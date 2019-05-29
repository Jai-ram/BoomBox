
import 'dart:io';
import 'dart:math';



import 'package:boom_box/main.dart';
import 'package:boom_box/theme.dart';
import 'package:flute_music_player/flute_music_player.dart';




import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
int ix;
enum PlayerState { stopped, playing, paused }



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

  SecondPage(this.index, this.nowtap);
  final index;
  final nowtap;
  
  
 
  @override
  _SecondPageState createState() => _SecondPageState();
 
  
}

class _SecondPageState extends State<SecondPage> {
  MusicFinder audioPlayer;
  Duration duration;
  Duration position;
  PlayerState playerState;
  Song song;
  
  int i=0;
  
  get isPlaying {
    return playerState == PlayerState.playing;
  }
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
position != null ? position.toString().split('.').first : '';
@override
  initState() {
    ix=widget.index;
    super.initState();
    audioPlayer = new MusicFinder();
    initPlayer();
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
    if(ix==songs.length-1){
      ix=-1;
    }
    play(songs[ix+1]);
    ix++;
  }

  initPlayer() async {
    if (audioPlayer == null) {
      audioPlayer = songs[widget.index].audioPlayer;
    }
    setState(() {
      song = songs[widget.index];
      print(widget.nowtap);
      if (widget.nowtap == null || widget.nowtap == true) {
        if (playerState != PlayerState.stopped) {
          stop();
        }
      }
      play(song);
      
    });
    audioPlayer.setDurationHandler((d) => setState(() {
          duration = d;
        }));

    audioPlayer.setPositionHandler((p) => setState(() {
          position = p;
        }));

    audioPlayer.setCompletionHandler(() {
      onComplete();
      setState(() {
        position = duration;
      });
    });

    audioPlayer.setErrorHandler((msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }
  
   Future play(currentsong) async {
     
     
    if (currentsong != null) {
     
      final result = await audioPlayer.play(currentsong.uri,isLocal: true);
      if (result == 1)
        setState(() {
          
          playerState = PlayerState.playing; 
          song = currentsong;
        });
    }
}

  Future pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1)
      setState(() {
        playerState = PlayerState.stopped;
        position = new Duration();
      });
  }

  Future next(songs) async {
    print(ix);
    if(ix==songs.length-1){
      ix=-1;
    }
    ix++;
    stop();
    setState(() {
      play(songs[ix]);
      
    });
  }
  
  Future prev(songs) async {
    print(ix);
    if(ix==0){
      ix=songs.length;
      print(ix);
      print("heyss");
    }
    ix--;
    stop();
    
   setState(() {
     
     
      play(songs[ix]);
      
    });
  }
  
    
    
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
                              title: new Text(songs[ix].title,style: TextStyle(color: Colors.black),),
                    
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
                                      width: 160.0,
                                      height: 160.0,
                                      child:ClipOval(
                                        clipper: new CircleClipper(),
                                                      child: songs[ix].albumArt != null ? Image.file(File.fromUri(Uri.parse(songs[ix].albumArt)),
                                                      fit: BoxFit.cover,
                                                      ):
                                                       new Image.asset(
                  "assets/music.png",
                  fit: BoxFit.cover,
                  height: 250.0,
                  gaplessPlayback: false,
),
                                                      
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
                                                                  new Container(
      width:double.infinity,
      color:  accentColor,
      child: Material(
        color: accentColor,
        shadowColor: const Color(0x4400000),

        child: Padding(
          padding: const EdgeInsets.only(top: 50.0,bottom: 50.0),
          child: new Column(
            children: <Widget>[
              new RichText(
                text: new TextSpan(
                  text:' ',
                  children: [
                    new TextSpan(
                      text: '',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        height: 1.5,                         
                      ),
                    ),
                    new TextSpan(
                     
                      text: songs[ix].artist!=null?songs[ix].artist:'Uknown',
                      style: new TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.0,
                        letterSpacing: 3.0,
                        height: 1.5,
          
                      )
                    )
                  
                  ]
                ),
                
              ),
             new Slider(
                  value: position?.inMilliseconds?.toDouble() ?? 0,
                  activeColor: Colors.deepPurpleAccent,
                  inactiveColor: Colors.white70,
                  onChanged: (double value) =>
                      audioPlayer.seek((value / 1000).roundToDouble()),
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble()),
              Padding(
                padding: const EdgeInsets.only(top: 40.0,bottom: 50.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    //previous
                    new IconButton(
                        splashColor: lightAccentColor,
                        highlightColor: Colors.transparent,
                        
                        icon: new Icon(Icons.skip_previous,
                        color: Colors.white,
                        size: 35.0,
                        ),
                        onPressed: (){
                          prev(songs);
                                          setState(() {
                                            
                                          });
                          
                        },
                      ),
                  
                       //new ControlButton(Icons.skip_previous, () => prev(songs)),
                    new Expanded(child: new Container()),
          //play          
                                  RawMaterialButton(
                                  shape: CircleBorder(),
                                  fillColor: Colors.white,
                                  splashColor: Colors.pink,
                                  highlightColor: Colors.pink.withOpacity(0.5),
                                  elevation: 10.0,
                                  highlightElevation: 5.0,
                                
                                  onPressed: (){
                                    playerState==PlayerState.paused?play(songs[widget.index]):pause();
                                    setState(() {
                                      
                                    });
                                  },
                                  
                                  child: new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Icon(
                                      playerState == PlayerState.playing?Icons.pause:Icons.play_arrow,
                                      color: Colors.deepPurple,
                                      size: 35.0,
                                      
                                    ),
                                  ),
                        ),
                    //new ControlButton(isPlaying ? Icons.pause : Icons.play_arrow,isPlaying ? () => pause() : () => play(songs[widget.index])),

                     //new PlayButton(),
                new Expanded(child: new Container()),
                    //next
                      new IconButton(
                        splashColor: lightAccentColor,
                        highlightColor: Colors.transparent,
                        
                        icon: new Icon(Icons.skip_next,
                        color: Colors.white,
                        size: 35.0,
                        ),
                        onPressed: (){
                          next(songs);
                                          setState(() {
                                            
                                          });
                          
                        },
                      ),
                    
                  
                      //new ControlButton(Icons.skip_next, () => next(songs)),
                    new Expanded(child: new Container()),

                    
                  ],
                  
                ),
              ),
               
                new Row(mainAxisSize: MainAxisSize.min, children: [
            new Text(
                position != null
                    ? "${positionText ?? ''} / ${durationText ?? ''}"
                    : duration != null ? durationText : '',
                // ignore: conflicting_dart_import
                style: new TextStyle(fontSize: 24.0,color: Colors.white))
]),
              
             
              
            ],
          ),
        ),
      ),
    ),
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