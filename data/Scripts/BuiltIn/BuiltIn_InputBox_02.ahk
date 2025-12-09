#Requires AutoHotkey v2.0

/**
* ============================================================================
* InputBox Advanced Validation - Part 2
* ============================================================================
*
* Advanced InputBox validation and data collection patterns in AutoHotkey v2.
*
* @description This file covers advanced InputBox validation including:
*              - Complex validation rules
*              - Multi-field forms
*              - Conditional validation
*              - Custom validators
*              - Data transformation
*
* @author AutoHotkey Foundation
* @version 2.0
* @see https://www.autohotkey.com/docs/v2/lib/InputBox.htm
*
* ============================================================================
*/

; ============================================================================
; EXAMPLE 1: Advanced Numeric Validation
; ============================================================================
/**
* Demonstrates advanced numeric validation patterns.
*
* @description Shows validation for integers, floats, ranges,
*              and formatted numbers.
*/
Example1_AdvancedNumericValidation() {
    ; Integer validation with range
    number := GetValidInteger("Enter a number between 1 and 100:", "Number Input", 1, 100)
    if (number != "")
    MsgBox "Valid number: " . number

    ; Float/Decimal validation
    price := GetValidFloat("Enter price (up to 2 decimal places):", "Price Input", 0.01, 9999.99, 2)
    if (price != "")
    MsgBox "Price: $" . Format("{:.2f}", price)

    ; Percentage validation (0-100)
    percentage := GetValidPercentage("Enter discount percentage:", "Discount")
    if (percentage != "")
    MsgBox "Discount: " . percentage . "%"

    ; Even number validation
    evenNum := GetValidEvenNumber("Enter an even number:", "Even Number")
    if (evenNum != "")
    MsgBox "Even number: " . evenNum

    ; Multiple of validation
    multipleOf5 := GetValidMultiple("Enter a multiple of 5:", "Multiple Input", 5)
    if (multipleOf5 != "")
    MsgBox "Multiple of 5: " . multipleOf5

    ; Positive/Negative validation
    positiveNum := GetPositiveNumber("Enter a positive number:", "Positive Number")
    if (positiveNum != "")
    MsgBox "Positive number: " . positiveNum

    ; Currency validation
    amount := GetCurrencyInput("Enter amount:", "Payment")
    if (amount != "")
    MsgBox "Amount: $" . Format("{:.2f}", amount)
}

/**
* Gets a valid integer within a range.
*/
GetValidInteger(prompt, title, min := "", max := "") {
    Loop {
        ib := InputBox(prompt, title)
        if (ib.Result = "Cancel")
        return ""

        value := ib.Value

        if (!IsNumber(value) || InStr(value, ".")) {
            MsgBox "Please enter a valid integer!", "Error", "Iconx"
            continue
        }

        num := Integer(value)

        if (min != "" && num < min) {
            MsgBox "Number must be at least " . min . "!", "Error", "Iconx"
            continue
        }

        if (max != "" && num > max) {
            MsgBox "Number must not exceed " . max . "!", "Error", "Iconx"
            continue
        }

        return num
    }
}

/**
* Gets a valid float with decimal precision.
*/
GetValidFloat(prompt, title, min := "", max := "", decimals := 2) {
    Loop {
        ib := InputBox(prompt, title)
        if (ib.Result = "Cancel")
        return ""

        value := ib.Value

        if (!IsNumber(value)) {
            MsgBox "Please enter a valid number!", "Error", "Iconx"
            continue
        }

        num := Float(value)

        ; Check decimal places
        if (InStr(value, ".")) {
            decimalPart := SubStr(value, InStr(value, ".") + 1)
            if (StrLen(decimalPart) > decimals) {
                MsgBox "Maximum " . decimals . " decimal places allowed!", "Error", "Iconx"
                continue
            }
        }

        if (min != "" && num < min) {
            MsgBox "Value must be at least " . min . "!", "Error", "Iconx"
            continue
        }

        if (max != "" && num > max) {
            MsgBox "Value must not exceed " . max . "!", "Error", "Iconx"
            continue
        }

        return num
    }
}

