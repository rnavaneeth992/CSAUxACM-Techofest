import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

//Models
import '../../models/team_model.dart';

//Repository
import '../repository/auth_repository.dart';

//Utils
import '../../common/utils.dart';

final teamProvider = StateProvider<Team?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangesProvider = StreamProvider<User?>(
  (ref) => ref.watch(authControllerProvider.notifier).authStateChanges,
);

final getTeamDataProvider = StreamProvider.family(
  (ref, String uid) =>
      ref.watch(authControllerProvider.notifier).getTeamData(uid),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false); //Loading State

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  Stream<Team> getTeamData(String uid) => _authRepository.getTeamData(uid);

  //Sign Out
  void signOut({required BuildContext context}) async {
    _authRepository.signOut();
    Routemaster.of(context).pop();
  }

  //Email Sign Up
  void signUpWithEmail({
    required BuildContext context,
    required String email,
    required String password,
    required String teamName,
    required String leaderName,
    required String leaderId,
    required String leaderPhone,
  }) async {
    state = true;
    final user = await _authRepository.signUpWithEmail(
      email: email,
      password: password,
      teamName: teamName,
      leaderName: leaderName,
      leaderId: leaderId,
      leaderPhone: leaderPhone,
    );
    state = false;
    user.fold(
      (err) {
        showSnackBar(context, err.message);
      },
      (userModel) {
        _ref.read(teamProvider.notifier).update(
              (state) => userModel,
            );
      },
    );
  }

  //Email Sign In
  void signInWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final user = await _authRepository.signInWithEmail(
      email: email,
      password: password,
    );
    state = false;
    user.fold(
      (err) {
        showSnackBar(context, err.message);
      },
      (userModel) {
        _ref.read(teamProvider.notifier).update(
              (state) => userModel,
            );
        Routemaster.of(context).replace('/');
      },
    );
  }
}
