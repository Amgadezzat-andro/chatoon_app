//Packages
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
//Providers
import '../providers/authentication_provider.dart';
import '../providers/users_page_provider.dart';
//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/rounded_button.dart';
//Models
import '../models/chat_user.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeigth;
  late double _deviceWidth;
  late AuthenticationProvider _authenticationProvider;
  late UsersPageProvider _pageProvider;
  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    _deviceHeigth = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_authenticationProvider),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<UsersPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeigth * 0.02,
        ),
        height: _deviceHeigth * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Users',
              primaryAction: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.logout,
                  color: Color.fromRGBO(0, 82, 218, 1.0),
                ),
              ),
            ),
            CustomTextField(
              onEditingComplete: (_value) {},
              hintText: 'Search...',
              obsecureText: false,
              controller: _searchFieldTextEditingController,
              icon: Icons.search,
            ),
            _usersList(),
          ],
        ),
      );
    });
  }

  Widget _usersList() {
    List<ChatUser>? _users = _pageProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.length != 0) {
          return ListView.builder(
            itemBuilder: (BuildContext _context, int _index) {
              return CustomListViewTile(
                height: _deviceHeigth * 0.10,
                title: _users[_index].name,
                subtitle: 'Last Active: ${_users[_index].lastDayActive()}',
                imagePath: _users[_index].imageUrL,
                isActive: _users[_index].wasRecentlyActive(),
                isSelected: _pageProvider.selectedUsers.contains(
                  _users[_index],
                ),
                onTap: () {
                  _pageProvider.updateSelectedUsers(_users[_index]);
                },
              );
            },
            itemCount: _users.length,
          );
        } else {
          return Center(
            child: Text(
              'No Users Found.',
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
    }());
  }
}
