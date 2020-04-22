import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewScreen extends StatefulWidget {
  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  String email, month;
  double screenHeight;
  Animation<Color> _progress = AlwaysStoppedAnimation(Colors.yellow);
  QuerySnapshot receipts;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getEmail();
    month = getMonth();
    super.initState();
  }

  String getMonth() {
    var month = DateFormat("MM-yyyy").format(DateTime.now());
    print(month);
    return month;
  }

  void getEmail() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user.email);
    setState(() {
      email = user.email;
    });
  }

  showReceipt(dynamic url) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          elevation: 10,
          content: Container(
              child: Image(
            image: NetworkImage(url),
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          )),
        );
      },
    );
  }

  Widget receiptList() {
    return StreamBuilder(
      stream: Firestore.instance.collection('$email').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.white,
            content: Text('Error occured, try again later', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w400)),));
        }
        switch(snapshot.connectionState){
          case ConnectionState.active: return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, i) {
              if (snapshot.hasData) {
                return Card(
                  margin: EdgeInsets.fromLTRB(5, 20, 5, 10),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                    child: ListTile(
                      onTap: () {
                        showReceipt(snapshot.data.documents[i]['photoUrl']);
                      },
                      leading: Image(
                          image: NetworkImage(
                              snapshot.data.documents[i]['photoUrl']),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Container(
                              alignment: Alignment.centerLeft,
                              height: 20,
                              width: 20,
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
                          }),
                      title: Text(
                        snapshot.data.documents[i]['recipetName'],
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                  valueColor: _progress,
                );
              }
            });
            case ConnectionState.waiting: return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orange,
                valueColor: _progress,
              ),
            );
            case ConnectionState.done: return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, i) {
              if (snapshot.hasData) {
                return Card(
                  margin: EdgeInsets.fromLTRB(5, 20, 5, 10),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                    child: ListTile(
                      onTap: () {
                        showReceipt(snapshot.data.documents[i]['photoUrl']);
                      },
                      leading: Image(
                          image: NetworkImage(
                              snapshot.data.documents[i]['photoUrl']),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          }),
                      title: Text(
                        snapshot.data.documents[i]['recipetName'],
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                  valueColor: _progress,
                );
              }
            });
            case ConnectionState.none: return Center(child: Text('Unable to fetch the data', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500)),);
        }

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.orange,
          elevation: 0,
          leading: IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          centerTitle: true,
          title: Text('Receipts',
              style: TextStyle(color: Colors.white, fontSize: 30)),
          actions: <Widget>[
            IconButton(
                splashColor: Colors.white,
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
          child: receiptList(),
        ));
  }
}
