#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Get_02_DefaultValues.ahk
 *
 * @description Map.Get() with default value handling patterns
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 *
 * @overview
 * Advanced patterns for using default values with Map.Get(), including
 * fallback chains, type coercion, lazy evaluation, and configuration defaults.
 */

;=============================================================================
; Example 1: Multi-Level Default Fallback
;=============================================================================

/**
 * @class FallbackConfig
 * @description Configuration with multiple fallback levels
 */
class FallbackConfig {
    user := Map()
    system := Map()
    defaults := Map()

    __New() {
        ; System defaults
        this.system.Set("theme", "system")
        this.system.Set("fontSize", 12)
        this.system.Set("language", "en")

        ; Application defaults
        this.defaults.Set("theme", "light")
        this.defaults.Set("fontSize", 14)
        this.defaults.Set("language", "en-US")
        this.defaults.Set("autoSave", true)
        this.defaults.Set("maxHistory", 50)
    }

    /**
     * @method Get
     * @description Get value with fallback chain: user -> system -> defaults
     */
    Get(key) {
        if (this.user.Has(key))
            return this.user.Get(key)

        if (this.system.Has(key))
            return this.system.Get(key)

        return this.defaults.Get(key, "")
    }

    /**
     * @method SetUser
     * @description Set user-level preference
     */
    SetUser(key, value) {
        this.user.Set(key, value)
    }

    /**
     * @method SetSystem
     * @description Set system-level configuration
     */
    SetSystem(key, value) {
        this.system.Set(key, value)
    }

    /**
     * @method ShowHierarchy
     * @description Display configuration hierarchy
     */
    ShowHierarchy(key) {
        output := "Configuration for '" key "':`n`n"
        output .= "User: " (this.user.Has(key) ? this.user.Get(key) : "(not set)") "`n"
        output .= "System: " (this.system.Has(key) ? this.system.Get(key) : "(not set)") "`n"
        output .= "Default: " this.defaults.Get(key, "(not set)") "`n`n"
        output .= "Final value: " this.Get(key)

        return output
    }
}

Example1_FallbackChain() {
    config := FallbackConfig()

    output := "=== Multi-Level Fallback Example ===`n`n"

    ; Show theme resolution
    output .= config.ShowHierarchy("theme") "`n`n---`n`n"

    ; Set user preference
    config.SetUser("theme", "dark")
    output .= "After setting user theme to 'dark':`n"
    output .= config.ShowHierarchy("theme")

    MsgBox(output, "Fallback Chain")
}

;=============================================================================
; Example 2: Type-Safe Defaults
;=============================================================================

/**
 * @class TypeSafeMap
 * @description Map with type-safe default values
 */
class TypeSafeMap {
    data := Map()
    typeDefaults := Map(
        "String", "",
        "Integer", 0,
        "Float", 0.0,
        "Array", () => [],
        "Map", () => Map(),
        "Boolean", false
    )

    /**
     * @method GetTyped
     * @description Get value with type-appropriate default
     */
    GetTyped(key, expectedType) {
        if (this.data.Has(key))
            return this.data.Get(key)

        if (this.typeDefaults.Has(expectedType)) {
            defaultValue := this.typeDefaults.Get(expectedType)

            ; Call function if it's a function (for complex types)
            if (Type(defaultValue) = "Func")
                return defaultValue.Call()

            return defaultValue
        }

        return ""
    }

    /**
     * @method Set
     * @description Store value
     */
    Set(key, value) {
        this.data.Set(key, value)
    }

    /**
     * @method GetString
     * @description Get as string with default
     */
    GetString(key) => this.GetTyped(key, "String")

    /**
     * @method GetInteger
     * @description Get as integer with default
     */
    GetInteger(key) => this.GetTyped(key, "Integer")

    /**
     * @method GetFloat
     * @description Get as float with default
     */
    GetFloat(key) => this.GetTyped(key, "Float")

    /**
     * @method GetArray
     * @description Get as array with default
     */
    GetArray(key) => this.GetTyped(key, "Array")

    /**
     * @method GetMap
     * @description Get as map with default
     */
    GetMap(key) => this.GetTyped(key, "Map")

    /**
     * @method GetBoolean
     * @description Get as boolean with default
     */
    GetBoolean(key) => this.GetTyped(key, "Boolean")
}

