import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:recieptStore/logic/AuthService.dart';
import 'package:recieptStore/models/appState.dart';
import 'package:recieptStore/redux/actions.dart';
import 'package:recieptStore/redux/reducer.dart';
import 'package:recieptStore/screens/AddScreen.dart';
import 'package:recieptStore/screens/HomeScreen.dart';
import 'package:recieptStore/screens/LoginScreen.dart';
import 'package:recieptStore/screens/SearchScreen.dart';
import 'package:recieptStore/screens/ViewScreen.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(), middleware: [thunkMiddleware]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({this.store});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(),
        routes: {
          '/home': (BuildContext context) => HomeScreen(
            onInit: (){
              StoreProvider.of<AppState>(context).dispatch(getEmailNameAction);
            }
          ),
          '/login': (BuildContext context) => LoginScreen(),
          '/add': (BuildContext context) => AddScreen(),
          '/view': (BuildContext context) => ViewScreen(
            onInit: (){
              StoreProvider.of<AppState>(context).dispatch(getEmailNameAction);
            }
          ),
          '/search': (BuildContext context) => SearchScreen(),
          '/drawer': (BuildContext context) => Drawer()
        },
        home: LoginScreen(),
      ),
    );
  }
}
