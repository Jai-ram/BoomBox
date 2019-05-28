

import 'package:boom_box/main.dart';
import 'package:boom_box/play.dart';
import 'package:boom_box/theme.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttery_audio/fluttery_audio.dart';

enum PlayerState { stopped, playing, paused }


class BottomControls extends StatefulWidget {
  const BottomControls( {
    Key key, this.index, this.nowtap,
  }) : super(key: key);
  final int index;
  final bool nowtap;
  

  
  @override
  _BottomControlsState createState() => _BottomControlsState();

}

class _BottomControlsState extends State<BottomControls> {

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
    super.initState();
    audioPlayer = new MusicFinder();
    initPlayer();
    ix=widget.index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
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
     print('hi');
     print(currentsong.uri);
    if (currentsong != null) {
      //final result =1;
      final result = await audioPlayer.play(currentsong.uri,isLocal: true);
      if (result == 1)
        setState(() {
          print('hey');
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
    return new Container(
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
    );
  }
}
/*class ControlButton extends StatelessWidget {
  final VoidCallback _onTap;
  final IconData iconData;

  ControlButton(this.iconData, this._onTap);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      onPressed: _onTap,
      iconSize: 50.0,
      icon: new Icon(iconData),
      color: Theme.of(context).buttonColor,
    );
  }
}
class NextButton extends StatelessWidget {
  const NextButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      
      icon: new Icon(Icons.skip_next,
      color: Colors.white,
      size: 35.0,
      ),
      onPressed: (){
        
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AudioComponent
    (
      updateMe: [
        WatchableAudioProperties.audioPlayerState
      ],
      playerBuilder: (BuildContext context,AudioPlayer player, Widget child){
        Color buttonCOlor=lightAccentColor;
        Function onPress;
        IconData icon=Icons.music_note;
        if(player.state==AudioPlayerState.playing){
          icon=Icons.pause;
          onPress=player.pause;
          buttonCOlor=Colors.white;
        }
        else if(player.state==AudioPlayerState.completed||player.state==AudioPlayerState.paused){
          icon=Icons.play_arrow;
          onPress=player.play;
          buttonCOlor=Colors.white;
        }
        else{
          icon=Icons.play_arrow;
          onPress=player.play;
          buttonCOlor=Colors.white;

        }
        return new RawMaterialButton(
        shape: CircleBorder(),
        fillColor: buttonCOlor,
        splashColor: lightAccentColor,
        highlightColor: lightAccentColor.withOpacity(0.5),
        elevation: 10.0,
        highlightElevation: 5.0,
        onPressed: onPress,
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Icon(
            icon,
            color: Colors.deepPurpleAccent,
            size: 35.0,
          
          ),
        ),
                    
                                          
      );
      
      },
          
    );
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return new ControlButton(Icons.skip_previous, () => prev(widget.songData));
    return new IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      icon: new Icon(
      Icons.skip_previous,
      color: Colors.white,
      size:35.0,
      ),
      onPressed: (){
        prev(widget.songData);
                  
      },
    );
  }
}*/



                 
                    


