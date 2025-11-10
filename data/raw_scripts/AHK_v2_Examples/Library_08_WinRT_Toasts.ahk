#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinRT - Toast Notifications
 *
 * Demonstrates creating modern Windows 10/11 toast notifications
 * using Windows Runtime APIs.
 *
 * Library: https://github.com/Lexikos/winrt.ahk
 * Note: Requires Windows 10+ and proper app registration
 */

MsgBox("WinRT - Toast Notifications Example`n`n"
     . "Demonstrates Windows 10+ toast notifications`n"
     . "Requires: winrt.ahk and Windows 10+`n`n"
     . "Note: Some features require app registration", , "T5")

/*
; Uncomment to run (requires winrt.ahk):

#Include <winrt.ahk>

; Example 1: Simple Text Toast
MsgBox("Example 1: Creating simple toast notification...", , "T2")

try {
    ; Get the toast manager
    ToastNotificationManager := WinRT('Windows.UI.Notifications.ToastNotificationManager')

    ; Get notifier for PowerShell (which is registered)
    ; For custom app, need to register AppUserModelID
    notifier := ToastNotificationManager.CreateToastNotifier("Microsoft.WindowsTerminal_8wekyb3d8bbwe!App")

    ; Create XML content
    xml := "
    (
    <toast>
        <visual>
            <binding template='ToastGeneric'>
                <text>Hello from AutoHotkey!</text>
                <text>This is a toast notification created with WinRT</text>
            </binding>
        </visual>
    </toast>
    )"

    ; Load XML
    XmlDocument := WinRT('Windows.Data.Xml.Dom.XmlDocument')
    toastXml := XmlDocument.Construct()
    toastXml.LoadXml(xml)

    ; Create and show toast
    ToastNotification := WinRT('Windows.UI.Notifications.ToastNotification')
    toast := ToastNotification.Construct(toastXml)
    notifier.Show(toast)

    MsgBox("Toast notification sent!", , "T3")
} catch as e {
    MsgBox("Toast notification example`n(Requires proper app registration)", , "T3")
}

; Example 2: Toast with Image
MsgBox("Example 2: Toast with image...", , "T2")

xmlWithImage := "
(
<toast>
    <visual>
        <binding template='ToastGeneric'>
            <text>Task Completed</text>
            <text>Your automation task has finished successfully</text>
            <image placement='appLogoOverride' hint-crop='circle' src='C:\Windows\System32\@facial-recognition.png'/>
        </binding>
    </visual>
</toast>
)"

MsgBox("Toast XML with image:`n`n" xmlWithImage "`n`n(Requires proper image path)", , "T5")

; Example 3: Toast with Actions
MsgBox("Example 3: Toast with action buttons...", , "T2")

xmlWithActions := "
(
<toast>
    <visual>
        <binding template='ToastGeneric'>
            <text>New Message</text>
            <text>You have a new message from Alice</text>
        </binding>
    </visual>
    <actions>
        <action content='Reply' arguments='reply' />
        <action content='Dismiss' arguments='dismiss' />
    </actions>
</toast>
)"

MsgBox("Toast XML with actions:`n`n" xmlWithActions, , "T5")

; Example 4: Toast Scenarios
MsgBox("Example 4: Different toast scenarios", , "T2")

scenarios := Map(
    "reminder", "Reminder - Stays visible longer",
    "alarm", "Alarm - Persistent, with audio",
    "incomingCall", "Incoming Call - Full screen",
    "urgent", "Urgent - High priority"
)

result := "Toast Scenarios:`n`n"
for name, desc in scenarios {
    result .= name ": " desc "`n"
}

MsgBox(result, , "T5")

; Example 5: Progress Toast
MsgBox("Example 5: Toast with progress bar", , "T2")

xmlWithProgress := "
(
<toast>
    <visual>
        <binding template='ToastGeneric'>
            <text>Downloading File</text>
            <text>Please wait...</text>
            <progress
                value='0.6'
                valueStringOverride='60%'
                title='setup.exe'
                status='Downloading...'/>
        </binding>
    </visual>
</toast>
)"

MsgBox("Toast XML with progress:`n`n" xmlWithProgress, , "T5")
*/

/*
 * Key Concepts:
 *
 * 1. Toast Manager:
 *    ToastNotificationManager.CreateToastNotifier(appId)
 *    appId: App User Model ID
 *    Requires registered app
 *
 * 2. XML Template:
 *    <toast> root element
 *    <visual> for content
 *    <binding template='ToastGeneric'> layout
 *    <text> for text lines
 *
 * 3. Toast Components:
 *    <text> - Text lines (1-3)
 *    <image> - Images (logo, hero, inline)
 *    <progress> - Progress bar
 *    <actions> - Buttons
 *    <audio> - Sound effects
 *
 * 4. Image Placement:
 *    appLogoOverride - Small logo
 *    hero - Large top image
 *    inline - Inline image
 *
 * 5. Action Buttons:
 *    <action content='Label' arguments='data'/>
 *    Up to 5 buttons
 *    Can have quick reply
 *
 * 6. Scenarios:
 *    reminder - Longer duration
 *    alarm - Persistent, audio
 *    incomingCall - Full screen
 *    urgent - High priority
 *
 * 7. App Registration:
 *    Need AppUserModelID
 *    Register in Registry or Start Menu
 *    Or use existing app (PowerShell, etc)
 *
 * 8. Use Cases:
 *    ✅ Automation completion alerts
 *    ✅ Reminders
 *    ✅ Progress notifications
 *    ✅ System events
 *    ✅ Interactive alerts
 *
 * 9. Best Practices:
 *    ✅ Keep text concise
 *    ✅ Use appropriate scenario
 *    ✅ Don't overuse sounds
 *    ✅ Test on target Windows version
 *    ✅ Handle registration properly
 *
 * 10. Advanced Features:
 *     Groups and subgroups
 *     Adaptive layouts
 *     Custom timestamps
 *     Attribution text
 *     Inline images/buttons
 *
 * 11. Audio Options:
 *     <audio src='ms-winsoundevent:Notification.Default'/>
 *     silent='true' for no sound
 *     loop='true' for alarms
 *
 * 12. Limitations:
 *     ⚠ Requires app registration
 *     ⚠ Windows 10+ only
 *     ⚠ May not work in scripts
 *     ⚠ User can disable
 */
