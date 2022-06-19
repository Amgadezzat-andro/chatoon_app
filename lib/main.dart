import 'package:flutter/material.dart';
//pages
import './pages/splash_page.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onIntializationComplete: () {},
    ),
  );
}
