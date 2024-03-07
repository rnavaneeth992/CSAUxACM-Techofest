import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../constants.dart';
import './round_button.dart';

class Instructions extends StatelessWidget {
  const Instructions({super.key, required this.startTreasureHunt});

  final Function startTreasureHunt;

  void confirmStart(BuildContext context) {
    Widget yesButton = TextButton(
      child: const Text("YES"),
      onPressed: () {
        startTreasureHunt();
        Routemaster.of(context).pop();
      },
    );

    Widget noButton = TextButton(
      child: const Text("NO"),
      onPressed: () {
        Routemaster.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Start Treasure Hunt"),
          content: const Text(
              "Are you sure you have read the instructions and would like to begin the Treasure Hunt?"),
          actions: [yesButton, noButton],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          "Instructions",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
          child: Text(
            Constants.instructions,
          ),
        ),
        RoundButton(
          title: "Start Treasure Hunt",
          onPressed: () => confirmStart(context),
        ),
      ],
    );
  }
}
