#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Null Object Pattern - Provides do-nothing default behavior
; Demonstrates eliminating null checks with polymorphism

class Logger {
    Log(msg) => OutputDebug("[LOG] " msg "`n")
    Error(msg) => OutputDebug("[ERROR] " msg "`n")
    Warn(msg) => OutputDebug("[WARN] " msg "`n")
}

class NullLogger {
    ; Do nothing - silent implementation
    Log(msg) => ""
    Error(msg) => ""
    Warn(msg) => ""
}

class Service {
    ; Logger is optional - uses NullLogger by default
    __New(logger := "") {
        this.logger := logger ? logger : NullLogger()
    }

    DoWork() {
        this.logger.Log("Starting work...")

        ; Simulate work
        result := "processed_data"

        this.logger.Log("Work completed")
        return result
    }

    DoRiskyOperation() {
        this.logger.Warn("About to do risky operation")

        try {
            ; Simulate operation
            return "success"
        } catch as e {
            this.logger.Error("Operation failed: " e.Message)
            return "failed"
        }
    }
}

; Demo - Service works with or without logger
serviceWithLogging := Service(Logger())
serviceWithoutLogging := Service()  ; Uses NullLogger

MsgBox("With logging: " serviceWithLogging.DoWork())
MsgBox("Without logging: " serviceWithoutLogging.DoWork())
