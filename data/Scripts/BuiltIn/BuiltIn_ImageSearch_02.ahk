#Requires AutoHotkey v2.0

/**
* BuiltIn_ImageSearch_02.ahk
*
* DESCRIPTION:
* Advanced ImageSearch for automation, game bots, and complex recognition tasks
*
* FEATURES:
* - Multi-image automation sequences
* - Game bot frameworks
* - Smart retry mechanisms
* - Image monitoring and triggers
* - Complex automation workflows
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/ImageSearch.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Advanced ImageSearch patterns
* - State machine automation
* - Conditional workflows
* - Error recovery
* - Performance optimization
*
* LEARNING POINTS:
* 1. Build complex automation with image recognition
* 2. Create robust retry and error handling
* 3. Implement game bot logic
* 4. Monitor screen state changes
* 5. Optimize search performance
* 6. Handle dynamic content
*/

; ============================================================
; Example 1: Smart Image Search with Retry
; ============================================================

/**
* Image search with intelligent retry logic
*/
class SmartImageSearch {
    /**
    * Search with automatic retry and variation adjustment
    *
    * @param {String} imagePath - Path to image
    * @param {Integer} maxRetries - Maximum retry attempts
    * @param {Integer} retryDelay - Delay between retries (ms)
    * @returns {Object} - Search result with metadata
    */
    static SearchWithRetry(imagePath, maxRetries := 5, retryDelay := 1000) {
        if !FileExist(imagePath) {
            MsgBox("Image file not found: " imagePath, "Error", "Iconx")
            return {found: false, x: 0, y: 0, attempts: 0, variation: 0}
        }

        variations := [0, 10, 20, 30, 50]

        MsgBox("Smart search starting:`n`n"
        . "Image: " imagePath "`n"
        . "Max retries: " maxRetries "`n"
        . "Retry delay: " retryDelay "ms",
        "Smart Search", "T1")

        attempts := 0

        Loop maxRetries {
            attempts++
            varIndex := Min(A_Index, variations.Length)
            variation := variations[varIndex]

            searchString := variation > 0 ? "*" variation " " imagePath : imagePath

            ToolTip("Attempt " attempts " / " maxRetries "`n"
            . "Variation: " variation)

            try {
                if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                searchString) {
                    ToolTip()

                    MsgBox("Image found!`n`n"
                    . "Position: " x ", " y "`n"
                    . "Attempts: " attempts "`n"
                    . "Variation used: " variation,
                    "Found", "Iconi")

                    return {found: true, x: x, y: y,
                    attempts: attempts, variation: variation}
                }

            } catch as err {
                ToolTip("Error on attempt " attempts ": " err.Message)
                Sleep(500)
            }

            if A_Index < maxRetries
            Sleep(retryDelay)
        }

        ToolTip()

        MsgBox("Image not found after " maxRetries " attempts",
        "Not Found", "Icon!")

        return {found: false, x: 0, y: 0, attempts: attempts, variation: 0}
    }

    /**
    * Search with exponential backoff
    */
    static SearchWithBackoff(imagePath, maxRetries := 5) {
        if !FileExist(imagePath) {
            return {found: false, x: 0, y: 0}
        }

        MsgBox("Searching with exponential backoff...",
        "Searching", "T1")

        Loop maxRetries {
            delay := (2 ** (A_Index - 1)) * 1000  ; 1s, 2s, 4s, 8s, 16s

            try {
                if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                imagePath) {
                    MsgBox("Found on attempt " A_Index, "Found", "Iconi T1")
                    return {found: true, x: x, y: y}
                }

            } catch {
                ; Continue
            }

            if A_Index < maxRetries {
                ToolTip("Attempt " A_Index " failed, waiting " (delay/1000) "s...")
                Sleep(delay)
            }
        }

        ToolTip()
        return {found: false, x: 0, y: 0}
    }
}

; Test smart search
; SmartImageSearch.SearchWithRetry("C:\Images\button.png", 5, 1000)
; SmartImageSearch.SearchWithBackoff("C:\Images\element.png", 5)

; ============================================================
; Example 2: Image-Based State Machine
; ============================================================

/**
* State machine driven by image recognition
*/
class ImageStateMachine {
    /**
    * Initialize state machine
    */
    __New() {
        this.currentState := "idle"
        this.states := Map()
        this.isRunning := false
    }