Example2_TypeSafeDefaults() {
    tsMap := TypeSafeMap()

    tsMap.Set("name", "John")
    tsMap.Set("age", 30)
    tsMap.Set("balance", 1234.56)

    output := "=== Type-Safe Defaults Example ===`n`n"

    ; Existing values
    output .= "Name (String): " tsMap.GetString("name") "`n"
    output .= "Age (Integer): " tsMap.GetInteger("age") "`n"
    output .= "Balance (Float): " tsMap.GetFloat("balance") "`n`n"

    ; Missing values - get type defaults
    output .= "Missing string: '" tsMap.GetString("missing") "' (empty)`n"
    output .= "Missing integer: " tsMap.GetInteger("missingNum") " (zero)`n"
    output .= "Missing float: " tsMap.GetFloat("missingFloat") " (zero)`n"
    output .= "Missing boolean: " (tsMap.GetBoolean("missingBool") ? "true" : "false") " (false)`n"

    arr := tsMap.GetArray("missingArray")
    output .= "Missing array length: " arr.Length " (empty array)`n"

    m := tsMap.GetMap("missingMap")
    output .= "Missing map count: " m.Count " (empty map)`n"

    MsgBox(output, "Type-Safe Defaults")
}

;=============================================================================
; Example 3: Lazy Default Evaluation
;=============================================================================

/**
 * @class LazyDefaultMap
 * @description Map with lazy-evaluated defaults
 */
class LazyDefaultMap {
    data := Map()
    defaultGenerators := Map()

    /**
     * @method SetDefaultGenerator
     * @description Set a function to generate default for missing keys
     */
    SetDefaultGenerator(key, generatorFunc) {
        this.defaultGenerators.Set(key, generatorFunc)
    }

    /**
     * @method Get
     * @description Get value, using lazy generator if needed
     */
    Get(key, defaultValue := "") {
        if (this.data.Has(key))
            return this.data.Get(key)

        ; Check if we have a generator for this key
        if (this.defaultGenerators.Has(key)) {
            generator := this.defaultGenerators.Get(key)
            value := generator.Call()

            ; Optionally cache the generated value
            this.data.Set(key, value)

            return value
        }

        return defaultValue
    }

    /**
     * @method Set
     * @description Store value
     */
    Set(key, value) {
        this.data.Set(key, value)
    }
}

Example3_LazyDefaults() {
    lazyMap := LazyDefaultMap()

    output := "=== Lazy Default Evaluation ===`n`n"

    ; Set up lazy generators
    lazyMap.SetDefaultGenerator("timestamp", () => A_Now)
    lazyMap.SetDefaultGenerator("randomId", () => "ID-" Random(10000, 99999))
    lazyMap.SetDefaultGenerator("counter", () => 1)

    output .= "First access (generates defaults):`n"
    output .= "Timestamp: " lazyMap.Get("timestamp") "`n"
    output .= "Random ID: " lazyMap.Get("randomId") "`n"
    output .= "Counter: " lazyMap.Get("counter") "`n`n"

    Sleep(100)

    output .= "Second access (cached values):`n"
    output .= "Timestamp: " lazyMap.Get("timestamp") " (same)`n"
    output .= "Random ID: " lazyMap.Get("randomId") " (same)`n"
    output .= "Counter: " lazyMap.Get("counter") " (same)`n"

    MsgBox(output, "Lazy Defaults")
}

Random(min, max) {
    return Mod(A_TickCount * A_Index, (max - min + 1)) + min
}

;=============================================================================
; Example 4: Environment Variable Defaults
;=============================================================================

/**
 * @class EnvConfig
 * @description Configuration with environment variable fallbacks
 */
class EnvConfig {
    config := Map()
    envMappings := Map()

    /**
     * @method MapToEnv
     * @description Map config key to environment variable
     */
    MapToEnv(key, envVar) {
        this.envMappings.Set(key, envVar)
    }

    /**
     * @method Get
     * @description Get value with env var fallback
     */
    Get(key, defaultValue := "") {
        ; Check config first
        if (this.config.Has(key))
            return this.config.Get(key)

        ; Check environment variable
        if (this.envMappings.Has(key)) {
            envVar := this.envMappings.Get(key)
            envValue := EnvGet(envVar)
            if (envValue != "")
                return envValue
        }

        ; Return default
        return defaultValue
    }

    /**
     * @method Set
     * @description Set configuration value
     */
    Set(key, value) {
        this.config.Set(key, value)
    }
}

