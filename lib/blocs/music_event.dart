part of 'music_bloc.dart';

abstract class MusicEvent {}

class LikeMusicEvent extends MusicEvent {
  final int id;
  LikeMusicEvent(this.id);
}

class DisLikeMusicEvent extends MusicEvent {
  final int id;
  DisLikeMusicEvent(this.id);
}

class ChangeMusicEvent extends MusicEvent {
  final int id;
  ChangeMusicEvent(this.id);
}
