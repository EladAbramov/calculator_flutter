import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Calculator.dart';

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
            if (snapshot.connectionState == ConnectionState.done) {
              return Calculator();
            }
            return loading();

          }
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  loading() {
    return CircularProgressIndicator();
  }
}

