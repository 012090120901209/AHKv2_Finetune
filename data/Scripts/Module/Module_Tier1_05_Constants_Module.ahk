#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

/**
 * Module Tier 1 Example 05: Constants Module
 * 
 * This example demonstrates:
 * - Exporting constant values
 * - Exporting configuration classes
 * - Organizing application constants
 * - Read-only configuration patterns
 * 
 * @module Constants
 */

#Module Constants

; ============================================================
; Mathematical Constants
; ============================================================

/**
 * PI constant (π)
 * @const {Number}
 */
Export PI := 3.14159265359

/**
 * Euler's number (e)
 * @const {Number}
 */
Export E := 2.71828182846

/**
 * Golden ratio (φ)
 * @const {Number}
 */
Export GOLDEN_RATIO := 1.61803398875

/**
 * Square root of 2
 * @const {Number}
 */
Export SQRT2 := 1.41421356237

/**
 * Natural log of 2
 * @const {Number}
 */
Export LN2 := 0.69314718056

/**
 * Natural log of 10
 * @const {Number}
 */
Export LN10 := 2.30258509299

; ============================================================
; Application Configuration
; ============================================================

/**
 * Application configuration constants
 * @class Config
 */
Export class Config {
    static APP_NAME := "AutoHotkey Module Demo"
    static VERSION := "1.0.0"
    static AUTHOR := "AHK Developer"
    static DEBUG := true
    static LOG_LEVEL := "INFO"

    /**
     * Get full application info string
     * @returns {String} - Formatted app info
     */
    static GetInfo() {
        return this.APP_NAME " v" this.VERSION " by " this.AUTHOR
    }

    /**
     * Check if debug mode is enabled
     * @returns {Boolean} - True if debug mode
     */
    static IsDebug() {
        return this.DEBUG
    }
}

; ============================================================
; HTTP Status Codes
; ============================================================

/**
 * Common HTTP status codes
 * @class HttpStatus
 */
Export class HttpStatus {
    ; Success
    static OK := 200
    static CREATED := 201
    static ACCEPTED := 202
    static NO_CONTENT := 204

    ; Redirection
    static MOVED_PERMANENTLY := 301
    static FOUND := 302
    static NOT_MODIFIED := 304

    ; Client Errors
    static BAD_REQUEST := 400
    static UNAUTHORIZED := 401
    static FORBIDDEN := 403
    static NOT_FOUND := 404
    static METHOD_NOT_ALLOWED := 405
    static CONFLICT := 409

    ; Server Errors
    static INTERNAL_SERVER_ERROR := 500
    static NOT_IMPLEMENTED := 501
    static BAD_GATEWAY := 502
    static SERVICE_UNAVAILABLE := 503

    /**
     * Get status code description
     * @param code {Number} - HTTP status code
     * @returns {String} - Description
     */
    static GetDescription(code) {
        switch code {
            case 200: return "OK"
            case 201: return "Created"
            case 204: return "No Content"
            case 400: return "Bad Request"
            case 401: return "Unauthorized"
            case 403: return "Forbidden"
            case 404: return "Not Found"
            case 500: return "Internal Server Error"
            default: return "Unknown Status"
        }
    }

    /**
     * Check if status code is successful (2xx)
     * @param code {Number} - HTTP status code
     * @returns {Boolean} - True if success
     */
    static IsSuccess(code) {
        return code >= 200 && code < 300
    }
}

; ============================================================
; Color Constants
; ============================================================

/**
 * Common color values (RGB hex)
 * @class Colors
 */
