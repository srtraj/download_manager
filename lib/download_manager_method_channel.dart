import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'download_manager_platform_interface.dart';

/// An implementation of [DownloadManagerPlatform] that uses method channels.
class MethodChannelDownloadManager extends DownloadManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.stj.dev/download_manager');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> downloadFile({
    required String url,
    String? savedDir,
    required String fileName,
    Map<String, String> headers = const {},
    bool showNotification = true,
    bool openFileFromNotification = true,
    bool requiresStorageNotLow = true,
    bool saveInPublicStorage = false,
  }) async {
    int? id;
    try {
      if (savedDir != null) {
        assert(Directory(savedDir).existsSync(), 'savedDir does not exist');
      }
      final int result = await methodChannel.invokeMethod('downloadFile',
          {'url': url, 'file_name': fileName, 'savedDir': savedDir});
      id = result;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }
    return id;
  }

  @override
  Future<void> viewDownloads() async {
    try {
      final int result = await methodChannel.invokeMethod(
        'view_downloads',
      );
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }
  }

  @override
  Future<void> registerCallback() async {
    methodChannel.setMethodCallHandler(methodHandler);
  }

  Future<void> methodHandler(MethodCall call) async {
    final Map argument = call.arguments;
    switch (call.method) {
      case "download_status":
        // this method name needs to be the same from invokeMethod in Android/ you can handle the data here. In this example, we will simply update the view via a data service
        print("download statuss::::::::::::::$argument");
        break;
      default:
        print('no method handler for method ${call.method}');
    }
  }
}
