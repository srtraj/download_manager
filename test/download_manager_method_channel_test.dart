import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:download_manager/download_manager_method_channel.dart';

void main() {
  MethodChannelDownloadManager platform = MethodChannelDownloadManager();
  const MethodChannel channel = MethodChannel('download_manager');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
