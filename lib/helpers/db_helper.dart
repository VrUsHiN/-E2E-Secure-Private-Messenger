//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:mobile_app_project/screens/cab_share_screen.dart';
//import 'package:mobile_app_project/screens/login_screen.dart';
//
//class DBHelper {
//  //static methods
//  final GoogleSignIn _googleSignIn = GoogleSignIn();
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//
//  static Widget initialScreen() {
//    return StreamBuilder(
//      stream: _auth.onAuthStateChanged,
//      builder: (context,userSnapshot){
//        if(userSnapshot.connectionState==ConnectionState.waiting){
//          return Center(child: Container());
//        }
//        if(userSnapshot.hasData){
//          return CabShareScreen();
//        }
//        return LoginScreen();
//      },
//    );
//  }
//}
