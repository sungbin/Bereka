import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';
class User {
    String name;
    String car_model;
  String car_url;
    String email;

    String lp;
    String password;
    String uid;
    String phone;
  List<String> clients;

    DocumentReference reference;
  bool manager;

  static void workUser(String email,Function(User user) f) {
    Future<QuerySnapshot> snapshot = Firestore.instance.collection('userList').getDocuments();
    
    snapshot.then((val) {
      List<DocumentSnapshot> documents = val.documents;
      for (DocumentSnapshot sh in documents) {
        User _user = User.fromSnapshot(sh);
        if (_user.email == email) {
          f(_user);
        }
      }
    });
  }

    void getMessages(Function(List<Message>) f) {

      List<Message> messages = List<Message>();
      reference.collection('messages').getDocuments().then((val) {
        List<DocumentSnapshot> documents = val.documents;
        for(DocumentSnapshot sh in documents) {

          Message message = Message.fromSnapshot(sh);
          messages.add(message);
        }
        messages.sort((m1,m2) {
          return m2.time.microsecond - m1.time.microsecond;
        });
        f(messages);
      });
    }
  /*void getMessages(Function(List<Message>) f) {
    List<Message> messages = List<Message>();
    reference.collection('messages').getDocuments().then((val) {
      List<DocumentSnapshot> documents = val.documents;
      for(DocumentSnapshot sh in documents) {
        Message message = Message.fromSnapshot(sh);
        messages.add(message);
      }
      f(messages);
    });
  }*/

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['car_model'] != null),
        assert(map['email'] != null),
        assert(map['lp'] != null),
        assert(map['password'] != null),
        assert(map['uid'] != null),
        assert(map['phone'] != null),
        assert(map['manager'] != null),
        name = map['name'],
        car_model = map['car_model'],
        car_url = map['car_url'],
        email = map['email'],
        lp = map['lp'],
        uid = map['uid'],
        phone = map['phone'],
        password = map['password'],
        clients = List.from(map['clients']),
        manager = map['manager'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}