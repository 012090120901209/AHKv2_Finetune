#Requires AutoHotkey v2.0

/**
* BuiltIn_StrCase_02_TextFormatting.ahk
*
* DESCRIPTION:
* Advanced text formatting examples using StrLower(), StrUpper(), and StrTitle()
* for real-world applications including name formatting, constants, and user input.
*
* FEATURES:
* - Format person names with proper title case
* - Handle multi-part names and prefixes
* - Create uppercase constants and identifiers
* - Format user input consistently
* - Handle acronyms and special cases
* - Mixed case scenario handling
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/StrLower.htm
* https://www.autohotkey.com/docs/v2/lib/StrUpper.htm
* https://www.autohotkey.com/docs/v2/lib/StrTitle.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Advanced string manipulation
* - StrReplace() for text processing
* - RegExReplace() for pattern matching
* - Custom formatting functions
* - Data structure operations
*
* LEARNING POINTS:
* 1. Title case isn't always perfect for names (e.g., "McDonald" vs "Mcdonald")
* 2. Constants should be UPPERCASE with underscores
* 3. User input needs normalization before processing
* 4. Acronyms should remain uppercase in titles
* 5. Some words should stay lowercase in titles (articles, prepositions)
*/

; ============================================================
; Example 1: Basic Name Formatting
; ============================================================

/**
* Format a person's name using title case
* Handles first name, middle name, and last name
*
* @param {String} fullName - Name in any case
* @returns {String} - Properly formatted name
*/
FormatPersonName(fullName) {
    ; Trim whitespace and convert to title case
    return StrTitle(Trim(fullName))
}

; Test with various name formats
nameInputs := [
"john doe",
"JANE MARIE SMITH",
"robert O'BRIEN",
"mary-ann wilson",
"DR. STEVEN ANDERSON"
]

output := "Name Formatting Examples:`n`n"
for name in nameInputs {
    formatted := FormatPersonName(name)
    output .= "Input:  " name "`n"
    . "Output: " formatted "`n`n"
}

MsgBox(output, "Basic Name Formatting", "Icon!")

; ============================================================
; Example 2: Enhanced Name Formatting with Special Cases
; ============================================================

/**
* Format name with special handling for common patterns
* Handles prefixes like Mc, Mac, O', Van, De, etc.
*
* @param {String} name - Name to format
* @returns {String} - Formatted name with special cases
*/
FormatNameAdvanced(name) {
    ; Start with title case
    formatted := StrTitle(Trim(name))

    ; Fix Scottish/Irish names: McDonald, O'Brien, etc.
    formatted := RegExReplace(formatted, "\bMac([a-z])", "Mac$U1")
    formatted := RegExReplace(formatted, "\bMc([a-z])", "Mc$U1")
    formatted := RegExReplace(formatted, "\bO'([a-z])", "O'$U1")

    ; Fix Dutch names: Van, De, etc.
    formatted := RegExReplace(formatted, "\b(Van|De|La|Le)\s+([a-z])", "$1 $U2")

    return formatted
}

; Test advanced name formatting
specialNames := [
"PATRICK MCDONALD",
"sean o'connor",
"VINCENT VAN GOGH",
"MARIA DE LA CRUZ",
"alexander mackenzie"
]

output := "Advanced Name Formatting:`n`n"
for name in specialNames {
    basic := StrTitle(name)
    advanced := FormatNameAdvanced(name)

    output .= "Original: " name "`n"
    . "Basic:    " basic "`n"
    . "Advanced: " advanced "`n`n"
}

MsgBox(output, "Special Case Handling", "Icon!")

; ============================================================
; Example 3: Creating Programming Constants
; ============================================================

/**
* Convert descriptive name to UPPER_SNAKE_CASE constant
* Used for creating constant identifiers in code
*
* @param {String} description - Human-readable description
* @returns {String} - UPPER_SNAKE_CASE constant name
*/
CreateConstantName(description) {
    ; Remove special characters, replace spaces with underscores
    constant := RegExReplace(description, "[^\w\s]", "")
    constant := StrReplace(constant, " ", "_")
    constant := StrReplace(constant, "-", "_")

    ; Remove multiple underscores
    while (InStr(constant, "__"))
    constant := StrReplace(constant, "__", "_")

    ; Convert to uppercase
    return StrUpper(Trim(constant, "_"))
}

