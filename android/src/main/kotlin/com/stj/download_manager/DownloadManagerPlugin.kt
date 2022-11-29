package com.stj.download_manager

import android.app.DownloadManager
import android.content.Context.DOWNLOAD_SERVICE
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*
import java.util.Collections.emptyMap
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/** DownloadManagerPlugin */
class DownloadManagerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.stj.dev/download_manager")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "downloadFile") {

      downloadFile(call, result)

    } else if (call.method == "view_downloads"){
      viewAllDownloads(call, result)


    } else {

      result.notImplemented()
    }
  }
  private fun downloadFile(call:MethodCall, result:MethodChannel.Result) {
    val url = call.argument<String>("url");
    val saveFile=call.argument<String>("file_name");
    val savedDir=call.argument<String>("savedDir");
    val request = DownloadManager.Request(Uri.parse(url))
    request.setTitle(saveFile)
    Log.d("downloadFile","downloadFile:::$saveFile")

// in order for this if to run, you must use the android 3.2 to compile your app
    // in order for this if to run, you must use the android 3.2 to compile your app
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
      request.allowScanningByMediaScanner()
      request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
    }
    if (savedDir != null) {
      request.setDestinationInExternalFilesDir(
        context,
        savedDir,
        saveFile
      )
      Log.d("save Directory:",savedDir)
    }else{
      Log.d("save Directory:", Environment.DIRECTORY_DOWNLOADS)
      request.setDestinationInExternalPublicDir(
        Environment.DIRECTORY_DOWNLOADS,
        saveFile)
    }


// get download service and enqueue file
    val manager: DownloadManager = getSystemService(DOWNLOAD_SERVICE) as DownloadManager

    val downloadID =manager.enqueue(request)
    result.success(downloadID)
    Log.d("downloadID:::::::::::::::::::::>>", downloadID.toString())

    // Run a task in a background thread to check download progress
    // Use a background thread to check the progress of downloading
    val executor: ExecutorService = Executors.newFixedThreadPool(1)

    // Use a hander to update progress bar on the main thread
    val mainHandler = Handler(
      Looper.getMainLooper()
    )
    executor.execute(Runnable {
      var progress = 0
      var downloadStatus="STATUS_UNKNOWN"
      var isDownloadFinished = false
      var statusObject = emptyMap<String, Any>()
      while (!isDownloadFinished) {
        val cursor: Cursor =
          manager.query(DownloadManager.Query().setFilterById(downloadID))
        if (cursor.moveToFirst()) {
          val downloadStatusId: Int =
            cursor.getInt(cursor.getColumnIndex(DownloadManager.COLUMN_STATUS))
          when (downloadStatusId) {
            DownloadManager.STATUS_RUNNING -> {
              downloadStatus="STATUS_RUNNING"
              val totalBytes: Long =
                cursor.getLong(cursor.getColumnIndex(DownloadManager.COLUMN_TOTAL_SIZE_BYTES))
              if (totalBytes > 0) {
                val downloadedBytes: Long =
                  cursor.getLong(cursor.getColumnIndex(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR))
                progress = (downloadedBytes * 100 / totalBytes).toInt()
              }

            }
            DownloadManager.STATUS_SUCCESSFUL -> {
              progress = 100
              isDownloadFinished = true
              downloadStatus="STATUS_SUCCESSFUL"
            }
            DownloadManager.STATUS_PAUSED-> {
              downloadStatus="STATUS_PAUSED"
            }
            DownloadManager.STATUS_PENDING -> {
              downloadStatus="STATUS_PENDING"
            }
            DownloadManager.STATUS_FAILED -> {
              downloadStatus="STATUS_FAILED"
              isDownloadFinished = true
            }
          }
          mainHandler.post {
            val values1: Any = HashSet(statusObject.values)
            val status=mapOf("id" to downloadID,"progress" to progress,"downloadStatus" to downloadStatus)
            val values2: HashSet<Any> = HashSet(status.values)

            if(values1 != values2) {
              methodChannel.invokeMethod("download_status", status)
              statusObject=status
            }

          }

        }
        cursor.close();
      }

    })
    executor.shutdown();
    mainHandler.removeCallbacksAndMessages(null);

  }

  private fun  viewAllDownloads(call:MethodCall, result:MethodChannel.Result){
    val viewDownloadsIntent = Intent(DownloadManager.ACTION_VIEW_DOWNLOADS)
    startActivity(viewDownloadsIntent)
  }
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
