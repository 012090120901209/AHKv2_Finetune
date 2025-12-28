#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; LRU Cache - Least Recently Used eviction policy
; Demonstrates bounded caching with automatic cleanup

class LRUCache {
    __New(capacity) {
        this.capacity := capacity
        this.cache := Map()
        this.order := []  ; Most recent at end
    }

    Get(key) {
        if !this.cache.Has(key)
            return ""

        this.MoveToFront(key)
        return this.cache[key]
    }

    Put(key, value) {
        if this.cache.Has(key) {
            this.cache[key] := value
            this.MoveToFront(key)
            return
        }

        ; Evict oldest if at capacity
        if this.order.Length >= this.capacity {
            oldest := this.order.RemoveAt(1)
            this.cache.Delete(oldest)
        }

        this.cache[key] := value
        this.order.Push(key)
    }

    MoveToFront(key) {
        for i, k in this.order {
            if k = key {
                this.order.RemoveAt(i)
                this.order.Push(key)
                return
            }
        }
    }

    Has(key) => this.cache.Has(key)
    Size() => this.order.Length

    GetOrder() {
        result := ""
        for k in this.order
            result .= k " "
        return Trim(result)
    }
}

; Demo
cache := LRUCache(3)

cache.Put("a", 1)
cache.Put("b", 2)
cache.Put("c", 3)
MsgBox("After a,b,c: " cache.GetOrder())

cache.Get("a")  ; Access 'a', makes it most recent
MsgBox("After accessing a: " cache.GetOrder())

cache.Put("d", 4)  ; Evicts 'b' (least recent)
MsgBox("After adding d: " cache.GetOrder() "`n'b' exists: " cache.Has("b"))
