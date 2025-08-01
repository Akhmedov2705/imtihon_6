part of 'like_bloc.dart';

abstract class LikeEvent {}

class ToggleLike extends LikeEvent {
  final Track track;
  ToggleLike(this.track);
}