    /**
    * Add a state with image trigger and action
    *
    * @param {String} stateName - State name
    * @param {String} triggerImage - Image that triggers this state
    * @param {Func} action - Action to perform
    * @param {String} nextState - Next state after action
    */
    AddState(stateName, triggerImage, action, nextState) {
        this.states[stateName] := {
            trigger: triggerImage,
            action: action,
            next: nextState
        }

        MsgBox("State added: " stateName "`n"
        . "Next state: " nextState,
        "State Added", "Iconi T1")
    }

    /**
    * Run the state machine
    */
    Run(maxIterations := 20) {
        this.isRunning := true

        MsgBox("State machine starting...`n`n"
        . "States: " this.states.Count "`n"
        . "Max iterations: " maxIterations,
        "Starting", "Iconi T1")

        iteration := 0

        while this.isRunning and iteration < maxIterations {
            iteration++

            if !this.states.Has(this.currentState) {
                MsgBox("Invalid state: " this.currentState, "Error", "Iconx")
                break
            }

            state := this.states[this.currentState]

            ToolTip("State: " this.currentState "`nIteration: " iteration)

            ; Check if trigger image exists
            if FileExist(state.trigger) {
                try {
                    if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                    state.trigger) {
                        ; Execute action
                        if IsSet(state.action) and state.action != ""
                        state.action.Call(x, y)

                        ; Transition to next state
                        this.currentState := state.next

                        Sleep(500)  ; Brief pause between states
                        continue
                    }

                } catch {
                    ; Continue on error
                }
            }

            Sleep(500)  ; Wait before checking again
        }

        ToolTip()
        this.isRunning := false

        MsgBox("State machine stopped`n"
        . "Final state: " this.currentState "`n"
        . "Iterations: " iteration,
        "Stopped", "Iconi")
    }

    /**
    * Stop the state machine
    */
    Stop() {
        this.isRunning := false
    }
}

; Example state machine setup
; sm := ImageStateMachine()
; sm.AddState("start", "C:\Images\start_button.png",
;            (x, y) => Click(x, y), "processing")
; sm.AddState("processing", "C:\Images\done_button.png",
;            (x, y) => Click(x, y), "finish")
; sm.AddState("finish", "C:\Images\close_button.png",
;            (x, y) => Click(x, y), "idle")
; sm.Run(20)

; ============================================================
; Example 3: Game Bot Framework
; ============================================================

/**
* Comprehensive game bot using image recognition
*/
class GameBot {
    /**
    * Initialize game bot
    */
    __New(gameWindowTitle := "") {
        this.gameWindow := gameWindowTitle
        this.isRunning := false
        this.images := Map()
        this.actions := []
        this.stats := {
            actions: 0,
            errors: 0,
            startTime: 0
        }
    }

    /**
    * Register an image for the bot to recognize
    *
    * @param {String} name - Image identifier
    * @param {String} path - Path to image file
    */
    RegisterImage(name, path) {
        this.images[name] := path
        MsgBox("Registered: " name, "Bot", "Iconi T1")
    }

    /**
    * Add action to bot routine
    *
    * @param {String} imageName - Image to look for
    * @param {String} actionType - Action type (click, doubleclick, wait)
    * @param {Integer} priority - Action priority (higher = more important)
    */
    AddAction(imageName, actionType := "click", priority := 1) {
        this.actions.Push({
            image: imageName,
            type: actionType,
            priority: priority
        })
    }

    /**
    * Start bot
    */
    Start() {
        if this.isRunning {
            MsgBox("Bot already running", "Info", "Iconi T1")
            return
        }

        this.isRunning := true
        this.stats.startTime := A_TickCount
        this.stats.actions := 0
        this.stats.errors := 0

        MsgBox("Game Bot Starting!`n`n"
        . "Registered images: " this.images.Count "`n"
        . "Actions: " this.actions.Length "`n`n"
        . "Press ESC to stop",
        "Bot Active", "Iconi")

        ; Setup ESC to stop
        Hotkey("Esc", (*) => this.Stop())

        ; Run bot loop
        SetTimer(() => this.BotLoop(), 500)
    }

    /**
    * Stop bot
    */
    Stop() {
        if !this.isRunning
        return

        this.isRunning := false
        SetTimer(() => this.BotLoop(), 0)

        ; Disable hotkey
        try Hotkey("Esc", "Off")

        this.ShowStats()
    }

