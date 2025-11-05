#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP Feature: Class Variables (Shared State)
; Demonstrates: Static properties, instance counting, shared configuration

class User {
    static totalUsers := 0
    static activeUsers := 0
    static userRegistry := Map()

    __New(username, email) {
        this.username := username
        this.email := email
        this.id := ++User.totalUsers
        this.active := true
        User.activeUsers++
        User.userRegistry[this.id] := this
        MsgBox("User #" this.id " created: " username "`nTotal users: " User.totalUsers)
    }

    Deactivate() {
        if (this.active) {
            this.active := false
            User.activeUsers--
            MsgBox(this.username " deactivated`nActive users: " User.activeUsers)
        }
    }

    static GetStats() => Format("Total: {1}, Active: {2}, Inactive: {3}",
        User.totalUsers, User.activeUsers, User.totalUsers - User.activeUsers)

    static FindById(id) => User.userRegistry.Has(id) ? User.userRegistry[id] : ""

    static GetAllUsers() {
        users := []
        for id, user in User.userRegistry
            users.Push(Format("#{1}: {2} ({3})", id, user.username, user.active ? "active" : "inactive"))
        return users
    }
}

class Config {
    static settings := Map(
        "appName", "MyApp",
        "version", "1.0.0",
        "debug", false,
        "maxConnections", 100
    )

    static Get(key, default := "") => Config.settings.Has(key) ? Config.settings[key] : default
    static Set(key, value) => Config.settings[key] := value
    static GetAll() => Config.settings
    static Reset() => Config.settings := Map()
}

class Counter {
    static globalCount := 0

    __New(name) {
        this.name := name
        this.localCount := 0
    }

    Increment() {
        this.localCount++
        Counter.globalCount++
        return Format("{1}: Local={2}, Global={3}", this.name, this.localCount, Counter.globalCount)
    }

    static GetGlobalCount() => Counter.globalCount
    static ResetGlobal() => Counter.globalCount := 0
}

; Demonstrate shared class variables
user1 := User("Alice", "alice@example.com")
user2 := User("Bob", "bob@example.com")
user3 := User("Charlie", "charlie@example.com")

MsgBox("User Stats:`n" User.GetStats())

user2.Deactivate()
MsgBox("After deactivation:`n" User.GetStats())

; Find user by ID
foundUser := User.FindById(1)
MsgBox("Found user #1: " (foundUser ? foundUser.username : "Not found"))

; List all users
MsgBox("All Users:`n" User.GetAllUsers().Join("`n"))

; Demonstrate shared config
MsgBox("App: " Config.Get("appName") " v" Config.Get("version"))
Config.Set("debug", true)
Config.Set("maxConnections", 200)
MsgBox("Debug mode: " (Config.Get("debug") ? "ON" : "OFF") "`nMax connections: " Config.Get("maxConnections"))

; Demonstrate counter with local and global state
counter1 := Counter("Counter A")
counter2 := Counter("Counter B")

MsgBox(counter1.Increment())  ; A: Local=1, Global=1
MsgBox(counter2.Increment())  ; B: Local=1, Global=2
MsgBox(counter1.Increment())  ; A: Local=2, Global=3
MsgBox(counter2.Increment())  ; B: Local=2, Global=4

MsgBox("Total global count: " Counter.GetGlobalCount())
