#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Sqrt_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Basic usage examples of Sqrt() function for calculating square roots
 * 
 * FEATURES:
 * - Basic square root calculations
 * - Distance formula (2D and 3D)
 * - Magnitude of vectors
 * - Pythagorean theorem applications
 * - Error handling for negative numbers
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Sqrt
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Sqrt() function
 * - Mathematical expressions
 * - Round() for decimal control
 * - Format() for number formatting
 * - Error handling with try/catch
 * 
 * LEARNING POINTS:
 * 1. Sqrt() returns the square root of a number
 * 2. Only works with non-negative numbers
 * 3. Returns floating-point results
 * 4. Essential for distance and magnitude calculations
 * 5. Commonly used in geometry and physics formulas
 */

; ============================================================
; Example 1: Basic Square Root Calculations
; ============================================================

numbers := [4, 9, 16, 25, 100, 144, 2, 3, 10]
output := "BASIC SQUARE ROOTS:`n`n"

for num in numbers {
    sqrtValue := Sqrt(num)
    output .= "√" num " = " Format("{:.6f}", sqrtValue) "`n"
}

MsgBox(output, "Square Root Basics", "Icon!")

; ============================================================
; Example 2: Perfect Squares vs Non-Perfect Squares
; ============================================================

/**
 * Check if a number is a perfect square
 * 
 * @param {Number} n - Number to check
 * @returns {Boolean} - True if perfect square
 */
IsPerfectSquare(n) {
    if (n < 0)
        return false

    root := Sqrt(n)
    return (root = Floor(root))
}

testNumbers := [1, 2, 4, 8, 9, 15, 16, 20, 25, 30, 36, 50, 64, 100]
output := "PERFECT SQUARE ANALYSIS:`n`n"

for num in testNumbers {
    sqrtValue := Sqrt(num)
    isPerfect := IsPerfectSquare(num) ? "YES" : "NO"
    output .= num " → √ = " Format("{:.4f}", sqrtValue) " → Perfect: " isPerfect "`n"
}

MsgBox(output, "Perfect Squares", "Icon!")

; ============================================================
; Example 3: 2D Distance Formula
; ============================================================

/**
 * Calculate distance between two points in 2D space
 * 
 * @param {Number} x1 - X coordinate of first point
 * @param {Number} y1 - Y coordinate of first point
 * @param {Number} x2 - X coordinate of second point
 * @param {Number} y2 - Y coordinate of second point
 * @returns {Number} - Distance between points
 */
Distance2D(x1, y1, x2, y2) {
    dx := x2 - x1
    dy := y2 - y1
    return Sqrt(dx * dx + dy * dy)
}

; Test various point pairs
points := [{
    x1: 0, y1: 0, x2: 3, y2: 4, name: "Origin to (3,4)" }, {
        x1: 0, y1: 0, x2: 5, y2: 12, name: "Origin to (5,12)" }, {
            x1: 1, y1: 1, x2: 4, y2: 5, name: "(1,1) to (4,5)" }, {
                x1: -2, y1: 3, x2: 1, y2: 7, name: "(-2,3) to (1,7)" }, {
                    x1: 10, y1: 20, x2: 13, y2: 24, name: "(10,20) to (13,24)"
                }
]

output := "2D DISTANCE CALCULATIONS:`n`n"

for point in points {
    dist := Distance2D(point.x1, point.y1, point.x2, point.y2)
    output .= point.name "`n"
    output .= "  Distance = " Format("{:.4f}", dist) " units`n`n"
}

MsgBox(output, "2D Distance Formula", "Icon!")

; ============================================================
; Example 4: 3D Distance Formula
; ============================================================

/**
 * Calculate distance between two points in 3D space
 * 
 * @param {Number} x1, y1, z1 - Coordinates of first point
 * @param {Number} x2, y2, z2 - Coordinates of second point
 * @returns {Number} - Distance between points
 */
Distance3D(x1, y1, z1, x2, y2, z2) {
    dx := x2 - x1
    dy := y2 - y1
    dz := z2 - z1
    return Sqrt(dx * dx + dy * dy + dz * dz)
}

; Test 3D distances
points3D := [{
    x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1, name: "Origin to (1,1,1)" }, {
        x1: 0, y1: 0, z1: 0, x2: 3, y2: 4, z2: 12, name: "Origin to (3,4,12)" }, {
            x1: 1, y1: 2, z1: 3, x2: 4, y2: 6, z2: 8, name: "(1,2,3) to (4,6,8)" }, {
                x1: -5, y1: -5, z1: -5, x2: 5, y2: 5, z2: 5, name: "(-5,-5,-5) to (5,5,5)"
            }
]

output := "3D DISTANCE CALCULATIONS:`n`n"

for point in points3D {
    dist := Distance3D(point.x1, point.y1, point.z1,
        point.x2, point.y2, point.z2)
    output .= point.name "`n"
    output .= "  Distance = " Format("{:.4f}", dist) " units`n`n"
}

MsgBox(output, "3D Distance Formula", "Icon!")

; ============================================================
; Example 5: Vector Magnitude
; ============================================================

/**
 * Calculate magnitude (length) of a 2D vector
 * 
 * @param {Number} x - X component
 * @param {Number} y - Y component
 * @returns {Number} - Vector magnitude
 */
VectorMagnitude2D(x, y) {
    return Sqrt(x * x + y * y)
}

/**
 * Calculate magnitude (length) of a 3D vector
 * 
 * @param {Number} x, y, z - Vector components
 * @returns {Number} - Vector magnitude
 */
