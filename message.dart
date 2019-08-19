import 'package:cloud_firestore/cloud_firestore.dart';
class Message {
 final String manager;
 final String message;
 final DateTime time;
 final DocumentReference reference;

 Message(
   this.manager,
   this.time,
   this.message,
   this.reference,
 );

 Message.fromMap(Map<String, dynamic> map, {this.reference})
     : 
       assert(map['manager'] != null),
       assert(map['time'] != null),
       assert(map['message'] != null),
       manager = map['manager'],
       time = DateTime.fromMillisecondsSinceEpoch(map['time'].millisecondsSinceEpoch),
       message = map['message'];

 Message.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

}