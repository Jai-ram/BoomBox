

import 'package:boom_box/app.dart';
import 'package:flutter/material.dart';
import 'package:boom_box/play.dart';


import 'package:flute_music_player/flute_music_player.dart';
 var songs;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boom Box Pro',
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>  {

  MusicFinder player = new MusicFinder();
 

  @override
  void initState() {
    super.initState();
    getAllSongs();
  }
  void getAllSongs() async{
    songs = await MusicFinder.allSongs();
    setState(() {
      
    });
    
  }
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }
  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: _onWillPop,
          child: Scaffold(
        
        appBar: AppBar(
          title: Text("Boom Box "),
          backgroundColor: Colors.blueAccent[200],
          elevation: 0.0,
          actions:<Widget>[
                  PopupMenuButton<String>(
                    onSelected: choiceAction,
                                                        itemBuilder: (BuildContext context){
                                                          return Constants.choices.map((String choice){
                                                            return PopupMenuItem<String>(
                                                              value: choice,
                                                              child: Text(choice),
                                                            );
                                                          }).toList(); 
                                                        },
                                                      )
                                      
                                                    ],
                          ),
                          body: Container(
                            
                            child: ListView.builder(
                              
                              itemCount: songs.length,
                              itemBuilder: (context,i){
                                return Card(
                                  child:Container(
                                    width: 50.0,
                                    height: 40.0,
                                    color: Colors.deepPurple,
                                    child: new InkWell(
                                      
                                      child: Text(
                                        songs[i].title,
                                        style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
                                        ),
                                      
                            
                                onTap: (){
                                    Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                  builder: (BuildContext context) 
                                                    => new SecondPage(i)));
                                },),
                                  ));
                              },
                            ),
                          )
                        ),
    );
                    }
                  
                    
                    void choiceAction(String value) {
                      Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                builder: (BuildContext context) 
                                                  => new Infopage()));
}
}