#Requires AutoHotkey v2.0

/**
* BuiltIn_FileGetAttrib_16.ahk
*
* DESCRIPTION:
* Attribute monitoring and change detection
*
* FEATURES:
* - Monitor attribute changes
* - Detect unauthorized modifications
* - Track attribute history
* - Alert on attribute changes
* - Attribute integrity checking
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/FileGetAttrib.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - FileGetAttrib() for monitoring
* - Attribute change detection
* - State tracking
* - Integrity validation
* - Alert systems
*
* LEARNING POINTS:
* 1. Monitor file attributes over time
* 2. Detect unauthorized changes
* 3. Track attribute modification history
* 4. Implement integrity checks
* 5. Alert on suspicious changes
* 6. Maintain attribute baselines
*/

; ============================================================
; Example 1: Attribute Change Detection
; ============================================================

/**
* Detect if file attributes have changed
*
* @param {String} filePath - File to monitor
* @param {String} baselineAttrs - Original attributes
* @returns {Object} - Change detection result
*/
DetectAttributeChange(filePath, baselineAttrs) {
    result := {
        changed: false,
        currentAttrs: "",
        added: [],
        removed: []
    }

    if (!FileExist(filePath))
    return result

    currentAttrs := FileGetAttrib(filePath)
    result.currentAttrs := currentAttrs

    if (currentAttrs = baselineAttrs)
    return result

    result.changed := true

    ; Detect added attributes
    loop parse, currentAttrs {
        if (!InStr(baselineAttrs, A_LoopField))
        result.added.Push(A_LoopField)
    }

    ; Detect removed attributes
    loop parse, baselineAttrs {
        if (!InStr(currentAttrs, A_LoopField))
        result.removed.Push(A_LoopField)
    }

    return result
}

; Create test file and get baseline
testFile := A_ScriptDir "\monitor_test.txt"
FileAppend("Test content", testFile)
baseline := FileGetAttrib(testFile)

; Modify attributes
FileSetAttrib("+R", testFile)

; Detect changes
changes := DetectAttributeChange(testFile, baseline)

output := "ATTRIBUTE CHANGE DETECTION:`n`n"
output .= "Baseline: " baseline "`n"
output .= "Current: " changes.currentAttrs "`n"
output .= "Changed: " (changes.changed ? "YES" : "NO") "`n`n"

if (changes.added.Length > 0) {
    output .= "Added Attributes: "
    for attr in changes.added
    output .= attr " "
    output .= "`n"
}

if (changes.removed.Length > 0) {
    output .= "Removed Attributes: "
    for attr in changes.removed
    output .= attr " "
    output .= "`n"
}

MsgBox(output, "Change Detection", changes.changed ? "IconX" : "Icon!")

FileSetAttrib("-R", testFile)

; ============================================================
; Example 2: Attribute Monitoring Class
; ============================================================

class AttributeMonitor {
    __New(filePath) {
        this.filePath := filePath
        this.history := []
        this.RecordSnapshot()
    }

    RecordSnapshot() {
        if (!FileExist(this.filePath))
        return false

        this.history.Push({
            timestamp: A_Now,
            attributes: FileGetAttrib(this.filePath)
        })
        return true
    }

    DetectChanges() {
        if (this.history.Length < 2)
        return {hasChanges: false}

        recent := this.history[this.history.Length]
        previous := this.history[this.history.Length - 1]

        return {
            hasChanges: (recent.attributes != previous.attributes),
            from: previous.attributes,
            to: recent.attributes,
            timestamp: recent.timestamp
        }
    }

    GetReport() {
        report := "ATTRIBUTE MONITOR REPORT:`n`n"
        report .= "File: " this.filePath "`n"
        report .= "Snapshots: " this.history.Length "`n`n"

        if (this.history.Length > 0) {
            report .= "History:`n"
            for snapshot in this.history {
                time := FormatTime(snapshot.timestamp, "HH:mm:ss")
                report .= "  " time ": " snapshot.attributes "`n"
            }
        }

        return report
    }
}

; Monitor attributes
monitor := AttributeMonitor(testFile)
Sleep(100)
FileSetAttrib("+H", testFile)
monitor.RecordSnapshot()
Sleep(100)
FileSetAttrib("-H", testFile)
monitor.RecordSnapshot()

MsgBox(monitor.GetReport(), "Attribute Monitor", "Icon!")

; ============================================================
; Example 3: Attribute Integrity Check
; ============================================================

/**
* Verify file attributes match expected state
*
* @param {String} filePath - File to check
* @param {String} expectedAttrs - Expected attributes
* @returns {Object} - Integrity check result
*/
CheckAttributeIntegrity(filePath, expectedAttrs) {
    result := {
        intact: false,
        message: ""
    }

    if (!FileExist(filePath)) {
        result.message := "File not found"
        return result
    }

    currentAttrs := FileGetAttrib(filePath)

    if (currentAttrs = expectedAttrs) {
        result.intact := true
        result.message := "Attributes match expected state"
    } else {
        result.intact := false
        result.message := "Attribute mismatch (Expected: " expectedAttrs ", Got: " currentAttrs ")"
    }

    return result
}

