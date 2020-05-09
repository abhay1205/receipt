import 'package:recieptStore/models/appState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThunkAction<AppState> getEmailNameAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String name = prefs.getString('name');
  final String email = prefs.getString('email');
  print("Action area $email");
  // final String emailLinkNum = prefs.getString('email-linked-number');
  store.dispatch(GetEmailAction(email));
  store.dispatch(GetNameAction(name));
};

class GetNameAction {
  final String _name;

  String get name => this._name;

  GetNameAction(this._name);
}

class GetEmailAction {
  final String _email;

  String get email => this._email;

  GetEmailAction(this._email);
}

class InitEmailAction{
  String iEmail;
  initEmail() async{
    final prefs = await SharedPreferences.getInstance();
    iEmail = prefs.getString('email');
  }
  
}

