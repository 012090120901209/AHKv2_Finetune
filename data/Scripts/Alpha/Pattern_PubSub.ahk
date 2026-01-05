#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; PubSub - Global publish/subscribe messaging
; Demonstrates decoupled component communication

class PubSub {
    static channels := Map()

    static Subscribe(channel, callback) {
        if !this.channels.Has(channel)
            this.channels[channel] := []
        this.channels[channel].Push(callback)

        ; Return unsubscribe function
        return () => this.Unsubscribe(channel, callback)
    }

    static Unsubscribe(channel, callback) {
        if !this.channels.Has(channel)
            return

        subs := this.channels[channel]
        for i, cb in subs {
            if cb = callback {
                subs.RemoveAt(i)
                break
            }
        }
    }

    static Publish(channel, data*) {
        if !this.channels.Has(channel)
            return 0

        count := 0
        for callback in this.channels[channel] {
            callback(data*)
            count++
        }
        return count
    }

    static HasSubscribers(channel) => this.channels.Has(channel) && this.channels[channel].Length > 0

    static Clear(channel := "") {
        if channel
            this.channels.Delete(channel)
        else
            this.channels := Map()
    }
}

; Demo - simulate application events
logs := []

; Subscribe to various events
PubSub.Subscribe("user:login", (user) => logs.Push("User logged in: " user))
PubSub.Subscribe("user:login", (user) => logs.Push("Analytics: login event for " user))
PubSub.Subscribe("user:logout", (user) => logs.Push("User logged out: " user))

unsub := PubSub.Subscribe("order:created", (orderId) =>
    logs.Push("New order: " orderId))

; Publish events
PubSub.Publish("user:login", "alice@example.com")
PubSub.Publish("order:created", "ORD-001")
PubSub.Publish("order:created", "ORD-002")

; Unsubscribe and publish again
unsub()
PubSub.Publish("order:created", "ORD-003")  ; Won't be logged

PubSub.Publish("user:logout", "alice@example.com")

output := "Event Log:`n"
for log in logs
    output .= "- " log "`n"

MsgBox(output)
