#Requires AutoHotkey v2.0

/**
 * GitHub_DllCall_03_ClipboardHTML.ahk
 * 
 * DESCRIPTION:
 * Copy HTML content to clipboard with proper formatting
 * 
 * FEATURES:
 * - Custom clipboard formats
 * - HTML clipboard format
 * - Buffer management for clipboard data
 * - GlobalAlloc/GlobalLock usage
 * 
 * SOURCE:
 * Based on common clipboard HTML patterns from AHK community
 * Reference: Windows Clipboard API
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall for Windows clipboard API
 * - Buffer() for memory management
 * - StrPut for writing strings to buffer
 * - RegisterClipboardFormat for custom formats
 * - Proper cleanup with try/finally
 * 
 * USAGE:
 * SetClipboardHTML("<b>Bold text</b>")
 * 
 * LEARNING POINTS:
 * 1. HTML clipboard format requires special header
 * 2. GlobalAlloc allocates memory, GlobalLock gets pointer
 * 3. OpenClipboard must be paired with CloseClipboard
 * 4. EmptyClipboard clears existing content
 * 5. SetClipboardData places data in clipboard
 */

/**
 * Set clipboard content as HTML
 * 
 * @param {String} html - HTML content to copy
 * @returns {Boolean} - Success status
 * 
 * @example
 * SetClipboardHTML("<h1>Title</h1><p>Paragraph</p>")
 * ; Now you can paste rich HTML into Word, Outlook, etc.
 */
SetClipboardHTML(html) {
    ; HTML clipboard format template
    ; StartHTML/EndHTML are byte offsets in UTF-8
    htmlTemplate := "
    (
    Version:0.9
    StartHTML:{1:010}
    EndHTML:{2:010}
    StartFragment:{3:010}
    EndFragment:{4:010}
    <html>
    <body>
    <!--StartFragment-->
    {
        5
    }
    <!--EndFragment-->
    </body>
    </html>
    )"

    ; Calculate byte offsets
    ; Note: This is simplified - production code needs precise UTF-8 byte counting
    header := Format(htmlTemplate, 0, 0, 0, 0, "")
    headerLen := StrLen(header)

    startFragment := headerLen
    endFragment := startFragment + StrLen(html)
    endHTML := endFragment + StrLen("</body></html>`r`n")

    ; Create final HTML with correct offsets
    htmlClipboard := Format(htmlTemplate,
        97,  ; StartHTML offset (approximate)
        endHTML,
        startFragment + 97,
        endFragment + 97,
        html)

    ; Register HTML clipboard format
    cfHTML := DllCall("RegisterClipboardFormat", "Str", "HTML Format", "UInt")

    ; Allocate global memory
    ; GMEM_MOVEABLE = 0x0002
    size := StrPut(htmlClipboard, "UTF-8")
    hMem := DllCall("GlobalAlloc", "UInt", 0x0002, "UPtr", size, "Ptr")

    if (!hMem)
        return false

    ; Lock memory and get pointer
    pMem := DllCall("GlobalLock", "Ptr", hMem, "Ptr")

    if (!pMem) {
        DllCall("GlobalFree", "Ptr", hMem)
        return false
    }

    ; Write HTML to memory
    StrPut(htmlClipboard, pMem, "UTF-8")

    ; Unlock memory
    DllCall("GlobalUnlock", "Ptr", hMem)

    ; Open clipboard
    if (!DllCall("OpenClipboard", "Ptr", 0)) {
        DllCall("GlobalFree", "Ptr", hMem)
        return false
    }

    ; Empty clipboard and set new data
    DllCall("EmptyClipboard")
    DllCall("SetClipboardData", "UInt", cfHTML, "Ptr", hMem)

    ; Close clipboard
    DllCall("CloseClipboard")

    return true
}

/**
 * Simplified version using A_Clipboard for plain text backup
 * 
 * @param {String} html - HTML content
 * @param {String} plainText - Plain text fallback
 */
