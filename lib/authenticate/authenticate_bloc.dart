import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeebrewbloc/authenticate/authenticate_events.dart';
import 'package:coffeebrewbloc/authenticate/authenticate_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvents, AuthenticationStates> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  @override
  // TODO: implement initialState
  AuthenticationStates get initialState => Initial();

  @override
  Stream<AuthenticationStates> mapEventToState(
      AuthenticationEvents event) async* {
    // TODO: implement mapEventToState
    if (event is GetDeviceUser) {
      final AuthenticationStates _authenticationResults = await loggedInUser();
      yield _authenticationResults;
    }
    if (event is LogInEvent) {
      yield Loading();
      final AuthenticationStates result =
          await signInWithEmailAndPassword(event.email, event.password);
      yield result;
      if (result is Unauthenticated)
        yield LogIn();
    }
    if (event is RegisterEvent) {
      yield Loading();
      final AuthenticationStates result =
          await registerWithEmailAndPassword(event.email, event.password);
      yield result;
      if (result is Unauthenticated)
        yield Register();
    }

    if (event is Swap) {
      yield event.showLogIn ? LogIn() : Register();
    }
    if (event is Logout) {
      yield Loading();
      if (signOut() == null)
        yield Unauthenticated('Falied Signing out');
      else
        yield LogIn();
    }
  }

  //for getting initial device user if already logged in
  Future<AuthenticationStates> loggedInUser() async {
    final FirebaseUser firebaseUser = await _auth.currentUser();

    return firebaseUser == null
        ? LogIn()
        : Authenticated(
      uid: firebaseUser.uid,);
  }

//for anonymous entry for testing purposes
  Future<AuthenticationStates> signInAnonymously() async {
    try {
      final AuthResult result = await _auth.signInAnonymously();
      print('Sucess');
      print(result.user);
      return Authenticated(
        uid: result.user.uid,);
    } catch (e) {
      print(e.toString());
      return Unauthenticated(e.message);
    }
  }

  //Signing in using email and password
  Future<AuthenticationStates> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      print(result.user.toString());
      print('Sucess');
      return Authenticated(
        uid: result.user.uid,);
    } catch (e) {
      print(e.message);
      return Unauthenticated(e.message);
    }
  }

  Future<AuthenticationStates> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      result.user.sendEmailVerification();
      print('Sucess');
      print(result.user);
      await Database().updateUserData(result.user.uid, '0', 'new-crew-member', 100);
      return Authenticated(
        uid: result.user.uid,
      );
    } catch (e) {
      print(e.toString());
      return Unauthenticated(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Brew> getDocument(String uid) async{
    final Brew _brew = await brewCollection
        .document(uid)
        .get()
        .then((DocumentSnapshot doc) => Brew(
      name: doc.data['name'],
      sugars: doc.data['sugars'],
      strength: doc.data['strength'],
    ));
      return _brew;
  }
}
