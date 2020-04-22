import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:recieptStore/logic/AuthService.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Animation<Color> _progress = AlwaysStoppedAnimation(Colors.yellow);
  String _name;
  double screenSizeHeight, screenSizeWidth;

  Widget appIcon() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 40, 10, 0),
      height: screenSizeHeight*0.4,
      child: Card(
        color: Colors.orange[600],
        elevation: 10,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Image(image: AssetImage('asset/index.jpeg'), colorBlendMode: BlendMode.overlay, color: Colors.orange,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSizeHeight = MediaQuery.of(context).size.height;
    screenSizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.orange,
      body: Container(
          margin: EdgeInsets.only(left: 40, top: 80),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(80))),
          padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(' Reciept\nManager',
                      style: TextStyle(color: Colors.orange, fontSize: 40)),
                ),
                appIcon(),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(20, 30, 20, 40),
                //   child: TextFormField(
                //     initialValue: '',
                //     cursorColor: Colors.black,
                //     style: TextStyle(fontSize: 20),
                //     decoration: InputDecoration(
                //         contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(40),
                //             borderSide:
                //                 BorderSide(color: Colors.orange, width: 2)),
                //         focusedErrorBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(40),
                //             borderSide:
                //                 BorderSide(color: Colors.orange, width: 2)),
                //         enabledBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(40),
                //             borderSide:
                //                 BorderSide(color: Colors.orange, width: 2)),
                //         focusedBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(40),
                //             borderSide:
                //                 BorderSide(color: Colors.orange, width: 2)),
                //         fillColor: Colors.orange,
                //         hintText: 'Name'),
                //     validator: (value) =>
                //         value.isNotEmpty ? null : 'Name required',
                //     onChanged: (value) => _name = value,
                //     onSaved: ((newValue) {
                //       _name = newValue;
                //       AuthService().storeUserName(_name);
                //     }),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  alignment: Alignment.center,
                  child: GoogleSignInButton(
                    borderRadius: 30,
                    textStyle: TextStyle(color: Colors.orange, fontSize: 20),
                    splashColor: Colors.orange,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          content: Row(
                            children: <Widget>[
                              CircularProgressIndicator(
                                backgroundColor: Colors.orange,
                                valueColor: _progress,
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text('Sigining In',
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 20))
                            ],
                          ),
                        ));
                        AuthService()
                            .signInWithGoogle()
                            .then((value) => Navigator.pushReplacementNamed(
                                context, '/home'))
                            .catchError((e) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                              "Error $e",
                              style: TextStyle(color: Colors.orange),
                            ),
                            duration: Duration(seconds: 5),
                          ));
                        });
                      }
                    },
                    text: 'Sign In ',
                  ),
                )
              ],
            ),
          )),
    );
  }
}
