#Requires AutoHotkey v2.0

/**
* BuiltIn_Sqrt_02_Geometry.ahk
*
* DESCRIPTION:
* Geometric applications of Sqrt() function including Pythagorean theorem and circle calculations
*
* FEATURES:
* - Pythagorean theorem (right triangles)
* - Circle circumference and area calculations
* - Triangle properties and calculations
* - Polygon diagonal calculations
* - Sphere and cylinder formulas
*
* SOURCE:
* AutoHotkey v2 Documentation & Geometric Mathematics
* https://www.autohotkey.com/docs/v2/lib/Math.htm#Sqrt
*
* KEY V2 FEATURES DEMONSTRATED:
* - Sqrt() function in geometric formulas
* - Class-based geometry objects
* - Method chaining
* - Property calculations
* - Mathematical constant definitions
*
* LEARNING POINTS:
* 1. Pythagorean theorem: c² = a² + b²
* 2. Circle radius from circumference or area
* 3. Triangle height calculations
* 4. Polygon diagonal formulas
* 5. 3D shape calculations with square roots
*/

; Mathematical constants
global PI := 3.14159265359

; ============================================================
; Example 1: Pythagorean Theorem - Right Triangles
; ============================================================

/**
* Calculate hypotenuse of right triangle
*
* @param {Number} a - First leg
* @param {Number} b - Second leg
* @returns {Number} - Hypotenuse length
*/
Hypotenuse(a, b) {
    return Sqrt(a * a + b * b)
}

/**
* Calculate leg of right triangle given hypotenuse and other leg
*
* @param {Number} c - Hypotenuse
* @param {Number} a - Known leg
* @returns {Number} - Unknown leg length
*/
RightTriangleLeg(c, a) {
    ; b² = c² - a²
    return Sqrt(c * c - a * a)
}

