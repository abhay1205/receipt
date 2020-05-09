import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:recieptStore/models/appState.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double screenHeight;

  var queryResultSet = [];
  var tempSearchStore = [];

  startSearch(value) {
    print("called");
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.toString().substring(0, 1).toUpperCase() +
        value.toString().substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      print("called1");

      var res = Firestore.instance
          .collection("abhaysinghal00@gmail.com")
          .where('searchKey', isEqualTo: value.toString().substring(0,1).toUpperCase()).getDocuments();
      res.then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          print(docs.documents[i].data['recipetName']);
          queryResultSet.add(docs.documents[i].data);
          setState(() {
            tempSearchStore.add(docs.documents[i].data);
          });
          
        }
      });
    } else {
      print("called2");
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['recipetName'].toString().startsWith(capitalizedValue)) {
            print("res " + element['recipetName']);
            setState(() {
              tempSearchStore.add(element);
            });
        }
      });
    }
  }



  Widget _buildResult(data) {
    return GestureDetector(
      onDoubleTap: () => showReceipt(data['photoUrl']),
      child: CachedNetworkImage(
        imageUrl: data['photoUrl'],
        imageBuilder: (context, imageProvider) {
          return Container(
              margin: EdgeInsets.fromLTRB(5, 4, 5, 2),
              padding: EdgeInsets.only(top: screenHeight * 0.18),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)]),
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
                                  data['receiptName'],
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )))),
                  ],
                ),
              ));
        },
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
                ),
              );
            },
          )),
        );
      },
    );
  }

    Widget _searchBox() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
      alignment: Alignment.center,
      child: TextField(
        cursorColor: Colors.black,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusColor: Color(0xFF045ed1),
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
          hintText: 'Name',
          counterStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(30)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(30)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(30)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(30)),
          errorStyle: TextStyle(color: Colors.white, fontSize: 15),
          suffixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
        ),
        onChanged: (value) {
          startSearch(value);
        },
      ),
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
              child: Text("Search Receipt",
                  style: TextStyle(color: Color(0xFF045ed1), fontSize: 35)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        screenHeight = MediaQuery.of(context).size.height;
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey[300],
          appBar: PreferredSize(
              child: _customAppBar(context),
              preferredSize: Size.fromHeight(60)),
          body: Container(
            child: ListView(
              children: <Widget>[
                _searchBox(),
                SizedBox(
                  height: 20,
                ),
                GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 20,
                  primary: false,
                  shrinkWrap: true,
                  children: tempSearchStore.map((element) {
                    return _buildResult(element);
                  }).toList(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
