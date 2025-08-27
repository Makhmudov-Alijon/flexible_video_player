import 'package:flexible_video_player/flexible_video_player_controller.dart';
import 'package:flexible_video_player/flexible_video_player_view.dart';
import 'package:flexible_video_player/flexible_video_controller_view.dart';
import 'package:flutter/material.dart';



class VideoPage extends StatefulWidget {
  const VideoPage({super.key});
  static const String route = "/native-video";
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {

  FlexibleVideoPlayerController controller = FlexibleVideoPlayerController();
  final url = 'https://vod03.glob.uz/spider_man_far_from_home_2019/src/master.m3u8';
  @override
  void initState() {
    super.initState();
    controller.initialize();
    controller.setUrl(url);
  }


  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : FlexibleVideoView(
          controller: controller,
        )
      )
    );
  }
}