/**
* Gets a valid percentage (0-100).
*/
GetValidPercentage(prompt, title) {
    return GetValidFloat(prompt, title, 0, 100, 2)
}

/**
* Gets a valid even number.
*/
GetValidEvenNumber(prompt, title) {
    Loop {
        num := GetValidInteger(prompt, title)
        if (num = "")
        return ""

        if (Mod(num, 2) = 0)
        return num

        MsgBox "Please enter an even number!", "Error", "Iconx"
    }
}

/**
* Gets a number that is a multiple of another.
*/
GetValidMultiple(prompt, title, multipleOf) {
    Loop {
        num := GetValidInteger(prompt, title)
        if (num = "")
        return ""

        if (Mod(num, multipleOf) = 0)
        return num

        MsgBox "Number must be a multiple of " . multipleOf . "!", "Error", "Iconx"
    }
}

/**
* Gets a positive number.
*/
GetPositiveNumber(prompt, title) {
    Loop {
        num := GetValidFloat(prompt, title)
        if (num = "")
        return ""

        if (num > 0)
        return num

        MsgBox "Number must be positive!", "Error", "Iconx"
    }
}

/**
* Gets currency input with validation.
*/
GetCurrencyInput(prompt, title) {
    Loop {
        ib := InputBox(prompt, title)
        if (ib.Result = "Cancel")
        return ""

        ; Remove currency symbols and spaces
        value := StrReplace(ib.Value, "$")
        value := StrReplace(value, " ")
        value := StrReplace(value, ",")

        if (!IsNumber(value)) {
            MsgBox "Please enter a valid amount!", "Error", "Iconx"
            continue
        }

        amount := Float(value)

        if (amount < 0) {
            MsgBox "Amount cannot be negative!", "Error", "Iconx"
            continue
        }

        return amount
    }
}

; ============================================================================
; EXAMPLE 2: String Validation and Formatting
; ============================================================================
/**
* Shows advanced string validation and formatting.
*
* @description Demonstrates length validation, character restrictions,
*              and format transformations.
*/
Example2_StringValidation() {
    ; Length validation
    username := GetStringWithLength("Enter username:", "Username", 3, 20)
    if (username != "")
    MsgBox "Username: " . username

    ; Alphanumeric only
    code := GetAlphanumericString("Enter alphanumeric code:", "Code Input")
    if (code != "")
    MsgBox "Code: " . code

    ; No spaces allowed
    identifier := GetNoSpaceString("Enter identifier (no spaces):", "Identifier")
    if (identifier != "")
    MsgBox "Identifier: " . identifier

    ; Uppercase transformation
    state := GetUppercaseString("Enter state code:", "State", 2, 2)
    if (state != "")
    MsgBox "State: " . state

    ; Lowercase transformation
    domain := GetLowercaseString("Enter domain name:", "Domain")
    if (domain != "")
    MsgBox "Domain: " . domain

    ; Title case transformation
    name := GetTitleCaseString("Enter your name:", "Name")
    if (name != "")
    MsgBox "Name: " . name

    ; Pattern matching (custom regex)
    zipCode := GetPatternString("Enter ZIP code:", "ZIP Code", "^\d{5}(-\d{4})?$")
    if (zipCode != "")
    MsgBox "ZIP Code: " . zipCode
}

/**
* Gets string with length constraints.
*/
GetStringWithLength(prompt, title, minLen := 1, maxLen := "") {
    Loop {
        ib := InputBox(prompt, title)
        if (ib.Result = "Cancel")
        return ""

        value := ib.Value
        length := StrLen(value)

        if (length < minLen) {
            MsgBox "Minimum length: " . minLen . " characters`nYour length: " . length,
            "Too Short", "Iconx"
            continue
        }

        if (maxLen != "" && length > maxLen) {
            MsgBox "Maximum length: " . maxLen . " characters`nYour length: " . length,
            "Too Long", "Iconx"
            continue
        }

        return value
    }
}

