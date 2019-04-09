
import 'dart:io';
import 'dart:math';


import 'package:boom_box/bottom.dart';
import 'package:boom_box/main.dart';



import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';




class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),

    );
  }
}



class SecondPage extends StatefulWidget{

  SecondPage(this.index);
  final index;
  
  
 
  @override
  _SecondPageState createState() => _SecondPageState();
 
  
}

class _SecondPageState extends State<SecondPage> {


  
  
  @override
  Widget build(BuildContext context) {
    
    return new Audio(
      audioUrl: songs[widget.index].uri,
     
      
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            color: const Color(0xffdddddd),
            onPressed: (){
                            Navigator.of(context).pop(true);
                              },
                            ),
                            title: new Text(songs[widget.index].title,style: TextStyle(color: Colors.black),),
                  
                            actions: <Widget>[
                              new IconButton(
                              icon: new Icon(Icons.exit_to_app),
                              color: const Color(0xffdddddd),
                              
                              onPressed: (){_showDialog();
                               
                              },
                            ),
                            ],
                          ),
                          body: new Column(
                            children: <Widget>[
                              new Expanded(
                                child: new Center(
                                  child: new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    child:ClipOval(
                                      clipper: new CircleClipper(),
                                                    child: songs[widget.index].albumArt != null ? Image.file(File.fromUri(Uri.parse(songs[widget.index].albumArt)),
                                                    fit: BoxFit.cover,
                                                    ):Container(),
                                    ),
                                  )

                                ),
                                ),
                             
                                                      
                              
                                                                //visualizer
                                                                new Container(
                                                                  width: double.infinity,
                                                                  height: 125.0,
                                                                ),
                                                                //song title,artist name and controls
                                                                new BottomControls(song:songs[widget.index])
                                                              ],
                                                            )
                                                            
                                                          ),
                      );
                                                      }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("Do you want to exit an app"),
          actions: <Widget>[
           
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );
}
                                                      
                  
  
}
class CircleClipper extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) => new Rect.fromCircle(
      center:new Offset(size.width/2, size.height/2),
      radius: min(size.width,size.height)/2,
    );

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true; 
  }


class Infopage extends StatefulWidget{
  @override
  _InfopageState createState()=> new _InfopageState();
  
  }
  
  class _InfopageState extends State<Infopage>{
  
     @override
    Widget build(BuildContext context){
    return new Scaffold(
      appBar :new AppBar(
        title: Text('App info'),
        backgroundColor: Colors.blueAccent,

      ),
      body: new Center(
        child: new Text('Developed with ❤ in flutter by Jai',
        style: TextStyle(fontWeight: FontWeight.w900,),),
      ),
    );
    
  }
    

}