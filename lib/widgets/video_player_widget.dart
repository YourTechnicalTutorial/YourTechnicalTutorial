import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class VideoPlayerWidget extends StatelessWidget {
  final String videoId;

  const VideoPlayerWidget({
    super.key,
    required this.videoId,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final String viewId = 'youtube-$videoId';

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        viewId,
        (int viewId) {
          final iframe = html.IFrameElement()
            ..src = 'https://www.youtube.com/embed/$videoId'
            ..style.border = 'none'
            ..allowFullscreen = true;

          return iframe;
        },
      );

      return HtmlElementView(viewType: viewId);
    } else {
      final controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );

      return YoutubePlayer(
        controller: controller,
        aspectRatio: 16 / 9,
      );
    }
  }
}