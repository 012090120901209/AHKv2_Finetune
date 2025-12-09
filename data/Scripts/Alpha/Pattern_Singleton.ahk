#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Singleton Pattern - Ensures only one instance of a class exists
; Demonstrates lazy initialization and instance caching

class Database {
    static _instance := ""

    static Instance {
        get {
            if !this._instance
                this._instance := Database()
            return this._instance
        }
    }

    __New() {
        if Database._instance
            throw Error("Use Database.Instance")
        this.connection := "connected"
    }
}

; Demo
db1 := Database.Instance
db2 := Database.Instance
MsgBox("Singleton: " (db1 = db2 ? "Same instance" : "Different"))
