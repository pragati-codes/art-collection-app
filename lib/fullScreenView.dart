import 'dart:io';
import 'dart:typed_data';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FullScreenView extends StatefulWidget {
  String imgPath;
  String title;
  String date;
  FullScreenView(this.imgPath, this.title, this.date);

  @override
  _FullScreenViewState createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  final LinearGradient backgroundGradient = LinearGradient(
    colors: [new Color(0x10000000), new Color(0x3000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppBar(
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      widget.title != null
                          ? Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  widget.title + '',
                                  style: TextStyle(
                                    fontFamily: 'Hand',
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Text(widget.date),
                                )
                              ],
                            )
                          : Text('Art')
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    SpinKitDoubleBounce(
                      color: Colors.redAccent[400],
                      size: 100.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Hero(
                        tag: widget.imgPath,
                        child: GestureDetector(
                          onScaleStart: (ScaleStartDetails details){
                            print(details);
                            _previousScale = _scale;
                            setState(() {
                            });
                          },
                          onScaleUpdate: (ScaleUpdateDetails details){
                            print(details);
                            _scale = _previousScale * details.scale;
                            setState(() {
                            });
                          },
                          onScaleEnd: (ScaleEndDetails details){
                            print(details);
                            _previousScale = 1.0;
                            _scale=1.0;
                            setState(() {


                            });
                          },
                          child: Transform(
                            alignment: FractionalOffset.center,
                              transform: Matrix4.diagonal3(Vector3(_scale,_scale,_scale)),
                              child: Image.network(widget.imgPath)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed:() {
////          RenderRepaintBoundary boundary =
////          _globalKey.currentContext.findRenderObject();
////          ui.Image image = await boundary.toImage();
////          ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
////          final result =
////              await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
////          print(result);
////          _toastInfo(result.toString());
//        },
//        child: Icon(Icons.save),
//      ),
    );
  }
}