; Test constant creation
descriptions := [
"Maximum File Size",
"Default Timeout Value",
"API Key Secret",
"User Session Duration",
"Database Connection String"
]

output := "Constant Name Generation:`n`n"
for desc in descriptions {
    constant := CreateConstantName(desc)
    output .= desc "`n"
    . "→ " constant "`n`n"
}

MsgBox(output, "Programming Constants", "Icon!")

; Example usage in code
MAX_RETRIES := 3
DEFAULT_TIMEOUT := 5000
API_BASE_URL := "https://api.example.com"

codeExample := "
(
Generated Constants in Use:

MAX_RETRIES := 3
DEFAULT_TIMEOUT := 5000
API_BASE_URL := 'https://api.example.com'

These constants follow naming conventions:
• All UPPERCASE
• Words separated by underscores
• Descriptive and clear
• Easy to identify as constants
)"

MsgBox(codeExample, "Constant Usage Example", "Icon!")

; ============================================================
; Example 4: Formatting User Input
; ============================================================

/**
* Clean and format user input for consistent processing
* Removes extra whitespace and normalizes case
*
* @param {String} input - Raw user input
* @param {String} format - "title", "lower", or "upper"
* @returns {String} - Cleaned and formatted input
*/
FormatUserInput(input, format := "title") {
    ; Remove leading/trailing whitespace
    cleaned := Trim(input)

    ; Replace multiple spaces with single space
    while (InStr(cleaned, "  "))
    cleaned := StrReplace(cleaned, "  ", " ")

    ; Apply case formatting
    if (format = "title")
    return StrTitle(cleaned)
    else if (format = "lower")
    return StrLower(cleaned)
    else if (format = "upper")
    return StrUpper(cleaned)
    else
    return cleaned
}

; Simulate user inputs with various issues
messyInputs := [
"  hello    world  ",
"MULTIPLE   SPACES    EVERYWHERE",
"  John   Doe  ",
"  product    NAME   ",
"  CaSeLesSLy   eNtErEd   "
]

output := "User Input Formatting:`n`n"
for input in messyInputs {
    titleCase := FormatUserInput(input, "title")
    lowerCase := FormatUserInput(input, "lower")

    output .= "Raw: '" input "'`n"
    . "Title: '" titleCase "'`n"
    . "Lower: '" lowerCase "'`n`n"
}

MsgBox(output, "Input Formatting", "Icon!")

; ============================================================
; Example 5: Title Case with Exceptions
; ============================================================

/**
* Format title with proper capitalization rules
* Keep articles and short prepositions lowercase unless first/last word
*
* @param {String} title - Title to format
* @returns {String} - Properly formatted title
*/
FormatProperTitle(title) {
    ; Words that should be lowercase in titles (unless first/last)
    lowercaseWords := ["a", "an", "the", "and", "but", "or", "for", "nor",
    "on", "at", "to", "from", "by", "in", "of", "with"]

    ; Split into words
    words := StrSplit(title, " ")
    formatted := []

    for index, word in words {
        if (word = "")
        continue

        ; First and last words always capitalized
        if (index = 1 || index = words.Length) {
            formatted.Push(StrTitle(word))
        }
        ; Check if word should be lowercase
        else {
            isLowercase := false
            for exception in lowercaseWords {
                if (StrLower(word) = exception) {
                    formatted.Push(StrLower(word))
                    isLowercase := true
                    break
                }
            }
            if (!isLowercase)
            formatted.Push(StrTitle(word))
        }
    }

    ; Join words back together
    result := ""
    for word in formatted
    result .= word " "

    return Trim(result)
}

; Test proper title formatting
titles := [
"the quick brown fox",
"A TALE OF TWO CITIES",
"gone with the wind",
"the lord of the rings",
"to kill a mockingbird",
"one hundred years of solitude"
]

output := "Proper Title Formatting:`n`n"
for title in titles {
    basic := StrTitle(title)
    proper := FormatProperTitle(title)

    output .= "Original: " title "`n"
    . "Basic:    " basic "`n"
    . "Proper:   " proper "`n`n"
}

MsgBox(output, "Title Case with Rules", "Icon!")

; ============================================================
; Example 6: Handling Acronyms in Text
; ============================================================

