import 'package:flutter/material.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'feedback.dart';
import 'estimate.dart';
import 'receiveMessage.dart';
import 'message.dart';

class ManagerPage extends StatefulWidget {
  List<User> users;
  List<User> clients;
  User manager;
  ManagerPage(this.users,this.manager,this.clients);
  @override
  _ManagerPageState createState() => _ManagerPageState(users,manager,clients);
}

class _ManagerPageState extends State<ManagerPage> {

  List<User> users;
  List<User> clients;
  User manager;
  _ManagerPageState(this.users,this.manager,this.clients);
  String clientId = "";

  
  bool check_model = false;
  bool check_name = false;
  bool check_lp = false;
  bool check_all = true;


AutoCompleteTextField searchTextField;
GlobalKey<AutoCompleteTextFieldState<User>> key = GlobalKey();

bool searched = false;

  void updateList(String phone) {
    print(phone);
    String str1 = phone.toString().substring(0,3);
    String str2 = phone.toString().substring(3,7);
    String str3 = phone.toString().substring(7);
    String p = str1 + '-' + str2 + '-' + str3;
    for(User u in users) {
      if(u.phone == p) {
        setState(() {
          clients.add(u);
        });
        manager.reference.updateData({'clients':FieldValue.arrayUnion(clients)});
      }
    }
    print(p);
  }
  final dialogController = TextEditingController();
  final messageController = TextEditingController();
  final messageController2 = TextEditingController();


