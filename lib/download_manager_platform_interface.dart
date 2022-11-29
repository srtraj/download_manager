import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'download_manager_method_channel.dart';

abstract class DownloadManagerPlatform extends PlatformInterface {
  /// Constructs a DownloadManagerPlatform.
  DownloadManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static DownloadManagerPlatform _instance = MethodChannelDownloadManager();

  /// The default instance of [DownloadManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelDownloadManager].
  static DownloadManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DownloadManagerPlatform] when
  /// they register themselves.
  static set instance(DownloadManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> downloadFile({
    required String url,
    String? savedDir,
    required String fileName,
    Map<String, String> headers = const {},
    bool showNotification = true,
    bool openFileFromNotification = true,
    bool requiresStorageNotLow = true,
    bool saveInPublicStorage = false,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> viewDownloads() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> registerCallback() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
