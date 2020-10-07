import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptography/cryptography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app_project/helpers/crypto_helper.dart';

class ComposeMsgsScreen extends StatefulWidget {
  @override
  _ComposeMsgsScreenState createState() => _ComposeMsgsScreenState();
}

class _ComposeMsgsScreenState extends State<ComposeMsgsScreen> {
  final _msgController = TextEditingController();
  final _msgFocusNode = FocusNode();
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  static List<String> users = new List<String>();
  bool loading = true;
  var destroyTime = 5;
  var sendingMsg = false;
  FirebaseUser user;

  Future<void> getCurrentUser() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = await auth.currentUser();
  }

  Future<void> getUsers() async {
    try {
      users = [];
      await getCurrentUser();
      final uname = user.displayName;

      final response =
          await Firestore.instance.collection('users').getDocuments();

      response.documents.forEach((element) {
        print(element['username']);
        users.add(element['username']);
      });

      users.removeWhere((element) => element == uname);

      if (users != null) {
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  @override
  void initState() {
    _secureScreen();
    getUsers();
    print(users);
    super.initState();
  }

  Widget row(String user) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            user,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }

  Future<PublicKey> getReceiverPubKey(CryptoHelper cryptoHelper,QuerySnapshot toDoc) async{
    final val = await toDoc.documents[0].data['pubKey'];
    final pubKey = cryptoHelper.strToPubKey(val);
    return pubKey;
  }

  Future<void> _sendMessage(String to,String message,String tempNonSecNonce) async{
    _msgFocusNode.unfocus();

    final toDocument =  await Firestore.instance
    .collection('users')
    .where('username',isEqualTo: to).getDocuments();

    try{
      if(users.contains(to)){

        final cryptoHelper = CryptoHelper();

        final receiverPubKey = await getReceiverPubKey(cryptoHelper,toDocument);
        final senderPrivKey = await cryptoHelper.getPrivKey(user.uid);
        final encryptedText = await cryptoHelper.encryptMsg(message,receiverPubKey,senderPrivKey);

        toDocument.documents[0].reference.collection('messages').document(user.uid+' '+DateTime.now().toString()).setData({
          'senderName': user.displayName,
          'senderID': user.uid,
          'sentAt': Timestamp.fromDate(DateTime.now()),
          'message': encryptedText,
          'tempNonSecNonce': tempNonSecNonce,
          'timer': destroyTime,
        });
      }
      else{
        throw Exception('No user found!');
      }
      Navigator.of(context).pop();
    }
    catch(error){
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      //TOAST
      //Scaffold.of(context).showSnackBar(SnackBar(content: Text(error.toString()),backgroundColor: Colors.red,));
    }
    finally{
      setState(() {
        sendingMsg = false;
      });
      _msgFocusNode.unfocus();
      _msgController.clear();
      searchTextField.clear();
    }
  }

  Future<void> _secureScreen() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 60);
    return Scaffold(
      appBar: AppBar(
        title: Text('Compose Message'),
      ),
      body: Builder(
        builder: (context) => Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: 500,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'To: ',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              searchTextField = AutoCompleteTextField<String>(
                                key: key,
                                clearOnSubmit: false,
                                suggestions: users,
                                style: TextStyle(color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                                  hintText: "Search User",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                itemFilter: (item, query) {
                                  return item
                                      .toLowerCase()
                                      .startsWith(query.toLowerCase());
                                },
                                itemSorter: (a, b) {
                                  return a.compareTo(b);
                                },
                                itemSubmitted: (item) {
                                  setState(() {
                                    searchTextField.textField.controller.text = item;
                                  });
                                },
                                itemBuilder: (context, item) {
                                  // ui for the autocompelete row
                                  if (loading) {
                                    return CircularProgressIndicator();
                                  }
                                  return row(item);
                                },
                              ),
                            ],
                          ),
                          //Text('Search User Widget'), //firebase here - (no user found CASE)
                          sizedBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Message: ',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              //image_picker or textfield
                              TextField(
                                controller: _msgController,//encrpyt the message here-after
                                focusNode: _msgFocusNode,
                              ),
                            ],
                          ),
                          sizedBox,
                          Row(
                            children: [
                              Text(
                                'Destroy message in (secs): ',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(width: 15),
                              //Set Message Destruction Time
                              //flutter_material_pickers - 1(min) to 60(max) secs
                              RaisedButton(
                                child: Text('$destroyTime'),
                                onPressed: () {
                                  showMaterialNumberPicker(//
                                    context: context,
                                    title: 'Set Timer',
                                    maxNumber: 60,
                                    minNumber: 1,
                                    selectedNumber: destroyTime,
                                    onChanged: (val) {
                                      setState(() {
                                        destroyTime = val;
                                      });
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          sizedBox,
                        ],
                      ),
                    ),
                  ),
                ),
                RaisedButton.icon(
                  //firebase here - in messages collection of user with username, store encrypted file, timer value
                  //disable pop while sending message, show errors if any or confirmation
                  icon: Icon(Icons.send),
                  label: Text('Send Message'),
                  onPressed: () async{
                    setState(() {
                      sendingMsg = true;
                    });
                    await _sendMessage(searchTextField.textField.controller.text,_msgController.value.text,CryptoHelper.nonce);
                  },
                  elevation: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
            if (sendingMsg)
              Container(
                color: Colors.grey.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }
}
