/**
 * ============================================================================
 * AutoHotkey v2 #SingleInstance Directive - Multi-Instance Management
 * ============================================================================
 * 
 * @description Comprehensive examples for managing multiple script instances
 *              with different #SingleInstance modes
 * 
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 * 
 * DIRECTIVE: #SingleInstance
 * FOCUS: Ignore, Prompt, and Off modes; Multi-instance scenarios
 * 
 * MODES DEMONSTRATED:
 *   - Ignore: Skip new instance, keep old
 *   - Prompt: Ask user what to do
 *   - Off: Allow multiple instances
 * 
 * @reference https://www.autohotkey.com/docs/v2/lib/_SingleInstance.htm
 */

#Requires AutoHotkey v2.0
#SingleInstance Prompt
; Note: Using Force mode for this demonstration script
; Change to Ignore/Prompt/Off to test different behaviors

/**
 * ============================================================================
 * Example 1: Ignore Mode Demonstration
 * ============================================================================
 * 
 * @description Keep existing instance, prevent new ones
 * @concept Instance protection, prevent duplicates
 */

/**
 * Ignore mode information class
 * @class
 */
class IgnoreModeInfo {
    /**
     * Explain Ignore mode behavior
     * @returns {void}
     */
    static Explain() {
        info := "Ignore Mode (#SingleInstance Ignore)`n"
        info .= "====================================`n`n"

        info .= "Behavior:`n"
        info .= "  • First instance keeps running`n"
        info .= "  • New instances exit immediately`n"
        info .= "  • No user prompts`n"
        info .= "  • Silent operation`n`n"

        info .= "Best For:`n"
        info .= "  ✓ Production scripts`n"
        info .= "  ✓ System tray applications`n"
        info .= "  ✓ Auto-start programs`n"
        info .= "  ✓ Background monitors`n`n"

        info .= "Usage:`n"
        info .= "  #SingleInstance Ignore`n`n"

        info .= "Example Scenario:`n"
        info .= "  Script starts at Windows startup`n"
        info .= "  User accidentally double-clicks icon`n"
        info .= "  → Second instance exits silently`n"
        info .= "  → First instance continues running"

        MsgBox(info, "Ignore Mode", "Iconi")
    }

    /**
     * Test Ignore mode behavior
     * @returns {void}
     */
    static TestBehavior() {
        instructions := "Testing Ignore Mode`n"
        instructions .= "===================`n`n"

        instructions .= "To test Ignore mode:`n`n"

        instructions .= "1. Change line at top of script to:`n"
        instructions .= "   #SingleInstance Ignore`n`n"

        instructions .= "2. Save and run the script`n`n"

        instructions .= "3. Try to run script again`n"
        instructions .= "   → Second instance will exit`n"
        instructions .= "   → No message will appear`n"
        instructions .= "   → First instance stays active`n`n"

        instructions .= "4. Check tray icon`n"
        instructions .= "   → Only one icon visible`n`n"

        instructions .= "Current mode: Prompt`n"
        instructions .= "(Change to Ignore to test)"

        MsgBox(instructions, "Test Instructions", "Iconi")
    }
}

^!1:: IgnoreModeInfo.Explain()
^!+1:: IgnoreModeInfo.TestBehavior()

/**
 * ============================================================================
 * Example 2: Prompt Mode Demonstration
 * ============================================================================
 * 
 * @description Ask user what to do with multiple instances
 * @concept User control, dialog prompts, choice
 */

/**
 * Prompt mode information class
 * @class
 */
