import 'package:flutter/material.dart';

import '../api/login.dart';

class GlobalUser extends ChangeNotifier {
  User? _globalUser;
  User? get globalUser => _globalUser;
  set globalUser(User? user) {
    _globalUser = user;
    notifyListeners();
  }

  // Tries to load the user, the user will remain null if the user is not logged in
  // It may also throw an exception while requesting the user to the API
  Future<void> tryLoad() async {
    final user = await fetchUser();
    globalUser = user;
  }

  GlobalUser() {
    tryLoad();
  }
}
