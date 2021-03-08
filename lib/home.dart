
import 'dart:async';
import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rani_arts/fullScreenView.dart';
import 'package:rani_arts/login.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

  class _HomePageState extends State<HomePage> {

  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> artList;
  final CollectionReference collectionReference =
  Firestore.instance.collection('arts');

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Art World App',
        text: 'Art World App By Rani Jain',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.roshan.app.rani_arts&hl=en_IN',
        chooserTitle: 'Created by Roshan'
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        artList = datasnapshot.documents;
      });

  });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }






  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent[400],
            elevation: 2.0,
            centerTitle: true,
            title: InkWell(
              child: GestureDetector(
                onLongPress: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context ) => Login()));
                },
                child: Text('Art World',style:
                TextStyle(
                  fontFamily: 'Hand',
                    fontSize: 25
                ),
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share App',
                onPressed: share,
              ),
            ],
          ),
          body: artList!= null ?  Scrollbar(
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(8.0),
              crossAxisCount: 4,
              itemCount: artList.length,
              itemBuilder: (context,i){
                String imgPath = artList[i].data['imgUrl'];
                String title = artList[i].data['title'];
                String date = artList[i].data['date'];
                return Container(
                    padding: EdgeInsets.all(0),
                    child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FullScreenView(imgPath,title,date),
                        )),
                        child: Hero(
                          tag: imgPath,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                            elevation: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage(
                                image: NetworkImage(imgPath),
                                fit: BoxFit.cover,
                                placeholder: AssetImage('assets/back.png',),
                              ),
                            ),
                          ),
                        )
                    )
                );
              },
              staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 3: 2),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          )
              : Center(
            child: SpinKitDoubleBounce(
              color: Colors.redAccent[400],
              size: 100.0,
            ),
          ),
      ),
    );
  }
}
