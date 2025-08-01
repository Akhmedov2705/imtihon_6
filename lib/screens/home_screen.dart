import 'package:audio_example/blocs/music_bloc.dart';
import 'package:audio_example/screens/liked_musics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/track.dart';
import '../blocs/like_bloc.dart';
import '../blocs/audio_player_bloc.dart';
import 'now_playing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final likeState = context.watch<LikeBloc>().state;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Options', style: TextStyle(color: Colors.white)),
            ),
            ListTile(title: Text('Liked Songs')),
          ],
        ),
      ),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Recommended", style: TextStyle(fontSize: 20)),
              BlocBuilder<MusicBloc, MusicState>(
                builder: (context, state) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.recommended.length,
                    itemBuilder: (context, index) {
                      final t = state.recommended[index];
                      final isLiked = likeState.liked.contains(t.assetPath);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: t.imagePath != null
                            ? Image.asset(t.imagePath!, width: 50, height: 50)
                            : null,
                        title: Text(t.title),
                        trailing: IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.white,
                          ),
                          onPressed: () {
                            context.read<LikeBloc>().add(ToggleLike(t));
                            context.read<MusicBloc>().add(
                              isLiked
                                  ? LikeMusicEvent(t.id)
                                  : DisLikeMusicEvent(t.id),
                            );
                          },
                        ),
                        onTap: () {
                          context.read<AudioPlayerBloc>().add(PlayTrack(t));
                          context.read<MusicBloc>().add(ChangeMusicEvent(t.id));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NowPlayingScreen(),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              Text("All Music", style: TextStyle(fontSize: 20)),
              BlocBuilder<MusicBloc, MusicState>(
                builder: (context, state) {
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.65,
                      crossAxisCount: 2,
                    ),
                    shrinkWrap: true,
                    itemCount: state.recommended.length,
                    itemBuilder: (context, index) {
                      final t = state.recommended[index];
                      final isLiked = likeState.liked.contains(t.assetPath);

                      return GestureDetector(
                        onTap: () {
                          context.read<AudioPlayerBloc>().add(PlayTrack(t));
                          context.read<MusicBloc>().add(ChangeMusicEvent(t.id));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NowPlayingScreen(),
                            ),
                          );
                        },
                        child: Card(
                          child: SizedBox(
                            width: 200,
                            height: 220,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  t.imagePath ?? "",
                                  width: 200,
                                  height: 200,
                                ),
                                Text(t.title),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) => state.activeMusic == null
            ? ColoredBox(color: Colors.transparent)
            : BlocBuilder<AudioPlayerBloc, dynamic>(
                builder: (context, state) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Slider(
                      min: 0,
                      max: state.duration.inMilliseconds.toDouble(),
                      value: state.position.inMilliseconds
                          .clamp(0, state.duration.inMilliseconds)
                          .toDouble(),
                      onChanged: (v) {
                        context.read<AudioPlayerBloc>().add(
                          SeekTrack(Duration(milliseconds: v.toInt())),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10),
                          onPressed: () {
                            final newPos =
                                state.position - const Duration(seconds: 10);
                            context.read<AudioPlayerBloc>().add(
                              SeekTrack(
                                newPos > Duration.zero ? newPos : Duration.zero,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            state.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                          ),
                          iconSize: 64,
                          onPressed: () => context.read<AudioPlayerBloc>().add(
                            TogglePlayPause(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          onPressed: () {
                            final newPos =
                                state.position + const Duration(seconds: 10);
                            context.read<AudioPlayerBloc>().add(
                              SeekTrack(
                                newPos < state.duration
                                    ? newPos
                                    : state.duration,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
