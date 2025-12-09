#Requires AutoHotkey v2.0

/**
* BuiltIn_StrCase_03_DataNormalization.ahk
*
* DESCRIPTION:
* Advanced data normalization examples using case conversion functions
* for database operations, URL processing, case-insensitive comparison,
* and data consistency.
*
* FEATURES:
* - Normalize data for case-insensitive comparison
* - Generate database keys and identifiers
* - Create URL-safe slugs
* - Process tags and categories
* - Handle file naming conventions
* - Standardize data for storage
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/StrLower.htm
* https://www.autohotkey.com/docs/v2/lib/StrUpper.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Case-insensitive string operations
* - Data standardization techniques
* - Map objects for lookups
* - RegEx for text processing
* - Practical data handling
*
* LEARNING POINTS:
* 1. Lowercase is standard for case-insensitive comparison
* 2. Database keys should be normalized for consistency
* 3. URL slugs require lowercase and special character handling
* 4. Tags and categories benefit from normalization
* 5. File naming conventions prevent case-related issues
*/

; ============================================================
; Example 1: Case-Insensitive String Comparison
; ============================================================

/**
* Compare two strings ignoring case differences
*
* @param {String} str1 - First string
* @param {String} str2 - Second string
* @returns {Boolean} - True if strings match (case-insensitive)
*/
CompareIgnoreCase(str1, str2) {
    return StrLower(str1) = StrLower(str2)
}

/**
* Check if string exists in array (case-insensitive)
*
* @param {String} needle - String to find
* @param {Array} haystack - Array to search
* @returns {Boolean} - True if found
*/
InArrayIgnoreCase(needle, haystack) {
    normalizedNeedle := StrLower(needle)

    for item in haystack {
        if (StrLower(item) = normalizedNeedle)
        return true
    }

    return false
}

; Test case-insensitive comparison
testPairs := [
["Hello", "hello"],
["AutoHotkey", "AUTOHOTKEY"],
["Test123", "test123"],
["Case", "case"]
]

output := "Case-Insensitive Comparison:`n`n"
for pair in testPairs {
    result := CompareIgnoreCase(pair[1], pair[2]) ? "MATCH" : "NO MATCH"
    output .= "'" pair[1] "' vs '" pair[2] "' → " result "`n"
}

MsgBox(output, "String Comparison", "Icon!")

; Test array search
validUsers := ["Administrator", "JohnDoe", "JaneSmith", "BobJones"]

searchTests := ["administrator", "JOHNDOE", "janesmith", "alice"]

output := "Case-Insensitive Array Search:`n`n"
output .= "Valid Users: " StrJoin(validUsers, ", ") "`n`n"

for search in searchTests {
    found := InArrayIgnoreCase(search, validUsers) ? "FOUND" : "NOT FOUND"
    output .= "Search '" search "': " found "`n"
}

MsgBox(output, "Array Search", "Icon!")

; Helper function to join array elements
StrJoin(arr, delimiter := ", ") {
    result := ""
    for item in arr
    result .= item delimiter
    return SubStr(result, 1, -StrLen(delimiter))
}

; ============================================================
; Example 2: Database Key Generation
; ============================================================

/**
* Generate a normalized database key from text
* Keys are lowercase, alphanumeric with underscores
*
* @param {String} text - Input text
* @returns {String} - Normalized database key
*/
GenerateDatabaseKey(text) {
    ; Convert to lowercase
    key := StrLower(text)

    ; Replace spaces and hyphens with underscores
    key := StrReplace(key, " ", "_")
    key := StrReplace(key, "-", "_")

    ; Remove special characters (keep only alphanumeric and underscore)
    key := RegExReplace(key, "[^\w]", "")

    ; Remove multiple underscores
    while (InStr(key, "__"))
    key := StrReplace(key, "__", "_")

    ; Trim underscores from ends
    key := Trim(key, "_")

    return key
}

/**
* Create a unique identifier from name and ID
*
* @param {String} name - Record name
* @param {Integer} id - Record ID
* @returns {String} - Unique key
*/
CreateUniqueKey(name, id := 0) {
    baseKey := GenerateDatabaseKey(name)

    if (id > 0)
    return baseKey "_" id
    else
    return baseKey
}

; Test database key generation
testNames := [
"User Profile",
"Order History",
"Payment Method",
"Shipping Address",
"Product-Catalog",
"Customer#Reviews"
]

