//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//
//class CabShareFormScreen extends StatefulWidget {
//  @override
//  _CabShareFormScreenState createState() => _CabShareFormScreenState();
//}
//
//class _CabShareFormScreenState extends State<CabShareFormScreen> {
//  var _fromVal;
//  var _toVal;
//  DateTime _selectedDate;
//  TimeOfDay _selectedTime;
//
//  Future<void> _selectDate(BuildContext context) async {
//    final DateTime pickedDate = await showDatePicker(
//      context: context,
//      initialDate: _selectedDate,
//      firstDate: DateTime.now(),
//      lastDate: DateTime.now().add(Duration(days: 4 * 365)),
//    );
//    if (pickedDate != null && pickedDate != _selectedDate) {
//      setState(() {
//        _selectedDate = pickedDate;
//      });
//    }
//  }
//
//  Future<void> _selectTime(BuildContext context) async {
//    final TimeOfDay pickedTime = await showTimePicker(
//      context: context,
//      initialTime: _selectedTime,
//    );
//    if (pickedTime != null && pickedTime != _selectedTime) {
//      setState(() {
//        _selectedTime = pickedTime;
//      });
//    }
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    _fromVal = 3;
//    _toVal = 1;
//    _selectedDate = DateTime.now();
//    _selectedTime = TimeOfDay.now();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Widget _buildFormItem(String hint, Widget child, [bool special = false]) {
//      return Column(
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        children: <Widget>[
//          Text(hint),
//          SizedBox(height: 10),
//          Container(
//            height: 52,
//            decoration: BoxDecoration(
//              color: Colors.grey.withOpacity(0.4),
//              borderRadius: BorderRadius.circular(8),
//            ),
//            child: Padding(
//              padding: EdgeInsets.symmetric(horizontal: special ? 8.0 : 20.0),
//              child: child,
//            ),
//          ),
//          SizedBox(height: 25),
//        ],
//      );
//    }
//
//    Widget _buildLocationDropDown([bool from = false]) {
//      return DropdownButton<int>(
//        value: from ? _fromVal : _toVal,
//        items: [
//          DropdownMenuItem(
//            child: Text('VIT Vellore'),
//            value: 0,
//          ),
//          DropdownMenuItem(
//            child: Text('VIT Chennai'),
//            value: 1,
//          ),
//          DropdownMenuItem(
//            child: Text('Bangalore Airport'),
//            value: 2,
//          ),
//          DropdownMenuItem(
//            child: Text('Chennai Airport'),
//            value: 3,
//          ),
//          DropdownMenuItem(
//            child: Text('Vellore Railway Station'),
//            value: 4,
//          ),
//          DropdownMenuItem(
//            child: Text('Chennai Railway Station'),
//            value: 5,
//          ),
//        ],
//        onChanged: (val) {
//          setState(() {
//            if(from)_fromVal = val;
//            else _toVal = val;
//          });
//        },
//        isExpanded: true,
//        underline: SizedBox(),
//      );
//    }
//
//    return Scaffold(
//      appBar: AppBar(
//        //centerTitle: true,
//        title: Text('New Cab Share Post'),
//      ),
//      body: SingleChildScrollView(
//        child: Padding(
//          padding: const EdgeInsets.all(20.0),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[
//              _buildFormItem(
//                'FROM',
//                _buildLocationDropDown(true),
//              ),
//              _buildFormItem(
//                'TO',
//                _buildLocationDropDown(),
//              ),
//              _buildFormItem(
//                'DATE',
//                FlatButton.icon(
//                  onPressed: () {
//                    _selectDate(context);
//                  },
//                  icon: Icon(Icons.calendar_today),
//                  label: Text(DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY)
//                      .format(_selectedDate)),
//                ),
//                true,
//              ),
//              _buildFormItem(
//                'TIME',
//                FlatButton.icon(
//                  onPressed: () {
//                    _selectTime(context);
//                  },
//                  icon: Icon(Icons.access_time),
//                  label: Text(_selectedTime.format(context)),
//                ),
//                true,
//              ),
//              _buildFormItem(
//                'DESCRIPTION (Optional)',
//                TextField(
//                  textCapitalization: TextCapitalization.sentences,
//                  decoration: InputDecoration(
//                    border: InputBorder.none,
//                  ),
//                ),
//              ),
//              RaisedButton(
//                child: Text('Submit'),
//                padding: const EdgeInsets.all(15),
//                color: Colors.white.withOpacity(0.9),
//                textColor: Colors.black,
//                onPressed: (){
//                  //TODO:
//                },
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
