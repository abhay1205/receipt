class Reciept {
  String recieptName, photoUrl, dateTimeStamp, downloadSize;
  Reciept({this.recieptName, this.photoUrl, this.dateTimeStamp, this.downloadSize});

  String get reciept => this.recieptName;
  String get photo => this.photoUrl;
  String get dateTime => this.dateTimeStamp;

  set reciept(String reciept){
    this.recieptName =reciept;
  }
  set photo(String photo){
    this.photoUrl =photo;
  }

  Map<String, String> toJson(){
  return{
//    key value pairs
    "recipetName": recieptName,
    "photoUrl": photoUrl,
    "dateTimeStamp": dateTimeStamp,
    "downloadSize": downloadSize
    
  };
}

}

