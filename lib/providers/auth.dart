import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/models/http_Exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userID;
  bool _authenticated = false;
  Timer? timerToExpire;

  Future<void> _authenticate(String type, String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$type?key=[Add Your API]");
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      sessionExpire();
      final pref = await SharedPreferences.getInstance();
      final userInfo = json.encode({
        'userID': _userID,
        'sessionDuration': _expiryDate!.toIso8601String(),
        'token': _token
      });

      pref.setString('userData', userInfo);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> autoLoginAttempt() async {
    try {
      final pref = await SharedPreferences.getInstance();

      if (!pref.containsKey('userData')) {
        return false;
      }

      final extractedUserData = json.decode(pref.getString('userData')!);
      // print(extractedUserData);
      final sessionExpireDate =
          DateTime.parse(extractedUserData['sessionDuration']);

      if (DateTime.now().isAfter(sessionExpireDate)) {
        return false;
      }

      _userID = extractedUserData['userID'];
      _expiryDate = sessionExpireDate;
      _token = extractedUserData['token'];
    } catch (error) {
      print(error);

      return false;
    }
    print("hello");
    notifyListeners();
    sessionExpire();
    return true;
  }

  String? get userId {
    return _userID;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate('signUp', email, password);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate('signInWithPassword', email, password);
  }

  String? get token {
    if (_token != null && DateTime.now().isBefore(_expiryDate!)) {
      return _token!;
    }
    return null;
  }

  bool get isAuthenticated {
    return token != null;
  }

  void logout() async {
    _userID = null;
    _token = null;
    _expiryDate = null;
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    if (timerToExpire != null) timerToExpire!.cancel();

    notifyListeners();
  }

  void sessionExpire() {
    final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    if (timerToExpire != null) timerToExpire!.cancel();
    timerToExpire = Timer(Duration(seconds: timeToExpire), logout);
  }
}
