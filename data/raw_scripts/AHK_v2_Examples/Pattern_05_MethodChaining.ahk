#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Method Chaining Pattern (Fluent Interface)
 *
 * Demonstrates how to create chainable methods by returning 'this'.
 * Enables readable, fluent API design.
 *
 * Source: AHK_Notes/Patterns/method-chaining-pattern.md
 */

; Example: Configuration Builder with Method Chaining
config := ConfigBuilder()
    .SetSize(1024, 768)
    .SetTitle("My Application")
    .SetTheme("Dark")
    .SetFontSize(12)
    .Build()

; Create a GUI with the configuration
myGui := Gui("+Resize", config.Title)
myGui.BackColor := (config.Theme = "Dark") ? "333333" : "FFFFFF"
myGui.SetFont("s" config.FontSize)
myGui.AddText("c" (config.Theme = "Dark" ? "FFFFFF" : "000000"),
    "Window Size: " config.Width "x" config.Height "`n"
    . "Theme: " config.Theme "`n"
    . "Font Size: " config.FontSize)
myGui.Show("w" config.Width " h" config.Height)

/**
 * Configuration Builder Class
 * Demonstrates fluent interface pattern
 */
class ConfigBuilder {
    ; Internal properties with defaults
    Width := 800
    Height := 600
    Title := "My Window"
    Theme := "Default"
    FontSize := 10

    /**
     * Chainable method: Set window size
     * Returns 'this' to enable chaining
     */
    SetSize(width, height) {
        this.Width := width
        this.Height := height
        return this  ; ← KEY: Return this for chaining
    }

    /**
     * Chainable method: Set window title
     */
    SetTitle(title) {
        this.Title := title
        return this  ; ← Return this for chaining
    }

    /**
     * Chainable method: Set theme
     */
    SetTheme(theme) {
        this.Theme := theme
        return this  ; ← Return this for chaining
    }

    /**
     * Chainable method: Set font size
     */
    SetFontSize(size) {
        this.FontSize := size
        return this  ; ← Return this for chaining
    }

    /**
     * Terminal method: Build final configuration
     * Returns configuration object (not 'this')
     */
    Build() {
        return {
            Width: this.Width,
            Height: this.Height,
            Title: this.Title,
            Theme: this.Theme,
            FontSize: this.FontSize
        }
    }
}

/*
 * Key Concepts:
 *
 * 1. Method Chaining Pattern:
 *    - Each method returns 'this'
 *    - Enables fluent, readable syntax
 *    - Reduces temporary variables
 *
 * 2. Syntax Comparison:
 *
 *    WITHOUT chaining:
 *    config := ConfigBuilder()
 *    config.SetSize(1024, 768)
 *    config.SetTitle("My App")
 *    config.SetTheme("Dark")
 *    result := config.Build()
 *
 *    WITH chaining:
 *    result := ConfigBuilder()
 *        .SetSize(1024, 768)
 *        .SetTitle("My App")
 *        .SetTheme("Dark")
 *        .Build()
 *
 * 3. Benefits:
 *    ✅ More readable and expressive
 *    ✅ Less verbose
 *    ✅ Clear intent
 *    ✅ Easy to extend
 *
 * 4. Common Use Cases:
 *    - Configuration builders
 *    - Query builders (SQL, filters)
 *    - Request/Response builders
 *    - GUI builders
 *    - Validation chains
 *
 * 5. Best Practices:
 *    - Return 'this' for chainable methods
 *    - Terminal methods (like Build) return results
 *    - Keep methods focused and simple
 *    - Document which methods are chainable
 */
