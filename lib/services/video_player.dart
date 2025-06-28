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

  void setController(VideoPlayerController controller) {
    state = controller;
    controller.addListener(() {
      _ref.read(isVideoPlayingProvider.notifier).state =
          controller.value.isPlaying;
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


final videoInitializedProvider = FutureProvider<void>((ref) async {
  final controller = VideoPlayerController.networkUrl(Uri.parse(
    'https://file-fetcher-api.navodiths.workers.dev/download?key=Hero.mp4',
  ));
  await controller.initialize();
  controller.setLooping(true);
  controller.setVolume(0);
  controller.play();
  ref.read(videoControllerProvider.notifier).setController(controller);
});

class HeroVideo extends ConsumerWidget {
  const HeroVideo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(videoControllerProvider);
    final initStatus = ref.watch(videoInitializedProvider);

    return initStatus.when(
      data: (_) {
        if (controller == null) return const SizedBox();
        return _buildStretchedVideo(controller);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading video: $e')),
    );
  }

  Widget _buildStretchedVideo(VideoPlayerController controller) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
