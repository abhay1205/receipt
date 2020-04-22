import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recieptStore/models/reciept.dart';
import 'package:recieptStore/screens/SearchBar.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String name , photoURL , dateTimeStamp, fileName, month, email, downloadSize;
  File file;
  bool isUploaded;
  List<String> recentList = ['Reciept 9'];
  double screenHeight, screenWidth;
  Animation<Color> _progress = AlwaysStoppedAnimation(Colors.yellow);
  QuerySnapshot receipts;
  
  @override
  void initState() {
    getData().then((results){
      setState(() {
        receipts = results;
      });
    });
    getEmail();
    month = getMonth();
    name=''; photoURL=''; dateTimeStamp=''; fileName=''; file = null;
    super.initState();
  }

  // final DocumentReference reference =
  //     Firestore.instance.document('test/reciept');
  
  String getMonth(){
    var month = DateFormat("MM-yyyy").format(DateTime.now());
    print(month);
    return month;
  }

  void refreshScreen(){
    setState(() {
      name =''; photoURL = ''; dateTimeStamp = ''; fileName=''; file = null;
    });
  }
  void getEmail() async {
     FirebaseUser user = await FirebaseAuth.instance.currentUser();
     print(user.email);
     setState(() {
       email = user.email;
     });
  }

  String getDateTimeStamp(){
    var now = DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
    return now; 
  }

  getData() async{
    return await Firestore.instance.collection('$email').getDocuments();
  }

  bool checkDup (String name) {
    print('Entered the function');
    if(receipts.documents.length != null){
       print('Entered the if block');
       var flag =0;
       var res = receipts.documents.where((element) {
         if(element == name){
           flag = 1;
           return true;
         }
         else{
           flag =0;
           return false;
         }
       });
       print("result" + res.toString());
       print(flag.toString());
      

    }

  }
   
  Future openCamera() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
    fileName = name;
    print('added');
    uploadImage(fileName, file).toString();
  }

  Future openGallery() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileName = basename(file.path);
    uploadImage(fileName, file).toString();
    print('added');
  }

  Future<void> uploadImage(String fileName, File file) async {
      StorageReference _storageReference =
        FirebaseStorage.instance.ref().child(fileName);
        
        print(fileName.toString());
    _storageReference.putFile(file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      String dateTime = getDateTimeStamp();
     var imageSize =  _storageReference.getMetadata().then((StorageMetadata storageMetadata) =>storageMetadata.sizeBytes.toInt()/1000).toString();
      setState(() {
        photoURL = downloadUrl;
        dateTimeStamp = dateTime;
        downloadSize = imageSize;
      });
      print('Uploaded');
       _scaffoldKey.currentState.showSnackBar(
         SnackBar(
           backgroundColor: Colors.white,
           content: Text("Image Uploaded", style: TextStyle(color: Colors.orange),), 
           duration: Duration(seconds: 3),));
    });
  }

  saveReciept() async {
    
    if (name.isNotEmpty && photoURL.isNotEmpty) {
      Reciept reciept = Reciept(
          recieptName: name,
          photoUrl: photoURL,
          dateTimeStamp: dateTimeStamp,
          downloadSize: downloadSize);
      final CollectionReference collectionReference = Firestore.instance.collection('$email');
      collectionReference.add(reciept.toJson())
          .whenComplete(() {
            print('Document added');
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                backgroundColor: Colors.white,
                content: Row(
                  children: <Widget>[
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 10,),
                    Text("Receipt Added", style: TextStyle(color: Colors.orange),),
                  ],
                ), duration: Duration(seconds: 3),));
          } )
          .catchError((e) {
        print(e);
        _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                backgroundColor: Colors.white,
                content: Row(
                  children: <Widget>[
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 10,),
                    Text("Error", style: TextStyle(color: Colors.orange),),
                  ],
                ), duration: Duration(seconds: 3),));
      });
    }
  }

  // WIDGETS


  // RECEIPT FORM

  Widget _addRecieptForm() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.orange, borderRadius: BorderRadius.circular(30)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              child: Text('Add Reciept',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            _nameInput(),
           _addImage(),
          ],
        ),
      ),
    );
  }

  // NAME INPUT

  Widget _nameInput() {
    return TextFormField(
      initialValue: '',
      maxLength: 20,
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      cursorColor: Colors.orange,
      style: TextStyle(color: Colors.black, fontSize: 20),
      validator: (input) {
        input.isEmpty ? 'Name Required' : null;
        // checkDup(input) == true ? 'Name already exists, try other name': 'Name available';
      } ,
      onSaved: (input) {
        name = input;
      },
      onChanged: (value) {
        name = value;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.orange,
        contentPadding: EdgeInsets.all(15),
        hintStyle: TextStyle(color: Colors.orange, fontSize: 20),
        hintText: 'Name',
        counterStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(30)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(30)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(30)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(30)),
        errorStyle: TextStyle(color: Colors.white, fontSize: 15),
        suffixIcon: Icon(
          Icons.account_circle,
          color: Colors.orange,
        ),
      ),
    );
  }

  // IMAGE ADD BUTTON
  
  Widget _addImage(){
    return  Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        splashColor: Colors.orange,
                        color: Colors.white,
                        elevation: 5,
                        onPressed: openCamera,
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.orangeAccent,
                        ),
                        label: Text(
                          'Camera',
                          style: TextStyle(
                              fontSize: 20, color: Colors.orangeAccent),
                        )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        splashColor: Colors.orange,
                        color: Colors.white,
                        elevation: 5,
                        onPressed: openGallery,
                        icon: Icon(
                          Icons.add_photo_alternate,
                          color: Colors.orangeAccent,
                        ),
                        label: Text(
                          'Gallery',
                          style: TextStyle(
                              fontSize: 20, color: Colors.orangeAccent),
                        )),
                  ),
                )
              ],
            );
  }

  //  VIEW RECEIPT

  Widget _receiptView() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      height: screenHeight * 0.35,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        shadowColor: Colors.orange,
        elevation: 10,
        child: 
        file == null
            ? 
            Container(
                alignment: Alignment.center,
                height: screenHeight * 0.35,
                width: screenWidth * 0.9,
                child: Text('Once photo uploaded,\nyou can preview it here',
                    style: TextStyle(color: Colors.grey[500])),
              )
            : photoURL=='' 
              ? CircularProgressIndicator(
                backgroundColor: Colors.orange,
                valueColor: _progress,
              )
              : Image(
                image: NetworkImage(photoURL), loadingBuilder: (context, child, loadingProgress) {
                   if (loadingProgress == null) {
                              return child;
                            }
                            return Container(
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.orange,
                                valueColor: _progress,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                },
              )
              ),
    );
  }

  // FLOATING ADD BUTTON

  Widget _addRecieptButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          if (fileName == '') {
           _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                backgroundColor: Colors.white,
                content: Row(
                  children: <Widget>[
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 10,),
                    Text("Error", style: TextStyle(color: Colors.orange),),
                  ],
                ), duration: Duration(seconds: 3),));
          }
          saveReciept();
          // Future.delayed(Duration(seconds: 4), () {
          //   refreshScreen();
          // });
        }
      },
      splashColor: Colors.white,
      backgroundColor: Colors.orange,
      icon: Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
      elevation: 10,
      label: Text(
        'Add Reciept',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      key: _scaffoldKey,
      body: Container(
          child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: IconButton(
                splashColor: Colors.orange,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.orange,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          _addRecieptForm(),
          _receiptView(),
        ],
      )),
      floatingActionButton: _addRecieptButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