output := "Database Key Generation:`n`n"
for name in testNames {
    key := GenerateDatabaseKey(name)
    output .= "Name: '" name "'`n"
    . "Key:  '" key "'`n`n"
}

MsgBox(output, "Database Keys", "Icon!")

; Test unique key generation
output := "Unique Key Generation:`n`n"
sampleName := "User Account"

Loop 5 {
    key := CreateUniqueKey(sampleName, A_Index)
    output .= "Record " A_Index ": " key "`n"
}

MsgBox(output, "Unique Keys", "Icon!")

; ============================================================
; Example 3: URL Slug Generation
; ============================================================

/**
* Generate a URL-safe slug from text
* Slugs are lowercase with hyphens, no special characters
*
* @param {String} text - Input text (e.g., article title)
* @param {Integer} maxLength - Maximum slug length (0 = unlimited)
* @returns {String} - URL-safe slug
*/
GenerateUrlSlug(text, maxLength := 0) {
    ; Convert to lowercase
    slug := StrLower(text)

    ; Replace spaces with hyphens
    slug := StrReplace(slug, " ", "-")

    ; Replace multiple spaces/hyphens
    slug := RegExReplace(slug, "[\s-]+", "-")

    ; Remove special characters (keep alphanumeric and hyphens)
    slug := RegExReplace(slug, "[^a-z0-9-]", "")

    ; Remove multiple hyphens
    while (InStr(slug, "--"))
    slug := StrReplace(slug, "--", "-")

    ; Trim hyphens from ends
    slug := Trim(slug, "-")

    ; Apply length limit if specified
    if (maxLength > 0 && StrLen(slug) > maxLength) {
        slug := SubStr(slug, 1, maxLength)
        ; Make sure we don't end with a hyphen after truncation
        slug := Trim(slug, "-")
    }

    return slug
}

/**
* Create a complete URL from base and title
*
* @param {String} baseUrl - Base URL
* @param {String} title - Page title
* @returns {String} - Complete URL
*/
CreatePageUrl(baseUrl, title) {
    slug := GenerateUrlSlug(title)
    return baseUrl "/" slug
}

; Test URL slug generation
articleTitles := [
"10 Tips for Better Programming",
"How to Learn AutoHotkey v2 (Beginner's Guide)",
"Understanding Object-Oriented Programming!!!",
"What is Machine Learning? An Introduction",
"The Future of AI & Technology"
]

output := "URL Slug Generation:`n`n"
for title in articleTitles {
    slug := GenerateUrlSlug(title, 50)
    output .= "Title: " title "`n"
    . "Slug:  " slug "`n`n"
}

MsgBox(output, "URL Slugs", "Icon!")

; Test complete URL creation
baseUrl := "https://blog.example.com"

output := "Complete URL Generation:`n`n"
for title in articleTitles {
    url := CreatePageUrl(baseUrl, title)
    output .= url "`n"
}

MsgBox(output, "Complete URLs", "Icon!")

; ============================================================
; Example 4: Tag and Category Normalization
; ============================================================

/**
* Normalize tags for consistent storage and comparison
* Tags are lowercase, trimmed, and deduplicated
*
* @param {String} tagString - Comma-separated tags
* @returns {Array} - Normalized tag array
*/
NormalizeTags(tagString) {
    ; Split by comma
    tags := StrSplit(tagString, ",")
    normalized := []
    seen := Map()

    for tag in tags {
        ; Trim and convert to lowercase
        clean := StrLower(Trim(tag))

        ; Skip empty tags
        if (clean = "")
        continue

        ; Skip duplicates (case-insensitive)
        if (seen.Has(clean))
        continue

        normalized.Push(clean)
        seen[clean] := true
    }

    return normalized
}

/**
* Format tags for display
*
* @param {Array} tags - Array of normalized tags
* @returns {String} - Formatted tag string
*/
FormatTagsForDisplay(tags) {
    if (tags.Length = 0)
    return "(no tags)"

    result := ""
    for tag in tags
    result .= "#" tag " "

    return Trim(result)
}

; Test tag normalization
messyTags := [
"Programming, AutoHotkey, Scripting, PROGRAMMING",
"  web-dev , HTML , CSS,JavaScript, html  ",
"AI, Machine-Learning, ai, deep-learning",
"Tutorial, Guide, TUTORIAL, how-to"
]

