import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeyProvider {
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  static Future<void> initializeDotEnv() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
  }
}