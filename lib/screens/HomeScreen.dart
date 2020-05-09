import 'package:flutter/material.dart';
import 'package:recieptStore/screens/DrawerScreen.dart';

class HomeScreen extends StatefulWidget {
  final void Function() onInit;
  HomeScreen({this.onInit});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight, screenWidth;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  // WIDGETS
  Widget _curveBoard() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 80),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40),
              alignment: Alignment.center,
              child: Text(' Reciept\nManager',
                  style: TextStyle(color: Color(0xFF045ed1), fontSize: 40)),
            ),
            // appIcon(),
             Container( 
                  height: screenHeight*0.4,
                  child: Image(image: AssetImage('asset/receipt_573065707_1000.jpg'), fit: BoxFit.fitHeight,),
                ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/add');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                borderSide: BorderSide(
                  color: Color(0xFF045ed1),
                  width: 2,
                ),
                highlightedBorderColor: Color(0xFF045ed1),
                splashColor: Color(0xFF045ed1),
                child: Text('Add',
                    style: TextStyle(color: Color(0xFF045ed1), fontSize: 25)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/view');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                borderSide: BorderSide(
                  color: Color(0xFF045ed1),
                  width: 2,
                ),
                highlightedBorderColor: Color(0xFF045ed1),
                splashColor: Color(0xFF045ed1),
                child: Text('View',
                    style: TextStyle(color: Color(0xFF045ed1), fontSize: 25)),
              ),
            ),
             Container(
              margin: EdgeInsets.only(top: 10),
              child: OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/search');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                borderSide: BorderSide(
                  color: Color(0xFF045ed1),
                  width: 2,
                ),
                highlightedBorderColor: Color(0xFF045ed1),
                splashColor: Color(0xFF045ed1),
                child: Text('Search',
                    style: TextStyle(color: Color(0xFF045ed1), fontSize: 25)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _drawerButton() {
    return Center(
      child: Container(
        height: screenHeight * 0.09,
        width: screenWidth * 0.09,
        padding: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                bottomRight: Radius.circular(100))),
        child: GestureDetector(
            child: Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF045ed1),
              size: 20,
            ),
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF045ed1),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Row(
                children: <Widget>[
                  // DRAWER BUTTON
                  _drawerButton(),
                  // MAIN BOARD
                  _curveBoard(),
                ],
              )),
            )
          ],
        ),
      ),
      drawer: DrawerScreen(),
    );
  }
}