Example4_EnvDefaults() {
    envConfig := EnvConfig()

    ; Map config keys to environment variables
    envConfig.MapToEnv("username", "USERNAME")
    envConfig.MapToEnv("computername", "COMPUTERNAME")
    envConfig.MapToEnv("temp", "TEMP")

    output := "=== Environment Variable Defaults ===`n`n"

    output .= "Username: " envConfig.Get("username", "Guest") "`n"
    output .= "Computer: " envConfig.Get("computername", "Unknown") "`n"
    output .= "Temp Dir: " envConfig.Get("temp", "C:\Temp") "`n`n"

    ; Override with config value
    envConfig.Set("username", "CustomUser")
    output .= "After override:`n"
    output .= "Username: " envConfig.Get("username", "Guest") "`n"

    MsgBox(output, "Environment Defaults")
}

;=============================================================================
; Example 5: Default Value Templates
;=============================================================================

/**
 * @class TemplateDefaults
 * @description Map with templated default values
 */
class TemplateDefaults {
    data := Map()
    templates := Map()

    __New() {
        ; Define templates for different entity types
        this.templates.Set("user", Map(
            "name", "New User",
            "role", "guest",
            "active", true,
            "created", () => A_Now
        ))

        this.templates.Set("product", Map(
            "name", "New Product",
            "price", 0.00,
            "stock", 0,
            "category", "uncategorized"
        ))

        this.templates.Set("order", Map(
            "id", () => "ORD-" Random(10000, 99999),
            "status", "pending",
            "total", 0.00,
            "items", () => []
        ))
    }

    /**
     * @method CreateFromTemplate
     * @description Create new entity from template
     */
    CreateFromTemplate(templateName, overrides := "") {
        if (!this.templates.Has(templateName))
            return Map()

        template := this.templates.Get(templateName)
        entity := Map()

        ; Apply template defaults
        for key, defaultValue in template {
            ; Evaluate functions
            if (Type(defaultValue) = "Func")
                entity.Set(key, defaultValue.Call())
            else
                entity.Set(key, defaultValue)
        }

        ; Apply overrides
        if (IsObject(overrides)) {
            for key, value in overrides {
                entity.Set(key, value)
            }
        }

        return entity
    }

    /**
     * @method GetWithTemplate
     * @description Get value with template field default
     */
    GetWithTemplate(id, field, templateName) {
        if (this.data.Has(id)) {
            entity := this.data.Get(id)
            if (entity.Has(field))
                return entity.Get(field)
        }

        ; Get template default
        if (this.templates.Has(templateName)) {
            template := this.templates.Get(templateName)
            if (template.Has(field)) {
                defaultValue := template.Get(field)
                return Type(defaultValue) = "Func" ? defaultValue.Call() : defaultValue
            }
        }

        return ""
    }
}

Example5_TemplateDefaults() {
    templates := TemplateDefaults()

    output := "=== Template Defaults Example ===`n`n"

    ; Create user from template
    user := templates.CreateFromTemplate("user", Map("name", "John Doe"))
    output .= "User created from template:`n"
    for key, value in user {
        output .= "  " key ": " value "`n"
    }
    output .= "`n"

    ; Create product with overrides
    product := templates.CreateFromTemplate("product", Map(
        "name", "Gaming Mouse",
        "price", 59.99,
        "stock", 100
    ))
    output .= "Product created from template:`n"
    for key, value in product {
        output .= "  " key ": " value "`n"
    }

    MsgBox(output, "Template Defaults")
}

;=============================================================================
; Example 6: Contextual Defaults
;=============================================================================

/**
 * @class ContextualMap
 * @description Map with context-aware defaults
 */
class ContextualMap {
    data := Map()
    context := ""

    /**
     * @method SetContext
     * @description Set current context
     */
    SetContext(ctx) {
        this.context := ctx
    }

    /**
     * @method Get
     * @description Get value with context-aware default
     */
    Get(key, defaults := "") {
        ; Try exact key first
        if (this.data.Has(key))
            return this.data.Get(key)

        ; Try context-specific key
        if (this.context != "") {
            contextKey := this.context "." key
            if (this.data.Has(contextKey))
                return this.data.Get(contextKey)
        }

        ; Use provided defaults map
        if (IsObject(defaults) && defaults.Has(key))
            return defaults.Get(key)

        ; Return empty string
        return ""
    }

    /**
     * @method Set
     * @description Set value
     */
    Set(key, value) {
        this.data.Set(key, value)
    }
}

