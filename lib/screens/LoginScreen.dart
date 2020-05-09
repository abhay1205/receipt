import 'package:firebase_auth/firebase_auth.dart';
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
  final Animation<Color> _progress = AlwaysStoppedAnimation(Color(0xFF0341850));
  double screenSizeHeight, screenSizeWidth;

  checkAuth() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    FirebaseUser currentUser = await _auth.currentUser();

    if (currentUser != null) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  Widget appIcon() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 40, 10, 0),
      height: screenSizeHeight * 0.4,
      child: Card(
        color: Colors.orange[600],
        elevation: 10,
//        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Image(
          image: AssetImage('asset/index.jpeg'),
          colorBlendMode: BlendMode.overlay,
          color: Colors.orange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSizeHeight = MediaQuery.of(context).size.height;
    screenSizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF045ed1),
      body: Container(
          margin: EdgeInsets.only(left: 40, top: 80),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)],
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
                      style: TextStyle(color: Color(0xFF045ed1), fontSize: 40)),
                ),
                Container( 
                  height: screenSizeHeight*0.5,
                  child: Image(image: AssetImage('asset/receipt_573065707_1000.jpg'), fit: BoxFit.fitHeight,),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: GoogleSignInButton(
                    borderRadius: 30,
                    textStyle:
                        TextStyle(color: Color(0xFF045ed1), fontSize: 20),
                    splashColor: Color(0xFF045ed1),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          content: Row(
                            children: <Widget>[
                              CircularProgressIndicator(
                                backgroundColor: Color(0xFF045ed1),
                                valueColor: _progress,
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text('Sigining In',
                                  style: TextStyle(
                                      color: Color(0xFF045ed1), fontSize: 20))
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
                              style: TextStyle(color: Color(0xFF045ed1)),
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