    /**
    * Main bot loop
    */
    BotLoop() {
        if !this.isRunning
        return

        ; Check for ESC key
        if GetKeyState("Esc", "P") {
            this.Stop()
            return
        }

        ; Focus game window if specified
        if this.gameWindow != "" {
            if WinExist(this.gameWindow)
            WinActivate(this.gameWindow)
        }

        ; Sort actions by priority
        sortedActions := this.SortActionsByPriority()

        ; Try each action
        for action in sortedActions {
            if !this.images.Has(action.image)
            continue

            imagePath := this.images[action.image]

            if !FileExist(imagePath)
            continue

            try {
                if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                "*20 " imagePath) {
                    ; Perform action
                    this.PerformAction(x, y, action.type)
                    this.stats.actions++

                    ToolTip("Bot Action: " action.type " on " action.image "`n"
                    . "Total actions: " this.stats.actions)

                    Sleep(500)  ; Prevent spam
                    return  ; One action per loop
                }

            } catch {
                this.stats.errors++
            }
        }
    }

    /**
    * Perform bot action
    */
    PerformAction(x, y, actionType) {
        switch actionType {
            case "click":
            Click(x, y)

            case "doubleclick":
            Click(x, y, 2)

            case "rightclick":
            Click(x, y, "Right")

            case "hover":
            MouseMove(x, y)

            default:
            Click(x, y)
        }
    }

    /**
    * Sort actions by priority
    */
    SortActionsByPriority() {
        sorted := this.actions.Clone()

        ; Simple bubble sort
        n := sorted.Length
        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                if sorted[j].priority < sorted[j + 1].priority {
                    temp := sorted[j]
                    sorted[j] := sorted[j + 1]
                    sorted[j + 1] := temp
                }
            }
        }

        return sorted
    }

    /**
    * Show bot statistics
    */
    ShowStats() {
        runtime := Round((A_TickCount - this.stats.startTime) / 1000, 1)
        apm := runtime > 0 ? Round((this.stats.actions / runtime) * 60, 1) : 0

        MsgBox("BOT STATISTICS:`n`n"
        . "Runtime: " runtime " seconds`n"
        . "Actions performed: " this.stats.actions "`n"
        . "Errors: " this.stats.errors "`n"
        . "Actions per minute: " apm,
        "Bot Stats", "Iconi")
    }
}

; Example game bot setup
; bot := GameBot("Game Window Title")
; bot.RegisterImage("health_potion", "C:\Bot\health.png")
; bot.RegisterImage("mana_potion", "C:\Bot\mana.png")
; bot.RegisterImage("enemy", "C:\Bot\enemy.png")
; bot.RegisterImage("loot", "C:\Bot\loot.png")
; bot.AddAction("health_potion", "click", 10)  ; Highest priority
; bot.AddAction("mana_potion", "click", 9)
; bot.AddAction("enemy", "click", 5)
; bot.AddAction("loot", "click", 3)
; bot.Start()

; ============================================================
; Example 4: Image Monitoring and Triggers
; ============================================================

/**
* Monitor screen for images and trigger actions
*/
class ImageMonitor {
    /**
    * Initialize monitor
    */
    __New() {
        this.monitors := []
        this.isActive := false
    }

    /**
    * Add image to monitor
    *
    * @param {String} imagePath - Path to image
    * @param {Func} callback - Function to call when found
    * @param {String} name - Monitor name
    */
    AddMonitor(imagePath, callback, name := "") {
        if name = ""
        name := "Monitor" (this.monitors.Length + 1)

        this.monitors.Push({
            name: name,
            image: imagePath,
            callback: callback,
            lastSeen: 0
        })

        MsgBox("Monitor added: " name, "Monitor", "Iconi T1")
    }

    /**
    * Start monitoring
    */
    Start(checkInterval := 1000) {
        if this.isActive {
            MsgBox("Already monitoring", "Info", "Iconi T1")
            return
        }

        this.isActive := true

        MsgBox("Image monitoring started`n`n"
        . "Monitors: " this.monitors.Length "`n"
        . "Check interval: " checkInterval "ms",
        "Monitoring", "Iconi")

        SetTimer(() => this.CheckMonitors(), checkInterval)
    }

    /**
    * Stop monitoring
    */
    Stop() {
        this.isActive := false
        SetTimer(() => this.CheckMonitors(), 0)

        MsgBox("Monitoring stopped", "Stopped", "Iconi T1")
    }

