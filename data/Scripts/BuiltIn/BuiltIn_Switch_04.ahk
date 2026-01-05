#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Control Flow - Switch Pattern Matching
 * ============================================================================
 * 
 * This script demonstrates pattern matching concepts with switch statements.
 * Shows advanced switch usage including type checking, validation patterns,
 * and structured data matching.
 * 
 * @file BuiltIn_Switch_04.ahk
 * @author AHK v2 Examples Collection
 * @version 2.0.0
 * @date 2024-01-15
 * 
 * @description
 * Examples included:
 * 1. Type-based switching
 * 2. Pattern validation
 * 3. Data structure matching
 * 4. Protocol handling
 * 5. Event type routing
 * 6. Command pattern implementation
 * 7. Complex matching scenarios
 * 
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Type-Based Switching
; ============================================================================

/**
 * Demonstrates switching based on data types.
 * Shows type detection and appropriate handling.
 */
Example1_TypeBasedSwitching() {
    OutputDebug("=== Example 1: Type-Based Switching ===`n")

    ProcessValue(42)
    ProcessValue("Hello World")
    ProcessValue([1, 2, 3])
    ProcessValue(Map("key", "value"))
    ProcessValue(3.14159)

    OutputDebug("`n")
}

/**
 * Processes values based on their type.
 */
ProcessValue(value) {
    valueType := Type(value)
    OutputDebug("Processing value: " ToString(value) "`n")
    OutputDebug("  Type: " valueType "`n")

    switch valueType {
        case "Integer":
            OutputDebug("  Handler: Integer processor`n")
            result := value * 2
            OutputDebug("  Result: " value " * 2 = " result "`n")

        case "String":
            OutputDebug("  Handler: String processor`n")
            result := StrLen(value)
            OutputDebug("  Length: " result " characters`n")

        case "Float":
            OutputDebug("  Handler: Float processor`n")
            result := Round(value, 2)
            OutputDebug("  Rounded: " result "`n")

        case "Array":
            OutputDebug("  Handler: Array processor`n")
            OutputDebug("  Length: " value.Length " elements`n")

        case "Map":
            OutputDebug("  Handler: Map processor`n")
            OutputDebug("  Count: " value.Count " entries`n")

        default:
            OutputDebug("  Handler: Unknown type`n")
    }

    OutputDebug("`n")
}

/**
 * Helper function to convert values to string for display.
 */
