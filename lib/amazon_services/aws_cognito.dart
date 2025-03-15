import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:domus_app/back_end_communication/class_services/utente_service.dart';
import 'package:domus_app/back_end_communication/dto/agenzia_immobiliare_dto.dart';
import 'package:domus_app/costants/costants.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AWSServices {
  final userPool = CognitoUserPool('eu-central-1_7QWCMoxQB', '56jim6pepm0s7g852hkn6soij2');
  final region =  'eu-central-1';

  static const LOGIN_CREDENZIALI = 'CREDENZIALI';
  static const LOGIN_GOOGLE = 'GOOGLE'; 
  static const SAVED_LOGIN_TYPE = 'tipoLogin';
  static const SAVED_USER_TOKEN = 'userToken';
  static const SAVED_NOME = 'nome';
  static const SAVED_COGNOME = 'cognome';
  static const SAVED_EMAIL = 'email';
  static const SAVED_SUB = 'sub';
  static const SAVED_GROUP = 'group';
  static const SAVED_EXPIRATION = 'exp';



  Future<bool> isUserLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    final String? tipoLogin = prefs.getString('tipoLogin');

    if(tipoLogin != null){
      if (tipoLogin == LOGIN_CREDENZIALI) {

        //controlla scadenza token credenziali
        final token = prefs.getString(SAVED_USER_TOKEN);

        //il token esiste e non è scaduto
        if (token != null && !JwtDecoder.isExpired(token)){
          return true;
        }

        return false;
      } else if (tipoLogin == LOGIN_GOOGLE){

        //controlla scadenza token google manuale
        final scadenza = prefs.getString('scadenza');
        if (scadenza != null){
          DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(int.parse(scadenza) * 1000);
          return DateTime.now().isBefore(expiryDate);
        }

        return false;
      }
    }

    return false;
  }

  Future<bool> isUserAdmin() async{
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    String? group = prefs.getString(SAVED_GROUP);
    debugPrint("gruppo dell'utente $group");

    if(group == TipoRuolo.ADMIN){
      return true;
    }

    return false;
  }

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

      //decodifica il token
      Map<String, dynamic> payload = JwtDecoder.decode(idToken!);
      debugPrint("Salvo le seguenti informazioni nelle shared preferences");
      debugPrint(LOGIN_CREDENZIALI);
      debugPrint(idToken);
      debugPrint(payload['name']);
      debugPrint(payload['family_name']);
      debugPrint(payload['email']);
      debugPrint(payload['sub']);
      debugPrint(payload['custom:group']);

      //salva le informazioni dell'utente in memoria
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('tipoLogin', LOGIN_CREDENZIALI);
      await prefs.setString('userToken', idToken);
      await prefs.setString('nome', payload['name']);
      await prefs.setString('cognome', payload['family_name']);
      await prefs.setString('email', payload['email']);
      await prefs.setString('sub', payload['sub']);
      await prefs.setString('group', payload['custom:group']);

      String? group = await recuperaGruppoUtenteLoggato();
      return group;
      
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

  Future<bool> register(name, surname, email, password, userGroup, AgenziaImmobiliareDto? agenziaImmobiliare) async{
    debugPrint('Registering User...');
    final userAttributes = [
      AttributeArg(name: 'name', value: name),
      AttributeArg(name: 'family_name', value: surname),
      AttributeArg(name: 'custom:group', value: userGroup),
    ];

    try {
      var data = await userPool.signUp(email, password, userAttributes: userAttributes);
      int statuscode = await UtenteService.creaUtente(data.userSub!, userGroup, name, surname, email, agenziaImmobiliare);
      safePrint("status code richiesta creazione utente: $statuscode");
      return true;
    } catch (e) {
      safePrint(e);
      return false;
    }
  }

  Future signOut() async{
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(SAVED_EMAIL);

    //effettua il logout dell'utente (rende i token non validi)
    final cognitoUser = CognitoUser(email, userPool);
    await cognitoUser.signOut();

    //pulisce il token dalla memoria del sistema
    await prefs.remove(SAVED_USER_TOKEN);
    await prefs.remove(SAVED_NOME);
    await prefs.remove(SAVED_COGNOME);
    await prefs.remove(SAVED_EMAIL);
    await prefs.remove(SAVED_SUB);
    await prefs.remove(SAVED_GROUP);
    await prefs.remove(SAVED_LOGIN_TYPE);
    await prefs.remove(SAVED_EXPIRATION);
  }

  Future<bool> startPasswordDimenticataProcedure(email) async{
    final cognitoUser = CognitoUser(email, userPool);

    //invia codice recupero per email
    var data;
    bool isAllOk = false;
    try {
      data = await cognitoUser.forgotPassword();
      safePrint('Code sent to $data');
      isAllOk = true;
      // return true;
    } catch (e) {
      safePrint(e);
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
      safePrint(passwordConfirmed);
    } catch (e) {
      safePrint(e);
    }
    
    return passwordConfirmed;
  }

  Future<String?> recuperaEmailUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(SAVED_EMAIL);

    return email;
  }

  Future<String?> recuperaNomeUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    String? nome = prefs.getString(SAVED_NOME);
    debugPrint("recupera nome utente loggato: $nome");

    return nome;
  }

  Future<String?> recuperaCognomeUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    String? cognome = prefs.getString(SAVED_COGNOME);
    debugPrint("recupera cognome utente loggato: $cognome");

    return cognome;
  }

  Future<String?> recuperaGruppoUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    String? gruppo = prefs.getString(SAVED_GROUP);
    debugPrint("recupera gruppo utente loggato: $gruppo");

    return gruppo;
  }

  Future<String?> recuperaSubUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    String? sub = prefs.getString(SAVED_SUB);
    debugPrint("recupera sub utente loggato: $sub");

    return sub;
  }

  Future<bool> cambiaPasswordUtenteLoggato(email, oldPassword, newPassword) async {
    final authDetails = AuthenticationDetails(username: email, password: oldPassword);
    bool passwordChanged = false;
    try {
      final cognitoUser = CognitoUser(email, userPool);
      await cognitoUser.authenticateUser(authDetails);
      passwordChanged = await cognitoUser.changePassword(
        oldPassword,
        newPassword,
      );
    } catch (e) {
      safePrint(e);
    }
    return passwordChanged;
  }

  Future<bool> eliminaUtenteLoggato(email, password) async {
    final authDetails = AuthenticationDetails(username: email, password: password);

    try {
      final cognitoUser = CognitoUser(email, userPool);
      await cognitoUser.authenticateUser(authDetails);
      await cognitoUser.deleteUser();
      safePrint("Utente eliminato con successo.");
      return true;
    } catch (e) {
      safePrint("Errore durante l'eliminazione dell'utente: $e");
    }
    return false;
}

  
  Future<bool> signInWithGoogle() async {
    bool isAllOk = false;
    try {
      final result = await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
      
      if (result.isSignedIn){
        
        try {
          final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
          final result = await cognitoPlugin.fetchAuthSession();

          final idToken = result.userPoolTokensResult.value.idToken;

          debugPrint("Salvo le seguenti informazioni nelle shared preferences");
          debugPrint(LOGIN_GOOGLE);
          debugPrint(idToken.name!);
          debugPrint(idToken.familyName!);
          debugPrint(idToken.email!);

          Map<String, dynamic> jsonMap = jsonDecode(idToken.toString());
          debugPrint(jsonMap['claims']['sub']);
          debugPrint(jsonMap['claims']['exp'].toString());
          
          debugPrint(TipoRuolo.CLIENTE);

          //salva le informazioni del token in memoria
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(SAVED_LOGIN_TYPE, LOGIN_GOOGLE);
          await prefs.setString(SAVED_NOME, idToken.name!);
          await prefs.setString(SAVED_COGNOME, idToken.familyName!);
          await prefs.setString(SAVED_EMAIL, idToken.email!);
          await prefs.setString(SAVED_SUB, jsonMap['claims']['sub']);
          await prefs.setString(SAVED_EXPIRATION, jsonMap['claims']['exp'].toString());
          await prefs.setString(SAVED_GROUP, TipoRuolo.CLIENTE);

          try {
            int statuscode = await UtenteService.creaUtente(jsonMap['claims']['sub'], TipoRuolo.CLIENTE, idToken.name!, idToken.familyName!, idToken.email!, null);
            safePrint("status code richiesta creazione utente: $statuscode");
            return true;
          } catch (e) {
            safePrint(e);
            return false;
          }

          
        } on AuthException catch (e) {
          safePrint('Error retrieving auth session: ${e.message}');
        }
          
        isAllOk = true;
      }
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
    }
    return isAllOk;
  }
}