VectorMagnitude3D(x, y, z) {
    return Sqrt(x * x + y * y + z * z)
}

vectors := [{
    x: 3, y: 4, z: 0, name: "2D Vector (3, 4)" }, {
        x: 5, y: 12, z: 0, name: "2D Vector (5, 12)" }, {
            x: 1, y: 1, z: 1, name: "3D Vector (1, 1, 1)" }, {
                x: 3, y: 4, z: 12, name: "3D Vector (3, 4, 12)" }, {
                    x: 2, y: 2, z: 1, name: "3D Vector (2, 2, 1)"
                }
]

output := "VECTOR MAGNITUDE CALCULATIONS:`n`n"

for vec in vectors {
    if (vec.z = 0) {
        mag := VectorMagnitude2D(vec.x, vec.y)
    } else {
        mag := VectorMagnitude3D(vec.x, vec.y, vec.z)
    }
    output .= vec.name "`n"
    output .= "  Magnitude = " Format("{:.4f}", mag) "`n`n"
}

MsgBox(output, "Vector Magnitudes", "Icon!")

; ============================================================
; Example 6: Error Handling for Negative Numbers
; ============================================================

/**
 * Safe square root calculation with error handling
 * 
 * @param {Number} n - Number to calculate square root
 * @returns {Object} - {success: bool, value: number, error: string}
 */
SafeSqrt(n) {
    if (n < 0) {
        return { success: false, value: 0, error: "Cannot calculate square root of negative number" }
    }

    return { success: true, value: Sqrt(n), error: "" }
}

testValues := [-4, -1, 0, 1, 4, -9, 16, -25, 100]
output := "SAFE SQUARE ROOT WITH ERROR HANDLING:`n`n"

for num in testValues {
    result := SafeSqrt(num)

    if (result.success) {
        output .= "√" num " = " Format("{:.4f}", result.value) " ✓`n"
    } else {
        output .= "√" num " → ERROR: " result.error " ✗`n"
    }
}

MsgBox(output, "Error Handling", "Icon!")

; ============================================================
; Example 7: Practical Applications
; ============================================================

/**
 * Calculate diagonal length of a rectangle
 * 
 * @param {Number} width - Rectangle width
 * @param {Number} height - Rectangle height
 * @returns {Number} - Diagonal length
 */
RectangleDiagonal(width, height) {
    return Sqrt(width * width + height * height)
}

/**
 * Calculate radius from circle area
 * 
 * @param {Number} area - Circle area
 * @returns {Number} - Circle radius
 */
RadiusFromArea(area) {
    ; Area = π * r²
    ; r = √(Area / π)
    return Sqrt(area / 3.14159265359)
}

/**
 * Calculate side length of square from area
 * 
 * @param {Number} area - Square area
 * @returns {Number} - Side length
 */
SquareSideFromArea(area) {
    return Sqrt(area)
}

output := "PRACTICAL GEOMETRY APPLICATIONS:`n`n"

; Rectangle diagonals
rectangles := [{ w: 3, h: 4 }, { w: 5, h: 12 }, { w: 8, h: 15 }]
output .= "Rectangle Diagonals:`n"
for rect in rectangles {
    diag := RectangleDiagonal(rect.w, rect.h)
    output .= "  " rect.w " × " rect.h " → Diagonal = " Format("{:.4f}", diag) "`n"
}

; Circle radii from areas
output .= "`nCircle Radius from Area:`n"
areas := [10, 50, 100, 314.159]
for area in areas {
    radius := RadiusFromArea(area)
    output .= "  Area " Format("{:.2f}", area) " → Radius = " Format("{:.4f}", radius) "`n"
}

; Square sides from areas
output .= "`nSquare Side from Area:`n"
squareAreas := [4, 9, 16, 25, 100]
for area in squareAreas {
    side := SquareSideFromArea(area)
    output .= "  Area " area " → Side = " Format("{:.4f}", side) "`n"
}

MsgBox(output, "Practical Applications", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
                                            (
                                            SQRT() FUNCTION REFERENCE:

                                            Syntax:
                                            Result := Sqrt(Number)

                                            Parameters:
                                            Number - Non-negative number to calculate square root

                                            Return Value:
                                            Float - The square root of the number

                                            Key Points:
                                            • Returns the principal (positive) square root
                                            • Input must be non-negative (≥ 0)
                                            • Returns Float, not Integer
                                            • Essential for distance formulas
                                            • Used in Pythagorean theorem: c = √(a² + b²)

                                            Common Formulas:
                                            ✓ Distance 2D: d = √((x₂-x₁)² + (y₂-y₁)²)
                                            ✓ Distance 3D: d = √((x₂-x₁)² + (y₂-y₁)² + (z₂-z₁)²)
                                            ✓ Vector magnitude: |v| = √(x² + y² + z²)
                                            ✓ Radius from area: r = √(A/π)
                                            ✓ Square side from area: s = √A

                                            Perfect Squares:
                                            1² = 1, 2² = 4, 3² = 9, 4² = 16, 5² = 25
                                            6² = 36, 7² = 49, 8² = 64, 9² = 81, 10² = 100
                                            12² = 144, 15² = 225, 20² = 400

                                            Common Square Roots:
                                            √2 ≈ 1.414 (diagonal of unit square)
                                            √3 ≈ 1.732 (height of equilateral triangle)
                                            √5 ≈ 2.236 (diagonal of 1×2 rectangle)
                                            )"

MsgBox(info, "Sqrt() Reference", "Icon!")