; Famous Pythagorean triples and other triangles
triangles := [
{
    a: 3, b: 4, name: "3-4-5 Triple"},
    {
        a: 5, b: 12, name: "5-12-13 Triple"},
        {
            a: 8, b: 15, name: "8-15-17 Triple"},
            {
                a: 7, b: 24, name: "7-24-25 Triple"},
                {
                    a: 1, b: 1, name: "45-45-90 Triangle"},
                    {
                        a: 1, b: Sqrt(3), name: "30-60-90 Triangle"},
                        {
                            a: 6, b: 8, name: "6-8-10 Triple"
                        }
                        ]

                        output := "PYTHAGOREAN THEOREM - RIGHT TRIANGLES:`n`n"

                        for tri in triangles {
                            c := Hypotenuse(tri.a, tri.b)
                            output .= tri.name ":"
                            output .= "`n  Legs: " Format("{:.4f}", tri.a) " and " Format("{:.4f}", tri.b)
                            output .= "`n  Hypotenuse: " Format("{:.4f}", c) "`n`n"
                        }

                        MsgBox(output, "Pythagorean Theorem", "Icon!")

                        ; ============================================================
                        ; Example 2: Circle Calculations
                        ; ============================================================

                        class Circle {
                            __New(radius) {
                                this.radius := radius
                            }

                            Area() {
                                return PI * this.radius * this.radius
                            }

                            Circumference() {
                                return 2 * PI * this.radius
                            }

                            Diameter() {
                                return 2 * this.radius
                            }

                            /**
                            * Create circle from area
                            */
                            static FromArea(area) {
                                radius := Sqrt(area / PI)
                                return Circle(radius)
                            }

                            /**
                            * Create circle from circumference
                            */
                            static FromCircumference(circ) {
                                radius := circ / (2 * PI)
                                return Circle(radius)
                            }

                            ToString() {
                                return Format("Circle(r={:.4f}, A={:.4f}, C={:.4f})",
                                this.radius, this.Area(), this.Circumference())
                            }
                        }

                        output := "CIRCLE CALCULATIONS:`n`n"

                        ; Circles from radius
                        radii := [1, 2, 5, 10]
                        output .= "Circles from Radius:`n"
                        for r in radii {
                            c := Circle(r)
                            output .= "  " c.ToString() "`n"
                        }

                        ; Circles from area
                        output .= "`nCircles from Area:`n"
                        areas := [10, 50, 100, 314.159]
                        for area in areas {
                            c := Circle.FromArea(area)
                            output .= "  Area=" Format("{:.2f}", area) " → " c.ToString() "`n"
                        }

                        ; Circles from circumference
                        output .= "`nCircles from Circumference:`n"
                        circumferences := [10, 20, 31.416, 62.832]
                        for circ in circumferences {
                            c := Circle.FromCircumference(circ)
                            output .= "  Circ=" Format("{:.2f}", circ) " → " c.ToString() "`n"
                        }

                        MsgBox(output, "Circle Calculations", "Icon!")

                        ; ============================================================
                        ; Example 3: Triangle Height and Area
                        ; ============================================================

                        /**
                        * Calculate triangle height using Pythagorean theorem
                        * For isosceles triangle with base b and equal sides a
                        *
                        * @param {Number} side - Length of equal sides
                        * @param {Number} base - Length of base
                        * @returns {Number} - Height of triangle
                        */
                        IsoscelesHeight(side, base) {
                            ; Height splits base in half, forming right triangle
                            ; h² = side² - (base/2)²
                            halfBase := base / 2
                            return Sqrt(side * side - halfBase * halfBase)
                        }

                        /**
                        * Calculate area of triangle using base and height
                        */
                        TriangleArea(base, height) {
                            return 0.5 * base * height
                        }

                        /**
                        * Calculate equilateral triangle height
                        * All sides equal, height = (√3/2) * side
                        */
                        EquilateralHeight(side) {
                            return (Sqrt(3) / 2) * side
                        }

                        triangles := [
                        {
                            side: 5, base: 6, type: "Isosceles"},
                            {
                                side: 5, base: 8, type: "Isosceles"},
                                {
                                    side: 10, base: 12, type: "Isosceles"},
                                    {
                                        side: 13, base: 10, type: "Isosceles"
                                    }
                                    ]

                                    output := "TRIANGLE HEIGHT CALCULATIONS:`n`n"

                                    for tri in triangles {
                                        height := IsoscelesHeight(tri.side, tri.base)
                                        area := TriangleArea(tri.base, height)
                                        output .= tri.type " Triangle:"
                                        output .= "`n  Sides: " tri.side ", " tri.side ", " tri.base
                                        output .= "`n  Height: " Format("{:.4f}", height)
                                        output .= "`n  Area: " Format("{:.4f}", area) "`n`n"
                                    }

                                    ; Equilateral triangles
                                    output .= "Equilateral Triangles:`n"
                                    sides := [4, 6, 8, 10]
                                    for side in sides {
                                        height := EquilateralHeight(side)
                                        area := TriangleArea(side, height)
                                        output .= "  Side=" side " → Height=" Format("{:.4f}", height)
                                        output .= ", Area=" Format("{:.4f}", area) "`n"
                                    }

                                    MsgBox(output, "Triangle Calculations", "Icon!")

                                    ; ============================================================
                                    ; Example 4: Rectangle and Square Diagonals
                                    ; ============================================================

                                    class Rectangle {
                                        __New(width, height) {
                                            this.width := width
                                            this.height := height
                                        }

                                        Diagonal() {
                                            return Sqrt(this.width * this.width + this.height * this.height)
                                        }

                                        Area() {
                                            return this.width * this.height
                                        }

                                        Perimeter() {
                                            return 2 * (this.width + this.height)
                                        }

                                        ToString() {
                                            return Format("Rectangle({:.2f}×{:.2f}, d={:.4f}, A={:.2f})",
                                            this.width, this.height, this.Diagonal(), this.Area())
                                        }
                                    }

                                    class Square extends Rectangle {
                                        __New(side) {
                                            super.__New(side, side)
                                            this.side := side
                                        }

                                        Diagonal() {
                                            ; Diagonal of square = side × √2
                                            return this.side * Sqrt(2)
                                        }

                                        ToString() {
                                            return Format("Square(s={:.2f}, d={:.4f}, A={:.2f})",
                                            this.side, this.Diagonal(), this.Area())
                                        }
                                    }

                                    output := "RECTANGLE & SQUARE DIAGONALS:`n`n"

                                    ; Rectangles
                                    output .= "Rectangles:`n"
                                    rectangles := [
                                    Rectangle(3, 4),
                                    Rectangle(5, 12),
                                    Rectangle(8, 15),
                                    Rectangle(7, 24)
                                    ]

                                    for rect in rectangles {
                                        output .= "  " rect.ToString() "`n"
                                    }

                                    ; Squares
                                    output .= "`nSquares:`n"
                                    squares := [Square(1), Square(2), Square(5), Square(10)]
                                    for sq in squares {
                                        output .= "  " sq.ToString() "`n"
                                    }

                                    MsgBox(output, "Rectangles & Squares", "Icon!")

                                    ; ============================================================
                                    ; Example 5: 3D Shapes - Sphere and Cylinder
                                    ; ============================================================

                                    class Sphere {
                                        __New(radius) {
                                            this.radius := radius
                                        }

                                        Volume() {
                                            ; V = (4/3) × π × r³
                                            return (4.0 / 3.0) * PI * this.radius ** 3
                                        }

                                        SurfaceArea() {
                                            ; A = 4 × π × r²
                                            return 4 * PI * this.radius * this.radius
                                        }

                                        /**
                                        * Create sphere from volume
                                        */
                                        static FromVolume(volume) {
                                            ; r = ∛(3V / 4π)
                                            ; For simplicity using numeric approximation
                                            r := (3 * volume / (4 * PI)) ** (1.0/3.0)
                                            return Sphere(r)
                                        }

                                        /**
                                        * Create sphere from surface area
                                        */
                                        static FromSurfaceArea(area) {
                                            ; A = 4πr²
                                            ; r = √(A / 4π)
                                            r := Sqrt(area / (4 * PI))
                                            return Sphere(r)
                                        }

                                        ToString() {
                                            return Format("Sphere(r={:.4f}, V={:.4f}, SA={:.4f})",
                                            this.radius, this.Volume(), this.SurfaceArea())
                                        }
                                    }

                                    class Cylinder {
                                        __New(radius, height) {
                                            this.radius := radius
                                            this.height := height
                                        }

                                        Volume() {
                                            ; V = π × r² × h
                                            return PI * this.radius * this.radius * this.height
                                        }

                                        SurfaceArea() {
                                            ; SA = 2πr² + 2πrh = 2πr(r + h)
                                            return 2 * PI * this.radius * (this.radius + this.height)
                                        }

                                        ToString() {
                                            return Format("Cylinder(r={:.2f}, h={:.2f}, V={:.4f}, SA={:.4f})",
                                            this.radius, this.height, this.Volume(), this.SurfaceArea())
                                        }
                                    }

                                    output := "3D SHAPE CALCULATIONS:`n`n"

                                    ; Spheres
                                    output .= "Spheres from Radius:`n"
                                    spheres := [Sphere(1), Sphere(2), Sphere(5), Sphere(10)]
                                    for s in spheres {
                                        output .= "  " s.ToString() "`n"
                                    }

                                    output .= "`nSpheres from Surface Area:`n"
                                    areas := [50, 100, 314.159]
                                    for area in areas {
                                        s := Sphere.FromSurfaceArea(area)
                                        output .= "  SA=" Format("{:.2f}", area) " → " s.ToString() "`n"
                                    }

                                    ; Cylinders
                                    output .= "`nCylinders:`n"
                                    cylinders := [
                                    Cylinder(2, 5),
                                    Cylinder(3, 10),
                                    Cylinder(5, 5),
                                    Cylinder(1, 10)
                                    ]
                                    for cyl in cylinders {
                                        output .= "  " cyl.ToString() "`n"
                                    }

                                    MsgBox(output, "3D Shapes", "Icon!")

                                    ; ============================================================
                                    ; Example 6: Distance from Point to Line
                                    ; ============================================================

                                    /**
                                    * Calculate perpendicular distance from point to line
                                    * Line in form: ax + by + c = 0
                                    *
                                    * @param {Number} x0, y0 - Point coordinates
                                    * @param {Number} a, b, c - Line coefficients
                                    * @returns {Number} - Distance from point to line
                                    */
                                    PointToLineDistance(x0, y0, a, b, c) {
                                        ; Distance = |ax₀ + by₀ + c| / √(a² + b²)
                                        numerator := Abs(a * x0 + b * y0 + c)
                                        denominator := Sqrt(a * a + b * b)
                                        return numerator / denominator
                                    }

                                    /**
                                    * Distance from point to line segment
                                    */
                                    PointToSegmentDistance(px, py, x1, y1, x2, y2) {
                                        ; Vector from point1 to point2
                                        dx := x2 - x1
                                        dy := y2 - y1

                                        ; If segment is a point
                                        if (dx = 0 && dy = 0) {
                                            return Sqrt((px - x1) ** 2 + (py - y1) ** 2)
                                        }

                                        ; Calculate parameter t
                                        t := ((px - x1) * dx + (py - y1) * dy) / (dx * dx + dy * dy)

                                        ; Clamp t to [0, 1] for segment
                                        if (t < 0)
                                        t := 0
                                        else if (t > 1)
                                        t := 1

                                        ; Find closest point on segment
                                        closestX := x1 + t * dx
                                        closestY := y1 + t * dy

                                        ; Return distance to closest point
                                        return Sqrt((px - closestX) ** 2 + (py - closestY) ** 2)
                                    }

                                    output := "POINT TO LINE DISTANCE:`n`n"

                                    ; Test points and lines
                                    tests := [
                                    {
                                        x: 0, y: 0, a: 1, b: 0, c: -5, desc: "Origin to vertical line x=5"},
                                        {
                                            x: 0, y: 0, a: 0, b: 1, c: -3, desc: "Origin to horizontal line y=3"},
                                            {
                                                x: 3, y: 4, a: 1, b: 1, c: 0, desc: "(3,4) to line x+y=0"},
                                                {
                                                    x: 2, y: 3, a: 3, b: 4, c: -25, desc: "(2,3) to line 3x+4y=25"
                                                }
                                                ]

                                                for test in tests {
                                                    dist := PointToLineDistance(test.x, test.y, test.a, test.b, test.c)
                                                    output .= test.desc "`n"
                                                    output .= "  Distance: " Format("{:.4f}", dist) "`n`n"
                                                }

                                                MsgBox(output, "Point to Line Distance", "Icon!")

                                                ; ============================================================
                                                ; Example 7: Geometric Mean and RMS
                                                ; ============================================================

                                                /**
                                                * Calculate geometric mean of two numbers
                                                * Used in geometry for similar triangles
                                                */
                                                GeometricMean(a, b) {
                                                    return Sqrt(a * b)
                                                }

                                                /**
                                                * Calculate Root Mean Square (RMS)
                                                */
                                                RMS(numbers*) {
                                                    sumSquares := 0
                                                    for num in numbers {
                                                        sumSquares += num * num
                                                    }
                                                    return Sqrt(sumSquares / numbers.Length)
                                                }

                                                output := "GEOMETRIC MEAN & RMS:`n`n"

                                                ; Geometric means
                                                output .= "Geometric Mean (√(a×b)):`n"
                                                pairs := [[1, 4], [2, 8], [3, 12], [4, 9], [5, 20]]
                                                for pair in pairs {
                                                    gm := GeometricMean(pair[1], pair[2])
                                                    output .= "  GM(" pair[1] ", " pair[2] ") = " Format("{:.4f}", gm) "`n"
                                                }

                                                ; RMS calculations
                                                output .= "`nRoot Mean Square (RMS):`n"
                                                datasets := [
                                                [1, 2, 3, 4, 5],
                                                [10, 20, 30],
                                                [3, 4, 5, 6, 7, 8],
                                                [100, 200, 300, 400]
                                                ]

                                                for data in datasets {
                                                    rmsVal := RMS(data*)
                                                    output .= "  RMS(" StrReplace(Format("{:s}", data), " ", ", ") ") = "
                                                    output .= Format("{:.4f}", rmsVal) "`n"
                                                }

                                                MsgBox(output, "Geometric Mean & RMS", "Icon!")

                                                ; ============================================================
                                                ; Reference Information
                                                ; ============================================================

                                                info := "
                                                (
                                                SQRT IN GEOMETRY REFERENCE:

                                                Pythagorean Theorem:
                                                c² = a² + b²
                                                c = √(a² + b²)

                                                Circle Formulas:
                                                Area: A = πr²  →  r = √(A/π)
                                                Circumference: C = 2πr  →  r = C/(2π)

                                                Triangle Heights:
                                                Isosceles: h = √(s² - (b/2)²)
                                                Equilateral: h = (√3/2)s

                                                Rectangle Diagonal:
                                                d = √(w² + h²)

                                                Square Diagonal:
                                                d = s√2

                                                Sphere:
                                                Surface Area: A = 4πr²  →  r = √(A/(4π))
                                                Volume: V = (4/3)πr³

                                                3D Distance:
                                                d = √((x₂-x₁)² + (y₂-y₁)² + (z₂-z₁)²)

                                                Point to Line Distance:
                                                d = |ax₀ + by₀ + c| / √(a² + b²)

                                                Geometric Mean:
                                                GM = √(a × b)

                                                RMS (Root Mean Square):
                                                RMS = √((x₁² + x₂² + ... + xₙ²) / n)

                                                Famous Pythagorean Triples:
                                                (3, 4, 5)    (5, 12, 13)   (8, 15, 17)
                                                (7, 24, 25)  (20, 21, 29)  (9, 40, 41)
                                                )"

                                                MsgBox(info, "Sqrt in Geometry Reference", "Icon!")
