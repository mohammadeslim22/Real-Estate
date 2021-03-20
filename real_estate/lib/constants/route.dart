import 'package:flutter/material.dart';


// Generate all application routes with simple transition
Route<PageController> onGenerateRoute(RouteSettings settings) {
  Route<PageController> page;

  // TODO(ahmed): I will use it for send arguments to custom pages
  final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;

  switch (settings.name) {
    case "/Home":
      // page = PageTransition<PageController>(
      //     child: const Home(), type: PageTransitionType.rightToLeftWithFade);
      // break;
  
  }

  return page;
}
