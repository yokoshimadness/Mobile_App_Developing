package com.example.flashlight_plugin

import android.content.Context
import android.hardware.camera2.CameraManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlashlightPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var cameraManager: CameraManager
  private var cameraId: String? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flashlight_plugin")
    channel.setMethodCallHandler(this)
    cameraManager = flutterPluginBinding.applicationContext.getSystemService(Context.CAMERA_SERVICE) as CameraManager
    cameraId = cameraManager.cameraIdList[0]
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "toggleFlashlight" -> {
        val enable = call.argument<Boolean>("enable") ?: false
        toggleFlashlight(enable, result)
      }
      else -> result.notImplemented()
    }
  }

  private fun toggleFlashlight(enable: Boolean, result: Result) {
    try {
      cameraId?.let {
        cameraManager.setTorchMode(it, enable)
        result.success(null)
      } ?: result.error("NO_CAMERA", "Camera ID is not available", null)
    } catch (e: Exception) {
      result.error("FLASHLIGHT_ERROR", "Could not toggle flashlight: ${e.message}", null)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
