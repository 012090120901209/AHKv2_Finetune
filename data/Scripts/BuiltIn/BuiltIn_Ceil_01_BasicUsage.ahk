#Requires AutoHotkey v2.0

/**
* BuiltIn_Ceil_01_BasicUsage.ahk
*
* DESCRIPTION:
* Basic usage examples of Ceil() function for rounding up to the nearest integer
* and ceiling operations in various contexts
*
* FEATURES:
* - Round up to nearest integer
* - Always rounds toward positive infinity
* - Positive and negative number handling
* - Decimal ceiling operations
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/Ceil.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Ceil() function
* - Mathematical ceiling operations
* - Comparison with Floor() and Round()
* - Practical rounding applications
*
* LEARNING POINTS:
* 1. Ceil() always rounds up to next integer
* 2. Ceil(3.1) = 4, Ceil(3.9) = 4
* 3. For negative numbers, rounds toward zero
* 4. Ceil(-2.5) = -2 (up on number line)
* 5. Useful when you need to "round up" quantities
*/

; ============================================================
; Example 1: Basic Ceiling Operation
; ============================================================

num1 := 3.1
num2 := 3.5
num3 := 3.9
num4 := 4.0

MsgBox("Basic Ceiling (Round Up):`n`n"
. "Ceil(" num1 ") = " Ceil(num1) "`n"
. "Ceil(" num2 ") = " Ceil(num2) "`n"
. "Ceil(" num3 ") = " Ceil(num3) "`n"
. "Ceil(" num4 ") = " Ceil(num4) "`n`n"
. "Ceil always rounds UP to next integer`n"
. "Even 3.1 rounds up to 4",
"Basic Ceil Example", "Icon!")

; ============================================================
; Example 2: Negative Numbers
; ============================================================

negNum1 := -2.1
negNum2 := -2.5
negNum3 := -2.9
negNum4 := -3.0

MsgBox("Ceiling with Negative Numbers:`n`n"
. "Ceil(" negNum1 ") = " Ceil(negNum1) "`n"
. "Ceil(" negNum2 ") = " Ceil(negNum2) "`n"
. "Ceil(" negNum3 ") = " Ceil(negNum3) "`n"
. "Ceil(" negNum4 ") = " Ceil(negNum4) "`n`n"
. "'Up' means toward positive infinity`n"
. "So -2.9 rounds up to -2, not -3",
"Negative Number Ceiling", "Icon!")

; ============================================================
; Example 3: Comparison with Round and Floor
; ============================================================

testValue := 3.7

result := "Comparing Rounding Functions:`n`n"
result .= "Value: " testValue "`n`n"
result .= "Floor(" testValue ") = " Floor(testValue) " (always down)`n"
result .= "Round(" testValue ") = " Round(testValue) " (nearest)`n"
result .= "Ceil(" testValue ")  = " Ceil(testValue) " (always up)`n`n"

testValue2 := -3.7
result .= "`nValue: " testValue2 "`n`n"
result .= "Floor(" testValue2 ") = " Floor(testValue2) " (more negative)`n"
result .= "Round(" testValue2 ") = " Round(testValue2) " (nearest)`n"
result .= "Ceil(" testValue2 ")  = " Ceil(testValue2) " (less negative)"

MsgBox(result, "Function Comparison", "Icon!")

; ============================================================
; Example 4: Division with Ceiling (Remainder Handling)
; ============================================================

/**
* Divide and round up (useful for pagination, grouping)
*
* @param {Number} total - Total items
* @param {Number} perGroup - Items per group
* @returns {Number} - Number of groups needed
*/
DivideAndRoundUp(total, perGroup) {
    return Ceil(total / perGroup)
}

; How many boxes needed?
totalItems := 47
itemsPerBox := 10
boxesNeeded := DivideAndRoundUp(totalItems, itemsPerBox)

MsgBox("Packing Problem:`n`n"
. "Total Items: " totalItems "`n"
. "Items per Box: " itemsPerBox "`n"
. "Boxes Needed: " boxesNeeded "`n`n"
. "Calculation: Ceil(" totalItems " / " itemsPerBox ")`n"
. "= Ceil(4.7) = 5 boxes`n`n"
. "Even partial boxes count as a full box needed",
"Division with Ceiling", "Icon!")

; ============================================================
; Example 5: Minimum Items Calculator
; ============================================================

/**
* Calculate minimum whole units needed
*
* @param {Number} required - Amount required
* @param {Number} unitSize - Size of each unit
* @returns {Object} - Purchase calculation
*/
CalculateMinimumUnits(required, unitSize) {
    unitsNeeded := Ceil(required / unitSize)
    totalPurchased := unitsNeeded * unitSize
    excess := totalPurchased - required

    return {
        required: required,
        unitSize: unitSize,
        unitsNeeded: unitsNeeded,
        totalPurchased: totalPurchased,
        excess: excess
    }
}

; Buying rope example
ropeRequired := 37.5  ; meters
ropePerRoll := 10     ; meters per roll

ropeCalc := CalculateMinimumUnits(ropeRequired, ropePerRoll)

MsgBox("Purchasing Calculation:`n`n"
. "Rope Required: " ropeCalc.required " meters`n"
. "Roll Size: " ropeCalc.unitSize " meters`n`n"
. "Rolls to Buy: " ropeCalc.unitsNeeded "`n"
. "Total Purchased: " ropeCalc.totalPurchased " meters`n"
. "Excess: " ropeCalc.excess " meters`n`n"
. "Can't buy partial rolls, so round up!",
"Minimum Units", "Icon!")

