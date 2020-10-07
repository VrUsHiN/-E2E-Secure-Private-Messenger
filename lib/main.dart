import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_project/screens/login_screen.dart';
import 'package:mobile_app_project/screens/pending_msgs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Give me a title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      darkTheme: ThemeData.dark().copyWith(
//        scaffoldBackgroundColor: Colors.black,
//      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {

//  Future<bool> isFirstTime() async {
//    var pref = await SharedPreferences.getInstance();
//    var isFirstTime = pref.getBool('first_time');
//    if (isFirstTime != null && !isFirstTime) {
//      pref.setBool('first_time', false);
//      return false;
//    } else {
//      pref.setBool('first_time', false);
//      return true;
//    }
//  }

  @override
  Widget build(BuildContext context) {
//    Test();
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context,userSnapshot){
          if(userSnapshot.connectionState==ConnectionState.waiting){
            return Scaffold(body: Center(child: Container(color: Colors.white,child: Text('Loading...',))));//Show SplashScreen
          }
          if(userSnapshot.hasData){
            FirebaseUser user = userSnapshot.data;
            return PendingMsgsScreen(user);//CabShareScreen();//
          }
          return LoginScreen();//wrap with a widget so to choose a username
        },
      );
  }
}


