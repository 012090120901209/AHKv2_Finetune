#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Mod_02_CyclicPatterns.ahk
 * 
 * DESCRIPTION:
 * Cyclic pattern applications using Mod() for circular buffers, rotation, and repeating sequences
 * 
 * FEATURES:
 * - Circular buffer implementation
 * - Rotation and cycling algorithms
 * - Repeating patterns and sequences
 * - Round-robin scheduling
 * - Periodic functions
 * - State machines with cycles
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation & Algorithm Design
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Mod
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Mod() for cyclic operations
 * - Class-based data structures
 * - Circular indexing
 * - Pattern generation
 * - State management
 * 
 * LEARNING POINTS:
 * 1. Modulo creates repeating cycles
 * 2. Perfect for circular data structures
 * 3. Enables rotation without data copying
 * 4. Used in round-robin algorithms
 * 5. Essential for periodic patterns
 */

; ============================================================
; Example 1: Circular Buffer Implementation
; ============================================================

/**
 * Fixed-size circular buffer (ring buffer)
 */
class CircularBuffer {
    __New(capacity) {
        this.capacity := capacity
        this.buffer := []
        this.head := 0      ; Write position
        this.tail := 0      ; Read position
        this.count := 0     ; Number of items

        ; Initialize buffer
        Loop capacity {
            this.buffer.Push(0)
        }
    }

    /**
     * Add item to buffer
     */
    Push(item) {
        this.buffer[this.head + 1] := item
        this.head := Mod(this.head + 1, this.capacity)

        if (this.count < this.capacity) {
            this.count++
        } else {
            ; Buffer full, move tail forward (overwrite oldest)
            this.tail := Mod(this.tail + 1, this.capacity)
        }
    }

    /**
     * Remove and return oldest item
     */
    Pop() {
        if (this.count = 0)
            return ""

        item := this.buffer[this.tail + 1]
        this.tail := Mod(this.tail + 1, this.capacity)
        this.count--

        return item
    }

    /**
     * Peek at item without removing
     */
    Peek(offset := 0) {
        if (offset >= this.count)
            return ""

        index := Mod(this.tail + offset, this.capacity)
        return this.buffer[index + 1]
    }

    /**
     * Get all items in order
     */
    ToArray() {
        result := []

        Loop this.count {
            index := Mod(this.tail + A_Index - 1, this.capacity)
            result.Push(this.buffer[index + 1])
        }

        return result
    }

    IsFull() => this.count = this.capacity
    IsEmpty() => this.count = 0
    Size() => this.count
}

; Test circular buffer
buffer := CircularBuffer(5)

output := "CIRCULAR BUFFER DEMONSTRATION:`n`n"
output .= "Buffer Capacity: 5`n`n"

; Add items
items := ["A", "B", "C", "D", "E"]
output .= "Adding items: "
for item in items {
    buffer.Push(item)
    output .= item " "
}
output .= "`nBuffer: [" StrReplace(Format("{:s}", buffer.ToArray()), " ", ", ") "]`n"
output .= "Head: " buffer.head ", Tail: " buffer.tail ", Count: " buffer.Size() "`n`n"

; Add more (overwrite)
output .= "Adding F, G (overwrites A, B):`n"
buffer.Push("F")
buffer.Push("G")
output .= "Buffer: [" StrReplace(Format("{:s}", buffer.ToArray()), " ", ", ") "]`n"
output .= "Head: " buffer.head ", Tail: " buffer.tail ", Count: " buffer.Size() "`n`n"

; Pop items
output .= "Popping 2 items: " buffer.Pop() ", " buffer.Pop() "`n"
output .= "Buffer: [" StrReplace(Format("{:s}", buffer.ToArray()), " ", ", ") "]`n"
output .= "Head: " buffer.head ", Tail: " buffer.tail ", Count: " buffer.Size()

MsgBox(output, "Circular Buffer", "Icon!")

; ============================================================
; Example 2: Round-Robin Scheduler
; ============================================================

/**
 * Round-robin task scheduler
 */
class RoundRobinScheduler {
    __New(tasks) {
        this.tasks := tasks
        this.current := 0
        this.totalRounds := 0
    }

    /**
     * Get next task
     */
    Next() {
        task := this.tasks[this.current + 1]
        this.current := Mod(this.current + 1, this.tasks.Length)

        if (this.current = 0)
            this.totalRounds++

        return task
    }

    /**
     * Get task at offset from current
     */
    Peek(offset := 0) {
        index := Mod(this.current + offset, this.tasks.Length)
        return this.tasks[index + 1]
    }

    /**
     * Reset to beginning
     */
    Reset() {
        this.current := 0
        this.totalRounds := 0
    }

