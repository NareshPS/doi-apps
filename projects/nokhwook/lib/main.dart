import 'package:flutter/material.dart';
import 'package:nokhwook/pages/home.dart';
import 'package:nokhwook/pages/loading.dart';

void main () => runApp(MaterialApp(
  // home: Stage(),
  routes: {
    '/': (context) => const Loading(),
    '/home':(context) => const Home()
  },
));