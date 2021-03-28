import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/data_base/DBhelper.dart';

class SavedSearchLoad extends StatelessWidget {
  SavedSearchLoad({Key key}) : super(key: key);
  final DBHelper databaseHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    {
      return
          //  getIt<PropertiesProvider>().myProps.isEmpty
          //     ?
          FutureBuilder<List<String>>(
        future: databaseHelper.readSearches(),
        builder: (BuildContext ctx, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SavedSearch(searchs: snapshot.data);
          } else {
            return Container(
                color: colors.white,
                child: const CupertinoActivityIndicator(radius: 24));
          }
        },
      );
      // : MyProperties();
    }
  }
}

class SavedSearch extends StatefulWidget {
  SavedSearch({Key key, this.searchs}) : super(key: key);
  final List<String> searchs;
  @override
  _SavedSearchState createState() => _SavedSearchState();
}

class _SavedSearchState extends State<SavedSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(children: [
          Text("أبحاث سابقة"),
        ]),
      ),
      body: ListView.builder(
          itemCount: widget.searchs.length,
          itemBuilder: (context, index) {
            print(widget.searchs[index]);
            // final String s = widget.searchs[index]
            //     .substring(1, widget.searchs[index].length - 1);
            return ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(12),
                title: Text(widget.searchs[index]));
          }),
    );
  }
}
