#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 SendInput Function - Gaming
 * ============================================================================
 *
 * Specialized gaming macros, combo systems, and rapid input sequences
 * optimized for gaming applications using SendInput's speed and reliability.
 *
 * @module BuiltIn_SendInput_02
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Skill Rotation Macros
; ============================================================================

/**
 * Basic skill rotation for MMORPGs.
 * Executes abilities in optimal sequence.
 *
 * @example
 * ; Press F1 for basic rotation
 */
F1:: {
    ToolTip("Basic rotation macro activating in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Basic 1-2-3 rotation
    skills := ["1", "2", "3"]

    for index, skill in skills {
        ToolTip("Skill " skill)
        SendInput(skill)
        Sleep(800)  ; Cooldown between skills
    }

    ToolTip("Rotation complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Advanced DPS rotation
 * Complex ability sequence with timings
 */
F2:: {
    ToolTip("Advanced rotation in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Advanced rotation: Buff -> Attack -> Cooldowns
    ToolTip("Activating buff...")
    SendInput("5")  ; Buff skill
    Sleep(200)

    ToolTip("Main attack sequence...")
    SendInput("1")  ; Main attack
    Sleep(600)

    SendInput("2")  ; Secondary
    Sleep(600)

    SendInput("3")  ; Finisher
    Sleep(600)

    ToolTip("Cooldown abilities...")
    SendInput("4")  ; Cooldown 1
    Sleep(400)

    SendInput("6")  ; Cooldown 2
    Sleep(400)

    ToolTip("Advanced rotation complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Burst damage combo
 * All cooldowns and burst abilities
 */
F3:: {
    ToolTip("BURST COMBO in 1 second...")
    Sleep(1000)
    ToolTip()

    burstSequence := [
        {key: "5", desc: "Ultimate buff"},
        {key: "r", desc: "Ultimate ability"},
        {key: "1", desc: "Main DPS"},
        {key: "2", desc: "Secondary DPS"},
        {key: "3", desc: "Finisher"},
        {key: "4", desc: "Cooldown"},
        {key: "6", desc: "Cooldown 2"}
    ]

    for index, ability in burstSequence {
        ToolTip("BURST: " ability.desc)
        SendInput(ability.key)
        Sleep(250)
    }

    ToolTip("BURST COMPLETE!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Example 2: MOBA/RTS Macros
; ============================================================================

/**
 * Quick cast ability combo for MOBAs.
 * Rapid ability sequence for team fights.
 *
 * @description
 * League of Legends / Dota 2 style combos
 */
^F1:: {
    ToolTip("MOBA combo in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Q-W-E-R combo
    ToolTip("Q -> W -> E -> R combo!")

    SendInput("q")
    Sleep(100)

    SendInput("w")
    Sleep(100)

    SendInput("e")
    Sleep(100)

    SendInput("r")

    ToolTip("Combo executed!")
    Sleep(1000)
    ToolTip()
}

/**
 * Item activation macro
 * Uses multiple items quickly
 */
^F2:: {
    ToolTip("Item combo in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Number key items (1-6) common in MOBAs
    items := ["1", "2", "3"]

    for index, item in items {
        ToolTip("Using item " item)
        SendInput(item)
        Sleep(150)
    }

    ToolTip("Items used!")
    Sleep(1000)
    ToolTip()
}

/**
 * Camera control macro
 * Rapid camera movement and selection
 */
^F3:: {
    ToolTip("Camera control in 1 second...")
    Sleep(1000)
    ToolTip()

    ; F keys for camera positions (common in RTS)
    ToolTip("Jump to base...")
    SendInput("{F1}")
    Sleep(600)

    ToolTip("Jump to expansion...")
    SendInput("{F2}")
    Sleep(600)

    ToolTip("Jump to army...")
    SendInput("{F3}")
    Sleep(600)

    ToolTip("Camera control complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 3: FPS Macros
; ============================================================================

/**
 * Weapon switch combo for FPS games.
 * Rapid weapon cycling.
 *
 * @description
 * Fast weapon switching for combat
 */
^F4:: {
    ToolTip("Weapon switch in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Switch to primary
    ToolTip("Primary weapon...")
    SendInput("1")
    Sleep(400)

    ; Fire burst
    SendInput("{LButton down}")
    Sleep(300)
    SendInput("{LButton up}")
    Sleep(200)

    ; Switch to secondary
    ToolTip("Secondary weapon...")
    SendInput("2")
    Sleep(400)

    ; Fire burst
    SendInput("{LButton down}")
    Sleep(300)
    SendInput("{LButton up}")

    ToolTip("Weapon switch complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Reload and switch macro
 * Auto-reload and switch pattern
 */
^F5:: {
    ToolTip("Reload combo in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Reload
    ToolTip("Reloading...")
    SendInput("r")
    Sleep(500)

    ; Quick switch (cancel reload animation in some games)
    ToolTip("Quick switch...")
    SendInput("2")
    Sleep(100)
    SendInput("1")

    ToolTip("Reload combo complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Grenade throw combo
 * Quick grenade sequences
 */
^F6:: {
    ToolTip("Grenade combo in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Flash grenade
    ToolTip("Flash...")
    SendInput("g")
    Sleep(100)
    SendInput("{LButton}")
    Sleep(800)

    ; Smoke grenade
    ToolTip("Smoke...")
    SendInput("g")
    Sleep(100)
    SendInput("{LButton}")
    Sleep(800)

    ToolTip("Grenades thrown!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 4: Fighting Game Combos
; ============================================================================

/**
 * Fighting game move sequence.
 * Precise input timing for combos.
 *
 * @description
 * Street Fighter / Mortal Kombat style
 */
^F7:: {
    ToolTip("Fighting combo in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Example: Quarter circle forward + Punch
    ToolTip("Special move combo...")

    ; Down
    SendInput("{Down down}")
    Sleep(50)
    SendInput("{Down up}")
    Sleep(50)

    ; Down-Forward (diagonal)
    SendInput("{Down down}{Right down}")
    Sleep(50)
    SendInput("{Down up}{Right up}")
    Sleep(50)

    ; Forward
    SendInput("{Right down}")
    Sleep(50)
    SendInput("{Right up}")
    Sleep(50)

    ; Punch
    SendInput("j")  ; J key as punch

    ToolTip("Special move executed!")
    Sleep(1500)
    ToolTip()
}

/**
 * Chain combo sequence
 * Multiple hits in sequence
 */
^F8:: {
    ToolTip("Chain combo in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Light -> Medium -> Heavy -> Special
    attacks := ["j", "k", "l", "i"]  ; Example keys
    attackNames := ["Light", "Medium", "Heavy", "Special"]

    for index, attack in attacks {
        ToolTip(attackNames[index] " attack!")
        SendInput(attack)
        Sleep(200)  ; Frame timing
    }

    ToolTip("Chain combo complete!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Example 5: Building/Crafting Macros
; ============================================================================

/**
 * Rapid building macro for survival games.
 * Fast structure placement.
 *
 * @description
 * Fortnite / Minecraft style building
 */
^F9:: {
    ToolTip("Building macro in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Build sequence: Wall, Floor, Ramp
    buildings := [
        {key: "q", name: "Wall"},
        {key: "f", name: "Floor"},
        {key: "r", name: "Ramp"}
    ]

    for index, building in buildings {
        ToolTip("Building: " building.name)
        SendInput(building.key)
        Sleep(100)
        SendInput("{LButton}")  ; Place
        Sleep(200)
    }

    ToolTip("Building complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Crafting macro
 * Auto-craft items rapidly
 */
^F10:: {
    ToolTip("Crafting macro in 1 second...")
    Sleep(1000)
    ToolTip()

    craftCount := 10

    Loop craftCount {
        ToolTip("Crafting " A_Index " of " craftCount "...")
        SendInput("e")  ; Craft key
        Sleep(100)
        SendInput("{Space}")  ; Confirm
        Sleep(200)
    }

    ToolTip("Crafting complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 6: Looting and Inventory
; ============================================================================

/**
 * Auto-loot macro.
 * Rapidly picks up items.
 *
 * @description
 * Battle royale / looter shooter style
 */
^F11:: {
    ToolTip("Auto-loot macro in 1 second...")
    Sleep(1000)
    ToolTip()

    lootCount := 8

    Loop lootCount {
        ToolTip("Looting item " A_Index "...")
        SendInput("f")  ; Loot key
        Sleep(100)
    }

    ToolTip("Looting complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Inventory sort macro
 * Quick inventory management
 */
^F12:: {
    ToolTip("Inventory sort in 1 second...")
    Sleep(1000)
    ToolTip()

    ; Open inventory
    SendInput("{Tab}")
    Sleep(300)

    ; Sort
    SendInput("s")
    Sleep(200)

    ; Close inventory
    SendInput("{Tab}")

    ToolTip("Inventory sorted!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 7: Communication Macros
; ============================================================================

/**
 * Quick chat macros for team games.
 * Sends predefined messages rapidly.
 *
 * @description
 * Team communication shortcuts
 */
!F1:: {
    ToolTip("Team chat macro...")

    ; Open chat
    SendInput("{Enter}")
    Sleep(100)

    ; Message
    SendInput("Good game, team!")
    Sleep(50)

    ; Send
    SendInput("{Enter}")

    ToolTip("Message sent!")
    Sleep(1000)
    ToolTip()
}

/**
 * Ping system macro
 * Multiple ping commands
 */
!F2:: {
    ToolTip("Ping macro...")

    pings := ["v", "g", "b"]  ; Example ping keys

    for ping in pings {
        SendInput(ping)
        Sleep(200)
    }

    ToolTip("Pings sent!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Execute ability rotation
 *
 * @param {Array} abilities - Array of ability keys
 * @param {Number} delay - Delay between abilities (ms)
 */
ExecuteRotation(abilities, delay := 500) {
    for index, ability in abilities {
        SendInput(ability)
        Sleep(delay)
    }
}

/**
 * Spam ability until stopped
 *
 * @param {String} key - Key to spam
 * @param {Number} interval - Time between presses (ms)
 * @param {Number} duration - How long to spam (ms)
 */
SpamAbility(key, interval := 100, duration := 3000) {
    startTime := A_TickCount

    while (A_TickCount - startTime < duration) {
        SendInput(key)
        Sleep(interval)
    }
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    SendInput - Gaming
    ==================

    F1 - Basic rotation
    F2 - Advanced rotation
    F3 - Burst combo

    Ctrl+F1  - MOBA ability combo
    Ctrl+F2  - Item activation
    Ctrl+F3  - Camera control
    Ctrl+F4  - FPS weapon switch
    Ctrl+F5  - Reload combo
    Ctrl+F6  - Grenade combo
    Ctrl+F7  - Fighting game combo
    Ctrl+F8  - Chain combo
    Ctrl+F9  - Building macro
    Ctrl+F10 - Crafting macro
    Ctrl+F11 - Auto-loot
    Ctrl+F12 - Inventory sort

    Alt+F1 - Team chat
    Alt+F2 - Ping system

    F12 - Show this help
    ESC - Exit script

    WARNING: Use gaming macros responsibly!
    Check game terms of service.
    )"

    MsgBox(helpText, "Gaming Macros Help")
}
