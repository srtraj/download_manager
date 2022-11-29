import 'package:flutter_test/flutter_test.dart';
import 'package:download_manager/download_manager.dart';
import 'package:download_manager/download_manager_platform_interface.dart';
import 'package:download_manager/download_manager_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDownloadManagerPlatform
    with MockPlatformInterfaceMixin
    implements DownloadManagerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DownloadManagerPlatform initialPlatform = DownloadManagerPlatform.instance;

  test('$MethodChannelDownloadManager is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDownloadManager>());
  });

  test('getPlatformVersion', () async {
    DownloadManager downloadManagerPlugin = DownloadManager();
    MockDownloadManagerPlatform fakePlatform = MockDownloadManagerPlatform();
    DownloadManagerPlatform.instance = fakePlatform;

    expect(await downloadManagerPlugin.getPlatformVersion(), '42');
  });
}
