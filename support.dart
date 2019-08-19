import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

User _user;
User _manager;

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {

  Widget getManagerInfo(){
    bool _isManager = false;
    Future<QuerySnapshot> snapshot= Firestore.instance.collection('userList').getDocuments();
    snapshot.then((val) {
//                List<User> _users = List<User>();

      List<DocumentSnapshot> documents = val.documents;
      for(DocumentSnapshot sh in documents) {
        _user = User.fromSnapshot(sh);
        print(_user.name);
        if(_user.manager){
//          print('manager : ' + _user.name);
          _manager = _user;

        _isManager = true;
          print(_manager.name);
          print(_manager.email);
          print(_manager.phone);
        }
      }
    });
/*
    if(_isManager)
      return _user;*/

//  return Text(" " + _manager.name + "\n Email : " + _manager.email + "\n PH \# \: " + _manager.phone);
  }

  Widget build(BuildContext context) {

    Future<QuerySnapshot> snapshot= Firestore.instance.collection('userList').getDocuments();
    snapshot.then((val) {
//                List<User> _users = List<User>();

      List<DocumentSnapshot> documents = val.documents;
      for(DocumentSnapshot sh in documents) {
        _user = User.fromSnapshot(sh);
        print(_user.name);
        if(_user.manager){
//          print('manager : ' + _user.name);
          _manager = _user;

          print(_manager.name);
          print(_manager.email);
          print(_manager.phone);
        }
      }
    });
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('고객 지원 센터'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              setState(() {
                getManagerInfo();

              });
              print(_manager.name);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Text(
            " 진영인\n Email: jinyi1187@gmail.com\n PH\# \: 010-4004-1187"
          ),
          Divider(color: Colors.black,),
//          getManagerInfo(),
          Text(" " + _manager.name + "\n Email : " + _manager.email + "\n PH \# \: " + _manager.phone),
          Divider(color: Colors.black,),

        ],
      ),
    );
  }
}