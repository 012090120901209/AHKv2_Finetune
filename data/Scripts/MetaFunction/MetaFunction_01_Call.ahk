#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* __Call Meta-Function - Undefined Method Handler
*
* Demonstrates the __Call meta-function which intercepts calls
* to undefined methods. Useful for error handling and debugging.
*
* Source: AHK_Notes/Methods/__call-method.md
*/

; Create instance and test method calls
menu := MenuSystem()

MsgBox("Testing defined methods...", , "T2")
menu.SetupProperties()  ; Works - method exists
menu.CreateMenus()      ; Works - method exists

MsgBox("Testing undefined method (typo)...", , "T2")
menu.SetupPropertie()   ; Typo - triggers __Call

MsgBox("Testing completely undefined method...", , "T2")
menu.NonExistentMethod()  ; Triggers __Call

/**
* MenuSystem Class
*
* Demonstrates __Call for catching undefined method calls
*/
class MenuSystem {
    static Name := "MenuSystem"

    __New() {
        this.SetupProperties()
    }

    /**
    * __Call Meta-Function
    *
    * Automatically called when an undefined method is invoked.
    *
    * @param Method - Name of the undefined method
    * @param Args - Array of arguments passed to the method
    */
    __Call(Method, Args*) {
        errorMsg := "Error: Method '" Method "' does not exist in class " MenuSystem.Name

        ; Add suggestion for common typos
        if (Method = "SetupPropertie")
        errorMsg .= "`n`nDid you mean: SetupProperties()?"
        else if (Method = "CreateMenu")
        errorMsg .= "`n`nDid you mean: CreateMenus()?"

        MsgBox(errorMsg, "Method Not Found", "Icon!")
        return
    }

    /**
    * Defined methods - these work normally
    */
    SetupProperties() {
        MsgBox("✓ SetupProperties executed successfully", , "T2")
    }

    CreateMenus() {
        MsgBox("✓ CreateMenus executed successfully", , "T2")
    }
}

/*
* Key Concepts:
*
* 1. __Call Meta-Function:
*    - Invoked when calling undefined methods
*    - Receives method name and arguments
*    - Allows custom error handling
*    - Can implement dynamic method dispatch
*
* 2. Parameters:
*    Method - String with the method name
*    Args* - Variadic parameter with all arguments
*
* 3. Use Cases:
*
*    Error Handling:
*    - Catch typos in method names
*    - Provide helpful error messages
*    - Suggest corrections
*
*    Dynamic Methods:
*    - Implement method_missing pattern
*    - Generate methods on-the-fly
*    - Proxy pattern implementation
*
*    Logging:
*    - Log all undefined method calls
*    - Debug missing implementations
*    - Track usage patterns
*
* 4. Example: Dynamic Getters/Setters
*
*    class DynamicObject {
    *        data := Map()
    *
    *        __Call(Method, Args*) {
        *            ; Intercept get_* and set_* methods
        *            if (SubStr(Method, 1, 4) = "get_") {
            *                key := SubStr(Method, 5)
            *                return this.data[key] ?? ""
            *            }
            *            else if (SubStr(Method, 1, 4) = "set_") {
                *                key := SubStr(Method, 5)
                *                this.data[key] := Args[1]
                *                return this
                *            }
                *        }
                *    }
                *
                *    obj := DynamicObject()
                *    obj.set_name("John")      ; Creates name property
                *    value := obj.get_name()   ; Retrieves name property
                *
                * 5. Best Practices:
                *    ✅ Provide clear error messages
                *    ✅ Suggest alternatives for common typos
                *    ✅ Use for debugging during development
                *    ✅ Document dynamic behavior
                *    ⚠️  Don't abuse for normal method dispatch
                *    ⚠️  Performance impact - slower than defined methods
                *
                * 6. Related Meta-Functions:
                *    __Get - Intercepts property reads
                *    __Set - Intercepts property writes
                *    __Enum - Custom iteration
                *    __Item - Custom indexing
                *
                * 7. Return Value:
                *    - Can return any value
                *    - Can throw errors
                *    - Can modify state
                *    - Can delegate to other methods
                */