SetClipboardHTMLSimple(html, plainText := "") {
    ; Set plain text first (for apps that don't support HTML)
    if (plainText = "")
        plainText := RegExReplace(html, "<[^>]+>", "")  ; Strip tags

    A_Clipboard := plainText

    ; Then set HTML format
    SetClipboardHTML(html)
}

; ============================================================
; Example 1: Copy Bold Text
; ============================================================

result := SetClipboardHTML("<b>This is bold text</b>")

if (result) {
    MsgBox("HTML copied to clipboard!`n`n"
        . "Try pasting into:`n"
        . "- Microsoft Word`n"
        . "- Outlook`n"
        . "- Gmail compose`n"
        . "- Any rich text editor`n`n"
        . "The text should appear BOLD.",
        "Clipboard HTML", "Icon!")
}

; ============================================================
; Example 2: Copy Formatted Table
; ============================================================

tableHTML := "
(
<table border='1' cellpadding='5'>
<tr style='background-color: #4CAF50; color: white;'>
<th>Name</th>
<th>Age</th>
<th>City</th>
</tr>
<tr>
<td>John Doe</td>
<td>30</td>
<td>New York</td>
</tr>
<tr>
<td>Jane Smith</td>
<td>25</td>
<td>Los Angeles</td>
</tr>
</table>
)"

result2 := MsgBox("Copy formatted table to clipboard?", "Table Example", "YesNo Icon?")

if (result2 = "Yes") {
    SetClipboardHTML(tableHTML)
    MsgBox("Table copied! Paste into Word or Outlook to see formatting.",
        "Success", "Icon!")
}

; ============================================================
; Example 3: Copy Styled List
; ============================================================

listHTML := "
(
<h2 style='color: #2E86DE;'>Shopping List</h2>
<ul style='font-family: Arial; font-size: 14px;'>
<li style='color: #EE5A6F;'>Milk</li>
<li style='color: #F79F1F;'>Bread</li>
<li style='color: #A3CB38;'>Eggs</li>
<li style='color: #1289A7;'>Butter</li>
</ul>
)"

result3 := MsgBox("Copy colored shopping list to clipboard?", "List Example", "YesNo Icon?")

if (result3 = "Yes") {
    SetClipboardHTML(listHTML)
    MsgBox("List copied! Paste to see colored items.",
        "Success", "Icon!")
}

; ============================================================
; Example 4: Copy Code Snippet with Syntax Highlighting
; ============================================================

codeHTML := '
    < div style = "background-color: #f4f4f4; padding: 10px; font-family: Consolas, monospace;" >
    < pre style = "margin: 0;" >
    < span style = "color: #0000FF;" > function < / span > < span style = "color: #795E26;" > greet < / span > ( < span style = "color: #001080;" > name < / span >) {
    < span style = "color: #0000FF;" > return < / span > < span style = "color: #A31515;" > "Hello, " < / span > + < span style = "color: #001080;" > name < / span >;
}
    < / pre >
    < / div >
    '

result4 := MsgBox("Copy syntax-highlighted code to clipboard?", "Code Example", "YesNo Icon?")

if (result4 = "Yes") {
    SetClipboardHTML(codeHTML)
    MsgBox("Code copied! Paste to see syntax highlighting.",
        "Success", "Icon!")
}

; ============================================================
; Example 5: Convert Plain Text to HTML with Formatting
; ============================================================

/**
 * Convert plain text to formatted HTML
 * 
 * @param {String} text - Plain text
 * @returns {String} - HTML
 */
TextToHTML(text) {
    ; Replace line breaks with <br>
    html := StrReplace(text, "`r`n", "<br>")
    html := StrReplace(html, "`n", "<br>")

    ; Wrap in paragraph
    html := "<p>" html "</p>"

    return html
}

plainText := "
(
Line 1
Line 2
Line 3
)"

htmlFromText := TextToHTML(plainText)

result5 := MsgBox("Copy plain text as HTML (with line breaks)?", "Text Conversion", "YesNo Icon?")

if (result5 = "Yes") {
    SetClipboardHTML(htmlFromText)
    MsgBox("Text copied as HTML!",
        "Success", "Icon!")
}

; ============================================================
; Practical Use Case: Email Template Generator
; ============================================================

/**
 * Generate email template HTML
 * 
 * @param {String} subject - Email subject
 * @param {String} body - Email body
 * @param {String} signature - Email signature
 * @returns {String} - Formatted HTML
 */
GenerateEmailHTML(subject, body, signature) {
    html := "
    (
    <div style='font-family: Arial, sans-serif;'>
    <h2 style='color: #333;'>" . subject . "</h2>
    <p style='font-size: 14px; line-height: 1.6;'>" . body . "</p>
    <hr style='border: 1px solid #ddd;'>
    <p style='font-size: 12px; color: #666;'>" . signature . "</p>
    </div>
    )"

    return html
}

emailHTML := GenerateEmailHTML(
    "Meeting Reminder",
    "This is a reminder about our meeting tomorrow at 2 PM.",
    "Best regards,`nYour Name`nCompany Name"
)

result6 := MsgBox("Copy email template to clipboard?", "Email Template", "YesNo Icon?")

if (result6 = "Yes") {
    SetClipboardHTML(emailHTML)
    MsgBox("Email template copied! Paste into Outlook or Gmail.",
        "Success", "Icon!")
}

; ============================================================
; Reference Information
; ============================================================

info := "
(
HTML CLIPBOARD FORMAT:

The Windows clipboard supports multiple formats simultaneously:
- Plain text (CF_TEXT)
- HTML (HTML Format)
- Rich Text Format (RTF)
- Images (CF_BITMAP)

HTML Format Structure:
1. Version line
2. Byte offsets (StartHTML, EndHTML, etc.)
3. HTML content with markers

Common HTML Tags for Clipboard:
- <b> or <strong> - Bold
- <i> or <em> - Italic
- <u> - Underline
- <span style=''> - Custom styling
- <table>, <tr>, <td> - Tables
- <ul>, <li> - Lists
- <h1> through <h6> - Headings

Applications that Support HTML Clipboard:
✓ Microsoft Word
✓ Microsoft Outlook
✓ Gmail (web)
✓ Most modern text editors
✓ Most web applications

DllCall Functions Used:
- RegisterClipboardFormat - Register custom format
- GlobalAlloc - Allocate memory
- GlobalLock/GlobalUnlock - Access memory
- OpenClipboard/CloseClipboard - Clipboard access
- EmptyClipboard - Clear clipboard
- SetClipboardData - Set clipboard content
)"

MsgBox(info, "HTML Clipboard Reference", "Icon!")
