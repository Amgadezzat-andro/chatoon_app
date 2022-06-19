//Packages
import 'package:chatoon_app/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

//Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

//models
import '../models/chat_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  // define firebase auth
  late final FirebaseAuth _auth;
  // define services (navigation service and database service)
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;
  // define user
  late ChatUser user;

  // in the constructor
  AuthenticationProvider() {
    //a assign the instance
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    //_auth.signOut();
    // whenever happens change in auth instance listen and expect user
    _auth.authStateChanges().listen(
      (_user) {
        // if there is user logged in already
        if (_user != null) {
          // update user last seen
          _databaseService.updateUserLastSeenTime(_user.uid);
          // get the user'uid from  assigned to instance of auth
          // _user from listen function it has only uid ((for now))
          //the get user function takes string and return json
          _databaseService.getUser(_user.uid).then(
            // get json as snapshot
            (_snapShot) {
              // define json as userData
              Map<String, dynamic> _userData =
                  _snapShot.data()! as Map<String, dynamic>;
              // convert json to model and fill data
              user = ChatUser.fromJSON(
                {
                  'uid': _user.uid,
                  'name': _userData['name'],
                  'email': _userData['email'],
                  'last_active': _userData['last_active'],
                  'image': _userData['image'],
                },
              );
              // go to homepage
              _navigationService.removeAndNavigateToRoute('/home');
              //print(user.toMap());
            },
          );
        }
        // if there is no user or no authenticated
        else {
          // go to login page
          _navigationService.removeAndNavigateToRoute('/login');
          // print('not aututinacted');
        }
      },
    );
  }

  Future<void> loginUsingEmailAndPassword(
      String _email, String _passwrod) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _passwrod);
      print(_auth.currentUser);
    } on FirebaseAuthException {
      print("Error Logging user into Firebase");
    } catch (e) {
      print(e);
    }
  }
}
