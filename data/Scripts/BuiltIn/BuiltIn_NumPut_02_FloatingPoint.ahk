#Requires AutoHotkey v2.0

/**
 * BuiltIn_NumPut_02_FloatingPoint.ahk
 * 
 * DESCRIPTION:
 * Comprehensive guide to writing floating-point numbers using NumPut.
 * Covers Float (32-bit) and Double (64-bit) types with precision handling.
 * 
 * FEATURES:
 * - Writing Float (single precision) values
 * - Writing Double (double precision) values
 * - Precision and rounding considerations
 * - Special floating-point values
 * - Scientific notation handling
 * - Practical data serialization
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - NumPut Function
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - NumPut with "Float" type (4 bytes, IEEE 754 single precision)
 * - NumPut with "Double" type (8 bytes, IEEE 754 double precision)
 * - Chaining float writes
 * - Mixed integer and float structures
 * - Binary float representation
 * 
 * LEARNING POINTS:
 * 1. Float uses 4 bytes, Double uses 8 bytes
 * 2. NumPut handles IEEE 754 format automatically
 * 3. Precision is limited by type (Float ~7 digits, Double ~15 digits)
 * 4. Special values (Infinity, NaN) can be written
 * 5. Proper type selection affects accuracy and size
 */

; ================================================================================================
; EXAMPLE 1: Basic Float and Double Writing
; ================================================================================================

