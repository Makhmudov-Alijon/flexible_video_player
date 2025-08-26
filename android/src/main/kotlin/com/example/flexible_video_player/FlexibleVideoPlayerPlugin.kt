package com.example.flexible_video_player

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** FlexibleVideoPlayerPlugin */
 class FlexibleVideoPlayerPlugin: FlutterPlugin {


  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    FlexiblePlayerPlugin(
      flutterPluginBinding.applicationContext,
      flutterPluginBinding.binaryMessenger,
      flutterPluginBinding.textureRegistry
    )
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

  }
}