/**
* Gets alphanumeric string only.
*/
GetAlphanumericString(prompt, title) {
    Loop {
        ib := InputBox(prompt, title)
        if (ib.Result = "Cancel")
        return ""

        value := ib.Value

        if (!RegExMatch(value, "^[a-zA-Z0-9]+$")) {
            MsgBox "Only letters and numbers allowed!", "Error", "Iconx"
            continue
        }

        return value
    }
}

/**
* Gets string without spaces.
*/
GetNoSpaceString(prompt, title) {
    Loop {
        ib := InputBox(prompt, title)
        if (ib.Result = "Cancel")
        return ""

        value := ib.Value

        if (InStr(value, " ")) {
            MsgBox "Spaces are not allowed!", "Error", "Iconx"
            continue
        }

        return value
    }
}

/**
* Gets string and converts to uppercase.
*/
GetUppercaseString(prompt, title, minLen := 1, maxLen := "") {
    value := GetStringWithLength(prompt, title, minLen, maxLen)
    return (value != "") ? StrUpper(value) : ""
}

/**
* Gets string and converts to lowercase.
*/
GetLowercaseString(prompt, title) {
    ib := InputBox(prompt, title)
    return (ib.Result = "OK") ? StrLower(ib.Value) : ""
}

/**
* Gets string and converts to title case.
*/
GetTitleCaseString(prompt, title) {
    ib := InputBox(prompt, title)
    if (ib.Result = "Cancel")
    return ""

    ; Simple title case: capitalize first letter of each word
    words := StrSplit(ib.Value, " ")
    result := ""

    for word in words {
        if (word != "") {
            result .= StrUpper(SubStr(word, 1, 1)) . StrLower(SubStr(word, 2)) . " "
        }
    }

    return Trim(result)
}

/**
* Gets string matching a regex pattern.
*/
GetPatternString(prompt, title, pattern) {
    Loop {
        ib := InputBox(prompt, title)
        if (ib.Result = "Cancel")
        return ""

        value := ib.Value

        if (!RegExMatch(value, pattern)) {
            MsgBox "Invalid format!", "Error", "Iconx"
            continue
        }

        return value
    }
}

; ============================================================================
; EXAMPLE 3: Multi-Field Form Collection
; ============================================================================
/**
* Demonstrates collecting multiple related fields with validation.
*
* @description Shows how to build complete forms with interdependent
*              field validation.
*/
Example3_MultiFieldForms() {
    ; User registration form
    userData := CollectUserRegistration()
    if (userData != "") {
        MsgBox Format("Registration Data:`n`n"
        . "Name: {1}`n"
        . "Email: {2}`n"
        . "Phone: {3}`n"
        . "Age: {4}",
        userData["name"],
        userData["email"],
        userData["phone"],
        userData["age"]),
        "Registration Complete"
    }

    ; Address form
    address := CollectAddress()
    if (address != "") {
        MsgBox Format("Address:`n`n"
        . "{1}`n"
        . "{2}, {3} {4}`n"
        . "{5}",
        address["street"],
        address["city"],
        address["state"],
        address["zip"],
        address["country"]),
        "Address Collected"
    }

    ; Payment information (simulated)
    payment := CollectPaymentInfo()
    if (payment != "") {
        MsgBox Format("Payment Method:`n`n"
        . "Cardholder: {1}`n"
        . "Card: **** **** **** {2}`n"
        . "Expires: {3}/{4}",
        payment["name"],
        payment["last4"],
        payment["expMonth"],
        payment["expYear"]),
        "Payment Info Collected"
    }
}

