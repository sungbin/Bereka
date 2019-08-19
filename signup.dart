import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'user.dart';
import 'dart:io';
import 'dart:async';
import 'car.dart';

String default_url = "https://firebasestorage.googleapis.com/v0/b/final-f741c.appspot.com/o/default_img.png?alt=media&token=aa334b33-ff9b-4c55-9d59-73d2ae82d2f2";

class SignupPage extends StatefulWidget {
  SignupPage({this.name, this.email, this.phone_number, this.car_model, this.car_url, this.lp_number});

  String name;
  String email;
  String phone_number;
  String car_model;
  String lp_number;
  String car_url;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String name;
  String password;
  String confirm_password;
  String email;
  String phone_number;
  String car_model;
  String lp_number;
  String car_url;

//  File _imageFile;
  Future<File> _imageFile;



  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final _username_controller = new TextEditingController();
  final _password_controller = new TextEditingController();
  final _confirm_pw_controller = new TextEditingController();
  final _email_address_controller = new TextEditingController();
  final _car_model_controller = new TextEditingController();
  final _license_plate_controller  = new TextEditingController();
  final _phone_number_controller = new TextEditingController();


  @override
  void initState(){
    super.initState();
  }

  pickImageFromGallery(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: _imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: SafeArea(
            child: new Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),

              child: new Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: FormUI(),
              ),
            )),
      ),
    );
  }

  Widget FormUI(){
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _imageFile == null
            ?
        Container(
            child: Image.network(default_url)
        )
            :
        showImage(),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
                icon: Icon(
                    Icons.photo_camera,
                    color: Colors.black
                ),
                onPressed:(){
                  pickImageFromGallery(ImageSource.gallery);
//                  getImage();
                }
            ),
          ],
        ),

        new TextFormField(
          controller: _username_controller,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Username',
          ),
          keyboardType: TextInputType.text,
          validator: validateName,
          style: new TextStyle(
              height: 0.5
          ),

          onSaved: (String val){
            setState(() {
              name = val;
            });
          },

        ),

        new SizedBox(height: 12.0),

        new TextFormField( controller: _password_controller,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Password',
          ),
          obscureText: true,
          validator: validatePassword,
          style: new TextStyle(
              height: 0.5
          ),
          onSaved: (String val){
            setState(() {
              password = val;
            });
          },
        ),

        new SizedBox(height: 12.0),

        new TextFormField(
          controller: _confirm_pw_controller,
          decoration: const InputDecoration(
              filled: true,
              labelText: 'Confirm Password'
          ),
          obscureText: true,
          validator: validateConfirmPassword,
          style: new TextStyle(
              height: 0.5
          ),
          onSaved: (String val){
            setState(() {
              confirm_password = val;
            });
          },
        ),

        new SizedBox(height: 12.0),

        new TextFormField(
          controller: _email_address_controller,
          decoration: const InputDecoration(
              filled: true,
              labelText: 'Email Address'
          ),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          style: new TextStyle(
              height: 0.5
          ),
          onSaved: (String val){
            setState(() {
              email = val;
            });
          },

        ),

        new SizedBox(height: 12.0),

        new TextFormField(
          controller: _phone_number_controller,
          decoration: const InputDecoration(
              filled: true,
              labelText: 'Phone Number (with \"-\"\)'
          ),
          validator: validatePhoneNum,
          style: new TextStyle(
              height: 0.5
          ),
          onSaved: (String val){
            setState(() {
              phone_number = val;
            });
          },

        ),

        new SizedBox(height: 12.0),

        new TextFormField(
          controller: _car_model_controller,
          decoration: const InputDecoration(
              filled: true,
              labelText: 'Car Model'
          ),
          validator: validateCar,
          style: new TextStyle(
              height: 0.5
          ),
          onSaved: (String val){
            setState(() {
              car_model = val;
            });
          },

        ),

        new SizedBox(height: 12.0),

        new TextFormField(
          controller: _license_plate_controller,
          decoration: const InputDecoration(
              filled: true,
              labelText: 'License Plate \#'
          ),
          validator: validateLP,
          style: new TextStyle(
              height: 0.5
          ),
          onSaved: (String val){
            setState(() {
              lp_number = val;
            });
          },
        ),


        new RaisedButton(
          child: Text('SIGN UP'),
          onPressed: () async{

            _validateInputs();


            FirebaseUser user = await FirebaseAuth.instance.currentUser();
            List <User> clients = List<User>();
//            clients.add(0);
            if(name != null && password != null && email != null && phone_number != null && car_model != null && lp_number != null){
              Firestore.instance.collection('userList').add(
                  {
                    'uid' : user.uid,
                    'name' : name,
                    'password' : password,
                    'email' : email,
                    'phone' : phone_number,
                    'car_model' : car_model,
                    'lp' : lp_number,
                    'manager' : false,
                    'car_url' : _imageFile,
                    'clients' : FieldValue.arrayUnion(clients)
                  }
              ).then((documentRefer) {
                Car car = Car(DateTime.now(),0,'https://firebasestorage.googleapis.com/v0/b/final-f741c.appspot.com/o/0553.jpg_wh1200.jpg?alt=media&token=e26f0135-350c-4a09-985e-fff63346295e'
                    ,'','',DateTime.now(),0,'','','',DateTime.now(),documentRefer.collection('Car').document());

                documentRefer.collection('Car').add(
                    {
                      'antifreeze' : Timestamp.fromDate(car.antifreeze),
                      'engine_oil' : car.engine_oil,
                      'image_url' : car.image_url,
                      'mission' : car.mission,
                      'name' : car.name,
                      'next_antifreeze' : Timestamp.fromDate(car.next_antifreeze),
                      'next_engine_oil' : car.next_engine_oil,
                      'next_mission' : car.next_mission,
                      'opinion' : car.opinion,
                      'manager' : car.manager,
                      'time' : Timestamp.fromDate(car.time),
                    }
                ).then((val) {
                  print(val.documentID);
                });
                documentRefer.collection('messages').add( {
                  'manager' : 'tjdqls0003@gmail.com',
                  'message' : 'Welcome Bereka!',
                  'time' :Timestamp.now(),
                }).then((val) {
                  print(val.documentID);
                });
                documentRefer.collection('receive_estimate').add(
                    {
                      'contents' : '',
                      'feedback_id' : 0,
                      'manager' : 'tjdqls0003@gmail.com',
                      'price' : 0,
                      'time' :Timestamp.now(),
                    }
                ).then((val) {
                  print(val.documentID);
                });
                documentRefer.collection('send_estimate').add( {
                  'contents' : 'https://firebasestorage.googleapis.com/v0/b/final-f741c.appspot.com/o/0553.jpg_wh1200.jpg?alt=media&token=e26f0135-350c-4a09-985e-fff63346295e',
                  'id' : 0,
                  'car_image' : 'tjdqls0003@gmail.com',
                  'time' :Timestamp.now(),
                }).then((val) {
                  print(val.documentID);
                });
              });

              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }

  String validateName(String value){
    if(value.isEmpty)
      return 'Please enter Username';
    else
      return null;
  }

  String validatePassword(String value){
    if(value.isEmpty)
      return 'Please enter Password';
    else {
      password = value;
      return null;
    }
  }

  String validateConfirmPassword(String value){
    if(value.isEmpty)
      return 'Please enter Confirm Password';
    else if(value != password){
      return 'Password does not match';
    }
    else{
      return null;
    }

  }

  String validateEmail(String value){
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|'
        r'(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])'
        r'|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(value.isEmpty)
      return 'Please enter Email Address';
    else if(!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePhoneNum(String value){
    if(value.isEmpty)
      return 'Please enter your phone number';
    else if(!value.contains("-"))
      return 'Please enter phone number with \"-\"';
    else return null;
  }

  String validateCar(String value){
    if(value.isEmpty)
      return 'Please enter Car model';
    else
      return null;
  }

  String validateLP(String value){
    if(value.isEmpty)
      return 'Please enter License Plate Number';
    else
      return null;
  }

  void _validateInputs(){
    if(_formKey.currentState.validate()){
      _autoValidate = false;
      _formKey.currentState.save();
    }
    else{
      setState(() {
        _autoValidate = true;
      });
    }
  }

}
