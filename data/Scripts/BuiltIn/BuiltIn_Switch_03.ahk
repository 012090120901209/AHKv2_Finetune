#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Control Flow - Switch Fall-Through Behavior
 * ============================================================================
 * 
 * This script demonstrates fall-through behavior in switch statements.
 * In AHK v2, switch statements do NOT fall through by default (unlike C).
 * Each case block executes independently.
 * 
 * @file BuiltIn_Switch_03.ahk
 * @author AHK v2 Examples Collection
 * @version 2.0.0
 * @date 2024-01-15
 * 
 * @description
 * Examples included:
 * 1. No fall-through by default in AHK v2
 * 2. Simulating fall-through with explicit logic
 * 3. Multiple cases sharing code (alternative to fall-through)
 * 4. Cumulative permissions pattern
 * 5. Range categorization
 * 6. State transitions
 * 7. Feature flags and capabilities
 * 
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: No Fall-Through by Default
; ============================================================================

/**
 * Demonstrates that AHK v2 switch does NOT fall through.
 * Each case executes its block only.
 */
Example1_NoFallThrough() {
    OutputDebug("=== Example 1: No Fall-Through by Default ===`n")

    value := "B"
    result := []

    ; Each case only executes its own block
    switch value {
        case "A":
            result.Push("Case A executed")
            OutputDebug("In case A`n")

        case "B":
            result.Push("Case B executed")
            OutputDebug("In case B`n")
            ; Does NOT fall through to case "C"

        case "C":
            result.Push("Case C executed")
            OutputDebug("In case C`n")

        default:
            result.Push("Default executed")
            OutputDebug("In default case`n")
    }

    OutputDebug("Results: " result.Length " item(s)`n")
    for item in result {
        OutputDebug("  - " item "`n")
    }

    ; Comparison with C-style fall-through (commented)
    OutputDebug("`n--- In C-style languages (with fall-through) ---`n")
    OutputDebug("If value='B' without breaks, you'd get:`n")
    OutputDebug("  - Case B executed`n")
    OutputDebug("  - Case C executed (fall-through)`n")
    OutputDebug("  - Default executed (fall-through)`n")

    OutputDebug("`n--- In AHK v2 (no fall-through) ---`n")
    OutputDebug("With value='B', you only get:`n")
    OutputDebug("  - Case B executed`n")
    OutputDebug("  (No automatic fall-through)`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 2: Simulating Fall-Through with Functions
; ============================================================================

/**
 * Demonstrates how to achieve fall-through-like behavior when needed.
 * Uses explicit function calls and logic.
 */
Example2_SimulatingFallThrough() {
    OutputDebug("=== Example 2: Simulating Fall-Through ===`n")

    ; Example: Permission levels where higher levels include lower permissions
    ProcessPermissionLevel(1)
    OutputDebug("`n")
    ProcessPermissionLevel(3)
    OutputDebug("`n")
    ProcessPermissionLevel(5)

    OutputDebug("`n")
}

/**
 * Simulates cumulative permissions (fall-through behavior).
 */
ProcessPermissionLevel(level) {
    permissions := []
    OutputDebug("Permission Level: " level "`n")

    ; Use if/else to simulate cumulative behavior
    if (level >= 5) {
        permissions.Push("DELETE")
    }
    if (level >= 4) {
        permissions.Push("UPDATE")
    }
    if (level >= 3) {
        permissions.Push("CREATE")
    }
    if (level >= 2) {
        permissions.Push("WRITE")
    }
    if (level >= 1) {
        permissions.Push("READ")
    }

    OutputDebug("Granted permissions:`n")
    for perm in permissions {
        OutputDebug("  - " perm "`n")
    }
}

; ============================================================================
; Example 3: Multiple Cases Sharing Code
; ============================================================================

/**
 * Demonstrates the proper AHK v2 way to share code between cases.
 * Uses comma-separated case values.
 */
Example3_MultipleCasesSharedCode() {
    OutputDebug("=== Example 3: Multiple Cases Sharing Code ===`n")

    ; This is the AHK v2 way to handle multiple cases
    ProcessCommand("start")
    ProcessCommand("begin")
    ProcessCommand("stop")
    ProcessCommand("end")

    OutputDebug("`n")
}

/**
 * Multiple cases execute the same code block.
 */
ProcessCommand(cmd) {
    OutputDebug("Command: " cmd "`n")

    switch cmd {
        case "start", "begin", "init", "launch":
            OutputDebug("  Action: Starting service...`n")
            status := "running"
            StartService()

        case "stop", "end", "terminate", "quit":
            OutputDebug("  Action: Stopping service...`n")
            status := "stopped"
            StopService()

        case "pause", "suspend":
            OutputDebug("  Action: Pausing service...`n")
            status := "paused"

        case "resume", "continue":
            OutputDebug("  Action: Resuming service...`n")
            status := "running"

        default:
            OutputDebug("  Action: Unknown command`n")
            status := "error"
    }

    OutputDebug("  New status: " status "`n`n")
}

StartService() {
    OutputDebug("    [Service started]`n")
}

StopService() {
    OutputDebug("    [Service stopped]`n")
}

; ============================================================================
; Example 4: Cumulative Permissions Pattern
; ============================================================================

/**
 * Demonstrates building cumulative permissions.
 * Shows how to handle hierarchical access levels.
 */
Example4_CumulativePermissions() {
    OutputDebug("=== Example 4: Cumulative Permissions ===`n")

    AssignPermissions("guest")
    OutputDebug("`n")
    AssignPermissions("user")
    OutputDebug("`n")
    AssignPermissions("admin")
    OutputDebug("`n")
    AssignPermissions("superadmin")

    OutputDebug("`n")
}

/**
 * Assigns cumulative permissions based on role.
 */
AssignPermissions(role) {
    capabilities := Map()
    capabilities["canView"] := false
    capabilities["canEdit"] := false
    capabilities["canDelete"] := false
    capabilities["canManageUsers"] := false
    capabilities["canConfigureSystem"] := false

    OutputDebug("Role: " role "`n")

    ; Use switch to set base capabilities, then enhance
    switch role {
        case "guest":
            capabilities["canView"] := true

        case "user":
            capabilities["canView"] := true
            capabilities["canEdit"] := true

        case "moderator":
            capabilities["canView"] := true
            capabilities["canEdit"] := true
            capabilities["canDelete"] := true

        case "admin":
            capabilities["canView"] := true
            capabilities["canEdit"] := true
            capabilities["canDelete"] := true
            capabilities["canManageUsers"] := true

        case "superadmin":
            capabilities["canView"] := true
            capabilities["canEdit"] := true
            capabilities["canDelete"] := true
            capabilities["canManageUsers"] := true
            capabilities["canConfigureSystem"] := true

        default:
            OutputDebug("  Unknown role - no permissions`n")
            return capabilities
    }

    OutputDebug("Capabilities:`n")
    for capability, hasAccess in capabilities {
        if (hasAccess) {
            OutputDebug("  ✓ " capability "`n")
        }
    }

    return capabilities
}

; ============================================================================
; Example 5: Range Categorization
; ============================================================================

/**
 * Demonstrates categorizing values into ranges.
 * Shows bucketing and classification patterns.
 */
Example5_RangeCategorization() {
    OutputDebug("=== Example 5: Range Categorization ===`n")

    CategorizeScore(45)
    CategorizeScore(75)
    CategorizeScore(92)
    CategorizeScore(105)

    OutputDebug("`n")
}

/**
 * Categorizes a score into a grade bracket.
 */
CategorizeScore(score) {
    ; First normalize score to a category
    if (score >= 90) {
        category := "A"
    } else if (score >= 80) {
        category := "B"
    } else if (score >= 70) {
        category := "C"
    } else if (score >= 60) {
        category := "D"
    } else {
        category := "F"
    }

    OutputDebug("Score: " score " -> Grade: " category "`n")

    ; Then use switch for category-specific logic
    switch category {
        case "A":
            message := "Excellent work!"
            scholarshipEligible := true
            honorRoll := true

        case "B":
            message := "Good job!"
            scholarshipEligible := true
            honorRoll := false

        case "C":
            message := "Satisfactory"
            scholarshipEligible := false
            honorRoll := false

        case "D":
            message := "Needs improvement"
            scholarshipEligible := false
            honorRoll := false

        case "F":
            message := "Failed - requires retake"
            scholarshipEligible := false
            honorRoll := false

        default:
            message := "Invalid grade"
            scholarshipEligible := false
            honorRoll := false
    }

    OutputDebug("  Message: " message "`n")
    OutputDebug("  Scholarship: " (scholarshipEligible ? "Yes" : "No") "`n")
    OutputDebug("  Honor Roll: " (honorRoll ? "Yes" : "No") "`n`n")
}

; ============================================================================
; Example 6: State Transitions
; ============================================================================

/**
 * Demonstrates state machine transitions.
 * Shows how to handle state-based logic without fall-through.
 */
Example6_StateTransitions() {
    OutputDebug("=== Example 6: State Transitions ===`n")

    ; Simulate state transitions
    currentState := "idle"
    OutputDebug("Initial state: " currentState "`n`n")

    currentState := TransitionState(currentState, "start")
    currentState := TransitionState(currentState, "pause")
    currentState := TransitionState(currentState, "resume")
    currentState := TransitionState(currentState, "complete")

    OutputDebug("`n")
}

/**
 * Handles state transitions based on current state and action.
 */
TransitionState(currentState, action) {
    OutputDebug("State: " currentState " + Action: " action "`n")

    newState := currentState
    validTransition := false

    switch currentState {
        case "idle":
            switch action {
                case "start":
                    newState := "running"
                    validTransition := true
                    OutputDebug("  Transitioning to RUNNING`n")
                default:
                    OutputDebug("  ERROR: Can only 'start' from idle`n")
            }

        case "running":
            switch action {
                case "pause":
                    newState := "paused"
                    validTransition := true
                    OutputDebug("  Transitioning to PAUSED`n")
                case "complete":
                    newState := "completed"
                    validTransition := true
                    OutputDebug("  Transitioning to COMPLETED`n")
                case "cancel":
                    newState := "idle"
                    validTransition := true
                    OutputDebug("  Transitioning to IDLE`n")
                default:
                    OutputDebug("  ERROR: Invalid action for running state`n")
            }

        case "paused":
            switch action {
                case "resume":
                    newState := "running"
                    validTransition := true
                    OutputDebug("  Transitioning to RUNNING`n")
                case "cancel":
                    newState := "idle"
                    validTransition := true
                    OutputDebug("  Transitioning to IDLE`n")
                default:
                    OutputDebug("  ERROR: Invalid action for paused state`n")
            }

        case "completed":
            switch action {
                case "reset":
                    newState := "idle"
                    validTransition := true
                    OutputDebug("  Transitioning to IDLE`n")
                default:
                    OutputDebug("  ERROR: Can only 'reset' from completed`n")
            }

        default:
            OutputDebug("  ERROR: Unknown state`n")
    }

    OutputDebug("  Result: " currentState " -> " newState "`n`n")
    return newState
}

; ============================================================================
; Example 7: Feature Flags and Capabilities
; ============================================================================

/**
 * Demonstrates managing feature flags and application capabilities.
 * Shows progressive enhancement patterns.
 */
Example7_FeatureFlags() {
    OutputDebug("=== Example 7: Feature Flags ===`n")

    DetermineFeatures("free")
    OutputDebug("`n")
    DetermineFeatures("pro")
    OutputDebug("`n")
    DetermineFeatures("enterprise")

    OutputDebug("`n")
}

/**
 * Determines available features based on subscription tier.
 */
DetermineFeatures(tier) {
    features := Map()
    OutputDebug("Subscription: " tier "`n")

    ; Initialize all features as disabled
    features["basicAccess"] := false
    features["cloudSync"] := false
    features["advancedAnalytics"] := false
    features["prioritySupport"] := false
    features["apiAccess"] := false
    features["customBranding"] := false
    features["sso"] := false
    features["auditLogs"] := false

    ; Enable features based on tier
    switch tier {
        case "free":
            features["basicAccess"] := true
            maxProjects := 1
            storageGB := 1
            support := "Community"

        case "starter":
            features["basicAccess"] := true
            features["cloudSync"] := true
            maxProjects := 5
            storageGB := 10
            support := "Email"

        case "pro":
            features["basicAccess"] := true
            features["cloudSync"] := true
            features["advancedAnalytics"] := true
            features["prioritySupport"] := true
            features["apiAccess"] := true
            maxProjects := 25
            storageGB := 100
            support := "Priority"

        case "enterprise":
            ; Enterprise gets all features
            features["basicAccess"] := true
            features["cloudSync"] := true
            features["advancedAnalytics"] := true
            features["prioritySupport"] := true
            features["apiAccess"] := true
            features["customBranding"] := true
            features["sso"] := true
            features["auditLogs"] := true
            maxProjects := "Unlimited"
            storageGB := "Unlimited"
            support := "24/7 Dedicated"

        default:
            OutputDebug("  Unknown tier`n")
            return features
    }

    ; Display enabled features
    OutputDebug("Enabled features:`n")
    for feature, enabled in features {
        if (enabled) {
            OutputDebug("  ✓ " feature "`n")
        }
    }

    OutputDebug("Limits:`n")
    OutputDebug("  Projects: " maxProjects "`n")
    OutputDebug("  Storage: " storageGB "GB`n")
    OutputDebug("  Support: " support "`n")

    return features
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" Format("{:=<70}", "") "`n")
    OutputDebug("AutoHotkey v2 - Switch Fall-Through Behavior`n")
    OutputDebug(Format("{:=<70}", "") "`n`n")

    Example1_NoFallThrough()
    Example2_SimulatingFallThrough()
    Example3_MultipleCasesSharedCode()
    Example4_CumulativePermissions()
    Example5_RangeCategorization()
    Example6_StateTransitions()
    Example7_FeatureFlags()

    OutputDebug(Format("{:=<70}", "") "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(Format("{:=<70}", "") "`n")
}

Main()
