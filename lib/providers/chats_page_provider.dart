// ignore_for_file: avoid_print

import 'dart:async';

//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Services
import '../services/database_service.dart';
import '../providers/authentication_provider.dart';

//Models
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../models/chat_user.dart';

class initialize extends ChangeNotifier {
  // Define Authentication Provider To Get it from chat page
  AuthenticationProvider _authenticationProvider;

  // initialize database service
  late DatabaseService _db;

  // list of chats
  List<Chat>? chats;

  // initialize new stream reference
  late StreamSubscription _chatsStream;

  // constructor get the auth provider and have function
  initialize(this._authenticationProvider) {
    // assign database service from get it
    _db = GetIt.instance.get<DatabaseService>();

    // then Apply this function
    getChats();
  }

  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      // listening to stream will return streams of snapshots of user chats
      _chatsStream =
          _db.getChatsForUser(_authenticationProvider.user.uid).listen(
        (_snapshot) async {
          // run multiple futures->future.wait(list of futures)
          chats = await Future.wait(
            // snap show will return as Collection but it contains documents so 
            // it goes like from Collection -> documents = snapshot.docs
            _snapshot.docs.map(
              // map every document
              (_doc) async {
                // cast doc data as Map<string,dynamic>
                // return doc data as json data
                Map<String, dynamic> _chatData =
                    _doc.data() as Map<String, dynamic>;

                //define an empty list of users
                List<ChatUser> _members = [];


                // loop through all docs thats holds chats for the auth User
                // loop through members and add it in members list
                for (var _uid in _chatData["members"]) {
                  DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
                  Map<String, dynamic> _userData =
                      _userSnapshot.data() as Map<String, dynamic>;
                  _userData["uid"] = _userSnapshot.id;
                  _members.add(
                    ChatUser.fromJSON(_userData),
                  );
                }
                //Get Last Messages this chat
                List<ChatMessage> _messages = [];
                // get the last message for each user as collection
                QuerySnapshot _chatMessage =
                    await _db.getLastMessageForChat(_doc.id);
              // so it goes like collection -> document
                if (_chatMessage.docs.isNotEmpty) {
                  Map<String, dynamic> _messageData =
                      _chatMessage.docs.first.data()! as Map<String, dynamic>;
                  ChatMessage _message = ChatMessage.fromJSON(_messageData);
                  _messages.add(_message);
                }
                //Return Chat Instance
                return Chat(
                  uid: _doc.id,
                  currentUserUid: _authenticationProvider.user.uid,
                  members: _members,
                  messages: _messages,
                  activity: _chatData["is_activity"],
                  group: _chatData["is_group"],
                );
              },
            ).toList(),
          );
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting chats.");
      print(e);
    }
  }
}