/**
* Collects user registration data.
*/
CollectUserRegistration() {
    data := Map()

    ; Name
    data["name"] := GetStringWithLength("Enter full name:", "Registration - Name", 2, 50)
    if (data["name"] = "")
    return ""

    ; Email
    Loop {
        email := InputBox("Enter email address:", "Registration - Email").Value
        if (email = "")
        return ""

        if (RegExMatch(email, "^[\w\.-]+@[\w\.-]+\.\w{2,}$")) {
            data["email"] := email
            break
        }

        MsgBox "Invalid email format!", "Error", "Iconx"
    }

    ; Phone
    Loop {
        phone := InputBox("Enter phone number (10 digits):", "Registration - Phone").Value
        if (phone = "")
        return ""

        cleanPhone := RegExReplace(phone, "[^\d]")

        if (StrLen(cleanPhone) = 10) {
            data["phone"] := cleanPhone
            break
        }

        MsgBox "Phone must be 10 digits!", "Error", "Iconx"
    }

    ; Age
    data["age"] := GetValidInteger("Enter age:", "Registration - Age", 13, 120)
    if (data["age"] = "")
    return ""

    return data
}

/**
* Collects address information.
*/
CollectAddress() {
    data := Map()

    ; Street
    data["street"] := GetStringWithLength("Enter street address:", "Address - Street", 5, 100)
    if (data["street"] = "")
    return ""

    ; City
    data["city"] := GetStringWithLength("Enter city:", "Address - City", 2, 50)
    if (data["city"] = "")
    return ""

    ; State
    data["state"] := GetUppercaseString("Enter state code (2 letters):", "Address - State", 2, 2)
    if (data["state"] = "")
    return ""

    ; ZIP
    data["zip"] := GetPatternString("Enter ZIP code:", "Address - ZIP", "^\d{5}(-\d{4})?$")
    if (data["zip"] = "")
    return ""

    ; Country
    data["country"] := InputBox("Enter country:", "Address - Country", , "United States").Value

    return data
}

/**
* Collects payment information (demo purposes).
*/
CollectPaymentInfo() {
    data := Map()

    ; Cardholder name
    data["name"] := GetStringWithLength("Enter cardholder name:", "Payment - Name", 2, 50)
    if (data["name"] = "")
    return ""

    ; Card number (simplified validation)
    Loop {
        cardNum := InputBox("Enter card number (16 digits):", "Payment - Card", "Password").Value
        if (cardNum = "")
        return ""

        cleanCard := RegExReplace(cardNum, "[^\d]")

        if (StrLen(cleanCard) = 16) {
            data["cardNum"] := cleanCard
            data["last4"] := SubStr(cleanCard, -3)
            break
        }

        MsgBox "Card number must be 16 digits!", "Error", "Iconx"
    }

    ; Expiration month
    data["expMonth"] := GetValidInteger("Enter expiration month (1-12):", "Payment - Exp Month", 1, 12)
    if (data["expMonth"] = "")
    return ""

    ; Expiration year
    currentYear := Integer(FormatTime(, "yyyy"))
    data["expYear"] := GetValidInteger("Enter expiration year:", "Payment - Exp Year", currentYear, currentYear + 10)
    if (data["expYear"] = "")
    return ""

    ; CVV
    data["cvv"] := GetPatternString("Enter CVV (3-4 digits):", "Payment - CVV", "^\d{3,4}$")
    if (data["cvv"] = "")
    return ""

    return data
}

