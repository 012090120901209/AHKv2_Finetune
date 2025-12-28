#Requires AutoHotkey v2.0
#Include JSON.ahk

/**
 * ============================================================================
 * AutoHotkey v2 SendText Function - Literal Text
 * ============================================================================
 * 
 * SendText sends keystrokes literally without interpreting special characters
 * or modifiers. Perfect for sending text that contains special characters,
 * code snippets, passwords, or any content that should be sent verbatim.
 * 
 * Syntax: SendText(Keys)
 * 
 * @module BuiltIn_SendText_01
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Basic Literal Text
; ============================================================================

/**
 * Sends text without special character interpretation.
 * All characters sent exactly as written.
 * 
 * @example
 * ; Press F1 to send literal text
 */
F1:: {
    ToolTip("Sending literal text in 2 seconds...")
    Sleep(2000)
    ToolTip()

    SendText("This is plain text sent literally!")

    ToolTip("Literal text sent!")
    Sleep(1000)
    ToolTip()
}

/**
 * Sends text with special characters
 * Characters like ^+!# sent as-is
 */
F2:: {
    ToolTip("Sending text with special chars in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; These would be modifiers in Send(), but are literal in SendText()
    SendText("Special chars: ^+!#{}[]")

    ToolTip("Special characters sent!")
    Sleep(1000)
    ToolTip()
}

/**
 * Sends braces and curly brackets
 * No need to escape {} characters
 */
F3:: {
    ToolTip("Sending braces in 2 seconds...")
    Sleep(2000)
    ToolTip()

    SendText("Curly braces: { } and { } are sent literally!")
    SendText(" ")
    SendText("Square brackets: [ ] [ ] also literal!")

    ToolTip("Braces sent!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 2: Code Snippet Sending
; ============================================================================

/**
 * Sends programming code literally.
 * Perfect for code snippets with special characters.
 * 
 * @description
 * Demonstrates code template insertion
 */
^F1:: {
    ToolTip("Sending code snippet in 2 seconds...")
    Sleep(2000)
    ToolTip()

    javaScriptCode := '
    (
    function example(param) {
        if (param !== null) {
            console.log("Value: " + param);
            return true;
        }
        return false;
    }
    )'

    SendText(StrReplace(javaScriptCode, "`n    ", "`n"))

    ToolTip("Code snippet sent!")
    Sleep(1500)
    ToolTip()
}

/**
 * Sends HTML code
 * Preserves all HTML special characters
 */
^F2:: {
    ToolTip("Sending HTML code in 2 seconds...")
    Sleep(2000)
    ToolTip()

    htmlCode := '
    (
    <div class="container">
    <h1>Title & Header</h1>
    <p>Paragraph with <strong>bold</strong> text.</p>
    <a href="https://example.com?param1=value&param2=value">Link</a>
    </div>
    )'

    SendText(StrReplace(htmlCode, "`n    ", "`n"))

    ToolTip("HTML code sent!")
    Sleep(1500)
    ToolTip()
}

/**
 * Sends CSS code
 * Maintains all CSS syntax
 */
^F3:: {
    ToolTip("Sending CSS code in 2 seconds...")
    Sleep(2000)
    ToolTip()

    cssCode := '
    (
    .container {
        width: 100%;
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }

    h1 + p {
        margin-top: 0;
    }
    )'

    SendText(StrReplace(cssCode, "`n    ", "`n"))

    ToolTip("CSS code sent!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Example 3: Special Characters and Symbols
; ============================================================================

/**
 * Sends mathematical expressions.
 * All operators sent literally.
 * 
 * @description
 * Demonstrates math formula insertion
 */
^F4:: {
    ToolTip("Sending math expressions in 2 seconds...")
    Sleep(2000)
    ToolTip()

    mathExpressions := [
        "x = (-b ± √(b²-4ac)) / 2a",
        "E = mc²",
        "∫(x² + 2x + 1)dx = x³/3 + x² + x + C",
        "a² + b² = c²"
    ]

    for index, expr in mathExpressions {
        SendText(expr)
        SendText("`n")
        Sleep(300)
    }

    ToolTip("Math expressions sent!")
    Sleep(1500)
    ToolTip()
}

/**
 * Sends currency and financial data
 * Preserves all currency symbols
 */
^F5:: {
    ToolTip("Sending financial data in 2 seconds...")
    Sleep(2000)
    ToolTip()

    financialData := [
        "Price: $1,234.56",
        "Tax: $123.45 (10%)",
        "Total: $1,358.01",
        "Euro: €1,050.00",
        "Pounds: £890.25",
        "Yen: ¥125,000"
    ]

    for index, data in financialData {
        SendText(data)
        SendText("`n")
        Sleep(200)
    }

    ToolTip("Financial data sent!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Example 4: URLs and Email Addresses
; ============================================================================

/**
 * Sends URLs literally.
 * Preserves all URL special characters.
 * 
 * @description
 * URL insertion without corruption
 */
^F6:: {
    ToolTip("Sending URLs in 2 seconds...")
    Sleep(2000)
    ToolTip()

    urls := [
        "https://example.com/path?param1=value&param2=value#section",
        "https://api.example.com/v2/users/{id}/posts?sort=desc&limit=10",
        "mailto:user@example.com?subject=Hello&body=Test%20Message",
        "ftp://files.example.com:21/downloads/file.zip"
    ]

    for index, url in urls {
        SendText(url)
        SendText("`n")
        Sleep(300)
    }

    ToolTip("URLs sent!")
    Sleep(1500)
    ToolTip()
}

/**
 * Sends email addresses and formats
 * Maintains all email syntax
 */
^F7:: {
    ToolTip("Sending email addresses in 2 seconds...")
    Sleep(2000)
    ToolTip()

    emails := [
        "john.doe+tag@example.com",
        "user_name@sub-domain.example.co.uk",
        "contact@example.com (John Doe)",
        '"Display Name" <email@example.com>'
    ]

    for index, email in emails {
        SendText(email)
        SendText("`n")
        Sleep(200)
    }

    ToolTip("Email addresses sent!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Example 5: Passwords and Credentials
; ============================================================================

/**
 * Sends passwords safely.
 * No character interpretation or hotkey triggering.
 * 
 * @description
 * Secure password entry
 */
^F8:: {
    ToolTip("Entering password in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Example complex password with special characters
    password := "P@ssw0rd!2024#Secure^Complex&Valid+"

    SendText(password)

    ToolTip("Password entered securely!")
    Sleep(1500)
    ToolTip()
}

/**
 * Sends API keys and tokens
 * Maintains exact format
 */
^F9:: {
    ToolTip("Entering API key in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Example API key format (placeholder)
    apiKey := "api_test_EXAMPLE1234567890abcdefghij"

    SendText(apiKey)

    ToolTip("API key entered!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Example 6: Data Formats
; ============================================================================

/**
 * Sends JSON data literally.
 * Preserves all JSON syntax.
 * 
 * @description
 * JSON data insertion
 */
^F10:: {
    ToolTip("Sending JSON in 2 seconds...")
    Sleep(2000)
    ToolTip()

    jsonData := '
    (
    {
        "name": "John Doe",
        "email": "john@example.com",
        "age": 30,
        "active": true,
        "tags": ["user", "admin"],
        "metadata": {
            "created": "2024-01-01",
            "score": 95.5
        }
    }
    )'

    SendText(StrReplace(jsonData, "`n    ", "`n"))

    ToolTip("JSON sent!")
    Sleep(1500)
    ToolTip()
}

/**
 * Sends XML data
 * Maintains XML structure
 */
^F11:: {
    ToolTip("Sending XML in 2 seconds...")
    Sleep(2000)
    ToolTip()

    xmlData := '
    (
    <?xml version="1.0" encoding="UTF-8"?>
    <root>
    <user id="1">
    <name>John Doe</name>
    <email>john@example.com</email>
    </user>
    <user id="2">
    <name>Jane Smith</name>
    <email>jane@example.com</email>
    </user>
    </root>
    )'

    SendText(StrReplace(xmlData, "`n    ", "`n"))

    ToolTip("XML sent!")
    Sleep(1500)
    ToolTip()
}

/**
 * Sends CSV data
 * Preserves comma and quote formatting
 */
^F12:: {
    ToolTip("Sending CSV in 2 seconds...")
    Sleep(2000)
    ToolTip()

    csvData := '
    (
    "ID","Name","Email","Price"
    "001","Product A","contact@example.com","$29.99"
    "002","Product B","sales@example.com","$19.99"
    "003","Product C","info@example.com","$39.99"
    )'

    SendText(StrReplace(csvData, "`n    ", "`n"))

    ToolTip("CSV sent!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Example 7: Multi-line Text Blocks
; ============================================================================

/**
 * Sends large text blocks.
 * Maintains all formatting and characters.
 * 
 * @description
 * Bulk text insertion
 */
!F1:: {
    ToolTip("Sending text block in 2 seconds...")
    Sleep(2000)
    ToolTip()

    textBlock := '
    (
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

    Key points:
    - First point with special chars: ^, +, !, #
    - Second point with brackets: {}, [], ()
    - Third point with symbols: @, $, %, &, *

    For more information: https://example.com?ref=docs&section=help
    Contact: support@example.com
    )'

    SendText(StrReplace(textBlock, "`n    ", "`n"))

    ToolTip("Text block sent!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Sends text from clipboard literally
 */
SendClipboardAsText() {
    if (A_Clipboard != "") {
        SendText(A_Clipboard)
        return true
    }
    return false
}

/**
 * Sends multi-line text with line breaks
 * 
 * @param {Array} lines - Array of text lines
 */
SendTextLines(lines) {
    for index, line in lines {
        SendText(line)
        if (index < lines.Length)
            SendText("`n")
    }
}

/**
 * Safely sends any text content
 * 
 * @param {String} text - Text to send
 * @returns {Boolean} Success status
 */
SafeSendText(text) {
    try {
        SendText(text)
        return true
    } catch as err {
        MsgBox("SendText failed: " err.Message)
        return false
    }
}

; Test utilities
!F2:: {
    A_Clipboard := "Test text from clipboard: ^+!#{}[]"
    Sleep(100)

    ToolTip("Sending clipboard as text in 2 seconds...")
    Sleep(2000)
    ToolTip()

    result := SendClipboardAsText()

    ToolTip("Clipboard sent: " (result ? "Success" : "Failed"))
    Sleep(1500)
    ToolTip()
}

!F3:: {
    ToolTip("Testing SendTextLines in 2 seconds...")
    Sleep(2000)
    ToolTip()

    lines := [
        "Line 1: Special chars ^+!",
        "Line 2: Braces {}[]",
        "Line 3: Symbols @#$%"
    ]

    SendTextLines(lines)

    ToolTip("SendTextLines complete!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc:: ExitApp()

F12:: {
    helpText := "
    (
    SendText - Literal Text
    =======================

    F1 - Basic literal text
    F2 - Special characters
    F3 - Braces and brackets

    Ctrl+F1  - JavaScript code
    Ctrl+F2  - HTML code
    Ctrl+F3  - CSS code
    Ctrl+F4  - Math expressions
    Ctrl+F5  - Financial data
    Ctrl+F6  - URLs
    Ctrl+F7  - Email addresses
    Ctrl+F8  - Password entry
    Ctrl+F9  - API key entry
    Ctrl+F10 - JSON data
    Ctrl+F11 - XML data
    Ctrl+F12 - CSV data

    Alt+F1 - Text block
    Alt+F2 - Send clipboard
    Alt+F3 - Send text lines

    F12 - Show this help
    ESC - Exit script

    SendText sends ALL characters literally!
    No special character interpretation.
    )"

    MsgBox(helpText, "SendText Examples Help")
}
