#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Property Descriptors - Temperature Converter
 * 
 * Demonstrates get/set property descriptors for computed properties.
 * Temperature class with Celsius, Fahrenheit, and Kelvin conversions.
 * 
 * Source: AHK_Notes/Concepts/property-get-set-descriptors.md
 */

; Create temperature object
temp := Temperature(25)  ; 25°C

MsgBox("Initial: 25°C`n`n"
    . "Celsius: " temp.Celsius "`n"
    . "Fahrenheit: " temp.Fahrenheit "`n"
    . "Kelvin: " temp.Kelvin, , "T5")

; Set via Fahrenheit
temp.Fahrenheit := 68
MsgBox("After setting to 68°F:`n`n"
    . "Celsius: " temp.Celsius "`n"
    . "Fahrenheit: " temp.Fahrenheit "`n"
    . "Kelvin: " temp.Kelvin, , "T5")

; Test validation (absolute zero)
try {
    temp.Celsius := -300  ; Below absolute zero
} catch Error as err {
    MsgBox("Validation error:`n" err.Message, "Error", "Icon!")
}

/**
 * Temperature Class
 * Stores in Celsius, computes other units via descriptors
 */
class Temperature {
    _celsius := 0

    __New(celsius := 0) {
        this._celsius := celsius
    }

    /**
     * Define properties in static constructor
     */
    static __New() {
        ; Celsius property (stored value)
        this.Prototype.DefineProp("Celsius", {
            get: (this) => this._celsius,
            set: (this, value) {
                if (value < -273.15)
                    throw ValueError("Below absolute zero (-273.15°C)")
                this._celsius := value
            }
        })

        ; Fahrenheit property (computed)
        this.Prototype.DefineProp("Fahrenheit", {
            get: (this) => (this._celsius * 9 / 5) + 32,
            set: (this, value) {
                celsius := (value - 32) * 5 / 9
                if (celsius < -273.15)
                    throw ValueError("Below absolute zero")
                this._celsius := celsius
            }
        })

        ; Kelvin property (computed)
        this.Prototype.DefineProp("Kelvin", {
            get: (this) => this._celsius + 273.15,
            set: (this, value) {
                celsius := value - 273.15
                if (celsius < -273.15)
                    throw ValueError("Below absolute zero (0K)")
                this._celsius := celsius
            }
        })
    }
}

/*
* Key Concepts:
*
* 1. Property Descriptors:
*    DefineProp("Name", {get: func, set: func})
*    - get: Called when property is read
*    - set: Called when property is written
*
* 2. Computed Properties:
*    - Fahrenheit/Kelvin computed from Celsius
*    - No duplicate storage
*    - Always in sync
*
* 3. Validation:
*    - Set methods can validate
*    - Throw errors for invalid values
*    - Enforce constraints
*
* 4. Benefits:
*    ✅ Clean API (temp.Fahrenheit = 68)
*    ✅ Automatic conversion
*    ✅ Validation enforced
*    ✅ Single source of truth
*/

