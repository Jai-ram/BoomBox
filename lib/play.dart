
import 'dart:io';
import 'dart:math';


import 'package:boom_box/bottom.dart';
import 'package:boom_box/main.dart';
import 'package:fluttery/gestures.dart';
import 'package:boom_box/theme.dart';


import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';


//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),

    );
  }
}

/*class MyHomePage extends StatefulWidget {
  MyHomePage(song, {Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}*/

class SecondPage extends StatefulWidget{

  SecondPage(this.index);
  final index;
  
  
 
  @override
  _SecondPageState createState() => _SecondPageState();
 
  
}

class _SecondPageState extends State<SecondPage> {

 double _seekPercent;
  
  
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
                              //seekbar
                              new Expanded(
                                child: AudioComponent(
                                  updateMe: [
                                    WatchableAudioProperties.audioPlayhead,
                                    WatchableAudioProperties.audioSeeking,
                                  ],
                  
                                  /*playerBuilder: (BuildContext context,AudioPlayer player,Widget child){
                  
                                    double playbackprogress=0.0;
                                    if(player.audioLength!=null&&player.position!=null){
                                      playbackprogress=player.position.inMilliseconds/player.audioLength.inMilliseconds;
                                    }
                                    _seekPercent=player.isSeeking?_seekPercent:null;
                                    return new RadialSeekBar(
                                      progress: playbackprogress,
                                      seekPercent: _seekPercent,
                                      onSeekRequested:(double seekPercent){
                                        setState(() {
                                          _seekPercent=seekPercent;

                                          final seekMillis=(player.audioLength.inMilliseconds*seekPercent).round();
                                          player.seek(new Duration(milliseconds: seekMillis));
                                        });
                                      });
                                  },
                                  */
                                  child: new RadialSeekBar(song:songs[widget.index])),
                                                      
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
class RadialSeekBar extends StatefulWidget {


  

 final song;
 
final double progress;
  final double seekPercent;
  final Function(double) onSeekRequested;
  final Widget child;
RadialSeekBar({Key key,this.song, this.progress=0.0, this.seekPercent=0.0, this.onSeekRequested, this.child, }):super(key: key);
  
   @override
  RadialSeekBarState createState() {
    return new RadialSeekBarState();
  }
}

class RadialSeekBarState extends State<RadialSeekBar> {

  double _progress = 0.0;
  PolarCoord _startDragCoord;
  double _startDragPercent;
  double _currentDragPercent;


  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _progress = widget.progress;
  }

  void _onDragStart(PolarCoord coord) {
    _startDragCoord = coord;
    _startDragPercent = _progress;
  }

  void _onDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);

