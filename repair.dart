import 'package:flutter/material.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'user.dart';
import 'estimate.dart';

String default_url = "https://firebasestorage.googleapis.com/v0/b/final-f741c.appspot.com/o/default_img.png?alt=media&token=aa334b33-ff9b-4c55-9d59-73d2ae82d2f2";
String image_url;

class RepairPage extends StatefulWidget {
  User user;
  RepairPage(this.user);
  @override
  _RepairPageState createState() => _RepairPageState(this.user);
}

class _RepairPageState extends State<RepairPage> {
  TextEditingController controller = TextEditingController();
  User user;
  _RepairPageState(this.user);
  Future<File> _imageFile;
  bool _selected = false;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
      _selected = true;
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('견적요청서'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              
              if(_selected) {
                _imageFile.then((val) {
                  final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(val.toString());
                  final StorageUploadTask task = firebaseStorageRef.putFile(val);
                  task.onComplete.then((downLoadUrl) {
                    downLoadUrl.ref.getDownloadURL().then((url) {
                      SendEstimate.addEstiamte(user, controller.text, url);
                    });
                  });
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _imageFile == null
                ?
            ImageUI()
                :
            showImage(),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: TextField(
              maxLength: null, 
              maxLines: null,
              controller: controller,
              ),
          ),

          // IconButton(
          //   icon: Icon(Icons.check),
          //   onPressed: (){
          //     print('send estimate Info');
          //   },
          //   // onPressed: _getImageList,
          // ),
        ],
      ),
    );
  }



  Widget ImageUI(){
    return Column(
      children: <Widget>[
        Container(
          child: image_url == null ? Image.network(default_url) : Image.network(image_url),
        ),
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
      ],
    );
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
}