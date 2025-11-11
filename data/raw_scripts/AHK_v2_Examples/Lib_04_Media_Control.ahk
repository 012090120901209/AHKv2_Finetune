#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Media Control - Universal Media Session Control
 *
 * Demonstrates controlling media playback across applications
 * using Windows UWP Media Control interface (Spotify, Chrome,
 * media players, etc.)
 *
 * Source: nperovic-AHK-v2-Libraries/Lib/Media.ahk
 * Inspired by: https://github.com/nperovic/AHK-v2-Libraries
 */

#Include <Media>

; Create GUI for media control
global mediaGui := Gui()
mediaGui.Title := "Universal Media Controller"

; Now Playing display
mediaGui.Add("GroupBox", "w500 h150", "Now Playing")
global titleCtrl := mediaGui.Add("Text", "xp+10 yp+25 w480", "No media playing")
global artistCtrl := mediaGui.Add("Text", "xp yp+25 w480", "")
global albumCtrl := mediaGui.Add("Text", "xp yp+20 w480", "")
global statusCtrl := mediaGui.Add("Text", "xp yp+20 w480", "Status: Idle")
global sourceCtrl := mediaGui.Add("Text", "xp yp+20 w480", "Source: None")

; Playback controls
mediaGui.Add("GroupBox", "x10 y+10 w500 h80", "Playback Controls")
mediaGui.Add("Button", "xp+10 yp+25 w95 h40", "⏮ Previous").OnEvent("Click", (*) => DoPrevious())
mediaGui.Add("Button", "x+5 w95 h40", "⏯ Play/Pause").OnEvent("Click", (*) => DoPlayPause())
mediaGui.Add("Button", "x+5 w95 h40", "⏹ Stop").OnEvent("Click", (*) => DoStop())
mediaGui.Add("Button", "x+5 w95 h40", "⏭ Next").OnEvent("Click", (*) => DoNext())
mediaGui.Add("Button", "x+5 w95 h40", "🔄 Refresh").OnEvent("Click", (*) => UpdateDisplay())

; Session selector
mediaGui.Add("GroupBox", "x10 y+10 w500 h80", "Media Sessions")
global sessionList := mediaGui.Add("ListBox", "xp+10 yp+25 w480 h45")
sessionList.OnEvent("Change", (*) => SwitchSession())

mediaGui.Show()

; Initialize
UpdateDisplay()

; Set timer to refresh display
SetTimer(UpdateDisplay, 2000)

; ===============================================
; MEDIA SESSION FUNCTIONS
; ===============================================

/**
 * Get and display current media session
 */
UpdateDisplay() {
    global titleCtrl, artistCtrl, albumCtrl, statusCtrl, sourceCtrl, sessionList
    global currentSession

    try {
        ; Try to get current session
        currentSession := Media.GetCurrentSession()

        if (currentSession) {
            ; Update display
            titleCtrl.Value := "Title: " (currentSession.Title || "Unknown")
            artistCtrl.Value := "Artist: " (currentSession.Artist || "Unknown")
            albumCtrl.Value := "Album: " (currentSession.Album || "Unknown")
            statusCtrl.Value := "Status: " currentSession.PlaybackStatus
            sourceCtrl.Value := "Source: " currentSession.SourceAppId

        } else {
            titleCtrl.Value := "No media playing"
            artistCtrl.Value := ""
            albumCtrl.Value := ""
            statusCtrl.Value := "Status: No active session"
            sourceCtrl.Value := "Source: None"
        }

        ; Update session list
        sessions := Media.GetSessions()
        sessionList.Delete()

        if (sessions.Length > 0) {
            for session in sessions {
                appName := session.SourceAppId
                title := session.Title || "Unknown"
                sessionList.Add([appName ": " title])
            }
            sessionList.Choose(1)
        } else {
            sessionList.Add(["No active sessions"])
        }

    } catch Error as e {
        titleCtrl.Value := "Error: " e.Message
    }
}

/**
 * Switch to selected session
 */
SwitchSession() {
    global sessionList, currentSession

    selected := sessionList.Value
    if (selected == 0)
        return

    try {
        sessions := Media.GetSessions()
        if (selected <= sessions.Length) {
            currentSession := sessions[selected]
            UpdateDisplay()
        }
    }
}

; ===============================================
; PLAYBACK CONTROL FUNCTIONS
; ===============================================

/**
 * Toggle play/pause
 */
