import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flexible_video_player/flexible_video_player_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlexibleVideoPlayer platform = MethodChannelFlexibleVideoPlayer();
  const MethodChannel channel = MethodChannel('flexible_video_player');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
