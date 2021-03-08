import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'home.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),

      )

  );
}

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
          color: Colors.redAccent[400],
          padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
          child: Center(
            child: Center(
              child: Image.asset('assets/logo.png',width: 300,
                height: 400,),
            ),
          ),
        )
    );
  }

  Future<Timer> loadData() async{
    return new Timer(Duration(seconds: 4),onDoneLoading);

  }

  onDoneLoading() async{
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context ) => HomePage()));
  }

  void checkInternet() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        loadData();
      }
    } on SocketException catch (_) {
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Text("Internet is Not Available !"),
          content:
          Text("Please Turn on your Internet Connection and Try Again..."),
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
}