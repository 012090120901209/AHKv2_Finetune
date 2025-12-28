#Requires AutoHotkey v2.0

/**
 * BuiltIn_OOP_Class_04_Static.ahk
 * 
 * DESCRIPTION:
 * Demonstrates static members (properties and methods) in AutoHotkey v2 classes.
 * Static members belong to the class itself rather than instances, useful for
 * shared data, utility functions, and class-level operations.
 * 
 * FEATURES:
 * - Static properties (class variables)
 * - Static methods (class methods)
 * - Static vs instance member access
 * - Instance counting and tracking
 * - Utility/helper static methods
 * - Constants using static properties
 * - Static initialization patterns
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - static keyword for class-level members
 * - Static property access via ClassName.Property
 * - Static method access via ClassName.Method()
 * - Shared state across all instances
 * - Class-level utility functions
 * - Static initialization blocks
 * 
 * LEARNING POINTS:
 * 1. Static members belong to the class, not instances
 * 2. Static members are shared across all instances
 * 3. Static methods can't access instance members directly
 * 4. Static members are accessed via class name
 * 5. Useful for counters, constants, and utilities
 * 6. Static methods can be factory methods
 * 7. Instance methods can access static members
 */

; ========================================
; EXAMPLE 1: Basic Static Properties and Methods
; ========================================
; Understanding the difference between static and instance members

class Counter {
    ; Static property - shared across all instances
    static TotalCount := 0

    ; Instance property - unique to each instance
    InstanceCount := 0
    Name := ""

    __New(name := "Counter") {
        this.Name := name
        ; Increment both static and instance counters
        Counter.TotalCount++
        this.InstanceCount := 0
    }

    ; Instance method
    Increment() {
        this.InstanceCount++
        Counter.TotalCount++
        return this.InstanceCount
    }

    ; Static method
    static GetTotalCount() {
        return Counter.TotalCount
    }

    ; Static method to reset all counters
    static ResetAll() {
        Counter.TotalCount := 0
        return "All counters reset"
    }

    GetInfo() {
        return Format("Counter '{}': Instance={}, Total={}",
            this.Name, this.InstanceCount, Counter.TotalCount)
    }
}

; Create multiple instances
counter1 := Counter("A")
counter2 := Counter("B")
counter3 := Counter("C")

; Each instance has its own instance count
counter1.Increment()
counter1.Increment()
counter2.Increment()

MsgBox(counter1.GetInfo())  ; Instance=2, Total=5 (3 created + 2 increments)
MsgBox(counter2.GetInfo())  ; Instance=1, Total=5
MsgBox(counter3.GetInfo())  ; Instance=0, Total=5

; Access static member through class
MsgBox("Total via static method: " Counter.GetTotalCount())

; Reset all counters
MsgBox(Counter.ResetAll())
MsgBox("After reset: " Counter.GetTotalCount())

; ========================================
; EXAMPLE 2: Instance Tracking and Management
; ========================================
; Using static members to track all instances of a class

class User {
    ; Static collection of all users
    static AllUsers := []
    static UserCount := 0
    static NextID := 1

    ; Instance properties
    ID := 0
    Username := ""
    Email := ""
    CreatedAt := ""

    __New(username, email) {
        ; Assign unique ID
        this.ID := User.NextID
        User.NextID++

        ; Set properties
        this.Username := username
        this.Email := email
        this.CreatedAt := A_Now

        ; Add to collection
        User.AllUsers.Push(this)
        User.UserCount++
    }

    ; Static method to find user by ID
    static FindByID(id) {
        for user in User.AllUsers {
            if (user.ID = id)
                return user
        }
        return ""
    }

    ; Static method to find user by username
    static FindByUsername(username) {
        for user in User.AllUsers {
            if (user.Username = username)
                return user
        }
        return ""
    }

    ; Static method to get all users
    static GetAllUsers() {
        return User.AllUsers
    }

    ; Static method to get user count
    static Count() {
        return User.UserCount
    }

    ; Static method to list all usernames
    static ListUsernames() {
        usernames := []
        for user in User.AllUsers {
            usernames.Push(user.Username)
        }
        return usernames
    }

    ToString() {
        return Format("User #{}: {} ({})", this.ID, this.Username, this.Email)
    }
}

; Create several users
user1 := User("alice", "alice@example.com")
user2 := User("bob", "bob@example.com")
user3 := User("charlie", "charlie@example.com")

; Find user by ID using static method
foundUser := User.FindByID(2)
MsgBox("Found: " foundUser.ToString())