output := "Tag Normalization:`n`n"
for tagString in messyTags {
    normalized := NormalizeTags(tagString)
    display := FormatTagsForDisplay(normalized)

    output .= "Input:  " tagString "`n"
    . "Output: " display "`n"
    . "Count:  " normalized.Length " unique tags`n`n"
}

MsgBox(output, "Tag Normalization", "Icon!")

; ============================================================
; Example 5: File Naming Normalization
; ============================================================

/**
* Generate a safe, normalized filename
* Lowercase, no spaces, no special characters
*
* @param {String} filename - Original filename
* @param {String} extension - File extension (optional)
* @returns {String} - Normalized filename
*/
NormalizeFilename(filename, extension := "") {
    ; Remove existing extension if present
    if (InStr(filename, ".")) {
        parts := StrSplit(filename, ".")
        filename := parts[1]
        if (extension = "" && parts.Length > 1)
        extension := parts[2]
    }

    ; Convert to lowercase
    normalized := StrLower(filename)

    ; Replace spaces with underscores
    normalized := StrReplace(normalized, " ", "_")

    ; Remove special characters (keep alphanumeric, underscore, hyphen)
    normalized := RegExReplace(normalized, "[^\w-]", "")

    ; Remove multiple underscores/hyphens
    while (InStr(normalized, "__"))
    normalized := StrReplace(normalized, "__", "_")
    while (InStr(normalized, "--"))
    normalized := StrReplace(normalized, "--", "-")

    ; Trim underscores/hyphens
    normalized := Trim(normalized, "_-")

    ; Add extension if provided
    if (extension != "")
    normalized .= "." StrLower(extension)

    return normalized
}

/**
* Batch normalize filenames
*
* @param {Array} filenames - Array of original filenames
* @returns {Map} - Map of original → normalized filenames
*/
BatchNormalizeFilenames(filenames) {
    result := Map()

    for filename in filenames {
        normalized := NormalizeFilename(filename)
        result[filename] := normalized
    }

    return result
}

; Test filename normalization
messyFilenames := [
"My Document.txt",
"Photo #123 (Final Version).jpg",
"Project Proposal - Draft 2.docx",
"Screenshot 2024-01-15 at 10.30.45 AM.png",
"User's Report (FINAL) v2.pdf"
]

output := "Filename Normalization:`n`n"
for filename in messyFilenames {
    normalized := NormalizeFilename(filename)
    output .= "Original:   " filename "`n"
    . "Normalized: " normalized "`n`n"
}

MsgBox(output, "File Naming", "Icon!")

; ============================================================
; Example 6: Data Lookup with Case Normalization
; ============================================================

/**
* Case-insensitive lookup table
* All keys are normalized to lowercase for consistent access
*/
class NormalizedMap {
    __New() {
        this.data := Map()
    }

    /**
    * Set a key-value pair (key is normalized)
    *
    * @param {String} key - Lookup key
    * @param {Any} value - Value to store
    */
    Set(key, value) {
        normalizedKey := StrLower(key)
        this.data[normalizedKey] := value
    }

    /**
    * Get a value by key (case-insensitive)
    *
    * @param {String} key - Lookup key
    * @param {Any} default - Default value if not found
    * @returns {Any} - Stored value or default
    */
    Get(key, default := "") {
        normalizedKey := StrLower(key)
        return this.data.Has(normalizedKey) ? this.data[normalizedKey] : default
    }

    /**
    * Check if key exists (case-insensitive)
    *
    * @param {String} key - Lookup key
    * @returns {Boolean} - True if exists
    */
    Has(key) {
        normalizedKey := StrLower(key)
        return this.data.Has(normalizedKey)
    }

    /**
    * Delete a key (case-insensitive)
    *
    * @param {String} key - Key to delete
    * @returns {Boolean} - True if deleted
    */
    Delete(key) {
        normalizedKey := StrLower(key)
        if (this.data.Has(normalizedKey)) {
            this.data.Delete(normalizedKey)
            return true
        }
        return false
    }
}

; Test normalized map
userRoles := NormalizedMap()

; Add data with various cases
userRoles.Set("Administrator", "Full Access")
userRoles.Set("EDITOR", "Edit Content")
userRoles.Set("viewer", "View Only")
userRoles.Set("Guest", "Limited Access")

; Test case-insensitive lookups
lookupTests := ["administrator", "ADMINISTRATOR", "Editor", "VIEWER", "guest"]

