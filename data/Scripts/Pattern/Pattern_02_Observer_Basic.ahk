#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Observer Pattern - Basic Implementation
 * 
 * Demonstrates the Observer (Publish-Subscribe) design pattern.
 * One subject notifies multiple observers about state changes.
 * 
 * Source: AHK_Notes/Patterns/observer-pattern.md
 */

; Create observable subject and observers
subject := Observable()

observer1 := CustomObserver("Observer 1")
observer2 := CustomObserver("Observer 2")
observer3 := CustomObserver("Observer 3")

; Register observers
subject.Subscribe(observer1)
    .Subscribe(observer2)
    .Subscribe(observer3)

; Trigger notification
MsgBox("Triggering notification to all observers...")
subject.Notify("Hello from Subject!")

Sleep(2000)

; Unsubscribe one observer
subject.Unsubscribe(observer2)
MsgBox("Observer 2 unsubscribed. Triggering again...")
subject.Notify("Second notification")

/**
 * Observable (Subject) Class
 * Maintains list of observers and notifies them of changes
 */
class Observable {
    Observers := []

    Subscribe(observer) {
        this.Observers.Push(observer)
        return this  ; For method chaining
    }

    Unsubscribe(observer) {
        for i, registeredObserver in this.Observers {
            if (registeredObserver == observer) {
                this.Observers.RemoveAt(i)
                break
            }
        }
        return this  ; For method chaining
    }

    Notify(data := "") {
        for i, observer in this.Observers {
            observer.Update(data)
        }
    }
}

/**
 * Observer Base Class
 * Defines interface that concrete observers must implement
 */
class Observer {
    Update(data) {
        ; Abstract method - subclasses override this
        throw Error("Update() must be implemented by subclass")
    }
}

/**
 * Concrete Observer Implementation
 * Responds to notifications from Observable
 */
class CustomObserver extends Observer {
    Name := ""

    __New(name) {
        this.Name := name
    }

    Update(data) {
        MsgBox(this.Name " received: " data, , "T2")
    }
}

/*
* Key Concepts:
*
* 1. One-to-Many Dependency:
*    - One subject can notify many observers
*    - Observers register/unregister dynamically
*
* 2. Loose Coupling:
*    - Subject doesn't know concrete observer types
*    - Observers don't know about each other
*
* 3. Use Cases:
*    - Event systems
*    - MVC architecture (Model notifies Views)
*    - Pub/Sub messaging
*    - State synchronization
*
* 4. Benefits:
*    - Flexible: Add/remove observers at runtime
*    - Decoupled: Subject and observers are independent
*    - Extensible: Easy to add new observer types
*/