Example1_BasicFloatWriting() {
    buf := Buffer(32)

    ; Write Float values
    NumPut("Float", 3.14159, buf, 0)
    NumPut("Float", -273.15, buf, 4)
    NumPut("Float", 0.00001, buf, 8)
    NumPut("Float", 999999.9, buf, 12)

    ; Write Double values
    NumPut("Double", 3.141592653589793, buf, 16)
    NumPut("Double", -273.15, buf, 24)

    ; Read back and compare
    result := "Basic Float and Double Writing:`n`n"
    result .= "Float Values (4 bytes each):`n"
    result .= "  Pi: " . Format("{:.6f}", NumGet(buf, 0, "Float")) . "`n"
    result .= "  Abs Zero: " . Format("{:.2f}", NumGet(buf, 4, "Float")) . "°C`n"
    result .= "  Small: " . Format("{:.8f}", NumGet(buf, 8, "Float")) . "`n"
    result .= "  Large: " . Format("{:.1f}", NumGet(buf, 12, "Float")) . "`n`n"

    result .= "Double Values (8 bytes each):`n"
    result .= "  Pi: " . Format("{:.15f}", NumGet(buf, 16, "Double")) . "`n"
    result .= "  Abs Zero: " . Format("{:.2f}", NumGet(buf, 24, "Double")) . "°C"

    MsgBox(result, "Example 1: Basic Float Writing", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Creating Float Arrays
; ================================================================================================

Example2_FloatArrays() {
    count := 10
    buf := Buffer(count * 4)

    ; Generate and write temperature data
    baseTemp := 20.0
    loop count {
        temp := baseTemp + Random(-5.0, 5.0)
        NumPut("Float", temp, buf, (A_Index - 1) * 4)
    }

    ; Read and analyze
    temps := []
    sum := 0.0
    min := 999.9
    max := -999.9

    loop count {
        temp := NumGet(buf, (A_Index - 1) * 4, "Float")
        temps.Push(temp)
        sum += temp
        if temp < min
            min := temp
        if temp > max
            max := temp
    }

    avg := sum / count

    ; Display results
    result := "Float Array Writing:`n`n"
    result .= "Temperature Data (10 readings):`n  "
    for temp in temps {
        result .= Format("{:.1f}", temp) . "°C "
        if Mod(A_Index, 5) = 0
            result .= "`n  "
    }

    result .= "`n`nStatistics:`n"
    result .= "  Min: " . Format("{:.1f}", min) . "°C`n"
    result .= "  Max: " . Format("{:.1f}", max) . "°C`n"
    result .= "  Avg: " . Format("{:.2f}", avg) . "°C`n"
    result .= "  Range: " . Format("{:.1f}", max - min) . "°C"

    MsgBox(result, "Example 2: Float Arrays", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Mixed Integer and Float Structures
; ================================================================================================

Example3_MixedStructures() {
    ; Product structure: id(int) + price(float) + quantity(int)
    recordSize := 12
    recordCount := 5
    buf := Buffer(recordSize * recordCount)

    products := [{
        id: 1001, price: 49.99, quantity: 100 }, {
            id: 1002, price: 29.99, quantity: 250 }, {
                id: 1003, price: 89.99, quantity: 50 }, {
                    id: 1004, price: 15.99, quantity: 500 }, {
                        id: 1005, price: 199.99, quantity: 25
                    }
    ]

    ; Write records
    loop recordCount {
        offset := (A_Index - 1) * recordSize
        product := products[A_Index]

        NumPut("Int", product.id, buf, offset)
        NumPut("Float", product.price, buf, offset + 4)
        NumPut("Int", product.quantity, buf, offset + 8)
    }

    ; Read and calculate
    totalValue := 0.0
    result := "Mixed Structure Writing:`n`n"

    loop recordCount {
        offset := (A_Index - 1) * recordSize
        id := NumGet(buf, offset, "Int")
        price := NumGet(buf, offset + 4, "Float")
        quantity := NumGet(buf, offset + 8, "Int")
        value := price * quantity
        totalValue += value

        result .= "Product " . id . ":`n"
        result .= "  Price: $" . Format("{:.2f}", price) . "`n"
        result .= "  Qty: " . quantity . "`n"
        result .= "  Value: $" . Format("{:.2f}", value) . "`n"
    }

    result .= "`nTotal Inventory: $" . Format("{:,.2f}", totalValue)

    MsgBox(result, "Example 3: Mixed Structures", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Scientific Data Recording
; ================================================================================================

Example4_ScientificData() {
    ; Record structure: timestamp(double) + temp(float) + pressure(float)
    recordSize := 16
    recordCount := 5
    buf := Buffer(recordSize * recordCount)

    baseTime := 1700000000.0
    loop recordCount {
        offset := (A_Index - 1) * recordSize

        NumPut("Double", baseTime + (A_Index - 1) * 60.0, buf, offset)
        NumPut("Float", 20.0 + Random(-2.0, 2.0), buf, offset + 8)
        NumPut("Float", 1013.25 + Random(-5.0, 5.0), buf, offset + 12)
    }

    ; Read and display
    result := "Scientific Data Writing:`n`n"
    result .= "Measurement Records (" . recordCount . " entries):`n`n"

    loop recordCount {
        offset := (A_Index - 1) * recordSize
        timestamp := NumGet(buf, offset, "Double")
        temp := NumGet(buf, offset + 8, "Float")
        pressure := NumGet(buf, offset + 12, "Float")

        result .= "Record " . A_Index . ":`n"
        result .= "  Time: " . Format("{:.0f}", timestamp) . "`n"
        result .= "  Temp: " . Format("{:.2f}", temp) . "°C`n"
        result .= "  Pressure: " . Format("{:.2f}", pressure) . " hPa`n"
        if A_Index < recordCount
            result .= "`n"
    }

    MsgBox(result, "Example 4: Scientific Data", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Precision Handling
; ================================================================================================

Example5_PrecisionHandling() {
    buf := Buffer(32)

    ; Test values showing precision differences
    testValue := 1.0 / 3.0  ; 0.333...

    ; Write as Float and Double
    NumPut("Float", testValue, buf, 0)
    NumPut("Double", testValue, buf, 4)

    ; Large number testing
    largeValue := 123456789.123456789

    NumPut("Float", largeValue, buf, 12)
    NumPut("Double", largeValue, buf, 16)

    ; Small number testing
    smallValue := 0.123456789012345

    NumPut("Float", smallValue, buf, 24)
    NumPut("Double", smallValue, buf, 28)

    ; Read back and compare
    result := "Precision Handling:`n`n"

    result .= "1/3 (0.333...):`n"
    result .= "  Float:  " . Format("{:.15f}", NumGet(buf, 0, "Float")) . "`n"
    result .= "  Double: " . Format("{:.15f}", NumGet(buf, 4, "Double")) . "`n`n"

    result .= "123456789.123456789:`n"
    result .= "  Float:  " . Format("{:.6f}", NumGet(buf, 12, "Float")) . "`n"
    result .= "  Double: " . Format("{:.15f}", NumGet(buf, 16, "Double")) . "`n`n"

    result .= "0.123456789012345:`n"
    result .= "  Float:  " . Format("{:.15f}", NumGet(buf, 24, "Float")) . "`n"
    result .= "  Double: " . Format("{:.15f}", NumGet(buf, 28, "Double")) . "`n`n"

    result .= "Conclusion: Double maintains higher precision!"

    MsgBox(result, "Example 5: Precision Handling", "Icon!")
}

; ================================================================================================
; EXAMPLE 6: Coordinate System Data
; ================================================================================================

Example6_CoordinateData() {
    ; 3D point structure: x(float) + y(float) + z(float)
    pointSize := 12
    pointCount := 8  ; Vertices of a cube
    buf := Buffer(pointSize * pointCount)

    ; Cube vertices
    vertices := [{
        x: 0.0, y: 0.0, z: 0.0 }, {
            x: 1.0, y: 0.0, z: 0.0 }, {
                x: 1.0, y: 1.0, z: 0.0 }, {
                    x: 0.0, y: 1.0, z: 0.0 }, {
                        x: 0.0, y: 0.0, z: 1.0 }, {
                            x: 1.0, y: 0.0, z: 1.0 }, {
                                x: 1.0, y: 1.0, z: 1.0 }, {
                                    x: 0.0, y: 1.0, z: 1.0
                                }
    ]

    ; Write vertices
    loop pointCount {
        offset := (A_Index - 1) * pointSize
        v := vertices[A_Index]

        NumPut("Float", v.x, buf, offset)
        NumPut("Float", v.y, buf, offset + 4)
        NumPut("Float", v.z, buf, offset + 8)
    }

    ; Read back and display
    result := "3D Coordinate System Data:`n`n"
    result .= "Cube Vertices (unit cube):`n`n"

    loop pointCount {
        offset := (A_Index - 1) * pointSize
        x := NumGet(buf, offset, "Float")
        y := NumGet(buf, offset + 4, "Float")
        z := NumGet(buf, offset + 8, "Float")

        result .= "V" . A_Index . ": ("
        result .= Format("{:.1f}", x) . ", "
        result .= Format("{:.1f}", y) . ", "
        result .= Format("{:.1f}", z) . ")`n"
    }

    result .= "`nTotal Size: " . buf.Size . " bytes"

    MsgBox(result, "Example 6: Coordinate Data", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
                                                (
                                                NumPut Floating-Point Examples

                                                1. Basic Float and Double Writing
                                                2. Creating Float Arrays
                                                3. Mixed Integer and Float Structures
                                                4. Scientific Data Recording
                                                5. Precision Handling
                                                6. 3D Coordinate System Data

                                                Select an example (1-6) or press Cancel to exit:
                                                )"

    choice := InputBox(menu, "NumPut Floating-Point Examples", "w450 h320")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_BasicFloatWriting()
        case "2": Example2_FloatArrays()
        case "3": Example3_MixedStructures()
        case "4": Example4_ScientificData()
        case "5": Example5_PrecisionHandling()
        case "6": Example6_CoordinateData()
        default: MsgBox("Invalid selection. Please choose 1-6.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
