#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Matrix - 2D array operations
; Demonstrates mathematical matrix operations

class Matrix {
    __New(rows, cols := "", fill := 0) {
        if IsObject(rows) {
            ; Initialize from 2D array
            this.data := rows
            this.rows := rows.Length
            this.cols := rows.Length > 0 ? rows[1].Length : 0
        } else {
            this.rows := rows
            this.cols := cols ?? rows
            this.data := []
            Loop this.rows {
                row := []
                Loop this.cols
                    row.Push(fill)
                this.data.Push(row)
            }
        }
    }

    Get(row, col) => this.data[row][col]

    Set(row, col, value) {
        this.data[row][col] := value
        return this
    }

    static Identity(n) {
        m := Matrix(n, n)
        Loop n
            m.Set(A_Index, A_Index, 1)
        return m
    }

    static Zero(rows, cols) => Matrix(rows, cols, 0)

    Add(other) {
        if this.rows != other.rows || this.cols != other.cols
            throw Error("Matrix dimensions must match")

        result := Matrix(this.rows, this.cols)
        Loop this.rows {
            r := A_Index
            Loop this.cols {
                c := A_Index
                result.Set(r, c, this.Get(r, c) + other.Get(r, c))
            }
        }
        return result
    }

    Multiply(other) {
        if IsNumber(other) {
            ; Scalar multiplication
            result := Matrix(this.rows, this.cols)
            Loop this.rows {
                r := A_Index
                Loop this.cols {
                    c := A_Index
                    result.Set(r, c, this.Get(r, c) * other)
                }
            }
            return result
        }

        ; Matrix multiplication
        if this.cols != other.rows
            throw Error("Invalid dimensions for multiplication")

        result := Matrix(this.rows, other.cols)
        Loop this.rows {
            r := A_Index
            Loop other.cols {
                c := A_Index
                sum := 0
                Loop this.cols {
                    k := A_Index
                    sum += this.Get(r, k) * other.Get(k, c)
                }
                result.Set(r, c, sum)
            }
        }
        return result
    }

    Transpose() {
        result := Matrix(this.cols, this.rows)
        Loop this.rows {
            r := A_Index
            Loop this.cols {
                c := A_Index
                result.Set(c, r, this.Get(r, c))
            }
        }
        return result
    }

    Trace() {
        if this.rows != this.cols
            throw Error("Trace only for square matrices")
        sum := 0
        Loop this.rows
            sum += this.Get(A_Index, A_Index)
        return sum
    }

    ToString() {
        result := ""
        Loop this.rows {
            r := A_Index
            row := "["
            Loop this.cols {
                c := A_Index
                row .= (c > 1 ? ", " : "") Format("{:6.2f}", this.Get(r, c))
            }
            result .= row "]`n"
        }
        return result
    }
}

; Demo
m1 := Matrix([[1, 2, 3], [4, 5, 6]])
m2 := Matrix([[7, 8], [9, 10], [11, 12]])

result := "Matrix M1 (2x3):`n" m1.ToString()
result .= "`nMatrix M2 (3x2):`n" m2.ToString()

; Multiplication
m3 := m1.Multiply(m2)
result .= "`nM1 × M2 (2x2):`n" m3.ToString()

MsgBox(result)

; Identity and operations
identity := Matrix.Identity(3)
m4 := Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

result := "Identity Matrix (3x3):`n" identity.ToString()
result .= "`nMatrix M4:`n" m4.ToString()
result .= "`nM4 × Identity:`n" m4.Multiply(identity).ToString()
result .= "`nTranspose of M4:`n" m4.Transpose().ToString()
result .= "`nTrace of M4: " m4.Trace()

MsgBox(result)

; Scalar multiplication
result := "M4 × 2:`n" m4.Multiply(2).ToString()
MsgBox(result)
