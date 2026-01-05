#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Chain of Responsibility Pattern - Passes requests along handler chain
; Demonstrates decoupled request processing with fallback handling

class Handler {
    next := ""

    SetNext(handler) {
        this.next := handler
        return handler
    }

    Handle(request) {
        if this.next
            return this.next.Handle(request)
        return ""
    }
}

class AuthHandler extends Handler {
    Handle(request) {
        if !request.Has("token")
            return "Auth failed: No token"
        if request["token"] != "valid"
            return "Auth failed: Invalid token"
        return super.Handle(request)
    }
}

class ValidationHandler extends Handler {
    Handle(request) {
        if !request.Has("data")
            return "Validation failed: No data"
        if StrLen(request["data"]) < 3
            return "Validation failed: Data too short"
        return super.Handle(request)
    }
}

class ProcessHandler extends Handler {
    Handle(request) => "Processed: " request["data"]
}

; Demo - build chain
auth := AuthHandler()
validate := ValidationHandler()
process := ProcessHandler()

auth.SetNext(validate).SetNext(process)

; Test various requests
requests := [
    Map(),
    Map("token", "invalid"),
    Map("token", "valid"),
    Map("token", "valid", "data", "ab"),
    Map("token", "valid", "data", "hello")
]

for req in requests
    MsgBox(auth.Handle(req))
