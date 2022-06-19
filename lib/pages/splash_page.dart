// ignore_for_file: prefer_const_constructors

import 'package:chatoon_app/firebase_options.dart';
import 'package:flutter/material.dart';

//Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

//Services
import '../services/navigation_service.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onIntializationComplete;

  const SplashPage({
    required Key key,
    required this.onIntializationComplete,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // do setup then make another function
    _setup().then(
      (_) => widget.onIntializationComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatoon',
      theme: ThemeData(
        backgroundColor: Color(0xffff5f5f5),
        scaffoldBackgroundColor: Color(0xffff5f5f5),
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // before everything in init state of the splash screen
  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    //initialize firebase
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    // register services
    _registerServices();
  }


  // register services through all application using GETIT PACKAGE
  void _registerServices() {
    //register navigation service
    GetIt.instance.registerSingleton<NavigationService>(
      NavigationService(),
    );
  }
}
