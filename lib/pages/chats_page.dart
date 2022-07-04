//Packages
// ignore_for_file: prefer_const_constructors

import 'package:chatoon_app/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
//Services
import '../services/navigation_service.dart';
//Providers
import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';
//Pages
import '../pages/chat_page.dart';

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

//Models
import '../models/chat.dart';
import '../models/chat_user.dart';
import '../models/chat_message.dart';

class ChatsPage extends StatefulWidget {
  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _authenticationProvider;
  late initialize _chatPageProvider;
  late NavigationService _navigationService;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _navigationService = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<initialize>(
          create: (_) => initialize(_authenticationProvider),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: ((context) {
        // the same
        // _authenticationProvider = Provider.of<AuthenticationProvider>(context,listen:true);
        _chatPageProvider = context.watch<initialize>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Chats',
                primaryAction: IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                  onPressed: () {
                    _authenticationProvider.logOut();
                  },
                ),
              ),
              _chatsList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _chatsList() {
    List<Chat>? _chats = _chatPageProvider.chats;
    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.length != 0) {
            return ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (BuildContext _context, int _index) {
                return _chatTile(_chats[_index]);
              },
            );
          } else {
            return Center(
              child: Text(
                'No Chats Found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recepiants = _chat.recepients();
    bool _isActive = _recepiants.any((_d) => _d.wasRecentlyActive());
    String _subTitleText = "";
    if (_chat.messages.isNotEmpty) {
      _subTitleText = _chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : _chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      heigth: _deviceHeight * 0.10,
      title: _chat.title(),
      subtitle: _subTitleText,
      imagePath: _chat.imageURL(),
      isActive: _isActive,
      isActivity: _chat.activity,
      onTap: () {
        _navigationService.navigateToPage(
          ChatPage(chat: _chat),
        );
      },
    );
  }
}
