//Packages
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/custom_input_fields.dart';
//Models
import '../models/chat.dart';
import '../models/chat_message.dart';
//Providers
import '../providers/authentication_provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  ChatPage({required this.chat});

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeigth;
  late double _deviceWidth;
  late AuthenticationProvider _authenticationProvider;
  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  Widget build(BuildContext context) {
    _deviceHeigth = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeigth * 0.02,
          ),
          height: _deviceHeigth,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                this.widget.chat.title(),
                fontSize: 16,
                primaryAction: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 2, 2, 2),
                  ),
                ),
                secondaryAction: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 2, 2, 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
