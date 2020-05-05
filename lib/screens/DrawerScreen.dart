import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:recieptStore/logic/AuthService.dart';
import 'package:recieptStore/models/appState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final _drawerKey = GlobalKey<DrawerControllerState>();
  // String name = '', email = '';
  // void getInfo() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     name = prefs.getString('name');
  //     email = prefs.getString('email');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Drawer(
          key: _drawerKey,
          elevation: 5,
          child: Container(
            margin: EdgeInsets.only(bottom: 1),
            color: Colors.grey[300],
            child: Column(
              children: <Widget>[
                // NameCard
                Container(
                  color: Color(0xFF045ed1),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(
                        left: 15, top: 40, bottom: 20, right: 20),
                    title: Text(
                      state.name.toString(),
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    subtitle: Text(
                      state.email.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    trailing:
                        Icon(Icons.account_circle, size: 40, color: Colors.white),
                  ),
                ),
                // About App
                Container(
                  margin: EdgeInsets.only(top: 40, left: 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 80, 10),
                  height: 60,
                  width: 400,
                  child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      splashColor: Colors.white,
                      color: Color(0xFF045ed1),
                      elevation: 5,
                      onPressed: () {},
                      icon: Icon(Icons.info_outline, color: Colors.white),
                      label: Text(
                        'About app',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
                // Rate the app
                Container(
                  margin: EdgeInsets.only(top: 20, left: 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 80, 10),
                  height: 60,
                  width: 400,
                  child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      splashColor: Colors.white,
                      color: Color(0xFF045ed1),
                      elevation: 5,
                      onPressed: () {},
                      icon: Icon(Icons.star_border, color: Colors.white),
                      label: Text(
                        'Rate the app',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
                // Log Out
                Container(
                  margin: EdgeInsets.only(top: 20, left: 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 80, 10),
                  height: 60,
                  width: 400,
                  child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      splashColor: Colors.white,
                      color: Color(0xFF045ed1),
                      elevation: 5,
                      onPressed: () {
                        AuthService().signOut();
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
                    width: MediaQuery.of(context).size.width * 0.09,
                    height: MediaQuery.of(context).size.height * 0.09,
                    padding: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 10)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100))),
                    child: GestureDetector(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF045ed1),
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
      },
    );
  }
}
