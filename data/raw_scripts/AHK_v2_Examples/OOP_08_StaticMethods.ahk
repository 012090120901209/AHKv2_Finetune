#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Static Methods - Class-Level Functionality
 *
 * Demonstrates static methods that belong to the class rather than
 * instances. Useful for utility functions and factory patterns.
 *
 * Source: AHK_Notes/Classes/class-static-methods.md
 */

; Test MathUtils static methods
numbers := [10, 25, 30, 15, 20]

MsgBox("MathUtils Static Methods:`n`n"
     . "Numbers: [" Join(numbers) "]`n`n"
     . "Average: " MathUtils.Average(numbers) "`n"
     . "Max: " MathUtils.Max(numbers) "`n"
     . "Min: " MathUtils.Min(numbers) "`n"
     . "Sum: " MathUtils.Sum(numbers), , "T5")

; Test StringUtils static methods
text := "Hello World"
MsgBox("StringUtils Static Methods:`n`n"
     . "Text: '" text "'`n`n"
     . "Reverse: '" StringUtils.Reverse(text) "'`n"
     . "WordCount: " StringUtils.WordCount(text) "`n"
     . "IsPalindrome('racecar'): " StringUtils.IsPalindrome("racecar"), , "T5")

; Test factory pattern with static method
user1 := User.Create("Alice", "alice@example.com")
user2 := User.Create("Bob", "bob@example.com")

MsgBox("Factory Pattern:`n`n"
     . "Created " User.GetCount() " users:`n"
     . user1.GetInfo() "`n`n"
     . user2.GetInfo(), , "T5")

/**
 * MathUtils - Static utility methods for math operations
 */
class MathUtils {
    /**
     * Calculate average of numbers
     */
    static Average(numbers) {
        if (numbers.Length == 0)
            return 0
        return this.Sum(numbers) / numbers.Length
    }

    /**
     * Find maximum value
     */
    static Max(numbers) {
        if (numbers.Length == 0)
            return 0

        max := numbers[1]
        for num in numbers {
            if (num > max)
                max := num
        }
        return max
    }

    /**
     * Find minimum value
     */
    static Min(numbers) {
        if (numbers.Length == 0)
            return 0

        min := numbers[1]
        for num in numbers {
            if (num < min)
                min := num
        }
        return min
    }

    /**
     * Calculate sum (used by Average)
     */
    static Sum(numbers) {
        total := 0
        for num in numbers
            total += num
        return total
    }
}

/**
 * StringUtils - Static utility methods for strings
 */
class StringUtils {
    /**
     * Reverse a string
     */
    static Reverse(str) {
        reversed := ""
        Loop Parse, str
            reversed := A_LoopField reversed
        return reversed
    }

    /**
     * Count words in text
     */
    static WordCount(text) {
        count := 0
        Loop Parse, text, " `t`n`r"
            if (StrLen(Trim(A_LoopField)) > 0)
                count++
        return count
    }

    /**
     * Check if string is palindrome
     */
    static IsPalindrome(str) {
        cleaned := StrReplace(StrLower(str), " ", "")
        return cleaned == this.Reverse(cleaned)
    }
}

/**
 * User - Class with static factory method
 */
class User {
    static _count := 0  ; Static property (shared across all instances)

    name := ""
    email := ""
    id := 0

    __New(name, email) {
        this.name := name
        this.email := email
        this.id := ++User._count
    }

    /**
     * Static factory method
     */
    static Create(name, email) {
        return User(name, email)
    }

    /**
     * Get total user count (static)
     */
    static GetCount() {
        return this._count
    }

    /**
     * Instance method
     */
    GetInfo() {
        return "User #" this.id ": " this.name " (" this.email ")"
    }
}

/**
 * Join helper function
 */
Join(arr, delimiter := ", ") {
    result := ""
    for index, value in arr {
        result .= value (index < arr.Length ? delimiter : "")
    }
    return result
}

/*
 * Key Concepts:
 *
 * 1. Static Method Syntax:
 *    class MyClass {
 *        static MethodName(params) {
 *            ; No access to instance 'this'
 *        }
 *    }
 *
 * 2. Calling Static Methods:
 *    result := MyClass.MethodName(args)
 *    No instance needed
 *    Called directly on class
 *
 * 3. Static vs Instance:
 *    Static: Belongs to class
 *    Instance: Belongs to object
 *    Static can't access instance data
 *    Instance can't access static without class name
 *
 * 4. Static Properties:
 *    static _count := 0
 *    Shared across ALL instances
 *    Used for counters, caches
 *
 * 5. Static Accessing Static:
 *    this.OtherStaticMethod()  ; Within static method
 *    this.staticProperty       ; Access static property
 *
 * 6. Use Cases:
 *    ✅ Utility functions (MathUtils, StringUtils)
 *    ✅ Factory methods (User.Create)
 *    ✅ Counters and tracking
 *    ✅ Configuration
 *    ✅ Singleton pattern
 *
 * 7. Benefits:
 *    ✅ No instance creation needed
 *    ✅ Organized code (namespace)
 *    ✅ Memory efficient
 *    ✅ Clear intent
 *
 * 8. Factory Pattern:
 *    static Create(params) {
 *        return MyClass(params)
 *    }
 *    Centralized object creation
 *    Can add validation, logging
 */
