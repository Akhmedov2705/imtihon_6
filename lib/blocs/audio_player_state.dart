part of 'audio_player_bloc.dart';

abstract class AudioPlayerState {
  final Track? track;
  AudioPlayerState({this.track});
}

class AudioPlayerInitial extends AudioPlayerState {}

class AudioPlayerPlaying extends AudioPlayerState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final ProcessingState processingState;

  AudioPlayerPlaying({
    required super.track,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.processingState,
  });
}