    /**
    * Check all monitored images
    */
    CheckMonitors() {
        if !this.isActive
        return

        for monitor in this.monitors {
            if !FileExist(monitor.image)
            continue

            try {
                if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                "*30 " monitor.image) {
                    currentTime := A_TickCount

                    ; Avoid trigger spam (minimum 5 second gap)
                    if (currentTime - monitor.lastSeen) > 5000 {
                        monitor.lastSeen := currentTime

                        ; Call callback
                        if IsSet(monitor.callback)
                        monitor.callback.Call(x, y, monitor.name)
                    }
                }

            } catch {
                ; Continue on error
            }
        }
    }
}

; Example monitor setup
; monitor := ImageMonitor()
; monitor.AddMonitor("C:\Images\error.png",
;                   (x, y, name) => MsgBox("Error detected!", "Alert", "Iconx"),
;                   "ErrorMonitor")
; monitor.AddMonitor("C:\Images\success.png",
;                   (x, y, name) => SoundBeep(1000, 200),
;                   "SuccessMonitor")
; monitor.Start(1000)

; ============================================================
; Example 5: Automated Workflow Sequences
; ============================================================

/**
* Execute complex workflows based on image recognition
*/
class WorkflowAutomation {
    /**
    * Execute a sequence of image-based steps
    *
    * @param {Array} steps - Array of workflow steps
    * @returns {Object} - Execution results
    */
    static ExecuteSequence(steps) {
        results := {
            totalSteps: steps.Length,
            completed: 0,
            failed: 0,
            skipped: 0
        }

        MsgBox("Starting workflow sequence`n`n"
        . "Total steps: " steps.Length,
        "Workflow", "Iconi T1")

        for index, step in steps {
            ToolTip("Step " index " / " steps.Length ": " step.name)

            result := this.ExecuteStep(step)

            if result.success {
                results.completed++
                Sleep(step.delay ?? 1000)
            } else if step.required {
                results.failed++
                MsgBox("Required step failed: " step.name "`n`n"
                . "Workflow aborted",
                "Workflow Failed", "Iconx")
                break
            } else {
                results.skipped++
            }
        }

        ToolTip()
        this.ShowWorkflowResults(results)

        return results
    }

    /**
    * Execute a single workflow step
    */
    static ExecuteStep(step) {
        if !FileExist(step.image)
        return {success: false, reason: "Image not found"}

        maxAttempts := step.retries ?? 3

        Loop maxAttempts {
            try {
                if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                "*30 " step.image) {
                    ; Perform action
                    switch step.action {
                        case "click":
                        Click(x + (step.offsetX ?? 0), y + (step.offsetY ?? 0))

                        case "doubleclick":
                        Click(x, y, 2)

                        case "wait":
                        ; Just wait, no action

                        default:
                        Click(x, y)
                    }

                    return {success: true, x: x, y: y}
                }

            } catch as err {
                if A_Index = maxAttempts
                return {success: false, reason: err.Message}
            }

            Sleep(step.retryDelay ?? 1000)
        }

