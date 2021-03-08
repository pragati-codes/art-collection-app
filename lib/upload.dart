import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'curd.dart';
import 'home.dart';

String artCategory;
class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}



class _UploadState extends State<Upload> {
  String title;
  String currentDate;
  bool _isLoading = false;
  CrudMethods crudMethods = new CrudMethods();
  File selectedImage;



  Future getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  publishArt() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
          .child('artImages').child("${randomAlphaNumeric(9)}.jpg");
      final StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);
      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      print(downloadUrl);
      var date = new DateTime.now().toString();
      var dateParse = DateTime.parse(date);
      var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse
          .year}";

      setState(() {
        currentDate = formattedDate.toString();
      });
      Map<String, String> blogMap = {
        "imgUrl": downloadUrl,
        "title": title,
        "date": currentDate,
        "artCategoty": artCategory,

      };
      crudMethods.addData(blogMap).then((result) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Upload()));
      });

    }
    else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Upload()));
    }
    _showAlert(context, 'Art not Uploaded...Try Again');
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close,
            color: Colors.white,
          ),
          onPressed: () =>
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage())),
        ),
        title: Text("UPLOAD",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,),
        ),
        backgroundColor: Colors.redAccent[400],
        elevation: 0.0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: (){},
                child: Text('Log Out'
               ,style: TextStyle(fontWeight: FontWeight.bold), )
            ),
          ),
        ],
      ),
      body: _isLoading ? Center(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SpinKitFadingCircle(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.red : Colors.green,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 300,),
                Center(
                    child: GestureDetector(
                      child: Text('Cancel',
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.redAccent[400]
                        ),),
                      onTap: () =>
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Upload())),
                    )
                ),
              ],
            ),
          ),
          alignment: Alignment.center,
        ),
      ) :
      SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: selectedImage != null ?
                Container(
                  child:
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(selectedImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 300,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                )
                    : Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  height: 300,
                  decoration: BoxDecoration(color: Colors.grey,
                      borderRadius: BorderRadius.circular(16)),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Icon(Icons.add_a_photo,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            errorText: 'Enter the title',
                              alignLabelWithHint: true,
                              hintText: "Title"
                          ),
                          onChanged: (val) {
                            title = val;
                          },
                        ),
                        SizedBox(height: 30,),
                        SizedBox(height: 30,),
                        Container(
                            height: 50.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.white,
                              color: Colors.redAccent[400],
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () {
                                  //date = getDate();
                                  if (title != null || selectedImage != null) {
                                    publishArt();
                                  }
                                  else {
                                    final snackBar = SnackBar(
                                      content: Text('Yay! A SnackBar!'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          // Some code to undo the change.
                                        },
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    'PUBLISH ART',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  _showAlert(BuildContext context, String msg) {
    showPlatformDialog(
      context: context,
      builder: (_) =>
          BasicDialogAlert(
            title: Text(''),
            content:
            Text(msg),
            actions: <Widget>[
              BasicDialogAction(
                title: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }
}
