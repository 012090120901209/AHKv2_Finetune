#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Feature: Destructors and Resource Cleanup
; Demonstrates: __Delete method, RAII pattern, automatic cleanup

class FileLogger {
    __New(filePath) {
        this.filePath := filePath
        this.handle := FileOpen(filePath, "a")
        if (!this.handle)
            throw Error("Failed to open log file: " filePath)
        this.Log("Logger initialized")
        MsgBox("FileLogger created: " filePath)
    }

    Log(message) {
        if (this.handle)
            this.handle.WriteLine(Format("[{1}] {2}", FormatTime(, "yyyy-MM-dd HH:mm:ss"), message))
    }

    __Delete() {
        this.Log("Logger shutting down")
        if (this.handle) {
            this.handle.Close()
            MsgBox("FileLogger destroyed - File closed: " this.filePath)
        }
    }
}

class DatabaseConnection {
    static activeConnections := 0

    __New(connectionString) {
        this.connectionString := connectionString
        this.connected := true
        DatabaseConnection.activeConnections++
        MsgBox("DB Connection opened`nActive connections: " DatabaseConnection.activeConnections)
    }

    Query(sql) => MsgBox("Executing: " sql)

    __Delete() {
        if (this.connected) {
            this.connected := false
            DatabaseConnection.activeConnections--
            MsgBox("DB Connection closed`nActive connections: " DatabaseConnection.activeConnections)
        }
    }
}

class ResourcePool {
    __New(name) {
        this.name := name
        this.resources := []
        this.acquired := 0
        MsgBox("ResourcePool '" name "' created")
    }

    Acquire() {
        this.acquired++
        resource := { id: this.acquired, pool: this }
        this.resources.Push(resource)
        MsgBox(this.name ": Resource #" this.acquired " acquired`nTotal: " this.resources.Length)
        return resource
    }

    Release(resource) {
        for index, res in this.resources {
            if (res.id = resource.id) {
                this.resources.RemoveAt(index)
                MsgBox(this.name ": Resource #" resource.id " released`nRemaining: " this.resources.Length)
                return
            }
        }
    }

    __Delete() {
        if (this.resources.Length > 0)
            MsgBox("WARNING: " this.name " destroyed with " this.resources.Length " unreleased resources!", "Resource Leak")
        else
            MsgBox("ResourcePool '" this.name "' cleaned up properly")
    }
}

; Demonstrate automatic cleanup with scope
{
    logger := FileLogger(A_ScriptDir "\test_log.txt")
    logger.Log("Starting test operations")

    db := DatabaseConnection("Server=localhost;Database=test")
    db.Query("SELECT * FROM users")

    pool := ResourcePool("Memory")
    res1 := pool.Acquire()
    res2 := pool.Acquire()
    pool.Release(res1)
    ; res2 not released - will show warning

    logger.Log("Test operations completed")
    ; All objects automatically destroyed when scope exits
}

MsgBox("All destructors called - resources cleaned up!")

; Demonstrate manual cleanup with global object
global appLogger := FileLogger(A_ScriptDir "\app_log.txt")
appLogger.Log("Application started")

result := MsgBox("Destroy global logger?", "Cleanup", "YesNo")
if (result = "Yes") {
    appLogger := ""  ; Manually destroy
    MsgBox("Global logger destroyed manually")
} else {
    MsgBox("Global logger will be destroyed on script exit")
}
