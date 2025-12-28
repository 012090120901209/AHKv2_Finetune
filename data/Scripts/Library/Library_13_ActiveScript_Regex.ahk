#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ActiveScript - Advanced Regex with JavaScript
 * 
 * Demonstrates using JavaScript's powerful regular expression engine
 * for complex pattern matching, captures, and replacements.
 * 
 * Library: https://github.com/Lexikos/ActiveScript.ahk
 */

MsgBox("ActiveScript - JavaScript Regex Example`n`n"
    . "Demonstrates advanced regex with JS`n"
    . "Requires: ActiveScript.ahk in Lib folder", , "T3")

/*
; Uncomment to run (requires ActiveScript.ahk):

#Include <ActiveScript>

; Create JScript engine
script := ActiveScript("JScript")

; Example 1: Extract all email addresses
MsgBox("Example 1: Email extraction...", , "T2")

text := "Contact us: support@example.com or sales@company.org. For urgent matters: urgent@test.co.uk"

script.Exec("var emailRegex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/g")
script.Exec("var text = '" StrReplace(text, "'", "\'") "'")
script.Exec("var matches = text.match(emailRegex)")

count := script.Eval("matches.length")
result := "Found " count " emails:`n`n"

Loop count {
    email := script.Eval("matches[" (A_Index-1) "]")
    result .= A_Index ". " email "`n"
}

MsgBox(result, , "T5")

; Example 2: URL parsing with capture groups
MsgBox("Example 2: URL parsing with capture groups...", , "T2")

url := "https://www.example.com:8080/path/to/page?param=value&other=123#section"

script.Exec("var urlRegex = /^(https?):\/\/([^:\/]+)(?::(\d+))?(\/[^?#]*)?(?:\?([^#]*))?(?:#(.*))?$/")
script.Exec("var url = '" url "'")
script.Exec("var match = url.match(urlRegex)")

if (script.Eval("match != null")) {
    protocol := script.Eval("match[1]")
    host := script.Eval("match[2]")
    port := script.Eval("match[3] || 'default'")
    path := script.Eval("match[4] || '/'")
    query := script.Eval("match[5] || 'none'")
    hash := script.Eval("match[6] || 'none'")

    MsgBox("URL Components:`n`n"
    . "Protocol: " protocol "`n"
    . "Host: " host "`n"
    . "Port: " port "`n"
    . "Path: " path "`n"
    . "Query: " query "`n"
    . "Hash: " hash, , "T8")
}

; Example 3: Phone number formatting
MsgBox("Example 3: Phone number formatting...", , "T2")

phones := "Call 555-1234 or (555) 5678 or 555.9012"

script.Exec("var phoneRegex = /\(?\d{3}\)?[-.\s]?\d{4}/g")
script.Exec("var phones = '" phones "'")
script.Exec("var formatted = phones.replace(phoneRegex, function(m) { return '***-****'; })")

formatted := script.Eval("formatted")
MsgBox("Phone Number Masking:`n`nOriginal: " phones "`n`nMasked: " formatted, , "T5")

; Example 4: Named groups simulation with JavaScript
MsgBox("Example 4: Date parsing with captures...", , "T2")

dateStr := "Date: 2024-01-15"

script.Exec("var dateRegex = /(\d{4})-(\d{2})-(\d{2})/")
script.Exec("var date = '" dateStr "'")
script.Exec("var match = date.match(dateRegex)")

if (script.Eval("match != null")) {
    year := script.Eval("match[1]")
    month := script.Eval("match[2]")
    day := script.Eval("match[3]")

    MsgBox("Date Parsing:`n`n"
    . "Year: " year "`n"
    . "Month: " month "`n"
    . "Day: " day, , "T3")
}

; Example 5: Advanced replacements with functions
MsgBox("Example 5: Title case conversion...", , "T2")

sentence := "hello world from javascript regex"

script.Exec("
(
var text = '" sentence "';
var titleCase = text.replace(/\b\w/g, function(char) {
    return char.toUpperCase();
});
)")

titleCase := script.Eval("titleCase")
MsgBox("Title Case Conversion:`n`nOriginal: " sentence "`n`nConverted: " titleCase, , "T3")

; Example 6: Password validation
MsgBox("Example 6: Password strength validation...", , "T2")

passwords := ["weak", "Better1", "Strong@Pass1", "Sup3r$ecure!"]

script.Exec("
(
function validatePassword(pwd) {
    var hasLower = /[a-z]/.test(pwd);
    var hasUpper = /[A-Z]/.test(pwd);
    var hasNumber = /\d/.test(pwd);
    var hasSpecial = /[!@#$%^&*(),.?\":{}|<>]/.test(pwd);
    var minLength = pwd.length >= 8;

    var score = 0;
    if (hasLower) score++;
    if (hasUpper) score++;
    if (hasNumber) score++;
    if (hasSpecial) score++;
    if (minLength) score++;

    return {
        score: score,
        strength: score < 3 ? 'Weak' : score < 5 ? 'Medium' : 'Strong'
    };
}
)")

result := "Password Validation:`n`n"

for pwd in passwords {
    script.Exec("var result = validatePassword('" pwd "')")
    strength := script.Eval("result.strength")
    score := script.Eval("result.score")
    result .= pwd ": " strength " (" score "/5)`n"
}

MsgBox(result, , "T5")

; Example 7: Extract data from structured text
MsgBox("Example 7: Log file parsing...", , "T2")

logLine := "[2024-01-15 10:30:45] ERROR: Connection failed (code: 500)"

script.Exec("var logRegex = /\[([^\]]+)\]\s+(\w+):\s+(.+)\s+\(code:\s+(\d+)\)/")
script.Exec("var log = '" StrReplace(logLine, "'", "\'") "'")
script.Exec("var match = log.match(logRegex)")

if (script.Eval("match != null")) {
    timestamp := script.Eval("match[1]")
    level := script.Eval("match[2]")
    message := script.Eval("match[3]")
    code := script.Eval("match[4]")

    MsgBox("Log Entry Parsed:`n`n"
    . "Timestamp: " timestamp "`n"
    . "Level: " level "`n"
    . "Message: " message "`n"
    . "Code: " code, , "T5")
}
*/

