import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
      Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

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

  Future register(name, surname, email, password) async{
    debugPrint('Registering User...');
    final userAttributes = [
      AttributeArg(name: 'name', value: name),
      AttributeArg(name: 'family_name', value: surname),
    ];

    var data;
    try {
      data = await userPool.signUp(email, password, userAttributes: userAttributes);
    } catch (e) {
      print(e);
    }
  }
}