output := "Case-Insensitive Lookup:`n`n"
for lookup in lookupTests {
    role := userRoles.Get(lookup, "Not Found")
    output .= "Lookup '" lookup "': " role "`n"
}

MsgBox(output, "Normalized Map", "Icon!")

; ============================================================
; Example 7: Configuration Data Normalization
; ============================================================

/**
* Normalize configuration keys for consistent access
* Handles environment variables, config files, etc.
*/
class ConfigNormalizer {
    /**
    * Normalize a configuration key
    * Converts to lowercase with underscores
    *
    * @param {String} key - Configuration key
    * @returns {String} - Normalized key
    */
    static NormalizeKey(key) {
        ; Convert to lowercase
        normalized := StrLower(key)

        ; Replace various separators with underscores
        normalized := StrReplace(normalized, "-", "_")
        normalized := StrReplace(normalized, ".", "_")
        normalized := StrReplace(normalized, " ", "_")

        ; Remove special characters
        normalized := RegExReplace(normalized, "[^\w]", "_")

        ; Remove multiple underscores
        while (InStr(normalized, "__"))
        normalized := StrReplace(normalized, "__", "_")

        ; Trim underscores
        normalized := Trim(normalized, "_")

        return normalized
    }

    /**
    * Normalize an entire configuration object
    *
    * @param {Map} config - Configuration map
    * @returns {Map} - Normalized configuration
    */
    static NormalizeConfig(config) {
        normalized := Map()

        for key, value in config {
            normalizedKey := this.NormalizeKey(key)
            normalized[normalizedKey] := value
        }

        return normalized
    }
}

; Test configuration normalization
rawConfig := Map(
"Database-Host", "localhost",
"DATABASE.PORT", "5432",
"database user", "admin",
"Database_Password", "secret123",
"max-connections", "100",
"TIMEOUT.VALUE", "30"
)

output := "Configuration Key Normalization:`n`n"
output .= "BEFORE NORMALIZATION:`n"

for key, value in rawConfig {
    output .= "  " key " = " value "`n"
}

normalizedConfig := ConfigNormalizer.NormalizeConfig(rawConfig)

output .= "`nAFTER NORMALIZATION:`n"

for key, value in normalizedConfig {
    output .= "  " key " = " value "`n"
}

MsgBox(output, "Config Normalization", "Icon!")

; Demonstrate consistent access
output := "Consistent Configuration Access:`n`n"
output .= "All these refer to the same value:`n`n"

accessMethods := [
"database_host",
"DATABASE_HOST",
"database-host",
"Database.Host"
]

for method in accessMethods {
    normalized := ConfigNormalizer.NormalizeKey(method)
    value := normalizedConfig.Get(normalized, "Not Found")
    output .= "Access '" method "' → " value "`n"
}

MsgBox(output, "Consistent Access", "Icon!")

; ============================================================
; Practical Example: User Authentication System
; ============================================================

/**
* Simple user authentication with normalized usernames
*/
class UserAuth {
    __New() {
        this.users := Map()
    }

    /**
    * Register a new user (username normalized to lowercase)
    *
    * @param {String} username - Username
    * @param {String} password - Password (would be hashed in production)
    * @returns {Boolean} - True if registered successfully
    */
    Register(username, password) {
        normalizedUsername := StrLower(Trim(username))

        if (normalizedUsername = "")
        return false

        if (this.users.Has(normalizedUsername))
        return false

        this.users[normalizedUsername] := password
        return true
    }

    /**
    * Authenticate user (case-insensitive username)
    *
    * @param {String} username - Username
    * @param {String} password - Password
    * @returns {Boolean} - True if authenticated
    */
    Authenticate(username, password) {
        normalizedUsername := StrLower(Trim(username))

        if (!this.users.Has(normalizedUsername))
        return false

        return this.users[normalizedUsername] = password
    }

    /**
    * Check if username exists (case-insensitive)
    *
    * @param {String} username - Username to check
    * @returns {Boolean} - True if exists
    */
    UserExists(username) {
        normalizedUsername := StrLower(Trim(username))
        return this.users.Has(normalizedUsername)
    }
}

; Test user authentication system
auth := UserAuth()

; Register users with various cases
auth.Register("JohnDoe", "password123")
auth.Register("ADMIN", "admin456")
auth.Register("jane_smith", "jane789")

