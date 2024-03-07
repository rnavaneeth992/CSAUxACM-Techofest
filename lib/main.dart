import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import './firebase_options.dart';

import './common/widgets/loader.dart';
import './features/controller/auth_controller.dart';

import './router.dart';

import './common/colours.dart';

import './models/team_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: HuntOfWebWanderer(),
    ),
  );
}

class HuntOfWebWanderer extends ConsumerStatefulWidget {
  const HuntOfWebWanderer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HuntOfWebWandererState();
}

class _HuntOfWebWandererState extends ConsumerState<HuntOfWebWanderer> {
  Team? team;

  void getTeamData(User user) async {
    team = await ref
        .watch(authControllerProvider.notifier)
        .getTeamData(user.uid)
        .first;
    ref.read(teamProvider.notifier).update((state) => team);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
          data: (teamData) => MaterialApp.router(
            title: 'Hunt Of Web Wanderer',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: TColor.primaryColor1,
              fontFamily: "Poppins",
            ),
            routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
              if (teamData != null) {
                getTeamData(teamData);
                if (team != null) {
                  return loggedInRoutes;
                }
              }
              return loggedOutRoutes;
            }),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => const Scaffold(
            body: Center(
              child: Text("Error"),
            ),
          ),
          loading: () => const Loader(
            message: "Fetching Team Data...",
          ),
        );
  }
}