/*
* Key Concepts:
*
* 1. JavaScript Regex Syntax:
*    /pattern/flags
*    Flags: g=global, i=ignoreCase, m=multiline
*
* 2. Common Patterns:
*    \d - Digit
*    \w - Word character
*    \s - Whitespace
*    . - Any character
*    * - 0 or more
*    + - 1 or more
*    ? - 0 or 1
*    {n,m} - Between n and m
*
* 3. Capture Groups:
*    (pattern) - Capturing group
*    (?:pattern) - Non-capturing
*    match[1], match[2] - Access captures
*
* 4. Methods:
*    string.match(regex) - Find matches
*    string.replace(regex, str/fn) - Replace
*    regex.test(string) - Boolean test
*    regex.exec(string) - Detailed match
*
* 5. Replace with Function:
*    text.replace(/pattern/, function(match) {
    *        return transformation;
    *    })
    *
    * 6. Lookahead/Lookbehind:
    *    (?=pattern) - Positive lookahead
    *    (?!pattern) - Negative lookahead
    *    (?<=pattern) - Lookbehind (ES2018+)
    *
    * 7. Use Cases:
    *    ✅ Email validation
    *    ✅ URL parsing
    *    ✅ Phone formatting
    *    ✅ Log parsing
    *    ✅ Data extraction
    *    ✅ Text transformation
    *
    * 8. Advantages over AHK Regex:
    *    ✅ Replace with functions
    *    ✅ More consistent syntax
    *    ✅ Better documented
    *    ✅ Widespread examples
    *
    * 9. Best Practices:
    *    ✅ Test regex online first
    *    ✅ Use non-capturing groups
    *    ✅ Escape special characters
    *    ✅ Consider performance
    *    ✅ Document complex patterns
    *
    * 10. Common Patterns:
    *     Email: /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i
    *     URL: /https?:\/\/[^\s]+/g
    *     Phone: /\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}/
    *     Date: /\d{4}-\d{2}-\d{2}/
    *     IP: /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
    *
    * 11. Performance:
    *     ⚠ Greedy quantifiers (.*) can be slow
    *     ✅ Use lazy (.*?) when possible
    *     ✅ Avoid catastrophic backtracking
    *     ✅ Test with large inputs
    *
    * 12. Testing Tools:
    *     regex101.com - Online tester
    *     regexr.com - Visual regex
    *     Test in browser console
*/

