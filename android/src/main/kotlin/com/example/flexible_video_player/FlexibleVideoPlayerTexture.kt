package com.example.flexible_video_player

import android.app.Activity
import android.app.Application
import android.app.PendingIntent
import android.app.PictureInPictureParams
import android.app.RemoteAction
import android.content.BroadcastReceiver
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.graphics.drawable.Icon
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Rational
import android.view.Surface
import android.view.View

import androidx.annotation.RequiresApi

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.view.TextureRegistry

import com.google.android.exoplayer2.C
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.Format
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.Player
import com.google.android.exoplayer2.Tracks
import com.google.android.exoplayer2.ui.PlayerView
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector.SelectionOverride
import com.google.android.exoplayer2.trackselection.MappingTrackSelector
import com.google.android.exoplayer2.trackselection.MappingTrackSelector.MappedTrackInfo
import android.content.pm.ActivityInfo
import android.view.WindowInsets
import android.view.WindowInsetsController


class FlexibleVideoPlayerTexture(
    private val context: Context,
     val hostActivity: Activity?,
    private val textureRegistry: TextureRegistry
) {

    // PiP related
    var pipAspectRatio: Rational? = null
    private var autoEnterOnPause: Boolean = false
    private lateinit var lifecycleCallbacks: Application.ActivityLifecycleCallbacks
//     val hostActivity: Activity? = findActivity(context)
//    private val application: Application? = (hostActivity?.application ?: (context.applicationContext as? Application))

    private lateinit var pipReceiver: BroadcastReceiver

    private val ACTION_PLAY = "native.video.PLAY"
    private val ACTION_PAUSE = "native.video.PAUSE"

    private val trackSelector = DefaultTrackSelector(context)
    private val player: ExoPlayer =
        ExoPlayer.Builder(context).setTrackSelector(trackSelector).build()

    private val textureEntry: TextureRegistry.SurfaceTextureEntry =
        textureRegistry.createSurfaceTexture()
    private val surface: Surface = Surface(textureEntry.surfaceTexture())

    private var eventSink: EventChannel.EventSink? = null

    init {
        player.setVideoSurface(surface)
        pipReceiver = object : BroadcastReceiver() {
            override fun onReceive(ctx: Context?, intent: Intent?) {
                when (intent?.action) {
                    ACTION_PLAY -> player.play()
                    ACTION_PAUSE -> player.pause()
                }
                updatePipActions()
            }
        }

        val flags = if (Build.VERSION.SDK_INT >= 33) Context.RECEIVER_NOT_EXPORTED else 0
        context.registerReceiver(pipReceiver, IntentFilter().apply {
            addAction(ACTION_PLAY)
            addAction(ACTION_PAUSE)
        }, flags)
    }
    private var isFullscreen = false
    fun setEventSink(sink: EventChannel.EventSink?) {
        eventSink = sink
    }

    fun setUrl(url: String) {
        val mediaItem = MediaItem.fromUri(url)
        player.setMediaItem(mediaItem)
        player.prepare()
        player.playWhenReady = true
        if (autoEnterOnPause && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            updatePipParamsForAuto()
        }
    }

    fun getTextureId(): Long = textureEntry.id()

    fun play() {
        player.play()
    }

    fun pause() {
        player.pause()
    }

    fun seekTo(position: Long) {
        player.seekTo(position)
    }

    fun getCurrentPosition(): Long {
        return player.currentPosition
    }

    fun getDuration(): Long {
        return player.duration
    }

    fun isPlaying(): Boolean {
        return player.isPlaying
    }

    fun getTracksMap(): Map<String, Any> {
        val out = HashMap<String, Any>()
        val audio = ArrayList<Map<String, Any>>()
        val text = ArrayList<Map<String, Any>>()
        val video = ArrayList<Map<String, Any>>()

        val mappedInfo = trackSelector.currentMappedTrackInfo
        if (mappedInfo != null) {
            for (rendererIndex in 0 until mappedInfo.rendererCount) {
                val rendererType = mappedInfo.getRendererType(rendererIndex)
                val groups = mappedInfo.getTrackGroups(rendererIndex)
                for (groupIndex in 0 until groups.length) {
                    val group = groups[groupIndex]
                    for (trackIndex in 0 until group.length) {
                        val format = group.getFormat(trackIndex)
                        val entry = mapOf(
                            "rendererIndex" to rendererIndex,
                            "groupIndex" to groupIndex,
                            "trackIndex" to trackIndex,
                            "mimeType" to (format.sampleMimeType ?: ""),
                            "language" to (format.language ?: ""),
                            "label" to (format.label ?: (format.language
                                ?: format.bitrate.toString()))
                        )
                        when (rendererType) {
                            C.TRACK_TYPE_AUDIO -> audio.add(entry)
                            C.TRACK_TYPE_TEXT -> text.add(entry)
                            C.TRACK_TYPE_VIDEO -> video.add(entry)
                        }
                    }
                }
            }
        } else {
            try {
                val tracks: Tracks = player.currentTracks
                var rendererCounter = 0
                for (group in tracks.groups) {
                    val type = group.type
                    val mediaGroup = group.mediaTrackGroup
                    for (i in 0 until mediaGroup.length) {
                        val f = mediaGroup.getFormat(i)
                        val base = mapOf(
                            "rendererIndex" to rendererCounter,
                            "groupIndex" to 0,
                            "trackIndex" to i,
                            "label" to (f.label ?: ""),
                            "language" to (f.language ?: ""),
                            "mimeType" to (f.sampleMimeType ?: "")
                        )
                        when (type) {
                            C.TRACK_TYPE_AUDIO -> audio.add(base)
                            C.TRACK_TYPE_TEXT -> text.add(base)
                            C.TRACK_TYPE_VIDEO -> video.add(base)
                        }
                    }
                    rendererCounter++
                }
            } catch (e: Exception) {
                // ignore if not available yet
            }
        }

        out["audio"] = audio
        out["text"] = text
        out["video"] = video

        // --- NEW: gather currently selected tracks (if available) ---
        val currentAudio = ArrayList<Map<String, Any>>()
        val currentText = ArrayList<Map<String, Any>>()
        val currentVideo = ArrayList<Map<String, Any>>()

        try {
            val tracks: Tracks = player.currentTracks
            var rendererCounter = 0
            for (group in tracks.groups) {
                val type = group.type
                val mediaGroup = group.mediaTrackGroup
                // mediaGroup.length matches the number of formats in this group
                for (i in 0 until mediaGroup.length) {
                    // group.isTrackSelected(i) returns true if this track is selected for playback
                    if (group.isTrackSelected(i)) {
                        val f = mediaGroup.getFormat(i)
                        val entry = mapOf(
                            "rendererIndex" to rendererCounter,
                            "groupIndex" to 0,
                            "trackIndex" to i,
                            "mimeType" to (f.sampleMimeType ?: ""),
                            "language" to (f.language ?: ""),
                            "label" to (f.label ?: (f.language ?: f.bitrate.toString()))
                        )
                        when (type) {
                            C.TRACK_TYPE_AUDIO -> currentAudio.add(entry)
                            C.TRACK_TYPE_TEXT -> currentText.add(entry)
                            C.TRACK_TYPE_VIDEO -> currentVideo.add(entry)
                        }
                    }
                }
                rendererCounter++
            }
        } catch (e: Exception) {
            // currentTracks might not be available yet; leave current lists empty
        }

        out["current_audio"] = currentAudio
        out["current_text"] = currentText
        out["current_video"] = currentVideo

        return out
    }


    @Suppress("DEPRECATION")
    fun selectTrack(rendererIndex: Int, groupIndex: Int, trackIndex: Int) {
        val mapped = trackSelector.currentMappedTrackInfo ?: return
        if (rendererIndex < 0 || rendererIndex >= mapped.rendererCount) return

        val groups = mapped.getTrackGroups(rendererIndex) // TrackGroupArray
        if (groupIndex < 0 || groupIndex >= groups.length) return

        val override = DefaultTrackSelector.SelectionOverride(groupIndex, trackIndex)

        val paramsBuilder = trackSelector.buildUponParameters()
        paramsBuilder.setSelectionOverride(rendererIndex, groups, override)

        trackSelector.setParameters(paramsBuilder.build())
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun enterPipMode(): Boolean {
        val activity = hostActivity ?: return false
        val params = PictureInPictureParams.Builder()
            .setAspectRatio(pipAspectRatio ?: Rational(16, 9))
            .setActions(createPipActions())
            .build()
        return activity.enterPictureInPictureMode(params)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createPipActions(): List<RemoteAction> {
        val actions = mutableListOf<RemoteAction>()

        if (player.isPlaying) {
            val pauseIntent = PendingIntent.getBroadcast(
                context, 0, Intent(ACTION_PAUSE), PendingIntent.FLAG_IMMUTABLE
            )
            actions.add(
                RemoteAction(
                    Icon.createWithResource(context, android.R.drawable.ic_media_pause),
                    "Pause", "Pause", pauseIntent
                )
            )
        } else {
            val playIntent = PendingIntent.getBroadcast(
                context, 1, Intent(ACTION_PLAY), PendingIntent.FLAG_IMMUTABLE
            )
            actions.add(
                RemoteAction(
                    Icon.createWithResource(context, android.R.drawable.ic_media_play),
                    "Play", "Play", playIntent
                )
            )
        }
        return actions
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun updatePipActions() {
        val activity = hostActivity ?: return
        if (activity.isInPictureInPictureMode) {
            activity.setPictureInPictureParams(
                PictureInPictureParams.Builder()
                    .setAspectRatio(pipAspectRatio ?: Rational(16, 9))
                    .setActions(createPipActions())
                    .build()
            )
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun enterPipInternal(activity: Activity) {
        val params = PictureInPictureParams.Builder()
            .setAspectRatio(pipAspectRatio ?: Rational(16, 9))
            .setActions(createPipActions())
            .build()
        activity.enterPictureInPictureMode(params)
    }

    fun setAutoEnterPip(enabled: Boolean) {
        autoEnterOnPause = enabled
        if (enabled && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            updatePipParamsForAuto()
        }
    }

    @RequiresApi(Build.VERSION_CODES.S)
    private fun updatePipParamsForAuto() {
        val activity = hostActivity ?: return
        val params = PictureInPictureParams.Builder()
            .setAspectRatio(pipAspectRatio ?: Rational(16, 9))
            .setActions(createPipActions())
            .setAutoEnterEnabled(true)
            .build()
        activity.setPictureInPictureParams(params)
    }
    // ---------------- FULLSCREEN ----------------

    fun enterFullscreen() {
        val activity = hostActivity ?: return
        if (isFullscreen) return

        // Landscape + hide system bars
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
        hideSystemUi(activity)
        isFullscreen = true
    }

    fun exitFullscreen() : Boolean{
        val activity = hostActivity ?: return false
        if (!isFullscreen) return false

        // Back to unspecified orientation + show system bars
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
        showSystemUi(activity)
        isFullscreen = false
        return true
    }

    private fun hideSystemUi(activity: Activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            activity.window.insetsController?.let {
                it.hide(WindowInsets.Type.statusBars() or WindowInsets.Type.navigationBars())
                it.systemBarsBehavior = WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
            }
        } else {
            @Suppress("DEPRECATION")
            activity.window.decorView.systemUiVisibility =
                (View.SYSTEM_UI_FLAG_FULLSCREEN
                        or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                        or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                        or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION)
        }
    }

    private fun showSystemUi(activity: Activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            activity.window.insetsController?.show(WindowInsets.Type.statusBars() or WindowInsets.Type.navigationBars())
        } else {
            @Suppress("DEPRECATION")
            activity.window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_VISIBLE
        }
    }

    fun dispose() {
        player.release()
        surface.release()
        textureEntry.release()
    }
}