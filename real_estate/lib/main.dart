import 'package:flutter/material.dart';
import 'package:real_estate/constants/themes.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
      backgroundColor: colors.white,
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
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          Container(
            height: 160,
            color: Color(0xFF170531),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("جد سعادتك",
                    style: TextStyle(color: Colors.white, fontSize: 32)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("عمليات بحث سابقة",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
                Container(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: Padding(
                                child: Text("للبيع- السعودية الرياض"),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16)),
                            elevation: 4),
                        Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Padding(
                                child: Text(" للبيع- السعودية الرياض - جدة"),
                                padding: EdgeInsets.all(16)),
                            elevation: 4),
                        Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Padding(
                                child: Text("للبيع- السعودية الرياض"),
                                padding: EdgeInsets.all(16)),
                            elevation: 4)
                      ],
                    )),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("ماي ريال اسيتيت",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ])),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("عمليات بحث محفوظة", style: TextStyle(fontSize: 24)),
                const SizedBox(width: 24),
                Icon(Icons.star, size: 36)
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("العقارات المفضلة", style: TextStyle(fontSize: 24)),
                const SizedBox(width: 24),
                Icon(Icons.favorite, size: 36)
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("المزيد من ماي ريال استيت",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))
                      ],
                    )),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("أملاك تجارية للبيع", style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 0),
                    Icon(Icons.search, size: 36)
                  ],
                ),
                const SizedBox(height: 6),
                Divider(),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("أملاك تجارية للتأجير",
                        style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 0),
                    Icon(Icons.search, size: 36)
                  ],
                ),
                Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("بحث خارج السعودية", style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Icon(Icons.wb_sunny_outlined, size: 36)
                  ],
                ),
                const SizedBox(height: 12)
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF170531),
        child: Column(
          children: [
            Divider(color: Color(0xFF170531), thickness: 2),
            Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Color(0xFF7C7C7C),
                width: MediaQuery.of(context).size.width,
                child: Text("تفقد أخر أسعر البيع بالقرب",
                    style: TextStyle(fontSize: 16, color: colors.white))),
            CarouselSlider(
                options: CarouselOptions(
                  height: 118,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                    pageViewKey:
                        const PageStorageKey<dynamic>('carousel_slider')),
                items: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset("assets/images/logo.jpg",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover),
                  ),
                ]),
          ],
        ),
        height: 160,
      ),
    );
  }
}
