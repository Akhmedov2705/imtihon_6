import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Track {
  final String assetPath;
  final String title;
  final String? imagePath;

  Track({required this.assetPath, required this.title, this.imagePath});
}

class LikeManager {
  static const _key = 'liked_tracks';
  final SharedPreferences prefs;

  LikeManager(this.prefs);

  Set<String> get liked => prefs.getStringList(_key)?.toSet() ?? {};

  bool isLiked(Track t) => liked.contains(t.assetPath);

  Future<void> toggle(Track t) async {
    final set = liked;
    if (set.contains(t.assetPath)) {
      set.remove(t.assetPath);
    } else {
      set.add(t.assetPath);
    }
    await prefs.setStringList(_key, set.toList());
  }
}

class AudioManager extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final List<Track> tracks;
  final LikeManager likeManager;

  Track? _current;
  Track? get current => _current;
  bool get isPlaying => _player.playing;

  AudioManager({required this.tracks, required this.likeManager}) {
    _player.playerStateStream.listen((state) {
      notifyListeners();
    });
  }

  Future<void> play(Track t) async {
    _current = t;
    await _player.setAsset(t.assetPath);
    await _player.play();
    notifyListeners();
  }

  Future<void> pause() => _player.pause();

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else if (_current != null) {
      await _player.play();
    }
  }

  Future<void> seek(Duration pos) => _player.seek(pos);

  Duration get position => _player.position;

  Duration get duration => _player.duration ?? Duration.zero;

  Stream<Duration> get positionStream => _player.positionStream;

  void toggleLike(Track t) {
    likeManager.toggle(t);
    notifyListeners();
  }
}
