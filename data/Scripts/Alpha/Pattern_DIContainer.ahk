#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Dependency Injection Container - IoC with factory support
; Demonstrates service resolution with singleton and transient lifetimes

class Container {
    __New() {
        this.bindings := Map()
        this.singletons := Map()
    }

    ; Bind with factory function
    Bind(name, factory, singleton := false) {
        this.bindings[name] := Map("factory", factory, "singleton", singleton)
        return this
    }

    ; Bind as singleton
    Singleton(name, factory) => this.Bind(name, factory, true)

    ; Bind existing instance
    Instance(name, instance) {
        this.singletons[name] := instance
        this.bindings[name] := Map("factory", "", "singleton", true)
        return this
    }

    Resolve(name) {
        if !this.bindings.Has(name)
            throw Error("Not bound: " name)

        ; Return cached singleton
        if this.singletons.Has(name)
            return this.singletons[name]

        binding := this.bindings[name]
        instance := binding["factory"](this)

        ; Cache if singleton
        if binding["singleton"]
            this.singletons[name] := instance

        return instance
    }

    Has(name) => this.bindings.Has(name)
}

; Services
class Logger {
    Log(msg) => OutputDebug("[LOG] " msg "`n")
}

class DatabaseConnection {
    __New(connString) {
        this.connString := connString
        OutputDebug("[DB] Connected to: " connString "`n")
    }
}

class UserRepository {
    __New(db, logger) {
        this.db := db
        this.logger := logger
    }

    Find(id) {
        this.logger.Log("Finding user " id)
        return Map("id", id, "name", "User" id)
    }
}

class UserService {
    __New(repo, logger) {
        this.repo := repo
        this.logger := logger
    }

    GetUser(id) {
        this.logger.Log("Service: GetUser " id)
        return this.repo.Find(id)
    }
}

; Demo - configure container
diContainer := Container()
    .Singleton("logger", (c) => Logger())
    .Singleton("db", (c) => DatabaseConnection("localhost:5432/mydb"))
    .Bind("userRepo", (c) => UserRepository(c.Resolve("db"), c.Resolve("logger")))
    .Bind("userService", (c) => UserService(c.Resolve("userRepo"), c.Resolve("logger")))

; Resolve services
service := diContainer.Resolve("userService")
user := service.GetUser(42)

MsgBox("Resolved user: " user["name"])

; Verify singleton behavior
logger1 := diContainer.Resolve("logger")
logger2 := container.Resolve("logger")
MsgBox("Same logger instance: " (logger1 = logger2))
