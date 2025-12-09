#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Property Descriptors - Validation and Computed Properties
*
* Demonstrates using property descriptors for data validation,
* computed properties, and maintaining data consistency.
*
* Source: AHK_Notes/Concepts/property-get-set-descriptors.md
*/

; Test User class with validation
user := User()
user.Name := "Alice"
user.Email := "alice@example.com"
user.Age := 25

MsgBox(user.GetInfo(), "Valid User", "T3")

; Test validation
try {
    user.Age := -5  ; Should throw error
} catch as err {
    MsgBox("Validation Error:`n" err.Message, , "T3")
}

try {
    user.Email := "invalid-email"  ; Should throw error
} catch as err {
    MsgBox("Validation Error:`n" err.Message, , "T3")
}

; Test Rectangle with computed properties
rect := Rectangle(5, 10)
MsgBox("Rectangle:`n`n"
. "Width: " rect.Width "`n"
. "Height: " rect.Height "`n"
. "Area: " rect.Area " (computed)`n"
. "Perimeter: " rect.Perimeter " (computed)", , "T3")

rect.Width := 8
MsgBox("After changing width to 8:`n`n"
. "Area: " rect.Area "`n"
. "Perimeter: " rect.Perimeter, , "T3")

/**
* User - Class with validated properties
*/
class User {
    _name := ""
    _email := ""
    _age := 0

    /**
    * Name property with validation
    */
    Name {
        get => this._name

        set {
            if (StrLen(value) < 2)
            throw ValueError("Name must be at least 2 characters")
            this._name := value
        }
    }

    /**
    * Email property with validation
    */
    Email {
        get => this._email

        set {
            if (!RegExMatch(value, "i)^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"))
            throw ValueError("Invalid email format")
            this._email := value
        }
    }

    /**
    * Age property with range validation
    */
    Age {
        get => this._age

        set {
            if (value < 0 || value > 150)
            throw ValueError("Age must be between 0 and 150")
            this._age := value
        }
    }

    /**
    * IsAdult - Computed property (no storage)
    */
    IsAdult {
        get => this._age >= 18
    }

    GetInfo() {
        return "Name: " this.Name "`n"
        . "Email: " this.Email "`n"
        . "Age: " this.Age "`n"
        . "Is Adult: " (this.IsAdult ? "Yes" : "No")
    }
}

/**
* Rectangle - Class with computed properties
*/
class Rectangle {
    _width := 0
    _height := 0

    __New(width, height) {
        this.Width := width
        this.Height := height
    }

    /**
    * Width with validation
    */
    Width {
        get => this._width

        set {
            if (value <= 0)
            throw ValueError("Width must be positive")
            this._width := value
        }
    }

    /**
    * Height with validation
    */
    Height {
        get => this._height

        set {
            if (value <= 0)
            throw ValueError("Height must be positive")
            this._height := value
        }
    }

    /**
    * Area - Computed property (not stored)
    */
    Area {
        get => this._width * this._height
    }

    /**
    * Perimeter - Computed property
    */
    Perimeter {
        get => 2 * (this._width + this._height)
    }

    /**
    * IsSquare - Computed boolean property
    */
    IsSquare {
        get => this._width == this._height
    }
}

/*
* Key Concepts:
*
* 1. Property Descriptor Syntax:
*    PropertyName {
    *        get => expression
    *        set {
        *            ; validation logic
        *            this._field := value
        *        }
        *    }
        *
        * 2. Validation Pattern:
        *    set {
            *        if (condition)
            *            throw ValueError("Error message")
            *        this._field := value
            *    }
            *
            * 3. Computed Properties:
            *    Area {
                *        get => this._width * this._height
                *    }
                *    No storage, calculated on demand
                *
                * 4. Private Fields:
                *    _name := ""  ; Convention: underscore prefix
                *    Direct access bypasses validation
                *    Use property accessors externally
                *
                * 5. Read-Only Properties:
                *    IsAdult {
                    *        get => this._age >= 18
                    *    }
                    *    No setter = read-only
                    *
                    * 6. Benefits:
                    *    ✅ Data integrity (validation)
                    *    ✅ Consistent state
                    *    ✅ Computed values (no storage)
                    *    ✅ Encapsulation
                    *    ✅ Change tracking possible
                    *
                    * 7. Common Validations:
                    *    - Range checks (min/max)
                    *    - Format validation (email, phone)
                    *    - Length constraints
                    *    - Type checking
                    *    - Business rules
                    *
                    * 8. Arrow vs Block Syntax:
                    *    get => simple_expression  ; Arrow for simple
                    *    set {                     ; Block for complex
                    *        ; validation
                    *        ; transformation
                    *    }
                    */
