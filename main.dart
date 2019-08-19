import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'myusage.dart';
import 'repair.dart';
import 'support.dart';
import 'profile.dart';
import 'signup.dart';
import 'user.dart';
import 'manager.dart';
import 'findCarCenter.dart';
import 'message.dart';
import 'QnA.dart';
import 'estimate.dart';


void main() => runApp(MyApp());

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
String uid;
FirebaseUser user;
bool avatar_photo = false;
String default_url = "https://firebasestorage.googleapis.com/v0/b/final-f741c.appspot.com/o/default_img.png?alt=media&token=aa334b33-ff9b-4c55-9d59-73d2ae82d2f2";
bool _success;

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bereka',
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {


  final drawerItems = [
    DrawerItem("내 페이지", Icons.home),
    DrawerItem("수리견적", Icons.sync),
    DrawerItem("이용내역", Icons.search),
    DrawerItem("고객 지원 센터", Icons.location_city),
    DrawerItem("Q&A", Icons.insert_chart),
//    DrawerItem("주변 카센터 찾기", Icons.map)
  ];
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  var drawerOptions = <Widget>[];
  final TextEditingController _searchController = new TextEditingController();
  String search_val;

  PageController _pageController;
  int currentPage = 1;
  User corr_user;
  DocumentReference reference;
  bool check = false;

  @override
  void initState(){
    super.initState();
    _success = false;
    _pageController = PageController(
      initialPage: currentPage,
      keepPage: false,
      viewportFraction: 0.5,
    );
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
      Navigator.of(context).pop(); // close the drawer

      if(index == 0) {

      } else if(index == 1) {
        print(user.email);
        User.workUser(user.email, (u) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RepairPage(u)), //수리 견적서
          );
        });
      } else if(index == 2) {
        User.workUser(user.email, (User u) { //TODO: this is user part
          SendEstimate.getEstimates(u, (sendList) {
            ReceiveEstimate.getEstimates(u, (receiveList) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyUsagePage(sendList,receiveList)),
              );
            });
          });
        });
      } else if(index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SupportPage()),
        );
      } else if(index == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QnAPage()),
        );
      } /*else if(index == 5){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FindCarCenter()),
        );
      }*/
      _selectedDrawerIndex = 0;
    });
  }

  Widget setupAlertDialogContainer(List<Message> messages) {
    return Container(
      height: 400.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
      shrinkWrap: true,
      itemCount: messages.length,//_str_messages.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading:  Text(messages[index].manager + "\n"),
          trailing: Text("\n\n" + messages[index].message + "\n" +  messages[index].time.toString()), //_str_messages.elementAt(index)),
        );
      },
    ),
    );
  }

  User getCurrentUser(){
    if(user != null){
      Future<QuerySnapshot> snapshot= Firestore.instance.collection('userList').getDocuments();
      snapshot.then((val) {
        List<DocumentSnapshot> documents = val.documents;
        for(DocumentSnapshot sh in documents) {
          User _user = User.fromSnapshot(sh);
          print(user.uid);
          print(_user.uid);
          if(user.uid == _user.uid){
            corr_user = _user;
            print(corr_user.name);
            check = true;
          }
        }
      });
      return corr_user;
    }
    else
      return null;
  }


  @override
  Widget build(BuildContext context) {

    drawerOptions = <Widget>[];
    for (var i = 1; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          ListTile(
            leading: Icon(d.icon),
            title: Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bereka",
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.alarm),
            onPressed: () {
//              getMessages(f)
              setState(() {
                User.workUser(user.email, (u) {
                  u.getMessages((messages) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alarm List'),
                            content: setupAlertDialogContainer(messages),
                          );
                        }
                    );
                  });
                });
              });
            },
          ),
          IconButton(
            icon: Icon(
                _success == false
                    ?
                Icons.lock
                    :
                Icons.lock_open
            ),
            onPressed: () async {

              print(_success);
              if(_success == false){
                print("lock pressed");
                avatar_photo = true;
                _showLoginDialog();
//                await getCurrentUser();

                setState(() {
//                  _success = true;
//                  user.reload();
                  avatar_photo = true;
                });

//                corr_user = user;
              }

//              if(_success)

            },
          ),
        ],
      ),
      drawer: get_drawer(),
      body: Column(
//        child: Text('data'),
        children: <Widget>[

          SizedBox(height: 40),
          Row(
            children: <Widget>[
              Flexible(
                child:  Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                        decoration: InputDecoration(
                          hintText: "Search..",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (val){
                          search_val = val;
                        }
                    ),
                  ),
                ),
              ),

              IconButton(
                  icon: Icon(Icons.search),

                  onPressed: () {
                    print('searching...');
                  }
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          new Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
//              avatar_photo == false ? default_url :
              Image.network(_success == false ? default_url : getCurrentUser() == null ? "" : corr_user.uid != user.uid ? default_url : corr_user.car_url, width: 300, height: 300, fit: BoxFit.scaleDown),
              Container(
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(_success == false ? "" : getCurrentUser() == null ? "" : corr_user.uid != user.uid ? "" : corr_user.car_model + " "
                        + corr_user.uid != user.uid ? "" : corr_user.name, style: TextStyle(color: Colors.white),)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut().then((_){
      print('_signOut method logged out');

      setState(() {
        _success = false;
      });
      _googleSignIn.signOut();
    });
    print(_success);
  }

  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _success = true;

      } else {
        _success = false;
      }

      if(_success){
        Navigator.pushNamed(context, '/home');
      }
    });
  }


  void _showLoginDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Container(
              height: 100,
              width: double.infinity,

              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      height: 50,
                      width: double.infinity,
                      child: _GoogleSignInSection()
                  )
              ),
            ),
          );
        }
    );

  }

  animateItemBuilder(int index){
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child){
        double value = 1;
        if(_pageController.position.haveDimensions){
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 250,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        color: index % 2 == 0 ? Colors.grey : Colors.black,
      ),
    );
  }

  Drawer get_drawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.cyan,
              child: new Image.network(
                _success == false ? "" : user == null ? "" : user.photoUrl,
//                user == null ? "" : user.photoUrl,
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text("Pages", style: TextStyle(fontSize: 20),), accountEmail: Text(avatar_photo ==  false ? "" : user == null ? "" : user.email.toString()),//user == null ? "" : user.email.toString()),
            onDetailsPressed: () async {
              print('profile setting');

              if(user != null){
                /*Future<QuerySnapshot> snapshot= Firestore.instance.collection('userList').getDocuments();
                snapshot.then((val) {
                  List<DocumentSnapshot> documents = val.documents;
                  for(DocumentSnapshot sh in documents) {
                    User _user = User.fromSnapshot(sh);
                    print(user.uid);
                    print(_user.uid);
                    if(user.uid == _user.uid){
                      corr_user = _user;
                      print(corr_user.name);
                      check = true;
                    }
                  }*/
//                  print(corr_user.name);
                  if(check == false){// || corr_user.name == null){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SignupPage()),);
                  }

                  else{
//                    print('corr_user name: ' + corr_user.name);
//                    print('car_url :' + corr_user.car_url);x
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePage(userInfo: corr_user)));
                  }

//                });
              }
            },

          ),

          Column(children: drawerOptions),
          Padding(
            padding: const EdgeInsets.fromLTRB(200, 150, 0, 0),
            child: IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () async{
                avatar_photo = false;
               await _signOut();
              },
            ),
          )
        ],
      ),
    );
  }
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
//            width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: RaisedButton(
            onPressed: () async {
              _signInWithGoogle();
//              avatar_photo = true;
//            _success = true;
            },
            child:Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.assignment_ind),
                  Center(
                    child: Text('Sign in Google', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),

            color: Colors.redAccent,
          ),
        ),
      ],
    );

  }

  // Example code of how to sign in with google.
  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    FirebaseUser currentUser = await _auth.currentUser();

    await Firestore.instance.collection('userList').getDocuments();
    
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _success = true;
      } else {
        _success = false;
      }
    });
    QuerySnapshot snapshot = await Firestore.instance.collection('userList').getDocuments();
    if(_success){
        Navigator.pop(context);
        User.workUser(user.email, (u) {
          if(u.manager) {
            print(u.email);
            print('manager!');
            List<String> clients_email = u.clients;
            List<User> clients = List<User>();
            List<User> _users = List<User>();
              List<DocumentSnapshot> documents = snapshot.documents;
              for (DocumentSnapshot sh in documents) {
                User _user = User.fromSnapshot(sh);
                _users.add(_user);
                if (clients_email.contains(_user.email)) {
                  clients.add(_user);
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManagerPage(_users,u,clients)), //수리 견적서
              );
          }
        });
      }
  }
}