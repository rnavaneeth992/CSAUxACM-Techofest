import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../../common/colours.dart';
import '../../common/constants.dart';
import '../../common/utils.dart';
import '../../common/widgets/animated_timer.dart';
import '../../common/widgets/clue_tile.dart';
import '../../common/widgets/custom_appbar.dart';
import '../../common/widgets/instructions.dart';
import '../../common/widgets/live_timer.dart';
import '../../common/widgets/loader.dart';
import '../../common/widgets/round_button.dart';

import '../controller/auth_controller.dart';
import '../controller/team_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late SharedPreferences prefs;
  bool prefsLoaded = false,
      hasSolved = false,
      hasWon = false,
      revealTimeReached = false,
      isRevealed = false;
  int clueNumber = 0;
  late DateTime clueStartTime;

  void updateHintCount() {
    ref.read(teamControllerProvider.notifier).updateHintCount(
          context: context,
        );
  }

  void updateWrongClueCount() {
    ref.read(teamControllerProvider.notifier).updateWrongClueCount(
          context: context,
        );
  }

  void updateClueTiming({
    required DateTime startTime,
    required DateTime endTime,
  }) {
    ref.read(teamControllerProvider.notifier).updateClueTiming(
          context: context,
          startTime: startTime,
          endTime: endTime,
          timeTaken: formatTimeTaken(startTime, endTime),
        );
  }

  void startTreasureHunt() {
    clueStartTime = DateTime.now();
    ref.read(teamControllerProvider.notifier).startTreasureHunt(
          context: context,
        );
    Fluttertoast.showToast(
      msg: "Treasure Hunt has begun!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: TColor.primaryColor2,
      textColor: TColor.white,
      fontSize: 14.0,
    );
    savePrefs();
  }

  void scanQRCode() async {
    String scanRes = await FlutterBarcodeScanner.scanBarcode(
        '#000000', "Cancel Scan", true, ScanMode.QR);
    if (scanRes == Constants.clues[clueNumber]['id'].toString()) {
      Fluttertoast.showToast(
        msg: "Clue Number ${clueNumber + 1} Solved!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: TColor.primaryColor2,
        textColor: TColor.white,
        fontSize: 14.0,
      );
      updateClueTiming(
        startTime: clueStartTime,
        endTime: DateTime.now(),
      );
      setState(() {
        hasSolved = true;
        prefs.setBool('hasSolved', hasSolved);
      });
      Vibration.vibrate(duration: 200);
    } else {
      updateWrongClueCount();
      Fluttertoast.showToast(
        msg: "Wrong QR Code!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: TColor.secondaryColor2,
        textColor: TColor.white,
        fontSize: 14.0,
      );

      Vibration.vibrate(duration: 500);
    }
  }

  void nextClue() {
    setState(() {
      if (clueNumber != 4) {
        revealTimeReached = false;
        isRevealed = false;
        clueStartTime = DateTime.now();
        clueNumber++;
        prefs.setInt('clueNumber', clueNumber);
        prefs.setString('clueStartTime', clueStartTime.toString());
      } else {
        hasWon = true;
        prefs.setBool('hasWon', hasWon);
        completedTreasureHunt();
      }
      hasSolved = false;
    });
    savePrefs();
  }

  void completedTreasureHunt() {
    Fluttertoast.showToast(
      msg: "Congratulations! You have completed the Treasure Hunt!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: TColor.primaryColor2,
      textColor: TColor.white,
      fontSize: 14.0,
    );
    ref.read(teamControllerProvider.notifier).completedTreasureHunt(
          context: context,
        );
  }

  void revealClue(BuildContext context) {
    Widget okButton = TextButton(
        child: const Text("CLOSE"),
        onPressed: () {
          updateHintCount();
          setState(() {
            isRevealed = true;
          });
          Routemaster.of(context).pop();
        });

    AlertDialog alert = AlertDialog(
      title: const Text("Reveal Location"),
      content: Text(
        "Location:\n${Constants.clues[clueNumber]['solution']}",
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> readPrefs() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getInt('clueNumber') == null) {
      setState(() {
        prefsLoaded = true;
      });
    } else {
      setState(() {
        clueNumber = prefs.getInt('clueNumber')!;
        hasWon = prefs.getBool('hasWon')!;
        hasSolved = prefs.getBool('hasSolved')!;
        clueStartTime = DateTime.parse(prefs.getString('clueStartTime')!);
        prefsLoaded = true;
      });
    }
  }

  Future<void> savePrefs() async {
    prefs.setInt('clueNumber', clueNumber);
    prefs.setBool('hasSolved', hasSolved);
    prefs.setBool('hasWon', hasWon);
    prefs.setString('clueStartTime', clueStartTime.toString());
  }

  @override
  void initState() {
    super.initState();
    readPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final team = ref.watch(teamProvider)!;
    final isLoading = ref.watch(teamControllerProvider);
    var media = MediaQuery.of(context).size;
    return SafeArea(
      child: !prefsLoaded
          ? const Loader(message: "Fetching Team Data...")
          : isLoading
              ? const Loader(message: "Fetching Team Data...")
              : Scaffold(
                  appBar: const PreferredSize(
                    preferredSize: Size.fromHeight(75),
                    child: CustomAppBar(),
                  ),
                  backgroundColor: TColor.white,
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 20.0,
                      ),
                      child: team.startTime == null
                          ? Instructions(startTreasureHunt: startTreasureHunt)
                          : hasWon
                              ? Column(
                                  children: [
                                    Container(
                                      width: double.maxFinite,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF91E7E7),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: TColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            width: 50,
                                            height: 50,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              Constants.completed,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Congratulations!",
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "You have completed the Treasure Hunt!",
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Container(
                                      width: double.maxFinite,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: TColor.primaryColor2,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: TColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            width: 50,
                                            height: 50,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              Constants.time,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Start Time:",
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  dateToString(
                                                    team.startTime!,
                                                  ),
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 12.0),
                                                Text(
                                                  "End Time:",
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  dateToString(
                                                    team.endTime!,
                                                  ),
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 12.0),
                                                Text(
                                                  "Time Taken:",
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  formatTimeTaken(
                                                    team.startTime!,
                                                    team.endTime!,
                                                  ),
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: media.width * 0.22,
                                          width: media.width * 0.45,
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: const Color(0xffFFE5E5),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: TColor.white,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                width: 50,
                                                height: 50,
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  Constants.welcome,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Hunt has begun!",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Text(
                                                        "Welcome, ${team.teamName}!",
                                                        style: TextStyle(
                                                          color: TColor.black,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: media.width * 0.22,
                                          width: media.width * 0.45,
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE8FFE5),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: TColor.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                width: 50,
                                                height: 50,
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  Constants.time,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Live Timer",
                                                      style: TextStyle(
                                                        color: TColor
                                                            .primaryColor2,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    LiveTimer(
                                                      startTime:
                                                          team.startTime!,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    ClueTile(
                                      clueNumber: clueNumber,
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    if (hasSolved)
                                      RoundButton(
                                        title: clueNumber == 4
                                            ? "Done..."
                                            : "Next Clue",
                                        onPressed: () => nextClue(),
                                      )
                                    else ...[
                                      AnimatedTimer(
                                        startDate: clueStartTime,
                                        endDate: clueStartTime
                                            .add(const Duration(minutes: 20)),
                                        onTimerFinished: (bool isFinished) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Clue ${clueNumber + 1} Solution Reveal Time Reached!",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                TColor.primaryColor2,
                                            textColor: TColor.white,
                                            fontSize: 14.0,
                                          );
                                          setState(() {
                                            revealTimeReached = isFinished;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      revealTimeReached
                                          ? RoundButton(
                                              title: "Reveal Location",
                                              onPressed: !isRevealed
                                                  ? () => revealClue(context)
                                                  : () {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Hint can be revealed only once!",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: TColor
                                                            .primaryColor2,
                                                        textColor: TColor.white,
                                                        fontSize: 14.0,
                                                      );
                                                    },
                                            )
                                          : Container(),
                                    ],
                                  ],
                                ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: !hasWon ? scanQRCode : null,
                    tooltip: 'Scan QR Code',
                    backgroundColor: TColor.primaryColor2,
                    child: Icon(
                      Icons.qr_code_scanner,
                      color: TColor.white,
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                ),
    );
  }
}
