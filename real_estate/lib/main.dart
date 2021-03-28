import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/constants/config.dart';
import 'package:real_estate/constants/themes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:real_estate/data_base/DBhelper.dart';
import 'package:real_estate/providers/location_provider.dart';
import 'package:real_estate/providers/property_provider.dart';
import 'package:real_estate/services/navigationService.dart';
import 'constants/colors.dart';
import 'constants/route.dart';
import 'helpers/data.dart';
import 'helpers/service_locator.dart';
import 'helpers/size_config.dart';
import 'providers/auth.dart';
import 'providers/mainprovider.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  await data.getData('loggedin').then<dynamic>((String auth) async {
    print("auth what :$auth");
    if (auth == "true") {
      config.userId = int.parse(await data.getData("user_id"));
      config.username = await data.getData("user_name");
      config.loggedin = true;
    } else {
      config.loggedin = false;
    }
    print("loggedIn: ${config.loggedin}");
  });
  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<Auth>.value(value: getIt<Auth>()),
        ChangeNotifierProvider<MainProvider>(create: (_) => MainProvider()),
        ChangeNotifierProvider<PropertiesProvider>.value(
            value: getIt<PropertiesProvider>()),
        ChangeNotifierProvider<LocationProvider>.value(
            value: getIt<LocationProvider>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: getIt<NavigationService>().navigatorKey,
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

DBHelper databaseHelper = DBHelper();
// @override
// initState() {
//   databaseHelper.initDatabase();
// }

void handleClick(String value) {
  switch (value) {
    case 'مشاركة':
      break;
    case 'أسئلة شائعة':
      break;
    case 'عن التطبيق':
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
        centerTitle: true,
        title: Row(children: [
          // Text("Real Estate"),
          const SizedBox(width: 12),
          Image.asset("assets/images/logo.jpg",
              width: 60, height: 40, fit: BoxFit.cover)
        ]),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () async {
              // List<User> users = await databaseHelper.readAllUsers();
              // users.forEach((user) => {
              //       print(
              //           "user.id ${user.id} user.phone ${user.phones} user.pass ${user.password} user.latitude ${user.latitude} user.longitude ${user.longitude}")
              //     });
              print("config.loggedin ${config.loggedin}");
              if (config.loggedin) {
                Navigator.pushNamed(context, "/Account");
              } else {
                Navigator.popAndPushNamed(context, "/login");
              }
            },
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
                Text("مسكن",
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
                        onPressed: () {
                          Navigator.pushNamed(context, "/Search",
                              arguments: <String, String>{
                                "search_title": "للبيع"
                              });
                        },
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
                        onPressed: () {
                          Navigator.pushNamed(context, "/Search",
                              arguments: <String, String>{
                                "search_title": "للإيجار"
                              });
                        },
                      ),
                      width: SizeConfig.blockSizeHorizontal * 32,
                      height: SizeConfig.blockSizeVertical * 6,
                    ),
                  ],
                )
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           Text("عمليات بحث سابقة",
          //               style: TextStyle(
          //                   fontWeight: FontWeight.bold, fontSize: 16))
          //         ],
          //       ),
          //       Container(
          //           height: 80,
          //           child: ListView(
          //             scrollDirection: Axis.horizontal,
          //             physics: ScrollPhysics(),
          //             shrinkWrap: true,
          //             children: [
          //               Card(
          //                   margin: EdgeInsets.symmetric(
          //                       horizontal: 8, vertical: 12),
          //                   child: Padding(
          //                       child: Text("للبيع- السعودية الرياض"),
          //                       padding: EdgeInsets.symmetric(
          //                           horizontal: 12, vertical: 16)),
          //                   elevation: 4),
          //               Card(
          //                   margin: EdgeInsets.symmetric(
          //                       horizontal: 16, vertical: 12),
          //                   child: Padding(
          //                       child: Text(" للبيع- السعودية الرياض - جدة"),
          //                       padding: EdgeInsets.all(16)),
          //                   elevation: 4),
          //               Card(
          //                   margin: EdgeInsets.symmetric(
          //                       horizontal: 16, vertical: 12),
          //                   child: Padding(
          //                       child: Text("للبيع- السعودية الرياض"),
          //                       padding: EdgeInsets.all(16)),
          //                   elevation: 4)
          //             ],
          //           )),
          //     ],
          //   ),
          // ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("أنشطتي",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ])),
          InkWell(
              child: Padding(
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
              onTap: () {
                if (config.loggedin) {
                  Navigator.pushNamed(context, "/PerviousSearch");
                } else {
                  Fluttertoast.showToast(msg: "سجل دخولك من فضلك");
                }
              }),
          Divider(),
          InkWell(
              child: Padding(
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
              onTap: () {
                if (config.loggedin) {
                  Navigator.pushNamed(context, "/FavProps");
                } else {
                  Fluttertoast.showToast(msg: "سجل دخولك من فضلك");
                  Navigator.popAndPushNamed(context, "/login");
                }
              }),
          InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("عقاراتي", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 24),
                  Icon(Icons.home, size: 36)
                ],
              ),
            ),
            onTap: () {
              if (config.loggedin) {
                Navigator.pushNamed(context, "/MyProps");
              } else {
                Fluttertoast.showToast(msg: "سجل دخولك من فضلك");
                Navigator.popAndPushNamed(context, "/login");
              }
            },
          ),
          Divider(),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          //   child: Column(
          //     children: [
          //       Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.end,
          //             children: [
          //               Text("المزيد من ماي ريال استيت",
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold, fontSize: 16))
          //             ],
          //           )),
          //       const SizedBox(height: 12),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           Text("أملاك تجارية للبيع", style: TextStyle(fontSize: 24)),
          //           const SizedBox(width: 0),
          //           Icon(Icons.search, size: 36)
          //         ],
          //       ),
          //       const SizedBox(height: 6),
          //       Divider(),
          //       const SizedBox(height: 6),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           Text("أملاك تجارية للتأجير",
          //               style: TextStyle(fontSize: 24)),
          //           const SizedBox(width: 0),
          //           Icon(Icons.search, size: 36)
          //         ],
          //       ),
          //       Divider(),
          //       const SizedBox(height: 12),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           Text("بحث خارج السعودية", style: TextStyle(fontSize: 24)),
          //           const SizedBox(width: 12),
          //           Icon(Icons.wb_sunny_outlined, size: 36)
          //         ],
          //       ),
          //       const SizedBox(height: 12)
          //     ],
          //   ),
          // ),
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
                color: Color(0xFF181515),
                width: MediaQuery.of(context).size.width,
                child: Text("تفقد أخر أسعار البيع بالقرب",
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