class PromptModeInfo {
    /**
     * Explain Prompt mode behavior
     * @returns {void}
     */
    static Explain() {
        info := "Prompt Mode (#SingleInstance Prompt)`n"
        info .= "=====================================`n`n"

        info .= "Behavior:`n"
        info .= "  • Shows dialog when new instance starts`n"
        info .= "  • User chooses: Replace or Keep old`n"
        info .= "  • Provides control to user`n"
        info .= "  • Safe for important scripts`n`n"

        info .= "Dialog Options:`n"
        info .= "  'Yes' - Replace old instance with new`n"
        info .= "  'No' - Keep old instance, cancel new`n`n"

        info .= "Best For:`n"
        info .= "  ✓ Critical scripts`n"
        info .= "  ✓ Scripts with important state`n"
        info .= "  ✓ User-facing applications`n"
        info .= "  ✓ When user should decide`n`n"

        info .= "Usage:`n"
        info .= "  #SingleInstance Prompt`n`n"

        info .= "Current Mode: " this.GetCurrentMode()

        MsgBox(info, "Prompt Mode", "Iconi")
    }

    /**
     * Get current single instance mode
     * @returns {String} Mode name
     */
    static GetCurrentMode() {
        ; This script is using Prompt mode
        return "Prompt"
    }

    /**
     * Simulate prompt dialog
     * @returns {void}
     */
    static SimulatePrompt() {
        msg := "An older instance of this script is already running.`n`n"
        msg .= "Replace old instance?`n`n"
        msg .= "Yes - Close old, start new`n"
        msg .= "No - Keep old, cancel new"

        result := MsgBox(msg, "Simulated Prompt", "YesNo Icon?")

        if (result = "Yes")
            MsgBox("User chose: Replace old instance", "Result", "Iconi")
        else
            MsgBox("User chose: Keep old instance", "Result", "Iconi")
    }
}

^!2:: PromptModeInfo.Explain()
^!+2:: PromptModeInfo.SimulatePrompt()

/**
 * ============================================================================
 * Example 3: Off Mode - Multiple Instances
 * ============================================================================
 * 
 * @description Allow multiple simultaneous instances
 * @concept Multiple instances, parallel execution
 */

/**
 * Off mode information and multi-instance management
 * @class
 */
class OffModeInfo {
    /**
     * Explain Off mode behavior
     * @returns {void}
     */
    static Explain() {
        info := "Off Mode (#SingleInstance Off)`n"
        info .= "==============================`n`n"

        info .= "Behavior:`n"
        info .= "  • Allows multiple instances`n"
        info .= "  • Each instance independent`n"
        info .= "  • No restrictions`n"
        info .= "  • No prompts or checks`n`n"

        info .= "Considerations:`n"
        info .= "  ⚠ Shared file access conflicts`n"
        info .= "  ⚠ Global hotkey conflicts`n"
        info .= "  ⚠ Resource usage multiplied`n"
        info .= "  ⚠ System tray clutter`n`n"

        info .= "Best For:`n"
        info .= "  ✓ Tools that work on different files`n"
        info .= "  ✓ Independent workers`n"
        info .= "  ✓ Parallel processing`n"
        info .= "  ✓ Multi-window applications`n`n"

        info .= "Usage:`n"
        info .= "  #SingleInstance Off`n`n"

        info .= "Example Use Case:`n"
        info .= "  Text processor that works on`n"
        info .= "  different files simultaneously"

        MsgBox(info, "Off Mode", "Iconi")
    }

    /**
     * Detect multiple instances
     * @returns {Array} List of script instances
     */
    static DetectInstances() {
        instances := []
        scriptName := A_ScriptName

        ; This is a simplified detection
        ; In Off mode, you would implement actual detection
        instances.Push({
            PID: ProcessExist(),
            Name: scriptName,
            Path: A_ScriptFullPath
        })

        return instances
    }

    /**
     * Show instance list
     * @returns {void}
     */
    static ShowInstances() {
        instances := this.DetectInstances()

        output := "Script Instances`n"
        output .= "================`n`n"

        output .= "Mode: Off allows multiple instances`n`n"

        output .= "Current Instance:`n"
        output .= "  PID: " ProcessExist() "`n"
        output .= "  Name: " A_ScriptName "`n`n"

        output .= "Detected Instances: " instances.Length "`n"

        for inst in instances {
            output .= "`nInstance:`n"
            output .= "  PID: " inst.PID "`n"
            output .= "  Name: " inst.Name "`n"
        }

        MsgBox(output, "Instances", "Iconi")
    }
}

