#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Feature: Mixin Pattern for Code Reuse
; Demonstrates: Composition over inheritance, behavior injection, multiple inheritance alternative

class LoggableMixin {
    static Apply(target) {
        target.DefineProp("Log", {Call: (self, message) => self._logs.Push(Format("[{1}] {2}: {3}", FormatTime(, "HH:mm:ss"), Type(self), message))})
        target.DefineProp("GetLogs", {Call: (self) => self._logs})
        target.DefineProp("_logs", {Value: []})
    }
}

class TimestampMixin {
    static Apply(target) {
        target.DefineProp("CreatedAt", {Get: (self) => self._createdAt})
        target.DefineProp("UpdatedAt", {Get: (self) => self._updatedAt})
        target.DefineProp("Touch", {Call: (self) => self._updatedAt := A_Now})
        target.DefineProp("_createdAt", {Value: A_Now})
        target.DefineProp("_updatedAt", {Value: A_Now})
    }
}

class SerializableMixin {
    static Apply(target) {
        target.DefineProp("ToJSON", {Call: (self) => self._BuildJSON()})
        target.DefineProp("_BuildJSON", {Call: (self) => JSON.stringify(self._GetData())})
        target.DefineProp("_GetData", {Call: (self) => {name: Type(self), data: ObjOwnProps(self)}})
    }
}

class Task {
    __New(title, description) => (this.title := title, this.description := description)
}

; Apply mixins to extend Task functionality
LoggableMixin.Apply(Task.Prototype)
TimestampMixin.Apply(Task.Prototype)
SerializableMixin.Apply(Task.Prototype)

; Now Task has logging, timestamps, and serialization
task := Task("Fix Bug #123", "Resolve memory leak in parser")
task.Log("Task created")
Sleep(100)
task.Touch()
task.Log("Task updated")
task.Log("Task completed")

MsgBox("Created: " task.CreatedAt "`nUpdated: " task.UpdatedAt)
MsgBox("Logs:`n" task.GetLogs().Join("`n"))

class JSON {
    static stringify(obj) {
        if (obj is Array) {
            items := []
            for item in obj
            items.Push(JSON.stringify(item))
            return "[" items.Join(",") "]"
        }
        if (obj is Map || obj is Object) {
            pairs := []
            for key, value in obj
            pairs.Push(Format('"{1}":{2}', key, JSON.stringify(value)))
            return "{" pairs.Join(",") "}"
        }
        if (obj is String)
        return Format('"{1}"', obj)
        return String(obj)
    }
}
