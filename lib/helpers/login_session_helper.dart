import 'package:hive_flutter/hive_flutter.dart';

import '../models/login_session_model.dart';
import '../tools/consts.dart';

class LoginSessionHelper {
  static const String _ns = 'not_set';
  static Box get box => Hive.box(Consts.loginSession);

  static Future<void> createSession(LoginSessionModel loginSessionModel) async {
    await box.putAll(loginSessionModel.toJson());
    // await box.put(tableId, tableSettingsModel.toJson());
  }

  static LoginSessionModel readSession() {
    LoginSessionModel loginSessionModel = LoginSessionModel(
      email: box.get('email', defaultValue: _ns),
      loggedIn: box.get('loggedIn', defaultValue: false),
      createdAt: box.get('createdAt', defaultValue: _ns),
      updatedAt: box.get('updatedAt', defaultValue: _ns),
    );

    return loginSessionModel;
  }

  static Future<bool> updateSession({
    required bool loggedIn,
    required String updatedAt,
  }) async {
    LoginSessionModel previousSession = readSession();
    if (previousSession.email == _ns) return false;

    LoginSessionModel updatedSession = previousSession.copyWith(
      loggedIn: loggedIn,
      updatedAt: updatedAt,
    );

    return box.putAll(updatedSession.toJson()).then((value) {
      return true;
    });
  }

  static clearSession() {
    box.clear();
  }
}