ToString(value) {
    valueType := Type(value)
    switch valueType {
        case "String":
            return "`"" value "`""
        case "Array":
            return "[Array]"
        case "Map":
            return "{Map}"
        default:
            return String(value)
    }
}

; ============================================================================
; Example 2: Pattern Validation
; ============================================================================

/**
 * Demonstrates input pattern validation.
 * Shows format checking and sanitization.
 */
Example2_PatternValidation() {
    OutputDebug("=== Example 2: Pattern Validation ===`n")

    ValidateInput("email", "user@example.com")
    ValidateInput("email", "invalid-email")
    ValidateInput("phone", "555-1234")
    ValidateInput("zipcode", "12345")
    ValidateInput("url", "https://example.com")

    OutputDebug("`n")
}

/**
 * Validates input based on expected pattern.
 */
ValidateInput(inputType, value) {
    OutputDebug("Validating " inputType ": " value "`n")

    isValid := false
    errorMsg := ""

    switch inputType {
        case "email":
            if (InStr(value, "@") and InStr(value, ".")) {
                if (RegExMatch(value, "^[\w\.\-]+@[\w\.\-]+\.\w+$")) {
                    isValid := true
                } else {
                    errorMsg := "Invalid email format"
                }
            } else {
                errorMsg := "Email must contain @ and domain"
            }

        case "phone":
            if (RegExMatch(value, "^\d{3}-\d{4}$")) {
                isValid := true
            } else {
                errorMsg := "Phone must be format: XXX-XXXX"
            }

        case "zipcode":
            if (RegExMatch(value, "^\d{5}$")) {
                isValid := true
            } else {
                errorMsg := "Zipcode must be 5 digits"
            }

        case "url":
            if (RegExMatch(value, "^https?://")) {
                isValid := true
            } else {
                errorMsg := "URL must start with http:// or https://"
            }

        case "username":
            if (StrLen(value) >= 3 and RegExMatch(value, "^[a-zA-Z0-9_]+$")) {
                isValid := true
            } else {
                errorMsg := "Username must be 3+ alphanumeric characters"
            }

        default:
            errorMsg := "Unknown validation type"
    }

    if (isValid) {
        OutputDebug("  ✓ Valid`n")
    } else {
        OutputDebug("  ✗ Invalid: " errorMsg "`n")
    }

    OutputDebug("`n")
    return isValid
}

; ============================================================================
; Example 3: Data Structure Matching
; ============================================================================

/**
 * Demonstrates matching against structured data.
 * Shows parsing and routing based on structure.
 */
Example3_DataStructureMatching() {
    OutputDebug("=== Example 3: Data Structure Matching ===`n")

    ProcessMessage(Map("type", "user", "action", "login", "username", "john"))
    ProcessMessage(Map("type", "system", "level", "error", "message", "Failed"))
    ProcessMessage(Map("type", "data", "operation", "insert", "table", "users"))

    OutputDebug("`n")
}

/**
 * Processes different message structures.
 */
ProcessMessage(message) {
    if (!message.Has("type")) {
        OutputDebug("Invalid message: missing type`n`n")
        return
    }

    msgType := message["type"]
    OutputDebug("Message type: " msgType "`n")

    switch msgType {
        case "user":
            if (message.Has("action")) {
                action := message["action"]
                switch action {
                    case "login":
                        username := message.Get("username", "unknown")
                        OutputDebug("  User login: " username "`n")
                    case "logout":
                        username := message.Get("username", "unknown")
                        OutputDebug("  User logout: " username "`n")
                    default:
                        OutputDebug("  Unknown user action: " action "`n")
                }
            }

        case "system":
            if (message.Has("level")) {
                level := message["level"]
                msg := message.Get("message", "")
                OutputDebug("  System " level ": " msg "`n")
            }

        case "data":
            if (message.Has("operation")) {
                operation := message["operation"]
                table := message.Get("table", "unknown")
                OutputDebug("  Database " operation " on table: " table "`n")
            }

        default:
            OutputDebug("  Unknown message type`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Protocol Handling
; ============================================================================

/**
 * Demonstrates protocol/format detection and routing.
 * Shows multi-protocol handling patterns.
 */
Example4_ProtocolHandling() {
    OutputDebug("=== Example 4: Protocol Handling ===`n")

    ParseURL("https://example.com/page")
    ParseURL("ftp://files.example.com/file.txt")
    ParseURL("file:///C:/Users/Document.txt")
    ParseURL("mailto:user@example.com")

    OutputDebug("`n")
}

/**
 * Parses and routes based on URL protocol.
 */
ParseURL(url) {
    OutputDebug("URL: " url "`n")

    ; Extract protocol
    protocolEnd := InStr(url, "://")
    if (protocolEnd) {
        protocol := SubStr(url, 1, protocolEnd - 1)
        path := SubStr(url, protocolEnd + 3)
    } else if (InStr(url, "mailto:")) {
        protocol := "mailto"
        path := SubStr(url, 8)
    } else {
        protocol := "unknown"
        path := url
    }

    OutputDebug("  Protocol: " protocol "`n")

    switch protocol {
        case "http", "https":
            OutputDebug("  Handler: HTTP client`n")
            OutputDebug("  Secure: " (protocol = "https" ? "Yes" : "No") "`n")
            OutputDebug("  Resource: " path "`n")

        case "ftp", "ftps":
            OutputDebug("  Handler: FTP client`n")
            OutputDebug("  Secure: " (protocol = "ftps" ? "Yes" : "No") "`n")
            OutputDebug("  File: " path "`n")

        case "file":
            OutputDebug("  Handler: Local file system`n")
            OutputDebug("  Path: " path "`n")

        case "mailto":
            OutputDebug("  Handler: Email client`n")
            OutputDebug("  Recipient: " path "`n")

        case "tel":
            OutputDebug("  Handler: Phone dialer`n")
            OutputDebug("  Number: " path "`n")

        default:
            OutputDebug("  Handler: Unknown protocol`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Event Type Routing
; ============================================================================

/**
 * Demonstrates event routing based on event type.
 * Shows event-driven programming patterns.
 */
Example5_EventTypeRouting() {
    OutputDebug("=== Example 5: Event Type Routing ===`n")

    HandleEvent("click", Map("x", 100, "y", 200, "button", "left"))
    HandleEvent("keypress", Map("key", "Enter", "ctrl", true))
    HandleEvent("resize", Map("width", 1920, "height", 1080))

    OutputDebug("`n")
}

/**
 * Routes events to appropriate handlers.
 */
HandleEvent(eventType, eventData) {
    OutputDebug("Event: " eventType "`n")

    switch eventType {
        case "click", "doubleclick":
            x := eventData.Get("x", 0)
            y := eventData.Get("y", 0)
            button := eventData.Get("button", "left")
            OutputDebug("  Mouse " eventType " at (" x ", " y ") with " button " button`n")

        case "keypress", "keydown", "keyup":
            key := eventData.Get("key", "")
            ctrl := eventData.Get("ctrl", false)
            shift := eventData.Get("shift", false)
            alt := eventData.Get("alt", false)
            modifiers := ""
            if (ctrl) modifiers .= "Ctrl+"
                if (shift) modifiers .= "Shift+"
                    if (alt) modifiers .= "Alt+"
                        OutputDebug("  Keyboard: " modifiers key "`n")

        case "scroll":
            delta := eventData.Get("delta", 0)
            direction := (delta > 0) ? "up" : "down"
            OutputDebug("  Scroll " direction " by " Abs(delta) "`n")

        case "resize", "move":
            width := eventData.Get("width", 0)
            height := eventData.Get("height", 0)
            OutputDebug("  Window " eventType ": " width "x" height "`n")

        default:
            OutputDebug("  Unhandled event type`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Command Pattern Implementation
; ============================================================================

/**
 * Demonstrates command pattern with switch.
 * Shows action dispatch and undo/redo support.
 */
Example6_CommandPattern() {
    OutputDebug("=== Example 6: Command Pattern ===`n")

    ExecuteCommand("add", Map("value", 5))
    ExecuteCommand("subtract", Map("value", 3))
    ExecuteCommand("multiply", Map("value", 2))
    ExecuteCommand("reset", Map())

    OutputDebug("`n")
}

/**
 * Executes commands on a calculator.
 */
ExecuteCommand(command, params) {
    static accumulator := 0

    OutputDebug("Command: " command "`n")
    OutputDebug("  Before: " accumulator "`n")

    switch command {
        case "add":
            value := params.Get("value", 0)
            accumulator += value
            OutputDebug("  Action: Added " value "`n")

        case "subtract":
            value := params.Get("value", 0)
            accumulator -= value
            OutputDebug("  Action: Subtracted " value "`n")

        case "multiply":
            value := params.Get("value", 1)
            accumulator *= value
            OutputDebug("  Action: Multiplied by " value "`n")

        case "divide":
            value := params.Get("value", 1)
            if (value != 0) {
                accumulator /= value
                OutputDebug("  Action: Divided by " value "`n")
            } else {
                OutputDebug("  Error: Division by zero`n")
            }

        case "reset":
            accumulator := 0
            OutputDebug("  Action: Reset`n")

        case "get":
            OutputDebug("  Action: Query (no change)`n")

        default:
            OutputDebug("  Error: Unknown command`n")
    }

    OutputDebug("  After: " accumulator "`n`n")
    return accumulator
}

; ============================================================================
; Example 7: Complex Matching Scenarios
; ============================================================================

/**
 * Demonstrates complex real-world matching scenarios.
 * Shows combining multiple factors for routing.
 */
Example7_ComplexMatching() {
    OutputDebug("=== Example 7: Complex Matching ===`n")

    ProcessRequest("GET", "/api/users/123", Map("auth", true, "role", "admin"))
    ProcessRequest("POST", "/api/users", Map("auth", true, "role", "user"))
    ProcessRequest("DELETE", "/api/users/456", Map("auth", false, "role", "guest"))

    OutputDebug("`n")
}

/**
 * Processes HTTP-style requests with complex routing.
 */
ProcessRequest(method, path, context) {
    OutputDebug("Request: " method " " path "`n")

    isAuth := context.Get("auth", false)
    role := context.Get("role", "guest")

    ; First check authorization
    if (!isAuth and method != "GET") {
        OutputDebug("  ERROR: Authentication required`n`n")
        return
    }

    ; Extract resource type from path
    if (InStr(path, "/api/users")) {
        resource := "users"
    } else if (InStr(path, "/api/posts")) {
        resource := "posts"
    } else if (InStr(path, "/api/comments")) {
        resource := "comments"
    } else {
        resource := "unknown"
    }

    ; Route based on method and resource
    switch method {
        case "GET":
            OutputDebug("  Action: Read " resource "`n")
            OutputDebug("  Allowed: Yes (public read)`n")

        case "POST":
            switch resource {
                case "users":
                    if (role = "admin") {
                        OutputDebug("  Action: Create user`n")
                        OutputDebug("  Allowed: Yes (admin)`n")
                    } else {
                        OutputDebug("  Action: Create user`n")
                        OutputDebug("  Denied: Admin only`n")
                    }

                case "posts", "comments":
                    if (role = "user" or role = "admin") {
                        OutputDebug("  Action: Create " resource "`n")
                        OutputDebug("  Allowed: Yes (authenticated user)`n")
                    } else {
                        OutputDebug("  Denied: User role required`n")
                    }
            }

        case "PUT", "PATCH":
            if (role = "admin" or role = "user") {
                OutputDebug("  Action: Update " resource "`n")
                OutputDebug("  Allowed: Yes`n")
            } else {
                OutputDebug("  Denied: Insufficient permissions`n")
            }

        case "DELETE":
            if (role = "admin") {
                OutputDebug("  Action: Delete " resource "`n")
                OutputDebug("  Allowed: Yes (admin)`n")
            } else {
                OutputDebug("  Action: Delete " resource "`n")
                OutputDebug("  Denied: Admin only`n")
            }

        default:
            OutputDebug("  ERROR: Unsupported method`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" Format("{:=<70}", "") "`n")
    OutputDebug("AutoHotkey v2 - Switch Pattern Matching Examples`n")
    OutputDebug(Format("{:=<70}", "") "`n`n")

    Example1_TypeBasedSwitching()
    Example2_PatternValidation()
    Example3_DataStructureMatching()
    Example4_ProtocolHandling()
    Example5_EventTypeRouting()
    Example6_CommandPattern()
    Example7_ComplexMatching()

    OutputDebug(Format("{:=<70}", "") "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(Format("{:=<70}", "") "`n")
}

Main()
