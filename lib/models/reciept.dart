class Reciept {
  String receiptName, photoUrl, searchKey, dateTimeStamp;
  int downloadSize;
  bool star;
  Reciept({this.receiptName, this.photoUrl, this.searchKey, this.dateTimeStamp, this.downloadSize, this.star});

  String get reciept => this.receiptName;
  String get photo => this.photoUrl;
  String get searcgkey => this.searchKey;
  String get dateTime => this.dateTimeStamp;
  bool get stars => this.star;

  set reciept(String reciept){
    this.receiptName =reciept;
  }
  set photo(String photo){
    this.photoUrl =photo;
  }
 set searchkey(String searchkey){
    this.searchKey =searchkey;
  }
  set stars(bool stars){
    this.star = stars;
  }

  Map<String, dynamic> toJson(){
  return{
//    key value pairs
    "receiptName": receiptName,
    "photoUrl": photoUrl,
    "searchKey": searchKey,
    "dateTimeStamp": dateTimeStamp,
    'star': star,
    "downloadSize": downloadSize
    
  };
}

}