  void _showDialog() {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('핸드폰 번호를 입력하시오'),
          content:TextField(
            controller: dialogController,
            keyboardType: TextInputType.number,
          ),
          
          actions: <Widget>[
            FlatButton(
              // color: Colors.blueGrey,
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Submit',style: TextStyle(color: Colors.white),),
              onPressed: () {
                updateList(dialogController.text);
                Navigator.of(context).pop();
              },
              color: Colors.blueAccent,
            ),
          ],
        );
      }
    );
  }

  Widget build(BuildContext context) {
    // List<SendEstimate> sendEstimates;
    List<Map<SendEstimate,User>> ests;
    setState(() {
      ests = List<Map<SendEstimate,User>>();
                    for(User u in clients) {
                      SendEstimate.getEstimates(u, (es) {
                        for(SendEstimate e in es) {
                          var m =  Map<SendEstimate,User>();
                          m[e] = u;
                          ests.add(m);
                        }
                      });
                    }
    });
      
      return Scaffold(
        appBar: AppBar(
          title: Text('피드백 보내기'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.alarm),
              onPressed: () {
                
                print(ests.length);
                Navigator.push(context,MaterialPageRoute(builder: (context) => 
                    Scaffold(
                      appBar: AppBar(),
                      body: ListView.builder(
                        itemCount: ests.length,
                        itemBuilder: (context,count) {
                          Map<SendEstimate,User> est = ests[count];
                          SendEstimate  esti = est.keys.elementAt(0);
                          User writer = est.values.elementAt(0);
                          TextStyle st1 = TextStyle(fontSize: 21,);
                          TextStyle st2 = TextStyle(fontSize: 10,color: Colors.grey);
                          TextStyle st3 = TextStyle(fontSize: 10,color: Colors.blue);


                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('메세지 보기'),
                                    content: Column(
                                      children: <Widget>[
                                        Image.network(esti.car_image),
                                        Text(esti.contents,style:st1),
                                        Text(writer.email,style: TextStyle(fontSize: 16,color: Colors.grey),),
                                        Text(esti.time.toString(),style: TextStyle(fontSize: 16,color: Colors.blue)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            RaisedButton(
                                              padding: const EdgeInsets.all(8.0),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('close'),
                                              color: Colors.grey,
                                            ),
                                            RaisedButton(
                                              padding: const EdgeInsets.all(8.0),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('답장보내기'),
                                                      content: Column(
                                                        children: <Widget>[
                                                          TextField(
                                                            controller: messageController,
                                                            decoration: InputDecoration(
                                                              hintText: '보낼 내용',
                                                            ),
                                                          ),
                                                          TextField(
                                                            controller: messageController2,
                                                            decoration: InputDecoration(
                                                              icon: Icon(Icons.monetization_on)
                                                            ),
                                                            keyboardType: TextInputType.number,
                                                          ),
                                                        ],
                                                      ),
                                                      
                                                      
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          // color: Colors.blueGrey,
                                                          child: Text('Close'),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child: Text('Send',style: TextStyle(color: Colors.white),),
                                                          onPressed: () {
                                                            ReceiveEstimate.addEstiamte(writer, messageController.text, manager.email, int.parse(messageController2.text),esti.id);
                                                            messageController.clear();
                                                            messageController2.clear();
                                                            dialogController.clear();
                                                            Navigator.of(context).pop();
                                                          },
                                                          color: Colors.blueAccent,
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                );
                                              },
                                              child: Text('답장 보내기',style: TextStyle(color: Colors.white),),
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Card(
                                child: 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                  Text(esti.contents.substring(0,14) + '...',style: st1,),
                                  Column(
                                    children: <Widget>[
                                      Text(writer.email,style: st2),
                                      Text(esti.time.toString(),style: st3)
                                    ],
                                  ),
                                ],),
                                
                              ),
                            )
                            
                          );
                        },
                      ),
                    )
                  )
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showDialog,
          child: Icon(Icons.add,),
        ),
        body: Column(
          children: <Widget>[
            searchTextField = AutoCompleteTextField<User>(
              textSubmitted: (val) {
                setState(() {
                  searched = true;
                  searchTextField.textField.controller.text = val.toString();
                });
              },
              submitOnSuggestionTap: true,
              key: key,
              clearOnSubmit: false,
              suggestions: clients,
              style: TextStyle(color: Colors.black,fontSize: 16.0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                hintText: "Search",
                hintStyle: TextStyle(color:Colors.black),
              ),
              itemFilter: (item, query) {
                if(check_model)
                  return item.car_model.toLowerCase().contains(query.toLowerCase());
                else if(check_lp)
                  return item.lp.toLowerCase().contains(query.toLowerCase());
                else if(check_name)
                  return item.name.toLowerCase().contains(query.toLowerCase());
                else
                  return item.car_model.toLowerCase().contains(query.toLowerCase()) || item.lp.toLowerCase().contains(query.toLowerCase()) || item.name.toLowerCase().contains(query.toLowerCase());
              },
              itemSorter: (a,b) {
                return a.car_model.compareTo(b.car_model);
              },
              itemSubmitted: (item) {
                setState(() { 
                  searched = true;
                  if(check_model) {
                    searchTextField.textField.controller.text = item.car_model.toString();
                  } else if(check_lp) {
                    searchTextField.textField.controller.text = item.lp.toString();
                  } else if(check_name || check_all) {
                    searchTextField.textField.controller.text = item.name.toString();
                  }
                });
              },
              itemBuilder: (context,item) {
                return row(item);
              },
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('All'),
                    Checkbox(value: check_all, onChanged: (val) {
                      setState(() {
                        check_all = true;
                        check_model = false;
                        check_lp = false;
                        check_name = false;
                      });
                    },),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Name'),
                    Checkbox(value: check_name, onChanged: (val) {
                      setState(() {
                        check_all = false;
                        check_model = false;
                        check_lp = false;
                        check_name = true;
                      });
                    },),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Model'),
                    Checkbox(value: check_model, onChanged: (val) {
                      setState(() {
                        check_all = false;
                        check_model = true;
                        check_lp = false;
                        check_name = false;
                      });
                    },),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('번호판'),
                    Checkbox(value: check_lp, onChanged: (val) {
                      setState(() {
                        check_all = false;
                        check_model = false;
                        check_lp = true;
                        check_name = false;
                      });
                    },),
                  ],
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Model'),
                Text('번호판'),
                Text('Name'),
                Text('Phone'),
              ],
            ),
            Expanded(
              child: searched ? _buildUserList(context) :_buildAllUserList(context),
            ),
            
          ],
        )
          // ],
      );
  }
  Widget row(User user) {
    double fs = 20;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        check_all ? Text(user.car_model, style: TextStyle(fontSize: fs),) : check_lp || check_name? Text(user.lp, style: TextStyle(fontSize: fs),) : check_model ? Text(user.car_model,style: TextStyle(fontSize: fs)) : Text(''),
        SizedBox(width: 10.0,),
        Text(user.name, style: TextStyle(fontSize: fs)),
      ],
    );
  }

  ListView _buildAllUserList(context) {

    List<User> subUsers = List<User>();

    setState(() {
      subUsers.addAll(clients);
    });
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: subUsers.length,
      // A callback that will return a widget.
      itemBuilder: (context, count) {
        User u = subUsers[count];
        return GestureDetector(
          onTap: () {
            print(u.email);

            _showInfoDialog(u);
            // Navigator.push(context,MaterialPageRoute(builder: (context) => FeedbackPage(u)),);
          },
          child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text(u.car_model),
                  Text(u.lp),
                  Text(u.name),
                  Text(u.phone),
                ],
                ),
              ),
        ),
        );
      },
    );
  }

  ListView _buildUserList(context) {

    List<User> subUsers = List<User>();

    setState(() {

    for(User user in clients) {
      if(!searched)
        subUsers.add(user); else 

      if((check_model || check_all) && user.car_model.toLowerCase().contains(searchTextField.textField.controller.text.toLowerCase())) {
        subUsers.add(user);
      }
      else if((check_lp || check_all)&& user.lp.toLowerCase().contains(searchTextField.textField.controller.text.toLowerCase())){
        subUsers.add(user);
      }
      else if((check_name || check_all) && user.name.toLowerCase().contains(searchTextField.textField.controller.text.toLowerCase())) {
        subUsers.add(user);
      }
    }
    });
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: subUsers.length,
      // A callback that will return a widget.
      itemBuilder: (context, count) {
        User u = subUsers[count];
        return GestureDetector(
          onTap: () {
            _showInfoDialog(u);
          },
          child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text(u.car_model),
                  Text(u.lp),
                  Text(u.name),
                  Text(u.phone),
                ],
                ),
              ),
        ),
        );
      },
    );
  }
  
  void  _showInfoDialog(User u) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Text(u.email),
              Text(u.car_model),
              Text(u.lp),
            ],
          ),
          content: Column(
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      TextEditingController messageController = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('메세지 보내기'),
                            titleTextStyle: TextStyle(color: Colors.blue),
                            content: Column(
                              children: <Widget>[
                                TextField(
                                  controller: messageController,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RaisedButton(
                                      padding: const EdgeInsets.all(8.0),
                                      onPressed: () {

                                        Navigator.of(context).pop();
                                      },
                                      child: Text('close'),
                                      color: Colors.grey,
                                    ),
                                    RaisedButton(
                                      padding: const EdgeInsets.all(8.0),
                                      onPressed: () {
                                        // messageController.text;
                                        Message newMessage = Message(manager.email, DateTime.now(), messageController.text, u.reference.collection('messages').document());
                                        newMessage.reference.setData( // new Document
                                        {
                                            'time' : Timestamp.fromDate(newMessage.time),
                                            'manager' : newMessage.manager,
                                            'message' : newMessage.message,
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('send'),
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      );
                    },
                    child: Text("메세지 보내기"),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => FeedbackPage(u,manager)),);
                    },
                    child: Text("평가서 보내기"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