; ============================================================================
; EXAMPLE 4: Conditional Validation
; ============================================================================
/**
* Shows validation that depends on previous inputs.
*
* @description Demonstrates interdependent field validation.
*/
Example4_ConditionalValidation() {
    ; Account type determines required fields
    accountType := MsgBox("Select account type:`n`nYes - Business`nNo - Personal",
    "Account Type",
    "YesNo")

    if (accountType = "Yes") {
        ; Business account
        companyName := GetStringWithLength("Enter company name:", "Business Info", 2, 100)
        taxId := GetPatternString("Enter Tax ID (XX-XXXXXXX):", "Business Info", "^\d{2}-\d{7}$")

        if (companyName != "" && taxId != "") {
            MsgBox "Business account created for: " . companyName
        }
    } else {
        ; Personal account
        firstName := GetStringWithLength("Enter first name:", "Personal Info", 2, 50)
        lastName := GetStringWithLength("Enter last name:", "Personal Info", 2, 50)

        if (firstName != "" && lastName != "") {
            MsgBox "Personal account created for: " . firstName . " " . lastName
        }
    }

    ; Age-based validation
    age := GetValidInteger("Enter age:", "Age Check", 1, 120)
    if (age = "")
    return

    if (age < 18) {
        parent := GetStringWithLength("Enter parent/guardian name:", "Parental Consent", 2, 50)
        if (parent != "") {
            MsgBox "Minor account - Parent: " . parent
        }
    } else {
        MsgBox "Adult account created."
    }

    ; Shipping option determines address requirement
    needsShipping := MsgBox("Physical product? Requires shipping address.",
    "Shipping",
    "YesNo")

    if (needsShipping = "Yes") {
        address := CollectAddress()
        if (address != "") {
            MsgBox "Shipping address collected."
        }
    } else {
        MsgBox "Digital product - no shipping needed."
    }
}

; ============================================================================
; EXAMPLE 5: Data Transformation and Sanitization
; ============================================================================
/**
* Demonstrates input transformation and sanitization.
*
* @description Shows how to clean and transform user input.
*/
Example5_DataTransformation() {
    ; Trim whitespace
    input := InputBox("Enter text (may have extra spaces):", "Trim Test").Value
    cleaned := Trim(input)
    MsgBox Format("Original: '{1}'`nCleaned: '{2}'", input, cleaned)

    ; Remove special characters
    input := InputBox("Enter text with special characters:", "Sanitize").Value
    sanitized := RegExReplace(input, "[^\w\s]", "")
    MsgBox Format("Original: {1}`nSanitized: {2}", input, sanitized)

    ; Normalize phone number
    phone := InputBox("Enter phone (any format):", "Phone").Value
    normalized := RegExReplace(phone, "[^\d]", "")
    if (StrLen(normalized) = 10) {
        formatted := Format("({1}) {2}-{3}",
        SubStr(normalized, 1, 3),
        SubStr(normalized, 4, 3),
        SubStr(normalized, 7, 4))
        MsgBox "Formatted: " . formatted
    }

    ; Convert to slug (URL-friendly)
    title := InputBox("Enter page title:", "Create Slug").Value
    slug := StrLower(title)
    slug := RegExReplace(slug, "\s+", "-")
    slug := RegExReplace(slug, "[^\w\-]", "")
    MsgBox Format("Title: {1}`nSlug: {2}", title, slug)

    ; Extract numbers from mixed input
    input := InputBox("Enter mixed text and numbers:", "Extract Numbers").Value
    numbers := RegExReplace(input, "[^\d]", "")
    MsgBox Format("Input: {1}`nNumbers only: {2}", input, numbers)
}

