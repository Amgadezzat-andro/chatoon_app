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
    _navigationService=GetIt.instance.get<NavigationService>();
  }
  @override
  void dispose() {
    super.dispose();
  }
}