    /**
     * Get schedule for n iterations
     */
    GetSchedule(iterations) {
        schedule := []

        Loop iterations {
            schedule.Push(this.Next())
        }

        return schedule
    }
}

; Create scheduler with tasks
tasks := ["Task A", "Task B", "Task C", "Task D"]
scheduler := RoundRobinScheduler(tasks)

output := "ROUND-ROBIN SCHEDULER:`n`n"
output .= "Tasks: " StrReplace(Format("{:s}", tasks), " ", ", ") "`n`n"

; Get schedule for 15 iterations
schedule := scheduler.GetSchedule(15)

output .= "Execution Schedule (15 iterations):`n"
Loop 15 {
    round := Ceil(A_Index / tasks.Length)
    taskInRound := Mod(A_Index - 1, tasks.Length) + 1

    output .= Format("{:2d}. ", A_Index) schedule[A_Index]
    output .= " (Round " round ", Position " taskInRound ")`n"
}

output .= "`nTotal Rounds Completed: " scheduler.totalRounds

MsgBox(output, "Round-Robin Scheduler", "Icon!")

; ============================================================
; Example 3: Repeating Patterns
; ============================================================

/**
 * Generate repeating patterns using modulo
 */
class PatternGenerator {
    /**
     * Simple repeating sequence
     */
    static RepeatSequence(sequence, length) {
        result := []

        Loop length {
            index := Mod(A_Index - 1, sequence.Length) + 1
            result.Push(sequence[index])
        }

        return result
    }

    /**
     * Alternating pattern (binary)
     */
    static AlternatingBinary(length, start := 0) {
        result := []

        Loop length {
            value := Mod(A_Index - 1 + start, 2)
            result.Push(value)
        }

        return result
    }

    /**
     * Pattern with custom cycle length
     */
    static CyclicPattern(length, cycle, generator) {
        result := []

        Loop length {
            value := generator(Mod(A_Index - 1, cycle))
            result.Push(value)
        }

        return result
    }

    /**
     * Wave pattern (0, 1, 2, 1, 0, 1, 2, 1, ...)
     */
    static WavePattern(length, amplitude := 2) {
        result := []
        cycle := amplitude * 2

        Loop length {
            pos := Mod(A_Index - 1, cycle)
            value := pos <= amplitude ? pos : cycle - pos
            result.Push(value)
        }

        return result
    }
}

output := "REPEATING PATTERN GENERATION:`n`n"

; Simple sequence repetition
sequence := ["A", "B", "C"]
pattern := PatternGenerator.RepeatSequence(sequence, 15)
output .= "Repeating [A, B, C]:`n"
output .= StrReplace(Format("{:s}", pattern), " ", " ") "`n`n"

; Alternating binary
binary := PatternGenerator.AlternatingBinary(20)
output .= "Alternating Binary (0, 1):`n"
output .= StrReplace(Format("{:s}", binary), " ", " ") "`n`n"

; Wave pattern
wave := PatternGenerator.WavePattern(20, 3)
output .= "Wave Pattern (amplitude 3):`n"
output .= StrReplace(Format("{:s}", wave), " ", " ") "`n`n"

; Custom pattern
custom := PatternGenerator.CyclicPattern(16, 4, (n) => n * n)
output .= "Custom Cycle (f(x) = x², cycle=4):`n"
output .= StrReplace(Format("{:s}", custom), " ", " ")

MsgBox(output, "Pattern Generation", "Icon!")

; ============================================================
; Example 4: Rotation Algorithms
; ============================================================

/**
 * Various rotation operations using modulo
 */
class Rotation {
    /**
     * Rotate array left (logical rotation)
     */
    static RotateLeft(array, positions) {
        result := []
        len := array.Length
        positions := Mod(positions, len)  ; Normalize positions

        Loop len {
            sourceIndex := Mod(A_Index - 1 + positions, len) + 1
            result.Push(array[sourceIndex])
        }

        return result
    }

    /**
     * Rotate array right
     */
    static RotateRight(array, positions) {
        return Rotation.RotateLeft(array, -positions)
    }

    /**
     * Rotate string
     */
    static RotateString(str, positions) {
        len := StrLen(str)
        positions := Mod(Mod(positions, len) + len, len)

        return SubStr(str, positions + 1) SubStr(str, 1, positions)
    }

    /**
     * Circular shift bits (simulation with array)
     */
    static CircularShift(bits, positions, width := 8) {
        positions := Mod(positions, width)
        result := []

        Loop width {
            sourceIndex := Mod(A_Index - 1 + positions, width) + 1
            result.Push(bits[sourceIndex])
        }

        return result
    }
}

output := "ROTATION ALGORITHMS:`n`n"