^!3:: OffModeInfo.Explain()
^!+3:: OffModeInfo.ShowInstances()

/**
 * ============================================================================
 * Example 4: Instance Communication
 * ============================================================================
 * 
 * @description Communicate between multiple instances
 * @concept Inter-process communication, message passing
 */

/**
 * Instance communication manager
 * @class
 */
class InstanceCommunication {
    static MessageFile := A_Temp "\AHK_InstanceMessages.txt"
    static InstanceID := Random(10000, 99999)

    /**
     * Send message to other instances
     * @param {String} message - Message to send
     * @returns {void}
     */
    static SendMessage(message) {
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        fullMessage := timestamp " [" this.InstanceID "] " message "`n"

        try {
            FileAppend(fullMessage, this.MessageFile)
            TrayTip("Message sent", "Communication", "Iconi Mute")
        } catch Error as err {
            MsgBox("Failed to send message: " err.Message, "Error", "Icon!")
        }
    }

    /**
     * Read messages from other instances
     * @param {Integer} maxLines - Max lines to read
     * @returns {String} Messages
     */
    static ReadMessages(maxLines := 10) {
        if (!FileExist(this.MessageFile))
            return "No messages"

        try {
            content := FileRead(this.MessageFile)
            lines := StrSplit(content, "`n")

            ; Get last N lines
            startLine := Max(1, lines.Length - maxLines + 1)
            messages := ""

            Loop (lines.Length - startLine + 1) {
                line := lines[startLine + A_Index - 1]
                if (line != "")
                    messages .= line "`n"
            }

            return messages
        }

        return "Error reading messages"
    }

    /**
     * Clear message file
     * @returns {void}
     */
    static ClearMessages() {
        if FileExist(this.MessageFile) {
            try {
                FileDelete(this.MessageFile)
                TrayTip("Messages cleared", "Communication", "Iconi Mute")
            }
        }
    }

    /**
     * Show communication interface
     * @returns {void}
     */
    static ShowInterface() {
        output := "Instance Communication`n"
        output .= "======================`n`n"

        output .= "Instance ID: " this.InstanceID "`n`n"

        output .= "Recent Messages:`n"
        output .= "---------------`n"
        output .= this.ReadMessages() "`n`n"

        output .= "Actions:`n"
        output .= "^!+send - Send test message`n"
        output .= "^!+read - Read messages`n"
        output .= "^!+clr - Clear messages"

        MsgBox(output, "Communication", "Iconi")
    }
}

^!+send:: InstanceCommunication.SendMessage("Test message from instance")
^!+read:: MsgBox(InstanceCommunication.ReadMessages(), "Messages", "Iconi")
^!+clr:: InstanceCommunication.ClearMessages()
^!4:: InstanceCommunication.ShowInterface()

/**
 * ============================================================================
 * Example 5: Mode Comparison and Selection
 * ============================================================================
 * 
 * @description Compare all modes and choose appropriate one
 * @concept Mode selection, decision matrix
 */

/**
 * Mode comparison helper
 * @class
 */
class ModeComparison {
    /**
     * Display comprehensive comparison
     * @returns {void}
     */
    static ShowComparison() {
        comp := "#SingleInstance Mode Comparison`n"
        comp .= "================================`n`n"

        comp .= "FORCE:`n"
        comp .= "  New instance replaces old automatically`n"
        comp .= "  → Development, testing, frequent updates`n`n"

        comp .= "IGNORE:`n"
        comp .= "  New instance exits, old keeps running`n"
        comp .= "  → Production, tray apps, auto-start`n`n"

        comp .= "PROMPT:`n"
        comp .= "  User decides: Replace or Keep`n"
        comp .= "  → Critical scripts, user control`n`n"

        comp .= "OFF:`n"
        comp .= "  Multiple instances allowed`n"
        comp .= "  → Parallel processing, different files`n`n"

        comp .= "Decision Guide:`n"
        comp .= "---------------`n"
        comp .= "Development? → FORCE`n"
        comp .= "Production background? → IGNORE`n"
        comp .= "Important data? → PROMPT`n"
        comp .= "Multiple needed? → OFF`n`n"

        comp .= "Current Mode: Prompt"

        MsgBox(comp, "Mode Comparison", "Iconi")
    }

