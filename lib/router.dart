import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

//Auth
import './features/pages/register_page.dart';

//Treasure Hunt
import 'features/pages/home_page.dart';

//Logged In Routes
final loggedInRoutes = RouteMap(
  onUnknownRoute: (route) => const Redirect('/'),
  routes: {
    //Treasure Hunt Routes
    '/': (route) => const MaterialPage(child: HomePage()),
  },
);

//Logged Out Routes
final loggedOutRoutes = RouteMap(
  onUnknownRoute: (route) => const Redirect('/'),
  routes: {
    // Authentication Route
    '/': (route) => const MaterialPage(child: RegisterPage()),
  },
);
