import 'download_manager_platform_interface.dart';

class DownloadManager {
  Future<String?> getPlatformVersion() {
    return DownloadManagerPlatform.instance.getPlatformVersion();
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
    return DownloadManagerPlatform.instance.downloadFile(
        url: url,
        savedDir: savedDir,
        fileName: fileName,
        headers: headers,
        showNotification: showNotification,
        openFileFromNotification: openFileFromNotification,
        requiresStorageNotLow: requiresStorageNotLow,
        saveInPublicStorage: saveInPublicStorage);
  }

  Future<void> viewDownloads() async {
    DownloadManagerPlatform.instance.viewDownloads();
  }

  Future<void> registerCallback() async {
    DownloadManagerPlatform.instance.registerCallback();
  }
}
