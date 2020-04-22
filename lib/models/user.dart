class User {
  String name, email;
  User({this.name, this.email});

  String get userName => this.name;
  String get userEmail => this.email;

  set userName(String userName){
    this.name =userName;
  }
  set userEmail(String userEmail){
    this.email =userEmail;
  }

  Map<String, String> toJson(){
  return{
//    key value pairs
    "name": name,
    "email": email,
    
  };
}

}

