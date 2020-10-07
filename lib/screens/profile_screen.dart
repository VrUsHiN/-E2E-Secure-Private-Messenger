import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  //photoUrl//email//displayName//phoneNumber
  final photoUrl;
  final email;
  final name;
  ProfileScreen({this.photoUrl,this.email,this.name});

  @override
  Widget build(BuildContext context) {
    const sizedbox = SizedBox(height: 25);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(width: double.infinity),
              CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                radius: 50.0,
              ),
              SizedBox(
                height: 20.0,
                width: 150.0,
                child: Divider(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Source Sans Pro',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.mail,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: FittedBox(
                    child: Text(
                      email,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Source Sans Pro',
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
