import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:recieptStore/logic/GetReceiptsService.dart';
import 'package:recieptStore/models/appState.dart';

class ViewScreen extends StatefulWidget {
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
  List<DocumentSnapshot> _products = [];
  bool _loadingProducts = true;
  int per_page = 5;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();
  bool gettingpdts = false;
  bool morepdtsavailable = true;

  @override
  void initState() {
    
    super.initState();
    print('initState');
    _getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height *0.25;

      if(maxScroll - currentScroll <= delta){
        _getMoreProducts();
      }

    });
    
  }

  _getProducts() async{
    print('Entered');
    Query q = _firestore.collection("abhaysinghal00@gmail.com").orderBy('recipetName').limit(per_page);
    setState(() {
      _loadingProducts = true;
    });
    QuerySnapshot querySnapshot =  await q.getDocuments();
    _products = querySnapshot.documents;
    _lastDocument = querySnapshot.documents[querySnapshot.documents.length-1];
    print(_products.length.toString());
    setState(() {
       _loadingProducts = false;
    });
   
  }

  _getMoreProducts() async {
    print("_getMorePdts called");

    if(morepdtsavailable == false){
      print("max");
      return;
    }

    if(gettingpdts == true){
      print("process");
      return;
    }

    gettingpdts = true;

    Query q = _firestore.collection("abhaysinghal00@gmail.com").orderBy('recipetName').startAfter([_lastDocument.data['recipetName']]).limit(per_page);
    
    QuerySnapshot querySnapshot =  await q.getDocuments();

    if(querySnapshot.documents.length < per_page){
      morepdtsavailable = false;
    }
    _lastDocument = querySnapshot.documents[querySnapshot.documents.length-1];
    setState(() {
      _products.addAll(querySnapshot.documents);
    });
    gettingpdts = false;
    print(_products.length.toString());
    
  }

  // Widget receiptList() {
  //   return StreamBuilder(
  //     stream: Firestore.instance.collection('$_email').snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         _scaffoldKey.currentState.showSnackBar(SnackBar(
  //           backgroundColor: Colors.white,
  //           content: Text('Error occured, try again later',
  //               style: TextStyle(
  //                   color: Color(0xFF045ed1), fontWeight: FontWeight.w400)),
  //         ));
  //       }
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.active:
  //           return ListView.builder(
  //               itemCount: snapshot.data.documents.length,
  //               itemBuilder: (context, i) {
  //                 if (snapshot.hasData) {
  //                   return _receiptCard(snapshot.data.documents[i]['photoUrl'],
  //                       snapshot.data.documents[i]['recipetName'], snapshot.data.documents[i].documentID);
  //                 } else {
  //                   return CircularProgressIndicator(
  //                     backgroundColor: Color(0xFF045ed1),
  //                     valueColor: _progress,
  //                   );
  //                 }
  //               });
  //         case ConnectionState.waiting:
  //           return Center(
  //             child: CircularProgressIndicator(
  //               backgroundColor: Color(0xFF045ed1),
  //               valueColor: _progress,
  //             ),
  //           );
  //         case ConnectionState.done:
  //           return ListView.builder(
  //               itemCount: snapshot.data.documents.length,
  //               itemBuilder: (context, i) {
  //                 if (snapshot.hasData) {
  //                   return _receiptCard(snapshot.data.documents[i]['photoUrl'],
  //                       snapshot.data.documents[i]['recipetName'],  snapshot.data.documents[i].documentID);
  //                 } else {
  //                   return CircularProgressIndicator(
  //                     backgroundColor: Colors.orange,
  //                     valueColor: _progress,
  //                   );
  //                 }
  //               });
  //         case ConnectionState.none:
  //           return Center(
  //             child: Text('Unable to fetch the data',
  //                 style: TextStyle(
  //                     color: Colors.orange, fontWeight: FontWeight.w500)),
  //           );
  //       }
  //     },
  //   );
  // }

  Widget _receiptCard(String url, String name, docID) {
    return GestureDetector(
      onDoubleTap: ()=> showReceipt(url),
          child: CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider){
              return Container(
                  height: screenHeight * 0.5,
                  margin: EdgeInsets.fromLTRB(50, 40, 50, 20),
                  padding: EdgeInsets.only(top: screenHeight * 0.45),
                  decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider,fit: BoxFit.fill, ),
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
                                      name,
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    )))),
                        IconButton(
                            icon: Icon(Icons.share, color: Colors.blue),
                            onPressed: () {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Loading"),));
                              GetReceipts().download(url);
                            }),
                        IconButton(
                          icon: Icon(Icons.star, color: Colors.yellow),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: ()  {
                            String res = GetReceipts().delete(_email, docID);
                            _getProducts();
                            morepdtsavailable = true;
                          },
                        )
                      ],
                    ),
                  ));
            },
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
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

  Widget _appBar() {
    return AppBar(
      backgroundColor: Color(0xFF045ed1),
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
      title:
          Text('Receipts', style: TextStyle(color: Colors.white, fontSize: 30)),
      actions: <Widget>[
        IconButton(
            splashColor: Colors.white,
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        _email = state.email.toString();
        print("redux " + _email);
        print('builder');
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey[300],
          appBar: _appBar(),
          body: Container(
            child:
            _loadingProducts == true ? Center(child: CircularProgressIndicator(),) :
            ListView.builder(
              controller: _scrollController,
              itemCount: _products.length,
              itemBuilder: (context, index){
                return _receiptCard(_products[index].data['photoUrl'], _products[index].data['recipetName'], _products[index].documentID);
              })
          )
        );
      },
    );
    
  }
}
