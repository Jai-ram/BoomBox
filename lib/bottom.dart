

import 'package:boom_box/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key, this.song,
  }) : super(key: key);
  final song;

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
                      text: song.artist!=null?song.artist:'Uknown',
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
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                  
                      new PreviousButton(),
                    new Expanded(child: new Container()),
                    
                      new PlayButton(),
                    new Expanded(child: new Container()),
                  
                  
                      new NextButton(),
                    new Expanded(child: new Container()),
                  ],
                ),
              )
             
              
            ],
          ),
        ),
      ),
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
    return new IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      icon: new Icon(
      Icons.skip_previous,
      color: Colors.white,
      size:35.0,
      ),
      onPressed: (){
                  
      },
    );
  }
}
                 
                    


