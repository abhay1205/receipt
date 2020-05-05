
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recieptStore/models/appState.dart';
import 'package:recieptStore/redux/actions.dart';
import 'package:recieptStore/screens/HomeScreen.dart';
import 'package:recieptStore/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Widget handleAuth(BuildContext context){
    if(_auth.currentUser() != null){
      return HomeScreen(
        onInit: (){
              StoreProvider.of<AppState>(context).dispatch(getEmailNameAction);
            }
      );
    }
    else{
      return LoginScreen();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final FirebaseUser user =
          (await _auth.signInWithCredential(authCredential)).user;
      assert(user.email != null);
      assert(user.displayName != null);

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentuser = await _auth.currentUser();
      assert(user.uid == currentuser.uid);
      if (user.email != null) {
        print(user.email);
        storeUserEmail(user.email);
        storeUserName(user.displayName);
      }
      return user;
    } catch (e) {
      SnackBar(content: Text(e.toString()), duration: Duration(seconds: 3),);
    }
  }

  void storeUserEmail(email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  void storeUserName(name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
  }

  void signOut() async {
    _auth.signOut();
    final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signOut();
    
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}