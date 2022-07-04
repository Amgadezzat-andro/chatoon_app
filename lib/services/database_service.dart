//packages
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseService() {}

  Future<void> createUser(
      String _uid, String _email, String _name, String _imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set(
        {
          'email': _email,
          'image': _imageURL,
          'last_active': DateTime.now().toUtc(),
          'name': _name,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // return user
  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  // update last active by passing uid
  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update(
        {
          'last_active': DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // return stream of chats Documents specific  for chat user depends on members
  // Chats -> Documents where members = UID 😊
  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: _uid)
        .snapshots();
  }

  // return future which one time in the future , it gets chat id
  // get the last message for every user
  Future<QuerySnapshot> getLastMessageForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }




}
