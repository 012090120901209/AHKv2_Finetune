#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Class Inheritance - Practical Example
 * 
 * Demonstrates practical class inheritance with a base Employee class
 * and specialized Manager and Developer subclasses.
 * 
 * Source: AHK_Notes/Concepts/class-inheritance.md
 */

; Create different employee types
dev := Developer("Alice", 85000, "JavaScript")
mgr := Manager("Bob", 95000, 5)
senior := SeniorDeveloper("Carol", 105000, "Python", "Backend")

; Display employee information
MsgBox(dev.GetInfo(), "Developer", "T3")
MsgBox(mgr.GetInfo(), "Manager", "T3")
MsgBox(senior.GetInfo(), "Senior Developer", "T3")

; Test salary calculations
MsgBox("Salary Comparison:`n`n"
    . dev.name ": $" dev.GetSalary() "/year`n"
    . mgr.name ": $" mgr.GetSalary() "/year`n"
    . senior.name ": $" senior.GetSalary() "/year", , "T5")

/**
 * Employee - Base Class
 */
class Employee {
    name := ""
    salary := 0
    employeeID := 0
    static nextID := 1000

    __New(name, salary) {
        this.name := name
        this.salary := salary
        this.employeeID := Employee.nextID++
    }

    /**
     * Get employee information
     */
    GetInfo() {
        return "Employee: " this.name "`n"
            . "ID: " this.employeeID "`n"
            . "Salary: $" this.salary
    }

    /**
     * Calculate annual salary
     */
    GetSalary() {
        return this.salary
    }
}

/**
 * Developer - Specializes Employee
 */
class Developer extends Employee {
    primaryLanguage := ""

    __New(name, salary, language) {
        super.__New(name, salary)  ; Initialize parent first
        this.primaryLanguage := language
    }

    /**
     * Override GetInfo to add language
     */
    GetInfo() {
        return super.GetInfo()  ; Get parent info
            . "`nRole: Developer"
            . "`nLanguage: " this.primaryLanguage
    }

    /**
     * Developers get 10% bonus
     */
    GetSalary() {
        bonus := super.GetSalary() * 0.10
        return super.GetSalary() + bonus
    }
}

/**
 * Manager - Specializes Employee
 */
class Manager extends Employee {
    teamSize := 0

    __New(name, salary, teamSize) {
        super.__New(name, salary)
        this.teamSize := teamSize
    }

    GetInfo() {
        return super.GetInfo()
            . "`nRole: Manager"
            . "`nTeam Size: " this.teamSize
    }

    /**
     * Managers get bonus per team member
     */
    GetSalary() {
        bonus := this.teamSize * 2000
        return super.GetSalary() + bonus
    }
}

/**
 * SeniorDeveloper - Multi-level inheritance
 * Inherits from Developer, which inherits from Employee
 */
class SeniorDeveloper extends Developer {
    specialization := ""

    __New(name, salary, language, specialization) {
        super.__New(name, salary, language)
        this.specialization := specialization
    }

    GetInfo() {
        return super.GetInfo()
            . "`nLevel: Senior"
            . "`nSpecialization: " this.specialization
    }

    /**
     * Senior developers get additional 15% bonus
     */
    GetSalary() {
        baseSalary := super.GetSalary()  ; Includes Developer bonus
        seniorBonus := this.salary * 0.15
        return baseSalary + seniorBonus
    }
}

/*
* Key Concepts:
*
* 1. Inheritance Syntax:
*    class Child extends Parent { }
*    Child inherits all parent properties/methods
*
* 2. Constructor Chaining:
*    __New(params) {
    *        super.__New(parentParams)  ; ALWAYS call parent first
    *        ; Then initialize child properties
    *    }
    *
    * 3. Method Overriding:
    *    GetInfo() {
        *        return super.GetInfo()  ; Call parent implementation
        *             . "`nExtra info"    ; Add child-specific data
        *    }
        *
        * 4. Multi-level Inheritance:
        *    SeniorDeveloper -> Developer -> Employee
        *    Each level adds functionality
        *    super refers to immediate parent
        *
        * 5. Static Properties:
        *    static nextID := 1000
        *    Shared across ALL instances
        *    Used for auto-incrementing IDs
        *
        * 6. Polymorphism:
        *    All classes have GetInfo() and GetSalary()
        *    Each implements differently
        *    Same interface, different behavior
        *
        * 7. Benefits:
        *    ✅ Code reuse (no duplication)
        *    ✅ Logical hierarchy
        *    ✅ Easy to extend
        *    ✅ Consistent interface
        *
        * 8. Single Inheritance:
        *    AHK v2 doesn't support multiple inheritance
        *    One parent class only
        *    Use composition for multiple behaviors
*/

