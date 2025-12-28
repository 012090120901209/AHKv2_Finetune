#Requires AutoHotkey v2.0

/**
 * BuiltIn_NumPut_04_Structures.ahk
 * 
 * DESCRIPTION:
 * Comprehensive guide to writing complex C structures using NumPut.
 * Covers structure packing, nested structures, and Windows API structures.
 * 
 * FEATURES:
 * - Writing complex multi-field structures
 * - Structure packing and alignment
 * - Nested structure creation
 * - Arrays within structures
 * - Windows API structure creation
 * - Bitfield packing
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - NumPut, Structures
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Sequential field writing
 * - Offset calculation for structure fields
 * - Mixed data type structures
 * - Platform-aware structure layouts
 * - Structure arrays
 * 
 * LEARNING POINTS:
 * 1. Structure layout must match expected binary format
 * 2. Field order and alignment are critical
 * 3. NumPut can build structures field-by-field
 * 4. Proper offset calculation prevents data corruption
 * 5. Windows API structures have specific requirements
 */

; ================================================================================================
; EXAMPLE 1: Simple Structure Creation
; ================================================================================================

Example1_SimpleStructure() {
    ; Employee: id(int) + salary(double) + dept(short) + active(char)
    buf := Buffer(16)

    NumPut("Int", 12345, buf, 0)
    NumPut("Double", 75500.50, buf, 4)
    NumPut("Short", 42, buf, 12)
    NumPut("Char", 1, buf, 14)

    ; Verify
    result := "Simple Structure Creation:`n`n"
    result .= "Employee Record (16 bytes):`n"
    result .= "  ID: " . NumGet(buf, 0, "Int") . "`n"
    result .= "  Salary: $" . Format("{:,.2f}", NumGet(buf, 4, "Double")) . "`n"
    result .= "  Department: " . NumGet(buf, 12, "Short") . "`n"
    result .= "  Active: " . (NumGet(buf, 14, "Char") ? "Yes" : "No")

    MsgBox(result, "Example 1: Simple Structure", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Nested Structure Writing
; ================================================================================================

Example2_NestedStructures() {
    ; Rectangle with two Point structures
    buf := Buffer(20)

    ; TopLeft Point (100, 50)
    NumPut("Int", 100, buf, 0)
    NumPut("Int", 50, buf, 4)

    ; BottomRight Point (400, 300)
    NumPut("Int", 400, buf, 8)
    NumPut("Int", 300, buf, 12)

    ; Color (RGBA)
    NumPut("Int", 0xFF0000FF, buf, 16)

    ; Calculate dimensions
    width := NumGet(buf, 8, "Int") - NumGet(buf, 0, "Int")
    height := NumGet(buf, 12, "Int") - NumGet(buf, 4, "Int")

    result := "Nested Structure Writing:`n`n"
    result .= "Rectangle (20 bytes):`n"
    result .= "  TopLeft: (" . NumGet(buf, 0, "Int") . ", "
        . NumGet(buf, 4, "Int") . ")`n"
    result .= "  BottomRight: (" . NumGet(buf, 8, "Int") . ", "
        . NumGet(buf, 12, "Int") . ")`n"
    result .= "  Color: 0x" . Format("{:08X}", NumGet(buf, 16, "Int")) . "`n`n"
    result .= "Dimensions:`n"
    result .= "  Width: " . width . "`n"
    result .= "  Height: " . height . "`n"
    result .= "  Area: " . (width * height)

    MsgBox(result, "Example 2: Nested Structures", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Structure with Array Field
; ================================================================================================

Example3_StructureWithArray() {
    ; SensorData: id(int) + readings[10](float) + timestamp(int)
    buf := Buffer(48)

    NumPut("Int", 2001, buf, 0)

    ; Write 10 temperature readings
    readings := [20.5, 21.2, 21.8, 22.1, 22.5, 23.0, 23.2, 22.8, 22.3, 21.9]
    loop 10 {
        NumPut("Float", readings[A_Index], buf, 4 + (A_Index - 1) * 4)
    }

    NumPut("Int", 1700000000, buf, 44)

    ; Calculate statistics
    sum := 0.0
    loop 10 {
        sum += NumGet(buf, 4 + (A_Index - 1) * 4, "Float")
    }
    avg := sum / 10

    result := "Structure with Array Field:`n`n"
    result .= "SensorData (48 bytes):`n"
    result .= "  Sensor ID: " . NumGet(buf, 0, "Int") . "`n"
    result .= "  Timestamp: " . NumGet(buf, 44, "Int") . "`n`n"
    result .= "Readings: "
    loop 10 {
        result .= Format("{:.1f}", NumGet(buf, 4 + (A_Index - 1) * 4, "Float")) . " "
    }
    result .= "`n`nAverage: " . Format("{:.2f}", avg) . "°C"

    MsgBox(result, "Example 3: Structure with Array", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Creating Structure Arrays
; ================================================================================================

Example4_StructureArrays() {
    ; Product: id(int) + price(float) + quantity(int)
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

    ; Write structure array
    loop recordCount {
        offset := (A_Index - 1) * recordSize
        p := products[A_Index]

        NumPut("Int", p.id, buf, offset)
        NumPut("Float", p.price, buf, offset + 4)
        NumPut("Int", p.quantity, buf, offset + 8)
    }

    ; Calculate total value
    totalValue := 0.0
    loop recordCount {
        offset := (A_Index - 1) * recordSize
        price := NumGet(buf, offset + 4, "Float")
        qty := NumGet(buf, offset + 8, "Int")
        totalValue += price * qty
    }

    result := "Structure Array Creation:`n`n"
    result .= recordCount . " products × " . recordSize . " bytes = "
        . buf.Size . " bytes`n`n"

    loop Min(3, recordCount) {
        offset := (A_Index - 1) * recordSize
        result .= "Product " . NumGet(buf, offset, "Int") . ": "
        result .= "$" . Format("{:.2f}", NumGet(buf, offset + 4, "Float"))
        result .= " × " . NumGet(buf, offset + 8, "Int") . "`n"
    }

    result .= "`nTotal Inventory Value: $" . Format("{:,.2f}", totalValue)

    MsgBox(result, "Example 4: Structure Arrays", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Bitfield Packing
; ================================================================================================

Example5_BitfieldPacking() {
    ; Pack multiple values into single integer
    buf := Buffer(4)

    ; Fields: priority(4 bits) + enabled(1 bit) + visible(1 bit)
    ;         + category(9 bits) + userID(16 bits)
    priority := 7
    enabled := 1
    visible := 1
    category := 42
    userID := 1234

    packed := 0
    packed |= (priority & 0xF)
    packed |= (enabled << 4)
    packed |= (visible << 5)
    packed |= ((category & 0x1FF) << 7)
    packed |= (userID << 16)

    NumPut("UInt", packed, buf, 0)

    ; Extract and verify
    value := NumGet(buf, 0, "UInt")
    result := "Bitfield Packing:`n`n"
    result .= "Packed Value: 0x" . Format("{:08X}", value) . "`n`n"

    result .= "Extracted Fields:`n"
    result .= "  Priority: " . (value & 0xF) . "`n"
    result .= "  Enabled: " . ((value >> 4) & 1) . "`n"
    result .= "  Visible: " . ((value >> 5) & 1) . "`n"
    result .= "  Category: " . ((value >> 7) & 0x1FF) . "`n"
    result .= "  UserID: " . ((value >> 16) & 0xFFFF) . "`n`n"

    result .= "Space savings: 16 bytes -> 4 bytes (75%)"

    MsgBox(result, "Example 5: Bitfield Packing", "Icon!")
}

; ================================================================================================
; EXAMPLE 6: Windows SYSTEMTIME Structure Creation
; ================================================================================================

Example6_SYSTEMTIME() {
    ; Create SYSTEMTIME structure
    buf := Buffer(16)

    NumPut("UShort", 2024, buf, 0)   ; Year
    NumPut("UShort", 11, buf, 2)     ; Month
    NumPut("UShort", 6, buf, 4)      ; DayOfWeek (Saturday)
    NumPut("UShort", 16, buf, 6)     ; Day
    NumPut("UShort", 14, buf, 8)     ; Hour
    NumPut("UShort", 30, buf, 10)    ; Minute
    NumPut("UShort", 45, buf, 12)    ; Second
    NumPut("UShort", 123, buf, 14)   ; Milliseconds

    ; Read back
    year := NumGet(buf, 0, "UShort")
    month := NumGet(buf, 2, "UShort")
    day := NumGet(buf, 6, "UShort")
    hour := NumGet(buf, 8, "UShort")
    minute := NumGet(buf, 10, "UShort")
    second := NumGet(buf, 12, "UShort")
    ms := NumGet(buf, 14, "UShort")

    monthNames := ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    result := "SYSTEMTIME Structure Creation:`n`n"
    result .= "Structure Size: 16 bytes`n`n"
    result .= "Date: " . monthNames[month] . " " . day . ", " . year . "`n"
    result .= "Time: " . Format("{:02}:{:02}:{:02}.{:03}", hour, minute, second, ms)

    MsgBox(result, "Example 6: SYSTEMTIME Creation", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
                    (
                    NumPut Structure Writing Examples

                    1. Simple Structure Creation
                    2. Nested Structures
                    3. Structure with Array Field
                    4. Creating Structure Arrays
                    5. Bitfield Packing
                    6. Windows SYSTEMTIME Creation

                    Select an example (1-6) or press Cancel to exit:
                    )"

    choice := InputBox(menu, "NumPut Structure Examples", "w450 h320")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_SimpleStructure()
        case "2": Example2_NestedStructures()
        case "3": Example3_StructureWithArray()
        case "4": Example4_StructureArrays()
        case "5": Example5_BitfieldPacking()
        case "6": Example6_SYSTEMTIME()
        default: MsgBox("Invalid selection. Please choose 1-6.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
