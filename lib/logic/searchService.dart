import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField) async {
    print("entered");
    var res = Firestore.instance.collection("abhaysinghal00@gmail.com").where(
          'searchKey', isEqualTo: searchField.substring(0,1).toUpperCase()
        ).getDocuments();
    res.then((value) => print(value.documents[0].data["searchKey"]));
    return res; 
  }
}