; Find by username
foundUser := User.FindByUsername("alice")
MsgBox("Found: " foundUser.ToString())

; Get count
MsgBox("Total users: " User.Count())

; List all usernames
usernames := User.ListUsernames()
list := "All Usernames:`n"
for username in usernames {
    list .= "- " username "`n"
}
MsgBox(list)

; ========================================
; EXAMPLE 3: Static Constants and Configuration
; ========================================
; Using static properties as constants and configuration values

class MathConstants {
    ; Mathematical constants
    static PI := 3.14159265358979323846
    static E := 2.71828182845904523536
    static GOLDEN_RATIO := 1.61803398874989484820
    static SQRT2 := 1.41421356237309504880

    ; Conversion factors
    static INCHES_TO_CM := 2.54
    static POUNDS_TO_KG := 0.453592
    static MILES_TO_KM := 1.60934

    ; No instance creation needed - all static
    __New() {
        throw Error("MathConstants is a static class and cannot be instantiated")
    }

    ; Static utility methods
    static CircleArea(radius) {
        return MathConstants.PI * radius ** 2
    }

    static CircleCircumference(radius) {
        return 2 * MathConstants.PI * radius
    }

    static InchesToCM(inches) {
        return inches * MathConstants.INCHES_TO_CM
    }

    static PoundsToKG(pounds) {
        return pounds * MathConstants.POUNDS_TO_KG
    }

    static MilesToKM(miles) {
        return miles * MathConstants.MILES_TO_KM
    }

    static DegreesToRadians(degrees) {
        return degrees * MathConstants.PI / 180
    }

    static RadiansToDegrees(radians) {
        return radians * 180 / MathConstants.PI
    }
}

; Use static constants and methods without creating instance
circleArea := MathConstants.CircleArea(5)
MsgBox("Circle area (r=5): " Round(circleArea, 2))

height := MathConstants.InchesToCM(72)  ; 6 feet in inches
MsgBox("72 inches = " Round(height, 2) " cm")

distance := MathConstants.MilesToKM(26.2)  ; Marathon distance
MsgBox("Marathon: " Round(distance, 2) " km")

; Attempting to instantiate would throw error
try {
    math := MathConstants()
} catch Error as err {
    MsgBox("Error: " err.Message)
}

; ========================================
; EXAMPLE 4: Static Factory Methods
; ========================================
; Static methods that create and return instances

class Date {
    Year := 0
    Month := 0
    Day := 0

    __New(year, month, day) {
        this.Year := year
        this.Month := month
        this.Day := day
    }

    ; Static factory method - create from current date
    static Today() {
        year := FormatTime(A_Now, "yyyy")
        month := FormatTime(A_Now, "MM")
        day := FormatTime(A_Now, "dd")
        return Date(year, month, day)
    }

    ; Static factory method - create from string
    static Parse(dateString) {
        ; Parse "YYYY-MM-DD" format
        parts := StrSplit(dateString, "-")
        if (parts.Length != 3)
            throw ValueError("Invalid date format. Use YYYY-MM-DD")

        return Date(Integer(parts[1]), Integer(parts[2]), Integer(parts[3]))
    }

    ; Static factory method - create from timestamp
    static FromTimestamp(timestamp) {
        year := FormatTime(timestamp, "yyyy")
        month := FormatTime(timestamp, "MM")
        day := FormatTime(timestamp, "dd")
        return Date(year, month, day)
    }

    ; Static factory method - first day of month
    static FirstDayOfMonth(year, month) {
        return Date(year, month, 1)
    }

    ; Static factory method - last day of month
    static LastDayOfMonth(year, month) {
        ; Simple approximation
        daysInMonth := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        if (month = 2 && this.IsLeapYear(year))
            return Date(year, month, 29)
        return Date(year, month, daysInMonth[month])
    }

    ; Static utility method
    static IsLeapYear(year) {
        return (Mod(year, 4) = 0 && Mod(year, 100) != 0) || (Mod(year, 400) = 0)
    }

    ToString() {
        return Format("{:04d}-{:02d}-{:02d}", this.Year, this.Month, this.Day)
    }
}

; Using static factory methods
today := Date.Today()
MsgBox("Today: " today.ToString())

parsed := Date.Parse("2024-12-25")
MsgBox("Parsed date: " parsed.ToString())

firstDay := Date.FirstDayOfMonth(2024, 11)
lastDay := Date.LastDayOfMonth(2024, 11)
MsgBox("November 2024: " firstDay.ToString() " to " lastDay.ToString())

