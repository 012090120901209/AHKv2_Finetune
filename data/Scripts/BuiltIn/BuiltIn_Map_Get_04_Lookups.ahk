#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Get_04_Lookups.ahk
 * 
 * @description Dictionary lookup patterns using Map.Get()
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 * 
 * @overview
 * Demonstrates using Maps for dictionary lookups, translation tables,
 * code mappings, lookup tables, and reference data access.
 */

;=============================================================================
; Example 1: Translation Dictionary
;=============================================================================

/**
 * @class Translator
 * @description Multi-language translation system
 */
class Translator {
    translations := Map()
    currentLang := "en"

    __New() {
        this.InitializeTranslations()
    }

    InitializeTranslations() {
        ; English
        this.translations.Set("en", Map(
            "hello", "Hello",
            "goodbye", "Goodbye",
            "yes", "Yes",
            "no", "No",
            "thank_you", "Thank you",
            "welcome", "Welcome",
            "error", "Error",
            "success", "Success"
        ))

        ; Spanish
        this.translations.Set("es", Map(
            "hello", "Hola",
            "goodbye", "Adiós",
            "yes", "Sí",
            "no", "No",
            "thank_you", "Gracias",
            "welcome", "Bienvenido",
            "error", "Error",
            "success", "Éxito"
        ))

        ; French
        this.translations.Set("fr", Map(
            "hello", "Bonjour",
            "goodbye", "Au revoir",
            "yes", "Oui",
            "no", "Non",
            "thank_you", "Merci",
            "welcome", "Bienvenue",
            "error", "Erreur",
            "success", "Succès"
        ))

        ; German
        this.translations.Set("de", Map(
            "hello", "Hallo",
            "goodbye", "Auf Wiedersehen",
            "yes", "Ja",
            "no", "Nein",
            "thank_you", "Danke",
            "welcome", "Willkommen",
            "error", "Fehler",
            "success", "Erfolg"
        ))
    }

    /**
     * @method Translate
     * @description Get translation for current language
     */
    Translate(key, fallback := "") {
        if (!this.translations.Has(this.currentLang))
            return fallback != "" ? fallback : key

        langMap := this.translations.Get(this.currentLang)
        return langMap.Get(key, fallback != "" ? fallback : key)
    }

    /**
     * @method SetLanguage
     * @description Set current language
     */
    SetLanguage(lang) {
        this.currentLang := lang
    }

    /**
     * @method GetAvailableLanguages
     * @description Get list of available languages
     */
    GetAvailableLanguages() {
        langs := []
        for lang in this.translations {
            langs.Push(lang)
        }
        return langs
    }
}

Example1_Translation() {
    t := Translator()

    output := "=== Translation Dictionary Example ===`n`n"

    languages := ["en", "es", "fr", "de"]
    keys := ["hello", "goodbye", "thank_you"]

    for lang in languages {
        t.SetLanguage(lang)
        output .= StrUpper(lang) ":`n"

        for key in keys {
            output .= "  " t.Translate(key) "`n"
        }
        output .= "`n"
    }

    MsgBox(output, "Translation")
}

;=============================================================================
; Example 2: Error Code Lookup
;=============================================================================

/**
 * @class ErrorCodeLookup
 * @description Error code to message mapping
 */
class ErrorCodeLookup {
    errorMessages := Map()
    errorSeverity := Map()

    __New() {
        this.InitializeErrors()
    }

