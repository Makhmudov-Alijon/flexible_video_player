package com.example.flexible_video_player

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.app.Activity

/** FlexibleVideoPlayerPlugin */
class FlexibleVideoPlayerPlugin : FlutterPlugin, ActivityAware {

    private var activity: Activity? = null
    private var playerPlugin: FlexiblePlayerPlugin? = null


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        playerPlugin = FlexiblePlayerPlugin(
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger,
            flutterPluginBinding.textureRegistry
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        playerPlugin = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        playerPlugin?.setActivity(activity)
    }

    override fun onDetachedFromActivity() {
        activity = null
        playerPlugin?.setActivity(null)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        playerPlugin?.setActivity(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        playerPlugin?.setActivity(activity)
    }
}
