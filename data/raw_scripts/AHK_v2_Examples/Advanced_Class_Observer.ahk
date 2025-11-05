#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Observer Pattern Implementation
class Subject {
    __New() {
        this.observers := []
    }
    
    Attach(observer) {
        this.observers.Push(observer)
    }
    
    Detach(observer) {
        Loop this.observers.Length {
            if (this.observers[A_Index] = observer) {
                this.observers.RemoveAt(A_Index)
                break
            }
        }
    }
    
    Notify(data) {
        for observer in this.observers {
            observer.Update(data)
        }
    }
}

class Observer {
    __New(name) {
        this.name := name
    }
    
    Update(data) {
        MsgBox(this.name " received update: " data)
    }
}

; Demo
subject := Subject()

observer1 := Observer("Observer 1")
observer2 := Observer("Observer 2")

subject.Attach(observer1)
subject.Attach(observer2)

subject.Notify("Important event occurred!")