Export class Colors {
    ; Basic colors
    static WHITE := 0xFFFFFF
    static BLACK := 0x000000
    static RED := 0xFF0000
    static GREEN := 0x00FF00
    static BLUE := 0x0000FF
    static YELLOW := 0xFFFF00
    static CYAN := 0x00FFFF
    static MAGENTA := 0xFF00FF

    ; Grays
    static GRAY := 0x808080
    static LIGHT_GRAY := 0xD3D3D3
    static DARK_GRAY := 0xA9A9A9

    ; Common UI colors
    static ORANGE := 0xFFA500
    static PURPLE := 0x800080
    static PINK := 0xFFC0CB
    static BROWN := 0xA52A2A

    /**
     * Convert RGB to hex string
     * @param r {Number} - Red (0-255)
     * @param g {Number} - Green (0-255)
     * @param b {Number} - Blue (0-255)
     * @returns {String} - Hex color string
     */
    static RGBToHex(r, g, b) {
        return Format("#{:02X}{:02X}{:02X}", r, g, b)
    }

    /**
     * Convert hex to RGB values
     * @param hex {Number} - Hex color value
     * @returns {Object} - {r, g, b} object
     */
    static HexToRGB(hex) {
        return {
            r: (hex >> 16) & 0xFF,
            g: (hex >> 8) & 0xFF,
            b: hex & 0xFF
        }
    }
}

; ============================================================
; Keyboard Keys
; ============================================================

/**
 * Virtual key codes
 * @class Keys
 */
Export class Keys {
    ; Function keys
    static F1 := "F1"
    static F2 := "F2"
    static F3 := "F3"
    static F4 := "F4"
    static F5 := "F5"
    static F6 := "F6"
    static F7 := "F7"
    static F8 := "F8"
    static F9 := "F9"
    static F10 := "F10"
    static F11 := "F11"
    static F12 := "F12"

    ; Modifiers
    static CTRL := "^"
    static ALT := "!"
    static SHIFT := "+"
    static WIN := "#"

    ; Special keys
    static ENTER := "Enter"
    static ESC := "Escape"
    static TAB := "Tab"
    static SPACE := "Space"
    static BACKSPACE := "Backspace"
    static DELETE := "Delete"

    ; Arrow keys
    static UP := "Up"
    static DOWN := "Down"
    static LEFT := "Left"
    static RIGHT := "Right"

    /**
     * Create hotkey combination string
     * @param key {String} - Key name
     * @param modifiers {Array} - Array of modifier strings
     * @returns {String} - Hotkey string
     */
    static Combine(key, modifiers*) {
        combo := ""
        for modifier in modifiers
            combo .= modifier
        combo .= key
        return combo
    }
}

; ============================================================
; Time Constants
; ============================================================

/**
 * Time duration constants (in milliseconds)
 * @class Time
 */
Export class Time {
    static MILLISECOND := 1
    static SECOND := 1000
    static MINUTE := 60000
    static HOUR := 3600000
    static DAY := 86400000
    static WEEK := 604800000

    /**
     * Convert seconds to milliseconds
     * @param seconds {Number} - Seconds
     * @returns {Number} - Milliseconds
     */
    static SecondsToMs(seconds) {
        return seconds * this.SECOND
    }

    /**
     * Convert minutes to milliseconds
     * @param minutes {Number} - Minutes
     * @returns {Number} - Milliseconds
     */
    static MinutesToMs(minutes) {
        return minutes * this.MINUTE
    }

    /**
     * Convert hours to milliseconds
     * @param hours {Number} - Hours
     * @returns {Number} - Milliseconds
     */
    static HoursToMs(hours) {
        return hours * this.HOUR
    }
}

; ============================================================
; File Sizes
; ============================================================

/**
 * File size constants (in bytes)
 * @class FileSize
 */
Export class FileSize {
    static BYTE := 1
    static KB := 1024
    static MB := 1048576
    static GB := 1073741824
    static TB := 1099511627776

    /**
     * Format bytes to human-readable string
     * @param bytes {Number} - Size in bytes
     * @returns {String} - Formatted size
     */
    static Format(bytes) {
        if bytes < this.KB
            return bytes " B"
        if bytes < this.MB
            return Format("{:.2f} KB", bytes / this.KB)
        if bytes < this.GB
            return Format("{:.2f} MB", bytes / this.MB)
        if bytes < this.TB
            return Format("{:.2f} GB", bytes / this.GB)
        return Format("{:.2f} TB", bytes / this.TB)
    }
}
