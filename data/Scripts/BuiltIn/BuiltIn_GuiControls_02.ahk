#Requires AutoHotkey v2.0

/**
* BuiltIn_GuiControls_02.ahk - Edit and Input Controls
*
* This file demonstrates edit boxes and input controls in AutoHotkey v2.
* Topics covered:
* - Single-line edit controls
* - Multi-line edit controls
* - Password fields
* - Read-only edit boxes
* - Input validation
* - Text manipulation
* - Number-only inputs
*
* @author AutoHotkey Community
* @version 2.0
* @date 2024
*/

; =============================================================================
; Example 1: Basic Edit Controls
; =============================================================================

/**
* Demonstrates basic edit control creation and usage
* Shows different edit box configurations
*/
Example1_BasicEdit() {
    myGui := Gui(, "Basic Edit Controls")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w460", "Edit Control Examples")
    myGui.SetFont("s9 Norm")

    ; Single-line edit
    myGui.Add("Text", "x20 y55", "Single-line Edit:")
    edit1 := myGui.Add("Edit", "x20 y75 w260", "Default text")

    ; Empty edit
    myGui.Add("Text", "x300 y55", "Empty Edit:")
    edit2 := myGui.Add("Edit", "x300 y75 w180")

    ; Wide edit
    myGui.Add("Text", "x20 y110", "Wide Edit:")
    edit3 := myGui.Add("Edit", "x20 y130 w460", "This is a wider edit control")

    ; Uppercase edit
    myGui.Add("Text", "x20 y165", "Uppercase Edit:")
    edit4 := myGui.Add("Edit", "x20 y185 w260 Uppercase", "converts to uppercase")

    ; Lowercase edit
    myGui.Add("Text", "x300 y165", "Lowercase Edit:")
    edit5 := myGui.Add("Edit", "x300 y185 w180 Lowercase", "CONVERTS TO LOWERCASE")

    ; Number-only edit
    myGui.Add("Text", "x20 y220", "Number Only:")
    edit6 := myGui.Add("Edit", "x20 y240 w260 Number", "12345")

    ; Password field
    myGui.Add("Text", "x300 y220", "Password Field:")
    edit7 := myGui.Add("Edit", "x300 y240 w180 Password", "secret")

    ; Multi-line edit
    myGui.Add("Text", "x20 y275", "Multi-line Edit:")
    edit8 := myGui.Add("Edit", "x20 y295 w460 h100 Multi", "Line 1`nLine 2`nLine 3`nMulti-line text area")

    ; Read-only edit
    myGui.Add("Text", "x20 y405", "Read-Only Edit:")
    edit9 := myGui.Add("Edit", "x20 y425 w460 ReadOnly", "This text cannot be edited")

    ; Get values button
    myGui.Add("Button", "x20 y460 w220", "Get All Values").OnEvent("Click", ShowValues)

    ShowValues(*) {
        values := "Edit Values:`n`n"
        values .= "1. " edit1.Value "`n"
        values .= "2. " edit2.Value "`n"
        values .= "3. " edit3.Value "`n"
        values .= "4. " edit4.Value "`n"
        values .= "5. " edit5.Value "`n"
        values .= "6. " edit6.Value "`n"
        values .= "7. " edit7.Value "`n"
        values .= "8. " edit8.Value "`n"
        values .= "9. " edit9.Value
        MsgBox(values, "Values")
    }

    myGui.Add("Button", "x250 y460 w230", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w500 h510")
}

; =============================================================================
; Example 2: Multi-line Text Editor
; =============================================================================

/**
* Creates a simple text editor with multi-line edit
* Demonstrates text manipulation functions
*/
Example2_TextEditor() {
    myGui := Gui(, "Simple Text Editor")
    myGui.BackColor := "0xF0F0F0"

    ; Menu bar simulation
    menuBar := myGui.Add("Text", "x0 y0 w600 h30 Background0xE0E0E0 Border", "")
    myGui.Add("Button", "x5 y5 w60 h20", "New").OnEvent("Click", (*) => editor.Value := "")
    myGui.Add("Button", "x70 y5 w60 h20", "Copy").OnEvent("Click", CopyText)
    myGui.Add("Button", "x135 y5 w60 h20", "Paste").OnEvent("Click", PasteText)
    myGui.Add("Button", "x200 y5 w60 h20", "Cut").OnEvent("Click", CutText)
    myGui.Add("Button", "x265 y5 w80 h20", "Select All").OnEvent("Click", SelectAll)

    ; Main editor
    editor := myGui.Add("Edit", "x10 y40 w580 h380 Multi WantTab")
    editor.Value := "Welcome to the Simple Text Editor!`n`nStart typing here...`n`nFeatures:`n• Multi-line editing`n• Copy/Paste/Cut`n• Character and word count`n• Line numbers`n• Find and replace"

    ; Status bar
    statusBar := myGui.Add("Text", "x0 y430 w600 h60 Background0xE0E0E0 Border", "")

    charCount := myGui.Add("Text", "x10 y440 w140", "Characters: 0")
    wordCount := myGui.Add("Text", "x160 y440 w140", "Words: 0")
    lineCount := myGui.Add("Text", "x310 y440 w140", "Lines: 0")

    ; Update stats
    myGui.Add("Button", "x460 y437 w130 h20", "Update Stats").OnEvent("Click", UpdateStats)

    UpdateStats(*) {
        text := editor.Value
        chars := StrLen(text)
        words := 0
        lines := 1

        ; Count words
        Loop Parse, text, " `t`n`r" {
            if (A_LoopField != "")
            words++
        }

        ; Count lines
        Loop Parse, text, "`n" {
            lines := A_Index
        }

        charCount.Value := "Characters: " chars
        wordCount.Value := "Words: " words
        lineCount.Value := "Lines: " lines
    }

    ; Text operations
    myGui.Add("Button", "x10 y465 w90", "Uppercase").OnEvent("Click", (*) => editor.Value := StrUpper(editor.Value))
    myGui.Add("Button", "x105 y465 w90", "Lowercase").OnEvent("Click", (*) => editor.Value := StrLower(editor.Value))
    myGui.Add("Button", "x200 y465 w90", "Title Case").OnEvent("Click", TitleCase)
    myGui.Add("Button", "x295 y465 w90", "Reverse").OnEvent("Click", ReverseText)
    myGui.Add("Button", "x390 y465 w90", "Clear").OnEvent("Click", (*) => editor.Value := "")
    myGui.Add("Button", "x485 y465 w105", "Close").OnEvent("Click", (*) => myGui.Destroy())

    CopyText(*) {
        A_Clipboard := editor.Value
        ToolTip("Copied to clipboard!")
        SetTimer(() => ToolTip(), -1000)
    }

    PasteText(*) {
        editor.Value := A_Clipboard
    }

    CutText(*) {
        A_Clipboard := editor.Value
        editor.Value := ""
        ToolTip("Cut to clipboard!")
        SetTimer(() => ToolTip(), -1000)
    }

    SelectAll(*) {
        editor.Focus()
        Send("^a")
    }

    TitleCase(*) {
        text := editor.Value
        result := ""
        capitalize := true

        Loop Parse, text {
            if (capitalize && RegExMatch(A_LoopField, "[a-zA-Z]")) {
                result .= StrUpper(A_LoopField)
                capitalize := false
            } else if (A_LoopField = " " || A_LoopField = "`n" || A_LoopField = "`t") {
                result .= A_LoopField
                capitalize := true
            } else {
                result .= StrLower(A_LoopField)
            }
        }
        editor.Value := result
    }

    ReverseText(*) {
        text := editor.Value
        result := ""
        Loop Parse, text {
            result := A_LoopField . result
        }
        editor.Value := result
    }

    UpdateStats()
    myGui.Show("w600 h500")
}

; =============================================================================
; Example 3: Form Input Validation
; =============================================================================

/**
* Demonstrates input validation techniques
* Real-time validation and error feedback
*/
Example3_InputValidation() {
    myGui := Gui(, "Input Validation Form")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w460", "Form Input Validation")
    myGui.SetFont("s9 Norm")

    ; Name field (required, letters only)
    myGui.Add("Text", "x20 y55", "Name (letters only, required):")
    nameEdit := myGui.Add("Edit", "x20 y75 w300")
    nameStatus := myGui.Add("Text", "x330 y75 w150 h23 Border Center BackgroundYellow", "Not validated")

    ; Email field (required, must contain @)
    myGui.Add("Text", "x20 y110", "Email (must contain @):")
    emailEdit := myGui.Add("Edit", "x20 y130 w300")
    emailStatus := myGui.Add("Text", "x330 y130 w150 h23 Border Center BackgroundYellow", "Not validated")

    ; Age field (number, 18-100)
    myGui.Add("Text", "x20 y165", "Age (18-100):")
    ageEdit := myGui.Add("Edit", "x20 y185 w300 Number")
    ageStatus := myGui.Add("Text", "x330 y185 w150 h23 Border Center BackgroundYellow", "Not validated")

    ; Phone field (numbers and dashes only)
    myGui.Add("Text", "x20 y220", "Phone (format: 555-123-4567):")
    phoneEdit := myGui.Add("Edit", "x20 y240 w300")
    phoneStatus := myGui.Add("Text", "x330 y240 w150 h23 Border Center BackgroundYellow", "Not validated")

    ; ZIP code (5 digits)
    myGui.Add("Text", "x20 y275", "ZIP Code (5 digits):")
    zipEdit := myGui.Add("Edit", "x20 y295 w300 Number")
    zipStatus := myGui.Add("Text", "x330 y295 w150 h23 Border Center BackgroundYellow", "Not validated")

    ; Password (min 8 chars, must include number)
    myGui.Add("Text", "x20 y330", "Password (min 8 chars, include number):")
    passEdit := myGui.Add("Edit", "x20 y350 w300 Password")
    passStatus := myGui.Add("Text", "x330 y350 w150 h23 Border Center BackgroundYellow", "Not validated")

    ; Confirm password
    myGui.Add("Text", "x20 y385", "Confirm Password:")
    pass2Edit := myGui.Add("Edit", "x20 y405 w300 Password")
    pass2Status := myGui.Add("Text", "x330 y405 w150 h23 Border Center BackgroundYellow", "Not validated")

    ; Validate button
    myGui.Add("Button", "x20 y445 w150", "Validate All").OnEvent("Click", ValidateAll)
    myGui.Add("Button", "x180 y445 w150", "Submit Form").OnEvent("Click", SubmitForm)
    myGui.Add("Button", "x340 y445 w140", "Clear Form").OnEvent("Click", ClearForm)

    ValidateAll(*) {
        ; Validate name
        name := nameEdit.Value
        if (name = "") {
            nameStatus.Value := "❌ Required"
            nameStatus.Opt("BackgroundRed")
        } else if (!RegExMatch(name, "^[a-zA-Z ]+$")) {
            nameStatus.Value := "❌ Letters only"
            nameStatus.Opt("BackgroundRed")
        } else {
            nameStatus.Value := "✓ Valid"
            nameStatus.Opt("BackgroundLime")
        }

        ; Validate email
        email := emailEdit.Value
        if (email = "") {
            emailStatus.Value := "❌ Required"
            emailStatus.Opt("BackgroundRed")
        } else if (!InStr(email, "@") || !InStr(email, ".")) {
            emailStatus.Value := "❌ Invalid"
            emailStatus.Opt("BackgroundRed")
        } else {
            emailStatus.Value := "✓ Valid"
            emailStatus.Opt("BackgroundLime")
        }

        ; Validate age
        age := ageEdit.Value
        if (age = "") {
            ageStatus.Value := "❌ Required"
            ageStatus.Opt("BackgroundRed")
        } else if (age < 18 || age > 100) {
            ageStatus.Value := "❌ 18-100 only"
            ageStatus.Opt("BackgroundRed")
        } else {
            ageStatus.Value := "✓ Valid"
            ageStatus.Opt("BackgroundLime")
        }

        ; Validate phone
        phone := phoneEdit.Value
        if (phone = "") {
            phoneStatus.Value := "❌ Required"
            phoneStatus.Opt("BackgroundRed")
        } else if (!RegExMatch(phone, "^\d{3}-\d{3}-\d{4}$")) {
            phoneStatus.Value := "❌ Use format"
            phoneStatus.Opt("BackgroundRed")
        } else {
            phoneStatus.Value := "✓ Valid"
            phoneStatus.Opt("BackgroundLime")
        }

        ; Validate ZIP
        zip := zipEdit.Value
        if (zip = "") {
            zipStatus.Value := "❌ Required"
            zipStatus.Opt("BackgroundRed")
        } else if (StrLen(zip) != 5) {
            zipStatus.Value := "❌ 5 digits"
            zipStatus.Opt("BackgroundRed")
        } else {
            zipStatus.Value := "✓ Valid"
            zipStatus.Opt("BackgroundLime")
        }

        ; Validate password
        pass := passEdit.Value
        if (pass = "") {
            passStatus.Value := "❌ Required"
            passStatus.Opt("BackgroundRed")
        } else if (StrLen(pass) < 8) {
            passStatus.Value := "❌ Too short"
            passStatus.Opt("BackgroundRed")
        } else if (!RegExMatch(pass, "\d")) {
            passStatus.Value := "❌ Need number"
            passStatus.Opt("BackgroundRed")
        } else {
            passStatus.Value := "✓ Valid"
            passStatus.Opt("BackgroundLime")
        }

        ; Validate password match
        pass2 := pass2Edit.Value
        if (pass2 = "") {
            pass2Status.Value := "❌ Required"
            pass2Status.Opt("BackgroundRed")
        } else if (pass != pass2) {
            pass2Status.Value := "❌ No match"
            pass2Status.Opt("BackgroundRed")
        } else {
            pass2Status.Value := "✓ Matches"
            pass2Status.Opt("BackgroundLime")
        }
    }

    SubmitForm(*) {
        ValidateAll()

        ; Check if all valid
        if (nameStatus.Value = "✓ Valid"
        && emailStatus.Value = "✓ Valid"
        && ageStatus.Value = "✓ Valid"
        && phoneStatus.Value = "✓ Valid"
        && zipStatus.Value = "✓ Valid"
        && passStatus.Value = "✓ Valid"
        && pass2Status.Value = "✓ Matches") {

            MsgBox("All fields are valid!`n`nForm submitted successfully.", "Success")
        } else {
            MsgBox("Please fix all validation errors before submitting.", "Validation Error")
        }
    }

    ClearForm(*) {
        nameEdit.Value := ""
        emailEdit.Value := ""
        ageEdit.Value := ""
        phoneEdit.Value := ""
        zipEdit.Value := ""
        passEdit.Value := ""
        pass2Edit.Value := ""

        for ctrl in [nameStatus, emailStatus, ageStatus, phoneStatus, zipStatus, passStatus, pass2Status] {
            ctrl.Value := "Not validated"
            ctrl.Opt("BackgroundYellow")
        }
    }

    myGui.Show("w500 h490")
}

; =============================================================================
; Example 4: Password Strength Meter
; =============================================================================

/**
* Real-time password strength indicator
* Demonstrates dynamic validation feedback
*/
Example4_PasswordStrength() {
    myGui := Gui(, "Password Strength Meter")
    myGui.BackColor := "White"

    myGui.SetFont("s12 Bold")
    myGui.Add("Text", "x20 y20 w460", "Password Strength Checker")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55", "Enter Password:")
    passEdit := myGui.Add("Edit", "x20 y75 w460 Password")

    ; Strength bar
    strengthBar := myGui.Add("Progress", "x20 y110 w460 h25 Background0xEEEEEE", 0)
    strengthText := myGui.Add("Text", "x20 y140 w460 h30 Center", "")
    strengthText.SetFont("s11 Bold")

    ; Requirements checklist
    myGui.Add("Text", "x20 y180", "Password Requirements:")
    check1 := myGui.Add("Text", "x20 y205 w460", "❌ At least 8 characters")
    check2 := myGui.Add("Text", "x20 y230 w460", "❌ Contains uppercase letter")
    check3 := myGui.Add("Text", "x20 y255 w460", "❌ Contains lowercase letter")
    check4 := myGui.Add("Text", "x20 y280 w460", "❌ Contains number")
    check5 := myGui.Add("Text", "x20 y305 w460", "❌ Contains special character (!@#$%^&*)")

    ; Show password checkbox
    showPass := myGui.Add("Checkbox", "x20 y340", "Show password")
    showPass.OnEvent("Click", TogglePassword)

    ; Update strength on keypress
    passEdit.OnEvent("Change", CheckStrength)

    TogglePassword(*) {
        if (showPass.Value) {
            passEdit.Opt("-Password")
        } else {
            passEdit.Opt("+Password")
        }
    }

    CheckStrength(*) {
        pass := passEdit.Value
        strength := 0
        checks := []

        ; Check length
        if (StrLen(pass) >= 8) {
            checks.Push(true)
            check1.Value := "✓ At least 8 characters"
            check1.Opt("cGreen")
            strength += 20
        } else {
            checks.Push(false)
            check1.Value := "❌ At least 8 characters"
            check1.Opt("cRed")
        }

        ; Check uppercase
        if (RegExMatch(pass, "[A-Z]")) {
            checks.Push(true)
            check2.Value := "✓ Contains uppercase letter"
            check2.Opt("cGreen")
            strength += 20
        } else {
            checks.Push(false)
            check2.Value := "❌ Contains uppercase letter"
            check2.Opt("cRed")
        }

        ; Check lowercase
        if (RegExMatch(pass, "[a-z]")) {
            checks.Push(true)
            check3.Value := "✓ Contains lowercase letter"
            check3.Opt("cGreen")
            strength += 20
        } else {
            checks.Push(false)
            check3.Value := "❌ Contains lowercase letter"
            check3.Opt("cRed")
        }

        ; Check number
        if (RegExMatch(pass, "\d")) {
            checks.Push(true)
            check4.Value := "✓ Contains number"
            check4.Opt("cGreen")
            strength += 20
        } else {
            checks.Push(false)
            check4.Value := "❌ Contains number"
            check4.Opt("cRed")
        }

        ; Check special character
        if (RegExMatch(pass, "[!@#$%^&*()_+\-=\[\]{};':\"\\|,.<>/?]")) {
            checks.Push(true)
            check5.Value := "✓ Contains special character (!@#$%^&*)"
            check5.Opt("cGreen")
            strength += 20
        } else {
            checks.Push(false)
            check5.Value := "❌ Contains special character (!@#$%^&*)"
            check5.Opt("cRed")
        }

        ; Update strength bar
        strengthBar.Value := strength

        ; Update strength text and color
        if (strength = 0) {
            strengthText.Value := ""
        } else if (strength <= 40) {
            strengthText.Value := "Strength: WEAK"
            strengthText.Opt("cRed")
        } else if (strength <= 60) {
            strengthText.Value := "Strength: FAIR"
            strengthText.Opt("cOrange")
        } else if (strength <= 80) {
            strengthText.Value := "Strength: GOOD"
            strengthText.Opt("cBlue")
        } else {
            strengthText.Value := "Strength: STRONG"
            strengthText.Opt("cGreen")
        }
    }

    myGui.Add("Button", "x20 y375 w220", "Generate Strong Password").OnEvent("Click", GeneratePassword)
    myGui.Add("Button", "x250 y375 w230", "Close").OnEvent("Click", (*) => myGui.Destroy())

    GeneratePassword(*) {
        ; Generate random strong password
        chars := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        password := ""
        Loop 12 {
            Random(&pos, 1, StrLen(chars))
            password .= SubStr(chars, pos, 1)
        }
        passEdit.Value := password
        showPass.Value := 1
        TogglePassword()
        CheckStrength()
    }

    myGui.Show("w500 h420")
}

; =============================================================================
; Example 5: Search and Filter
; =============================================================================

/**
* Search box with real-time filtering
* Demonstrates incremental search functionality
*/
Example5_SearchFilter() {
    myGui := Gui(, "Search and Filter Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Search and Filter Example")
    myGui.SetFont("s9 Norm")

    ; Sample data
    allItems := [
    "Apple", "Banana", "Cherry", "Date", "Elderberry",
    "Fig", "Grape", "Honeydew", "Kiwi", "Lemon",
    "Mango", "Nectarine", "Orange", "Papaya", "Quince",
    "Raspberry", "Strawberry", "Tangerine", "Ugli Fruit", "Watermelon",
    "Apricot", "Blueberry", "Cantaloupe", "Dragonfruit", "Grapefruit"
    ]

    ; Search box
    myGui.Add("Text", "x20 y55", "Search:")
    searchEdit := myGui.Add("Edit", "x20 y75 w460")
    clearBtn := myGui.Add("Button", "x490 y75 w90", "Clear")

    ; Results count
    resultText := myGui.Add("Text", "x20 y110 w560", Format("Showing all {1} items", allItems.Length))

    ; Results list
    resultList := myGui.Add("ListBox", "x20 y135 w560 h300", allItems)

    ; Search on keypress
    searchEdit.OnEvent("Change", FilterResults)
    clearBtn.OnEvent("Click", (*) => (searchEdit.Value := "", FilterResults()))

    FilterResults(*) {
        query := StrLower(searchEdit.Value)
        resultList.Delete()

        if (query = "") {
            resultList.Add(allItems)
            resultText.Value := Format("Showing all {1} items", allItems.Length)
        } else {
            filtered := []
            for item in allItems {
                if (InStr(StrLower(item), query)) {
                    filtered.Push(item)
                }
            }

            if (filtered.Length > 0) {
                resultList.Add(filtered)
                resultText.Value := Format("Found {1} item{2} matching '{3}'",
                filtered.Length, filtered.Length = 1 ? "" : "s", query)
            } else {
                resultText.Value := Format("No items found matching '{1}'", query)
            }
        }
    }

    ; Action buttons
    myGui.Add("Button", "x20 y445 w180", "Select Item").OnEvent("Click", SelectItem)
    myGui.Add("Button", "x210 y445 w180", "Add to Favorites").OnEvent("Click", AddFavorite)
    myGui.Add("Button", "x400 y445 w180", "Close").OnEvent("Click", (*) => myGui.Destroy())

    SelectItem(*) {
        selected := resultList.Text
        if (selected != "") {
            MsgBox("Selected: " selected, "Item Selected")
        } else {
            MsgBox("Please select an item first", "No Selection")
        }
    }

    AddFavorite(*) {
        selected := resultList.Text
        if (selected != "") {
            MsgBox("Added to favorites: " selected, "Favorite Added")
        } else {
            MsgBox("Please select an item first", "No Selection")
        }
    }

    searchEdit.Focus()
    myGui.Show("w600 h490")
}

; =============================================================================
; Example 6: Auto-Complete Input
; =============================================================================

/**
* Edit control with auto-complete suggestions
* Demonstrates suggestion dropdown
*/
Example6_AutoComplete() {
    myGui := Gui(, "Auto-Complete Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w460", "Auto-Complete Input Field")
    myGui.SetFont("s9 Norm")

    ; Suggestions database
    suggestions := [
    "JavaScript", "Python", "Java", "C++", "C#",
    "Ruby", "PHP", "Swift", "Kotlin", "Go",
    "Rust", "TypeScript", "Perl", "Scala", "Haskell",
    "AutoHotkey", "PowerShell", "Bash", "SQL", "HTML"
    ]

    myGui.Add("Text", "x20 y55", "Type a programming language:")
    inputEdit := myGui.Add("Edit", "x20 y75 w460")

    myGui.Add("Text", "x20 y110", "Suggestions:")
    suggestionList := myGui.Add("ListBox", "x20 y130 w460 h200", [])
    suggestionList.Visible := false

    resultText := myGui.Add("Text", "x20 y345 w460 h60 Border BackgroundWhite", "Selected: None")

    inputEdit.OnEvent("Change", ShowSuggestions)
    suggestionList.OnEvent("DoubleClick", SelectSuggestion)

    ShowSuggestions(*) {
        query := inputEdit.Value

        if (query = "" || StrLen(query) < 2) {
            suggestionList.Visible := false
            return
        }

        ; Filter suggestions
        matches := []
        for item in suggestions {
            if (InStr(StrLower(item), StrLower(query)) = 1) {  ; Starts with query
            matches.Push(item)
        }
    }

    if (matches.Length > 0) {
        suggestionList.Delete()
        suggestionList.Add(matches)
        suggestionList.Visible := true
        suggestionList.Choose(1)
    } else {
        suggestionList.Visible := false
    }
}

SelectSuggestion(*) {
    selected := suggestionList.Text
    if (selected != "") {
        inputEdit.Value := selected
        suggestionList.Visible := false
        resultText.Value := "Selected: " selected
    }
}

myGui.Add("Button", "x20 y420 w220", "Use Selected").OnEvent("Click", UseSelection)
myGui.Add("Button", "x250 y420 w230", "Close").OnEvent("Click", (*) => myGui.Destroy())

UseSelection(*) {
    value := inputEdit.Value
    if (value != "") {
        MsgBox("Using: " value, "Selection")
        resultText.Value := "Selected: " value
    }
}

inputEdit.Focus()
myGui.Show("w500 h465")
}

; =============================================================================
; Example 7: Character Counter and Limiter
; =============================================================================

/**
* Text input with character limit and counter
* Real-time character counting
*/
Example7_CharacterLimit() {
    myGui := Gui(, "Character Counter Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w460", "Character Limit Examples")
    myGui.SetFont("s9 Norm")

    ; Tweet-style limit (280 chars)
    myGui.Add("Text", "x20 y55", "Tweet (280 character limit):")
    tweetEdit := myGui.Add("Edit", "x20 y75 w460 h80 Multi")
    tweetCounter := myGui.Add("Text", "x20 y160 w460 Right", "0 / 280")

    tweetEdit.OnEvent("Change", UpdateTweetCounter)

    UpdateTweetCounter(*) {
        text := tweetEdit.Value
        length := StrLen(text)
        maxLen := 280

        if (length > maxLen) {
            tweetEdit.Value := SubStr(text, 1, maxLen)
            length := maxLen
        }

        tweetCounter.Value := length " / " maxLen

        if (length > maxLen * 0.9) {
            tweetCounter.Opt("cRed")
        } else if (length > maxLen * 0.75) {
            tweetCounter.Opt("cOrange")
        } else {
            tweetCounter.Opt("cGreen")
        }
    }

    ; Bio (150 chars)
    myGui.Add("Text", "x20 y190", "Bio (150 character limit):")
    bioEdit := myGui.Add("Edit", "x20 y210 w460 h60 Multi")
    bioCounter := myGui.Add("Text", "x20 y275 w460 Right", "0 / 150")

    bioEdit.OnEvent("Change", UpdateBioCounter)

    UpdateBioCounter(*) {
        text := bioEdit.Value
        length := StrLen(text)
        maxLen := 150

        if (length > maxLen) {
            bioEdit.Value := SubStr(text, 1, maxLen)
            length := maxLen
        }

        bioCounter.Value := length " / " maxLen

        if (length >= maxLen) {
            bioCounter.Opt("cRed")
        } else {
            bioCounter.Opt("cBlack")
        }
    }

    ; Comment (500 chars)
    myGui.Add("Text", "x20 y305", "Comment (500 character limit):")
    commentEdit := myGui.Add("Edit", "x20 y325 w460 h100 Multi")
    commentCounter := myGui.Add("Text", "x20 y430 w460", "Characters: 0 / 500 | Words: 0")

    commentEdit.OnEvent("Change", UpdateCommentCounter)

    UpdateCommentCounter(*) {
        text := commentEdit.Value
        length := StrLen(text)
        maxLen := 500

        if (length > maxLen) {
            commentEdit.Value := SubStr(text, 1, maxLen)
            length := maxLen
        }

        ; Count words
        words := 0
        Loop Parse, text, " `t`n`r" {
            if (A_LoopField != "")
            words++
        }

        commentCounter.Value := Format("Characters: {1} / {2} | Words: {3}", length, maxLen, words)
    }

    myGui.Add("Button", "x20 y460 w460", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w500 h505")
}

; =============================================================================
; Main Menu - Example Launcher
; =============================================================================

/**
* Creates a main menu to launch all examples
*/
ShowMainMenu() {
    menuGui := Gui(, "BuiltIn_GuiControls_02 - Edit Control Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Edit and Input Control Examples")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    ; Example buttons
    menuGui.Add("Button", "x20 y80 w360", "Example 1: Basic Edit Controls").OnEvent("Click", (*) => Example1_BasicEdit())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Text Editor").OnEvent("Click", (*) => Example2_TextEditor())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Input Validation").OnEvent("Click", (*) => Example3_InputValidation())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Password Strength").OnEvent("Click", (*) => Example4_PasswordStrength())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Search and Filter").OnEvent("Click", (*) => Example5_SearchFilter())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Auto-Complete").OnEvent("Click", (*) => Example6_AutoComplete())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Character Limit").OnEvent("Click", (*) => Example7_CharacterLimit())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
