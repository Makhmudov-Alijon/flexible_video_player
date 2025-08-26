package com.example.flexible_video_player

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.view.TextureRegistry
import io.flutter.plugin.common.BinaryMessenger
import android.os.Handler
import android.os.Looper
import android.view.Surface
import android.graphics.SurfaceTexture

class FlexiblePlayerPlugin(
    private val context: Context,
    messenger: BinaryMessenger,
    private val textureRegistry: TextureRegistry
) : MethodChannel.MethodCallHandler {

    private val handler = Handler(Looper.getMainLooper())
    private val textureEntry: TextureRegistry.SurfaceTextureEntry = textureRegistry.createSurfaceTexture()
    private val surfaceTexture: SurfaceTexture = textureEntry.surfaceTexture()
    private val surface: Surface = Surface(surfaceTexture)
    private val textureId: Long = textureEntry.id()
    private val channel = MethodChannel(messenger, "flexible_video_player")
    private val eventChannel = EventChannel(messenger, "flexible_video_player_event")

    private var player: FlexibleVideoPlayerTexture? = null
    @Volatile
    private var eventSink: EventChannel.EventSink? = null

    private val positionTick = object : Runnable {
        override fun run() {
            try {
                val pos = player?.getCurrentPosition()
                val dur = player?.getDuration()
                val payload = mapOf(
                    "event" to "position",
                    "position" to pos,
                    "duration" to dur,
                    "id" to textureId
                )
                eventSink?.success(payload)
            } catch (t: Throwable) {
                eventSink?.error("position_error", t.message, null)
            } finally {
                handler.postDelayed(this, 250)
            }
        }
    }

    init {
        channel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(object: EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                val idArg = (arguments as? Map<*,*>)?.get("id")
                val requestedId: Long? = when (idArg) {
                    is Long -> idArg
                    is Int  -> idArg.toLong()
                    is String -> idArg.toLongOrNull()
                    else -> null
                }
                if (requestedId == null || requestedId == textureId) {
                    eventSink = events
                    handler.post(positionTick)
                } else {
                    events?.error("invalid_id", "id mismatch", null)
                }
            }
            override fun onCancel(arguments: Any?) {  }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "create" -> {
                // Dispose old player if exists
                player?.dispose()
                player = FlexibleVideoPlayerTexture(context, textureRegistry)
                result.success(player!!.getTextureId())
            }
            "setUrl" -> {
                val url = call.argument<String>("url")!!
                player?.setUrl(url)
                result.success(null)
            }
            "dispose" -> {
                player?.dispose()
                player = null
                result.success(null)
            }
            "play" -> { player?.play(); result.success(null) }
            "pause" -> { player?.pause(); result.success(null) }
            "seekTo" -> {
                val p = (call.argument<Int>("position") ?: 0).toLong()
                player?.seekTo(p)
                result.success(null)
            }
            "getTracks" -> {
                result.success(player?.getTracksMap())
            }
//            "checkPlaying" -> {
//                result.success(player.isPlaying)
//            }
//            "selectTrack" -> {
//                val args = call.arguments as Map<String, Any>
//                val rendererIndex = (args["rendererIndex"] as Number).toInt()
//                val groupIndex = (args["groupIndex"] as Number).toInt()
//                val trackIndex = (args["trackIndex"] as Number).toInt()
//                selectTrack(rendererIndex, groupIndex, trackIndex)
//                result.success(null)
//            }
//            "clearOverrides" -> {
//                clearOverrides()
//                result.success(null)
//            }
//            "setPreferredBitrate" -> {
//                val kbps = (call.argument<Int>("kbps") ?: 0)
//                val builder = trackSelector.buildUponParameters()
//                if (kbps > 0) builder.setMaxVideoBitrate(kbps * 1000)
//                else builder.setMaxVideoBitrate(Int.MAX_VALUE)
//                trackSelector.parameters = builder.build()
//                result.success(null)
//            }
//            // PIP related:
//            "isPipSupported" -> {
//                result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
//            }
//            "isInPipMode" -> {
//                result.success(hostActivity?.isInPictureInPictureMode ?: false)
//            }
//            "enterPictureInPicture" -> {
//                val entered = enterPipMode()
//                result.success(entered)
//            }
//            "setPipAspectRatio" -> {
//                val w = call.argument<Int>("width") ?: 16
//                val h = call.argument<Int>("height") ?: 9
//                pipAspectRatio = Rational(w, h)
//                result.success(null)
//            }
//            "setAutoEnterPipOnPause" -> {
//                autoEnterOnPause = call.argument<Boolean>("enabled") ?: false
//                result.success(null)
//            }
            else -> result.notImplemented()
        }
    }
}