    InitializeErrors() {
        ; Define error messages
        this.errorMessages.Set(1001, "File not found")
        this.errorMessages.Set(1002, "Permission denied")
        this.errorMessages.Set(1003, "Invalid file format")
        this.errorMessages.Set(2001, "Network timeout")
        this.errorMessages.Set(2002, "Connection refused")
        this.errorMessages.Set(2003, "DNS resolution failed")
        this.errorMessages.Set(3001, "Invalid credentials")
        this.errorMessages.Set(3002, "Session expired")
        this.errorMessages.Set(3003, "Insufficient permissions")
        this.errorMessages.Set(4001, "Database connection failed")
        this.errorMessages.Set(4002, "Query execution error")

        ; Define severity levels
        this.errorSeverity.Set(1001, "Warning")
        this.errorSeverity.Set(1002, "Error")
        this.errorSeverity.Set(1003, "Error")
        this.errorSeverity.Set(2001, "Warning")
        this.errorSeverity.Set(2002, "Error")
        this.errorSeverity.Set(2003, "Error")
        this.errorSeverity.Set(3001, "Error")
        this.errorSeverity.Set(3002, "Warning")
        this.errorSeverity.Set(3003, "Error")
        this.errorSeverity.Set(4001, "Critical")
        this.errorSeverity.Set(4002, "Critical")
    }

    /**
     * @method GetMessage
     * @description Get error message by code
     */
    GetMessage(errorCode) {
        return this.errorMessages.Get(errorCode, "Unknown error (Code: " errorCode ")")
    }

    /**
     * @method GetSeverity
     * @description Get error severity
     */
    GetSeverity(errorCode) {
        return this.errorSeverity.Get(errorCode, "Unknown")
    }

    /**
     * @method FormatError
     * @description Format complete error message
     */
    FormatError(errorCode) {
        return "[" this.GetSeverity(errorCode) "] Error "
            . errorCode ": " this.GetMessage(errorCode)
    }

    /**
     * @method GetErrorsByCategory
     * @description Get errors by category (first digit)
     */
    GetErrorsByCategory(category) {
        results := []

        for code, message in this.errorMessages {
            if (Integer(code / 1000) = category) {
                results.Push({ code: code, message: message })
            }
        }

        return results
    }
}

Example2_ErrorCodeLookup() {
    lookup := ErrorCodeLookup()

    output := "=== Error Code Lookup Example ===`n`n"

    ; Lookup individual errors
    testCodes := [1001, 2002, 3001, 4001, 9999]

    output .= "Error lookups:`n"
    for code in testCodes {
        output .= lookup.FormatError(code) "`n"
    }
    output .= "`n"

    ; Get by category
    fileErrors := lookup.GetErrorsByCategory(1)
    output .= "File errors (1xxx):`n"
    for err in fileErrors {
        output .= "  " err.code ": " err.message "`n"
    }

    MsgBox(output, "Error Code Lookup")
}

;=============================================================================
; Example 3: HTTP Status Code Lookup
;=============================================================================

/**
 * @class HTTPStatusCodes
 * @description HTTP status code reference
 */
class HTTPStatusCodes {
    static codes := Map(
        200, "OK",
        201, "Created",
        204, "No Content",
        301, "Moved Permanently",
        302, "Found",
        304, "Not Modified",
        400, "Bad Request",
        401, "Unauthorized",
        403, "Forbidden",
        404, "Not Found",
        405, "Method Not Allowed",
        408, "Request Timeout",
        429, "Too Many Requests",
        500, "Internal Server Error",
        502, "Bad Gateway",
        503, "Service Unavailable",
        504, "Gateway Timeout"
    )

    /**
     * @method GetStatus
     * @description Get status message
     */
    static GetStatus(code) {
        return this.codes.Get(code, "Unknown Status")
    }

    /**
     * @method GetStatusType
     * @description Get status type category
     */
    static GetStatusType(code) {
        category := Integer(code / 100)

        types := Map(
            1, "Informational",
            2, "Success",
            3, "Redirection",
            4, "Client Error",
            5, "Server Error"
        )

        return types.Get(category, "Unknown")
    }

    /**
     * @method IsSuccess
     * @description Check if status is success (2xx)
     */
    static IsSuccess(code) {
        return code >= 200 && code < 300
    }

    /**
     * @method IsError
     * @description Check if status is error (4xx or 5xx)
     */
    static IsError(code) {
        return code >= 400
    }
}