Example6_ContextualDefaults() {
    ctxMap := ContextualMap()

    ; Set context-specific values
    ctxMap.Set("development.apiUrl", "http://localhost:3000")
    ctxMap.Set("production.apiUrl", "https://api.example.com")
    ctxMap.Set("debugLevel", 1)  ; Global default

    output := "=== Contextual Defaults Example ===`n`n"

    ; Development context
    ctxMap.SetContext("development")
    output .= "Development context:`n"
    output .= "  API URL: " ctxMap.Get("apiUrl") "`n"
    output .= "  Debug Level: " ctxMap.Get("debugLevel") "`n`n"

    ; Production context
    ctxMap.SetContext("production")
    output .= "Production context:`n"
    output .= "  API URL: " ctxMap.Get("apiUrl") "`n"
    output .= "  Debug Level: " ctxMap.Get("debugLevel") "`n`n"

    ; With fallback defaults
    fallbackDefaults := Map("timeout", 30, "retries", 3)
    ctxMap.SetContext("testing")
    output .= "Testing context (with fallbacks):`n"
    output .= "  API URL: " ctxMap.Get("apiUrl", fallbackDefaults) " (not set)`n"
    output .= "  Timeout: " ctxMap.Get("timeout", fallbackDefaults) " (from fallback)`n"
    output .= "  Retries: " ctxMap.Get("retries", fallbackDefaults) " (from fallback)`n"

    MsgBox(output, "Contextual Defaults")
}

;=============================================================================
; Example 7: Computed Defaults
;=============================================================================

/**
 * @class ComputedDefaultMap
 * @description Map with computed default values
 */
class ComputedDefaultMap {
    data := Map()
    computers := Map()

    /**
     * @method RegisterComputer
     * @description Register a computer function for a key
     */
    RegisterComputer(key, computerFunc) {
        this.computers.Set(key, computerFunc)
    }

    /**
     * @method Get
     * @description Get value, computing default if needed
     */
    Get(key, staticDefault := "") {
        if (this.data.Has(key))
            return this.data.Get(key)

        if (this.computers.Has(key)) {
            computer := this.computers.Get(key)
            return computer.Call(this)  ; Pass map reference
        }

        return staticDefault
    }

    /**
     * @method Set
     * @description Set value
     */
    Set(key, value) {
        this.data.Set(key, value)
    }
}

Example7_ComputedDefaults() {
    compMap := ComputedDefaultMap()

    ; Set base values
    compMap.Set("price", 100)
    compMap.Set("taxRate", 0.15)
    compMap.Set("discountPercent", 10)

    ; Register computed defaults
    compMap.RegisterComputer("tax", (m) => m.Get("price") * m.Get("taxRate"))
    compMap.RegisterComputer("discount", (m) => m.Get("price") * (m.Get("discountPercent") / 100))
    compMap.RegisterComputer("subtotal", (m) => m.Get("price") - m.Get("discount"))
    compMap.RegisterComputer("total", (m) => m.Get("subtotal") + m.Get("tax"))

    output := "=== Computed Defaults Example ===`n`n"

    output .= "Base values:`n"
    output .= "  Price: $" compMap.Get("price") "`n"
    output .= "  Tax Rate: " (compMap.Get("taxRate") * 100) "%`n"
    output .= "  Discount: " compMap.Get("discountPercent") "%`n`n"

    output .= "Computed values:`n"
    output .= "  Tax: $" compMap.Get("tax") "`n"
    output .= "  Discount: $" compMap.Get("discount") "`n"
    output .= "  Subtotal: $" compMap.Get("subtotal") "`n"
    output .= "  Total: $" compMap.Get("total") "`n"

    MsgBox(output, "Computed Defaults")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Get() - Default Value Handling Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Default Value Patterns with Map.Get()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Fallback Chain")
        .OnEvent("Click", (*) => Example1_FallbackChain())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Type-Safe")
        .OnEvent("Click", (*) => Example2_TypeSafeDefaults())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Lazy Defaults")
        .OnEvent("Click", (*) => Example3_LazyDefaults())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Env Defaults")
        .OnEvent("Click", (*) => Example4_EnvDefaults())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Templates")
        .OnEvent("Click", (*) => Example5_TemplateDefaults())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Contextual")
        .OnEvent("Click", (*) => Example6_ContextualDefaults())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Computed")
        .OnEvent("Click", (*) => Example7_ComputedDefaults())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_FallbackChain()
        Example2_TypeSafeDefaults()
        Example3_LazyDefaults()
        Example4_EnvDefaults()
        Example5_TemplateDefaults()
        Example6_ContextualDefaults()
        Example7_ComputedDefaults()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