; ============================================================
; Example 6: Time Rounding Up
; ============================================================

/**
* Round time up to next interval
*
* @param {Number} minutes - Time in minutes
* @param {Number} interval - Interval to round to (default: 15)
* @returns {Object} - Rounded time info
*/
RoundTimeUp(minutes, interval := 15) {
    roundedMinutes := Ceil(minutes / interval) * interval
    added := roundedMinutes - minutes

    return {
        original: minutes,
        interval: interval,
        rounded: roundedMinutes,
        added: added,
        formatted: FormatMinutes(roundedMinutes)
    }
}

FormatMinutes(totalMinutes) {
    hours := Floor(totalMinutes / 60)
    minutes := Mod(totalMinutes, 60)
    return Format("{1}h {2}m", hours, minutes)
}

; Parking time example
parkingTime := 67  ; minutes
roundedTime := RoundTimeUp(parkingTime, 15)

MsgBox("Parking Time Rounding:`n`n"
. "Actual Time: " roundedTime.original " minutes`n"
. "Billing Interval: " roundedTime.interval " minutes`n`n"
. "Billed Time: " roundedTime.rounded " minutes (" roundedTime.formatted ")`n"
. "Extra Time Charged: " roundedTime.added " minutes`n`n"
. "Many services bill in minimum intervals",
"Time Rounding", "Icon!")

; Multiple examples
timesToRound := [8, 23, 31, 45, 52]

output := "Rounding to 15-Minute Intervals:`n`n"

for time in timesToRound {
    rounded := RoundTimeUp(time, 15)
    output .= Format("{1} min → {2} min (+{3})`n",
    rounded.original, rounded.rounded, rounded.added)
}

MsgBox(output, "Billing Intervals", "Icon!")

; ============================================================
; Example 7: Capacity Planning
; ============================================================

/**
* Calculate resources needed based on capacity
*
* @param {Number} total - Total demand
* @param {Number} capacity - Capacity per resource
* @returns {Object} - Resource planning
*/
PlanCapacity(total, capacity) {
    resourcesNeeded := Ceil(total / capacity)
    totalCapacity := resourcesNeeded * capacity
    utilizationPercent := (total / totalCapacity) * 100

    return {
        demand: total,
        perResource: capacity,
        resourcesNeeded: resourcesNeeded,
        totalCapacity: totalCapacity,
        utilization: Round(utilizationPercent, 1)
    }
}

; Server capacity example
scenarios := [
{
    name: "Web Servers", demand: 450, capacity: 100},
    {
        name: "Database Connections", demand: 1234, capacity: 500},
        {
            name: "Seats in Conference Rooms", demand: 87, capacity: 25
        }
        ]

        output := "Capacity Planning Analysis:`n`n"

        for scenario in scenarios {
            plan := PlanCapacity(scenario.demand, scenario.capacity)

            output .= scenario.name . ":`n"
            output .= "  Demand: " plan.demand "`n"
            output .= "  Capacity per unit: " plan.perResource "`n"
            output .= "  Units needed: " plan.resourcesNeeded "`n"
            output .= "  Total capacity: " plan.totalCapacity "`n"
            output .= "  Utilization: " plan.utilization "%`n`n"
        }

        MsgBox(output, "Capacity Planning", "Icon!")

        ; ============================================================
        ; Reference Information
        ; ============================================================

        info := "
        (
        CEIL() FUNCTION REFERENCE:

        Syntax:
        Ceiling := Ceil(Number)

        Parameters:
        Number - Any number (integer or float)

        Return Value:
        Integer - The smallest integer ≥ Number

        Mathematical Definition:
        Ceil(x) = smallest integer n where n ≥ x

        Behavior:
        • Always rounds UP (toward positive infinity)
        • Returns same value if already an integer
        • For negatives, rounds toward zero

        Examples:
        Ceil(3.1) → 4
        Ceil(3.5) → 4
        Ceil(3.9) → 4
        Ceil(4.0) → 4
        Ceil(-2.1) → -2
        Ceil(-2.9) → -2
        Ceil(0) → 0

        Comparison:
        Value: 3.7
        ───────────────────────
        Floor(3.7) → 3 (down)
        Round(3.7) → 4 (nearest)
        Ceil(3.7)  → 4 (up)

        Value: -2.3
        ───────────────────────
        Floor(-2.3) → -3 (down = more negative)
        Round(-2.3) → -2 (nearest)
        Ceil(-2.3)  → -2 (up = less negative)

        Common Use Cases:
        ✓ Pagination (pages needed)
        ✓ Resource allocation (servers needed)
        ✓ Packing problems (boxes needed)
        ✓ Capacity planning (units required)
        ✓ Billing intervals (round up to interval)
        ✓ Minimum purchase quantities
        ✓ Dividing items into groups

        Division Formula:
        groups_needed = Ceil(total_items / items_per_group)

        Example: 47 items, 10 per box
        Ceil(47 / 10) = Ceil(4.7) = 5 boxes

        Key Insight:
        Use Ceil() when you can't have partial units
        and must round UP to whole numbers.

        - Can't buy 4.7 boxes → Buy 5
        - Can't have 3.2 servers → Need 4
        - Can't use 2.1 rooms → Reserve 3
        )"

        MsgBox(info, "Ceil() Reference", "Icon!")
