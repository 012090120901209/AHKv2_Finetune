#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Proxy Pattern - Provides surrogate for controlling access to an object
; Demonstrates lazy initialization with deferred expensive operations

class ExpensiveObject {
    __New() {
        ; Simulate expensive initialization
        Sleep(100)
        this.data := "Heavy data loaded at " A_TickCount
    }

    GetData() => this.data
}

class LazyProxy {
    __New() => this.real := ""

    GetData() {
        if !this.real
            this.real := ExpensiveObject()
        return this.real.GetData()
    }

    IsLoaded() => this.real != ""
}

; Logging Proxy - adds behavior
class LoggingProxy {
    __New(target) => this.target := target

    GetData() {
        OutputDebug("GetData called at " A_TickCount "`n")
        result := this.target.GetData()
        OutputDebug("GetData returned: " result "`n")
        return result
    }
}

; Demo
proxy := LazyProxy()
MsgBox("Proxy created. Loaded: " proxy.IsLoaded())

data := proxy.GetData()
MsgBox("Data: " data "`nLoaded: " proxy.IsLoaded())