; Using static utility
isLeap := Date.IsLeapYear(2024)
MsgBox("Is 2024 a leap year? " (isLeap ? "Yes" : "No"))

; ========================================
; EXAMPLE 5: Static Initialization and State
; ========================================
; Managing class-level state and initialization

class Database {
    ; Static configuration
    static DefaultHost := "localhost"
    static DefaultPort := 3306
    static DefaultTimeout := 30
    static ConnectionPool := []
    static MaxConnections := 10
    static TotalConnections := 0
    static IsInitialized := false

    ; Instance properties
    ConnectionID := 0
    Host := ""
    Port := 0
    IsActive := false

    ; Static initialization method
    static Initialize(config := "") {
        if (Database.IsInitialized) {
            return "Already initialized"
        }

        ; Apply configuration if provided
        if (IsObject(config)) {
            if (config.HasOwnProp("Host"))
                Database.DefaultHost := config.Host
            if (config.HasOwnProp("Port"))
                Database.DefaultPort := config.Port
            if (config.HasOwnProp("MaxConnections"))
                Database.MaxConnections := config.MaxConnections
        }

        ; Initialize connection pool
        Database.ConnectionPool := []
        Database.IsInitialized := true

        return "Database system initialized"
    }

    ; Static method to get connection from pool
    static GetConnection() {
        if (!Database.IsInitialized)
            throw Error("Database not initialized")

        if (Database.TotalConnections >= Database.MaxConnections)
            throw Error("Maximum connections reached")

        conn := Database(Database.DefaultHost, Database.DefaultPort)
        return conn
    }

    ; Static method to get statistics
    static GetStats() {
        return Format("Connections: {}/{}, Pool Size: {}",
            Database.TotalConnections,
            Database.MaxConnections,
            Database.ConnectionPool.Length)
    }

    __New(host, port) {
        this.ConnectionID := ++Database.TotalConnections
        this.Host := host
        this.Port := port
        this.IsActive := true
        Database.ConnectionPool.Push(this)
    }

    Close() {
        this.IsActive := false
    }

    ToString() {
        status := this.IsActive ? "Active" : "Closed"
        return Format("Connection #{}: {}:{} ({})",
            this.ConnectionID, this.Host, this.Port, status)
    }
}

; Initialize database system
MsgBox(Database.Initialize({ MaxConnections: 5 }))

; Get connections
conn1 := Database.GetConnection()
conn2 := Database.GetConnection()
conn3 := Database.GetConnection()

MsgBox("Connection 1: " conn1.ToString())
MsgBox(Database.GetStats())

; ========================================
; EXAMPLE 6: Static Validation and Utilities
; ========================================
; Static methods as validators and utilities

class Validator {
    ; No instance properties needed

    __New() {
        throw Error("Validator is a static utility class")
    }

    ; Email validation
    static IsValidEmail(email) {
        return RegExMatch(email, "^[^@]+@[^@]+\.[^@]+$")
    }

    ; Phone validation (US format)
    static IsValidPhone(phone) {
        ; Remove formatting
        phone := RegExReplace(phone, "[^0-9]", "")
        return StrLen(phone) = 10
    }

    ; URL validation
    static IsValidURL(url) {
        return RegExMatch(url, "^https?://[^\s]+$")
    }

    ; Password strength
    static IsStrongPassword(password) {
        if (StrLen(password) < 8)
            return false

        hasUpper := RegExMatch(password, "[A-Z]")
        hasLower := RegExMatch(password, "[a-z]")
        hasDigit := RegExMatch(password, "[0-9]")
        hasSpecial := RegExMatch(password, "[^A-Za-z0-9]")

        return hasUpper && hasLower && hasDigit && hasSpecial
    }

    ; Credit card validation (Luhn algorithm)
    static IsValidCreditCard(cardNumber) {
        cardNumber := RegExReplace(cardNumber, "[^0-9]", "")

        if (StrLen(cardNumber) < 13 || StrLen(cardNumber) > 19)
            return false

        sum := 0
        isEven := false

        Loop Parse, cardNumber {
            digit := Integer(A_LoopField)

            if (isEven)
                digit *= 2

            if (digit > 9)
                digit -= 9

            sum += digit
            isEven := !isEven
        }

        return Mod(sum, 10) = 0
    }

    ; Static method to validate multiple fields
    static ValidateAll(data) {
        errors := []

        if (data.HasOwnProp("Email") && !Validator.IsValidEmail(data.Email))
            errors.Push("Invalid email")

        if (data.HasOwnProp("Phone") && !Validator.IsValidPhone(data.Phone))
            errors.Push("Invalid phone")

        if (data.HasOwnProp("Password") && !Validator.IsStrongPassword(data.Password))
            errors.Push("Weak password")

        return errors.Length = 0 ? "" : errors
    }
}