    /**
     * Show decision tree
     * @returns {void}
     */
    static ShowDecisionTree() {
        tree := "Mode Selection Decision Tree`n"
        tree .= "============================`n`n"

        tree .= "Q1: Allow multiple instances?`n"
        tree .= "  Yes → Use OFF mode`n"
        tree .= "  No → Continue to Q2`n`n"

        tree .= "Q2: Development or production?`n"
        tree .= "  Development → Use FORCE`n"
        tree .= "  Production → Continue to Q3`n`n"

        tree .= "Q3: User should decide?`n"
        tree .= "  Yes → Use PROMPT`n"
        tree .= "  No → Use IGNORE`n`n"

        tree .= "Summary:`n"
        tree .= "  Multiple needed → OFF`n"
        tree .= "  Dev/Testing → FORCE`n"
        tree .= "  User control → PROMPT`n"
        tree .= "  Silent prevention → IGNORE"

        MsgBox(tree, "Decision Tree", "Iconi")
    }
}

^!5:: ModeComparison.ShowComparison()
^!+5:: ModeComparison.ShowDecisionTree()

/**
 * ============================================================================
 * Example 6: Instance Management Utilities
 * ============================================================================
 * 
 * @description Utilities for managing script instances
 * @concept Instance control, management tools
 */

/**
 * Instance management utilities
 * @class
 */
class InstanceManager {
    /**
     * Check if script is already running
     * @returns {Boolean} True if another instance exists
     */
    static IsAlreadyRunning() {
        ; Simplified check
        ; Real implementation would check for other processes
        return false
    }

    /**
     * Get count of running instances
     * @returns {Integer} Number of instances
     */
    static GetInstanceCount() {
        ; This would count actual running instances
        ; For demo, return 1
        return 1
    }

    /**
     * Kill all other instances
     * @returns {Integer} Number of instances killed
     */
    static KillOtherInstances() {
        msg := "Kill Other Instances`n"
        msg .= "====================`n`n"

        msg .= "This would terminate all other instances`n"
        msg .= "of this script.`n`n"

        msg .= "Use cases:`n"
        msg .= "  • Cleanup before reload`n"
        msg .= "  • Force single instance`n"
        msg .= "  • Reset script state`n`n"

        msg .= "Implementation would use:`n"
        msg .= "  ProcessClose() or WinClose()`n"
        msg .= "  to close other instances`n`n"

        msg .= "Current instances: " this.GetInstanceCount()

        MsgBox(msg, "Instance Management", "Iconi")
    }

    /**
     * Show instance management options
     * @returns {void}
     */
    static ShowOptions() {
        options := "Instance Management Options`n"
        options .= "===========================`n`n"

        options .= "Detection:`n"
        options .= "  • Check if already running`n"
        options .= "  • Count instances`n"
        options .= "  • Get instance PIDs`n`n"

        options .= "Control:`n"
        options .= "  • Kill other instances`n"
        options .= "  • Send reload command`n"
        options .= "  • Coordinate instances`n`n"

        options .= "Communication:`n"
        options .= "  • Share data via files`n"
        options .= "  • Use Windows messages`n"
        options .= "  • Named pipes/sockets`n`n"

        options .= "Current: " this.GetInstanceCount() " instance(s)"

        MsgBox(options, "Management", "Iconi")
    }
}

^!6:: InstanceManager.ShowOptions()
^!+6:: InstanceManager.KillOtherInstances()