    setState(() => _currentDragPercent = (_startDragPercent + dragPercent) % 1.0);
  }

  void _onDragEnd() {
    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }

    setState(() {
      _currentDragPercent = null;
      _startDragCoord = null;
      _startDragPercent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double thumbposition=_progress;
    if(_currentDragPercent!=null){
      thumbposition=_currentDragPercent;
    }
    else if(widget.seekPercent!=null){
      thumbposition=widget.seekPercent;
    }


    return new RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate:  _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
                  child: new Container(
        width:double.infinity,
        height: double.infinity,
        color: Colors.transparent,

                    child: new Center(
          child: new Container(
            width: 150.0,
            height: 150.0,
          
            child: RadialProgressBar(
              progressPercent: _progress,
              thumbposition: thumbposition,
              progressColor: Colors.deepPurple,
              thumbcolor: lightAccentColor,
              ipadding: EdgeInsets.all(10.0),
              opadding: EdgeInsets.all(10.0),
                                              child: ClipOval(
                                clipper: new CircleClipper(),
                                                  child:widget.song.albumArt != null ? Image.file(File.fromUri(Uri.parse(widget.song.albumArt)),
                                                  fit: BoxFit.cover,
                                                  ):Container(),
                                                  
                                                ),
                            ),
                                              
                                            ),
                                             
                                          ),
      ),
    );
  }
}
                
                class RadialProgressBar extends StatefulWidget{
                  final double trackwidth;
                  final Color trackcolor;
                  final double progressWidth;
                  final Color progressColor;
                  final double progressPercent;
                  final double thumbSize;
                  final Color thumbcolor;
                  final double thumbposition;
                  final EdgeInsets opadding;
                  final EdgeInsets ipadding;
                  final Widget child;
                  RadialProgressBar({
                    this.trackwidth = 3.0,
                    this.trackcolor = Colors.grey,
                    this.progressWidth = 5.0,
                    this.progressColor = Colors.black,
                    this.thumbSize=10.0,
                    this.thumbcolor=Colors.black, this.progressPercent=0.0, this.thumbposition =0.0, this.child,
                    this.opadding=const EdgeInsets.all(0.0),
                    this.ipadding=const EdgeInsets.all(0.0),
                  });

                @override
                _RadialProgressBarState createState() => new _RadialProgressBarState();
  
  
                  }
  
  class _RadialProgressBarState extends State<RadialProgressBar>{
    EdgeInsets _insetsForPainter(){
      final thickness =max(widget.trackwidth,max(widget.progressWidth,widget.thumbSize))/2.0;
      return new EdgeInsets.all(thickness);
    }
    @override
    Widget build(BuildContext context){
      return Padding(
        padding: widget.opadding,
        child: new CustomPaint(
          painter: new RadialProgressBarPainter(
            trackwidth: widget.trackwidth,
            trackcolor: widget.trackcolor,
            progressWidth: widget.progressWidth,
            progressColor: widget.progressColor,
            progressPercent: widget.progressPercent,
            thumbSize: widget.thumbSize,
            thumbcolor: widget.thumbcolor,
            thumbposition: widget.thumbposition



          ),
          child: new Padding(
            padding: _insetsForPainter()+widget.ipadding,
            child:widget.child
          ),
        ),
      );
    }
}
class RadialProgressBarPainter extends CustomPainter{
                  final double trackwidth;
                  final Color trackcolor;
                  final double progressWidth;
                  final Paint trackPaint;
                  final Paint progressPaint;
                  final Paint thumbPaint;
                  final Color progressColor;
                  final double progressPercent;
                  final double thumbSize;
                  final Color thumbcolor;
                  final double thumbposition;
                  RadialProgressBarPainter({

                    @required this.trackwidth ,
                     @required this.trackcolor,
                     @required this.progressWidth,
                    @required this.progressColor,
                     @required this.thumbSize,
                     @required this.thumbcolor, 
                     @required this.progressPercent, 
                    @required  this.thumbposition,
                   
                  }) :trackPaint=new Paint()
                      ..color=trackcolor
                      ..style=PaintingStyle.stroke
                      ..strokeWidth=trackwidth,
                      progressPaint=new Paint()
                      ..color=progressColor
                      ..style=PaintingStyle.stroke
                      ..strokeWidth=progressWidth
                      ..strokeCap=StrokeCap.round,
                      thumbPaint=new Paint()
                      ..color=thumbcolor
                      ..style=PaintingStyle.fill

                      ;


  @override
  void paint(Canvas canvas, Size size) {
    final thickness = max(trackwidth,max(progressWidth,thumbSize));
    Size constrainedSize=new Size(
      size.width-thickness, 
      size.height-thickness,  
      );
    final center = new Offset(size.width/2, size.height/2);
    final radius = min(constrainedSize.width,constrainedSize.height,)/2;
    

    //todo
    canvas.drawCircle(
    center, 
    radius, 
    trackPaint,
    );
    final progressAngle=2*pi*progressPercent;
    canvas.drawArc(
       new Rect.fromCircle(
         center: center,
         radius: radius,
       ), 
      -pi/2, 
      progressAngle, 
      false, 
      progressPaint
      );
      
      final thumbAngle=2*pi*thumbposition-(pi/2);
      final thumbX=cos(thumbAngle)*radius;
      final thumby=sin(thumbAngle)*radius;
      final thumbCenter=new Offset(thumbX,thumby)+center;
      final thumbRadius=thumbSize/2.0;
      
      canvas.drawCircle(

        thumbCenter,
        thumbRadius,
        thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    
    //todo
    return null;
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