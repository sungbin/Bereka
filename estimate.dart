import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
class ReceiveEstimate {
 final String contents;
 final int id;
 final String manager;
 final int price;
 final DateTime time;
 
 final DocumentReference reference;

 static void addEstiamte(User u, String contents, String manager, int price, int feedback_id) {
    DocumentReference refer = u.reference.collection('receive_estimate').document();
    
    u.reference.collection('receive_estimate').getDocuments().then((val) {
      refer.setData(
      {
        'contents' :contents,
        'feedback_id' :feedback_id,
        'manager' :manager,
        'price' :price,
        'time' : Timestamp.now()
      }
      );
    });
 }

 static void getEstimates(User user,Function(List<ReceiveEstimate>) f) {
   user.reference.collection('receive_estimate').getDocuments().then((val) {
     List<ReceiveEstimate> estimates = List<ReceiveEstimate>();
     for(DocumentSnapshot sh in val.documents) estimates.add(ReceiveEstimate.fromSnapshot(sh));
     f(estimates);
   });
 }

 ReceiveEstimate(
   this.manager,
   this.contents,
   this.reference,
   this.id,
   this.price,
   this.time
 );

 ReceiveEstimate.fromMap(Map<String, dynamic> map, {this.reference})
     : 
       assert(map['manager'] != null),
       assert(map['contents'] != null),
       assert(map['feedback_id'] != null),
       assert(map['price'] != null),
       assert(map['time'] != null),
       manager = map['manager'],
       contents = map['contents'],
       id = map['feedback_id'],
       price = map['price'],
       time = DateTime.fromMillisecondsSinceEpoch(map['time'].millisecondsSinceEpoch);

 ReceiveEstimate.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);
}
class SendEstimate {
 final String car_image;
 final String contents;
 final int id;
 final DateTime time;
 final DocumentReference reference;

 SendEstimate(
   this.car_image,
   this.contents,
   this.reference,
   this.id,
   this.time
 );

 SendEstimate.fromMap(Map<String, dynamic> map, {this.reference})
     : 
       assert(map['car_image'] != null),
       assert(map['contents'] != null),
       assert(map['id'] != null),
       assert(map['time'] != null),
       car_image = map['car_image'],
       contents = map['contents'],
       id = map['id'],
       time = DateTime.fromMillisecondsSinceEpoch(map['time'].millisecondsSinceEpoch);

 SendEstimate.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);


  static void addEstiamte(User u, String contents, String car_image) {
    DocumentReference refer = u.reference.collection('send_estimate').document();
    
    u.reference.collection('send_estimate').getDocuments().then((val) {
      int newId = val.documents.length;
      refer.setData(
      {
        'contents' :contents,
        'id' :newId,
        'car_image' :car_image,
        'time' : Timestamp.now()
      }
      );
    });
 }

 static void getEstimates(User user,Function(List<SendEstimate>) f) {
   user.reference.collection('send_estimate').getDocuments().then((val) {
     List<SendEstimate> estimates = List<SendEstimate>();
     for(DocumentSnapshot sh in val.documents) estimates.add(SendEstimate.fromSnapshot(sh));
     f(estimates);
   });
 }
}