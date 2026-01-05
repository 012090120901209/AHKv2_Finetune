#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Hotstring Option: T (Text mode / Raw)
 * Sends text as-is without interpreting special characters
 */

; Without T, characters like {, }, ! would be interpreted
; With T, they're sent literally

; Send literal braces
:T:{{::{{}}
:T:mycode::`n{`n    // code here`n}

; Email template with special chars
:T:emailsig::
(
Best regards,
John Doe
Email: john@company.com
Tel: +1 (555) 123-4567
)

; Code snippets with special characters
:T:forloop::for (let i = 0; i < length; i++) { }

; HTML templates
:T:divtag::<div class="container"></div>
:T:htmllink::<a href="https://example.com">Link Text</a>

; Regular expressions
:T:regex::/^[a-zA-Z0-9]+$/

; Markdown formatting
:T:mdlink::[Link Text](https://example.com)
:T:mdcode::```javascript`n`n```
