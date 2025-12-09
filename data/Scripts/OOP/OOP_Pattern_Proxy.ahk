#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Proxy Pattern
; Demonstrates: Access control, lazy loading, caching

class Subject {
    Request() => throw Error("Must implement Request()")
}

class RealSubject extends Subject {
    Request() => (Sleep(1000), MsgBox("RealSubject: Handling request (expensive operation)"))
}

class CachingProxy extends Subject {
    __New() => (this.realSubject := "", this.cache := "")

    Request() {
        if (this.cache) {
            MsgBox("Proxy: Returning cached result")
            return this.cache
        }

        if (!this.realSubject)
        this.realSubject := RealSubject()

        MsgBox("Proxy: Forwarding to real subject...")
        this.realSubject.Request()
        this.cache := "cached result"
        return this.cache
    }
}

class ProtectionProxy extends Subject {
    __New(realSubject, password) => (this.realSubject := realSubject, this.password := password)

    Request() {
        if (!this.CheckAccess())
        return MsgBox("Access denied!", "Error")
        this.realSubject.Request()
    }

    CheckAccess() {
        result := InputBox("Enter password:", "Authentication", "Password")
        return result.Result = "OK" && result.Value = this.password
    }
}

; Usage
proxy := CachingProxy()
proxy.Request()  ; Slow first time
proxy.Request()  ; Fast from cache

protectedProxy := ProtectionProxy(RealSubject(), "secret")
protectedProxy.Request()  ; Requires password
