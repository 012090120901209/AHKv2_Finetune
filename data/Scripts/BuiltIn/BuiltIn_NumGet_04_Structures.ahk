#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_NumGet_04_Structures.ahk
 * 
 * DESCRIPTION:
 * Comprehensive guide to using NumGet for reading complex C structures.
 * Demonstrates reading nested structures, unions, and Windows API structures.
 * 
 * FEATURES:
 * - Reading complex nested structures
 * - Structure alignment and padding
 * - Union data type handling
 * - Reading arrays within structures
 * - Windows API structure parsing
 * - Practical structure manipulation
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - NumGet, Structures
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Calculated offsets for structure fields
 * - Mixed data type reading
 * - Platform-aware structure layouts
 * - String handling in structures
 * - Bitfield extraction
 * 
 * LEARNING POINTS:
 * 1. Structure fields must account for alignment and padding
 * 2. Offset calculations are critical for correctness
 * 3. Different platforms may have different structure layouts
 * 4. Nested structures require careful offset tracking
 * 5. Windows API structures follow specific packing rules
 */

; ================================================================================================
; EXAMPLE 1: Reading Employee Record Structure
; ================================================================================================
; Demonstrates reading a multi-field structure

Example1_EmployeeRecord() {
    ; Define Employee structure:
    ; struct Employee {
    ;     int id;           // 4 bytes, offset 0
    ;     double salary;    // 8 bytes, offset 4
    ;     short department; // 2 bytes, offset 12
    ;     char active;      // 1 byte, offset 14
    ;     char padding;     // 1 byte, offset 15
    ; } // Total: 16 bytes

    ; Create and populate buffer
    buf := Buffer(16)
    NumPut("Int", 12345, buf, 0)
    NumPut("Double", 75500.50, buf, 4)
    NumPut("Short", 42, buf, 12)
    NumPut("Char", 1, buf, 14)  ; Active = true

    ; Read structure fields using NumGet
    id := NumGet(buf, 0, "Int")
    salary := NumGet(buf, 4, "Double")
    department := NumGet(buf, 12, "Short")
    active := NumGet(buf, 14, "Char")

    ; Parse active status
    activeStr := active ? "Active" : "Inactive"

    ; Display results
    result := "Employee Record Structure:`n`n"
    result .= "Structure Layout (16 bytes):`n"
    result .= "  Offset  0-3:  Int id`n"
    result .= "  Offset  4-11: Double salary`n"
    result .= "  Offset 12-13: Short department`n"
    result .= "  Offset 14:    Char active`n"
    result .= "  Offset 15:    (padding)`n`n"

    result .= "Field Values:`n"
    result .= "  Employee ID: " . id . "`n"
    result .= "  Salary: $" . Format("{:,.2f}", salary) . "`n"
    result .= "  Department: " . department . "`n"
    result .= "  Status: " . activeStr . " (" . active . ")`n`n"

    result .= "Total Structure Size: " . buf.Size . " bytes"

    MsgBox(result, "Example 1: Employee Record", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Nested Structure Reading
; ================================================================================================
; Shows reading structures containing other structures

Example2_NestedStructures() {
    ; Define structures:
    ; struct Point { int x; int y; }  // 8 bytes
    ; struct Rectangle {
    ;     Point topLeft;      // 8 bytes, offset 0
    ;     Point bottomRight;  // 8 bytes, offset 8
    ;     int color;          // 4 bytes, offset 16
    ; } // Total: 20 bytes

    ; Create and populate buffer
    buf := Buffer(20)

    ; TopLeft point (100, 50)
    NumPut("Int", 100, buf, 0)
    NumPut("Int", 50, buf, 4)

    ; BottomRight point (400, 300)
    NumPut("Int", 400, buf, 8)
    NumPut("Int", 300, buf, 12)

    ; Color (RGBA as int: 0xFF0000FF = blue)
    NumPut("Int", 0xFF0000FF, buf, 16)

    ; Read nested structure
    topLeft_x := NumGet(buf, 0, "Int")
    topLeft_y := NumGet(buf, 4, "Int")
    bottomRight_x := NumGet(buf, 8, "Int")
    bottomRight_y := NumGet(buf, 12, "Int")
    color := NumGet(buf, 16, "Int")

    ; Calculate derived values
    width := bottomRight_x - topLeft_x
    height := bottomRight_y - topLeft_y
    area := width * height

    ; Extract color components
    colorR := (color >> 24) & 0xFF
    colorG := (color >> 16) & 0xFF
    colorB := (color >> 8) & 0xFF
    colorA := color & 0xFF

    ; Display results
    result := "Nested Structure Reading:`n`n"
    result .= "Rectangle Structure (20 bytes):`n"
    result .= "  TopLeft Point:`n"
    result .= "    X: " . topLeft_x . "`n"
    result .= "    Y: " . topLeft_y . "`n"
    result .= "  BottomRight Point:`n"
    result .= "    X: " . bottomRight_x . "`n"
    result .= "    Y: " . bottomRight_y . "`n"
    result .= "  Color: 0x" . Format("{:08X}", color) . "`n"
    result .= "    R=" . colorR . " G=" . colorG . " B=" . colorB . " A=" . colorA . "`n`n"

    result .= "Calculated Values:`n"
    result .= "  Width: " . width . " pixels`n"
    result .= "  Height: " . height . " pixels`n"
    result .= "  Area: " . area . " sq pixels"

    MsgBox(result, "Example 2: Nested Structures", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Array Within Structure
; ================================================================================================
; Demonstrates reading structures containing arrays

Example3_ArrayInStructure() {
    ; Define structure:
    ; struct SensorData {
    ;     int sensorId;        // 4 bytes, offset 0
    ;     float readings[10];  // 40 bytes (10 * 4), offset 4
    ;     int timestamp;       // 4 bytes, offset 44
    ; } // Total: 48 bytes

    ; Create and populate buffer
    buf := Buffer(48)

    ; Sensor ID
    NumPut("Int", 2001, buf, 0)

    ; 10 temperature readings
    readings := [20.5, 21.2, 21.8, 22.1, 22.5, 23.0, 23.2, 22.8, 22.3, 21.9]
    loop 10 {
        offset := 4 + ((A_Index - 1) * 4)
        NumPut("Float", readings[A_Index], buf, offset)
    }

    ; Timestamp
    NumPut("Int", 1700000000, buf, 44)

    ; Read structure using NumGet
    sensorId := NumGet(buf, 0, "Int")

    ; Read array of readings
    readingsOut := []
    loop 10 {
        offset := 4 + ((A_Index - 1) * 4)
        value := NumGet(buf, offset, "Float")
        readingsOut.Push(value)
    }

    timestamp := NumGet(buf, 44, "Int")

    ; Calculate statistics
    sum := 0.0
    min := 999.9
    max := -999.9
    for value in readingsOut {
        sum += value
        if value < min
            min := value
        if value > max
            max := value
    }
    average := sum / readingsOut.Length

    ; Display results
    result := "Structure with Array Reading:`n`n"
    result .= "SensorData Structure (48 bytes):`n`n"

    result .= "Header:`n"
    result .= "  Sensor ID: " . sensorId . "`n"
    result .= "  Timestamp: " . timestamp . "`n`n"

    result .= "Readings Array (10 floats):`n  "
    for value in readingsOut {
        result .= Format("{:.1f}", value) . " "
        if Mod(A_Index, 5) = 0
            result .= "`n  "
    }

    result .= "`n`nStatistics:`n"
    result .= "  Minimum: " . Format("{:.1f}", min) . "°C`n"
    result .= "  Maximum: " . Format("{:.1f}", max) . "°C`n"
    result .= "  Average: " . Format("{:.2f}", average) . "°C`n"
    result .= "  Range: " . Format("{:.1f}", max - min) . "°C"

    MsgBox(result, "Example 3: Array in Structure", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Windows SYSTEMTIME Structure
; ================================================================================================
; Practical example: reading Windows SYSTEMTIME structure

Example4_SYSTEMTIME() {
    ; SYSTEMTIME structure:
    ; typedef struct _SYSTEMTIME {
    ;     WORD wYear;         // offset 0
    ;     WORD wMonth;        // offset 2
    ;     WORD wDayOfWeek;    // offset 4
    ;     WORD wDay;          // offset 6
    ;     WORD wHour;         // offset 8
    ;     WORD wMinute;       // offset 10
    ;     WORD wSecond;       // offset 12
    ;     WORD wMilliseconds; // offset 14
    ; } SYSTEMTIME; // Total: 16 bytes

    ; Get current system time
    buf := Buffer(16)
    DllCall("GetSystemTime", "Ptr", buf.Ptr)

    ; Read structure fields
    year := NumGet(buf, 0, "UShort")
    month := NumGet(buf, 2, "UShort")
    dayOfWeek := NumGet(buf, 4, "UShort")
    day := NumGet(buf, 6, "UShort")
    hour := NumGet(buf, 8, "UShort")
    minute := NumGet(buf, 10, "UShort")
    second := NumGet(buf, 12, "UShort")
    milliseconds := NumGet(buf, 14, "UShort")

    ; Day of week names
    dayNames := ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    dayName := dayNames[dayOfWeek + 1]

    ; Month names
    monthNames := ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"]
    monthName := monthNames[month]

    ; Format time
    timeStr := Format("{:02}:{:02}:{:02}.{:03}", hour, minute, second, milliseconds)
    dateStr := Format("{} {}, {}", monthName, day, year)

    ; Display results
    result := "Windows SYSTEMTIME Structure:`n`n"
    result .= "Structure Size: 16 bytes (8 WORDs)`n`n"

    result .= "Raw Values:`n"
    result .= "  wYear: " . year . "`n"
    result .= "  wMonth: " . month . "`n"
    result .= "  wDayOfWeek: " . dayOfWeek . "`n"
    result .= "  wDay: " . day . "`n"
    result .= "  wHour: " . hour . "`n"
    result .= "  wMinute: " . minute . "`n"
    result .= "  wSecond: " . second . "`n"
    result .= "  wMilliseconds: " . milliseconds . "`n`n"

    result .= "Formatted Output:`n"
    result .= "  Date: " . dateStr . "`n"
    result .= "  Day: " . dayName . "`n"
    result .= "  Time (UTC): " . timeStr

    MsgBox(result, "Example 4: SYSTEMTIME Structure", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Reading Packed Bitfields
; ================================================================================================
; Shows reading and extracting bitfield data from structures

Example5_Bitfields() {
    ; Structure with bitfields (simulated):
    ; struct Flags {
    ;     unsigned int flags; // 4 bytes
    ;     // Bit layout:
    ;     // bits 0-3: priority (0-15)
    ;     // bit 4: enabled
    ;     // bit 5: visible
    ;     // bit 6: locked
    ;     // bits 7-15: category (0-511)
    ;     // bits 16-31: userID (0-65535)
    ; }

    ; Create buffer with packed flags
    buf := Buffer(4)

    ; Pack values into flags:
    ; priority = 7 (bits 0-3)
    ; enabled = 1 (bit 4)
    ; visible = 1 (bit 5)
    ; locked = 0 (bit 6)
    ; category = 42 (bits 7-15)
    ; userID = 1234 (bits 16-31)

    flags := 0
    flags |= (7 & 0xF)          ; bits 0-3: priority
    flags |= (1 << 4)            ; bit 4: enabled
    flags |= (1 << 5)            ; bit 5: visible
    flags |= (0 << 6)            ; bit 6: locked
    flags |= ((42 & 0x1FF) << 7) ; bits 7-15: category
    flags |= (1234 << 16)        ; bits 16-31: userID

    NumPut("UInt", flags, buf, 0)

    ; Read and extract bitfields using NumGet
    packedValue := NumGet(buf, 0, "UInt")

    ; Extract individual bitfields
    priority := packedValue & 0xF
    enabled := (packedValue >> 4) & 1
    visible := (packedValue >> 5) & 1
    locked := (packedValue >> 6) & 1
    category := (packedValue >> 7) & 0x1FF
    userID := (packedValue >> 16) & 0xFFFF

    ; Display results
    result := "Packed Bitfield Structure:`n`n"
    result .= "Structure: 4 bytes (32 bits)`n"
    result .= "Packed Value: 0x" . Format("{:08X}", packedValue) . "`n"
    result .= "Binary: " . ToBinary(packedValue, 32) . "`n`n"

    result .= "Extracted Bitfields:`n"
    result .= "  Priority (bits 0-3): " . priority . " (range 0-15)`n"
    result .= "  Enabled (bit 4): " . (enabled ? "Yes" : "No") . "`n"
    result .= "  Visible (bit 5): " . (visible ? "Yes" : "No") . "`n"
    result .= "  Locked (bit 6): " . (locked ? "Yes" : "No") . "`n"
    result .= "  Category (bits 7-15): " . category . " (range 0-511)`n"
    result .= "  User ID (bits 16-31): " . userID . " (range 0-65535)`n`n"

    result .= "Space Efficiency:`n"
    result .= "  Separate fields would use: 16 bytes`n"
    result .= "  Packed bitfields use: 4 bytes`n"
    result .= "  Savings: 75%"

    ; Helper function to convert to binary string
    ToBinary(num, bits) {
        result := ""
        loop bits {
            bit := (num >> (bits - A_Index)) & 1
            result .= bit
            if Mod(A_Index, 8) = 0 && A_Index < bits
                result .= " "
        }
        return result
    }

    MsgBox(result, "Example 5: Packed Bitfields", "Icon!")
}

; ================================================================================================
; EXAMPLE 6: Reading Multiple Structure Records
; ================================================================================================
; Practical example: reading an array of structures

Example6_StructureArray() {
    ; Structure: Product
    ; struct Product {
    ;     int id;           // 4 bytes
    ;     float price;      // 4 bytes
    ;     int quantity;     // 4 bytes
    ;     short category;   // 2 bytes
    ;     short padding;    // 2 bytes (alignment)
    ; } // Total: 16 bytes

    recordSize := 16
    recordCount := 5
    buf := Buffer(recordSize * recordCount)

    ; Sample product data
    products := [{
        id: 1001, price: 49.99, quantity: 100, category: 1 }, {
            id: 1002, price: 29.99, quantity: 250, category: 2 }, {
                id: 1003, price: 89.99, quantity: 50, category: 1 }, {
                    id: 1004, price: 15.99, quantity: 500, category: 3 }, {
                        id: 1005, price: 199.99, quantity: 25, category: 1
                    }
    ]

    ; Write products to buffer
    loop recordCount {
        offset := (A_Index - 1) * recordSize
        product := products[A_Index]

        NumPut("Int", product.id, buf, offset)
        NumPut("Float", product.price, buf, offset + 4)
        NumPut("Int", product.quantity, buf, offset + 8)
        NumPut("Short", product.category, buf, offset + 12)
    }

    ; Read and analyze products using NumGet
    totalValue := 0.0
    totalQuantity := 0
    categoryCount := Map(1, 0, 2, 0, 3, 0)

    readProducts := []
    loop recordCount {
        offset := (A_Index - 1) * recordSize

        id := NumGet(buf, offset, "Int")
        price := NumGet(buf, offset + 4, "Float")
        quantity := NumGet(buf, offset + 8, "Int")
        category := NumGet(buf, offset + 12, "Short")

        value := price * quantity
        totalValue += value
        totalQuantity += quantity

        if categoryCount.Has(category)
            categoryCount[category]++

        readProducts.Push({
            id: id,
            price: price,
            quantity: quantity,
            category: category,
            value: value
        })
    }

    ; Find most valuable product
    maxValue := 0.0
    maxValueId := 0
    for product in readProducts {
        if product.value > maxValue {
            maxValue := product.value
            maxValueId := product.id
        }
    }

    ; Display results
    result := "Structure Array Reading:`n`n"
    result .= "Array: " . recordCount . " products × " . recordSize . " bytes = "
        . buf.Size . " bytes`n`n"

    result .= "Product Inventory:`n"
    loop recordCount {
        product := readProducts[A_Index]
        result .= "  Product " . product.id . ":`n"
        result .= "    Price: $" . Format("{:.2f}", product.price) . "`n"
        result .= "    Quantity: " . product.quantity . "`n"
        result .= "    Category: " . product.category . "`n"
        result .= "    Total Value: $" . Format("{:.2f}", product.value) . "`n"

        if A_Index < recordCount
            result .= "`n"
    }

    result .= "`n`nSummary:`n"
    result .= "  Total Items: " . totalQuantity . "`n"
    result .= "  Total Inventory Value: $" . Format("{:,.2f}", totalValue) . "`n"
    result .= "  Most Valuable: Product " . maxValueId
        . " ($" . Format("{:.2f}", maxValue) . ")`n`n"

    result .= "By Category:`n"
    for catId, count in categoryCount {
        result .= "  Category " . catId . ": " . count . " products`n"
    }

    MsgBox(result, "Example 6: Structure Array", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
                                            (
                                            NumGet Structure Reading Examples

                                            1. Employee Record Structure
                                            2. Nested Structures (Rectangle with Points)
                                            3. Array Within Structure (Sensor Data)
                                            4. Windows SYSTEMTIME Structure
                                            5. Packed Bitfields
                                            6. Reading Multiple Structure Records

                                            Select an example (1-6) or press Cancel to exit:
                                            )"

    choice := InputBox(menu, "NumGet Structure Examples", "w450 h330")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_EmployeeRecord()
        case "2": Example2_NestedStructures()
        case "3": Example3_ArrayInStructure()
        case "4": Example4_SYSTEMTIME()
        case "5": Example5_Bitfields()
        case "6": Example6_StructureArray()
        default: MsgBox("Invalid selection. Please choose 1-6.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
