import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recieptStore/models/reciept.dart';

class UploadReceipt{

   final String name;
   UploadReceipt({this.name});
   
   File file ;
   String fileName, photoURL = '', dateTime = '';
  final DocumentReference reference =
      Firestore.instance.document('test/reciept');
   
  Future openCamera() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
    fileName = basename(file.path);
    photoURL =  uploadImage(fileName, file).toString();
  }

  Future openGallery() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileName = basename(file.path);
    photoURL = uploadImage(fileName, file).toString();
  }

  Future<String> uploadImage(String fileName, File file) async {
    var downloadUrl;
      StorageReference _storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    _storageReference.putFile(file).onComplete.then((firebaseFile) async {
      downloadUrl = await firebaseFile.ref.getDownloadURL();
    });
    return downloadUrl.toString();
  }

  saveReciept() async {
    if (name.isNotEmpty && photoURL.isNotEmpty) {
      Reciept reciept = Reciept(
          receiptName: name,
          photoUrl: photoURL,
          dateTimeStamp: dateTime);
      reference
          .setData(reciept.toJson(), merge: true)
          .whenComplete(() {
            print('Document added');
          } )
          .catchError((e) {
        print(e);
      });
    }
  }
}