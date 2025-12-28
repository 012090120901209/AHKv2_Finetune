#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Data Structure: Hash Table (Custom Implementation)
; Demonstrates: Hashing, collision resolution, load factor, resizing

class HashNode {
    __New(key, value) => (this.key := key, this.value := value, this.next := "")
}

class HashTable {
    __New(capacity := 16) {
        this.capacity := capacity
        this.size := 0
        this.buckets := []
        this.loadFactorThreshold := 0.75

        loop capacity
            this.buckets.Push("")
    }

    _Hash(key) {
        hash := 0
        loop parse String(key) {
            hash := Mod(hash * 31 + Ord(A_LoopField), this.capacity)
        }
        return hash + 1  ; AHK arrays are 1-indexed
    }

    Set(key, value) {
        if (this.size / this.capacity >= this.loadFactorThreshold)
            this._Resize()

        index := this._Hash(key)
        head := this.buckets[index]

        ; Check if key exists
        current := head
        while (current) {
            if (current.key = key) {
                current.value := value  ; Update existing
                return this
            }
            current := current.next
        }

        ; Add new node
        newNode := HashNode(key, value)
        newNode.next := head
        this.buckets[index] := newNode
        this.size++

        return this
    }

    Get(key) {
        index := this._Hash(key)
        current := this.buckets[index]

        while (current) {
            if (current.key = key)
                return current.value
            current := current.next
        }

        return ""
    }

    Has(key) {
        index := this._Hash(key)
        current := this.buckets[index]

        while (current) {
            if (current.key = key)
                return true
            current := current.next
        }

        return false
    }

    Delete(key) {
        index := this._Hash(key)
        current := this.buckets[index]
        prev := ""

        while (current) {
            if (current.key = key) {
                if (prev)
                    prev.next := current.next
                else
                    this.buckets[index] := current.next

                this.size--
                return true
            }
            prev := current
            current := current.next
        }

        return false
    }

    Keys() {
        keys := []
        for bucket in this.buckets {
            current := bucket
            while (current) {
                keys.Push(current.key)
                current := current.next
            }
        }
        return keys
    }

    Values() {
        values := []
        for bucket in this.buckets {
            current := bucket
            while (current) {
                values.Push(current.value)
                current := current.next
            }
        }
        return values
    }

    Entries() {
        entries := []
        for bucket in this.buckets {
            current := bucket
            while (current) {
                entries.Push({ key: current.key, value: current.value })
                current := current.next
            }
        }
        return entries
    }

    _Resize() {
        oldBuckets := this.buckets
        this.capacity := this.capacity * 2
        this.buckets := []
        this.size := 0

        loop this.capacity
            this.buckets.Push("")

        ; Rehash all entries
        for bucket in oldBuckets {
            current := bucket
            while (current) {
                this.Set(current.key, current.value)
                current := current.next
            }
        }
    }

    GetLoadFactor() => Round(this.size / this.capacity, 2)

    GetStats() {
        stats := Format("HashTable Stats:`nSize: {1} | Capacity: {2} | Load Factor: {3}",
            this.size, this.capacity, this.GetLoadFactor())

        collisions := 0
        for bucket in this.buckets {
            if (bucket && bucket.next)
                collisions++
        }

        stats .= Format("`nBuckets with collisions: {1}", collisions)
        return stats
    }

    ToString() => "HashTable{" . this.Entries().Map((e) => e.key . ": " . e.value).Join(", ") . "}"
}

; Usage
ht := HashTable(4)  ; Small capacity to test resizing

; Set values
ht.Set("name", "Alice")
    .Set("age", 30)
    .Set("city", "New York")
    .Set("country", "USA")

MsgBox(ht.ToString())
MsgBox(ht.GetStats())

; Get values
MsgBox("Name: " . ht.Get("name"))
MsgBox("Age: " . ht.Get("age"))

; Check existence
MsgBox("Has 'city'? " . (ht.Has("city") ? "Yes" : "No"))
MsgBox("Has 'phone'? " . (ht.Has("phone") ? "Yes" : "No"))

; Add more items (triggers resize)
ht.Set("email", "alice@example.com")
    .Set("phone", "555-1234")
    .Set("job", "Engineer")

MsgBox("After adding more items:`n" . ht.GetStats())

; Get all keys and values
MsgBox("Keys: " . ht.Keys().Join(", "))
MsgBox("Values: " . ht.Values().Join(", "))

; Update value
ht.Set("age", 31)
MsgBox("Updated age: " . ht.Get("age"))

; Delete
ht.Delete("phone")
MsgBox("After deleting phone:`n" . ht.ToString())

; Cache example
cache := HashTable()
cache.Set("user:1", { name: "Alice", age: 30 })
    .Set("user:2", { name: "Bob", age: 25 })
    .Set("user:3", { name: "Charlie", age: 35 })

user := cache.Get("user:2")
MsgBox("Cached user: " . user.name . " (" . user.age . ")")
