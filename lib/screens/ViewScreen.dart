import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:recieptStore/logic/GetReceiptsService.dart';
import 'package:recieptStore/models/appState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewScreen extends StatefulWidget {
  final void Function() onInit;
  ViewScreen({this.onInit});
  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  String _email;
  double screenHeight;
  Animation<Color> _progress = AlwaysStoppedAnimation(Colors.blue);
  QuerySnapshot receipts;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<DocumentSnapshot> _products = [];
  bool _loadingProducts = true, gettingpdts = false, morepdtsavailable = true;
  int per_page = 5;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    widget.onInit();
    super.initState();
    _getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (maxScroll - currentScroll <= delta) {
        _getMoreProducts();
      }
    });
  }

  Future<String> getEmailInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String email;
    setState(() {
      email = prefs.getString('email');
    });
    return email;
  }

  _getProducts() async {
    await getEmailInfo().then((value) {
      setState(() {_email = value;});
    });
    print('Entered');
    print(_email);
    Query q = _firestore.collection("$_email").orderBy('receiptName').limit(per_page);
    setState(() {_loadingProducts = true;});

    QuerySnapshot querySnapshot = await q.getDocuments();
    _products = querySnapshot.documents;
    print("getPdt" + querySnapshot.documents.length.toString());
    _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];

    setState(() { _loadingProducts = false;});
  }


  _getMoreProducts() async {
    print("_getMorePdts called");
    if (morepdtsavailable == false) {
      print("max");
      return;
    }
    if (gettingpdts == true) {
      print("process");
      return;
    }
    gettingpdts = true;

    Query q = _firestore
        .collection("$_email")
        .orderBy('receiptName')
        .startAfter([_lastDocument.data['receiptName']]).limit(per_page);

    QuerySnapshot querySnapshot = await q.getDocuments();
    print("getPdt" + querySnapshot.documents.length.toString());
    if (querySnapshot.documents.length < per_page) {
      morepdtsavailable = false;
    }
    _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
    setState(() {
      _products.addAll(querySnapshot.documents);
    });
    gettingpdts = false;
  }

  Widget _receiptCard(String url, String name, bool star, docID) {
    return GestureDetector(
      onDoubleTap: () => showReceipt(url),
      child: 
      // CachedNetworkImage(
      //   imageUrl: url,
      //   imageBuilder: (context, imageProvider) {
      //     return 
          Container(
              height: screenHeight * 0.5,
              margin: EdgeInsets.fromLTRB(50, 40, 50, 20),
              padding: EdgeInsets.only(top: screenHeight * 0.45),
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(url), fit: BoxFit.fill, onError: (exception, stackTrace) {return Icon(Icons.error, color: Colors.red);},),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)]),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 30),
                            alignment: Alignment.centerLeft,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(5, 2, 5, 4),
                                decoration: BoxDecoration(
                                    color: Color(0xFF045ed1),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.white, blurRadius: 15)
                                    ]),
                                child: Text(
                                  "${name.substring(0,5)}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )))),
                    IconButton(
                        icon: Icon(Icons.share, color: Colors.blue),
                        onPressed: () {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Loading"),
                          ));
                          GetReceipts().download(url);
                        }),
                    IconButton(
                      icon: Icon( star ? Icons.star : Icons.star_border, color: star ? Colors.yellow : Colors.grey),
                      onPressed: () {
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        String res = GetReceipts().delete(_email, docID);
                        _getProducts();
                        morepdtsavailable = true;
                      },
                    )
                  ],
                ),
              ))
      //   },
      //   // placeholder: (context, url) => CircularProgressIndicator(),
      //   errorWidget: (context, url, error) {
      //     print(error);
      //     return Icon(Icons.error);
      //   } ,
      // ),
    );
  }

  showReceipt(dynamic url) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          elevation: 10,
          content: Container(
            height: screenHeight*0.6,
              child: Image(
            image: CachedNetworkImageProvider(url),
            fit: BoxFit.fill,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xFF045ed1),
                  valueColor: _progress,
                ),
              );
            },
          )),
        );
      },
    );
  }
  

  Widget _customAppBar(context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF045ed1),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          SizedBox(width: MediaQuery.of(context).size.width * 0.15),
          Center(
              child: Text("View Receipts",
                  style: TextStyle(color: Color(0xFF045ed1), fontSize: 35)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        _email = state.email.toString();
        return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.grey[300],
            appBar: PreferredSize(
                child: _customAppBar(context),
                preferredSize: Size.fromHeight(50)),
            body: Container(
                child: _loadingProducts == true
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: screenHeight * 0.05,
                            ),
                            Text("Loading...")
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {

                          return _receiptCard(
                              _products[index].data['photoUrl'],
                              _products[index].data['receiptName'],
                              _products[index].data['star'],
                              _products[index].documentID);
                        })));
      },
    );
  }
}
