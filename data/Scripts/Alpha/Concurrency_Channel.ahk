#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Channel - Go-style channels for communication
; Demonstrates CSP-style message passing

class Channel {
    __New(capacity := 0) {
        this.buffer := []
        this.capacity := capacity  ; 0 = unbuffered
        this.closed := false
        this.sendWaiters := []
        this.recvWaiters := []
    }

    Send(value) {
        if this.closed
            throw Error("Cannot send on closed channel")

        ; If someone is waiting to receive
        if this.recvWaiters.Length {
            waiter := this.recvWaiters.RemoveAt(1)
            waiter(value)
            return true
        }

        ; Buffered channel with space
        if this.capacity > 0 && this.buffer.Length < this.capacity {
            this.buffer.Push(value)
            return true
        }

        ; Need to wait (in real async, this would block)
        ; For simulation, we'll queue it
        this.sendWaiters.Push(Map("value", value))
        return true
    }

    Receive() {
        if this.buffer.Length {
            value := this.buffer.RemoveAt(1)
            
            ; Check if sender is waiting
            if this.sendWaiters.Length {
                waiter := this.sendWaiters.RemoveAt(1)
                this.buffer.Push(waiter["value"])
            }
            
            return Map("value", value, "ok", true)
        }

        if this.closed
            return Map("value", "", "ok", false)

        ; Check waiting senders
        if this.sendWaiters.Length {
            waiter := this.sendWaiters.RemoveAt(1)
            return Map("value", waiter["value"], "ok", true)
        }

        return Map("value", "", "ok", false)
    }

    ; Try receive without blocking
    TryReceive() => this.Receive()

    Close() {
        this.closed := true
        ; Notify all waiters
        this.sendWaiters := []
        this.recvWaiters := []
    }

    IsClosed() => this.closed
    Len() => this.buffer.Length
}

; Select - Wait on multiple channels
class Select {
    __New() {
        this.cases := []
    }

    Case(channel, callback) {
        this.cases.Push(Map("channel", channel, "callback", callback))
        return this
    }

    Default(callback) {
        this.defaultCallback := callback
        return this
    }

    Run() {
        ; Try each case
        for c in this.cases {
            result := c["channel"].TryReceive()
            if result["ok"] {
                c["callback"](result["value"])
                return true
            }
        }

        ; No channel ready, run default if exists
        if this.HasProp("defaultCallback") && this.defaultCallback {
            this.defaultCallback()
            return true
        }

        return false
    }
}

; Worker pool using channels
class WorkerPool {
    __New(numWorkers, workerFn) {
        this.jobs := Channel(100)
        this.results := Channel(100)
        this.workerFn := workerFn
        this.numWorkers := numWorkers
    }

    Submit(job) {
        this.jobs.Send(job)
    }

    Process() {
        ; Process all available jobs
        while this.jobs.Len() > 0 {
            jobResult := this.jobs.Receive()
            if jobResult["ok"] {
                result := this.workerFn(jobResult["value"])
                this.results.Send(result)
            }
        }
    }

    GetResult() {
        result := this.results.Receive()
        return result["ok"] ? result["value"] : ""
    }

    ResultsAvailable() => this.results.Len()
}

; Demo - Basic channel
ch := Channel(3)  ; Buffered channel with capacity 3

result := "Channel Demo:`n`n"

; Send values
ch.Send("hello")
ch.Send("world")
ch.Send("!")

result .= "Sent 3 values, buffer size: " ch.Len() "`n`n"

; Receive values
result .= "Receiving:`n"
Loop 3 {
    r := ch.Receive()
    if r["ok"]
        result .= "  " r["value"] "`n"
}

result .= "`nBuffer after receive: " ch.Len()

MsgBox(result)

; Demo - Producer/Consumer
producer := Channel(5)
consumer := Channel(5)

; Simulate producer
Loop 5
    producer.Send("item" A_Index)

result := "Producer/Consumer:`n`n"
result .= "Produced: 5 items`n"

; Simulate consumer
consumed := 0
while producer.Len() > 0 {
    item := producer.Receive()
    if item["ok"] {
        consumed++
        consumer.Send("processed: " item["value"])
    }
}

result .= "Consumed: " consumed " items`n"
result .= "Results pending: " consumer.Len()

MsgBox(result)

; Demo - Worker Pool
squareWorker := (job) => Map("input", job, "result", job * job)

pool := WorkerPool(4, squareWorker)

; Submit jobs
Loop 10
    pool.Submit(A_Index)

result := "Worker Pool Demo:`n`n"
result .= "Submitted: 10 jobs`n"

; Process all jobs
pool.Process()

result .= "Results:`n"
while pool.ResultsAvailable() > 0 {
    r := pool.GetResult()
    result .= "  " r["input"] "² = " r["result"] "`n"
}

MsgBox(result)

; Demo - Select
ch1 := Channel(1)
ch2 := Channel(1)

ch1.Send("from channel 1")

result := "Select Demo:`n`n"

selected := Select()
    .Case(ch1, (v) => result .= "Received from ch1: " v "`n")
    .Case(ch2, (v) => result .= "Received from ch2: " v "`n")
    .Default(() => result .= "No channel ready`n")

selected.Run()

; ch1 is now empty, ch2 is empty
selected.Run()  ; Will hit default

MsgBox(result)
