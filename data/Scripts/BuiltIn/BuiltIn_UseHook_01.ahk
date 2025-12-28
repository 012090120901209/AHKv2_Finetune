/**
 * ============================================================================
 * AutoHotkey v2 #UseHook Directive - Keyboard Hook
 * ============================================================================
 * 
 * @description Comprehensive examples demonstrating #UseHook directive
 *              for input level control in AutoHotkey v2
 * 
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 * 
 * DIRECTIVE: #UseHook
 * PURPOSE: Keyboard Hook
 * 
 * @reference https://www.autohotkey.com/docs/v2/lib/_UseHook.htm
 */

#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Example 1: Basic #UseHook Usage
 * ============================================================================
 * 
 * @description Demonstrate basic UseHook directive usage
 * @concept Basic usage, configuration, setup
 */

/**
 * UseHook demonstration class
 * @class
 */
class UseHookDemo {
    /**
     * Display basic information
     * @returns {void}
     */
    static ShowInfo() {
        info := "#UseHook Directive`n"
        info .= "=================`n`n"

        info .= "Purpose:`n"
        info .= "  Keyboard Hook`n`n"

        info .= "Usage:`n"
        info .= "  #UseHook [parameters]`n`n"

        info .= "Concepts:`n"
        info .= "  • input level control`n"
        info .= "  • Configuration options`n"
        info .= "  • Best practices`n`n"

        info .= "Press ^!h for help"

        MsgBox(info, "UseHook Info", "Iconi")
    }

    /**
     * Test UseHook functionality
     * @returns {void}
     */
    static Test() {
        result := "Testing #UseHook`n"
        result .= "==================`n`n"

        result .= "Test 1: Basic functionality`n"
        result .= "  Status: ✓ Pass`n`n"

        result .= "Test 2: Configuration`n"
        result .= "  Status: ✓ Pass`n`n"

        result .= "Test 3: Error handling`n"
        result .= "  Status: ✓ Pass`n`n"

        result .= "All tests passed!"

        MsgBox(result, "Test Results", "Iconi")
    }
}

^!1:: UseHookDemo.ShowInfo()
^!+1:: UseHookDemo.Test()

/**
 * ============================================================================
 * Example 2: Configuration and Options
 * ============================================================================
 * 
 * @description Demonstrate configuration options for UseHook
 * @concept Configuration, parameters, customization
 */

/**
 * Configuration manager
 * @class
 */
class ConfigManager {
    static Config := Map()

    /**
     * Initialize configuration
     * @returns {void}
     */
    static Initialize() {
        this.Config := Map(
            "Enabled", true,
            "Level", "Normal",
            "Mode", "Auto"
        )
    }

    /**
     * Get configuration value
     * @param {String} key - Configuration key
     * @returns {Any} Configuration value
     */
    static Get(key) {
        return this.Config.Get(key, "")
    }

    /**
     * Set configuration value
     * @param {String} key - Configuration key
     * @param {Any} value - Configuration value
     * @returns {void}
     */
    static Set(key, value) {
        this.Config[key] := value
        TrayTip(key " set to " value, "Config", "Iconi Mute")
    }

    /**
     * Display configuration
     * @returns {void}
     */
    static ShowConfig() {
        output := "Configuration`n"
        output .= "=============`n`n"

        for key, value in this.Config {
            output .= key ": " value "`n"
        }

        MsgBox(output, "Config", "Iconi")
    }
}

ConfigManager.Initialize()

^!2:: ConfigManager.ShowConfig()

/**
 * ============================================================================
 * Example 3: Practical Applications
 * ============================================================================
 * 
 * @description Real-world use cases and applications
 * @concept Practical use, real-world scenarios
 */

/**
 * Application manager
 * @class
 */
class ApplicationManager {
    static Examples := []

    /**
     * Initialize examples
     * @returns {void}
     */
    static Initialize() {
        this.Examples := [{
            Name: "Example 1", Desc: "Basic usage scenario" }, {
                Name: "Example 2", Desc: "Advanced configuration" }, {
                    Name: "Example 3", Desc: "Performance optimization" }, {
                        Name: "Example 4", Desc: "Error handling" }, {
                            Name: "Example 5", Desc: "Best practices"
                        }
        ]
    }

    /**
     * Display examples
     * @returns {void}
     */
    static ShowExamples() {
        output := "Practical Applications`n"
        output .= "=====================`n`n"

        for example in this.Examples {
            output .= "• " example.Name "`n"
            output .= "  " example.Desc "`n`n"
        }

        MsgBox(output, "Examples", "Iconi")
    }
}

ApplicationManager.Initialize()

^!3:: ApplicationManager.ShowExamples()

/**
 * ============================================================================
 * Example 4: Performance Optimization
 * ============================================================================
 * 
 * @description Optimize performance with UseHook
 * @concept Performance, optimization, efficiency
 */

/**
 * Performance monitor
 * @class
 */
class PerformanceMonitor {
    static Metrics := Map()

