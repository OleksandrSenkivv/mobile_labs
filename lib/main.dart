import 'package:flutter/material.dart';
import 'package:mobile_labs/pages/home_page.dart';
import 'package:mobile_labs/pages/login_page.dart';
import 'package:mobile_labs/pages/profile_page.dart';
import 'package:mobile_labs/pages/signup_page.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/login',
  routes: {
    '/home': (context) => const Home(),
    '/profile': (context) => const Profile(),
    '/login': (context) => Login(),
    '/signup': (context) => SignUp(),
  },
),);

