import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayerBloc() : super(AudioPlayerInitial()) {
    on<PlayTrack>(_onPlay);
    on<PauseTrack>((_, emit) => _player.pause());
    on<TogglePlayPause>((_, emit) async {
      state.track != null && _player.playing
          ? _player.pause()
          : await _player.play();
    });
    on<SeekTrack>((event, _) => _player.seek(event.position));

    _player.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      final processing = playerState.processingState;
      add(
        _InternalUpdate(
          position: _player.position,
          duration: _player.duration ?? Duration.zero,
          playing: playing,
          processingState: processing,
        ),
      );
    });

    on<_InternalUpdate>((event, emit) {
      emit(
        AudioPlayerPlaying(
          track: state.track,
          position: event.position,
          duration: event.duration,
          isPlaying: event.playing,
          processingState: event.processingState,
        ),
      );
    });
  }

  Future<void> _onPlay(PlayTrack event, Emitter<AudioPlayerState> emit) async {
    await _player.setAsset(event.track.assetPath);
    await _player.play();
    emit(
      AudioPlayerPlaying(
        track: event.track,
        position: Duration.zero,
        duration: _player.duration ?? Duration.zero,
        isPlaying: true,
        processingState: ProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