; Check integrity
expected := FileGetAttrib(testFile)
integrity := CheckAttributeIntegrity(testFile, expected)

MsgBox("INTEGRITY CHECK:`n`n"
. "Expected: " expected "`n"
. "Status: " (integrity.intact ? "INTACT ✓" : "COMPROMISED ✗") "`n"
. "Message: " integrity.message,
"Integrity", integrity.intact ? "Icon!" : "IconX")

; ============================================================
; Example 4: Unauthorized Change Alert
; ============================================================

/**
* Alert if critical attributes have been modified
*
* @param {String} filePath - File to check
* @param {String} criticalAttrs - Attributes that should not change
* @param {String} baseline - Baseline attributes
* @returns {Object} - Alert status
*/
AlertUnauthorizedChange(filePath, criticalAttrs, baseline) {
    result := {
        alert: false,
        violations: []
    }

    if (!FileExist(filePath))
    return result

    currentAttrs := FileGetAttrib(filePath)

    ; Check each critical attribute
    loop parse, criticalAttrs {
        criticalAttr := A_LoopField
        wasSet := InStr(baseline, criticalAttr)
        isSet := InStr(currentAttrs, criticalAttr)

        if (wasSet && !isSet) {
            result.alert := true
            result.violations.Push("Critical attribute removed: " criticalAttr)
        } else if (!wasSet && isSet) {
            result.alert := true
            result.violations.Push("Critical attribute added: " criticalAttr)
        }
    }

    return result
}

; Set baseline and check for changes
baselineAttrs := FileGetAttrib(testFile)
FileSetAttrib("+R", testFile)  ; Simulate unauthorized change

alert := AlertUnauthorizedChange(testFile, "R", baselineAttrs)

output := "UNAUTHORIZED CHANGE ALERT:`n`n"
output .= "Alert Triggered: " (alert.alert ? "YES ⚠" : "NO ✓") "`n`n"

if (alert.violations.Length > 0) {
    output .= "Violations Detected:`n"
    for violation in alert.violations
    output .= "  • " violation "`n"
}

MsgBox(output, "Security Alert", alert.alert ? "IconX" : "Icon!")

FileSetAttrib("-R", testFile)

; ============================================================
; Example 5: Attribute Baseline Management
; ============================================================

/**
* Manage attribute baselines for multiple files
*/
class BaselineManager {
    __New() {
        this.baselines := Map()
    }

    SetBaseline(filePath) {
        if (!FileExist(filePath))
        return false

        this.baselines[filePath] := FileGetAttrib(filePath)
        return true
    }

    VerifyBaseline(filePath) {
        if (!this.baselines.Has(filePath))
        return {verified: false, reason: "No baseline set"}

        if (!FileExist(filePath))
        return {verified: false, reason: "File not found"}

        baseline := this.baselines[filePath]
        current := FileGetAttrib(filePath)

        return {
            verified: (baseline = current),
            reason: (baseline = current)
            ? "Attributes match baseline"
            : "Attributes differ (Baseline: " baseline ", Current: " current ")"
        }
    }

    GetReport() {
        report := "BASELINE VERIFICATION REPORT:`n`n"
        report .= "Files Tracked: " this.baselines.Count "`n`n"

        for filePath, baseline in this.baselines {
            SplitPath(filePath, &name)
            verification := this.VerifyBaseline(filePath)
            report .= name ":`n"
            report .= "  Status: " (verification.verified ? "OK ✓" : "CHANGED ✗") "`n"
            report .= "  " verification.reason "`n`n"
        }

        return report
    }
}

; Test baseline manager
baselineMgr := BaselineManager()
baselineMgr.SetBaseline(testFile)

FileSetAttrib("+H", testFile)

MsgBox(baselineMgr.GetReport(), "Baseline Manager", "Icon!")

FileSetAttrib("-H", testFile)

; ============================================================
; Reference Information
; ============================================================

info := "
(
ATTRIBUTE MONITORING:

Monitoring Strategies:
1. Periodic Snapshots
• Record attributes at intervals
• Compare with previous state
• Alert on changes

2. Event-Based
• Check before/after operations
• Validate after external changes
• Monitor critical files

3. Baseline Comparison
• Establish known-good state
• Verify against baseline
• Report deviations

Change Detection:
baseline := FileGetAttrib(file)
current := FileGetAttrib(file)
if (current != baseline)
; Attributes changed

Security Implications:
• Read-only removal (R)
• Hidden attribute added (H)
• System attribute changed (S)
• Archive bit cleared (A)

Best Practices:
• Establish baselines early
• Monitor critical files
• Log all changes
• Alert on unauthorized changes
• Implement rollback capability
• Regular integrity checks
• Document expected states

Common Use Cases:
✓ Security monitoring
✓ Compliance verification
✓ Change tracking
✓ Integrity validation
✓ Audit trails
✓ Tamper detection
)"

MsgBox(info, "Monitoring Reference", "Icon!")

; Cleanup
FileDelete(testFile)
