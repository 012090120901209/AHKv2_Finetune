#Requires AutoHotkey v2.0 AutoHotkey v2.0
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
; Demo
mySubject := Subject()

myObserver1 := Observer("Observer 1")
myObserver2 := Observer("Observer 2")

mySubject.Attach(myObserver1)
mySubject.Attach(myObserver2)

mySubject.Notify("Important event occurred!")
