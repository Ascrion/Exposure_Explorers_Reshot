import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';


// video state
final videoControllerProvider =
    StateNotifierProvider<VideoControllerNotifier, VideoPlayerController?>(
  (ref) => VideoControllerNotifier(ref),
);
final isVideoPlayingProvider = StateProvider<bool>((ref) => false);


class VideoControllerNotifier extends StateNotifier<VideoPlayerController?> {
  final Ref _ref;

  VideoControllerNotifier(this._ref) : super(null);

  Future<void> initialize(String assetPath) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(assetPath));
    await controller.initialize();
    controller.setLooping(true);
    controller.setVolume(0);
    controller.play();
    state = controller;

    controller.addListener(() {
      _ref.read(isVideoPlayingProvider.notifier).state = controller.value.isPlaying;
  });
  }

  void play() => state?.play();
  void pause() => state?.pause();
  void toggle() {
    if (state?.value.isPlaying ?? false) {
      state?.pause();
    } else {
      state?.play();
    }
  }

  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}

class HeroVideo extends ConsumerWidget {
  final String assetPath;

  const HeroVideo({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(videoControllerProvider);

    if (controller == null) {
      return FutureBuilder(
        future: ref.read(videoControllerProvider.notifier).initialize(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final controller = ref.watch(videoControllerProvider);
            return _buildStretchedVideo(controller!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    return _buildStretchedVideo(controller);
  }

  Widget _buildStretchedVideo(VideoPlayerController controller) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover, // Stretch + crop if needed
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}