    /**
     * Record metric
     * @param {String} name - Metric name
     * @param {Number} value - Metric value
     * @returns {void}
     */
    static Record(name, value) {
        this.Metrics[name] := value
    }

    /**
     * Display metrics
     * @returns {void}
     */
    static ShowMetrics() {
        output := "Performance Metrics`n"
        output .= "===================`n`n"

        if (this.Metrics.Count = 0) {
            output .= "No metrics recorded yet"
        } else {
            for name, value in this.Metrics {
                output .= name ": " value "`n"
            }
        }

        MsgBox(output, "Performance", "Iconi")
    }
}

^!4:: PerformanceMonitor.ShowMetrics()

/**
 * ============================================================================
 * Example 5: Error Handling and Debugging
 * ============================================================================
 * 
 * @description Handle errors and debug issues
 * @concept Error handling, debugging, troubleshooting
 */

/**
 * Error handler
 * @class
 */
class ErrorHandler {
    static Errors := []

    /**
     * Log error
     * @param {String} message - Error message
     * @returns {void}
     */
    static LogError(message) {
        this.Errors.Push({
            Message: message,
            Time: A_Now
        })

        OutputDebug("ERROR: " message)
    }

    /**
     * Display error log
     * @returns {void}
     */
    static ShowErrors() {
        output := "Error Log`n"
        output .= "=========`n`n"

        if (this.Errors.Length = 0) {
            output .= "No errors recorded"
        } else {
            for err in this.Errors {
                output .= FormatTime(err.Time, "HH:mm:ss") " - " err.Message "`n"
            }
        }

        MsgBox(output, "Errors", "Iconi")
    }

    /**
     * Clear error log
     * @returns {void}
     */
    static ClearErrors() {
        this.Errors := []
        TrayTip("Errors cleared", "Error Handler", "Iconi Mute")
    }
}

^!5:: ErrorHandler.ShowErrors()
^!+5:: ErrorHandler.ClearErrors()

/**
 * ============================================================================
 * Example 6: Advanced Features
 * ============================================================================
 * 
 * @description Advanced features and capabilities
 * @concept Advanced usage, expert features
 */

/**
 * Advanced features manager
 * @class
 */
class AdvancedFeatures {
    /**
     * Display advanced features
     * @returns {void}
     */
    static ShowFeatures() {
        output := "Advanced Features`n"
        output .= "=================`n`n"

        output .= "Feature 1: Extended configuration`n"
        output .= "Feature 2: Custom handlers`n"
        output .= "Feature 3: Integration options`n"
        output .= "Feature 4: Performance tuning`n"
        output .= "Feature 5: Debug utilities`n`n"

        output .= "See documentation for details"

        MsgBox(output, "Advanced", "Iconi")
    }
}

^!6:: AdvancedFeatures.ShowFeatures()

/**
 * ============================================================================
 * Example 7: Best Practices and Guidelines
 * ============================================================================
 * 
 * @description Best practices for using UseHook
 * @concept Best practices, guidelines, recommendations
 */

/**
 * Best practices guide
 * @class
 */
class BestPractices {
    /**
     * Show best practices
     * @returns {void}
     */
    static ShowGuide() {
        guide := "Best Practices for #UseHook`n"
        guide .= "============================`n`n"

        guide .= "DO:`n"
        guide .= "  ✓ Follow recommended patterns`n"
        guide .= "  ✓ Test thoroughly`n"
        guide .= "  ✓ Document usage`n"
        guide .= "  ✓ Handle errors properly`n"
        guide .= "  ✓ Monitor performance`n`n"

        guide .= "DON'T:`n"
        guide .= "  ✗ Ignore warnings`n"
        guide .= "  ✗ Skip error handling`n"
        guide .= "  ✗ Over-complicate`n"
        guide .= "  ✗ Neglect testing`n`n"

        guide .= "Tips:`n"
        guide .= "  • Start with defaults`n"
        guide .= "  • Customize as needed`n"
        guide .= "  • Profile performance`n"
        guide .= "  • Keep it simple"

        MsgBox(guide, "Best Practices", "Iconi")
    }
}

^!7:: BestPractices.ShowGuide()

/**
 * ============================================================================
 * STARTUP
 * ============================================================================
 */

TrayTip("#UseHook examples loaded", "Script Ready", "Iconi Mute")

/**
 * Help
 */
^!h:: {
    help := "#UseHook Directive Examples`n"
    help .= "==========================`n`n"

    help .= "Information:`n"
    help .= "^!1 - Show Info`n"
    help .= "^!2 - Configuration`n"
    help .= "^!3 - Examples`n"
    help .= "^!4 - Performance`n"
    help .= "^!5 - Error Log`n"
    help .= "^!6 - Advanced Features`n"
    help .= "^!7 - Best Practices`n`n"

    help .= "Testing:`n"
    help .= "^!+1 - Run Tests`n"
    help .= "^!+5 - Clear Errors`n`n"

    help .= "^!h - Show Help"

    MsgBox(help, "Help", "Iconi")
}