Example3_HTTPStatusLookup() {
    output := "=== HTTP Status Code Lookup ===`n`n"

    testCodes := [200, 201, 301, 404, 500, 999]

    for code in testCodes {
        output .= code " - " HTTPStatusCodes.GetStatus(code)
        output .= " (" HTTPStatusCodes.GetStatusType(code) ")"
        output .= " - " (HTTPStatusCodes.IsSuccess(code) ? "Success" :
            HTTPStatusCodes.IsError(code) ? "Error" : "Other")
        output .= "`n"
    }

    MsgBox(output, "HTTP Status Lookup")
}

;=============================================================================
; Example 4: Country/Currency Code Lookup
;=============================================================================

/**
 * @class CountryData
 * @description Country and currency reference data
 */
class CountryData {
    countries := Map()

    __New() {
        this.InitializeData()
    }

    InitializeData() {
        this.countries.Set("US", { name: "United States", currency: "USD", symbol: "$", code: "+1" })
        this.countries.Set("GB", { name: "United Kingdom", currency: "GBP", symbol: "£", code: "+44" })
        this.countries.Set("JP", { name: "Japan", currency: "JPY", symbol: "¥", code: "+81" })
        this.countries.Set("DE", { name: "Germany", currency: "EUR", symbol: "€", code: "+49" })
        this.countries.Set("FR", { name: "France", currency: "EUR", symbol: "€", code: "+33" })
        this.countries.Set("CN", { name: "China", currency: "CNY", symbol: "¥", code: "+86" })
        this.countries.Set("BR", { name: "Brazil", currency: "BRL", symbol: "R$", code: "+55" })
        this.countries.Set("IN", { name: "India", currency: "INR", symbol: "₹", code: "+91" })
        this.countries.Set("AU", { name: "Australia", currency: "AUD", symbol: "$", code: "+61" })
        this.countries.Set("CA", { name: "Canada", currency: "CAD", symbol: "$", code: "+1" })
    }

    /**
     * @method GetCountryName
     * @description Get country name by code
     */
    GetCountryName(code) {
        country := this.countries.Get(code, "")
        return country != "" ? country.name : "Unknown"
    }

    /**
     * @method GetCurrency
     * @description Get currency code
     */
    GetCurrency(code) {
        country := this.countries.Get(code, "")
        return country != "" ? country.currency : ""
    }

    /**
     * @method GetCurrencySymbol
     * @description Get currency symbol
     */
    GetCurrencySymbol(code) {
        country := this.countries.Get(code, "")
        return country != "" ? country.symbol : "$"
    }

    /**
     * @method FormatPrice
     * @description Format price for country
     */
    FormatPrice(code, amount) {
        symbol := this.GetCurrencySymbol(code)
        currency := this.GetCurrency(code)

        return symbol . FormatNumber(amount) . " " . currency
    }
}

FormatNumber(num) {
    return Format("{:.2f}", num)
}

Example4_CountryLookup() {
    data := CountryData()

    output := "=== Country/Currency Lookup ===`n`n"

    testCodes := ["US", "GB", "JP", "DE", "BR"]

    for code in testCodes {
        output .= code ": " data.GetCountryName(code)
        output .= " - " data.FormatPrice(code, 99.99)
        output .= "`n"
    }

    MsgBox(output, "Country Lookup")
}

;=============================================================================
; Example 5: Keyboard Shortcut Lookup
;=============================================================================

/**
 * @class ShortcutRegistry
 * @description Keyboard shortcut reference
 */
class ShortcutRegistry {
    shortcuts := Map()
    reverseMap := Map()  ; Action -> Shortcut

    __New() {
        this.RegisterDefaults()
    }

    RegisterDefaults() {
        this.Register("^s", "Save")
        this.Register("^o", "Open")
        this.Register("^n", "New")
        this.Register("^z", "Undo")
        this.Register("^y", "Redo")
        this.Register("^c", "Copy")
        this.Register("^v", "Paste")
        this.Register("^x", "Cut")
        this.Register("^a", "Select All")
        this.Register("^f", "Find")
        this.Register("^h", "Replace")
        this.Register("^p", "Print")
    }

