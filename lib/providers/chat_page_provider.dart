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
  late StreamSubscription _messagesStream;

  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  List<ChatMessage>? messages;
  String? _message;

  String get message {
    return message;
  }

  void set message(String _value) {
    _message = _value;
  }

  ChatPageProvider(
    this._chatId,
    this._authenticationProvider,
    this._messagesListViewController,
  ) {
    _databaseService = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _mediaService = GetIt.instance.get<MediaService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyBoardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      _messagesStream = _databaseService.streamMessagesForChat(_chatId).listen(
        (_snapShot) {
          List<ChatMessage> _messages = _snapShot.docs.map(
            (_message) {
              Map<String, dynamic> _messageData =
                  _message.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(_messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
          //Add Scroll to Bottom Call
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (_messagesListViewController.hasClients) {
                _messagesListViewController.jumpTo(
                  _messagesListViewController.position.maxScrollExtent,
                );
              }
            },
          );
        },
      );
    } catch (e) {
      print('Error Getting Messages');
      print(e);
    }
  }

  void listenToKeyBoardChanges() {
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen(
      (_event) {
        _databaseService.updateChatData(
          _chatId,
          {
            "is_activity": _event,
          },
        );
      },
    );
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        content: _message!,
        type: MessageType.TEXT,
        senderID: _authenticationProvider.user.uid,
        sentTime: DateTime.now(),
      );
      _databaseService.addMessageToChat(_chatId, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _mediaService.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadURL =
            await _cloudStorageService.saveChatImageToStorage(
          _chatId,
          _authenticationProvider.user.uid,
          _file,
        );
        ChatMessage _messageToSend = ChatMessage(
          content: _downloadURL!,
          type: MessageType.IMAGE,
          senderID: _authenticationProvider.user.uid,
          sentTime: DateTime.now(),
        );
        _databaseService.addMessageToChat(_chatId, _messageToSend);
      }
    } catch (e) {
      print('Error Sending Image Message');
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _databaseService.deleteChat(_chatId);
  }

  void goBack() {
    _navigationService.goBack();
  }
}