DoPlayPause() {
    global currentSession

    if (!IsSet(currentSession) || !currentSession)
        return UpdateDisplay()

    try {
        if (currentSession.PlaybackStatus == "Playing")
            currentSession.Pause()
        else
            currentSession.Play()

        Sleep(500)
        UpdateDisplay()
    } catch Error as e {
        MsgBox("Error: " e.Message, "Playback Error")
    }
}

/**
 * Stop playback
 */
DoStop() {
    global currentSession

    if (!IsSet(currentSession) || !currentSession)
        return UpdateDisplay()

    try {
        currentSession.Stop()
        Sleep(500)
        UpdateDisplay()
    } catch Error as e {
        MsgBox("Error: " e.Message, "Stop Error")
    }
}

/**
 * Previous track
 */
DoPrevious() {
    global currentSession

    if (!IsSet(currentSession) || !currentSession)
        return UpdateDisplay()

    try {
        currentSession.SkipPrevious()
        Sleep(500)
        UpdateDisplay()
    } catch Error as e {
        MsgBox("Error: " e.Message, "Skip Error")
    }
}

/**
 * Next track
 */
DoNext() {
    global currentSession

    if (!IsSet(currentSession) || !currentSession)
        return UpdateDisplay()

    try {
        currentSession.SkipNext()
        Sleep(500)
        UpdateDisplay()
    } catch Error as e {
        MsgBox("Error: " e.Message, "Skip Error")
    }
}

; ===============================================
; GLOBAL HOTKEYS
; ===============================================

; Media keys
Media_Play_Pause::DoPlayPause()
Media_Stop::DoStop()
Media_Prev::DoPrevious()
Media_Next::DoNext()

/*
 * Key Concepts:
 *
 * 1. Media Session Manager:
 *    Windows UWP Media Control API
 *    System-wide media control
 *    Works with modern apps
 *
 * 2. Getting Sessions:
 *    Media.GetCurrentSession() - Active session
 *    Media.GetSessions() - All sessions
 *    Sessions array
 *
 * 3. Session Properties:
 *    session.Title - Track title
 *    session.Artist - Artist name
 *    session.Album - Album name
 *    session.PlaybackStatus - Playing/Paused/Stopped
 *    session.SourceAppId - App identifier
 *
 * 4. Playback Control:
 *    session.Play() - Start playback
 *    session.Pause() - Pause playback
 *    session.Stop() - Stop playback
 *    session.SkipNext() - Next track
 *    session.SkipPrevious() - Previous track
 *
 * 5. Supported Apps:
 *    ✅ Spotify
 *    ✅ Chrome (YouTube, etc.)
 *    ✅ Edge browser
 *    ✅ Windows Media Player
 *    ✅ Groove Music
 *    ✅ VLC (with plugin)
 *    ❌ Old apps without Media Session API
 *
 * 6. Use Cases:
 *    ✅ Universal media remote
 *    ✅ Now playing display
 *    ✅ Keyboard shortcuts
 *    ✅ Media widget
 *    ✅ Integration with other apps
 *
 * 7. Multi-Session:
 *    Multiple apps playing simultaneously
 *    Switch between sessions
 *    Control each independently
 *
 * 8. Session Events:
 *    Monitor playback changes
 *    Detect track changes
 *    Update UI automatically
 *
 * 9. Thumbnail Support:
 *    session.Thumbnail - Album art
 *    Requires ImagePut library
 *    Bitmap or file path
 *
 * 10. Playback Info:
 *     PlaybackStatus values:
 *     - "Playing"
 *     - "Paused"
 *     - "Stopped"
 *     - "Closed"
 *     - "Changing"
 *
 * 11. Best Practices:
 *     ✅ Check if session exists
 *     ✅ Handle errors gracefully
 *     ✅ Refresh periodically
 *     ✅ Validate commands
 *
 * 12. Advanced Features:
 *     - Timeline position
 *     - Playback rate
 *     - Shuffle/Repeat state
 *     - Playlist info
 *
 * 13. Common Patterns:
 *     Now playing widget
 *     Global media hotkeys
 *     Notification display
 *     OSD (on-screen display)
 *     Stream deck integration
 *
 * 14. Limitations:
 *     ⚠ Requires Windows 10/11
 *     ⚠ Apps must support Media Session API
 *     ⚠ Limited control over some apps
 *     ⚠ No volume control (use SoundSet)
 *
 * 15. Integration Examples:
 *     - Discord presence
 *     - Last.fm scrobbling
 *     - Lyrics display
 *     - Smart home control
 *     - Voice commands
 */
