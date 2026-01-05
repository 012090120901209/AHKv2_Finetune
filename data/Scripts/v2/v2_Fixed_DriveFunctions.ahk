#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * AHK v2 Drive Functions
 * 
 * Functions for drive and disk operations
 */

/**
 * Eject/retract a CD/DVD drive
 * 
 * @param {String} drive - Drive letter (e.g., "D:")
 * @param {Integer} retract - 1 to retract, 0 to eject
 * @returns {Integer} Success (1) or failure (0)
 * 
 * Example: DriveEject("D:") or DriveEject("D:", 1) to retract
 */
DriveEjectExample() {
    drive := "D:"

    result := MsgBox("Eject drive " drive "?", "Drive Eject", "YesNo")

    if (result = "Yes") {
        try {
            DriveEject(drive)
            MsgBox("Drive ejected successfully")
        } catch Error as e {
            MsgBox("Error ejecting drive: " e.Message)
        }
    }
}

/**
 * Retract a CD/DVD drive
 */
DriveRetractExample() {
    drive := "D:"

    try {
        DriveRetract(drive)
        MsgBox("Drive retracted successfully")
    } catch Error as e {
        MsgBox("Error retracting drive: " e.Message)
    }
}

/**
 * Lock or unlock a drive
 * 
 * @param {String} drive - Drive letter
 * @param {Integer} lock - 1 to lock, 0 to unlock
 */
DriveLockExample() {
    drive := "D:"

    try {
        ; Lock the drive
        DriveLock(drive)
        MsgBox("Drive locked. Eject button disabled.")

        Sleep(3000)

        ; Unlock the drive
        DriveUnlock(drive)
        MsgBox("Drive unlocked. Eject button enabled.")
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }
}

/**
 * Get drive type
 * 
 * @param {String} path - Drive letter or path
 * @returns {String} Drive type: "Unknown", "Removable", "Fixed", "Network", "CDROM", "RAMDisk"
 */
DriveGetTypeExample() {
    drives := DriveGetList()

    output := "Drive Types:`n`n"

    for drive in StrSplit(drives) {
        driveLetter := drive ":"
        try {
            driveType := DriveGetType(driveLetter)
            output .= driveLetter " - " driveType "`n"
        } catch {
            output .= driveLetter " - Error`n"
        }
    }

    MsgBox(output)
}

/**
 * Get drive label (volume name)
 */
DriveGetLabelExample() {
    drive := "C:"

    try {
        label := DriveGetLabel(drive)
        MsgBox("Drive " drive " label: " (label ? label : "(No label)"))
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }
}

/**
 * Set drive label
 */
DriveSetLabelExample() {
    drive := "D:"
    newLabel := "MyDrive"

    result := MsgBox("Set label of " drive " to '" newLabel "'?", "Set Label", "YesNo")

    if (result = "Yes") {
        try {
            DriveSetLabel(drive, newLabel)
            MsgBox("Label set successfully")
        } catch Error as e {
            MsgBox("Error: " e.Message)
        }
    }
}

/**
 * Get drive filesystem
 */
DriveGetFilesystemExample() {
    drive := "C:"

    try {
        fs := DriveGetFilesystem(drive)
        MsgBox("Drive " drive " filesystem: " fs)
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }
}

/**
 * Get drive serial number
 */
DriveGetSerialExample() {
    drive := "C:"

    try {
        serial := DriveGetSerial(drive)
        MsgBox("Drive " drive " serial: " serial)
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }
}

/**
 * Get drive capacity and free space
 */
DriveGetSpaceExample() {
    drives := DriveGetList()

    output := "Drive Space Information:`n`n"

    for drive in StrSplit(drives) {
        driveLetter := drive ":"
        try {
            capacity := DriveGetCapacity(driveLetter)
            freeSpace := DriveGetSpaceFree(driveLetter)
            usedSpace := capacity - freeSpace
            usedPercent := Round((usedSpace / capacity) * 100, 1)

            output .= driveLetter "`n"
            output .= "  Capacity: " FormatBytes(capacity) "`n"
            output .= "  Used: " FormatBytes(usedSpace) " (" usedPercent "%)`n"
            output .= "  Free: " FormatBytes(freeSpace) "`n`n"
        } catch {
            output .= driveLetter " - Not ready`n`n"
        }
    }

    MsgBox(output)
}

