//Packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
//Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';
//Providers
import '../providers/authentication_provider.dart';
//Models
import '../models/chat_user.dart';
import '../models/chat.dart';
//Pages
import '../pages/chat_page.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _authenticationProvider;
  late DatabaseService _databaseService;
  late NavigationService _navigationService;
  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;
  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UsersPageProvider(this._authenticationProvider) {
    _selectedUsers = [];
    _databaseService = GetIt.instance.get<DatabaseService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    getUsers();
  }
  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      _databaseService.getUsers(name: name).then(
        (_snapShot) {
          users = _snapShot.docs.map(
            (_doc) {
              Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
              _data['uid'] = _doc.id;
              return ChatUser.fromJSON(_data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print('error getting users');
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }
}
