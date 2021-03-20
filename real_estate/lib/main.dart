import 'package:flutter/material.dart';
import 'package:real_estate/constants/themes.dart';

import 'constants/colors.dart';
import 'constants/route.dart';
import 'helpers/size_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: mainThemeData(),
      onGenerateRoute: onGenerateRoute,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

@override
void initState() {}
void handleClick(String value) {
  switch (value) {
    case 'Logout':
      break;
    case 'Settings':
      break;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Real Estate"),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {"عن التطبيق", "أسئلة شائعة", "مشاركة"}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            color: Color(0xFF170531),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("جد سعادتك"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: RaisedButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        color: Colors.green,
                        child: Text("للبيع",
                            style: TextStyle(
                                fontSize: 24, color: Color(0xFF170531))),
                        onPressed: () {},
                      ),
                      width: SizeConfig.blockSizeHorizontal * 32,
                      height: SizeConfig.blockSizeVertical * 6,
                    ),
                    Container(
                      child: RaisedButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        color: Colors.green,
                        child: Text("للإيجار",
                            style: TextStyle(
                                fontSize: 24, color: Color(0xFF170531))),
                        onPressed: () {},
                      ),
                      width: SizeConfig.blockSizeHorizontal * 32,
                      height: SizeConfig.blockSizeVertical * 6,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: colors.red,
      ),
    );
  }
}
