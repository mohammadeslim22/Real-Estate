import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/property.dart';
import 'package:real_estate/ui/account.dart';
import 'package:real_estate/ui/add_property.dart';
import 'package:real_estate/ui/auth/login_screen.dart';
import 'package:real_estate/ui/auth/registration_screen.dart';
import 'package:real_estate/ui/chat_screen.dart';
import 'package:real_estate/ui/my_fav.dart';
import 'package:real_estate/ui/my_property.dart';
import 'package:real_estate/ui/prop_screen.dart';
import 'package:real_estate/ui/saved_search.dart';
import 'package:real_estate/ui/search.dart';
import 'package:real_estate/ui/search_results.dart';
import 'package:real_estate/ui/setLocation.dart';

// Generate all application routes with simple transition
Route<PageController> onGenerateRoute(RouteSettings settings) {
  Route<PageController> page;

  final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;

  switch (settings.name) {
    case "/Home":
      page = PageTransition<PageController>(
          child: MyHomePage(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/login":
      page = PageTransition<PageController>(
          child: LoginScreen(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/Registration":
      page = PageTransition<PageController>(
          child: Registration(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/Account":
      page = PageTransition<PageController>(
          child: Account(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/MyProps":
      page = PageTransition<PageController>(
          child: LoadMyProps(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/AddProp":
      page = PageTransition<PageController>(
          child: AddProp(
            address: args["address"],
          ),
          type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/AutoLocate":
      page = PageTransition<PageController>(
          child: AutoLocate(
            lat: args["lat"],
            long: args["long"],
            choice: args["choice"],
          ),
          type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/Search":
      page = PageTransition<PageController>(
          child: SearchScreenLoad(search: args["search_title"]),
          type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/PropScreen":
      page = PageTransition<PageController>(
          child: PropScreen(prop: args["prop"] as Property),
          type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/ChatScreen":
      page = PageTransition<PageController>(
          child: ChatScreen(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/PerviousSearch":
      page = PageTransition<PageController>(
          child: SavedSearchLoad(),
          type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/FavProps":
      page = PageTransition<PageController>(
          child: LoadMyFav(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/SearchResult":
      page = PageTransition<PageController>(
          child: SearchResults(
            state: args["state"],
            firstPrice: args["minPrice"],
            secondprice: args["maxPrice"],
            timeAdded: args["timeAdded"],
            type: args["propType"],
            roomMax: args["roomMax"],
            roomMin: args["roomMin"],
            furn: args["furn"],
          ),
          type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/SearchRes":
      page = PageTransition<PageController>(
          child: MySearchProperties(
            props: args["props"],
          ),
          type: PageTransitionType.rightToLeftWithFade);
      break;
  }

  return page;
}