; ============================================================================
; EXAMPLE 6: Password Strength Validation
; ============================================================================
/**
* Advanced password validation with strength checking.
*
* @description Demonstrates complex password requirements.
*/
Example6_PasswordStrength() {
    Loop {
        password := InputBox("Create password:`n`n"
        . "Requirements:`n"
        . "- At least 8 characters`n"
        . "- At least one uppercase letter`n"
        . "- At least one lowercase letter`n"
        . "- At least one number`n"
        . "- At least one special character",
        "Password",
        "Password W400").Value

        if (password = "")
        return

        ; Check length
        if (StrLen(password) < 8) {
            MsgBox "Password must be at least 8 characters!", "Too Short", "Iconx"
            continue
        }

        ; Check for uppercase
        if (!RegExMatch(password, "[A-Z]")) {
            MsgBox "Password must contain at least one uppercase letter!", "Missing Uppercase", "Iconx"
            continue
        }

        ; Check for lowercase
        if (!RegExMatch(password, "[a-z]")) {
            MsgBox "Password must contain at least one lowercase letter!", "Missing Lowercase", "Iconx"
            continue
        }

        ; Check for number
        if (!RegExMatch(password, "\d")) {
            MsgBox "Password must contain at least one number!", "Missing Number", "Iconx"
            continue
        }

        ; Check for special character
        if (!RegExMatch(password, "[!@#$%^&*(),.?':{}|<>]")) {
            MsgBox "Password must contain at least one special character!", "Missing Special", "Iconx"
            continue
        }

        ; Calculate strength
        strength := CalculatePasswordStrength(password)
        MsgBox Format("Password accepted!`n`nStrength: {1}",
        strength),
        "Success",
        "Iconi"
        break
    }
}

/**
* Calculates password strength score.
*/
CalculatePasswordStrength(password) {
    score := 0

    if (StrLen(password) >= 8)
    score += 20
    if (StrLen(password) >= 12)
    score += 20
    if (RegExMatch(password, "[A-Z]"))
    score += 20
    if (RegExMatch(password, "[a-z]"))
    score += 20
    if (RegExMatch(password, "\d"))
    score += 10
    if (RegExMatch(password, "[!@#$%^&*(),.?':{}|<>]"))
    score += 10

    if (score >= 80)
    return "Strong"
    else if (score >= 60)
    return "Medium"
    else
    return "Weak"
}

; ============================================================================
; EXAMPLE 7: Batch Input Collection
; ============================================================================
/**
* Collects multiple similar inputs efficiently.
*
* @description Shows patterns for collecting lists of data.
*/
Example7_BatchInput() {
    ; Collect multiple items
    items := []
    Loop {
        item := InputBox(Format("Enter item #{1} (or leave blank to finish):",
        items.Length + 1),
        "Item Entry").Value

        if (item = "")
        break

        items.Push(item)

        if (items.Length >= 10) {
            shouldContinue := MsgBox("You've entered 10 items. Continue adding more?",
            "Continue?",
            "YesNo")
            if (shouldContinue = "No")
            break
        }
    }

    if (items.Length > 0) {
        list := ""
        for index, item in items {
            list .= index . ". " . item . "`n"
        }
        MsgBox Format("Collected {1} items:`n`n{2}", items.Length, list)
    }

    ; Collect key-value pairs
    config := Map()
    Loop {
        key := InputBox("Enter configuration key (or blank to finish):", "Config Key").Value
        if (key = "")
        break

        value := InputBox(Format("Enter value for '{1}':", key), "Config Value").Value

        config[key] := value
    }

    if (config.Count > 0) {
        settings := ""
        for key, value in config {
            settings .= key . " = " . value . "`n"
        }
        MsgBox Format("Configuration ({1} settings):`n`n{2}",
        config.Count,
        settings)
    }
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1::Example1_AdvancedNumericValidation()
^2::Example2_StringValidation()
^3::Example3_MultiFieldForms()
^4::Example4_ConditionalValidation()
^5::Example5_DataTransformation()
^6::Example6_PasswordStrength()
^7::Example7_BatchInput()
^0::ExitApp

/**
* ============================================================================
* SUMMARY
* ============================================================================
*
* Advanced InputBox patterns:
* 1. Advanced numeric validation (integers, floats, ranges, multiples)
* 2. String validation and formatting (length, case, patterns)
* 3. Multi-field form collection with validation
* 4. Conditional validation based on previous inputs
* 5. Data transformation and sanitization
* 6. Password strength validation
* 7. Batch input collection for lists and configurations
*
* ============================================================================
*/
