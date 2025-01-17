import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get carUrl => dotenv.env['CAR_URL'] ?? '';
  static String get clientUrl => dotenv.env['CLIENT_URL'] ?? '';
  static String get driverUrl => dotenv.env['DRIVER_URL'] ?? '';
  static String get agentUrl => dotenv.env['AGENT_URL'] ?? '';
}
