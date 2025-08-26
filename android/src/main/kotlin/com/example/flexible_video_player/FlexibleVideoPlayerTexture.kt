package com.example.flexible_video_player

import android.content.Context
import android.view.Surface
import com.google.android.exoplayer2.MediaItem
import io.flutter.view.TextureRegistry
import com.google.android.exoplayer2.C
import com.google.android.exoplayer2.Format
import com.google.android.exoplayer2.Tracks
import com.google.android.exoplayer2.ExoPlayer

// Track selector / mapped info
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector
import com.google.android.exoplayer2.trackselection.MappingTrackSelector
import com.google.android.exoplayer2.trackselection.MappingTrackSelector.MappedTrackInfo

// Track group / arrays
import com.google.android.exoplayer2.source.TrackGroup
import com.google.android.exoplayer2.source.TrackGroupArray

class FlexibleVideoPlayerTexture(
    context: Context,
    private val textureRegistry: TextureRegistry
) {

    private val trackSelector = DefaultTrackSelector(context)
    private val player: ExoPlayer = ExoPlayer.Builder(context).setTrackSelector(trackSelector).build()

    private val textureEntry: TextureRegistry.SurfaceTextureEntry =
        textureRegistry.createSurfaceTexture()
    private val surface: Surface = Surface(textureEntry.surfaceTexture())

    init {
        player.setVideoSurface(surface)
    }

    fun setUrl(url: String) {
        val mediaItem = MediaItem.fromUri(url)
        player.setMediaItem(mediaItem)
        player.prepare()
        player.playWhenReady = true
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
                            "label" to (format.label ?: (format.language ?: format.bitrate.toString()))
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
        return out
    }

    fun dispose() {
        player.release()
        surface.release()
        textureEntry.release()
    }
}


