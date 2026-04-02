import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'youtube-player',
      (int viewId) {
        final IFrameElement element = IFrameElement()
          ..width = '100%'
          ..height = '100%'
          ..src = 'https://www.youtube.com/embed/RVGAENB9sFg'
          ..style.border = 'none';
        return element;
      },
    );

    return const HtmlElementView(viewType: 'youtube-player');
  }
}