; Array rotation
original := [1, 2, 3, 4, 5, 6, 7, 8]
output .= "Original Array: " StrReplace(Format("{:s}", original), " ", ", ") "`n`n"

rotations := [-3, -1, 0, 1, 3, 5, 10]
for rot in rotations {
    rotated := Rotation.RotateLeft(original, rot)
    output .= "Rotate " Format("{:+3d}", rot) ": "
    output .= StrReplace(Format("{:s}", rotated), " ", ", ") "`n"
}

; String rotation
output .= "`nString Rotation:`n"
str := "ABCDEFGH"
output .= "Original: " str "`n`n"

for rot in [1, 2, 3, -1, -2] {
    rotated := Rotation.RotateString(str, rot)
    output .= "Rotate " Format("{:+2d}", rot) ": " rotated "`n"
}

MsgBox(output, "Rotation Operations", "Icon!")

; ============================================================
; Example 5: Day of Week and Calendar Patterns
; ============================================================

/**
 * Calendar and day-of-week calculations
 */
class CalendarCycles {
    static DAYS := ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    static MONTHS := ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    /**
     * Get day name from day number
     */
    static DayName(dayNum) {
        index := Mod(dayNum, 7) + 1
        return CalendarCycles.DAYS[index]
    }

    /**
     * Add days and get new day
     */
    static AddDays(startDay, daysToAdd) {
        newDay := Mod(startDay + daysToAdd, 7)
        return CalendarCycles.DayName(newDay)
    }

    /**
     * Days between two days of week
     */
    static DaysBetween(fromDay, toDay) {
        diff := toDay - fromDay
        return Mod(diff + 7, 7)
    }

    /**
     * Month cycling
     */
    static MonthName(monthNum) {
        index := Mod(monthNum - 1, 12) + 1
        return CalendarCycles.MONTHS[index]
    }

    /**
     * Add months
     */
    static AddMonths(startMonth, monthsToAdd) {
        newMonth := Mod(startMonth - 1 + monthsToAdd, 12) + 1
        return CalendarCycles.MonthName(newMonth)
    }
}

output := "CALENDAR CYCLIC PATTERNS:`n`n"

; Day of week cycling
output .= "Day of Week Cycling (starting from Monday=1):`n"
startDay := 1  ; Monday
additions := [0, 3, 7, 10, 14, 30, 100]

for add in additions {
    dayName := CalendarCycles.AddDays(startDay, add)
    output .= "  Monday + " Format("{:3d}", add) " days = " dayName "`n"
}

; Days between
output .= "`nDays Until (from Monday):`n"
dayPairs := [{
    from: "Monday", to: "Wednesday", fromN: 1, toN: 3 }, {
        from: "Monday", to: "Friday", fromN: 1, toN: 5 }, {
            from: "Monday", to: "Sunday", fromN: 1, toN: 0 }, {
                from: "Friday", to: "Monday", fromN: 5, toN: 1
            }
]

for pair in dayPairs {
    days := CalendarCycles.DaysBetween(pair.fromN, pair.toN)
    output .= "  " pair.from " to " pair.to ": " days " days`n"
}

; Month cycling
output .= "`nMonth Cycling (from January):`n"
monthAdds := [0, 3, 6, 12, 15, 24]

for add in monthAdds {
    monthName := CalendarCycles.AddMonths(1, add)
    output .= "  Jan + " Format("{:2d}", add) " months = " monthName "`n"
}

MsgBox(output, "Calendar Cycles", "Icon!")

; ============================================================
; Example 6: State Machine with Cyclic States
; ============================================================

/**
 * Traffic light state machine
 */
class TrafficLight {
    static STATES := ["Red", "Yellow", "Green"]
    static DURATIONS := [30, 5, 25]  ; seconds

    __New() {
        this.currentState := 0
        this.elapsed := 0
    }

    /**
     * Get current state name
     */
    State() {
        return TrafficLight.STATES[this.currentState + 1]
    }

    /**
     * Advance to next state
     */
    Next() {
        this.currentState := Mod(this.currentState + 1, TrafficLight.STATES.Length)
        this.elapsed := 0
        return this.State()
    }

    /**
     * Update with time
     */
    Update(seconds) {
        this.elapsed += seconds
        duration := TrafficLight.DURATIONS[this.currentState + 1]

        if (this.elapsed >= duration) {
            this.Next()
        }

        return this.State()
    }

    /**
     * Get state at offset
     */
    PeekState(offset) {
        index := Mod(this.currentState + offset, TrafficLight.STATES.Length)
        return TrafficLight.STATES[index + 1]
    }

    /**
     * Simulate cycle
     */
    SimulateCycle(totalSeconds, interval) {
        timeline := []
        time := 0

        while (time < totalSeconds) {
            state := this.Update(interval)
            timeline.Push({ time: time, state: state, elapsed: this.elapsed })
            time += interval
        }

        return timeline
    }
}

