import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  MediaService() {}
  Future<File?> pickImageFromLibrary() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      // return _result.files[0];
      // print(_result.files.first.name);
      // print(_result.files.first.bytes);
      // print(_result.files.first.size);
      // print(_result.files.first.extension);
      // print(_result.files.first.path);

      // if you return now it will return path in cache (not working)
      PlatformFile file = result.files.first;
      //print(result.files.first.path);
      final newFile = await saveFilePermanently(file);
      //print(newFile.path);

      return newFile;
    }
    return null;
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File("${appStorage.path}/${file.name}");
    return File(file.path!).copy(newFile.path);
  }

}
