#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Actor Model - Message-passing concurrency
; Demonstrates isolated actors with mailboxes

class Actor {
    __New(behavior) {
        this.mailbox := []
        this.behavior := behavior
        this.running := true
        this.parent := ""
        this.children := []
        this.state := Map()
    }

    Send(message) {
        if !this.running
            return false
        this.mailbox.Push(message)
        return true
    }

    ; Process one message
    Process() {
        if !this.running || !this.mailbox.Length
            return false

        message := this.mailbox.RemoveAt(1)

        try {
            result := this.behavior(this, message)
            return result ?? true
        } catch Error as e {
            this._handleError(e, message)
            return false
        }
    }

    ; Process all pending messages
    ProcessAll() {
        count := 0
        while this.Process()
            count++
        return count
    }

    _handleError(err, message) {
        OutputDebug("[Actor Error] " err.Message " while processing: " String(message) "`n")
        if this.parent
            this.parent.Send(Map("type", "error", "error", err, "message", message))
    }

    Spawn(behavior) {
        child := Actor(behavior)
        child.parent := this
        this.children.Push(child)
        return child
    }

    Stop() {
        this.running := false
        for child in this.children
            child.Stop()
    }

    IsRunning() => this.running
    HasMessages() => this.mailbox.Length > 0
    MessageCount() => this.mailbox.Length
}

; Actor System - Manages multiple actors
class ActorSystem {
    __New() {
        this.actors := Map()
        this.nextId := 1
    }

    Create(name, behavior) {
        actor := Actor(behavior)
        this.actors[name] := actor
        return actor
    }

    Get(name) => this.actors.Has(name) ? this.actors[name] : ""

    Send(name, message) {
        if this.actors.Has(name)
            return this.actors[name].Send(message)
        return false
    }

    Tick() {
        ; Process one message from each actor
        processed := 0
        for name, actor in this.actors {
            if actor.Process()
                processed++
        }
        return processed
    }

    Run(maxIterations := 1000) {
        iterations := 0
        while iterations < maxIterations {
            processed := this.Tick()
            if processed = 0
                break
            iterations++
        }
        return iterations
    }

    Shutdown() {
        for name, actor in this.actors
            actor.Stop()
        this.actors := Map()
    }
}

; Demo - Simple ping-pong actors
system := ActorSystem()

logs := []

; Create ping actor
pingBehavior := (self, msg) {
    if msg["type"] = "start" {
        logs.Push("Ping: Starting, sending to Pong")
        system.Send("pong", Map("type", "ping", "count", 1))
    } else if msg["type"] = "pong" {
        logs.Push("Ping: Received pong #" msg["count"])
        if msg["count"] < 3 {
            system.Send("pong", Map("type", "ping", "count", msg["count"] + 1))
        } else {
            logs.Push("Ping: Done!")
        }
    }
}

; Create pong actor
pongBehavior := (self, msg) {
    if msg["type"] = "ping" {
        logs.Push("Pong: Received ping #" msg["count"] ", sending back")
        system.Send("ping", Map("type", "pong", "count", msg["count"]))
    }
}

system.Create("ping", pingBehavior)
system.Create("pong", pongBehavior)

; Start the exchange
system.Send("ping", Map("type", "start"))

; Run until no more messages
iterations := system.Run()

result := "Actor Ping-Pong Demo:`n`n"
for log in logs
    result .= log "`n"
result .= "`nCompleted in " iterations " iterations"

MsgBox(result)

; Demo - Counter actor with state
counterBehavior := (self, msg) {
    if !self.state.Has("count")
        self.state["count"] := 0

    switch msg["type"] {
        case "increment":
            self.state["count"]++
        case "decrement":
            self.state["count"]--
        case "get":
            return self.state["count"]
        case "reset":
            self.state["count"] := 0
    }
}

counter := Actor(counterBehavior)

; Send messages
counter.Send(Map("type", "increment"))
counter.Send(Map("type", "increment"))
counter.Send(Map("type", "increment"))
counter.Send(Map("type", "decrement"))

counter.ProcessAll()

; Get current value
counter.Send(Map("type", "get"))
finalValue := counter.Process()

MsgBox("Counter Actor Demo:`n`n"
    . "Sent: +1, +1, +1, -1`n"
    . "Final value: " counter.state["count"])

; Demo - Worker actor pool
system2 := ActorSystem()
results := []

; Worker behavior
workerBehavior := (self, msg) {
    if msg["type"] = "work" {
        ; Simulate work
        result := msg["data"] * 2
        results.Push(Map("id", msg["id"], "input", msg["data"], "output", result))
    }
}

; Create worker pool
Loop 3
    system2.Create("worker" A_Index, workerBehavior)

; Distribute work
Loop 9 {
    worker := "worker" (Mod(A_Index - 1, 3) + 1)
    system2.Send(worker, Map("type", "work", "id", A_Index, "data", A_Index * 10))
}

system2.Run()

result := "Worker Pool Demo (3 workers, 9 jobs):`n`n"
for r in results
    result .= Format("Job {}: {} * 2 = {}`n", r["id"], r["input"], r["output"])

MsgBox(result)
