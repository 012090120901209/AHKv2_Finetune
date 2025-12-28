#Requires AutoHotkey v2.0

/**
 * BuiltIn_Buffer_03_Structures.ahk
 * 
 * DESCRIPTION:
 * Demonstrates working with C-style structures using Buffer objects.
 * Shows how to pack, unpack, and manipulate structured binary data.
 * 
 * FEATURES:
 * - C structure definition and usage
 * - Structure packing and alignment
 * - Nested structures
 * - Arrays within structures
 * - Structure marshaling for DllCall
 * - Common Windows API structures
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Buffer, NumGet, NumPut
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Buffer for structure storage
 * - NumGet/NumPut for field access
 * - StrGet/StrPut for string fields
 * - Structure offset calculations
 * - Pointer handling in structures
 * 
 * LEARNING POINTS:
 * 1. Structures are contiguous memory blocks with defined layouts
 * 2. Field alignment affects structure size and layout
 * 3. Nested structures require careful offset calculation
 * 4. String fields need special handling (pointers or fixed arrays)
 * 5. Windows API structures have specific packing requirements
 */

; ================================================================================================
; EXAMPLE 1: Simple Structures
; ================================================================================================
; Demonstrates creating and using simple C-style structures

Example1_SimpleStructures() {
    ; Define a Point structure: struct Point { int x; int y; }

    ; Define a Rectangle structure:
    ; struct Rectangle { int left; int top; int right; int bottom; }

    ; Create and use structures
    pt1 := BufferPoint.Create(100, 200)
    pt2 := BufferPoint.Create(350, 450)

    rect := Rectangle.Create(50, 50, 400, 300)

    ; Modify point
    BufferPoint.SetX(pt1, BufferPoint.GetX(pt1) + 10)
    BufferPoint.SetY(pt1, BufferPoint.GetY(pt1) + 20)

    ; Display results
    result := "Simple Structure Examples:`n`n"

    result .= "Point Structures:`n"
    result .= "  pt1: " . BufferPoint.ToString(pt1) . "`n"
    result .= "  pt2: " . BufferPoint.ToString(pt2) . "`n`n"

    result .= "Rectangle Structure:`n"
    result .= "  " . Rectangle.ToString(rect) . "`n"
    result .= "  Width: " . Rectangle.GetWidth(rect) . "`n"
    result .= "  Height: " . Rectangle.GetHeight(rect) . "`n"
    result .= "  Area: " . Rectangle.GetArea(rect) . " sq units"

    MsgBox(result, "Example 1: Simple Structures", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Structures with Different Data Types
; ================================================================================================
; Shows structures containing various data types

Example2_MixedTypeStructures() {
    ; Define a Person structure:
    ; struct Person {
    ;     int id;              // 4 bytes, offset 0
    ;     double salary;       // 8 bytes, offset 4 (or 8 with alignment)
    ;     unsigned char age;   // 1 byte
    ;     char gender;         // 1 byte
    ;     short department;    // 2 bytes
    ; }


    ; Define a Product structure with price and quantity

    ; Create instances
    person1 := Person.Create(1001, 75500.50, 32, Ord("M"), 5)
    person2 := Person.Create(1002, 82300.75, 28, Ord("F"), 3)

    product1 := Product.Create(5001, 10, 49.99, 0.15)
    product2 := Product.Create(5002, 25, 29.99, 0.10)

    ; Give person1 a raise
    currentSalary := Person.GetSalary(person1)
    Person.SetSalary(person1, currentSalary * 1.10)

    ; Display results
    result := "Mixed Type Structure Examples:`n`n"

    result .= "Person Structures (16 bytes each):`n"
    result .= "  " . Person.ToString(person1) . "`n"
    result .= "  " . Person.ToString(person2) . "`n`n"

    result .= "Product Structures (16 bytes each):`n"
    result .= "  " . Product.ToString(product1) . "`n"
    result .= "    Total: $" . Format("{:.2f}", Product.GetTotal(product1)) . "`n"
    result .= "  " . Product.ToString(product2) . "`n"
    result .= "    Total: $" . Format("{:.2f}", Product.GetTotal(product2))

    MsgBox(result, "Example 2: Mixed Type Structures", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Nested Structures
; ================================================================================================
; Demonstrates structures containing other structures

Example3_NestedStructures() {
    ; Simple Color structure

    ; Circle structure with embedded Point and Color
    ; struct Circle {
    ;     Point center;    // 8 bytes (x, y)
    ;     int radius;      // 4 bytes
    ;     Color color;     // 4 bytes (RGBA)
    ; }

    ; Rectangle with two points and color

    ; Create instances
    circle1 := Circle.Create(100, 100, 50, 255, 0, 0)    ; Red circle
    circle2 := Circle.Create(300, 200, 75, 0, 0, 255)    ; Blue circle

    rect1 := ColoredRect.Create(50, 50, 200, 150, 0, 255, 0)  ; Green rectangle

    ; Display results
    result := "Nested Structure Examples:`n`n"

    result .= "Circle Structures:`n"
    result .= "  " . Circle.ToString(circle1) . "`n"
    result .= "    Area: " . Round(Circle.GetArea(circle1), 2) . " sq units`n"
    result .= "  " . Circle.ToString(circle2) . "`n"
    result .= "    Area: " . Round(Circle.GetArea(circle2), 2) . " sq units`n`n"

    result .= "Colored Rectangle:`n"
    result .= "  " . ColoredRect.ToString(rect1) . "`n"
    result .= "    Dimensions: " . ColoredRect.GetWidth(rect1) . "x"
    result .= ColoredRect.GetHeight(rect1) . "`n"
    result .= "    Area: " . ColoredRect.GetArea(rect1) . " sq units"

    MsgBox(result, "Example 3: Nested Structures", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Structures with Arrays
; ================================================================================================
; Shows structures containing fixed-size arrays

Example4_StructuresWithArrays() {
    ; Student structure with grades array
    ; struct Student {
    ;     int id;
    ;     float grades[5];  // 5 subjects
    ;     int credits;
    ; }

    ; Temperature readings structure (hourly data for 24 hours)

    ; Create student instances
    student1 := Student.Create(1001, [85.5, 92.0, 78.5, 88.0, 95.5], 15)
    student2 := Student.Create(1002, [72.0, 85.5, 90.0, 82.5, 88.0], 12)

    ; Create temperature data (simulate hourly temps)
    temps := []
    loop 24 {
        temps.Push(60 + Random(-10, 15))  ; Random temps around 60°F
    }
    dailyTemps := DailyTemp.Create(temps)

    ; Display results
    result := "Structures with Arrays:`n`n"

    result .= "Student Records:`n"
    result .= "  " . Student.ToString(student1) . "`n"
    result .= "    Average: " . Format("{:.2f}", Student.GetAverage(student1)) . "`n"
    result .= "  " . Student.ToString(student2) . "`n"
    result .= "    Average: " . Format("{:.2f}", Student.GetAverage(student2)) . "`n`n"

    minMax := DailyTemp.GetMinMax(dailyTemps)
    result .= "Daily Temperature Readings (24 hours):`n"
    result .= "  Average: " . Format("{:.1f}°F", DailyTemp.GetAverage(dailyTemps)) . "`n"
    result .= "  Min: " . Format("{:.1f}°F", minMax.Min) . "`n"
    result .= "  Max: " . Format("{:.1f}°F", minMax.Max) . "`n"
    result .= "  First 6 hours: "
    loop 6 {
        result .= Format("{:.1f}", DailyTemp.GetTemp(dailyTemps, A_Index))
        if A_Index < 6
            result .= ", "
    }

    MsgBox(result, "Example 4: Structures with Arrays", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Windows API Structures
; ================================================================================================
; Demonstrates common Windows API structures

Example5_WindowsAPIStructures() {
    ; RECT structure (used extensively in Windows API)

    ; POINT structure

    ; Get active window rectangle
    hwnd := WinExist("A")
    windowRect := RECT.FromWindow(hwnd)

    ; Get cursor position
    cursorPos := PointStruct.GetCursorPos()

    ; Create some manual structures
    customRect := RECT.Create(100, 100, 500, 400)
    customPoint := PointStruct.Create(250, 250)

    ; Display results
    result := "Windows API Structures:`n`n"

    result .= "Active Window RECT:`n"
    result .= "  " . RECT.ToString(windowRect) . "`n"
    result .= "  Width: " . (RECT.GetRight(windowRect) - RECT.GetLeft(windowRect)) . "`n"
    result .= "  Height: " . (RECT.GetBottom(windowRect) - RECT.GetTop(windowRect)) . "`n`n"

    result .= "Cursor Position:`n"
    result .= "  " . PointStruct.ToString(cursorPos) . "`n`n"

    result .= "Custom Structures:`n"
    result .= "  " . RECT.ToString(customRect) . "`n"
    result .= "  " . PointStruct.ToString(customPoint)

    MsgBox(result, "Example 5: Windows API Structures", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
                (
                Buffer Structure Examples

                1. Simple Structures (Point, Rectangle)
                2. Mixed Type Structures (Person, Product)
                3. Nested Structures (Circle, ColoredRect)
                4. Structures with Arrays (Student, DailyTemp)
                5. Windows API Structures (RECT, POINT)

                Select an example (1-5) or press Cancel to exit:
                )"

    choice := InputBox(menu, "Buffer Structure Examples", "w450 h300")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_SimpleStructures()
        case "2": Example2_MixedTypeStructures()
        case "3": Example3_NestedStructures()
        case "4": Example4_StructuresWithArrays()
        case "5": Example5_WindowsAPIStructures()
        default: MsgBox("Invalid selection. Please choose 1-5.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()

; Moved class Point from nested scope
class BufferPoint {
    static SIZE := 8  ; 4 + 4 bytes

    static Create(x, y) {
        buf := Buffer(BufferPoint.SIZE)
        NumPut("Int", x, buf, 0)
        NumPut("Int", y, buf, 4)
        return buf
    }

    static GetX(buf) => NumGet(buf, 0, "Int")
    static GetY(buf) => NumGet(buf, 4, "Int")
    static SetX(buf, value) => NumPut("Int", value, buf, 0)
    static SetY(buf, value) => NumPut("Int", value, buf, 4)

    static ToString(buf) {
        return "Point(" . BufferPoint.GetX(buf) . ", " . BufferPoint.GetY(buf) . ")"
    }
}

; Moved class Rectangle from nested scope
class Rectangle {
    static SIZE := 16  ; 4 * 4 bytes

    static Create(left, top, right, bottom) {
        buf := Buffer(Rectangle.SIZE)
        NumPut("Int", left, buf, 0)
        NumPut("Int", top, buf, 4)
        NumPut("Int", right, buf, 8)
        NumPut("Int", bottom, buf, 12)
        return buf
    }

    static GetLeft(buf) => NumGet(buf, 0, "Int")
    static GetTop(buf) => NumGet(buf, 4, "Int")
    static GetRight(buf) => NumGet(buf, 8, "Int")
    static GetBottom(buf) => NumGet(buf, 12, "Int")

    static GetWidth(buf) => Rectangle.GetRight(buf) - Rectangle.GetLeft(buf)
    static GetHeight(buf) => Rectangle.GetBottom(buf) - Rectangle.GetTop(buf)
    static GetArea(buf) => Rectangle.GetWidth(buf) * Rectangle.GetHeight(buf)

    static ToString(buf) {
        return Format("Rectangle({}, {}, {}, {})"
            , Rectangle.GetLeft(buf)
            , Rectangle.GetTop(buf)
            , Rectangle.GetRight(buf)
            , Rectangle.GetBottom(buf))
    }
}

; Moved class Person from nested scope
class Person {
    static SIZE := 4 + 8 + 1 + 1 + 2  ; 16 bytes (no padding)

    static Create(id, salary, age, gender, department) {
        buf := Buffer(Person.SIZE)
        NumPut("Int", id, buf, 0)
        NumPut("Double", salary, buf, 4)
        NumPut("UChar", age, buf, 12)
        NumPut("Char", gender, buf, 13)
        NumPut("Short", department, buf, 14)
        return buf
    }

    static GetId(buf) => NumGet(buf, 0, "Int")
    static GetSalary(buf) => NumGet(buf, 4, "Double")
    static GetAge(buf) => NumGet(buf, 12, "UChar")
    static GetGender(buf) => Chr(NumGet(buf, 13, "Char"))
    static GetDepartment(buf) => NumGet(buf, 14, "Short")

    static SetSalary(buf, value) => NumPut("Double", value, buf, 4)
    static SetDepartment(buf, value) => NumPut("Short", value, buf, 14)

    static ToString(buf) {
        return Format("Person(ID:{}, Salary:${:.2f}, Age:{}, Gender:{}, Dept:{})"
            , Person.GetId(buf)
            , Person.GetSalary(buf)
            , Person.GetAge(buf)
            , Person.GetGender(buf)
            , Person.GetDepartment(buf))
    }
}

; Moved class Product from nested scope
class Product {
    static SIZE := 4 + 4 + 4 + 4  ; id, quantity, price(float), discount(float)

    static Create(id, quantity, price, discount) {
        buf := Buffer(Product.SIZE)
        NumPut("Int", id, buf, 0)
        NumPut("Int", quantity, buf, 4)
        NumPut("Float", price, buf, 8)
        NumPut("Float", discount, buf, 12)
        return buf
    }

    static GetId(buf) => NumGet(buf, 0, "Int")
    static GetQuantity(buf) => NumGet(buf, 4, "Int")
    static GetPrice(buf) => NumGet(buf, 8, "Float")
    static GetDiscount(buf) => NumGet(buf, 12, "Float")

    static GetTotal(buf) {
        quantity := Product.GetQuantity(buf)
        price := Product.GetPrice(buf)
        discount := Product.GetDiscount(buf)
        return quantity * price * (1 - discount)
    }

    static ToString(buf) {
        return Format("Product(ID:{}, Qty:{}, Price:${:.2f}, Discount:{:.1f}%)"
            , Product.GetId(buf)
            , Product.GetQuantity(buf)
            , Product.GetPrice(buf)
            , Product.GetDiscount(buf) * 100)
    }
}

; Moved class Color from nested scope
class Color {
    static SIZE := 4  ; 4 bytes for RGBA

    static Create(r, g, b, a := 255) {
        buf := Buffer(Color.SIZE)
        NumPut("UChar", r, buf, 0)
        NumPut("UChar", g, buf, 1)
        NumPut("UChar", b, buf, 2)
        NumPut("UChar", a, buf, 3)
        return buf
    }

    static GetR(buf) => NumGet(buf, 0, "UChar")
    static GetG(buf) => NumGet(buf, 1, "UChar")
    static GetB(buf) => NumGet(buf, 2, "UChar")
    static GetA(buf) => NumGet(buf, 3, "UChar")

    static ToString(buf) {
        return Format("Color({}, {}, {}, {})"
            , Color.GetR(buf), Color.GetG(buf)
            , Color.GetB(buf), Color.GetA(buf))
    }
}

; Moved class Circle from nested scope
class Circle {
    static SIZE := 8 + 4 + 4  ; 16 bytes
    static OFFSET_CENTER := 0
    static OFFSET_RADIUS := 8
    static OFFSET_COLOR := 12

    static Create(centerX, centerY, radius, r, g, b) {
        buf := Buffer(Circle.SIZE)
        ; Center point
        NumPut("Int", centerX, buf, 0)
        NumPut("Int", centerY, buf, 4)
        ; Radius
        NumPut("Int", radius, buf, 8)
        ; Color
        NumPut("UChar", r, buf, 12)
        NumPut("UChar", g, buf, 13)
        NumPut("UChar", b, buf, 14)
        NumPut("UChar", 255, buf, 15)  ; Alpha
        return buf
    }

    static GetCenterX(buf) => NumGet(buf, 0, "Int")
    static GetCenterY(buf) => NumGet(buf, 4, "Int")
    static GetRadius(buf) => NumGet(buf, 8, "Int")
    static GetColorR(buf) => NumGet(buf, 12, "UChar")
    static GetColorG(buf) => NumGet(buf, 13, "UChar")
    static GetColorB(buf) => NumGet(buf, 14, "UChar")

    static GetArea(buf) {
        radius := Circle.GetRadius(buf)
        return 3.14159 * radius * radius
    }

    static ToString(buf) {
        return Format("Circle(Center:({}, {}), Radius:{}, Color:({},{},{}))"
            , Circle.GetCenterX(buf), Circle.GetCenterY(buf)
            , Circle.GetRadius(buf)
            , Circle.GetColorR(buf), Circle.GetColorG(buf), Circle.GetColorB(buf))
    }
}

; Moved class ColoredRect from nested scope
class ColoredRect {
    static SIZE := 8 + 8 + 4  ; topLeft + bottomRight + color = 20 bytes

    static Create(x1, y1, x2, y2, r, g, b) {
        buf := Buffer(ColoredRect.SIZE)
        NumPut("Int", x1, buf, 0)
        NumPut("Int", y1, buf, 4)
        NumPut("Int", x2, buf, 8)
        NumPut("Int", y2, buf, 12)
        NumPut("UChar", r, buf, 16)
        NumPut("UChar", g, buf, 17)
        NumPut("UChar", b, buf, 18)
        NumPut("UChar", 255, buf, 19)
        return buf
    }

    static GetWidth(buf) => NumGet(buf, 8, "Int") - NumGet(buf, 0, "Int")
    static GetHeight(buf) => NumGet(buf, 12, "Int") - NumGet(buf, 4, "Int")
    static GetArea(buf) => ColoredRect.GetWidth(buf) * ColoredRect.GetHeight(buf)

    static ToString(buf) {
        return Format("ColoredRect(TL:({},{}), BR:({},{}), Color:({},{},{}))"
            , NumGet(buf, 0, "Int"), NumGet(buf, 4, "Int")
            , NumGet(buf, 8, "Int"), NumGet(buf, 12, "Int")
            , NumGet(buf, 16, "UChar"), NumGet(buf, 17, "UChar")
            , NumGet(buf, 18, "UChar"))
    }
}

; Moved class Student from nested scope
class Student {
    static SIZE := 4 + (4 * 5) + 4  ; id + 5 floats + credits = 28 bytes
    static NUM_GRADES := 5

    static Create(id, grades, credits) {
        buf := Buffer(Student.SIZE)
        NumPut("Int", id, buf, 0)

        ; Store grades array
        loop Student.NUM_GRADES {
            grade := A_Index <= grades.Length ? grades[A_Index] : 0.0
            NumPut("Float", grade, buf, 4 + (A_Index - 1) * 4)
        }

        NumPut("Int", credits, buf, 24)
        return buf
    }

    static GetId(buf) => NumGet(buf, 0, "Int")
    static GetGrade(buf, index) => NumGet(buf, 4 + (index - 1) * 4, "Float")
    static GetCredits(buf) => NumGet(buf, 24, "Int")

    static GetAverage(buf) {
        total := 0.0
        loop Student.NUM_GRADES {
            total += Student.GetGrade(buf, A_Index)
        }
        return total / Student.NUM_GRADES
    }

    static ToString(buf) {
        gradesStr := ""
        loop Student.NUM_GRADES {
            gradesStr .= Format("{:.1f}", Student.GetGrade(buf, A_Index))
            if A_Index < Student.NUM_GRADES
                gradesStr .= ", "
        }
        return Format("Student(ID:{}, Grades:[{}], Credits:{})"
            , Student.GetId(buf), gradesStr, Student.GetCredits(buf))
    }
}

; Moved class DailyTemp from nested scope
class DailyTemp {
    static SIZE := 24 * 4  ; 24 floats = 96 bytes
    static HOURS := 24

    static Create(readings) {
        buf := Buffer(DailyTemp.SIZE)
        loop DailyTemp.HOURS {
            temp := A_Index <= readings.Length ? readings[A_Index] : 0.0
            NumPut("Float", temp, buf, (A_Index - 1) * 4)
        }
        return buf
    }

    static GetTemp(buf, hour) => NumGet(buf, (hour - 1) * 4, "Float")

    static GetAverage(buf) {
        total := 0.0
        loop DailyTemp.HOURS {
            total += DailyTemp.GetTemp(buf, A_Index)
        }
        return total / DailyTemp.HOURS
    }

    static GetMinMax(buf) {
        min := DailyTemp.GetTemp(buf, 1)
        max := min

        loop DailyTemp.HOURS - 1 {
            temp := DailyTemp.GetTemp(buf, A_Index + 1)
            if temp < min
                min := temp
            if temp > max
                max := temp
        }
        return { Min: min, Max: max }
    }
}

; Moved class RECT from nested scope
class RECT {
    static SIZE := 16  ; 4 ints

    static Create(left := 0, top := 0, right := 0, bottom := 0) {
        buf := Buffer(RECT.SIZE)
        NumPut("Int", left, buf, 0)
        NumPut("Int", top, buf, 4)
        NumPut("Int", right, buf, 8)
        NumPut("Int", bottom, buf, 12)
        return buf
    }

    static FromWindow(hwnd) {
        buf := RECT.Create()
        DllCall("GetWindowRect", "Ptr", hwnd, "Ptr", buf.Ptr)
        return buf
    }

    static GetLeft(buf) => NumGet(buf, 0, "Int")
    static GetTop(buf) => NumGet(buf, 4, "Int")
    static GetRight(buf) => NumGet(buf, 8, "Int")
    static GetBottom(buf) => NumGet(buf, 12, "Int")

    static ToString(buf) {
        return Format("RECT(L:{}, T:{}, R:{}, B:{})"
            , RECT.GetLeft(buf), RECT.GetTop(buf)
            , RECT.GetRight(buf), RECT.GetBottom(buf))
    }
}

; Moved class PointStruct from nested scope
class PointStruct {
    static SIZE := 8  ; 2 ints

    static Create(x := 0, y := 0) {
        buf := Buffer(PointStruct.SIZE)
        NumPut("Int", x, buf, 0)
        NumPut("Int", y, buf, 4)
        return buf
    }

    static GetCursorPos() {
        buf := PointStruct.Create()
        DllCall("GetCursorPos", "Ptr", buf.Ptr)
        return buf
    }

    static ToString(buf) {
        return Format("POINT(X:{}, Y:{})"
            , NumGet(buf, 0, "Int"), NumGet(buf, 4, "Int"))
    }
}
