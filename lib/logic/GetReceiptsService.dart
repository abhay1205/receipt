import 'dart:io';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:http/http.dart' as http;

class GetReceipts {
  String getMonth() {
    var month = DateFormat("MM-yyyy").format(DateTime.now());
    print(month);
    return month;
  }

  String delete(String email, dynamic docID) {
    print("entered del func");
    print(email);
    String res;
    Firestore.instance
        .collection('$email')
        .document(docID)
        .delete()
        .whenComplete((){
          print("deleted");
          res = "DEL";
        } )
        .catchError((e) {
          print("error");
          res =  "ERR";
        } );
    print(res);
    return res;
  }

  Future<void> download(String url) async {
    Dio dio = Dio();
    try {
      // File image;
      // var response = await http.get(url);

      // var filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
      // String BASE64_IMAGE = filePath;
      // print(filePath.toString());
      var dir = await getExternalStorageDirectory();
      await dio.download(url, "${dir.path}/myimage.jpg");
      var file = "${dir.path}/myimage.jpg";
      print("File path" + file.toString());
      // if (!await file.exists()) {
      // await file.create(recursive: true);
      // }
      share(file);
    } catch (e) {
      print(e);
    }
  }

  share(file) async {
    try {
      final ByteData bytes = await rootBundle.load(file.toString());
      await Share.file(
              'esys image', 'esys.jpg', bytes.buffer.asUint8List(), 'image/jpg')
          .whenComplete(() {
        print("done");
      });
      print("res");
    } catch (e) {
      print(e);
    }
  }
}
