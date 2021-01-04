//Author: Elad_Abramov - portfolio website: https://myportfolioelad.herokuapp.com/

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Calculator.dart';
import 'Splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot){
            if (snapshot.hasError) {
              print("no");
            }
            //check connection to firebase app
            if (snapshot.connectionState == ConnectionState.done) {
              return Splash();
            }
            return loading();

          }
      ),
      debugShowCheckedModeBanner: false,
      routes:
      {
        "Calculator": (context) => Calculator(),
      },
    );
  }

  loading() {
    return CircularProgressIndicator();
  }
}

