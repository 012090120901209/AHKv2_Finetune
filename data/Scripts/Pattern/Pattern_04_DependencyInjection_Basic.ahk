#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Dependency Injection Pattern - Basic Concepts
 * 
 * Demonstrates three types of dependency injection:
 * 1. Constructor Injection (most common)
 * 2. Method Injection
 * 3. Property Injection
 * 
 * Source: AHK_Notes/Patterns/dependency-injection.md
 */

; Example 1: Constructor Injection (Recommended)
logger1 := ConsoleLogger()
service1 := UserService(logger1)
service1.CreateUser("john.doe")

; Example 2: Method Injection
service2 := UserServiceMethodInjection()
logger2 := FileLogger("app.log")
service2.CreateUser("jane.doe", logger2)

; Example 3: Property Injection
service3 := UserServicePropertyInjection()
service3.Logger := ConsoleLogger()
service3.CreateUser("bob.smith")

/**
 * Logger Interface (Base Class)
 */
class LoggerBase {
    Log(message) {
        throw Error("Method not implemented")
    }
}

/**
 * Console Logger Implementation
 */
class ConsoleLogger extends LoggerBase {
    Log(message) {
        ; Log to stdout (console)
        FileAppend(FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") " - " message "`n", "*")
        MsgBox("CONSOLE: " message, , "T2")
    }
}

/**
 * File Logger Implementation
 */
class FileLogger extends LoggerBase {
    FilePath := ""

    __New(filePath) {
        this.FilePath := filePath
    }

    Log(message) {
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        FileAppend(timestamp " - " message "`n", this.FilePath)
        MsgBox("FILE: Logged to " this.FilePath, , "T2")
    }
}

/**
 * Example 1: Constructor Injection
 * Dependencies passed via constructor (best practice)
 */
class UserService {
    Logger := ""

    __New(logger) {
        this.Logger := logger
    }

    CreateUser(username) {
        this.Logger.Log("User created: " username)
        return true
    }
}

/**
 * Example 2: Method Injection
 * Dependencies passed as method parameters
 */
class UserServiceMethodInjection {
    CreateUser(username, logger) {
        logger.Log("User created: " username)
        return true
    }
}

/**
 * Example 3: Property Injection
 * Dependencies set as properties after construction
 */
class UserServicePropertyInjection {
    Logger := ""

    CreateUser(username) {
        if (!this.Logger)
            throw Error("Logger not set!")

        this.Logger.Log("User created: " username)
        return true
    }
}

/*
* Key Concepts:
*
* 1. Dependency Injection Benefits:
*    - Loose Coupling: Classes don't create dependencies
*    - Testability: Easy to inject mock objects for testing
*    - Flexibility: Change implementations without modifying code
*    - Maintainability: Dependencies are explicit
*
* 2. Injection Types:
*
*    Constructor Injection (RECOMMENDED):
*    ✅ Dependencies are required and immutable
*    ✅ Object is always in valid state
*    ✅ Clear dependency requirements
*
*    Method Injection:
*    - Use when dependency varies per method call
*    - Less common, useful for optional dependencies
*
*    Property Injection:
*    ⚠️  Dependencies can be changed or forgotten
*    ⚠️  Object may be in invalid state
*    - Use sparingly, prefer constructor injection
*
* 3. Real-World Example:
*    UserService can work with ANY logger implementation
*    (Console, File, Network, Database, etc.)
*    without knowing the implementation details
*/

