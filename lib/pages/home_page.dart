// ignore_for_file: prefer_const_constructors

//Packages
import 'package:flutter/material.dart';

//pages
import '../pages/chats_page.dart';
import '../pages/users_page.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  //final because it wont change
  final List<Widget> _pages = [
    //0
    ChatPage(),
    //1
    UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(
            label: 'Chats',
            icon: Icon(Icons.chat_bubble_sharp),
          ),
          BottomNavigationBarItem(
            label: 'Users',
            icon: Icon(Icons.supervised_user_circle_sharp),
          ),
        ],
      ),
    );
  }
}