    /**
     * @method Register
     * @description Register shortcut
     */
    Register(shortcut, action) {
        this.shortcuts.Set(shortcut, action)
        this.reverseMap.Set(action, shortcut)
    }

    /**
     * @method GetAction
     * @description Get action for shortcut
     */
    GetAction(shortcut) {
        return this.shortcuts.Get(shortcut, "Unassigned")
    }

    /**
     * @method GetShortcut
     * @description Get shortcut for action
     */
    GetShortcut(action) {
        return this.reverseMap.Get(action, "No shortcut")
    }

    /**
     * @method FormatShortcut
     * @description Format shortcut for display
     */
    FormatShortcut(shortcut) {
        display := StrReplace(shortcut, "^", "Ctrl+")
        display := StrReplace(display, "!", "Alt+")
        display := StrReplace(display, "+", "Shift+")
        display := StrReplace(display, "#", "Win+")
        return display
    }

    /**
     * @method ListAll
     * @description List all shortcuts
     */
    ListAll() {
        output := "Registered shortcuts:`n`n"

        for shortcut, action in this.shortcuts {
            output .= this.FormatShortcut(shortcut) . " - " . action . "`n"
        }

        return output
    }
}

Example5_ShortcutLookup() {
    registry := ShortcutRegistry()

    output := "=== Keyboard Shortcut Lookup ===`n`n"

    ; Lookup by shortcut
    output .= "Shortcut lookups:`n"
    output .= "Ctrl+S: " registry.GetAction("^s") "`n"
    output .= "Ctrl+C: " registry.GetAction("^c") "`n"
    output .= "Ctrl+F: " registry.GetAction("^f") "`n`n"

    ; Lookup by action
    output .= "Action lookups:`n"
    output .= "Save: " registry.FormatShortcut(registry.GetShortcut("Save")) "`n"
    output .= "Copy: " registry.FormatShortcut(registry.GetShortcut("Copy")) "`n"
    output .= "Find: " registry.FormatShortcut(registry.GetShortcut("Find")) "`n"

    MsgBox(output, "Shortcut Lookup")
}

;=============================================================================
; Example 6: MIME Type Lookup
;=============================================================================

/**
 * @class MIMETypes
 * @description File extension to MIME type mapping
 */
class MIMETypes {
    static types := Map(
        "txt", "text/plain",
        "html", "text/html",
        "htm", "text/html",
        "css", "text/css",
        "js", "text/javascript",
        "json", "application/json",
        "xml", "application/xml",
        "pdf", "application/pdf",
        "zip", "application/zip",
        "jpg", "image/jpeg",
        "jpeg", "image/jpeg",
        "png", "image/png",
        "gif", "image/gif",
        "svg", "image/svg+xml",
        "mp3", "audio/mpeg",
        "mp4", "video/mp4",
        "avi", "video/x-msvideo",
        "doc", "application/msword",
        "docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "xls", "application/vnd.ms-excel",
        "xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

    /**
     * @method GetMIMEType
     * @description Get MIME type for extension
     */
    static GetMIMEType(extension) {
        ; Remove leading dot if present
        ext := LTrim(extension, ".")
        ext := StrLower(ext)

        return this.types.Get(ext, "application/octet-stream")
    }

    /**
     * @method GetMIMETypeFromFilename
     * @description Get MIME type from filename
     */
    static GetMIMETypeFromFilename(filename) {
        ; Extract extension
        pos := InStrRev(filename, ".")
        if (pos = 0)
            return "application/octet-stream"

        ext := SubStr(filename, pos + 1)
        return this.GetMIMEType(ext)
    }

    /**
     * @method GetCategory
     * @description Get MIME category (text, image, etc.)
     */
    static GetCategory(mimeType) {
        pos := InStr(mimeType, "/")
        return pos > 0 ? SubStr(mimeType, 1, pos - 1) : "unknown"
    }
}

InStrRev(haystack, needle) {
    pos := 0
    lastPos := 0

    Loop {
        pos := InStr(haystack, needle, , pos + 1)
        if (pos = 0)
            break
        lastPos := pos
    }

    return lastPos
}

Example6_MIMETypeLookup() {
    output := "=== MIME Type Lookup ===`n`n"

    testFiles := ["document.pdf", "image.jpg", "style.css", "data.json", "video.mp4", "unknown.xyz"]

    for filename in testFiles {
        mimeType := MIMETypes.GetMIMETypeFromFilename(filename)
        category := MIMETypes.GetCategory(mimeType)

        output .= filename "`n"
        output .= "  Type: " mimeType "`n"
        output .= "  Category: " category "`n`n"
    }

    MsgBox(output, "MIME Type Lookup")
}

;=============================================================================
; Example 7: Configuration Lookup Table
;=============================================================================

/**
 * @class ConfigLookup
 * @description Multi-environment configuration lookup
 */
class ConfigLookup {
    configs := Map()

