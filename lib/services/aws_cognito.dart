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


  Future<bool> isUserLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    //il token esiste e non è scaduto
    if (token != null && !JwtDecoder.isExpired(token)){
      return true;
    }

    return false;
  }

  Future<bool> isUserAdmin() async{
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('userToken');

    //decodifica il token
    Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

    //recupera il gruppo dell'utente
    String? group = payload['custom:group'];
    debugPrint('User groups: $group');
    debugPrint('User is: ');
    debugPrint(group);

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

      //salva il token in memoria
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userToken', idToken!);

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
    final idToken = prefs.getString('userToken');

    //decodifica il token
    Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

    //recupera la mail
    String? email = payload['email'];
    return email;
  }

  Future<String?> recuperaNomeUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('userToken');

    //decodifica il token
    Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

    //recupera la mail
    String? nome = payload['name'];
    return nome;
  }

  Future<String?> recuperaCognomeUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('userToken');

    //decodifica il token
    Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

    //recupera la mail
    String? cognome = payload['family_name'];
    return cognome;
  }

  Future<String?> recuperaGruppoUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('userToken');

    //decodifica il token
    Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

    //recupera la mail
    String? gruppo = payload['custom:group'];
    return gruppo;
  }

  Future<String?> recuperaSubUtenteLoggato() async {
    //recupera il token dalla memoria
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('userToken');

    //decodifica il token
    Map<String, dynamic> payload = JwtDecoder.decode(idToken!);

    //recupera la mail
    String? sub = payload['sub'];
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
      safePrint('Result: $result');
      if (result.isSignedIn){
        // final CognitoAuthSession? result = await Amplify.Auth.getAuthSession();
        // final String? token = result?.userPoolTokensResult.value.accessToken.raw;
         try {
          final cognitoPlugin = 
              Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
          final result = await cognitoPlugin.fetchAuthSession();
          final accessToken = 
              result.userPoolTokensResult.value.accessToken.toJson();
          safePrint("Current user's access token: $accessToken");

          //salva il token in memoria
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userToken', accessToken);
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