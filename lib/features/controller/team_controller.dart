import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

//Repository
import '../controller/auth_controller.dart';
import '../repository/team_repository.dart';

//Utils
import '../../common/utils.dart';

final teamControllerProvider = StateNotifierProvider<TeamController, bool>(
  (ref) => TeamController(
    teamRepository: ref.watch(teamRepositoryProvider),
    ref: ref,
  ),
);

class TeamController extends StateNotifier<bool> {
  final TeamRepository _teamRepository;
  final Ref _ref;
  TeamController({
    required TeamRepository teamRepository,
    required Ref ref,
  })  : _teamRepository = teamRepository,
        _ref = ref,
        super(false); //Loading State

  Future<void> startTreasureHunt({
    required BuildContext context,
  }) async {
    state = true;
    var team = _ref.watch(teamProvider)!;
    team = team.copyWith(startTime: DateTime.now());
    final result = await _teamRepository.startTreasureHunt(team: team);
    state = false;
    result.fold(
      (failure) => showSnackBar(
        context,
        failure.toString(),
      ),
      (team) {
        Routemaster.of(context).push('/');
      },
    );
  }

  Future<void> completedTreasureHunt({
    required BuildContext context,
  }) async {
    state = true;
    var team = _ref.watch(teamProvider)!;
    team = team.copyWith(endTime: DateTime.now());
    final result = await _teamRepository.completedTreasureHunt(team: team);
    state = false;
    result.fold(
      (failure) => showSnackBar(
        context,
        failure.toString(),
      ),
      (team) {
        Routemaster.of(context).push('/');
      },
    );
  }

  Future<void> updateClueTiming({
    required BuildContext context,
    required DateTime startTime,
    required DateTime endTime,
    required String timeTaken,
  }) async {
    state = true;
    var team = _ref.watch(teamProvider)!;
    final timings = team.timings ?? [];
    timings.add({
      'startTime': startTime,
      'endTime': endTime,
    });
    team = team.copyWith(timings: timings);
    final result = await _teamRepository.updateClueTiming(team: team);
    state = false;
    result.fold(
      (failure) => showSnackBar(
        context,
        failure.toString(),
      ),
      (team) {
        Routemaster.of(context).push('/');
      },
    );
  }

  Future<void> updateHintCount({
    required BuildContext context,
  }) async {
    state = true;
    var team = _ref.watch(teamProvider)!;
    team = team.copyWith(hintCount: team.hintCount + 1);
    final result = await _teamRepository.updateHintCount(team: team);
    state = false;
    result.fold(
      (failure) => showSnackBar(
        context,
        failure.toString(),
      ),
      (team) {
        Routemaster.of(context).push('/');
      },
    );
  }

  Future<void> updateWrongClueCount({
    required BuildContext context,
  }) async {
    state = true;
    var team = _ref.watch(teamProvider)!;
    team = team.copyWith(wrongClueCount: team.wrongClueCount + 1);
    final result = await _teamRepository.updateWrongClueCount(team: team);
    state = false;
    result.fold(
      (failure) => showSnackBar(
        context,
        failure.toString(),
      ),
      (team) {
        Routemaster.of(context).push('/');
      },
    );
  }
}