    __New() {
        this.InitializeConfigs()
    }

    InitializeConfigs() {
        ; Development
        this.configs.Set("dev", Map(
            "db.host", "localhost",
            "db.port", 3306,
            "api.url", "http://localhost:3000",
            "debug", true,
            "cache", false,
            "log.level", "debug"
        ))

        ; Staging
        this.configs.Set("staging", Map(
            "db.host", "staging-db.example.com",
            "db.port", 3306,
            "api.url", "https://staging.example.com",
            "debug", true,
            "cache", true,
            "log.level", "info"
        ))

        ; Production
        this.configs.Set("prod", Map(
            "db.host", "prod-db.example.com",
            "db.port", 3306,
            "api.url", "https://api.example.com",
            "debug", false,
            "cache", true,
            "log.level", "error"
        ))
    }

    /**
     * @method Get
     * @description Get config value for environment
     */
    Get(environment, key, defaultValue := "") {
        if (!this.configs.Has(environment))
            return defaultValue

        envConfig := this.configs.Get(environment)
        return envConfig.Get(key, defaultValue)
    }

    /**
     * @method CompareEnvs
     * @description Compare config across environments
     */
    CompareEnvs(key) {
        output := "Config key '" key "':`n`n"

        for env in ["dev", "staging", "prod"] {
            value := this.Get(env, key, "(not set)")
            output .= env ": " value "`n"
        }

        return output
    }
}

Example7_ConfigLookup() {
    lookup := ConfigLookup()

    output := "=== Configuration Lookup ===`n`n"

    output .= "Development environment:`n"
    output .= "  DB Host: " lookup.Get("dev", "db.host") "`n"
    output .= "  API URL: " lookup.Get("dev", "api.url") "`n"
    output .= "  Debug: " (lookup.Get("dev", "debug") ? "On" : "Off") "`n`n"

    output .= lookup.CompareEnvs("cache")

    MsgBox(output, "Config Lookup")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Get() - Dictionary Lookups Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Dictionary Lookup Patterns")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Translation")
        .OnEvent("Click", (*) => Example1_Translation())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Error Codes")
        .OnEvent("Click", (*) => Example2_ErrorCodeLookup())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: HTTP Status")
        .OnEvent("Click", (*) => Example3_HTTPStatusLookup())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Country Data")
        .OnEvent("Click", (*) => Example4_CountryLookup())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Shortcuts")
        .OnEvent("Click", (*) => Example5_ShortcutLookup())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: MIME Types")
        .OnEvent("Click", (*) => Example6_MIMETypeLookup())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Config Lookup")
        .OnEvent("Click", (*) => Example7_ConfigLookup())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_Translation()
        Example2_ErrorCodeLookup()
        Example3_HTTPStatusLookup()
        Example4_CountryLookup()
        Example5_ShortcutLookup()
        Example6_MIMETypeLookup()
        Example7_ConfigLookup()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
