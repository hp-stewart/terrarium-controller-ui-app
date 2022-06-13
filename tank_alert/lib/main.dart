// created according to the following tutorial on Youtube:
// Title: Flutter & Firebase App Tutorial
// Author: The Net Ninja
// progress: Videos 1 - 6


import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tank_alert/homepage.dart';
import 'package:tank_alert/sched_BL.dart';
import 'package:tank_alert/sched_F.dart';
import 'package:tank_alert/sched_W.dart';
import 'package:tank_alert/schedule.dart';
import 'package:tank_alert/history.dart';
import 'package:tank_alert/sched_RL.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBMrIvuFyhpDja62FriCuBRkIjMGVV3GI8",
      authDomain: "smart-mini-vivarium.firebaseapp.com",
      projectId: "smart-mini-vivarium",
      storageBucket: "smart-mini-vivarium.appspot.com",
      databaseURL: "https://smart-mini-vivarium-default-rtdb.firebaseio.com/",
      messagingSenderId: "250727653884",
      appId: "1:250727653884:android:17d0e5fc6f2e5721011279",
    ),
  );
  runApp(new MaterialApp(
      title: "Tank Alert",
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,

      ),
      routes: {
        '/': (context) => HomePage(),
        '/schedule': (context) => Schedule(),
        '/history': (context) => History(),
        '/schedRL': (context) => Sched_RL(),
        '/schedBL': (context) => Sched_BL(),
        '/schedW': (context) => Sched_W(),
        '/schedF': (context) => Sched_F(),
      },
      initialRoute: '/',),
  );
}