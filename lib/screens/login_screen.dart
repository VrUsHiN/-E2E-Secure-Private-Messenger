import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app_project/helpers/crypto_helper.dart';
import 'package:cryptography/cryptography.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project App'),
      ),
      body: SignInButtonBody(),
    );
  }
}

class SignInButtonBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        child: SignInButton(
          Buttons.Google,
          text: 'Sign up with Google',
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () {
            _handleSignIn(context);
          },
        ),
      ),
    );
  }

  Future<void> _handleSignIn(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await _auth.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;
      if (user == null) {
        throw Exception();
        //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Some error occurred. Please try again!',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),backgroundColor: Colors.red,));
      }

//      await Firestore.instance.collection('users').document(user.uid).setData({
//        'username': user.displayName,
//        'email': user.email,
//      });

      Map<String,dynamic> upload = {
        'username': user.displayName,
        'email': user.email,
      };

      final newUser = authResult.additionalUserInfo.isNewUser;
      if(newUser){
        //first time
        final cryptoHelper = CryptoHelper();
        KeyPair keyPair = await cryptoHelper.generateKeyPair();

        //for public key
        final strPubKey = cryptoHelper.pubKeyToStr(keyPair.publicKey);
//        await Firestore.instance.collection('users').document(user.uid).updateData({
//          'pubKey': strPubKey,
//        });
        upload.putIfAbsent('pubKey', () => strPubKey);
        //print(keyPair.publicKey.toString()+":BBBBBBBBBB:"+upload['pubKey']);

        //for private key
        await cryptoHelper.storePrivKey(keyPair.privateKey, user.uid);
      }

      await Firestore.instance.collection('users').document(user.uid).setData(upload,merge: true);

    } on Exception catch (error) {
      print("**********"+error.toString());
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Some error occurred. Please try again!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ));
      print(error);
    }
  }
}