/**
 * Get drive status
 */
DriveGetStatusExample() {
    drive := "C:"

    try {
        status := DriveGetStatus(drive)
        statusText := status = "Ready" ? "Ready"
            : status = "NotReady" ? "Not Ready"
            : status = "Invalid" ? "Invalid"
            : "Unknown"

        MsgBox("Drive " drive " status: " statusText)
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }
}

/**
 * Get all drives
 */
DriveGetListExample() {
    drives := DriveGetList()

    output := "All Drives:`n`n"

    for drive in StrSplit(drives) {
        output .= drive ": `n"
    }

    MsgBox(output)

    ; Get only fixed drives
    fixedDrives := DriveGetList("FIXED")
    output := "Fixed Drives:`n`n"
    for drive in StrSplit(fixedDrives) {
        output .= drive ": `n"
    }

    MsgBox(output)
}

/**
 * Helper function to format bytes
 */
FormatBytes(bytes) {
    if (bytes < 1024)
        return Round(bytes, 2) " B"
    else if (bytes < 1048576)
        return Round(bytes / 1024, 2) " KB"
    else if (bytes < 1073741824)
        return Round(bytes / 1048576, 2) " MB"
    else if (bytes < 1099511627776)
        return Round(bytes / 1073741824, 2) " GB"
    else
        return Round(bytes / 1099511627776, 2) " TB"
}

/**
 * Comprehensive drive information display
 */
ComprehensiveDriveInfoExample() {
    drives := DriveGetList()

    for drive in StrSplit(drives) {
        driveLetter := drive ":"

        try {
            info := "Drive Information: " driveLetter "`n"
            info .= "=" . StrReplace(info, ".", "=") . "`n`n"

            ; Type
            info .= "Type: " DriveGetType(driveLetter) "`n"

            ; Status
            info .= "Status: " DriveGetStatus(driveLetter) "`n"

            ; Filesystem
            try info .= "Filesystem: " DriveGetFilesystem(driveLetter) "`n"

            ; Label
            try {
                label := DriveGetLabel(driveLetter)
                info .= "Label: " (label ? label : "(No label)") "`n"
            }

            ; Serial
            try info .= "Serial: " DriveGetSerial(driveLetter) "`n"

            ; Space
            try {
                capacity := DriveGetCapacity(driveLetter)
                free := DriveGetSpaceFree(driveLetter)
                used := capacity - free
                info .= "`nCapacity: " FormatBytes(capacity) "`n"
                info .= "Used: " FormatBytes(used) " (" Round((used / capacity) * 100, 1) "%)`n"
                info .= "Free: " FormatBytes(free) " (" Round((free / capacity) * 100, 1) "%)`n"
            }

            MsgBox(info)
        } catch Error as e {
            MsgBox("Error reading " driveLetter ": " e.Message)
        }
    }
}

/**
 * Monitor drive space in real-time
 */
MonitorDriveSpaceExample() {
    drive := "C:"

    MsgBox("Monitoring " drive " space for 10 seconds...`nWatch the tooltip")

    startTime := A_TickCount

    loop {
        try {
            capacity := DriveGetCapacity(drive)
            free := DriveGetSpaceFree(drive)
            used := capacity - free
            usedPercent := Round((used / capacity) * 100, 1)

            ToolTip("Drive " drive " Space Monitor`n"
                . "Capacity: " FormatBytes(capacity) "`n"
                . "Used: " FormatBytes(used) " (" usedPercent "%)`n"
                . "Free: " FormatBytes(free))

            Sleep(1000)
        } catch {
            break
        }

        if (A_TickCount - startTime > 10000)
            break
    }

    ToolTip()
    MsgBox("Monitoring complete")
}

MsgBox("Drive Functions Loaded`n`n"
    . "Available Examples:`n"
    . "- DriveGetTypeExample()`n"
    . "- DriveGetSpaceExample()`n"
    . "- DriveGetListExample()`n"
    . "- ComprehensiveDriveInfoExample()`n"
    . "- MonitorDriveSpaceExample()")

; Uncomment to test:
; DriveGetTypeExample()
; DriveGetSpaceExample()
; DriveGetListExample()
; ComprehensiveDriveInfoExample()
; MonitorDriveSpaceExample()

