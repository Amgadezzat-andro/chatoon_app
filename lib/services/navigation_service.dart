import 'package:flutter/material.dart';

class NavigationService {
  // it passed to know the current state
  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String _route) {
    //check if there is state or not and move to another routed state with deleting the old one
    navigatorKey.currentState?.popAndPushNamed(_route);
  }

  void navigateToRoute(String _route) {
    //check if null and push another state to screen
    navigatorKey.currentState?.pushNamed(_route);
  }

  void navigateToPage(Widget _page) {
    // to push widget on the screen
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (BuildContext _context) {
          return _page;
        },
      ),
    );
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
