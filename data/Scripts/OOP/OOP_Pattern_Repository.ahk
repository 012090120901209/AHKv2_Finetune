#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Repository Pattern
; Demonstrates: Data access abstraction, CRUD operations, clean architecture

class Repository {
    Find(id) => throw Error("Must implement Find()")
    FindAll() => throw Error("Must implement FindAll()")
    Save(entity) => throw Error("Must implement Save()")
    Delete(id) => throw Error("Must implement Delete()")
}

class InMemoryRepository extends Repository {
    __New() => (this.data := Map(), this.nextId := 1)

    Find(id) => this.data.Has(id) ? this.data[id] : ""
    FindAll() => [this.data*]

    Save(entity) {
        if (!entity.HasOwnProp("id") || entity.id = 0)
            entity.id := this.nextId++
        this.data[entity.id] := entity
        return entity
    }

    Delete(id) => this.data.Delete(id)
    Count() => this.data.Count
}

class User {
    __New(name, email) => (this.id := 0, this.name := name, this.email := email)
    ToString() => Format("User[id={}, name={}, email={}]", this.id, this.name, this.email)
}

; Usage with clean separation
repo := InMemoryRepository()

; Create
user1 := repo.Save(User("Alice", "alice@example.com"))
user2 := repo.Save(User("Bob", "bob@example.com"))
user3 := repo.Save(User("Charlie", "charlie@example.com"))

; Read
found := repo.Find(2)
MsgBox("Found: " found.ToString())

; Update
found.email := "bob.new@example.com"
repo.Save(found)

; List all
output := "All users:`n"
for id, user in repo.data
    output .= user.ToString() "`n"
MsgBox(output)

; Delete
repo.Delete(2)
MsgBox("Count after delete: " repo.Count())