        return {success: false, reason: "Image not found after retries"}
    }

    /**
    * Show workflow results
    */
    static ShowWorkflowResults(results) {
        MsgBox("WORKFLOW RESULTS:`n`n"
        . "Total steps: " results.totalSteps "`n"
        . "Completed: " results.completed "`n"
        . "Failed: " results.failed "`n"
        . "Skipped: " results.skipped,
        "Workflow Complete", "Iconi")
    }

    /**
    * Create a simple form-filling workflow
    */
    static ExampleFormFill() {
        workflow := [
        {
            name: "Click Name Field", image: "C:\Workflow\name_field.png",
            action: "click", required: true, delay: 500},
            {
                name: "Click Email Field", image: "C:\Workflow\email_field.png",
                action: "click", required: true, delay: 500},
                {
                    name: "Click Submit", image: "C:\Workflow\submit_btn.png",
                    action: "click", required: true, delay: 1000},
                    {
                        name: "Wait for Confirmation", image: "C:\Workflow\success.png",
                        action: "wait", required: false, retries: 5, retryDelay: 2000}
                        ]

                        return this.ExecuteSequence(workflow)
                    }
                }

                ; Test workflow
                ; WorkflowAutomation.ExampleFormFill()

                ; ============================================================
                ; Example 6: Performance-Optimized Image Finder
                ; ============================================================

                /**
                * Optimized image searching techniques
                */
                class OptimizedImageSearch {
                    /**
                    * Search in multiple regions (divide and conquer)
                    */
                    static SearchMultiRegion(imagePath, regions := "") {
                        if !FileExist(imagePath)
                        return {found: false, x: 0, y: 0}

                        ; Default regions: divide screen into quadrants
                        if regions = "" {
                            halfW := A_ScreenWidth // 2
                            halfH := A_ScreenHeight // 2

                            regions := [
                            {
                                x1: 0, y1: 0, x2: halfW, y2: halfH},              ; Top-left
                                {
                                    x1: halfW, y1: 0, x2: A_ScreenWidth, y2: halfH},  ; Top-right
                                    {
                                        x1: 0, y1: halfH, x2: halfW, y2: A_ScreenHeight}, ; Bottom-left
                                        {
                                            x1: halfW, y1: halfH, x2: A_ScreenWidth, y2: A_ScreenHeight} ; Bottom-right
                                            ]
                                        }

                                        for region in regions {
                                            try {
                                                if ImageSearch(&x, &y, region.x1, region.y1,
                                                region.x2, region.y2, imagePath) {
                                                    MsgBox("Found in region " A_Index "`n"
                                                    . "Position: " x ", " y,
                                                    "Found", "Iconi T1")

                                                    return {found: true, x: x, y: y, region: A_Index}
                                                }

                                            } catch {
                                                continue
                                            }
                                        }

                                        return {found: false, x: 0, y: 0, region: 0}
                                    }

                                    /**
                                    * Cached image search (stores last known position)
                                    */
                                    static cachedPositions := Map()

                                    static SearchWithCache(imagePath, searchRadius := 100) {
                                        if !FileExist(imagePath)
                                        return {found: false, x: 0, y: 0}

                                        ; Check if we have cached position
                                        if this.cachedPositions.Has(imagePath) {
                                            cached := this.cachedPositions[imagePath]

                                            ; Search near last known position first
                                            x1 := Max(0, cached.x - searchRadius)
                                            y1 := Max(0, cached.y - searchRadius)
                                            x2 := Min(A_ScreenWidth, cached.x + searchRadius)
                                            y2 := Min(A_ScreenHeight, cached.y + searchRadius)

                                            try {
                                                if ImageSearch(&x, &y, x1, y1, x2, y2, imagePath) {
                                                    this.cachedPositions[imagePath] := {x: x, y: y}
                                                    return {found: true, x: x, y: y, cached: true}
                                                }

                                            } catch {
                                                ; Fall through to full search
                                            }
                                        }

                                        ; Full screen search
                                        try {
                                            if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                                            imagePath) {
                                                this.cachedPositions[imagePath] := {x: x, y: y}
                                                return {found: true, x: x, y: y, cached: false}
                                            }

                                        } catch {
                                            return {found: false, x: 0, y: 0}
                                        }

                                        return {found: false, x: 0, y: 0}
                                    }

                                    /**
                                    * Clear cache
                                    */
                                    static ClearCache() {
                                        this.cachedPositions := Map()
                                        MsgBox("Image search cache cleared", "Cache", "Iconi T1")
                                    }
                                }

                                ; Test optimized search
                                ; OptimizedImageSearch.SearchMultiRegion("C:\Images\button.png")
                                ; OptimizedImageSearch.SearchWithCache("C:\Images\logo.png", 100)

                                ; ============================================================
                                ; Example 7: Image-Based Testing Framework
                                ; ============================================================

                                /**
                                * Automated testing using image recognition
                                */
                                class ImageTestFramework {
                                    /**
                                    * Run a test suite
                                    */
                                    static RunTestSuite(tests) {
                                        results := {
                                            total: tests.Length,
                                            passed: 0,
                                            failed: 0,
                                            errors: 0
                                        }

                                        MsgBox("Running test suite`n`n"
                                        . "Total tests: " tests.Length,
                                        "Testing", "Iconi T1")

                                        for index, test in tests {
                                            ToolTip("Running test " index " / " tests.Length "`n"
                                            . test.name)

                                            try {
                                                if this.RunTest(test)
                                                results.passed++
                                                else
                                                results.failed++

                                            } catch as err {
                                                results.errors++
                                                MsgBox("Test error: " test.name "`n" err.Message,
                                                "Error", "Iconx T2")
                                            }

                                            Sleep(500)
                                        }

                                        ToolTip()
                                        this.ShowTestResults(results)

                                        return results
                                    }

                                    /**
                                    * Run a single test
                                    */
                                    static RunTest(test) {
                                        ; Setup
                                        if IsSet(test.setup) and test.setup != ""
                                        test.setup.Call()

                                        Sleep(200)

                                        ; Execute
                                        found := false
                                        if FileExist(test.expectedImage) {
                                            found := ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                                            "*30 " test.expectedImage)
                                        }

                                        ; Verify
                                        passed := (found = test.shouldExist)

                                        ; Cleanup
                                        if IsSet(test.cleanup) and test.cleanup != ""
                                        test.cleanup.Call()

                                        ; Report
                                        status := passed ? "PASS" : "FAIL"
                                        ToolTip(status ": " test.name)
                                        Sleep(500)

                                        return passed
                                    }

                                    /**
                                    * Show test results
                                    */
                                    static ShowTestResults(results) {
                                        passRate := results.total > 0
                                        ? Round((results.passed / results.total) * 100, 1)
                                        : 0

                                        MsgBox("TEST RESULTS:`n`n"
                                        . "Total: " results.total "`n"
                                        . "Passed: " results.passed "`n"
                                        . "Failed: " results.failed "`n"
                                        . "Errors: " results.errors "`n`n"
                                        . "Pass Rate: " passRate "%",
                                        "Test Results", results.failed = 0 ? "Iconi" : "Iconx")
                                    }
                                }

                                ; Example test suite
                                ; tests := [
                                ;     {name: "Verify Logo", expectedImage: "C:\Tests\logo.png",
                                ;      shouldExist: true},
                                ;     {name: "Verify No Error", expectedImage: "C:\Tests\error.png",
                                ;      shouldExist: false},
                                ;     {name: "Button Visible", expectedImage: "C:\Tests\button.png",
                                ;      shouldExist: true}
                                ; ]
                                ; ImageTestFramework.RunTestSuite(tests)

                                ; ============================================================
                                ; Reference Information
                                ; ============================================================

                                info := "
                                (
                                ADVANCED IMAGESEARCH TECHNIQUES:

                                Smart Retry Logic:
                                • Automatic variation adjustment
                                • Exponential backoff
                                • Configurable retry attempts
                                • Error recovery

                                State Machines:
                                • Image-triggered transitions
                                • Sequential workflows
                                • Conditional branching
                                • Loop prevention

                                Game Bots:
                                • Priority-based actions
                                • Multi-image recognition
                                • Statistics tracking
                                • Error handling
                                • Performance monitoring

                                Image Monitoring:
                                • Real-time screen watching
                                • Event-driven triggers
                                • Callback actions
                                • Spam prevention

                                Workflow Automation:
                                • Sequential execution
                                • Required vs optional steps
                                • Retry mechanisms
                                • Result tracking
                                • Form filling

                                Performance Optimization:
                                • Region-based searching
                                • Position caching
                                • Divide and conquer
                                • Smart search areas
                                • Result reuse

                                Testing Frameworks:
                                • Automated UI testing
                                • Expected vs actual
                                • Pass/fail reporting
                                • Test suites
                                • Setup/cleanup

                                Best Practices:
                                ✓ Always validate image files
                                ✓ Implement timeouts
                                ✓ Use appropriate variations
                                ✓ Cache results when possible
                                ✓ Limit search regions
                                ✓ Handle errors gracefully
                                ✓ Provide user feedback
                                ✓ Test thoroughly

                                Common Patterns:
                                • Find → Click → Wait
                                • Monitor → Trigger → Action
                                • Search → Retry → Report
                                • Sequence → Validate → Continue
                                • Cache → Quick Search → Full Search

                                Bot Ethics & Legal:
                                ⚠ Check ToS before automating
                                ⚠ Some games/apps prohibit bots
                                ⚠ Respect rate limits
                                ⚠ Don't harm other users
                                ⚠ Educational use only
                                ⚠ Consider anti-cheat systems

                                Troubleshooting:
                                • False positives → Lower variation
                                • Missed matches → Increase variation
                                • Slow performance → Reduce region
                                • Inconsistent → Add retry logic
                                • DPI issues → Test on target system

                                Advanced Tips:
                                1. Combine with PixelSearch for validation
                                2. Use multiple reference images
                                3. Implement confidence scoring
                                4. Log all actions for debugging
                                5. Add manual override options
                                6. Test on different resolutions
                                7. Handle window focus changes
                                8. Account for animations
                                9. Use incremental timeouts
                                10. Provide stop mechanisms

                                Creating Robust Bots:
                                • Multiple image variations
                                • Fallback strategies
                                • State validation
                                • Resource management
                                • Error recovery
                                • Status reporting
                                • User controls
                                )"

                                MsgBox(info, "Advanced ImageSearch Reference", "Icon!")
