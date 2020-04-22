import 'package:meta/meta.dart';


@immutable

class AppState {

  final String name;
  final String email;
  


  AppState({
     @required this.name,
    @required this.email, 
    });

  factory AppState.initial(){
    return AppState(
      name: null,
      email: null,);
  }
}