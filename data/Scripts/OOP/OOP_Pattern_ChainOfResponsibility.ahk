#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Chain of Responsibility
; Demonstrates: Handler chain, request processing, elegant delegation

class Handler {
    __New(next := "") => this.next := next
    SetNext(handler) => (this.next := handler, handler)
    Handle(request) => this.next ? this.next.Handle(request) : false
}

class AuthenticationHandler extends Handler {
    Handle(request) {
        if (!request.HasOwnProp("user") || request.user = "")
            return MsgBox("Authentication failed: No user", "Error"), false
        return super.Handle(request)
    }
}

class AuthorizationHandler extends Handler {
    Handle(request) {
        if (!request.HasOwnProp("role") || request.role != "admin")
            return MsgBox("Authorization failed: Insufficient permissions", "Error"), false
        return super.Handle(request)
    }
}

class ValidationHandler extends Handler {
    Handle(request) {
        if (!request.HasOwnProp("data") || request.data = "")
            return MsgBox("Validation failed: No data", "Error"), false
        return super.Handle(request)
    }
}

class ProcessingHandler extends Handler {
    Handle(request) {
        MsgBox(Format("Processing request from {} with data: {}", request.user, request.data), "Success")
        return true
    }
}

; Build chain with elegant chaining
auth := AuthenticationHandler()
authz := AuthorizationHandler()
valid := ValidationHandler()
process := ProcessingHandler()

auth.SetNext(authz).SetNext(valid).SetNext(process)

; Test requests
request1 := { user: "admin", role: "admin", data: "important data" }
auth.Handle(request1)

request2 := { user: "guest", role: "guest", data: "some data" }
auth.Handle(request2)
