import 'dart:async';

import 'package:flexible_video_player/flexible_video_player_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlexibleVideoView extends StatefulWidget {
  final FlexibleVideoPlayerController controller;
  final double aspectRatio;

  const FlexibleVideoView({Key? key, required this.controller,this.aspectRatio = 16/9})
    : super(key: key);

  @override
  State<FlexibleVideoView> createState() => _FlexibleVideoViewState();
}

class _FlexibleVideoViewState extends State<FlexibleVideoView> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        if (value.textureId != null) {
          return AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: Texture(textureId: value.textureId!));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
