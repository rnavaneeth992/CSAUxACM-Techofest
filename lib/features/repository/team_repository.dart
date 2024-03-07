import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Constants
import '../../common/core/firebase_constants.dart';

//Firebase Provider
import '../../common/providers/firebase_providers.dart';

//Typedefs
import '../../common/typedef.dart';

//Failure Class
import '../../common/failure.dart';

//Models
import '../../models/team_model.dart';

//Team Provider
final teamRepositoryProvider = Provider(
  (ref) => TeamRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);

class TeamRepository {
  final FirebaseFirestore _firestore;

  TeamRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  //Team Collection
  CollectionReference get _team =>
      _firestore.collection(FirebaseConstants.teamCollection);

  FutureEither<Team> startTreasureHunt({
    required Team team,
  }) async {
    try {
      await _team.doc(team.id).update(team.toMap());
      return right(team);
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }

  FutureEither<Team> completedTreasureHunt({
    required Team team,
  }) async {
    try {
      await _team.doc(team.id).update(team.toMap());
      return right(team);
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }

  FutureEither<Team> updateClueTiming({
    required Team team,
  }) async {
    try {
      await _team.doc(team.id).update(team.toMap());
      return right(team);
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }

  FutureEither<Team> updateHintCount({
    required Team team,
  }) async {
    try {
      await _team.doc(team.id).update(team.toMap());
      return right(team);
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }

  FutureEither<Team> updateWrongClueCount({
    required Team team,
  }) async {
    try {
      await _team.doc(team.id).update(team.toMap());
      return right(team);
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }
}
