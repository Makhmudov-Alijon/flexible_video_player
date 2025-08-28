
import 'package:flexible_video_player/flexible_video_player_controller.dart';
import 'package:flutter/material.dart';

import 'flexible_video_controller_view.dart';

class FlexibleVideoView extends StatefulWidget {
  final FlexibleVideoPlayerController controller;
  final double aspectRatio;
  final bool showController;

  const FlexibleVideoView({super.key, required this.controller,this.aspectRatio = 16/9,this.showController = true});

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
          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                  aspectRatio: widget.aspectRatio,
                  child: Texture(textureId: value.textureId!)),
              if(value.isInitialized && widget.showController && !value.isPictureInPicture)...{
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FlexibleVideoControllerView(controller: widget.controller),
                )
              }
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
