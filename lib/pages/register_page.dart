//Packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//Services
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/navigation_service.dart';

//Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_image.dart';

//Provider
import '../providers/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  //define screen vars
  late double _deviceHeight;
  late double _deviceWidth;

  //define authentication provider and database service and cloud storage service
  late AuthenticationProvider _authenticationProvider;
  late DatabaseService _databaseService;
  late CloudStorageService _cloudStorageService;

  // define file for profile image from library
  PlatformFile? _profileImage;

  // define form's Key
  final _registerFormKey = GlobalKey<FormState>();

  // define form vars
  String? _email;
  String? _password;
  String? _name;

  @override
  Widget build(BuildContext context) {
    // Assign Variables with it's needed code;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _databaseService = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageFiled(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _registerForm(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _registerButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileImageFiled() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
              (file) => {
                setState(
                  () {
                    _profileImage = file;
                  },
                )
              },
            );
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: _profileImage!,
            size: _deviceHeight * 0.154,
          );
        } else {
          return RoundedImageNetwork(
            key: UniqueKey(),
            imagePath: 'https://i.pravatar.cc/150?img=37',
            size: _deviceHeight * 0.154,
          );
        }
      }(),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _name = _value;
                });
              },
              regEx: r'.{8,}',
              hintText: "Name",
              obscuredText: false,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              regEx:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: "Email",
              obscuredText: false,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              regEx: r".{8,}",
              hintText: "Password",
              obscuredText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: 'Register',
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        // validate and make sure pic not null
        if (_registerFormKey.currentState!.validate() &&
            _profileImage != null) {
          // save after validation values email password name
          _registerFormKey.currentState!.save();
          // return uid after registering
          String? _uid = await _authenticationProvider
              .registerUserUsingEmailAndPassword(_email!, _password!);
          // return imageurl after putting it in storage bucket
          String? _imageURL = await _cloudStorageService.saveUserImageToStorage(
              _uid!, _profileImage!);
          // creating user in fire base docs with data required
          await _databaseService.createUser(_uid, _email!, _name!, _imageURL!);
          // log out to restart  provider work
          await _authenticationProvider.logOut();
          // login and restart provider function it will listen now and automatically log in
          await _authenticationProvider.loginUsingEmailAndPassword(
              _email!, _password!);
        }
      },
    );
  }
}