; Use static validation methods
email := "test@example.com"
MsgBox("Is valid email? " (Validator.IsValidEmail(email) ? "Yes" : "No"))

phone := "555-123-4567"
MsgBox("Is valid phone? " (Validator.IsValidPhone(phone) ? "Yes" : "No"))

password := "Weak123"
MsgBox("Is strong password? " (Validator.IsStrongPassword(password) ? "Yes" : "No"))

strongPassword := "Str0ng!Pass"
MsgBox("Is strong password? " (Validator.IsStrongPassword(strongPassword) ? "Yes" : "No"))

; Validate multiple fields
userData := {
    Email: "john@example.com",
    Phone: "5551234567",
    Password: "WeakPass"
}
errors := Validator.ValidateAll(userData)
if (IsObject(errors)) {
    errorMsg := "Validation errors:`n"
    for error in errors
        errorMsg .= "- " error "`n"
    MsgBox(errorMsg)
} else {
    MsgBox("All validations passed")
}

; ========================================
; EXAMPLE 7: Mixing Static and Instance Members
; ========================================
; Classes that effectively combine both static and instance members

class Logger {
    ; Static configuration
    static GlobalLogLevel := "INFO"
    static LogLevels := Map(
        "DEBUG", 1,
        "INFO", 2,
        "WARN", 3,
        "ERROR", 4
    )
    static AllLoggers := []
    static GlobalLogCount := 0

    ; Instance properties
    Name := ""
    InstanceLogLevel := ""
    LogCount := 0
    Logs := []

    __New(name, level := "") {
        this.Name := name
        this.InstanceLogLevel := level != "" ? level : Logger.GlobalLogLevel
        this.LogCount := 0
        this.Logs := []

        ; Register logger
        Logger.AllLoggers.Push(this)
    }

    ; Static method to set global log level
    static SetGlobalLevel(level) {
        if (!Logger.LogLevels.Has(level))
            throw ValueError("Invalid log level: " level)

        Logger.GlobalLogLevel := level

        ; Update all loggers that use global level
        for logger in Logger.AllLoggers {
            if (logger.InstanceLogLevel = "")
                logger.InstanceLogLevel := level
        }
    }

    ; Instance method that uses static data
    ShouldLog(level) {
        currentLevel := Logger.LogLevels[this.InstanceLogLevel]
        messageLevel := Logger.LogLevels[level]
        return messageLevel >= currentLevel
    }

    ; Instance method
    Log(level, message) {
        if (!this.ShouldLog(level))
            return

        logEntry := Format("[{}] [{}] {}", A_Now, level, message)
        this.Logs.Push(logEntry)
        this.LogCount++
        Logger.GlobalLogCount++

        return logEntry
    }

    Info(msg) => this.Log("INFO", msg)
    Debug(msg) => this.Log("DEBUG", msg)
    Warn(msg) => this.Log("WARN", msg)
    Error(msg) => this.Log("ERROR", msg)

    ; Static method to get total log count
    static GetGlobalLogCount() {
        return Logger.GlobalLogCount
    }

    ; Instance method to get stats
    GetStats() {
        return Format("Logger '{}': {} logs (Global: {})",
            this.Name, this.LogCount, Logger.GlobalLogCount)
    }
}

; Create loggers
logger1 := Logger("App")
logger2 := Logger("Database", "DEBUG")
logger3 := Logger("Network")

; Log messages
logger1.Info("Application started")
logger1.Debug("Debug message")  ; Won't log (INFO level)
logger2.Debug("Database query")  ; Will log (DEBUG level)
logger3.Warn("Network slow")

; Show stats
MsgBox(logger1.GetStats() "`n" logger2.GetStats() "`n" logger3.GetStats())
MsgBox("Global log count: " Logger.GetGlobalLogCount())

; Change global level
Logger.SetGlobalLevel("DEBUG")
logger1.Debug("Now this will log")  ; Will log now

MsgBox(logger1.GetStats())

MsgBox("=== OOP Static Members Examples Complete ===`n`n"
    . "This file demonstrated:`n"
    . "- Static properties and methods`n"
    . "- Instance tracking with static members`n"
    . "- Static constants and configuration`n"
    . "- Static factory methods`n"
    . "- Static initialization`n"
    . "- Static utility classes`n"
    . "- Mixing static and instance members")
