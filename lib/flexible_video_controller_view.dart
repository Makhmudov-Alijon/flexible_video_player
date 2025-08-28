import 'dart:io';

import 'package:flexible_video_player/models/flexible_video_player_track.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'flexible_video_player_controller.dart';


class FlexibleVideoControllerView extends StatefulWidget {
  final FlexibleVideoPlayerController controller;

  const FlexibleVideoControllerView({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<FlexibleVideoControllerView> createState() => _FlexibleVideoControllerViewState();
}

class _FlexibleVideoControllerViewState extends State<FlexibleVideoControllerView> {

  bool _isPlaying = true;
  bool isFullScreen = false;

  String _fmt(int ms) {
    final s = (ms / 1000).floor();
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$m:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.black45,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    _fmt(value.position.inMilliseconds),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: value.duration.inMilliseconds.toDouble(),
                      value: value.position.inMilliseconds.toDouble(),
                      // onChangeStart: (_) => setState(() => _seeking = true),
                      onChanged: (v) {

                      },
                      onChangeEnd: (v) {
                        widget.controller.seekTo(v.toInt());
                      },
                    ),
                  ),
                  Text(
                    _fmt(value.duration.inMilliseconds),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(Platform.isIOS)...{
                    // AirPlayRoutePickerView(
                    //   tintColor: Colors.white,
                    //   activeTintColor: Colors.white,
                    //   backgroundColor: Colors.transparent,
                    //   onAirplayConnectionChanged: (isConnected) {
                    //     widget.controller.play();
                    //   },
                    // )
                  },
                  SizedBox(width: 12,),
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: Colors.white),
                    onPressed: () {
                      final t = (value.position.inMilliseconds - 10000).clamp(0, value.duration.inMilliseconds);
                      widget.controller.seekTo(t);
                    },
                  ),
                  SizedBox(width: 12,),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle : Icons.play_circle,
                      size: 48,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (_isPlaying) {
                        await widget.controller.pause();
                      } else {
                        await widget.controller.play();
                      }
                      setState(() => _isPlaying = !_isPlaying);
                    },
                  ),
                  SizedBox(width: 12,),
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: Colors.white),
                    onPressed: () {
                      final t = (value.position.inMilliseconds + 10000).clamp(0, value.duration.inMilliseconds);
                      widget.controller.seekTo(t);
                    },
                  ),
                  SizedBox(width: 12,),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: (){
                      _openMenu(
                        audio: value.audioTrack,
                        video: value.videoTrack,
                        text: value.subtitleTracks,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.picture_in_picture_alt_rounded, color: Colors.white),
                    onPressed: (){
                      widget.controller.enterPictureInPicture();
                    },
                  ),
                  IconButton(
                    icon: value.isFullscreen ? const Icon(Icons.fullscreen_exit, color: Colors.white) : const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: (){
                      setState(() {
                      if (value.isFullscreen) {
                        widget.controller.exitFullscreen();
                      }else{
                        widget.controller.enterFullscreen();
                      }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 32,)
            ],
          ),
        );
      }
    );
  }

  Future<void> _openMenu( {required List<VideoPlayerTrack> video,required List<VideoPlayerTrack> audio,required List<VideoPlayerTrack> text}) async {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Audio'),
                for (var i = 0; i < audio.length; i++)
                  ListTile(
                    title: Text(
                      audio[i].label ?? "",
                    ),
                    // trailing:tracks['audio_current']["metadata"]["title"] == audio[i]['title'] ?  Icon(Icons.check, color: Colors.white,) : SizedBox(),
                    onTap: () {
                      if(defaultTargetPlatform == TargetPlatform.iOS){
                        // widget.controller.selectAudioIos(i);
                      }else{
                        if (audio[i].rendererIndex != null) {
                          widget.controller.selectAndroidTrack(
                            rendererIndex: audio[i].rendererIndex!,
                            groupIndex: audio[i].groupIndex!,
                            trackIndex: audio[i].trackIndex!,
                          );
                        }
                      }
                      Navigator.pop(context);
                    },
                  ),
                const Divider(),
                const ListTile(title: Text('Subtitles')),
                ListTile(
                  title: const Text('Off'),
                  onTap: () {
                    // widget.controller.selectTextIos(-1);
                    Navigator.pop(context);
                  },
                ),
                for (var i = 0; i < text.length; i++)
                  ListTile(
                    title: Text(
                      text[i].label ?? "",
                    ),
                    onTap: () {
                      if(defaultTargetPlatform == TargetPlatform.iOS){
                        // widget.controller.selectTextIos(i);
                      }else{
                        if (text[i].rendererIndex != null) {
                          widget.controller.selectAndroidTrack(
                            rendererIndex: text[i].rendererIndex!,
                            groupIndex: text[i].groupIndex!,
                            trackIndex: text[i].trackIndex!,
                          );
                        }
                      }
                      Navigator.pop(context);
                    },
                  ),
                const Divider(),
                const ListTile(title: Text('Quality (bitrate cap)')),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // widget.controller.setPreferredBitrateKbps(0);
                            Navigator.pop(context);
                          },
                          child: const Text('Auto'),
                        ),
                        const SizedBox(width: 8),
                        for (final item in video)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: OutlinedButton(
                              onPressed: () {
                                if(defaultTargetPlatform == TargetPlatform.iOS){
                                  // widget.controller.selectVideoIos(kbps['width'], kbps['height'],kbps["peakBitrate"]);
                                }else{
                                  if (item.rendererIndex != null) {
                                    widget.controller.selectAndroidTrack(
                                      rendererIndex: item.rendererIndex!,
                                      groupIndex: item.groupIndex!,
                                      trackIndex: item.trackIndex!,
                                    );
                                  }
                                }
                                Navigator.pop(context);
                              },
                              child: (defaultTargetPlatform == TargetPlatform.iOS) ? Text("${item.width}x${item.height}") : Text(item.label ?? ""),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
