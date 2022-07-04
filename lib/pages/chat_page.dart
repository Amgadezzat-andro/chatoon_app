//Packages
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
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold();
  }
}
