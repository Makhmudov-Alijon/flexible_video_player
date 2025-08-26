// import 'package:flutter_test/flutter_test.dart';
// import 'package:flexible_video_player/flexible_video_player.dart';
// import 'package:flexible_video_player/flexible_video_player_platform_interface.dart';
// import 'package:flexible_video_player/flexible_video_player_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockFlexibleVideoPlayerPlatform
//     with MockPlatformInterfaceMixin
//     implements FlexibleVideoPlayerPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final FlexibleVideoPlayerPlatform initialPlatform = FlexibleVideoPlayerPlatform.instance;
//
//   test('$MethodChannelFlexibleVideoPlayer is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlexibleVideoPlayer>());
//   });
//
//   test('getPlatformVersion', () async {
//     FlexibleVideoPlayer flexibleVideoPlayerPlugin = FlexibleVideoPlayer();
//     MockFlexibleVideoPlayerPlatform fakePlatform = MockFlexibleVideoPlayerPlatform();
//     FlexibleVideoPlayerPlatform.instance = fakePlatform;
//
//     expect(await flexibleVideoPlayerPlugin.getPlatformVersion(), '42');
//   });
// }
