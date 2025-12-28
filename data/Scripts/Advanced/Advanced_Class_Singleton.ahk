#Requires AutoHotkey v2.0
#SingleInstance Force
; Singleton Pattern Implementation
class Singleton {
    static instance := ""

    __New() {
        if (Singleton.instance != "") {
            throw Error("Singleton already exists! Use GetInstance()")
        }
        Singleton.instance := this
        this.data := Map()
    }

    static GetInstance() {
        if (Singleton.instance = "")
            Singleton.instance := Singleton()
        return Singleton.instance
    }

    SetValue(key, value) {
        this.data[key] := value
    }

    GetValue(key) {
        return this.data.Has(key) ? this.data[key] : ""
    }
}

; Demo
config1 := Singleton.GetInstance()
config1.SetValue("theme", "dark")

config2 := Singleton.GetInstance()
MsgBox("Theme from config2: " config2.GetValue("theme"))  ; Shows "dark"

; Both variables reference the same instance
MsgBox("Same instance? " (config1 = config2 ? "Yes" : "No"))  ; Shows "Yes"

