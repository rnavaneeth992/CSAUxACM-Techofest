import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Firebase Provider
import '../../common/core/firebase_constants.dart';
import '../../common/providers/firebase_providers.dart';

//Typedefs
import '../../common/typedef.dart';

//Failure Class
import '../../common/failure.dart';

//Models
import '../../models/team_model.dart';

//Auth Provider
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: ref.watch(authProvider),
    firestore: ref.watch(firestoreProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  //Team Collection
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.teamCollection);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Stream<Team> getTeamData(String uid) {
    return _users.doc(uid).snapshots().map(
          (snapshot) => Team.fromMap(
            snapshot.data() as Map<String, dynamic>,
          ),
        );
  }

  FutureEither<Team> signUpWithEmail({
    required String email,
    required String password,
    required String teamName,
    required String leaderId,
    required String leaderName,
    required String leaderPhone,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      Team team = Team(
        id: userCredential.user!.uid,
        leaderEmail: userCredential.user!.email!,
        teamName: teamName,
        leaderName: leaderName,
        leaderId: leaderId,
        leaderPhone: leaderPhone,
        clueList: 1,
      );
      await _users.doc(userCredential.user!.uid).set(team.toMap());
      return right(team);
    } on FirebaseAuthException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(Failure(err.toString()));
    }
  }

  FutureEither<Team> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      Team team = await getTeamData(userCredential.user!.uid).first;
      return right(team);
    } on FirebaseAuthException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(Failure(err.toString()));
    }
  }

  void signOut() async {
    await _auth.signOut();
  }
}
