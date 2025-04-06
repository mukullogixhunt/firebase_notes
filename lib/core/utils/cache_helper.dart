import 'dart:convert';

import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/user_model.dart';



class CacheHelper {
  const CacheHelper(this._prefs);

  final SharedPreferences _prefs;

  static const _userIdKey = 'user_id';
  static const _userKey = 'user';

  static const _fcmTokenKey = 'fcm-token';



  // Cache user ID
  Future<bool> cacheUserId(String userId) async {
    try {
      final result = await _prefs.setString(_userIdKey, userId);
      return result;
    } catch (_) {
      return false;
    }
  }

  // Cache user data
  Future<bool> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toMap());
      final result = await _prefs.setString(_userKey, userJson);
      return result;
    } catch (e) {
      log('Error caching user: $e');
      return false;
    }
  }



  // Cache fcm token
  Future<bool> cacheFcmToken(String token) async {
    try {
      final result = await _prefs.setString(_fcmTokenKey, token);
      return result;
    } catch (_) {
      return false;
    }
  }

  // Get  user ID
  String? getUserId() {
    final userId = _prefs.getString(_userIdKey);
    return userId;
  }

  // Get user data
  UserModel? getUser() {
    final userJson = _prefs.getString(_userKey);

    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      final user = UserModel.fromFirebase(userMap);
      return user;
    } else {
      log('getUser: User does not exist');
      return null;
    }
  }

  // Get  user ID
  String? getFcmToken() {
    final token = _prefs.getString(_fcmTokenKey);



    return token;
  }

  // Reset session
  Future<void> resetSession() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userKey);
    await _prefs.remove(_fcmTokenKey);
  }


}