light := TrafficLight()
timeline := light.SimulateCycle(120, 5)

output := "TRAFFIC LIGHT STATE MACHINE:`n`n"
output .= "States: Red (30s) → Yellow (5s) → Green (25s)`n"
output .= "Cycle Time: 60 seconds`n`n"

output .= "Time   State     Elapsed`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for entry in timeline {
    output .= Format("{:4d}s", entry.time)
    output .= Format("  {:-8s}", entry.state)
    output .= Format("{:6d}s", entry.elapsed)
    output .= "`n"
}

MsgBox(output, "State Machine", "Icon!")

; ============================================================
; Example 7: Periodic Functions and Waveforms
; ============================================================

/**
 * Generate periodic waveforms using modulo
 */
class Waveforms {
    /**
     * Square wave (0 or 1)
     */
    static SquareWave(x, period) {
        return Mod(Floor(x / (period / 2)), 2)
    }

    /**
     * Sawtooth wave (0 to period-1, repeating)
     */
    static SawtoothWave(x, period) {
        return Mod(x, period)
    }

    /**
     * Triangle wave
     */
    static TriangleWave(x, period) {
        pos := Mod(x, period)
        halfPeriod := period / 2

        return pos < halfPeriod ? pos : period - pos
    }

    /**
     * Step function with multiple levels
     */
    static StepFunction(x, period, levels) {
        stepSize := period / levels
        step := Floor(Mod(x, period) / stepSize)
        return Min(step, levels - 1)
    }

    /**
     * Generate waveform samples
     */
    static GenerateSamples(waveFunc, period, samples) {
        result := []

        Loop samples {
            x := A_Index - 1
            y := waveFunc(x, period)
            result.Push(y)
        }

        return result
    }
}

output := "PERIODIC WAVEFORMS:`n`n"

period := 8
samples := 24

; Square wave
square := Waveforms.GenerateSamples((x, p) => Waveforms.SquareWave(x, p), period, samples)
output .= "Square Wave (period " period "):`n"
output .= StrReplace(Format("{:s}", square), " ", " ") "`n`n"

; Sawtooth wave
sawtooth := Waveforms.GenerateSamples((x, p) => Waveforms.SawtoothWave(x, p), period, samples)
output .= "Sawtooth Wave (period " period "):`n"
output .= StrReplace(Format("{:s}", sawtooth), " ", " ") "`n`n"

; Triangle wave
triangle := Waveforms.GenerateSamples((x, p) => Waveforms.TriangleWave(x, p), period, samples)
output .= "Triangle Wave (period " period "):`n"
output .= StrReplace(Format("{:s}", triangle), " ", " ") "`n`n"

; Step function
steps := Waveforms.GenerateSamples((x, p) => Waveforms.StepFunction(x, p, 4), period, samples)
output .= "Step Function (4 levels, period " period "):`n"
output .= StrReplace(Format("{:s}", steps), " ", " ")

MsgBox(output, "Waveforms", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
            (
            MODULO IN CYCLIC PATTERNS REFERENCE:

            Circular Indexing:
            index = Mod(position, size)
            Wraps position to valid array index

            Rotation:
            rotated[i] = original[Mod(i + shift, length)]
            Shift elements cyclically

            Round-Robin:
            current = Mod(current + 1, n)
            Cycle through n items

            Day of Week:
            day = Mod(dayNumber, 7)
            0=Sunday, 1=Monday, ..., 6=Saturday

            Periodic Functions:
            y = f(Mod(x, period))
            Creates repeating pattern

            State Machines:
            nextState = Mod(currentState + 1, numStates)
            Cycle through finite states

            Common Patterns:
            • Circular Buffer: Mod(head++, capacity)
            • Alternating: Mod(n, 2) → 0, 1, 0, 1, ...
            • Every Nth: Mod(i, N) = 0
            • Rotation: Mod(i + shift, length)
            • Wraparound: Mod(value, max)

            Applications:
            ✓ Circular queues/buffers
            ✓ Round-robin scheduling
            ✓ Calendar calculations
            ✓ Traffic light controllers
            ✓ Game turn systems
            ✓ Animation frames
            ✓ Waveform generation
            ✓ Pattern matching

            Benefits:
            • Eliminates array bounds checking
            • No data copying for rotation
            • Constant time operations
            • Memory efficient
            • Natural for periodic data

            Key Properties:
            • Mod(a, n) ∈ [0, n-1] for positive n
            • Mod(a + kn, n) = Mod(a, n)
            • Period = divisor value
            )"

MsgBox(info, "Cyclic Patterns Reference", "Icon!")
