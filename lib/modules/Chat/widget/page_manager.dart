import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class PageManager {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
  String url ='https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';
   /*static const url =

      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'
      'https://firebasestorage.googleapis.com/v0/b/mostaqbal-masr.appspot.com/o/Messages%2F537%2FFuture%20Of%20Egypt%2F2022-04-04-17-28-42-audio.m4a?alt=media&token=01e3bcb9-256c-4b3f-a6e3-f2f74e6b5c5c'
      ;
*/
  late AudioPlayer audioPlayer;
  PageManager() {
    init();
  }

   init() async {
    audioPlayer = AudioPlayer();
     audioPlayer.setUrl(url);

    audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
      }
    });

    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }


  void play()  {
    audioPlayer.play();
  }

  void pause() {
    audioPlayer.pause();
  }

   stop(){
    audioPlayer.stop();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  void dispose() {
    audioPlayer.dispose();
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }