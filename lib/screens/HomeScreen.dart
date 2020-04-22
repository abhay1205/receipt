import 'package:flutter/material.dart';
import 'package:recieptStore/screens/DrawerScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget appIcon() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 40, 20, 0),
      height: screenHeight*0.35,
      child: Card(
        color: Colors.orange[600],
        elevation: 10,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Image(image: AssetImage('asset/index.jpeg'), colorBlendMode: BlendMode.overlay, color: Colors.orange,),
      ),
    );
  }

  // WIDGETS
  Widget _curveBoard() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: Text(' Reciept\nManager',
                  style: TextStyle(color: Colors.orange, fontSize: 40)),
            ),
            appIcon(),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/add');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
                highlightedBorderColor: Colors.orange,
                splashColor: Colors.orange,
                child: Text('Add Reciept',
                    style: TextStyle(color: Colors.orange, fontSize: 25)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              child: OutlineButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/view');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
                highlightedBorderColor: Colors.orange,
                splashColor: Colors.orange,
                child: Text('View Reciepts',
                    style: TextStyle(color: Colors.orange, fontSize: 25)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.orange,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Row(
                children: <Widget>[
                  Center(
                    child: Container(
                      height: screenHeight * 0.07,
                      padding: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(100),
                              bottomRight: Radius.circular(100))),
                      child: GestureDetector(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.orange,
                          size: 20,
                        ),
                        onTap: () 
                        { _scaffoldKey.currentState.openDrawer();}
                      ),
                    ),
                  ),
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
