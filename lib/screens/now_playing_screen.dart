import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/audio_player_bloc.dart';
import '../blocs/like_bloc.dart';
import '../models/track.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: BlocBuilder<AudioPlayerBloc, dynamic>(
        builder: (context, state) {
          if (state is AudioPlayerPlaying && state.track != null) {
            final Track t = state.track!;
            final isLiked = context.watch<LikeBloc>().state.liked.contains(
              t.assetPath,
            );

            return Column(
              children: [
                if (t.imagePath != null)
                  Image.asset(
                    t.imagePath!,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 16),
                Text(t.title, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
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
                            newPos < state.duration ? newPos : state.duration,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
