import 'dart:async';
//Packages
import 'package:chatoon_app/providers/authentication_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';
//Providers
import '../providers/chats_page_provider.dart';

//Models
import '../models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _databaseService;
  late CloudStorageService _cloudStorageService;
  late MediaService _mediaService;
  late NavigationService _navigationService;

  AuthenticationProvider _authenticationProvider;
  ScrollController _messagesListViewController;
  String _chatId;

  List<ChatMessage>? messages;
  String? _message;
  String get message {
    return message;
  }

  ChatPageProvider(this._chatId, this._authenticationProvider,
      this._messagesListViewController) {
    _databaseService = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _mediaService = GetIt.instance.get<MediaService>();
    _navigationService = GetIt.instance.get<NavigationService>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() {
    _navigationService.goBack();
  }
}