/**
* Format text while preserving known acronyms in uppercase
*
* @param {String} text - Text containing acronyms
* @param {Array} acronyms - Array of acronyms to preserve
* @returns {String} - Formatted text with preserved acronyms
*/
FormatWithAcronyms(text, acronyms := []) {
    ; Default common acronyms
    if (acronyms.Length = 0) {
        acronyms := ["USA", "UK", "CEO", "CTO", "API", "HTML", "CSS",
        "JSON", "XML", "HTTP", "HTTPS", "FTP", "SQL",
        "PDF", "NASA", "FBI", "CIA", "NATO"]
    }

    ; Start with title case
    formatted := StrTitle(text)

    ; Replace each acronym with uppercase version
    for acronym in acronyms {
        ; Match word boundaries to avoid partial matches
        pattern := "\b" StrTitle(acronym) "\b"
        formatted := RegExReplace(formatted, pattern, StrUpper(acronym))
    }

    return formatted
}

; Test acronym handling
textsWithAcronyms := [
"the usa and uk signed the agreement",
"john is the ceo of the company",
"send the data via the api using json format",
"nasa announced a new mission",
"export to pdf or html format"
]

output := "Acronym Preservation:`n`n"
for text in textsWithAcronyms {
    basic := StrTitle(text)
    withAcronyms := FormatWithAcronyms(text)

    output .= "Original: " text "`n"
    . "Basic:    " basic "`n"
    . "Acronyms: " withAcronyms "`n`n"
}

MsgBox(output, "Acronym Handling", "Icon!")

; ============================================================
; Example 7: Mixed Case Scenarios and Solutions
; ============================================================

/**
* Product name formatter that handles various naming conventions
*
* @param {String} productName - Product name in any format
* @param {String} style - "title", "upper", "lower", or "brand"
* @returns {String} - Formatted product name
*/
FormatProductName(productName, style := "brand") {
    switch style {
        case "title":
        ; Standard title case
        return StrTitle(productName)

        case "upper":
        ; All uppercase (for SKUs, IDs)
        return StrUpper(productName)

        case "lower":
        ; All lowercase (for URLs, tags)
        return StrLower(productName)

        case "brand":
        ; Brand style: Title case with preserved patterns
        formatted := StrTitle(productName)

        ; Common brand patterns
        formatted := RegExReplace(formatted, "\biPhone\b", "iPhone")
        formatted := RegExReplace(formatted, "\biPad\b", "iPad")
        formatted := RegExReplace(formatted, "\bMacBook\b", "MacBook")
        formatted := RegExReplace(formatted, "\bPlayStation\b", "PlayStation")
        formatted := RegExReplace(formatted, "\bXbox\b", "Xbox")

        return formatted

        default:
        return productName
    }
}

/**
* Display various formatting styles for product names
*/
ShowProductFormats() {
    products := [
    "IPHONE 15 PRO MAX",
    "macbook air m2",
    "PlayStation 5 Console",
    "microsoft XBOX series X"
    ]

    output := "Product Name Formatting Styles:`n`n"

    for product in products {
        output .= "Original: " product "`n"
        . "Title:    " FormatProductName(product, "title") "`n"
        . "Upper:    " FormatProductName(product, "upper") "`n"
        . "Lower:    " FormatProductName(product, "lower") "`n"
        . "Brand:    " FormatProductName(product, "brand") "`n`n"
    }

    MsgBox(output, "Product Formatting", "Icon!")
}

ShowProductFormats()

; ============================================================
; Practical Application: Form Data Formatter
; ============================================================

/**
* Format form data with appropriate case for each field type
*/
class FormDataFormatter {
    /**
    * Format contact form data
    *
    * @param {Object} data - Raw form data
    * @returns {Object} - Formatted form data
    */
    static FormatContactForm(data) {
        formatted := Map()

        ; Names: Title case
        if (data.Has("firstName"))
        formatted["firstName"] := StrTitle(Trim(data["firstName"]))
        if (data.Has("lastName"))
        formatted["lastName"] := StrTitle(Trim(data["lastName"]))

        ; Email: Lowercase
        if (data.Has("email"))
        formatted["email"] := StrLower(Trim(data["email"]))

        ; City/State: Title case
        if (data.Has("city"))
        formatted["city"] := StrTitle(Trim(data["city"]))
        if (data.Has("state"))
        formatted["state"] := StrUpper(Trim(data["state"]))

        ; Country code: Uppercase
        if (data.Has("country"))
        formatted["country"] := StrUpper(Trim(data["country"]))

        ; Comments: Preserve as-is but trim
        if (data.Has("comments"))
        formatted["comments"] := Trim(data["comments"])

        return formatted
    }
}

