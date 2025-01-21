import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AWSServices {
  final userPool = CognitoUserPool('eu-central-1_7QWCMoxQB', '56jim6pepm0s7g852hkn6soij2');

  Future<String?> signIn(email, password) async {
    debugPrint('Authenticating User...');
    final cognitoUser = CognitoUser(email, userPool);
    final authDetails = AuthenticationDetails(username: email, password: password);

    CognitoUserSession? session;
    try{
      //effettua il Login dell'utente
      session = await cognitoUser.authenticateUser(authDetails);
      debugPrint('Login Success...');

      //recupera il token dell'utente
      final idToken = session?.idToken.jwtToken;

      //salva il token in memoria
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userToken', idToken!);

      //decodifica il token
      Map<String, dynamic> payload = JwtDecoder.decode(idToken);

      //recupera il gruppo dell'utente
      List<dynamic>? groups = payload['cognito:groups'];
      debugPrint('User groups: $groups');
      return groups?.first;
      
    } on CognitoUserNewPasswordRequiredException catch (e) {
      debugPrint('CognitoUserNewPasswordRequiredException $e');
      return 'error';
    } on CognitoUserMfaRequiredException catch (e) {
      debugPrint('CognitoUserMfaRequiredException $e');
      return 'error';
    } on CognitoUserSelectMfaTypeException catch (e) {
      debugPrint('CognitoUserSelectMfaTypeException $e');
      return 'error';
    } on CognitoUserMfaSetupException catch (e) {
      debugPrint('CognitoUserMfaSetupException $e');
      return 'error';
    } on CognitoUserTotpRequiredException catch (e) {
      debugPrint('CognitoUserTotpRequiredException $e');
      return 'error';
    } on CognitoUserEmailOtpRequiredException catch (e) {
      debugPrint('CognitoUserEmailOtpRequiredException $e');
      return 'error';
    } on CognitoUserCustomChallengeException catch (e) {
      debugPrint('CognitoUserCustomChallengeException $e');
      return 'error';
    } on CognitoUserConfirmationNecessaryException catch (e) {
      debugPrint('CognitoUserConfirmationNecessaryException $e');
      return 'error';
    } on CognitoClientException catch (e) {
      debugPrint('CognitoClientException $e');
      return 'error';
    }catch (e) {
      print(e);
      return 'error';
    }
  }

  Future<bool> register(name, surname, email, password) async{
    debugPrint('Registering User...');
    final userAttributes = [
      AttributeArg(name: 'name', value: name),
      AttributeArg(name: 'family_name', value: surname),
    ];

    var data;
    try {
      data = await userPool.signUp(email, password, userAttributes: userAttributes);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future signOut() async{
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('userToken');

    //decodifica il token
    Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

    //recupera la mail
    dynamic email = payload['email'];

    //effettua il logout dell'utente (rende i token non validi)
    final cognitoUser = CognitoUser(email, userPool);
    await cognitoUser.signOut();

    //pulisce il token dalla memoria del sistema
    await prefs.remove('userToken');
  }

  Future<bool> startPasswordDimenticataProcedure(email) async{
    final cognitoUser = CognitoUser(email, userPool);

    //invia codice recupero per email
    var data;
    bool isAllOk = false;
    try {
      data = await cognitoUser.forgotPassword();
      print('Code sent to $data');
      isAllOk = true;
      // return true;
    } catch (e) {
      print(e);
      // return false;
    }
    return isAllOk;
  }

  Future<bool> endPasswordDimenticataProcedure(email, codice, newPassword) async {
    final cognitoUser = CognitoUser(email, userPool);

    //imposta nuova password
    bool passwordConfirmed = false;
    try {
      passwordConfirmed = await cognitoUser.confirmPassword(codice, newPassword);
      print(passwordConfirmed);
    } catch (e) {
      print(e);
    }
    
    return passwordConfirmed;
  }

  Future<String> recuperaEmailUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('userToken');

    //decodifica il token
    Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

    //recupera la mail
    String email = payload['email'];
    return email;
  }

  Future<String> recuperaNomeUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('userToken');

    //decodifica il token
    Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

    //recupera la mail
    String nome = payload['name'];
    return nome;
  }

  Future<String> recuperaCognomeUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('userToken');

    //decodifica il token
    Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

    //recupera la mail
    String cognome = payload['family_name'];
    return cognome;
  }

  Future<void> socialSignIn() async {
  try {
    final result = await Amplify.Auth.signInWithWebUI(
      provider: AuthProvider.google,
    );
    safePrint('Sign in result: $result');
  } on AuthException catch (e) {
    safePrint('Error signing in: ${e.message}');
  }
}
}