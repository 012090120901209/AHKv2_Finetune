#Requires AutoHotkey v2.1-alpha.17

/**
* Module Tier 1 Example 06: Constants Consumer
*
* This example demonstrates:
* - Using exported constants
* - Accessing static class properties
* - Using exported configuration classes
*
* USAGE: Run this file directly
*
* @requires Module_Tier1_05_Constants_Module.ahk
*/

#SingleInstance Force

Import Constants

; ============================================================
; Example 1: Mathematical Constants
; ============================================================

radius := 5
area := Constants.PI * (radius ** 2)
circumference := 2 * Constants.PI * radius

MsgBox("Circle with radius " radius ":"
. "`nArea: " Format("{:.2f}", area)
. "`nCircumference: " Format("{:.2f}", circumference)
. "`n`nUsing PI = " Constants.PI,
"Math Constants - Circle", "Icon!")

; Exponential calculation
value := Constants.E ** 2

MsgBox("e² = " Format("{:.4f}", value)
. "`n`nUsing E = " Constants.E,
"Math Constants - Exponential", "Icon!")

; ============================================================
; Example 2: Application Configuration
; ============================================================

appInfo := Constants.Config.GetInfo()
isDebug := Constants.Config.IsDebug()

MsgBox(appInfo
. "`n`nDebug Mode: " (isDebug ? "Enabled" : "Disabled")
. "`nLog Level: " Constants.Config.LOG_LEVEL,
"Application Configuration", "Icon!")

; ============================================================
; Example 3: HTTP Status Codes
; ============================================================

; Simulate HTTP responses
status1 := Constants.HttpStatus.OK
status2 := Constants.HttpStatus.NOT_FOUND
status3 := Constants.HttpStatus.INTERNAL_SERVER_ERROR

result := "HTTP Status Codes:`n`n"
result .= status1 ": " Constants.HttpStatus.GetDescription(status1)
result .= " - " (Constants.HttpStatus.IsSuccess(status1) ? "✓ Success" : "✗ Error")
result .= "`n"

result .= status2 ": " Constants.HttpStatus.GetDescription(status2)
result .= " - " (Constants.HttpStatus.IsSuccess(status2) ? "✓ Success" : "✗ Error")
result .= "`n"

result .= status3 ": " Constants.HttpStatus.GetDescription(status3)
result .= " - " (Constants.HttpStatus.IsSuccess(status3) ? "✓ Success" : "✗ Error")

MsgBox(result, "HTTP Status Codes", "Icon!")

; ============================================================
; Example 4: Color Constants
; ============================================================

redHex := Constants.Colors.RGBToHex(255, 0, 0)
blueRGB := Constants.Colors.HexToRGB(Constants.Colors.BLUE)

MsgBox("Color Utilities:`n`n"
. "RED (RGB 255,0,0) → " redHex "`n"
. "BLUE (0x" Format("{:06X}", Constants.Colors.BLUE) ") → RGB("
. blueRGB.r ", " blueRGB.g ", " blueRGB.b ")",
"Color Constants", "Icon!")

; ============================================================
; Example 5: Keyboard Keys
; ============================================================

; Create hotkey combinations
combo1 := Constants.Keys.Combine("F1", Constants.Keys.CTRL)
combo2 := Constants.Keys.Combine("S", Constants.Keys.CTRL, Constants.Keys.SHIFT)

MsgBox("Keyboard Shortcuts:`n`n"
. "Help: " combo1 " (Ctrl+F1)`n"
. "Save All: " combo2 " (Ctrl+Shift+S)",
"Keyboard Keys", "Icon!")

; ============================================================
; Example 6: Time Constants
; ============================================================

timeout := Constants.Time.SecondsToMs(5)
interval := Constants.Time.MinutesToMs(2)
duration := Constants.Time.HoursToMs(1)

MsgBox("Time Conversions:`n`n"
. "5 seconds = " timeout " ms`n"
. "2 minutes = " interval " ms`n"
. "1 hour = " duration " ms",
"Time Constants", "Icon!")

; ============================================================
; Example 7: File Size Constants
; ============================================================

file1 := 1500
file2 := 5242880
file3 := 1073741824

MsgBox("File Size Formatting:`n`n"
. file1 " bytes → " Constants.FileSize.Format(file1) "`n"
. file2 " bytes → " Constants.FileSize.Format(file2) "`n"
. file3 " bytes → " Constants.FileSize.Format(file3),
"File Size Constants", "Icon!")

; ============================================================
; Example 8: Practical Use Case - Configuration
; ============================================================

class Application {
    name := ""
    version := ""
    timeout := 0

    __New() {
        ; Use imported constants for configuration
        global Constants

        this.name := Constants.Config.APP_NAME
        this.version := Constants.Config.VERSION
        this.timeout := Constants.Time.SecondsToMs(30)
    }

    GetInfo() {
        return this.name " v" this.version
        . "`nTimeout: " this.timeout " ms"
    }

    Log(message) {
        if Constants.Config.IsDebug() {
            OutputDebug("[" Constants.Config.LOG_LEVEL "] " message)
        }
    }
}

app := Application()
MsgBox(app.GetInfo(), "Practical Use Case - App Config", "Icon!")