; Test authentication with different cases
authTests := [
["johndoe", "password123", "Should succeed"],
["JOHNDOE", "password123", "Should succeed (different case)"],
["Admin", "admin456", "Should succeed"],
["admin", "wrong", "Should fail (wrong password)"],
["jane_smith", "jane789", "Should succeed"],
["unknown", "password", "Should fail (user doesn't exist)"]
]

output := "User Authentication Testing:`n`n"

for test in authTests {
    username := test[1]
    password := test[2]
    description := test[3]

    result := auth.Authenticate(username, password)
    status := result ? "✓ SUCCESS" : "✗ FAILED"

    output .= status " - " username "`n"
    . "  " description "`n`n"
}

MsgBox(output, "Authentication Test", "Icon!")

; Test username existence
existTests := ["johndoe", "ADMIN", "Jane_Smith", "UNKNOWN"]

output := "Username Existence Check:`n`n"
for username in existTests {
    exists := auth.UserExists(username)
    status := exists ? "EXISTS" : "NOT FOUND"
    output .= "'" username "': " status "`n"
}

MsgBox(output, "User Existence", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
DATA NORMALIZATION REFERENCE:

CASE-INSENSITIVE COMPARISON:
• Always normalize to lowercase first
• Compare normalized versions
• Prevents case-related bugs
Example: StrLower(str1) = StrLower(str2)

DATABASE KEYS:
• Use lowercase with underscores
• Remove special characters
• Examples:
'User Profile' → user_profile
'Order #123' → order_123

URL SLUGS:
• Lowercase with hyphens
• No special characters
• SEO-friendly
Examples:
'Hello World!' → hello-world
'10 Tips & Tricks' → 10-tips-tricks

TAGS/CATEGORIES:
• Normalize to lowercase
• Remove duplicates (case-insensitive)
• Trim whitespace
• Store in consistent format

FILE NAMING:
• Lowercase recommended
• Use underscores or hyphens
• No spaces or special characters
• Prevents cross-platform issues

CONFIGURATION KEYS:
• lowercase_with_underscores
• Consistent separator (underscore)
• Easy to reference in code

USERNAMES/EMAIL:
• Store as lowercase
• Compare case-insensitively
• Prevents duplicate accounts
Example: 'John@Email.com' → 'john@email.com'

Best Practices:
✓ Normalize at input time
✓ Store normalized version
✓ Display original if needed (keep both)
✓ Be consistent across application
✓ Document normalization rules
✓ Test edge cases

Common Pitfalls:
✗ Forgetting to normalize before comparison
✗ Inconsistent normalization rules
✗ Not trimming whitespace
✗ Case-sensitive databases without normalization
✗ Assuming user input is already normalized

Performance Tips:
• Normalize once, use many times
• Cache normalized values
• Use indexed normalized fields in databases
• Consider locale-specific rules for international text
)"

MsgBox(info, "Normalization Reference", "Icon!")

; ============================================================
; Summary
; ============================================================

summary := "
(
DATA NORMALIZATION SUMMARY:

Topics Covered:
1. Case-insensitive string comparison
2. Database key generation
3. URL slug creation
4. Tag and category normalization
5. File naming conventions
6. Case-insensitive lookup structures
7. Configuration data normalization
8. User authentication with normalized data

Key Techniques:
✓ Use StrLower() for normalization
✓ Remove/replace special characters
✓ Standardize separators (_, -)
✓ Trim whitespace consistently
✓ Handle duplicates case-insensitively
✓ Create helper classes for consistency

Real-World Applications:
• User authentication systems
• Database operations
• URL generation for web apps
• File management systems
• Configuration management
• Tag/category systems
• Search functionality
• Data imports/exports

Benefits of Normalization:
• Prevents duplicate entries
• Enables case-insensitive search
• Improves data consistency
• Reduces errors
• Simplifies comparison logic
• Better user experience

Complete Series:
1. BuiltIn_StrCase_01_BasicConversions.ahk
2. BuiltIn_StrCase_02_TextFormatting.ahk
3. BuiltIn_StrCase_03_DataNormalization.ahk ← You are here

You now have comprehensive knowledge of:
• Basic case conversion (StrLower, StrUpper, StrTitle)
• Text formatting for display
• Data normalization for storage and comparison
)"

MsgBox(summary, "Data Normalization Summary", "Icon!")
