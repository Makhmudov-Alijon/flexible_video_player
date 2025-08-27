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
import android.os.Build
import android.util.Rational
import android.app.Activity
import android.app.Application

class FlexiblePlayerPlugin(
    private val context: Context,
    messenger: BinaryMessenger,
    private val textureRegistry: TextureRegistry
) : MethodChannel.MethodCallHandler {

    private val handler = Handler(Looper.getMainLooper())
    private val textureEntry: TextureRegistry.SurfaceTextureEntry = textureRegistry.createSurfaceTexture()
    private val channel = MethodChannel(messenger, "flexible_video_player")
    private val eventChannel = EventChannel(messenger, "flexible_video_player_event")
    private var currentActivity: Activity? = null

    private var player: FlexibleVideoPlayerTexture? = null
    @Volatile
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var lifecycleCallbacks: Application.ActivityLifecycleCallbacks

    private val positionTick = object : Runnable {
        override fun run() {
            try {
                if (player == null) return
                val pos = player?.getCurrentPosition()
                val dur = player?.getDuration()
                val payload = mapOf(
                    "event" to "position",
                    "position" to pos,
                    "duration" to dur,
                    "id" to player?.getTextureId()
                )
                eventSink?.success(payload)
            } catch (t: Throwable) {
                eventSink?.error("position_error", t.message, null)
            } finally {
                // only continue if a listener is still attached and player exists
                if (eventSink != null && player != null) {
                    handler.postDelayed(this, 250)
                }
            }
        }
    }

    private val pipTick = object : Runnable {
        override fun run() {
            try {
                if (player == null) return
                val inPip = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    currentActivity?.isInPictureInPictureMode ?: false
                } else false
                val payload = mapOf(
                    "event" to "pipState",
                    "inPip" to inPip,
                    "id" to player?.getTextureId()
                )
                eventSink?.success(payload)
            } catch (t: Throwable) {
                eventSink?.error("pip_error", t.message, null)
            } finally {
                // only continue if a listener is still attached and player exists
                if (eventSink != null && player != null) {
                    handler.postDelayed(this, 250)
                }
            }
        }
    }

    private val stateTick = object : Runnable {
        override fun run() {
            try {
                if (player == null) return
                val payload = mapOf(
                    "event" to "state",
                    "playing" to player?.isPlaying(),
                    "id" to player?.getTextureId()
                )
                eventSink?.success(payload)
            } catch (t: Throwable) {
                eventSink?.error("state_error", t.message, null)
            }
        }
    }
    private val application: Application? = (currentActivity?.application ?: (context.applicationContext as? Application))


    init {
        lifecycleCallbacks = object : Application.ActivityLifecycleCallbacks {
            override fun onActivityPaused(activity: Activity) {
                if (activity == currentActivity) {
                    handler.post(pipTick)
                }
            }

            override fun onActivityResumed(activity: Activity) {
                if (activity == currentActivity) {
                    handler.post(pipTick)
                }
            }

            override fun onActivityStarted(activity: Activity) {}
            override fun onActivityStopped(activity: Activity) {}
            override fun onActivityDestroyed(activity: Activity) {
                if (activity == currentActivity) {
                    currentActivity = null
                }
            }
            override fun onActivitySaveInstanceState(activity: Activity, outState: android.os.Bundle) {}
            override fun onActivityCreated(activity: Activity, savedInstanceState: android.os.Bundle?) {}
        }
        application?.registerActivityLifecycleCallbacks(lifecycleCallbacks)

        channel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                android.util.Log.d("FlexiblePlayer", "onListen arguments=$arguments, currentPlayer=${player?.getTextureId()}")

                val idArg = (arguments as? Map<*, *>)?.get("id")
                val requestedId: Long? = when (idArg) {
                    is Number -> idArg.toLong()
                    is String -> idArg.toLongOrNull()
                    else -> null
                }

                val currentPlayerId: Long? = player?.getTextureId()

                when {
                    requestedId == null -> {
                        if (player == null) {
                            android.util.Log.w("FlexiblePlayer", "listener rejected: no player created yet. requested=null")
                            events?.error("no_player", "no player created yet. call create()/initialize() before subscribing", null)
                            return
                        }
                        android.util.Log.d("FlexiblePlayer", "no id requested - accepting listener (requested=null)")
                        eventSink = events
                        handler.post(positionTick)
                        handler.post(pipTick)
                        handler.post(stateTick)
                    }

                    currentPlayerId != null && requestedId == currentPlayerId -> {
                        if (eventSink != null) {
                            events?.error("already_listening", "A listener is already registered for this texture (native)", null)
                            return
                        }
                        android.util.Log.d("FlexiblePlayer", "listener accepted for id=$requestedId")
                        eventSink = events
                        handler.post(positionTick)
                        handler.post(pipTick)
                        handler.post(stateTick)
                    }

                    currentPlayerId == null -> {
                        android.util.Log.w("FlexiblePlayer", "listener rejected: no player created yet. requested=$requestedId")
                        events?.error("no_player", "no player created yet. call create()/initialize() before subscribing", null)
                    }

                    else -> {
                        android.util.Log.w("FlexiblePlayer", "listener rejected - id mismatch requested=$requestedId native=$currentPlayerId")
                        events?.error("invalid_id", "id mismatch: requested=$requestedId native=$currentPlayerId", null)
                    }
                }
            }

            override fun onCancel(arguments: Any?) {
                android.util.Log.d("FlexiblePlayer", "onCancel called")
                handler.removeCallbacks(positionTick)
                handler.removeCallbacks(stateTick)
                handler.removeCallbacks(pipTick)
                player?.setEventSink(null)
                eventSink = null
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "create" -> {
                // Dispose old player if exists
                player?.dispose()
                player = FlexibleVideoPlayerTexture(context, currentActivity, textureRegistry)
                player?.setEventSink(eventSink)
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
                application?.unregisterActivityLifecycleCallbacks(lifecycleCallbacks)
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
            "checkPlaying" -> {
                result.success(player?.isPlaying())
            }
            "selectTrack" -> {
                val args = call.arguments as Map<String, Any>
                val rendererIndex = (args["rendererIndex"] as Number).toInt()
                val groupIndex = (args["groupIndex"] as Number).toInt()
                val trackIndex = (args["trackIndex"] as Number).toInt()
                player?.selectTrack(rendererIndex, groupIndex, trackIndex)
                result.success(null)
            }
            // "clearOverrides" -> {
            //     clearOverrides()
            //     result.success(null)
            // }
            // PIP related:
            "isPipSupported" -> {
                result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            }
            "isInPipMode" -> {
                result.success(player?.hostActivity?.isInPictureInPictureMode ?: false)
            }
            "enterPictureInPicture" -> {
                val entered = player?.enterPipMode()
                result.success(entered)
            }
            "setPipAspectRatio" -> {
                val w = call.argument<Int>("width") ?: 16
                val h = call.argument<Int>("height") ?: 9
                player?.pipAspectRatio = Rational(w, h)
                result.success(null)
            }
            "setAutoEnterPipOnPause" -> {
                val enabled = call.argument<Boolean>("enabled") ?: false
                player?.setAutoEnterPip(enabled)
                result.success(null)
            }
            "enterFullscreen" -> {
                 player?.enterFullscreen()
                result.success(null)
            }
            "exitFullscreen" -> {
                 player?.exitFullscreen()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
    fun setActivity(activity: Activity?) {
        this.currentActivity = activity
    }
}