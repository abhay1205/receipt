import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ReciptSearch extends SearchDelegate<String> {




  List<String> reciepts = [
    'Reciept 1',
    'Reciept 2',
    'Reciept 3',
    'Reciept 4',
    'Reciept 5',
    'Reciept 6',
    'Reciept 7',
    'Reciept 8',
    'Reciept 9',
  ];

  List<String> recent = [
    'Reciept 4',
    'Reciept 5',
    'Reciept 6',
  ];
  List<String> recentList = ['Reciept 9'];
  void storeRecieptName(List<String> recentList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recentList', recentList);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 300,
        color: Colors.orange,
        alignment: Alignment.center,
        child: Text(
          query,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recent
        : reciepts.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                query = suggestionList[index];
                recentList.add(suggestionList[index]);
                recentList = recentList.toSet().toList();
                storeRecieptName(recentList);
                showResults(context);
              },
              leading: Icon(Icons.assessment),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: suggestionList[index].substring(query.length),
                          style: TextStyle(
                            color: Colors.grey,
                          ))
                    ]),
              ),
            ));
  }
}
