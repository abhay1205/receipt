import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerScreen extends StatefulWidget{

@override
  _DrawerScreenState createState() => _DrawerScreenState();

}

class _DrawerScreenState extends State<DrawerScreen>{
  final _drawerKey = GlobalKey<DrawerControllerState>();
  String name = '', email = '';
  void getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    return Drawer(
      key: _drawerKey,
      elevation: 5,
      child: Container(
        margin: EdgeInsets.only(bottom: 1),
        color: Colors.grey[300],
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.orange,
              child: ListTile(
                contentPadding:
                    EdgeInsets.only(left: 15, top: 40, bottom: 20, right: 20),
                title: Text(
                  name,
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                subtitle: Text(
                  email,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                trailing:
                    Icon(Icons.account_box, size: 40, color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 10),
              padding: EdgeInsets.fromLTRB(10, 0, 80, 10),
              height: 60,
              width: 400,
              child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  splashColor: Colors.white,
                  color: Colors.orange,
                  elevation: 5,
                  onPressed: () {},
                  icon: Icon(Icons.info_outline, color: Colors.white),
                  label: Text(
                    'About app',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 10),
              padding: EdgeInsets.fromLTRB(10, 0, 80, 10),
              height: 60,
              width: 400,
              child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  splashColor: Colors.white,
                  color: Colors.orange,
                  elevation: 5,
                  onPressed: () {},
                  icon: Icon(Icons.star_border, color: Colors.white),
                  label: Text(
                    'Rate the app',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 10),
              padding: EdgeInsets.fromLTRB(10, 0, 80, 10),
              height: 60,
              width: 400,
              child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  splashColor: Colors.white,
                  color: Colors.orange,
                  elevation: 5,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  label: Text(
                    'Log Out',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.07,
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100))),
                child: GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.orange,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
