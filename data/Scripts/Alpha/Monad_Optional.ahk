#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Optional/Maybe Monad - Safely handles absent values
; Demonstrates null-safe operations with Map/Filter/FlatMap

class Optional {
    __New(value := "") {
        this.value := value
        this.hasValue := value != ""
    }

    static Of(value) => Optional(value)
    static Empty() => Optional()
    
    static FromNullable(value) {
        return (value = "" || value = 0) ? Optional.Empty() : Optional.Of(value)
    }

    Map(fn) {
        if !this.hasValue
            return Optional.Empty()
        return Optional.Of(fn(this.value))
    }

    Filter(predicate) {
        if !this.hasValue || !predicate(this.value)
            return Optional.Empty()
        return this
    }
    
    FlatMap(fn) {
        if !this.hasValue
            return Optional.Empty()
        return fn(this.value)
    }

    GetOrElse(defaultVal) => this.hasValue ? this.value : defaultVal

    IfPresent(action) {
        if this.hasValue
            action(this.value)
        return this
    }
    
    IfEmpty(action) {
        if !this.hasValue
            action()
        return this
    }
    
    OrElse(alternative) {
        return this.hasValue ? this : alternative
    }
}

; Demo - safe user lookup
class UserService {
    static users := Map(
        1, Map("name", "Alice", "email", "alice@example.com"),
        2, Map("name", "Bob", "email", "")
    )
    
    static FindById(id) {
        return this.users.Has(id) ? Optional.Of(this.users[id]) : Optional.Empty()
    }
}

; Chain operations safely
result := UserService.FindById(1)
    .Map((u) => u["name"])
    .Map((n) => StrUpper(n))
    .GetOrElse("Unknown")

MsgBox("User 1: " result)

result := UserService.FindById(999)
    .Map((u) => u["name"])
    .GetOrElse("Not Found")

MsgBox("User 999: " result)

; Filter example
result := UserService.FindById(2)
    .Map((u) => u["email"])
    .Filter((e) => e != "")
    .GetOrElse("No email provided")

MsgBox("User 2 email: " result)
