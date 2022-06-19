// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//pages
import './pages/splash_page.dart';
import './pages/login_page.dart';
//services
import 'services/navigation_service.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onIntializationComplete: () {
        runApp(
          MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  // const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatoon',
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
        scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
        ),
      ),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext _context) => LoginPage(),
      },
    );
  }
}