; Test form data formatting
rawFormData := Map(
"firstName", "  JOHN  ",
"lastName", "doe",
"email", "John.Doe@EXAMPLE.com",
"city", "new york",
"state", "ny",
"country", "usa",
"comments", "  Please contact me ASAP  "
)

formattedData := FormDataFormatter.FormatContactForm(rawFormData)

output := "Form Data Formatting:`n`n"
. "RAW DATA:`n"
. "First Name: '" rawFormData["firstName"] "'`n"
. "Last Name: '" rawFormData["lastName"] "'`n"
. "Email: '" rawFormData["email"] "'`n"
. "City: '" rawFormData["city"] "'`n"
. "State: '" rawFormData["state"] "'`n"
. "Country: '" rawFormData["country"] "'`n"
. "Comments: '" rawFormData["comments"] "'`n`n"
. "FORMATTED DATA:`n"
. "First Name: '" formattedData["firstName"] "'`n"
. "Last Name: '" formattedData["lastName"] "'`n"
. "Email: '" formattedData["email"] "'`n"
. "City: '" formattedData["city"] "'`n"
. "State: '" formattedData["state"] "'`n"
. "Country: '" formattedData["country"] "'`n"
. "Comments: '" formattedData["comments"] "'`n"

MsgBox(output, "Form Formatting Example", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
TEXT FORMATTING BEST PRACTICES:

PERSON NAMES:
• Use title case: John Smith
• Handle prefixes: McDonald, O'Brien
• Respect cultural names: Van Gogh, De La Cruz

CONSTANTS:
• Use UPPER_SNAKE_CASE
• All uppercase letters
• Underscores between words
• Example: MAX_CONNECTION_TIMEOUT

USER INPUT:
• Always trim whitespace
• Normalize multiple spaces
• Apply consistent casing
• Validate after formatting

TITLES:
• Capitalize first and last words
• Keep articles lowercase: the, a, an
• Keep prepositions lowercase: of, in, on
• Preserve acronyms: USA, API, HTML

ACRONYMS:
• Keep all uppercase: CEO, FBI, NASA
• Common in technical writing
• Preserve in title case text

PRODUCT NAMES:
• Follow brand guidelines
• Respect trademarked capitalization
• iPhone, iPad, PlayStation, Xbox

FORM DATA:
• Names: Title case
• Email: Lowercase
• State codes: Uppercase
• Country codes: Uppercase
• Comments: Preserve original

Common Patterns:
✓ Names → Title Case
✓ Email → lowercase
✓ Constants → UPPER_SNAKE_CASE
✓ URLs → lowercase
✓ Titles → Proper Title Case
✓ Acronyms → UPPERCASE
)"

MsgBox(info, "Text Formatting Reference", "Icon!")

; ============================================================
; Summary
; ============================================================

summary := "
(
TEXT FORMATTING SUMMARY:

Techniques Covered:
1. Basic name formatting with StrTitle()
2. Advanced name handling (Mc, O', Van, etc.)
3. Creating programming constants
4. User input normalization
5. Proper title case with exceptions
6. Acronym preservation in text
7. Mixed case scenarios and solutions
8. Form data formatting

Key Takeaways:
✓ Title case isn't one-size-fits-all
✓ Different data types need different formatting
✓ User input always needs cleaning
✓ Cultural and linguistic patterns matter
✓ Brand names have specific capitalization
✓ Constants follow programming conventions

Real-World Applications:
• Contact form processing
• Name display in applications
• Code constant generation
• Title and heading formatting
• Product catalog management
• User input validation

Next Steps:
• Explore data normalization techniques
• Learn case-insensitive comparison
• Practice with database operations
• See: BuiltIn_StrCase_03_DataNormalization.ahk
)"

MsgBox(summary, "Formatting Summary", "Icon!")
