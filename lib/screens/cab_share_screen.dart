//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:mobile_app_project/account_info.dart';
//import 'package:mobile_app_project/screens/cab_share_form_screen.dart';
//
//class CabShareScreen extends StatefulWidget {
//  @override
//  _CabShareScreenState createState() => _CabShareScreenState();
//}
//
//class _CabShareScreenState extends State<CabShareScreen> {
//  DateTime _selectedDate = DateTime.now();
//
//  Future<void> _selectDate(BuildContext context) async {
//    final DateTime pickedDate = await showDatePicker(
//      context: context,
//      initialDate: _selectedDate,
//      firstDate: DateTime.now(),
//      lastDate: DateTime.now().add(Duration(days: 4*365)),
//    );
//    if(pickedDate!=null && pickedDate!=_selectedDate){
//      setState(() {
//        _selectedDate = pickedDate;
//      });
//    }
//  }
//
//  Route _createRoute(Widget nextPage) {
//    return PageRouteBuilder(
//      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
//      transitionsBuilder: (context, animation, secondaryAnimation, child) {
//        var begin = Offset(1.0, 0.0);//
//        var end = Offset.zero;
//        var curve = Curves.easeInOut;//
//
//        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//        return SlideTransition(
//          position: animation.drive(tween),
//          child: child,
//        );
//      },
//    );
//  }
//
//
//  String name;
//  String phoneNumber;
//  String photoUrl;
//
//  @override
//  void initState() {
//    super.initState();
//    FirebaseUser user;
//    name = user.displayName;
//    photoUrl = user.photoUrl;
//    phoneNumber = user.phoneNumber;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text('Cab Share'),
//        actions: <Widget>[
//          Container(
//            margin: EdgeInsets.all(8),
//            decoration: BoxDecoration(
//              color: Colors.grey.withOpacity(0.3),
//              borderRadius: BorderRadius.circular(5),
//            ),
//            child: IconButton(
//              icon: Icon(Icons.add),
//              onPressed: () {
//                Navigator.of(context).push(_createRoute(CabShareFormScreen()));
//              },
//            ),
//          ),
//        ],
//      ),
//      body: SingleChildScrollView(
//        child: Padding(
//          padding: const EdgeInsets.all(10.0),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[
//              RaisedButton.icon(
//                color: Colors.grey.withOpacity(0.35),
//                padding: const EdgeInsets.all(12),
//                icon: Icon(Icons.calendar_today),
//                label: Text(DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY).format(_selectedDate)),
//                onPressed: () {
//                  _selectDate(context);
//                },
//              ),
//              Card(
//                color: Colors.grey.withOpacity(0.35),
//                margin: EdgeInsets.symmetric(vertical: 15),
//                child: Container(
//                  child: Row(
//                    children: [
//                      CircleAvatar(
//                        child: Image.network(photoUrl),
//                        radius: 10,
//                      ),
//                      Text(name),
//                      Text(phoneNumber),
//                    ],
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
