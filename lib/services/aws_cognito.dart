import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';

class AWSServices {
  final userPool = CognitoUserPool('eu-central-1_7QWCMoxQB', '56jim6pepm0s7g852hkn6soij2');

  Future signIn(email, password) async {
    debugPrint('Authenticating User...');
    final cognitoUser = CognitoUser(email, userPool);
    final authDetails = AuthenticationDetails(username: email, password: password);

    CognitoUserSession? session;
    try{
      session = await cognitoUser.authenticateUser(authDetails);
      debugPrint('Login Success...');
    } on CognitoUserNewPasswordRequiredException catch (e) {
      debugPrint('CognitoUserNewPasswordRequiredException $e');
    } on CognitoUserMfaRequiredException catch (e) {
      debugPrint('CognitoUserMfaRequiredException $e');
    } on CognitoUserSelectMfaTypeException catch (e) {
      debugPrint('CognitoUserSelectMfaTypeException $e');
    } on CognitoUserMfaSetupException catch (e) {
      debugPrint('CognitoUserMfaSetupException $e');
    } on CognitoUserTotpRequiredException catch (e) {
      debugPrint('CognitoUserTotpRequiredException $e');
    } on CognitoUserEmailOtpRequiredException catch (e) {
      debugPrint('CognitoUserEmailOtpRequiredException $e');
    } on CognitoUserCustomChallengeException catch (e) {
      debugPrint('CognitoUserCustomChallengeException $e');
    } on CognitoUserConfirmationNecessaryException catch (e) {
      debugPrint('CognitoUserConfirmationNecessaryException $e');
    } on CognitoClientException catch (e) {
      debugPrint('CognitoClientException $e');
    }catch (e) {
      print(e);
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