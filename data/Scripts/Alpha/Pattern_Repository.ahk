#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Repository Pattern - Abstracts data access behind collection-like interface
; Demonstrates CRUD operations with in-memory storage

class Entity {
    static _nextId := 0

    __New() {
        Entity._nextId++
        this.id := Entity._nextId
    }
}

class User extends Entity {
    __New(name, email, age) {
        super.__New()
        this.name := name
        this.email := email
        this.age := age
    }
}

class Repository {
    __New() => this.items := Map()

    Add(entity) {
        this.items[entity.id] := entity
        return entity
    }

    Get(id) => this.items.Has(id) ? this.items[id] : ""

    GetAll() {
        result := []
        for id, item in this.items
            result.Push(item)
        return result
    }

    Find(predicate) {
        results := []
        for id, item in this.items
            if predicate(item)
                results.Push(item)
        return results
    }

    Update(entity) {
        if this.items.Has(entity.id)
            this.items[entity.id] := entity
        return entity
    }

    Delete(id) {
        if this.items.Has(id) {
            this.items.Delete(id)
            return true
        }
        return false
    }

    Count() => this.items.Count
}

; Demo
repo := Repository()

; Add users
repo.Add(User("Alice", "alice@example.com", 30))
repo.Add(User("Bob", "bob@example.com", 25))
repo.Add(User("Charlie", "charlie@example.com", 35))

; Find users over 28
adults := repo.Find((u) => u.age > 28)

result := "Users over 28:`n"
for u in adults
    result .= u.name " (" u.age ")`n"

result .= "`nTotal users: " repo.Count()
MsgBox(result)