/**
 * ============================================================================
 * Example 7: Best Practices for Each Mode
 * ============================================================================
 * 
 * @description Mode-specific best practices
 * @concept Guidelines, recommendations, patterns
 */

/**
 * Best practices guide
 * @class
 */
class BestPracticesGuide {
    /**
     * Show best practices for all modes
     * @returns {void}
     */
    static ShowAll() {
        guide := "Multi-Instance Best Practices`n"
        guide .= "=============================`n`n"

        guide .= "FORCE Mode:`n"
        guide .= "  ✓ Save state before reload`n"
        guide .= "  ✓ Log reload events`n"
        guide .= "  ✗ Don't use with critical data`n`n"

        guide .= "IGNORE Mode:`n"
        guide .= "  ✓ Use for tray applications`n"
        guide .= "  ✓ Perfect for auto-start`n"
        guide .= "  ✗ No way to force update`n`n"

        guide .= "PROMPT Mode:`n"
        guide .= "  ✓ Let user control behavior`n"
        guide .= "  ✓ Safe for important scripts`n"
        guide .= "  ✗ Requires user interaction`n`n"

        guide .= "OFF Mode:`n"
        guide .= "  ✓ Use unique identifiers`n"
        guide .= "  ✓ Avoid shared resources`n"
        guide .= "  ✗ Watch for conflicts"

        MsgBox(guide, "Best Practices", "Iconi")
    }

    /**
     * Show common pitfalls
     * @returns {void}
     */
    static ShowPitfalls() {
        pitfalls := "Common Pitfalls`n"
        pitfalls .= "===============`n`n"

        pitfalls .= "⚠ Wrong Mode Choice`n"
        pitfalls .= "  Using OFF when should use IGNORE`n"
        pitfalls .= "  Using FORCE in production`n`n"

        pitfalls .= "⚠ Shared Resource Conflicts`n"
        pitfalls .= "  Multiple instances writing same file`n"
        pitfalls .= "  Global hotkey registration`n`n"

        pitfalls .= "⚠ State Loss`n"
        pitfalls .= "  Not saving before FORCE reload`n"
        pitfalls .= "  Forgetting to restore state`n`n"

        pitfalls .= "⚠ User Confusion`n"
        pitfalls .= "  Multiple tray icons (OFF mode)`n"
        pitfalls .= "  Unclear prompt messages`n`n"

        pitfalls .= "Solutions:`n"
        pitfalls .= "  • Choose appropriate mode`n"
        pitfalls .= "  • Implement state persistence`n"
        pitfalls .= "  • Use clear messaging`n"
        pitfalls .= "  • Test all scenarios"

        MsgBox(pitfalls, "Pitfalls", "Icon!")
    }
}

^!7:: BestPracticesGuide.ShowAll()
^!+7:: BestPracticesGuide.ShowPitfalls()

/**
 * ============================================================================
 * STARTUP
 * ============================================================================
 */

global InstanceID := Random(10000, 99999)

TrayTip(
    "Mode: Prompt`n"
    "Instance: " InstanceID,
    "Script Started",
    "Iconi Mute"
)

/**
 * Help
 */
^!h:: {
    help := "Multi-Instance Management`n"
    help .= "=========================`n`n"

    help .= "Mode Information:`n"
    help .= "^!1 - Ignore mode`n"
    help .= "^!2 - Prompt mode`n"
    help .= "^!3 - Off mode`n`n"

    help .= "Communication:`n"
    help .= "^!4 - Instance comm`n"
    help .= "^!+send - Send message`n"
    help .= "^!+read - Read messages`n`n"

    help .= "Comparison:`n"
    help .= "^!5 - Mode comparison`n"
    help .= "^!+5 - Decision tree`n`n"

    help .= "Management:`n"
    help .= "^!6 - Management options`n"
    help .= "^!7 - Best practices`n"
    help .= "^!+7 - Common pitfalls`n`n"

    help .= "Current Mode: Prompt`n"
    help .= "Instance: " InstanceID

    MsgBox(help, "Help", "Iconi")
}
