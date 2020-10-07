import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptography/cryptography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_project/helpers/crypto_helper.dart';
import 'package:mobile_app_project/screens/compose_msg_screen.dart';
import 'package:mobile_app_project/screens/profile_screen.dart';

class PendingMsgsScreen extends StatefulWidget {
  final FirebaseUser user;

  PendingMsgsScreen(this.user);

  //List<DocumentSnapshot> messages = [];
  // on taping message, decrypt the message open a dialogue box or something
  // When timer completes pop it and on pop delete the message

  @override
  _PendingMsgsScreenState createState() => _PendingMsgsScreenState();
}

class _PendingMsgsScreenState extends State<PendingMsgsScreen> {
  Future<List<DocumentSnapshot>> fetchMessages() async {
    //time of gettingcurrentuser error
    final uid = widget.user.uid;
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    //documents.forEach((data) => print(data));
    return documents;
  }

  Future<void> deleteMessage(sentAt) async {
    final uid = widget.user.uid;
    final result = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('messages')
        .where('sentAt', isEqualTo: sentAt)
        .getDocuments()
        .then((value) {
      for (DocumentSnapshot ds in value.documents) {
        ds.reference.delete();
      }
    });
  }

  Future<PublicKey> getSenderPublicKey(CryptoHelper cryptoHelper,String docId) async{
    final snap = await Firestore.instance.collection('users').document(docId).get();
    final val = snap.data['pubKey'];
    final pubKey = cryptoHelper.strToPubKey(val);
    return pubKey;
  }

  Future<void> _secureScreen() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }


  @override
  void initState() {
    _secureScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Messages'),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Profile'),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text('Logout'),
                  value: 1,
                ),
              ];
            },
            onSelected: (val) async {
              if (val == 1) {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
              } else if (val == 0) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen(
                      //widget.user.//photoUrl//email//displayName//phoneNumber
                      photoUrl: widget.user.photoUrl,
                      email: widget.user.email,
                      name: widget.user.displayName,
                    )));
              }
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: FutureBuilder(
          future: fetchMessages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
//            if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: (snapshot.hasData && snapshot.data.isNotEmpty)
                    ? ListView.builder(
                        //list size = 0 - no msgs
                        itemCount: snapshot.data.length,
                        padding: EdgeInsets.all(8),
                        itemBuilder: (ctx, index) {
                          return Column(
                            children: [
                              Container(
                                color: Colors.grey.withOpacity(0.3),
                                child: ListTile(
                                  leading: Icon(Icons.account_circle),
                                  title:
                                      Text(snapshot.data[index]['senderName']),
                                  trailing: Text(
                                      '${DateFormat('d/M/y H:m').format(snapshot.data[index]['sentAt'].toDate())}'),
                                  subtitle: Text('View Once'),
                                  onTap: () async {
                                    final cryptoHelper = CryptoHelper();
                                    //final decryptedText = await CryptoHelper().decryptMsg(snapshot.data[index]['message'], snapshot.data[index]['tempSecKey'], snapshot.data[index]['tempNonSecNonce']);
                                    final senderPubKey = await getSenderPublicKey(cryptoHelper,snapshot.data[index]['senderID']);
                                    final receiverPrivKey = await cryptoHelper.getPrivKey(widget.user.uid);

                                    final decryptedText = await cryptoHelper.decryptMsg(snapshot.data[index]['message'], snapshot.data[index]['tempNonSecNonce'], senderPubKey, receiverPrivKey);
                                    await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      //maybe true if replay feature exist!
                                      child: WillPopScope(
                                        onWillPop: () async {
                                          return false;
                                        },
                                        child: Dialog(
                                          elevation: 50,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ), //this right here
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Container(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              snapshot.data[
                                                                      index][
                                                                  'senderName'],
                                                              style: TextStyle(
                                                                  fontSize: 26,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              'on ${DateFormat('d/M/y H:m').format(snapshot.data[index]['sentAt'].toDate())}',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      CircularCountDownTimer(
                                                        // Countdown duration in Seconds
                                                        duration:
                                                            snapshot.data[index]
                                                                ['timer'],

                                                        // Width of the Countdown Widget
                                                        width: 60,

                                                        // Height of the Countdown Widget
                                                        height: 60,

                                                        // Default Color for Countdown Timer
                                                        color: Colors.white,

                                                        // Filling Color for Countdown Timer
                                                        fillColor: Colors.red,

                                                        // Border Thickness of the Countdown Circle
                                                        strokeWidth: 7.0,

                                                        // Text Style for Countdown Text
                                                        textStyle: TextStyle(
                                                            fontSize: 11.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),

                                                        // true for reverse countdown (max to 0), false for forward countdown (0 to max)
                                                        isReverse: true,

                                                        // Optional [bool] to hide the [Text] in this widget.
//                                                      isTimerTextShown: true,

                                                        // Function which will execute when the Countdown Ends
                                                        onComplete: () async {
                                                          await deleteMessage(
                                                              snapshot.data[
                                                                      index]
                                                                  ['sentAt']);
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          Text(
                                                            decryptedText,
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Spacer(),
                                                    FlatButton(
                                                      onPressed: () async {
                                                        await deleteMessage(
                                                            snapshot.data[index]
                                                                ['sentAt']);
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {});
                                                      },
                                                      child: Text('Done'),
                                                      textColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                //padding: EdgeInsets.all(3),
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        },
                      )
                    : SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 8,
                              width: double.infinity,
                            ),
                            Text(
                              'No pending messages!',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Image.asset(
                                'lib/images/waiting.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
//          CryptoHelper().Printy();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ComposeMsgsScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
