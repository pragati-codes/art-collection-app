import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rani_arts/upload.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  _showAlert(BuildContext context, e) {
    showPlatformDialog(
      context: context,
      builder: (_) =>
          BasicDialogAlert(
            title: Text("Failed Because of"),
            content:
            Text(e),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _isLoading ?
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close,
                color: Colors.white,
              ),
              onPressed: () =>
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Login())),),
          ),
          body: Center(
            child: Container(
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
          ),
        )
            :
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <
                Widget>[
              SizedBox(height: 40.0),
              Container(
                color: Colors.white,
                child:
                Center(child: Image.asset(
                  'assets/back.png', height: 200, width: 200,)),),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        child: Text(
                          'Art World',
                          style:
                          TextStyle(
                              fontFamily: 'Hand',
                              fontSize: 40.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'Enter Login Credential Here',
                      style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 1.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50,),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent[400]))),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'PASSWORD ',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent[400]))),
                        obscureText: true,
                      ),
                      SizedBox(height: 50.0),
                      Container(
                          height: 50.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.redAccent[400],
                            color: Colors.redAccent[400],
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });
//                                _auth.createUserWithEmailAndPassword(email: email, password: password);
                                try {
                                  final user = await _auth
                                      .signInWithEmailAndPassword(
                                      email: email, password: password);
                                  if (user != null) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => Upload()));
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                                catch (e) {
                                  String error = e.toString();
                                  _showAlert(context, error);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Open Admin Panel',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(height: 300.0),
                    ],
                  )),
            ],
          ),
        )
    );
  }


}
