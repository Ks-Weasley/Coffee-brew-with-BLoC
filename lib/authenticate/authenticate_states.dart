import 'package:coffeebrewbloc/authenticate/database.dart';

class AuthenticationStates{}

class Initial extends AuthenticationStates{}

class Loading extends AuthenticationStates{}

class Authenticated extends AuthenticationStates{
  Authenticated({this.brew});

  final Database brew;

}

class Unauthenticated extends AuthenticationStates{
  Unauthenticated(this.error);

  final String error;

}

class LogIn extends AuthenticationStates{}

class Register extends AuthenticationStates{}

class SentEmailVerificationLink extends AuthenticationStates{}

