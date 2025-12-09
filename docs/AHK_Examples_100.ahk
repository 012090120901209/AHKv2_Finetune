cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === SINGLETON PATTERN ===
class Database {
    static _instance := ""

    static Instance {
        get {
            if !this._instance
                this._instance := Database()
            return this._instance
        }
    }

    __New() {
        if Database._instance
            throw Error("Use Database.Instance")
        this.connection := "connected"
    }
}

; === FACTORY PATTERN ===
class ShapeFactory {
    static Create(type, size) {
        switch type {
            case "circle": return Circle(size)
            case "square": return Square(size)
            default: throw Error("Unknown shape")
        }
    }
}

class Shape {
    __New(size) => this.size := size
    Area() => 0
}

class Circle extends Shape {
    Area() => 3.14159 * this.size ** 2
}

class Square extends Shape {
    Area() => this.size ** 2
}

; === STRATEGY PATTERN ===
class Sorter {
    __New(strategy) => this.strategy := strategy

    Sort(data) => this.strategy.Execute(data.Clone())
}

class AscendingSort {
    Execute(arr) {
        arr.Sort("N")
        return arr
    }
}

class DescendingSort {
    Execute(arr) {
        arr.Sort("NR")
        return arr
    }
}

; === OBSERVER PATTERN ===
class EventEmitter {
    __New() => this.listeners := Map()

    On(event, callback) {
        if !this.listeners.Has(event)
            this.listeners[event] := []
        this.listeners[event].Push(callback)
    }

    Emit(event, data*) {
        if this.listeners.Has(event)
            for cb in this.listeners[event]
                cb(data*)
    }
}

; === DECORATOR PATTERN ===
class Coffee {
    Cost() => 5
    Description() => "Coffee"
}

class MilkDecorator {
    __New(beverage) => this.beverage := beverage
    Cost() => this.beverage.Cost() + 2
    Description() => this.beverage.Description() . " + Milk"
}

class SugarDecorator {
    __New(beverage) => this.beverage := beverage
    Cost() => this.beverage.Cost() + 1
    Description() => this.beverage.Description() . " + Sugar"
}

; === COMMAND PATTERN ===
class CommandInvoker {
    __New() => this.history := []

    Execute(cmd) {
        cmd.Execute()
        this.history.Push(cmd)
    }

    Undo() {
        if this.history.Length
            this.history.Pop().Undo()
    }
}

class AddCommand {
    __New(receiver, value) {
        this.receiver := receiver
        this.value := value
    }
    Execute() => this.receiver.total += this.value
    Undo() => this.receiver.total -= this.value
}

; === DEPENDENCY INJECTION ===
class UserService {
    __New(repository, logger) {
        this.repo := repository
        this.logger := logger
    }

    GetUser(id) {
        this.logger.Log("Fetching user " id)
        return this.repo.Find(id)
    }
}

class UserRepository {
    Find(id) => Map("id", id, "name", "User" id)
}

class ConsoleLogger {
    Log(msg) => OutputDebug(msg "`n")
}

; === DEMO ===
Demo()
class Demo {
    static Call() {
        db1 := Database.Instance
        db2 := Database.Instance
        MsgBox("Singleton: " (db1 = db2 ? "Same instance" : "Different"))

        circle := ShapeFactory.Create("circle", 5)
        MsgBox("Factory - Circle area: " circle.Area())

        sorter := Sorter(DescendingSort())
        sorted := sorter.Sort([3, 1, 4, 1, 5])
        MsgBox("Strategy - Sorted: " sorted[1] "," sorted[2] "," sorted[3])

        emitter := EventEmitter()
        emitter.On("ping", (msg) => MsgBox("Observer: " msg))
        emitter.Emit("ping", "Hello!")

        drink := SugarDecorator(MilkDecorator(Coffee()))
        MsgBox("Decorator: " drink.Description() " = $" drink.Cost())

        calc := {total: 0}
        invoker := CommandInvoker()
        invoker.Execute(AddCommand(calc, 10))
        invoker.Execute(AddCommand(calc, 5))
        invoker.Undo()
        MsgBox("Command - Total after undo: " calc.total)

        service := UserService(UserRepository(), ConsoleLogger())
        user := service.GetUser(42)
        MsgBox("DI - User: " user["name"])
    }
}Create a ton of mini scripts like this that I can use to train a finetuning model?cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 1. BUILDER PATTERN ===
class QueryBuilder {
    __New() {
        this.table := ""
        this.columns := ["*"]
        this.conditions := []
    }

    From(table) {
        this.table := table
        return this
    }

    Select(cols*) {
        this.columns := cols
        return this
    }

    Where(condition) {
        this.conditions.Push(condition)
        return this
    }

    Build() {
        sql := "SELECT " this.Join(this.columns, ", ") " FROM " this.table
        if this.conditions.Length
            sql .= " WHERE " this.Join(this.conditions, " AND ")
        return sql
    }

    Join(arr, sep) {
        result := ""
        for i, v in arr
            result .= (i > 1 ? sep : "") v
        return result
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 2. STATE PATTERN ===
class TrafficLight {
    __New() => this.state := RedState(this)

    SetState(state) => this.state := state
    Change() => this.state.Change()
    GetColor() => this.state.color
}

class RedState {
    color := "RED"
    __New(light) => this.light := light
    Change() => this.light.SetState(GreenState(this.light))
}

class GreenState {
    color := "GREEN"
    __New(light) => this.light := light
    Change() => this.light.SetState(YellowState(this.light))
}

class YellowState {
    color := "YELLOW"
    __New(light) => this.light := light
    Change() => this.light.SetState(RedState(this.light))
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 3. CHAIN OF RESPONSIBILITY ===
class Handler {
    next := ""

    SetNext(handler) {
        this.next := handler
        return handler
    }

    Handle(request) {
        if this.next
            return this.next.Handle(request)
        return ""
    }
}

class AuthHandler extends Handler {
    Handle(request) {
        if !request.Has("token")
            return "Auth failed"
        return super.Handle(request)
    }
}

class ValidationHandler extends Handler {
    Handle(request) {
        if !request.Has("data")
            return "Validation failed"
        return super.Handle(request)
    }
}

class ProcessHandler extends Handler {
    Handle(request) => "Processed: " request["data"]
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 4. PROXY PATTERN ===
class ExpensiveObject {
    __New() {
        Sleep(100)
        this.data := "Loaded"
    }

    GetData() => this.data
}

class LazyProxy {
    __New() => this.real := ""

    GetData() {
        if !this.real
            this.real := ExpensiveObject()
        return this.real.GetData()
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 5. ADAPTER PATTERN ===
class OldApi {
    GetXml() => "<data>value</data>"
}

class JsonAdapter {
    __New(oldApi) => this.api := oldApi

    GetJson() {
        xml := this.api.GetXml()
        RegExMatch(xml, "<data>(.*)</data>", &m)
        return '{"data":"' m[1] '"}'
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 6. COMPOSITE PATTERN ===
class FileComponent {
    __New(name) => this.name := name
    GetSize() => 0
}

class File extends FileComponent {
    __New(name, size) {
        super.__New(name)
        this.size := size
    }
    GetSize() => this.size
}

class Folder extends FileComponent {
    __New(name) {
        super.__New(name)
        this.children := []
    }

    Add(component) => this.children.Push(component)

    GetSize() {
        total := 0
        for child in this.children
            total += child.GetSize()
        return total
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 7. FLYWEIGHT PATTERN ===
class IconFactory {
    static cache := Map()

    static Get(name) {
        if !this.cache.Has(name)
            this.cache[name] := Icon(name)
        return this.cache[name]
    }
}

class Icon {
    __New(name) {
        this.name := name
        this.pixels := "heavy_data_" name
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 8. MEMENTO PATTERN ===
class Editor {
    __New() => this.content := ""

    Type(text) => this.content .= text
    Save() => Memento(this.content)
    Restore(memento) => this.content := memento.state
}

class Memento {
    __New(state) => this.state := state
}

class History {
    __New() => this.snapshots := []

    Push(memento) => this.snapshots.Push(memento)

    Pop() {
        if this.snapshots.Length
            return this.snapshots.Pop()
        return ""
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 9. TEMPLATE METHOD ===
class DataProcessor {
    Process(data) {
        data := this.Validate(data)
        data := this.Transform(data)
        return this.Format(data)
    }

    Validate(data) => data
    Transform(data) => data
    Format(data) => data
}

class CsvProcessor extends DataProcessor {
    Validate(data) => StrReplace(data, '"', '')
    Transform(data) => StrUpper(data)
    Format(data) => "CSV: " data
}

class JsonProcessor extends DataProcessor {
    Transform(data) => Trim(data)
    Format(data) => '{"value":"' data '"}'
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 10. MEDIATOR PATTERN ===
class ChatRoom {
    __New() => this.users := Map()

    Register(user) {
        this.users[user.name] := user
        user.room := this
    }

    Send(from, to, msg) {
        if this.users.Has(to)
            this.users[to].Receive(from, msg)
    }
}

class ChatUser {
    __New(name) {
        this.name := name
        this.room := ""
        this.messages := []
    }

    Send(to, msg) => this.room.Send(this.name, to, msg)
    Receive(from, msg) => this.messages.Push(from ": " msg)
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 11. VISITOR PATTERN ===
class Employee {
    __New(name, salary) {
        this.name := name
        this.salary := salary
    }
    Accept(visitor) => visitor.VisitEmployee(this)
}

class Department {
    __New(name) {
        this.name := name
        this.members := []
    }
    Add(emp) => this.members.Push(emp)
    Accept(visitor) => visitor.VisitDepartment(this)
}

class SalaryVisitor {
    __New() => this.total := 0

    VisitEmployee(emp) => this.total += emp.salary

    VisitDepartment(dept) {
        for member in dept.members
            member.Accept(this)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 12. SPECIFICATION PATTERN ===
class Spec {
    And(other) => AndSpec(this, other)
    Or(other) => OrSpec(this, other)
    Not() => NotSpec(this)
}

class AndSpec extends Spec {
    __New(a, b) {
        this.a := a
        this.b := b
    }
    IsSatisfied(item) => this.a.IsSatisfied(item) && this.b.IsSatisfied(item)
}

class OrSpec extends Spec {
    __New(a, b) {
        this.a := a
        this.b := b
    }
    IsSatisfied(item) => this.a.IsSatisfied(item) || this.b.IsSatisfied(item)
}

class NotSpec extends Spec {
    __New(spec) => this.spec := spec
    IsSatisfied(item) => !this.spec.IsSatisfied(item)
}

class MinPrice extends Spec {
    __New(min) => this.min := min
    IsSatisfied(item) => item["price"] >= this.min
}

class InStock extends Spec {
    IsSatisfied(item) => item["stock"] > 0
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 13. REPOSITORY PATTERN ===
class Repository {
    __New() => this.items := Map()

    Add(entity) {
        this.items[entity.id] := entity
        return entity
    }

    Get(id) => this.items.Has(id) ? this.items[id] : ""

    Find(predicate) {
        results := []
        for id, item in this.items
            if predicate(item)
                results.Push(item)
        return results
    }

    Delete(id) => this.items.Delete(id)
}

class Entity {
    static _nextId := 0

    __New() {
        Entity._nextId++
        this.id := Entity._nextId
    }
}

class User extends Entity {
    __New(name, age) {
        super.__New()
        this.name := name
        this.age := age
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 14. UNIT OF WORK ===
class UnitOfWork {
    __New() {
        this.newEntities := []
        this.dirtyEntities := []
        this.deletedEntities := []
    }

    RegisterNew(entity) => this.newEntities.Push(entity)
    RegisterDirty(entity) => this.dirtyEntities.Push(entity)
    RegisterDeleted(entity) => this.deletedEntities.Push(entity)

    Commit() {
        for e in this.newEntities
            this.Insert(e)
        for e in this.dirtyEntities
            this.Update(e)
        for e in this.deletedEntities
            this.Remove(e)
        this.Clear()
    }

    Insert(e) => OutputDebug("INSERT: " e.id "`n")
    Update(e) => OutputDebug("UPDATE: " e.id "`n")
    Remove(e) => OutputDebug("DELETE: " e.id "`n")

    Clear() {
        this.newEntities := []
        this.dirtyEntities := []
        this.deletedEntities := []
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 15. OBJECT POOL ===
class ObjectPool {
    __New(factory, maxSize := 10) {
        this.factory := factory
        this.maxSize := maxSize
        this.available := []
        this.inUse := []
    }

    Acquire() {
        obj := this.available.Length ? this.available.Pop() : this.factory()
        this.inUse.Push(obj)
        return obj
    }

    Release(obj) {
        for i, o in this.inUse {
            if o = obj {
                this.inUse.RemoveAt(i)
                if this.available.Length < this.maxSize
                    this.available.Push(obj)
                return
            }
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 16. NULL OBJECT ===
class Logger {
    Log(msg) => OutputDebug(msg "`n")
}

class NullLogger {
    Log(msg) => ""
}

class Service {
    __New(logger := "") {
        this.logger := logger ? logger : NullLogger()
    }

    DoWork() {
        this.logger.Log("Working...")
        return "done"
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 17. SERVICE LOCATOR ===
class ServiceLocator {
    static services := Map()

    static Register(name, service) => this.services[name] := service

    static Get(name) {
        if !this.services.Has(name)
            throw Error("Service not found: " name)
        return this.services[name]
    }
}

class EmailService {
    Send(to, msg) => "Sent to " to ": " msg
}

class SmsService {
    Send(to, msg) => "SMS to " to ": " msg
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 18. ITERATOR PATTERN ===
class Range {
    __New(start, end, step := 1) {
        this.start := start
        this.end := end
        this.step := step
    }

    __Enum(n) {
        i := this.start
        return (&val) {
            if i > this.end
                return false
            val := i
            i += this.step
            return true
        }
    }
}

class Fibonacci {
    __New(count) => this.count := count

    __Enum(n) {
        a := 0, b := 1, i := 0
        return (&val) {
            if i >= this.count
                return false
            val := a
            temp := a + b
            a := b
            b := temp
            i++
            return true
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 19. LAZY INITIALIZATION ===
class LazyValue {
    __New(initializer) {
        this.initializer := initializer
        this.computed := false
        this.cache := ""
    }

    Value {
        get {
            if !this.computed {
                this.cache := this.initializer()
                this.computed := true
            }
            return this.cache
        }
    }
}

class Config {
    static settings := LazyValue(() => Config.LoadFromFile())

    static LoadFromFile() {
        return Map("theme", "dark", "lang", "en")
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 20. DOUBLE DISPATCH ===
class Collision {
    static Check(a, b) => a.CollideWith(b)
}

class Asteroid {
    CollideWith(other) => other.CollidedByAsteroid(this)
    CollidedByAsteroid(a) => "Asteroid+Asteroid"
    CollidedBySpaceship(s) => "Spaceship+Asteroid"
}

class Spaceship {
    CollideWith(other) => other.CollidedBySpaceship(this)
    CollidedByAsteroid(a) => "Asteroid+Spaceship"
    CollidedBySpaceship(s) => "Spaceship+Spaceship"
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 21. ACTIVE RECORD ===
class ActiveRecord {
    static table := ""
    static records := Map()

    __New(data := "") {
        this.id := 0
        if data
            for key, val in data
                this.%key% := val
    }

    Save() {
        if !this.id {
            this.id := ActiveRecord.records.Count + 1
        }
        ActiveRecord.records[this.id] := this
        return this
    }

    static Find(id) => this.records.Has(id) ? this.records[id] : ""

    static All() {
        result := []
        for id, record in this.records
            result.Push(record)
        return result
    }
}

class Post extends ActiveRecord {
    static table := "posts"
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 22. DATA MAPPER ===
class UserMapper {
    __New() => this.storage := Map()

    Insert(user) {
        row := Map("id", user.id, "name", user.name, "email", user.email)
        this.storage[user.id] := row
    }

    Find(id) {
        if !this.storage.Has(id)
            return ""
        row := this.storage[id]
        return DomainUser(row["id"], row["name"], row["email"])
    }

    Update(user) {
        if this.storage.Has(user.id)
            this.storage[user.id] := Map("id", user.id, "name", user.name, "email", user.email)
    }
}

class DomainUser {
    __New(id, name, email) {
        this.id := id
        this.name := name
        this.email := email
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 23. IDENTITY MAP ===
class IdentityMap {
    __New() => this.entities := Map()

    Get(type, id) {
        key := type ":" id
        return this.entities.Has(key) ? this.entities[key] : ""
    }

    Add(type, id, entity) {
        key := type ":" id
        this.entities[key] := entity
        return entity
    }

    Remove(type, id) {
        key := type ":" id
        this.entities.Delete(key)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 24. EVENT SOURCING ===
class EventStore {
    __New() => this.events := []

    Append(event) => this.events.Push(event)

    GetEvents(aggregateId) {
        result := []
        for e in this.events
            if e.aggregateId = aggregateId
                result.Push(e)
        return result
    }
}

class BankAccount {
    __New(id) {
        this.id := id
        this.balance := 0
    }

    Apply(event) {
        switch event.type {
            case "deposited": this.balance += event.amount
            case "withdrawn": this.balance -= event.amount
        }
    }

    static Reconstitute(id, events) {
        account := BankAccount(id)
        for event in events
            account.Apply(event)
        return account
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 25. CQRS ===
class CommandBus {
    __New() => this.handlers := Map()

    Register(cmdType, handler) => this.handlers[cmdType] := handler

    Dispatch(cmd) {
        type := Type(cmd)
        if this.handlers.Has(type)
            return this.handlers[type].Handle(cmd)
        throw Error("No handler for: " type)
    }
}

class QueryBus {
    __New() => this.handlers := Map()

    Register(queryType, handler) => this.handlers[queryType] := handler

    Execute(query) {
        type := Type(query)
        if this.handlers.Has(type)
            return this.handlers[type].Execute(query)
        throw Error("No handler for: " type)
    }
}

class CreateUserCommand {
    __New(name) => this.name := name
}

class CreateUserHandler {
    Handle(cmd) => "Created: " cmd.name
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 26. PIPELINE PATTERN ===
class Pipeline {
    __New() => this.stages := []

    Pipe(stage) {
        this.stages.Push(stage)
        return this
    }

    Process(input) {
        result := input
        for stage in this.stages
            result := stage.Process(result)
        return result
    }
}

class TrimStage {
    Process(data) => Trim(data)
}

class UpperStage {
    Process(data) => StrUpper(data)
}

class ValidateStage {
    Process(data) {
        if StrLen(data) < 3
            throw Error("Too short")
        return data
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 27. CIRCUIT BREAKER ===
class CircuitBreaker {
    __New(threshold := 3, resetTimeout := 5000) {
        this.threshold := threshold
        this.resetTimeout := resetTimeout
        this.failures := 0
        this.state := "closed"
        this.lastFailure := 0
    }

    Execute(action) {
        if this.state = "open" {
            if A_TickCount - this.lastFailure > this.resetTimeout
                this.state := "half-open"
            else
                throw Error("Circuit is open")
        }

        try {
            result := action()
            this.OnSuccess()
            return result
        } catch as e {
            this.OnFailure()
            throw e
        }
    }

    OnSuccess() {
        this.failures := 0
        this.state := "closed"
    }

    OnFailure() {
        this.failures++
        this.lastFailure := A_TickCount
        if this.failures >= this.threshold
            this.state := "open"
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 28. RETRY PATTERN ===
class Retry {
    static Execute(action, maxAttempts := 3, delay := 100) {
        attempt := 0
        loop {
            attempt++
            try {
                return action()
            } catch as e {
                if attempt >= maxAttempts
                    throw e
                Sleep(delay * attempt)
            }
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 29. THROTTLE/DEBOUNCE ===
class Throttle {
    __New(fn, delay) {
        this.fn := fn
        this.delay := delay
        this.lastCall := 0
    }

    Call(args*) {
        now := A_TickCount
        if now - this.lastCall >= this.delay {
            this.lastCall := now
            return this.fn(args*)
        }
    }
}

class Debounce {
    __New(fn, delay) {
        this.fn := fn
        this.delay := delay
        this.timer := ""
    }

    Call(args*) {
        if this.timer
            SetTimer(this.timer, 0)
        this.timer := this.CreateTimer(args)
        SetTimer(this.timer, -this.delay)
    }

    CreateTimer(args) {
        return () => this.fn(args*)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 30. MEMOIZATION ===
class Memoize {
    __New(fn) {
        this.fn := fn
        this.cache := Map()
    }

    Call(args*) {
        key := this.MakeKey(args)
        if !this.cache.Has(key)
            this.cache[key] := this.fn(args*)
        return this.cache[key]
    }

    MakeKey(args) {
        key := ""
        for arg in args
            key .= String(arg) "|"
        return key
    }
}

class Math {
    static Fib := Memoize((n) => n <= 1 ? n : Math.Fib(n-1) + Math.Fib(n-2))
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 31. MULTITON ===
class Multiton {
    static instances := Map()

    static GetInstance(key) {
        if !this.instances.Has(key)
            this.instances[key] := this(key)
        return this.instances[key]
    }

    __New(key) => this.key := key
}

class DbConnection extends Multiton {
    __New(key) {
        super.__New(key)
        this.connection := "conn_" key
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 32. EXTENSION OBJECT ===
class Extensible {
    __New() => this.extensions := Map()

    AddExtension(name, ext) => this.extensions[name] := ext

    GetExtension(name) => this.extensions.Has(name) ? this.extensions[name] : ""

    __Call(name, params) {
        for extName, ext in this.extensions
            if ext.HasMethod(name)
                return ext.%name%(params*)
        throw Error("Method not found: " name)
    }
}

class PrintExtension {
    Print(msg) => OutputDebug(msg "`n")
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 33. MONEY PATTERN ===
class Money {
    __New(amount, currency := "USD") {
        this.amount := Round(amount * 100)
        this.currency := currency
    }

    Add(other) {
        this.AssertSameCurrency(other)
        return Money((this.amount + other.amount) / 100, this.currency)
    }

    Subtract(other) {
        this.AssertSameCurrency(other)
        return Money((this.amount - other.amount) / 100, this.currency)
    }

    Multiply(factor) => Money((this.amount * factor) / 100, this.currency)

    Equals(other) => this.amount = other.amount && this.currency = other.currency

    AssertSameCurrency(other) {
        if this.currency != other.currency
            throw Error("Currency mismatch")
    }

    ToString() => Format("{:.2f} {}", this.amount / 100, this.currency)
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 34. QUANTITY PATTERN ===
class Quantity {
    __New(value, unit) {
        this.value := value
        this.unit := unit
    }

    ConvertTo(targetUnit) {
        factor := Quantity.GetConversionFactor(this.unit, targetUnit)
        return Quantity(this.value * factor, targetUnit)
    }

    static GetConversionFactor(from, to) {
        conversions := Map(
            "m:km", 0.001,
            "km:m", 1000,
            "kg:g", 1000,
            "g:kg", 0.001
        )
        key := from ":" to
        return conversions.Has(key) ? conversions[key] : 1
    }

    Add(other) {
        converted := other.ConvertTo(this.unit)
        return Quantity(this.value + converted.value, this.unit)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 35. RANGE PATTERN ===
class DateRange {
    __New(start, end) {
        this.start := start
        this.end := end
    }

    Contains(date) => date >= this.start && date <= this.end

    Overlaps(other) => this.start <= other.end && other.start <= this.end

    Merge(other) {
        if !this.Overlaps(other)
            throw Error("Ranges don't overlap")
        return DateRange(Min(this.start, other.start), Max(this.end, other.end))
    }

    Gap(other) {
        if this.Overlaps(other)
            return ""
        if this.end < other.start
            return DateRange(this.end, other.start)
        return DateRange(other.end, this.start)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 36. RESULT/EITHER MONAD ===
class Result {
    __New(value, error := "") {
        this.value := value
        this.error := error
        this.isSuccess := error = ""
    }

    static Ok(value) => Result(value)
    static Fail(error) => Result("", error)

    Map(fn) {
        if !this.isSuccess
            return this
        try
            return Result.Ok(fn(this.value))
        catch as e
            return Result.Fail(e.Message)
    }

    FlatMap(fn) {
        if !this.isSuccess
            return this
        return fn(this.value)
    }

    GetOrElse(default) => this.isSuccess ? this.value : default
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 37. OPTIONAL/MAYBE MONAD ===
class Optional {
    __New(value := "") {
        this.value := value
        this.hasValue := value != ""
    }

    static Of(value) => Optional(value)
    static Empty() => Optional()

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

    GetOrElse(default) => this.hasValue ? this.value : default

    IfPresent(action) {
        if this.hasValue
            action(this.value)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 38. SPECIFICATION WITH LINQ-STYLE ===
class Query {
    __New(source) {
        this.source := source
        this.operations := []
    }

    Where(predicate) {
        this.operations.Push(Map("type", "where", "fn", predicate))
        return this
    }

    Select(selector) {
        this.operations.Push(Map("type", "select", "fn", selector))
        return this
    }

    OrderBy(keySelector) {
        this.operations.Push(Map("type", "orderby", "fn", keySelector))
        return this
    }

    Take(count) {
        this.operations.Push(Map("type", "take", "count", count))
        return this
    }

    ToArray() {
        result := this.source.Clone()
        for op in this.operations {
            switch op["type"] {
                case "where":
                    result := this.ApplyWhere(result, op["fn"])
                case "select":
                    result := this.ApplySelect(result, op["fn"])
                case "orderby":
                    result := this.ApplyOrderBy(result, op["fn"])
                case "take":
                    result := this.ApplyTake(result, op["count"])
            }
        }
        return result
    }

    ApplyWhere(arr, fn) {
        result := []
        for item in arr
            if fn(item)
                result.Push(item)
        return result
    }

    ApplySelect(arr, fn) {
        result := []
        for item in arr
            result.Push(fn(item))
        return result
    }

    ApplyOrderBy(arr, fn) {
        arr.Sort((a, b) => fn(a) > fn(b) ? 1 : -1)
        return arr
    }

    ApplyTake(arr, count) {
        result := []
        loop Min(count, arr.Length)
            result.Push(arr[A_Index])
        return result
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 39. REACTIVE PROPERTY ===
class Reactive {
    __New(value) {
        this._value := value
        this.subscribers := []
    }

    Value {
        get => this._value
        set {
            old := this._value
            this._value := value
            for sub in this.subscribers
                sub(value, old)
        }
    }

    Subscribe(callback) {
        this.subscribers.Push(callback)
        return () => this.Unsubscribe(callback)
    }

    Unsubscribe(callback) {
        for i, sub in this.subscribers
            if sub = callback {
                this.subscribers.RemoveAt(i)
                return
            }
    }
}

class Computed {
    __New(dependencies, compute) {
        this.compute := compute
        this._value := compute()
        for dep in dependencies
            dep.Subscribe((*) => this._value := this.compute())
    }

    Value => this._value
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 40. FINITE STATE MACHINE ===
class StateMachine {
    __New(initial) {
        this.current := initial
        this.transitions := Map()
        this.onEnter := Map()
        this.onExit := Map()
    }

    AddTransition(from, event, to) {
        key := from ":" event
        this.transitions[key] := to
        return this
    }

    OnEnter(state, action) {
        this.onEnter[state] := action
        return this
    }

    OnExit(state, action) {
        this.onExit[state] := action
        return this
    }

    Trigger(event) {
        key := this.current ":" event
        if !this.transitions.Has(key)
            return false

        if this.onExit.Has(this.current)
            this.onExit[this.current]()

        this.current := this.transitions[key]

        if this.onEnter.Has(this.current)
            this.onEnter[this.current]()

        return true
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 41. HIERARCHICAL STATE MACHINE ===
class HierarchicalState {
    __New(name, parent := "") {
        this.name := name
        this.parent := parent
        this.children := Map()
    }

    AddChild(name) {
        child := HierarchicalState(name, this)
        this.children[name] := child
        return child
    }

    IsAncestorOf(state) {
        current := state.parent
        while current {
            if current = this
                return true
            current := current.parent
        }
        return false
    }

    GetPath() {
        path := [this.name]
        current := this.parent
        while current {
            path.InsertAt(1, current.name)
            current := current.parent
        }
        return path
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 42. INTERPRETER PATTERN ===
class Expression {
    Interpret(context) => 0
}

class NumberExpr extends Expression {
    __New(value) => this.value := value
    Interpret(context) => this.value
}

class VariableExpr extends Expression {
    __New(name) => this.name := name
    Interpret(context) => context.Has(this.name) ? context[this.name] : 0
}

class AddExpr extends Expression {
    __New(left, right) {
        this.left := left
        this.right := right
    }
    Interpret(context) => this.left.Interpret(context) + this.right.Interpret(context)
}

class MultiplyExpr extends Expression {
    __New(left, right) {
        this.left := left
        this.right := right
    }
    Interpret(context) => this.left.Interpret(context) * this.right.Interpret(context)
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 43. FLUENT INTERFACE ===
class HtmlBuilder {
    __New(tag) {
        this.tag := tag
        this.attributes := Map()
        this.children := []
        this.text := ""
    }

    Attr(name, value) {
        this.attributes[name] := value
        return this
    }

    Class(cls) => this.Attr("class", cls)
    Id(id) => this.Attr("id", id)

    Text(content) {
        this.text := content
        return this
    }

    Child(builder) {
        this.children.Push(builder)
        return this
    }

    Build() {
        html := "<" this.tag
        for name, value in this.attributes
            html .= ' ' name '="' value '"'
        html .= ">"
        html .= this.text
        for child in this.children
            html .= child.Build()
        html .= "</" this.tag ">"
        return html
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 44. ABSTRACT FACTORY ===
class UIFactory {
    CreateButton() => ""
    CreateCheckbox() => ""
}

class WindowsFactory extends UIFactory {
    CreateButton() => WindowsButton()
    CreateCheckbox() => WindowsCheckbox()
}

class MacFactory extends UIFactory {
    CreateButton() => MacButton()
    CreateCheckbox() => MacCheckbox()
}

class WindowsButton {
    Render() => "[  OK  ]"
}

class MacButton {
    Render() => "( OK )"
}

class WindowsCheckbox {
    Render() => "[X]"
}

class MacCheckbox {
    Render() => "(•)"
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 45. BRIDGE PATTERN ===
class Device {
    __New() {
        this.enabled := false
        this.volume := 50
    }
    Enable() => this.enabled := true
    Disable() => this.enabled := false
    SetVolume(v) => this.volume := v
}

class TV extends Device {
}

class Radio extends Device {
}

class RemoteControl {
    __New(device) => this.device := device

    TogglePower() {
        if this.device.enabled
            this.device.Disable()
        else
            this.device.Enable()
    }

    VolumeUp() => this.device.SetVolume(this.device.volume + 10)
    VolumeDown() => this.device.SetVolume(this.device.volume - 10)
}

class AdvancedRemote extends RemoteControl {
    Mute() => this.device.SetVolume(0)
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 46. FACADE PATTERN ===
class VideoConverter {
    Convert(filename, format) {
        file := VideoFile(filename)
        codec := CodecFactory.Extract(file)
        if format = "mp4"
            return MPEG4Compressor().Compress(file, codec)
        return OGGCompressor().Compress(file, codec)
    }
}

class VideoFile {
    __New(name) => this.name := name
}

class CodecFactory {
    static Extract(file) => "codec_" file.name
}

class MPEG4Compressor {
    Compress(file, codec) => "mp4:" file.name
}

class OGGCompressor {
    Compress(file, codec) => "ogg:" file.name
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 47. PROTOTYPE PATTERN ===
class Prototype {
    Clone() {
        clone := %Type(this)%()
        for prop in this.OwnProps()
            clone.%prop% := this.%prop%
        return clone
    }
}

class Document extends Prototype {
    __New(title := "", content := "") {
        this.title := title
        this.content := content
        this.created := A_Now
    }
}

class ShapePrototype extends Prototype {
    __New(x := 0, y := 0, color := "black") {
        this.x := x
        this.y := y
        this.color := color
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 48. POLICY PATTERN ===
class ValidationPolicy {
    Validate(value) => true
}

class NotEmptyPolicy extends ValidationPolicy {
    Validate(value) => value != ""
}

class MinLengthPolicy extends ValidationPolicy {
    __New(min) => this.min := min
    Validate(value) => StrLen(value) >= this.min
}

class EmailPolicy extends ValidationPolicy {
    Validate(value) => RegExMatch(value, "^\w+@\w+\.\w+$")
}

class Validator {
    __New() => this.policies := []

    AddPolicy(policy) {
        this.policies.Push(policy)
        return this
    }

    Validate(value) {
        for policy in this.policies
            if !policy.Validate(value)
                return false
        return true
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 49. TYPE OBJECT PATTERN ===
class ItemType {
    __New(name, basePrice, category) {
        this.name := name
        this.basePrice := basePrice
        this.category := category
    }
}

class Item {
    static Types := Map()

    static DefineType(name, basePrice, category) {
        Item.Types[name] := ItemType(name, basePrice, category)
    }

    __New(typeName, quality := 1.0) {
        if !Item.Types.Has(typeName)
            throw Error("Unknown type: " typeName)
        this.type := Item.Types[typeName]
        this.quality := quality
    }

    GetPrice() => this.type.basePrice * this.quality
    GetName() => this.type.name
    GetCategory() => this.type.category
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 50. CURRYING ===
class Curry {
    static Call(fn, arity := 2) {
        return Curry.Curried(fn, arity, [])
    }

    static Curried(fn, arity, args) {
        return (arg) {
            newArgs := args.Clone()
            newArgs.Push(arg)
            if newArgs.Length >= arity
                return fn(newArgs*)
            return Curry.Curried(fn, arity, newArgs)
        }
    }
}

class MathOps {
    static Add(args*) => args[1] + args[2] + args[3]
    static Multiply(args*) => args[1] * args[2]
}Create a ton of mini scripts like this that I can use to train a finetuning model?cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 1. DEPENDENCY CONTAINER ===
class Container {
    __New() {
        this.bindings := Map()
        this.singletons := Map()
    }

    Bind(name, factory, singleton := false) {
        this.bindings[name] := Map("factory", factory, "singleton", singleton)
    }

    Resolve(name) {
        if !this.bindings.Has(name)
            throw Error("Not bound: " name)

        binding := this.bindings[name]

        if binding["singleton"] {
            if !this.singletons.Has(name)
                this.singletons[name] := binding["factory"](this)
            return this.singletons[name]
        }

        return binding["factory"](this)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 2. ASPECT-ORIENTED PROXY ===
class AopProxy {
    __New(target, before := "", after := "") {
        this.target := target
        this.before := before
        this.after := after
    }

    __Call(method, params) {
        if this.before
            this.before(method, params)

        result := this.target.%method%(params*)

        if this.after
            this.after(method, params, result)

        return result
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 3. PROMISE PATTERN ===
class Promise {
    __New(executor) {
        this.state := "pending"
        this.value := ""
        this.handlers := []
        executor(this.Resolve.Bind(this), this.Reject.Bind(this))
    }

    Resolve(value) {
        if this.state != "pending"
            return
        this.state := "fulfilled"
        this.value := value
        this.Process()
    }

    Reject(reason) {
        if this.state != "pending"
            return
        this.state := "rejected"
        this.value := reason
        this.Process()
    }

    Then(onFulfilled, onRejected := "") {
        this.handlers.Push(Map("fulfilled", onFulfilled, "rejected", onRejected))
        this.Process()
        return this
    }

    Process() {
        if this.state = "pending"
            return
        for handler in this.handlers {
            if this.state = "fulfilled" && handler["fulfilled"]
                handler["fulfilled"](this.value)
            else if this.state = "rejected" && handler["rejected"]
                handler["rejected"](this.value)
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 4. SAGA PATTERN ===
class Saga {
    __New() {
        this.steps := []
        this.completed := []
    }

    AddStep(action, compensation) {
        this.steps.Push(Map("action", action, "compensation", compensation))
        return this
    }

    Execute() {
        for step in this.steps {
            try {
                step["action"]()
                this.completed.Push(step)
            } catch {
                this.Rollback()
                return false
            }
        }
        return true
    }

    Rollback() {
        loop this.completed.Length {
            step := this.completed.Pop()
            try
                step["compensation"]()
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 5. OUTBOX PATTERN ===
class Outbox {
    __New() {
        this.messages := []
        this.processed := []
    }

    Add(event, payload) {
        this.messages.Push(Map(
            "id", A_TickCount,
            "event", event,
            "payload", payload,
            "status", "pending"
        ))
    }

    Process(handler) {
        for msg in this.messages {
            if msg["status"] = "pending" {
                try {
                    handler(msg["event"], msg["payload"])
                    msg["status"] := "sent"
                    this.processed.Push(msg)
                }
            }
        }
    }

    Cleanup(maxAge := 3600000) {
        now := A_TickCount
        i := this.processed.Length
        while i > 0 {
            if now - this.processed[i]["id"] > maxAge
                this.processed.RemoveAt(i)
            i--
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 6. BULKHEAD PATTERN ===
class Bulkhead {
    __New(maxConcurrent := 5) {
        this.maxConcurrent := maxConcurrent
        this.running := 0
        this.queue := []
    }

    Execute(task) {
        if this.running >= this.maxConcurrent {
            this.queue.Push(task)
            return false
        }

        this.running++
        try {
            result := task()
            return result
        } finally {
            this.running--
            this.ProcessQueue()
        }
    }

    ProcessQueue() {
        if this.queue.Length && this.running < this.maxConcurrent {
            task := this.queue.RemoveAt(1)
            this.Execute(task)
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 7. RATE LIMITER ===
class RateLimiter {
    __New(maxRequests, windowMs) {
        this.maxRequests := maxRequests
        this.windowMs := windowMs
        this.requests := []
    }

    TryAcquire() {
        now := A_TickCount
        this.Cleanup(now)

        if this.requests.Length >= this.maxRequests
            return false

        this.requests.Push(now)
        return true
    }

    Cleanup(now) {
        while this.requests.Length && now - this.requests[1] > this.windowMs
            this.requests.RemoveAt(1)
    }

    GetWaitTime() {
        if this.requests.Length < this.maxRequests
            return 0
        return this.windowMs - (A_TickCount - this.requests[1])
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 8. TOKEN BUCKET ===
class TokenBucket {
    __New(capacity, refillRate) {
        this.capacity := capacity
        this.tokens := capacity
        this.refillRate := refillRate
        this.lastRefill := A_TickCount
    }

    Consume(count := 1) {
        this.Refill()
        if this.tokens >= count {
            this.tokens -= count
            return true
        }
        return false
    }

    Refill() {
        now := A_TickCount
        elapsed := now - this.lastRefill
        tokensToAdd := (elapsed / 1000) * this.refillRate
        this.tokens := Min(this.capacity, this.tokens + tokensToAdd)
        this.lastRefill := now
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 9. LEAKY BUCKET ===
class LeakyBucket {
    __New(capacity, leakRate) {
        this.capacity := capacity
        this.water := 0
        this.leakRate := leakRate
        this.lastLeak := A_TickCount
    }

    Add(amount := 1) {
        this.Leak()
        if this.water + amount <= this.capacity {
            this.water += amount
            return true
        }
        return false
    }

    Leak() {
        now := A_TickCount
        elapsed := now - this.lastLeak
        leaked := (elapsed / 1000) * this.leakRate
        this.water := Max(0, this.water - leaked)
        this.lastLeak := now
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 10. SLIDING WINDOW COUNTER ===
class SlidingWindow {
    __New(windowSize, maxCount) {
        this.windowSize := windowSize
        this.maxCount := maxCount
        this.buckets := Map()
        this.bucketSize := windowSize // 10
    }

    Increment() {
        this.Cleanup()
        bucket := this.GetBucket()

        if !this.buckets.Has(bucket)
            this.buckets[bucket] := 0

        if this.GetCount() >= this.maxCount
            return false

        this.buckets[bucket]++
        return true
    }

    GetBucket() => A_TickCount // this.bucketSize

    GetCount() {
        count := 0
        for bucket, val in this.buckets
            count += val
        return count
    }

    Cleanup() {
        cutoff := this.GetBucket() - (this.windowSize // this.bucketSize)
        for bucket in this.buckets.Clone() {
            if bucket < cutoff
                this.buckets.Delete(bucket)
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 11. BLOOM FILTER ===
class BloomFilter {
    __New(size := 1000, hashCount := 3) {
        this.size := size
        this.hashCount := hashCount
        this.bits := []
        loop size
            this.bits.Push(0)
    }

    Add(item) {
        for hash in this.GetHashes(item)
            this.bits[hash] := 1
    }

    MightContain(item) {
        for hash in this.GetHashes(item)
            if !this.bits[hash]
                return false
        return true
    }

    GetHashes(item) {
        hashes := []
        str := String(item)
        loop this.hashCount {
            hash := this.Hash(str, A_Index)
            hashes.Push(Mod(hash, this.size) + 1)
        }
        return hashes
    }

    Hash(str, seed) {
        hash := seed
        loop StrLen(str)
            hash := (hash * 31 + Ord(SubStr(str, A_Index, 1))) & 0x7FFFFFFF
        return hash
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 12. LRU CACHE ===
class LRUCache {
    __New(capacity) {
        this.capacity := capacity
        this.cache := Map()
        this.order := []
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
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 13. LFU CACHE ===
class LFUCache {
    __New(capacity) {
        this.capacity := capacity
        this.cache := Map()
        this.freq := Map()
        this.minFreq := 0
    }

    Get(key) {
        if !this.cache.Has(key)
            return ""
        this.IncrementFreq(key)
        return this.cache[key]["value"]
    }

    Put(key, value) {
        if this.capacity <= 0
            return

        if this.cache.Has(key) {
            this.cache[key]["value"] := value
            this.IncrementFreq(key)
            return
        }

        if this.cache.Count >= this.capacity
            this.Evict()

        this.cache[key] := Map("value", value, "freq", 1)
        if !this.freq.Has(1)
            this.freq[1] := []
        this.freq[1].Push(key)
        this.minFreq := 1
    }

    IncrementFreq(key) {
        entry := this.cache[key]
        oldFreq := entry["freq"]
        entry["freq"]++

        this.RemoveFromFreqList(key, oldFreq)

        if !this.freq.Has(entry["freq"])
            this.freq[entry["freq"]] := []
        this.freq[entry["freq"]].Push(key)
    }

    RemoveFromFreqList(key, freq) {
        list := this.freq[freq]
        for i, k in list {
            if k = key {
                list.RemoveAt(i)
                break
            }
        }
        if !list.Length {
            this.freq.Delete(freq)
            if this.minFreq = freq
                this.minFreq++
        }
    }

    Evict() {
        if !this.freq.Has(this.minFreq)
            return
        list := this.freq[this.minFreq]
        if list.Length {
            key := list.RemoveAt(1)
            this.cache.Delete(key)
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 14. TTL CACHE ===
class TTLCache {
    __New(defaultTTL := 60000) {
        this.cache := Map()
        this.defaultTTL := defaultTTL
    }

    Set(key, value, ttl := 0) {
        if !ttl
            ttl := this.defaultTTL
        this.cache[key] := Map(
            "value", value,
            "expires", A_TickCount + ttl
        )
    }

    Get(key) {
        if !this.cache.Has(key)
            return ""

        entry := this.cache[key]
        if A_TickCount > entry["expires"] {
            this.cache.Delete(key)
            return ""
        }
        return entry["value"]
    }

    Cleanup() {
        now := A_TickCount
        for key in this.cache.Clone() {
            if now > this.cache[key]["expires"]
                this.cache.Delete(key)
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 15. WRITE-THROUGH CACHE ===
class WriteThroughCache {
    __New(storage) {
        this.cache := Map()
        this.storage := storage
    }

    Get(key) {
        if this.cache.Has(key)
            return this.cache[key]

        value := this.storage.Read(key)
        if value != ""
            this.cache[key] := value
        return value
    }

    Set(key, value) {
        this.storage.Write(key, value)
        this.cache[key] := value
    }

    Delete(key) {
        this.storage.Delete(key)
        this.cache.Delete(key)
    }
}

class MemoryStorage {
    __New() => this.data := Map()
    Read(key) => this.data.Has(key) ? this.data[key] : ""
    Write(key, value) => this.data[key] := value
    Delete(key) => this.data.Delete(key)
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 16. WRITE-BEHIND CACHE ===
class WriteBehindCache {
    __New(storage, flushInterval := 5000) {
        this.cache := Map()
        this.dirty := Map()
        this.storage := storage
        this.flushCallback := this.Flush.Bind(this)
        SetTimer(this.flushCallback, flushInterval)
    }

    Get(key) => this.cache.Has(key) ? this.cache[key] : ""

    Set(key, value) {
        this.cache[key] := value
        this.dirty[key] := true
    }

    Flush() {
        for key in this.dirty.Clone() {
            if this.cache.Has(key)
                this.storage.Write(key, this.cache[key])
            this.dirty.Delete(key)
        }
    }

    __Delete() {
        SetTimer(this.flushCallback, 0)
        this.Flush()
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 17. READ-THROUGH CACHE ===
class ReadThroughCache {
    __New(loader) {
        this.cache := Map()
        this.loader := loader
    }

    Get(key) {
        if !this.cache.Has(key)
            this.cache[key] := this.loader(key)
        return this.cache[key]
    }

    Invalidate(key) => this.cache.Delete(key)
    InvalidateAll() => this.cache := Map()
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 18. RING BUFFER ===
class RingBuffer {
    __New(capacity) {
        this.capacity := capacity
        this.buffer := []
        loop capacity
            this.buffer.Push("")
        this.head := 1
        this.tail := 1
        this.count := 0
    }

    Push(item) {
        this.buffer[this.tail] := item
        this.tail := Mod(this.tail, this.capacity) + 1

        if this.count < this.capacity
            this.count++
        else
            this.head := Mod(this.head, this.capacity) + 1
    }

    Pop() {
        if this.count = 0
            return ""

        item := this.buffer[this.head]
        this.head := Mod(this.head, this.capacity) + 1
        this.count--
        return item
    }

    Peek() => this.count > 0 ? this.buffer[this.head] : ""
    IsFull() => this.count = this.capacity
    IsEmpty() => this.count = 0
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 19. PRIORITY QUEUE ===
class PriorityQueue {
    __New() => this.heap := []

    Enqueue(item, priority) {
        this.heap.Push(Map("item", item, "priority", priority))
        this.BubbleUp(this.heap.Length)
    }

    Dequeue() {
        if !this.heap.Length
            return ""

        top := this.heap[1]
        last := this.heap.Pop()

        if this.heap.Length {
            this.heap[1] := last
            this.BubbleDown(1)
        }

        return top["item"]
    }

    BubbleUp(index) {
        while index > 1 {
            parent := index // 2
            if this.heap[parent]["priority"] <= this.heap[index]["priority"]
                break
            this.Swap(parent, index)
            index := parent
        }
    }

    BubbleDown(index) {
        loop {
            smallest := index
            left := index * 2
            right := left + 1

            if left <= this.heap.Length && this.heap[left]["priority"] < this.heap[smallest]["priority"]
                smallest := left
            if right <= this.heap.Length && this.heap[right]["priority"] < this.heap[smallest]["priority"]
                smallest := right

            if smallest = index
                break

            this.Swap(index, smallest)
            index := smallest
        }
    }

    Swap(i, j) {
        temp := this.heap[i]
        this.heap[i] := this.heap[j]
        this.heap[j] := temp
    }

    Peek() => this.heap.Length ? this.heap[1]["item"] : ""
    IsEmpty() => !this.heap.Length
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 20. DEQUE ===
class Deque {
    __New() => this.items := []

    PushFront(item) => this.items.InsertAt(1, item)
    PushBack(item) => this.items.Push(item)

    PopFront() => this.items.Length ? this.items.RemoveAt(1) : ""
    PopBack() => this.items.Length ? this.items.Pop() : ""

    PeekFront() => this.items.Length ? this.items[1] : ""
    PeekBack() => this.items.Length ? this.items[this.items.Length] : ""

    IsEmpty() => !this.items.Length
    Size() => this.items.Length
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 21. STACK ===
class Stack {
    __New() => this.items := []

    Push(item) => this.items.Push(item)
    Pop() => this.items.Length ? this.items.Pop() : ""
    Peek() => this.items.Length ? this.items[this.items.Length] : ""
    IsEmpty() => !this.items.Length
    Size() => this.items.Length
    Clear() => this.items := []
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 22. QUEUE ===
class Queue {
    __New() => this.items := []

    Enqueue(item) => this.items.Push(item)
    Dequeue() => this.items.Length ? this.items.RemoveAt(1) : ""
    Peek() => this.items.Length ? this.items[1] : ""
    IsEmpty() => !this.items.Length
    Size() => this.items.Length
    Clear() => this.items := []
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 23. TRIE ===
class Trie {
    __New() {
        this.children := Map()
        this.isEnd := false
    }

    Insert(word) {
        node := this
        loop StrLen(word) {
            char := SubStr(word, A_Index, 1)
            if !node.children.Has(char)
                node.children[char] := Trie()
            node := node.children[char]
        }
        node.isEnd := true
    }

    Search(word) {
        node := this.FindNode(word)
        return node && node.isEnd
    }

    StartsWith(prefix) => this.FindNode(prefix) != ""

    FindNode(str) {
        node := this
        loop StrLen(str) {
            char := SubStr(str, A_Index, 1)
            if !node.children.Has(char)
                return ""
            node := node.children[char]
        }
        return node
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 24. BINARY SEARCH TREE ===
class BSTNode {
    __New(value) {
        this.value := value
        this.left := ""
        this.right := ""
    }
}

class BST {
    __New() => this.root := ""

    Insert(value) {
        if !this.root {
            this.root := BSTNode(value)
            return
        }
        this.InsertNode(this.root, value)
    }

    InsertNode(node, value) {
        if value < node.value {
            if !node.left
                node.left := BSTNode(value)
            else
                this.InsertNode(node.left, value)
        } else {
            if !node.right
                node.right := BSTNode(value)
            else
                this.InsertNode(node.right, value)
        }
    }

    Search(value) => this.SearchNode(this.root, value)

    SearchNode(node, value) {
        if !node
            return false
        if value = node.value
            return true
        if value < node.value
            return this.SearchNode(node.left, value)
        return this.SearchNode(node.right, value)
    }

    InOrder() {
        result := []
        this.InOrderTraverse(this.root, result)
        return result
    }

    InOrderTraverse(node, result) {
        if !node
            return
        this.InOrderTraverse(node.left, result)
        result.Push(node.value)
        this.InOrderTraverse(node.right, result)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 25. LINKED LIST ===
class ListNode {
    __New(value) {
        this.value := value
        this.next := ""
    }
}

class LinkedList {
    __New() {
        this.head := ""
        this.tail := ""
        this.size := 0
    }

    Append(value) {
        node := ListNode(value)
        if !this.head {
            this.head := node
            this.tail := node
        } else {
            this.tail.next := node
            this.tail := node
        }
        this.size++
    }

    Prepend(value) {
        node := ListNode(value)
        node.next := this.head
        this.head := node
        if !this.tail
            this.tail := node
        this.size++
    }

    Remove(value) {
        if !this.head
            return false

        if this.head.value = value {
            this.head := this.head.next
            if !this.head
                this.tail := ""
            this.size--
            return true
        }

        current := this.head
        while current.next {
            if current.next.value = value {
                current.next := current.next.next
                if !current.next
                    this.tail := current
                this.size--
                return true
            }
            current := current.next
        }
        return false
    }

    ToArray() {
        result := []
        current := this.head
        while current {
            result.Push(current.value)
            current := current.next
        }
        return result
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 26. DOUBLY LINKED LIST ===
class DLLNode {
    __New(value) {
        this.value := value
        this.prev := ""
        this.next := ""
    }
}

class DoublyLinkedList {
    __New() {
        this.head := ""
        this.tail := ""
        this.size := 0
    }

    Append(value) {
        node := DLLNode(value)
        if !this.tail {
            this.head := node
            this.tail := node
        } else {
            node.prev := this.tail
            this.tail.next := node
            this.tail := node
        }
        this.size++
    }

    Prepend(value) {
        node := DLLNode(value)
        if !this.head {
            this.head := node
            this.tail := node
        } else {
            node.next := this.head
            this.head.prev := node
            this.head := node
        }
        this.size++
    }

    RemoveNode(node) {
        if node.prev
            node.prev.next := node.next
        else
            this.head := node.next

        if node.next
            node.next.prev := node.prev
        else
            this.tail := node.prev

        this.size--
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 27. GRAPH ===
class Graph {
    __New(directed := false) {
        this.adjacency := Map()
        this.directed := directed
    }

    AddVertex(v) {
        if !this.adjacency.Has(v)
            this.adjacency[v] := []
    }

    AddEdge(v1, v2, weight := 1) {
        this.AddVertex(v1)
        this.AddVertex(v2)
        this.adjacency[v1].Push(Map("vertex", v2, "weight", weight))
        if !this.directed
            this.adjacency[v2].Push(Map("vertex", v1, "weight", weight))
    }

    GetNeighbors(v) => this.adjacency.Has(v) ? this.adjacency[v] : []

    BFS(start) {
        visited := Map()
        result := []
        queue := [start]
        visited[start] := true

        while queue.Length {
            vertex := queue.RemoveAt(1)
            result.Push(vertex)

            for edge in this.GetNeighbors(vertex) {
                if !visited.Has(edge["vertex"]) {
                    visited[edge["vertex"]] := true
                    queue.Push(edge["vertex"])
                }
            }
        }
        return result
    }

    DFS(start) {
        visited := Map()
        result := []
        this.DFSRecurse(start, visited, result)
        return result
    }

    DFSRecurse(vertex, visited, result) {
        visited[vertex] := true
        result.Push(vertex)

        for edge in this.GetNeighbors(vertex) {
            if !visited.Has(edge["vertex"])
                this.DFSRecurse(edge["vertex"], visited, result)
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 28. DISJOINT SET ===
class DisjointSet {
    __New() {
        this.parent := Map()
        this.rank := Map()
    }

    MakeSet(x) {
        this.parent[x] := x
        this.rank[x] := 0
    }

    Find(x) {
        if !this.parent.Has(x)
            this.MakeSet(x)

        if this.parent[x] != x
            this.parent[x] := this.Find(this.parent[x])

        return this.parent[x]
    }

    Union(x, y) {
        rootX := this.Find(x)
        rootY := this.Find(y)

        if rootX = rootY
            return

        if this.rank[rootX] < this.rank[rootY]
            this.parent[rootX] := rootY
        else if this.rank[rootX] > this.rank[rootY]
            this.parent[rootY] := rootX
        else {
            this.parent[rootY] := rootX
            this.rank[rootX]++
        }
    }

    Connected(x, y) => this.Find(x) = this.Find(y)
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 29. HASH SET ===
class HashSet {
    __New() => this.items := Map()

    Add(item) => this.items[item] := true
    Remove(item) => this.items.Delete(item)
    Has(item) => this.items.Has(item)
    Clear() => this.items := Map()
    Size() => this.items.Count

    ToArray() {
        result := []
        for item in this.items
            result.Push(item)
        return result
    }

    Union(other) {
        result := HashSet()
        for item in this.items
            result.Add(item)
        for item in other.items
            result.Add(item)
        return result
    }

    Intersection(other) {
        result := HashSet()
        for item in this.items
            if other.Has(item)
                result.Add(item)
        return result
    }

    Difference(other) {
        result := HashSet()
        for item in this.items
            if !other.Has(item)
                result.Add(item)
        return result
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 30. MULTIMAP ===
class MultiMap {
    __New() => this.data := Map()

    Add(key, value) {
        if !this.data.Has(key)
            this.data[key] := []
        this.data[key].Push(value)
    }

    Get(key) => this.data.Has(key) ? this.data[key] : []

    Remove(key, value := "") {
        if !this.data.Has(key)
            return false

        if value = "" {
            this.data.Delete(key)
            return true
        }

        arr := this.data[key]
        for i, v in arr {
            if v = value {
                arr.RemoveAt(i)
                if !arr.Length
                    this.data.Delete(key)
                return true
            }
        }
        return false
    }

    Has(key) => this.data.Has(key) && this.data[key].Length > 0
    Count(key) => this.data.Has(key) ? this.data[key].Length : 0
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 31. BIMAP ===
class BiMap {
    __New() {
        this.forward := Map()
        this.reverse := Map()
    }

    Put(key, value) {
        if this.forward.Has(key)
            this.reverse.Delete(this.forward[key])
        if this.reverse.Has(value)
            this.forward.Delete(this.reverse[value])

        this.forward[key] := value
        this.reverse[value] := key
    }

    GetByKey(key) => this.forward.Has(key) ? this.forward[key] : ""
    GetByValue(value) => this.reverse.Has(value) ? this.reverse[value] : ""

    RemoveByKey(key) {
        if this.forward.Has(key) {
            this.reverse.Delete(this.forward[key])
            this.forward.Delete(key)
        }
    }

    RemoveByValue(value) {
        if this.reverse.Has(value) {
            this.forward.Delete(this.reverse[value])
            this.reverse.Delete(value)
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 32. ORDERED MAP ===
class OrderedMap {
    __New() {
        this.data := Map()
        this.order := []
    }

    Set(key, value) {
        if !this.data.Has(key)
            this.order.Push(key)
        this.data[key] := value
    }

    Get(key) => this.data.Has(key) ? this.data[key] : ""

    Delete(key) {
        if this.data.Has(key) {
            this.data.Delete(key)
            for i, k in this.order {
                if k = key {
                    this.order.RemoveAt(i)
                    break
                }
            }
        }
    }

    Keys() => this.order.Clone()

    __Enum(n) {
        i := 0
        return (&key, &value) {
            if ++i > this.order.Length
                return false
            key := this.order[i]
            value := this.data[key]
            return true
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 33. COUNTER ===
class Counter {
    __New() => this.counts := Map()

    Increment(key, amount := 1) {
        if !this.counts.Has(key)
            this.counts[key] := 0
        this.counts[key] += amount
    }

    Decrement(key, amount := 1) => this.Increment(key, -amount)

    Get(key) => this.counts.Has(key) ? this.counts[key] : 0

    MostCommon(n := 0) {
        items := []
        for key, count in this.counts
            items.Push(Map("key", key, "count", count))

        items.Sort((a, b) => b["count"] - a["count"])

        if n > 0 && n < items.Length {
            result := []
            loop n
                result.Push(items[A_Index])
            return result
        }
        return items
    }

    Total() {
        sum := 0
        for key, count in this.counts
            sum += count
        return sum
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 34. DEFAULT MAP ===
class DefaultMap {
    __New(defaultFactory) {
        this.data := Map()
        this.defaultFactory := defaultFactory
    }

    Get(key) {
        if !this.data.Has(key)
            this.data[key] := this.defaultFactory()
        return this.data[key]
    }

    Set(key, value) => this.data[key] := value
    Has(key) => this.data.Has(key)
    Delete(key) => this.data.Delete(key)

    __Enum(n) => this.data.__Enum(n)
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 35. INTERVAL TREE ===
class Interval {
    __New(start, end, data := "") {
        this.start := start
        this.end := end
        this.data := data
    }

    Overlaps(other) => this.start <= other.end && other.start <= this.end
    Contains(point) => point >= this.start && point <= this.end
}

class IntervalList {
    __New() => this.intervals := []

    Add(start, end, data := "") {
        this.intervals.Push(Interval(start, end, data))
        this.intervals.Sort((a, b) => a.start - b.start)
    }

    Query(point) {
        result := []
        for interval in this.intervals {
            if interval.Contains(point)
                result.Push(interval)
        }
        return result
    }

    QueryRange(start, end) {
        query := Interval(start, end)
        result := []
        for interval in this.intervals {
            if interval.Overlaps(query)
                result.Push(interval)
        }
        return result
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 36. SPARSE ARRAY ===
class SparseArray {
    __New(defaultValue := 0) {
        this.data := Map()
        this.defaultValue := defaultValue
    }

    Get(index) => this.data.Has(index) ? this.data[index] : this.defaultValue

    Set(index, value) {
        if value = this.defaultValue
            this.data.Delete(index)
        else
            this.data[index] := value
    }

    NonZeroIndices() {
        indices := []
        for index in this.data
            indices.Push(index)
        return indices
    }

    Density() => this.data.Count
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 37. MATRIX ===
class Matrix {
    __New(rows, cols, fill := 0) {
        this.rows := rows
        this.cols := cols
        this.data := []
        loop rows {
            row := []
            loop cols
                row.Push(fill)
            this.data.Push(row)
        }
    }

    Get(r, c) => this.data[r][c]
    Set(r, c, value) => this.data[r][c] := value

    Add(other) {
        result := Matrix(this.rows, this.cols)
        loop this.rows {
            r := A_Index
            loop this.cols {
                c := A_Index
                result.Set(r, c, this.Get(r, c) + other.Get(r, c))
            }
        }
        return result
    }

    Multiply(other) {
        if this.cols != other.rows
            throw Error("Incompatible dimensions")

        result := Matrix(this.rows, other.cols)
        loop this.rows {
            r := A_Index
            loop other.cols {
                c := A_Index
                sum := 0
                loop this.cols {
                    k := A_Index
                    sum += this.Get(r, k) * other.Get(k, c)
                }
                result.Set(r, c, sum)
            }
        }
        return result
    }

    Transpose() {
        result := Matrix(this.cols, this.rows)
        loop this.rows {
            r := A_Index
            loop this.cols {
                c := A_Index
                result.Set(c, r, this.Get(r, c))
            }
        }
        return result
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 38. VECTOR ===
class Vector {
    __New(components*) => this.v := components.Length ? components : [0, 0]

    static FromArray(arr) {
        vec := Vector()
        vec.v := arr.Clone()
        return vec
    }

    Add(other) {
        result := []
        loop this.v.Length
            result.Push(this.v[A_Index] + other.v[A_Index])
        return Vector.FromArray(result)
    }

    Subtract(other) {
        result := []
        loop this.v.Length
            result.Push(this.v[A_Index] - other.v[A_Index])
        return Vector.FromArray(result)
    }

    Scale(scalar) {
        result := []
        for val in this.v
            result.Push(val * scalar)
        return Vector.FromArray(result)
    }

    Dot(other) {
        sum := 0
        loop this.v.Length
            sum += this.v[A_Index] * other.v[A_Index]
        return sum
    }

    Magnitude() {
        sum := 0
        for val in this.v
            sum += val * val
        return Sqrt(sum)
    }

    Normalize() => this.Scale(1 / this.Magnitude())
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 39. COMPLEX NUMBER ===
class Complex {
    __New(real := 0, imag := 0) {
        this.real := real
        this.imag := imag
    }

    Add(other) => Complex(this.real + other.real, this.imag + other.imag)
    Subtract(other) => Complex(this.real - other.real, this.imag - other.imag)

    Multiply(other) => Complex(
        this.real * other.real - this.imag * other.imag,
        this.real * other.imag + this.imag * other.real
    )

    Divide(other) {
        denom := other.real ** 2 + other.imag ** 2
        return Complex(
            (this.real * other.real + this.imag * other.imag) / denom,
            (this.imag * other.real - this.real * other.imag) / denom
        )
    }

    Magnitude() => Sqrt(this.real ** 2 + this.imag ** 2)
    Phase() => ATan(this.imag / this.real)
    Conjugate() => Complex(this.real, -this.imag)

    ToString() {
        if this.imag >= 0
            return this.real "+" this.imag "i"
        return this.real this.imag "i"
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 40. FRACTION ===
class Fraction {
    __New(num, den := 1) {
        if den = 0
            throw Error("Division by zero")

        sign := (num < 0) != (den < 0) ? -1 : 1
        num := Abs(num)
        den := Abs(den)

        g := this.GCD(num, den)
        this.num := sign * (num // g)
        this.den := den // g
    }

    GCD(a, b) {
        while b {
            temp := b
            b := Mod(a, b)
            a := temp
        }
        return a
    }

    Add(other) => Fraction(this.num * other.den + other.num * this.den, this.den * other.den)
    Subtract(other) => Fraction(this.num * other.den - other.num * this.den, this.den * other.den)
    Multiply(other) => Fraction(this.num * other.num, this.den * other.den)
    Divide(other) => Fraction(this.num * other.den, this.den * other.num)

    ToFloat() => this.num / this.den
    ToString() => this.den = 1 ? String(this.num) : this.num "/" this.den
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 41. BIG INTEGER ===
class BigInt {
    __New(value := "0") {
        this.negative := SubStr(value, 1, 1) = "-"
        value := this.negative ? SubStr(value, 2) : value
        this.digits := []
        loop StrLen(value)
            this.digits.InsertAt(1, Integer(SubStr(value, A_Index, 1)))
    }

    Add(other) {
        if this.negative != other.negative
            return this.SubtractAbs(other)

        result := BigInt()
        result.negative := this.negative
        result.digits := []

        carry := 0
        maxLen := Max(this.digits.Length, other.digits.Length)

        loop maxLen {
            a := A_Index <= this.digits.Length ? this.digits[A_Index] : 0
            b := A_Index <= other.digits.Length ? other.digits[A_Index] : 0
            sum := a + b + carry
            result.digits.Push(Mod(sum, 10))
            carry := sum // 10
        }

        if carry
            result.digits.Push(carry)

        return result
    }

    SubtractAbs(other) {
        result := BigInt()
        result.digits := []

        borrow := 0
        loop this.digits.Length {
            a := this.digits[A_Index]
            b := A_Index <= other.digits.Length ? other.digits[A_Index] : 0
            diff := a - b - borrow

            if diff < 0 {
                diff += 10
                borrow := 1
            } else
                borrow := 0

            result.digits.Push(diff)
        }

        while result.digits.Length > 1 && result.digits[result.digits.Length] = 0
            result.digits.Pop()

        return result
    }

    ToString() {
        str := this.negative ? "-" : ""
        i := this.digits.Length
        while i > 0 {
            str .= this.digits[i]
            i--
        }
        return str
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 42. DATE RANGE GENERATOR ===
class DateRange {
    __New(startDate, endDate) {
        this.start := startDate
        this.end := endDate
    }

    __Enum(n) {
        current := this.start
        return (&date) {
            if current > this.end
                return false
            date := current
            current := DateAdd(current, 1, "days")
            return true
        }
    }

    static DaysBetween(d1, d2) => DateDiff(d2, d1, "days")

    Contains(date) => date >= this.start && date <= this.end

    Overlaps(other) => this.start <= other.end && other.start <= this.end
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 43. CRON EXPRESSION ===
class CronSchedule {
    __New(minute, hour, dayOfMonth, month, dayOfWeek) {
        this.minute := minute
        this.hour := hour
        this.dayOfMonth := dayOfMonth
        this.month := month
        this.dayOfWeek := dayOfWeek
    }

    Matches(timestamp := "") {
        if !timestamp
            timestamp := A_Now

        m := Integer(FormatTime(timestamp, "m"))
        h := Integer(FormatTime(timestamp, "H"))
        d := Integer(FormatTime(timestamp, "d"))
        mo := Integer(FormatTime(timestamp, "M"))
        dw := Integer(FormatTime(timestamp, "WDay"))

        return this.FieldMatches(this.minute, m)
            && this.FieldMatches(this.hour, h)
            && this.FieldMatches(this.dayOfMonth, d)
            && this.FieldMatches(this.month, mo)
            && this.FieldMatches(this.dayOfWeek, dw)
    }

    FieldMatches(field, value) {
        if field = "*"
            return true
        if IsInteger(field)
            return Integer(field) = value
        if InStr(field, ",") {
            for part in StrSplit(field, ",")
                if Integer(part) = value
                    return true
            return false
        }
        if InStr(field, "-") {
            parts := StrSplit(field, "-")
            return value >= Integer(parts[1]) && value <= Integer(parts[2])
        }
        return false
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 44. TIMER WHEEL ===
class TimerWheel {
    __New(slots := 60, tickDuration := 1000) {
        this.slots := slots
        this.tickDuration := tickDuration
        this.wheel := []
        loop slots
            this.wheel.Push([])
        this.currentSlot := 1
        this.callback := this.Tick.Bind(this)
        SetTimer(this.callback, tickDuration)
    }

    Schedule(delay, action) {
        ticks := delay // this.tickDuration
        slot := Mod(this.currentSlot + ticks - 1, this.slots) + 1
        this.wheel[slot].Push(action)
    }

    Tick() {
        for action in this.wheel[this.currentSlot]
            action()
        this.wheel[this.currentSlot] := []
        this.currentSlot := Mod(this.currentSlot, this.slots) + 1
    }

    Stop() => SetTimer(this.callback, 0)
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 45. SCHEDULER ===
class Scheduler {
    __New() {
        this.tasks := []
        this.running := false
    }

    Schedule(task, interval, repeat := true) {
        this.tasks.Push(Map(
            "task", task,
            "interval", interval,
            "repeat", repeat,
            "nextRun", A_TickCount + interval
        ))
    }

    Start() {
        this.running := true
        this.callback := this.Process.Bind(this)
        SetTimer(this.callback, 100)
    }

    Stop() {
        this.running := false
        SetTimer(this.callback, 0)
    }

    Process() {
        now := A_TickCount
        i := 1
        while i <= this.tasks.Length {
            task := this.tasks[i]
            if now >= task["nextRun"] {
                task["task"]()
                if task["repeat"]
                    task["nextRun"] := now + task["interval"]
                else {
                    this.tasks.RemoveAt(i)
                    continue
                }
            }
            i++
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 46. WORK QUEUE ===
class WorkQueue {
    __New(concurrency := 1) {
        this.concurrency := concurrency
        this.queue := []
        this.running := 0
    }

    Add(task) {
        this.queue.Push(task)
        this.Process()
    }

    Process() {
        while this.running < this.concurrency && this.queue.Length {
            task := this.queue.RemoveAt(1)
            this.running++
            try
                task()
            finally
                this.running--
            this.Process()
        }
    }

    Clear() => this.queue := []
    Pending() => this.queue.Length
    Active() => this.running
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 47. ASYNC QUEUE ===
class AsyncQueue {
    __New() {
        this.queue := []
        this.processing := false
        this.handlers := Map()
    }

    OnComplete(handler) => this.handlers["complete"] := handler
    OnError(handler) => this.handlers["error"] := handler

    Enqueue(task) {
        this.queue.Push(task)
        if !this.processing
            this.ProcessNext()
    }

    ProcessNext() {
        if !this.queue.Length {
            this.processing := false
            return
        }

        this.processing := true
        task := this.queue.RemoveAt(1)

        try {
            result := task()
            if this.handlers.Has("complete")
                this.handlers["complete"](result)
        } catch as e {
            if this.handlers.Has("error")
                this.handlers["error"](e)
        }

        SetTimer(this.ProcessNext.Bind(this), -1)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 48. PUBSUB ===
class PubSub {
    static channels := Map()

    static Subscribe(channel, callback) {
        if !this.channels.Has(channel)
            this.channels[channel] := []
        this.channels[channel].Push(callback)

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
            return

        for callback in this.channels[channel]
            callback(data*)
    }

    static Clear(channel := "") {
        if channel
            this.channels.Delete(channel)
        else
            this.channels := Map()
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 49. MESSAGE BUS ===
class MessageBus {
    __New() {
        this.handlers := Map()
        this.middlewares := []
    }

    Use(middleware) => this.middlewares.Push(middleware)

    On(messageType, handler) {
        if !this.handlers.Has(messageType)
            this.handlers[messageType] := []
        this.handlers[messageType].Push(handler)
    }

    Send(message) {
        processed := message
        for mw in this.middlewares
            processed := mw(processed)

        type := processed.Has("type") ? processed["type"] : ""
        if !type || !this.handlers.Has(type)
            return

        for handler in this.handlers[type]
            handler(processed)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 50. SIGNAL ===
class Signal {
    __New() {
        this.slots := []
        this.blocked := false
    }

    Connect(slot) {
        this.slots.Push(slot)
        return () => this.Disconnect(slot)
    }

    Disconnect(slot) {
        for i, s in this.slots {
            if s = slot {
                this.slots.RemoveAt(i)
                return
            }
        }
    }

    Emit(args*) {
        if this.blocked
            return
        for slot in this.slots
            slot(args*)
    }

    Block() => this.blocked := true
    Unblock() => this.blocked := false
    Clear() => this.slots := []
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 51. PROPERTY CHANGED ===
class Observable {
    __New() {
        this._data := Map()
        this._listeners := Map()
    }

    Get(prop) => this._data.Has(prop) ? this._data[prop] : ""

    Set(prop, value) {
        old := this.Get(prop)
        if old = value
            return

        this._data[prop] := value
        this.Notify(prop, old, value)
    }

    Watch(prop, callback) {
        if !this._listeners.Has(prop)
            this._listeners[prop] := []
        this._listeners[prop].Push(callback)
    }

    Notify(prop, old, new) {
        if this._listeners.Has(prop)
            for cb in this._listeners[prop]
                cb(prop, old, new)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 52. TWO-WAY BINDING ===
class Binding {
    __New(source, sourceProp, target, targetProp) {
        this.source := source
        this.sourceProp := sourceProp
        this.target := target
        this.targetProp := targetProp
        this.updating := false

        source.Watch(sourceProp, this.OnSourceChange.Bind(this))
        target.Watch(targetProp, this.OnTargetChange.Bind(this))
    }

    OnSourceChange(prop, old, new) {
        if this.updating
            return
        this.updating := true
        this.target.Set(this.targetProp, new)
        this.updating := false
    }

    OnTargetChange(prop, old, new) {
        if this.updating
            return
        this.updating := true
        this.source.Set(this.sourceProp, new)
        this.updating := false
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 53. EXPRESSION EVALUATOR ===
class Evaluator {
    static Evaluate(expr, context := "") {
        if !context
            context := Map()

        expr := Trim(expr)

        if RegExMatch(expr, "^\d+(\.\d+)?$")
            return Number(expr)

        if context.Has(expr)
            return context[expr]

        if RegExMatch(expr, "^(.+)\s*([+\-*/])\s*(.+)$", &m) {
            left := this.Evaluate(m[1], context)
            right := this.Evaluate(m[3], context)
            switch m[2] {
                case "+": return left + right
                case "-": return left - right
                case "*": return left * right
                case "/": return right != 0 ? left / right : 0
            }
        }

        return 0
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 54. TEMPLATE ENGINE ===
class Template {
    __New(template) => this.template := template

    Render(data) {
        result := this.template

        for key, value in data
            result := StrReplace(result, "{{" key "}}", String(value))

        while RegExMatch(result, "\{\{#each\s+(\w+)\}\}(.*?)\{\{/each\}\}", &m) {
            if data.Has(m[1]) {
                items := data[m[1]]
                replacement := ""
                for item in items {
                    itemResult := m[2]
                    if IsObject(item) {
                        for k, v in item
                            itemResult := StrReplace(itemResult, "{{" k "}}", String(v))
                    } else
                        itemResult := StrReplace(itemResult, "{{this}}", String(item))
                    replacement .= itemResult
                }
                result := StrReplace(result, m[0], replacement)
            }
        }

        return result
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 55. ROUTER ===
class Router {
    __New() {
        this.routes := []
        this.middleware := []
    }

    Use(mw) => this.middleware.Push(mw)

    Add(pattern, handler) {
        regex := "^" StrReplace(pattern, ":(\w+)", "(?P<$1>[^/]+)") "$"
        this.routes.Push(Map("pattern", pattern, "regex", regex, "handler", handler))
    }

    Route(path) {
        for mw in this.middleware
            path := mw(path)

        for route in this.routes {
            if RegExMatch(path, route["regex"], &m) {
                params := Map()
                if RegExMatch(route["pattern"], ":(\w+)", &p)
                    params[p[1]] := m[p[1]]
                return route["handler"](params)
            }
        }
        return ""
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 56. MIDDLEWARE CHAIN ===
class MiddlewareChain {
    __New() => this.stack := []

    Use(fn) {
        this.stack.Push(fn)
        return this
    }

    Execute(context, finalHandler) {
        index := 0

        next := () {
            index++
            if index <= this.stack.Length
                this.stack[index](context, next)
            else if finalHandler
                finalHandler(context)
        }

        next()
        return context
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 57. RULE ENGINE ===
class Rule {
    __New(name, condition, action) {
        this.name := name
        this.condition := condition
        this.action := action
        this.priority := 0
    }
}

class RuleEngine {
    __New() => this.rules := []

    AddRule(name, condition, action, priority := 0) {
        rule := Rule(name, condition, action)
        rule.priority := priority
        this.rules.Push(rule)
        this.rules.Sort((a, b) => b.priority - a.priority)
    }

    Evaluate(facts) {
        results := []
        for rule in this.rules {
            if rule.condition(facts) {
                result := rule.action(facts)
                results.Push(Map("rule", rule.name, "result", result))
            }
        }
        return results
    }

    EvaluateFirst(facts) {
        for rule in this.rules {
            if rule.condition(facts)
                return rule.action(facts)
        }
        return ""
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 58. DECISION TABLE ===
class DecisionTable {
    __New() {
        this.conditions := []
        this.actions := []
        this.rules := []
    }

    AddCondition(name, evaluator) {
        this.conditions.Push(Map("name", name, "eval", evaluator))
    }

    AddAction(name, executor) {
        this.actions.Push(Map("name", name, "exec", executor))
    }

    AddRule(conditionResults, actionIndices) {
        this.rules.Push(Map("conditions", conditionResults, "actions", actionIndices))
    }

    Evaluate(context) {
        condResults := []
        for cond in this.conditions
            condResults.Push(cond["eval"](context))

        for rule in this.rules {
            match := true
            for i, expected in rule["conditions"] {
                if expected != "*" && condResults[i] != expected {
                    match := false
                    break
                }
            }

            if match {
                for actionIdx in rule["actions"]
                    this.actions[actionIdx]["exec"](context)
                return true
            }
        }
        return false
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 59. VALIDATOR ===
class FieldValidator {
    __New() => this.rules := []

    Required(msg := "Field is required") {
        this.rules.Push(Map("type", "required", "msg", msg))
        return this
    }

    MinLength(len, msg := "") {
        if !msg
            msg := "Minimum length is " len
        this.rules.Push(Map("type", "minLength", "value", len, "msg", msg))
        return this
    }

    MaxLength(len, msg := "") {
        if !msg
            msg := "Maximum length is " len
        this.rules.Push(Map("type", "maxLength", "value", len, "msg", msg))
        return this
    }

    Pattern(regex, msg := "Invalid format") {
        this.rules.Push(Map("type", "pattern", "value", regex, "msg", msg))
        return this
    }

    Validate(value) {
        errors := []
        for rule in this.rules {
            switch rule["type"] {
                case "required":
                    if value = ""
                        errors.Push(rule["msg"])
                case "minLength":
                    if StrLen(value) < rule["value"]
                        errors.Push(rule["msg"])
                case "maxLength":
                    if StrLen(value) > rule["value"]
                        errors.Push(rule["msg"])
                case "pattern":
                    if !RegExMatch(value, rule["value"])
                        errors.Push(rule["msg"])
            }
        }
        return errors
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 60. SCHEMA VALIDATOR ===
class Schema {
    __New() => this.fields := Map()

    Field(name) {
        validator := FieldValidator()
        this.fields[name] := validator
        return validator
    }

    Validate(data) {
        errors := Map()
        valid := true

        for name, validator in this.fields {
            value := data.Has(name) ? data[name] : ""
            fieldErrors := validator.Validate(value)
            if fieldErrors.Length {
                errors[name] := fieldErrors
                valid := false
            }
        }

        return Map("valid", valid, "errors", errors)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 61. DIFF ===
class Diff {
    static Compare(a, b) {
        changes := []

        if IsObject(a) && IsObject(b) {
            allKeys := Map()
            for key in a.OwnProps()
                allKeys[key] := true
            for key in b.OwnProps()
                allKeys[key] := true

            for key in allKeys {
                hasA := a.HasOwnProp(key)
                hasB := b.HasOwnProp(key)

                if hasA && !hasB
                    changes.Push(Map("type", "delete", "key", key, "old", a.%key%))
                else if !hasA && hasB
                    changes.Push(Map("type", "add", "key", key, "new", b.%key%))
                else if a.%key% != b.%key%
                    changes.Push(Map("type", "change", "key", key, "old", a.%key%, "new", b.%key%))
            }
        }

        return changes
    }

    static Apply(obj, changes) {
        result := obj.Clone()
        for change in changes {
            switch change["type"] {
                case "add", "change":
                    result.%change["key"]% := change["new"]
                case "delete":
                    result.DeleteProp(change["key"])
            }
        }
        return result
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 62. PATCH ===
class JsonPatch {
    static Apply(doc, operations) {
        result := doc.Clone()

        for op in operations {
            switch op["op"] {
                case "add":
                    result.%op["path"]% := op["value"]
                case "remove":
                    result.DeleteProp(op["path"])
                case "replace":
                    result.%op["path"]% := op["value"]
                case "copy":
                    result.%op["path"]% := result.%op["from"]%
                case "move":
                    result.%op["path"]% := result.%op["from"]%
                    result.DeleteProp(op["from"])
            }
        }

        return result
    }

    static Create(from, to) {
        ops := []
        diff := Diff.Compare(from, to)

        for change in diff {
            switch change["type"] {
                case "add":
                    ops.Push(Map("op", "add", "path", change["key"], "value", change["new"]))
                case "delete":
                    ops.Push(Map("op", "remove", "path", change["key"]))
                case "change":
                    ops.Push(Map("op", "replace", "path", change["key"], "value", change["new"]))
            }
        }

        return ops
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 63. SNAPSHOT ===
class Snapshot {
    __New(state) {
        this.state := this.DeepClone(state)
        this.timestamp := A_TickCount
    }

    DeepClone(obj) {
        if !IsObject(obj)
            return obj

        if Type(obj) = "Array" {
            result := []
            for item in obj
                result.Push(this.DeepClone(item))
            return result
        }

        if Type(obj) = "Map" {
            result := Map()
            for key, value in obj
                result[key] := this.DeepClone(value)
            return result
        }

        result := {}
        for key in obj.OwnProps()
            result.%key% := this.DeepClone(obj.%key%)
        return result
    }

    Restore() => this.DeepClone(this.state)
}

class SnapshotManager {
    __New(maxSnapshots := 10) {
        this.snapshots := []
        this.maxSnapshots := maxSnapshots
    }

    Take(state) {
        this.snapshots.Push(Snapshot(state))
        while this.snapshots.Length > this.maxSnapshots
            this.snapshots.RemoveAt(1)
    }

    Restore(index := 0) {
        if !index
            index := this.snapshots.Length
        return index <= this.snapshots.Length ? this.snapshots[index].Restore() : ""
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 64. VERSION ===
class Version {
    __New(major, minor := 0, patch := 0) {
        this.major := major
        this.minor := minor
        this.patch := patch
    }

    static Parse(str) {
        parts := StrSplit(str, ".")
        return Version(
            parts.Length >= 1 ? Integer(parts[1]) : 0,
            parts.Length >= 2 ? Integer(parts[2]) : 0,
            parts.Length >= 3 ? Integer(parts[3]) : 0
        )
    }

    Compare(other) {
        if this.major != other.major
            return this.major - other.major
        if this.minor != other.minor
            return this.minor - other.minor
        return this.patch - other.patch
    }

    IsGreaterThan(other) => this.Compare(other) > 0
    IsLessThan(other) => this.Compare(other) < 0
    IsEqual(other) => this.Compare(other) = 0

    Bump(part := "patch") {
        switch part {
            case "major": return Version(this.major + 1, 0, 0)
            case "minor": return Version(this.major, this.minor + 1, 0)
            default: return Version(this.major, this.minor, this.patch + 1)
        }
    }

    ToString() => this.major "." this.minor "." this.patch
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 65. COLOR ===
class Color {
    __New(r, g, b, a := 255) {
        this.r := Mod(r, 256)
        this.g := Mod(g, 256)
        this.b := Mod(b, 256)
        this.a := Mod(a, 256)
    }

    static FromHex(hex) {
        hex := StrReplace(hex, "#", "")
        return Color(
            Integer("0x" SubStr(hex, 1, 2)),
            Integer("0x" SubStr(hex, 3, 2)),
            Integer("0x" SubStr(hex, 5, 2))
        )
    }

    ToHex() => Format("#{:02X}{:02X}{:02X}", this.r, this.g, this.b)
    ToRGB() => Format("rgb({}, {}, {})", this.r, this.g, this.b)
    ToRGBA() => Format("rgba({}, {}, {}, {})", this.r, this.g, this.b, Round(this.a / 255, 2))

    Lighten(amount := 0.1) {
        return Color(
            Min(255, this.r + 255 * amount),
            Min(255, this.g + 255 * amount),
            Min(255, this.b + 255 * amount),
            this.a
        )
    }

    Darken(amount := 0.1) {
        return Color(
            Max(0, this.r - 255 * amount),
            Max(0, this.g - 255 * amount),
            Max(0, this.b - 255 * amount),
            this.a
        )
    }

    Mix(other, weight := 0.5) {
        return Color(
            this.r * (1 - weight) + other.r * weight,
            this.g * (1 - weight) + other.g * weight,
            this.b * (1 - weight) + other.b * weight,
            this.a * (1 - weight) + other.a * weight
        )
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 66. POINT ===
class Point {
    __New(x := 0, y := 0) {
        this.x := x
        this.y := y
    }

    Add(other) => Point(this.x + other.x, this.y + other.y)
    Subtract(other) => Point(this.x - other.x, this.y - other.y)
    Scale(factor) => Point(this.x * factor, this.y * factor)

    Distance(other) => Sqrt((this.x - other.x) ** 2 + (this.y - other.y) ** 2)

    Angle(other) => ATan2(other.y - this.y, other.x - this.x)

    Rotate(angle, origin := "") {
        if !origin
            origin := Point(0, 0)

        translated := this.Subtract(origin)
        cos := Cos(angle)
        sin := Sin(angle)

        rotated := Point(
            translated.x * cos - translated.y * sin,
            translated.x * sin + translated.y * cos
        )

        return rotated.Add(origin)
    }

    ToString() => "(" this.x ", " this.y ")"
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 67. RECTANGLE ===
class Rectangle {
    __New(x, y, width, height) {
        this.x := x
        this.y := y
        this.width := width
        this.height := height
    }

    Left => this.x
    Right => this.x + this.width
    Top => this.y
    Bottom => this.y + this.height

    Center => Point(this.x + this.width / 2, this.y + this.height / 2)
    Area => this.width * this.height
    Perimeter => 2 * (this.width + this.height)

    Contains(point) {
        return point.x >= this.Left && point.x <= this.Right
            && point.y >= this.Top && point.y <= this.Bottom
    }

    Intersects(other) {
        return this.Left < other.Right && this.Right > other.Left
            && this.Top < other.Bottom && this.Bottom > other.Top
    }

    Intersection(other) {
        if !this.Intersects(other)
            return ""

        return Rectangle(
            Max(this.Left, other.Left),
            Max(this.Top, other.Top),
            Min(this.Right, other.Right) - Max(this.Left, other.Left),
            Min(this.Bottom, other.Bottom) - Max(this.Top, other.Top)
        )
    }

    Union(other) {
        return Rectangle(
            Min(this.Left, other.Left),
            Min(this.Top, other.Top),
            Max(this.Right, other.Right) - Min(this.Left, other.Left),
            Max(this.Bottom, other.Bottom) - Min(this.Top, other.Top)
        )
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 68. CIRCLE ===
class Circle {
    __New(center, radius) {
        this.center := center
        this.radius := radius
    }

    Area => 3.14159 * this.radius ** 2
    Circumference => 2 * 3.14159 * this.radius
    Diameter => 2 * this.radius

    Contains(point) => this.center.Distance(point) <= this.radius

    Intersects(other) {
        distance := this.center.Distance(other.center)
        return distance <= this.radius + other.radius
    }

    PointAt(angle) {
        return Point(
            this.center.x + this.radius * Cos(angle),
            this.center.y + this.radius * Sin(angle)
        )
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 69. LINE ===
class Line {
    __New(start, end) {
        this.start := start
        this.end := end
    }

    Length => this.start.Distance(this.end)

    Midpoint => Point(
        (this.start.x + this.end.x) / 2,
        (this.start.y + this.end.y) / 2
    )

    Slope {
        get {
            if this.end.x = this.start.x
                return ""
            return (this.end.y - this.start.y) / (this.end.x - this.start.x)
        }
    }

    PointAt(t) {
        return Point(
            this.start.x + t * (this.end.x - this.start.x),
            this.start.y + t * (this.end.y - this.start.y)
        )
    }

    DistanceTo(point) {
        a := this.end.y - this.start.y
        b := this.start.x - this.end.x
        c := this.end.x * this.start.y - this.start.x * this.end.y
        return Abs(a * point.x + b * point.y + c) / Sqrt(a ** 2 + b ** 2)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 70. PATH ===
class Path {
    __New() => this.points := []

    MoveTo(point) {
        this.points := [point]
        return this
    }

    LineTo(point) {
        this.points.Push(point)
        return this
    }

    Close() {
        if this.points.Length > 1
            this.points.Push(this.points[1])
        return this
    }

    Length {
        get {
            total := 0
            loop this.points.Length - 1
                total += this.points[A_Index].Distance(this.points[A_Index + 1])
            return total
        }
    }

    Bounds {
        get {
            if !this.points.Length
                return ""

            minX := maxX := this.points[1].x
            minY := maxY := this.points[1].y

            for point in this.points {
                minX := Min(minX, point.x)
                maxX := Max(maxX, point.x)
                minY := Min(minY, point.y)
                maxY := Max(maxY, point.y)
            }

            return Rectangle(minX, minY, maxX - minX, maxY - minY)
        }
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 71. EASING ===
class Easing {
    static Linear(t) => t
    static EaseInQuad(t) => t * t
    static EaseOutQuad(t) => t * (2 - t)
    static EaseInOutQuad(t) => t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t

    static EaseInCubic(t) => t * t * t
    static EaseOutCubic(t) => (--t) * t * t + 1
    static EaseInOutCubic(t) => t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1

    static EaseInSine(t) => 1 - Cos(t * 3.14159 / 2)
    static EaseOutSine(t) => Sin(t * 3.14159 / 2)
    static EaseInOutSine(t) => -(Cos(3.14159 * t) - 1) / 2

    static EaseInExpo(t) => t = 0 ? 0 : 2 ** (10 * t - 10)
    static EaseOutExpo(t) => t = 1 ? 1 : 1 - 2 ** (-10 * t)

    static EaseInElastic(t) {
        if t = 0 || t = 1
            return t
        return -(2 ** (10 * t - 10)) * Sin((t * 10 - 10.75) * 2.094)
    }

    static EaseOutElastic(t) {
        if t = 0 || t = 1
            return t
        return 2 ** (-10 * t) * Sin((t * 10 - 0.75) * 2.094) + 1
    }

    static EaseOutBounce(t) {
        if t < 1 / 2.75
            return 7.5625 * t * t
        if t < 2 / 2.75
            return 7.5625 * (t -= 1.5 / 2.75) * t + 0.75
        if t < 2.5 / 2.75
            return 7.5625 * (t -= 2.25 / 2.75) * t + 0.9375
        return 7.5625 * (t -= 2.625 / 2.75) * t + 0.984375
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 72. TWEEN ===
class Tween {
    __New(from, to, duration, easing := "") {
        this.from := from
        this.to := to
        this.duration := duration
        this.easing := easing ? easing : Easing.Linear
        this.startTime := 0
        this.running := false
        this.onUpdate := ""
        this.onComplete := ""
    }

    Start() {
        this.startTime := A_TickCount
        this.running := true
        this.callback := this.Update.Bind(this)
        SetTimer(this.callback, 16)
    }

    Update() {
        elapsed := A_TickCount - this.startTime
        progress := Min(1, elapsed / this.duration)
        easedProgress := this.easing(progress)

        current := this.from + (this.to - this.from) * easedProgress

        if this.onUpdate
            this.onUpdate(current)

        if progress >= 1 {
            this.running := false
            SetTimer(this.callback, 0)
            if this.onComplete
                this.onComplete()
        }
    }

    Stop() {
        this.running := false
        SetTimer(this.callback, 0)
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 73. ANIMATION SEQUENCE ===
class AnimationSequence {
    __New() {
        this.animations := []
        this.currentIndex := 0
        this.running := false
    }

    Add(animation) {
        this.animations.Push(animation)
        return this
    }

    Start() {
        if !this.animations.Length
            return

        this.running := true
        this.currentIndex := 1
        this.RunCurrent()
    }

    RunCurrent() {
        if this.currentIndex > this.animations.Length {
            this.running := false
            return
        }

        anim := this.animations[this.currentIndex]
        anim.onComplete := this.OnAnimationComplete.Bind(this)
        anim.Start()
    }

    OnAnimationComplete() {
        this.currentIndex++
        this.RunCurrent()
    }

    Stop() {
        if this.currentIndex <= this.animations.Length
            this.animations[this.currentIndex].Stop()
        this.running := false
    }
}
cpp#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 74. SPRING PHYSICS ===
class Spring {
    __New(target, stiffness := 100, damping := 10, mass := 1) {
        this.target := target
        this.stiffness := stiffness
        this.damping := damping
        this.mass := mass
        this.position := 0
        this.velocity := 0
        this.running := false
        this.onUpdate := ""
    }

    SetTarget(target) => this.target := target

    Start() {
        this.running := true
        this.lastTime := A_TickCount
        this.callback := this.Update.Bind(this)
        SetTimer(this.callback, 16)
    }

    Update() {
        now := A_TickCount
        dt := (now - this.lastTime) / 1000
        this.lastTime := now

        springForce := -this.stiffness * (this.position - this.target)
        dampingForce := -this.damping * this.velocity
        acceleration := (springForce + dampingForce) /Continuethis.mass
    this.velocity += acceleration * dt
    this.position += this.velocity * dt

    if this.onUpdate
        this.onUpdate(this.position)

    if Abs(this.velocity) < 0.01 && Abs(this.position - this.target) < 0.01 {
        this.position := this.target
        this.velocity := 0
        this.running := false
        SetTimer(this.callback, 0)
    }
}

Stop() {
    this.running := false
    SetTimer(this.callback, 0)
}
}
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 75. PARTICLE ===
class Particle {
    __New(x, y, vx := 0, vy := 0) {
        this.position := Point(x, y)
        this.velocity := Point(vx, vy)
        this.acceleration := Point(0, 0)
        this.life := 1
        this.decay := 0.01
    }

    ApplyForce(force) {
        this.acceleration := this.acceleration.Add(force)
    }

    Update() {
        this.velocity := this.velocity.Add(this.acceleration)
        this.position := this.position.Add(this.velocity)
        this.acceleration := Point(0, 0)
        this.life -= this.decay
    }

    IsDead() => this.life <= 0
}

class ParticleSystem {
    __New() {
        this.particles := []
        this.gravity := Point(0, 0.1)
    }

    Emit(x, y, count := 1) {
        loop count {
            vx := (Random() - 0.5) * 4
            vy := (Random() - 0.5) * 4 - 2
            this.particles.Push(Particle(x, y, vx, vy))
        }
    }

    Update() {
        i := this.particles.Length
        while i > 0 {
            p := this.particles[i]
            p.ApplyForce(this.gravity)
            p.Update()
            if p.IsDead()
                this.particles.RemoveAt(i)
            i--
        }
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 76. NOISE ===
class PerlinNoise {
    __New(seed := 0) {
        this.p := []
        this.permutation := []

        loop 256
            this.permutation.Push(A_Index - 1)

        loop 256 {
            j := Random(1, 256)
            temp := this.permutation[A_Index]
            this.permutation[A_Index] := this.permutation[j]
            this.permutation[j] := temp
        }

        loop 512
            this.p.Push(this.permutation[Mod(A_Index - 1, 256) + 1])
    }

    Fade(t) => t * t * t * (t * (t * 6 - 15) + 10)

    Lerp(t, a, b) => a + t * (b - a)

    Grad(hash, x, y) {
        h := hash & 3
        u := h < 2 ? x : y
        v := h < 2 ? y : x
        return ((h & 1) ? -u : u) + ((h & 2) ? -2 * v : 2 * v)
    }

    Noise(x, y) {
        X := Integer(Floor(x)) & 255
        Y := Integer(Floor(y)) & 255

        x -= Floor(x)
        y -= Floor(y)

        u := this.Fade(x)
        v := this.Fade(y)

        A := this.p[X + 1] + Y
        B := this.p[X + 2] + Y

        return this.Lerp(v,
            this.Lerp(u, this.Grad(this.p[A + 1], x, y), this.Grad(this.p[B + 1], x - 1, y)),
            this.Lerp(u, this.Grad(this.p[A + 2], x, y - 1), this.Grad(this.p[B + 2], x - 1, y - 1))
        )
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 77. RANDOM ===
class RandomGenerator {
    __New(seed := 0) {
        this.seed := seed ? seed : A_TickCount
        this.state := this.seed
    }

    Next() {
        this.state := (this.state * 1103515245 + 12345) & 0x7FFFFFFF
        return this.state / 0x7FFFFFFF
    }

    NextInt(min, max) => min + Integer(this.Next() * (max - min + 1))
    NextFloat(min, max) => min + this.Next() * (max - min)
    NextBool(probability := 0.5) => this.Next() < probability

    Choice(arr) => arr[this.NextInt(1, arr.Length)]

    Shuffle(arr) {
        result := arr.Clone()
        i := result.Length
        while i > 1 {
            j := this.NextInt(1, i)
            temp := result[i]
            result[i] := result[j]
            result[j] := temp
            i--
        }
        return result
    }

    Sample(arr, count) {
        shuffled := this.Shuffle(arr)
        result := []
        loop Min(count, shuffled.Length)
            result.Push(shuffled[A_Index])
        return result
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 78. UUID ===
class UUID {
    static Generate() {
        hex := "0123456789abcdef"
        uuid := ""

        loop 36 {
            if A_Index = 9 || A_Index = 14 || A_Index = 19 || A_Index = 24
                uuid .= "-"
            else if A_Index = 15
                uuid .= "4"
            else if A_Index = 20
                uuid .= SubStr(hex, (Random(0, 3) | 8) + 1, 1)
            else
                uuid .= SubStr(hex, Random(1, 16), 1)
        }

        return uuid
    }

    static IsValid(uuid) {
        return RegExMatch(uuid, "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$")
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 79. SLUG ===
class Slug {
    static Generate(text, separator := "-") {
        text := StrLower(text)
        text := RegExReplace(text, "[^\w\s-]", "")
        text := RegExReplace(text, "[\s_]+", separator)
        text := RegExReplace(text, separator "{2,}", separator)
        text := Trim(text, separator)
        return text
    }

    static Unique(text, existing := "") {
        base := this.Generate(text)

        if !existing || !existing.Length
            return base

        slug := base
        counter := 1

        while this.Contains(existing, slug) {
            counter++
            slug := base "-" counter
        }

        return slug
    }

    static Contains(arr, value) {
        for item in arr
            if item = value
                return true
        return false
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 80. HASH ===
class Hash {
    static DJB2(str) {
        hash := 5381
        loop StrLen(str)
            hash := ((hash << 5) + hash) + Ord(SubStr(str, A_Index, 1))
        return hash & 0x7FFFFFFF
    }

    static FNV1a(str) {
        hash := 2166136261
        loop StrLen(str) {
            hash ^= Ord(SubStr(str, A_Index, 1))
            hash := (hash * 16777619) & 0xFFFFFFFF
        }
        return hash
    }

    static SimpleHash(str) {
        hash := 0
        loop StrLen(str) {
            char := Ord(SubStr(str, A_Index, 1))
            hash := ((hash << 5) - hash) + char
            hash := hash & 0xFFFFFFFF
        }
        return hash
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 81. BASE64 ===
class Base64 {
    static chars := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

    static Encode(str) {
        result := ""
        bytes := []

        loop StrLen(str)
            bytes.Push(Ord(SubStr(str, A_Index, 1)))

        i := 1
        while i <= bytes.Length {
            b1 := bytes[i]
            b2 := i + 1 <= bytes.Length ? bytes[i + 1] : 0
            b3 := i + 2 <= bytes.Length ? bytes[i + 2] : 0

            result .= SubStr(this.chars, (b1 >> 2) + 1, 1)
            result .= SubStr(this.chars, (((b1 & 3) << 4) | (b2 >> 4)) + 1, 1)
            result .= i + 1 <= bytes.Length ? SubStr(this.chars, (((b2 & 15) << 2) | (b3 >> 6)) + 1, 1) : "="
            result .= i + 2 <= bytes.Length ? SubStr(this.chars, (b3 & 63) + 1, 1) : "="

            i += 3
        }

        return result
    }

    static Decode(str) {
        result := ""
        str := StrReplace(str, "=", "")

        i := 1
        while i <= StrLen(str) {
            c1 := InStr(this.chars, SubStr(str, i, 1)) - 1
            c2 := InStr(this.chars, SubStr(str, i + 1, 1)) - 1
            c3 := i + 2 <= StrLen(str) ? InStr(this.chars, SubStr(str, i + 2, 1)) - 1 : 0
            c4 := i + 3 <= StrLen(str) ? InStr(this.chars, SubStr(str, i + 3, 1)) - 1 : 0

            result .= Chr((c1 << 2) | (c2 >> 4))
            if i + 2 <= StrLen(str)
                result .= Chr(((c2 & 15) << 4) | (c3 >> 2))
            if i + 3 <= StrLen(str)
                result .= Chr(((c3 & 3) << 6) | c4)

            i += 4
        }

        return result
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 82. LEVENSHTEIN DISTANCE ===
class StringDistance {
    static Levenshtein(s1, s2) {
        m := StrLen(s1)
        n := StrLen(s2)

        if m = 0
            return n
        if n = 0
            return m

        prev := []
        curr := []

        loop n + 1
            prev.Push(A_Index - 1)

        loop m {
            i := A_Index
            loop n + 1
                curr.Push(0)
            curr[1] := i

            loop n {
                j := A_Index
                cost := SubStr(s1, i, 1) = SubStr(s2, j, 1) ? 0 : 1
                curr[j + 1] := Min(
                    prev[j + 1] + 1,
                    curr[j] + 1,
                    prev[j] + cost
                )
            }

            prev := curr.Clone()
            curr := []
        }

        return prev[n + 1]
    }

    static Similarity(s1, s2) {
        maxLen := Max(StrLen(s1), StrLen(s2))
        if maxLen = 0
            return 1
        return 1 - this.Levenshtein(s1, s2) / maxLen
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 83. FUZZY MATCH ===
class FuzzyMatcher {
    static Match(pattern, str) {
        pattern := StrLower(pattern)
        str := StrLower(str)

        pIdx := 1
        sIdx := 1
        score := 0
        consecutive := 0

        while pIdx <= StrLen(pattern) && sIdx <= StrLen(str) {
            pChar := SubStr(pattern, pIdx, 1)
            sChar := SubStr(str, sIdx, 1)

            if pChar = sChar {
                score += 1 + consecutive
                consecutive++
                pIdx++
            } else {
                consecutive := 0
            }
            sIdx++
        }

        if pIdx > StrLen(pattern)
            return Map("match", true, "score", score)
        return Map("match", false, "score", 0)
    }

    static Search(pattern, items, key := "") {
        results := []

        for item in items {
            str := key ? item[key] : item
            result := this.Match(pattern, str)
            if result["match"]
                results.Push(Map("item", item, "score", result["score"]))
        }

        results.Sort((a, b) => b["score"] - a["score"])
        return results
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 84. TOKENIZER ===
class Tokenizer {
    __New(rules) => this.rules := rules

    Tokenize(input) {
        tokens := []
        pos := 1

        while pos <= StrLen(input) {
            matched := false

            for rule in this.rules {
                pattern := "^" rule["pattern"]
                if RegExMatch(SubStr(input, pos), pattern, &m) {
                    if rule["type"] != "whitespace"
                        tokens.Push(Map("type", rule["type"], "value", m[0]))
                    pos += StrLen(m[0])
                    matched := true
                    break
                }
            }

            if !matched
                throw Error("Unexpected character at position " pos)
        }

        return tokens
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 85. PARSER COMBINATOR ===
class Parser {
    __New(fn) => this.parse := fn

    static Literal(expected) {
        return Parser((input, pos) {
            if SubStr(input, pos, StrLen(expected)) = expected
                return Map("success", true, "value", expected, "pos", pos + StrLen(expected))
            return Map("success", false)
        })
    }

    static Regex(pattern) {
        return Parser((input, pos) {
            if RegExMatch(SubStr(input, pos), "^" pattern, &m)
                return Map("success", true, "value", m[0], "pos", pos + StrLen(m[0]))
            return Map("success", false)
        })
    }

    Then(other) {
        return Parser((input, pos) {
            r1 := this.parse(input, pos)
            if !r1["success"]
                return r1
            r2 := other.parse(input, r1["pos"])
            if !r2["success"]
                return r2
            return Map("success", true, "value", [r1["value"], r2["value"]], "pos", r2["pos"])
        })
    }

    Or(other) {
        return Parser((input, pos) {
            r1 := this.parse(input, pos)
            if r1["success"]
                return r1
            return other.parse(input, pos)
        })
    }

    Many() {
        return Parser((input, pos) {
            results := []
            loop {
                r := this.parse(input, pos)
                if !r["success"]
                    break
                results.Push(r["value"])
                pos := r["pos"]
            }
            return Map("success", true, "value", results, "pos", pos)
        })
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 86. CSV PARSER ===
class CSV {
    static Parse(text, delimiter := ",") {
        rows := []
        lines := StrSplit(text, "`n")

        for line in lines {
            line := Trim(line, "`r")
            if line = ""
                continue

            cells := []
            inQuotes := false
            cell := ""

            loop StrLen(line) {
                char := SubStr(line, A_Index, 1)

                if char = '"' {
                    inQuotes := !inQuotes
                } else if char = delimiter && !inQuotes {
                    cells.Push(cell)
                    cell := ""
                } else {
                    cell .= char
                }
            }
            cells.Push(cell)
            rows.Push(cells)
        }

        return rows
    }

    static Stringify(rows, delimiter := ",") {
        result := ""

        for row in rows {
            line := ""
            for i, cell in row {
                if i > 1
                    line .= delimiter
                if InStr(cell, delimiter) || InStr(cell, '"') || InStr(cell, "`n")
                    line .= '"' StrReplace(cell, '"', '""') '"'
                else
                    line .= cell
            }
            result .= line "`n"
        }

        return result
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 87. INI PARSER ===
class INI {
    static Parse(text) {
        result := Map()
        currentSection := ""

        for line in StrSplit(text, "`n") {
            line := Trim(line, " `t`r")

            if line = "" || SubStr(line, 1, 1) = ";"
                continue

            if RegExMatch(line, "^\[(.+)\]$", &m) {
                currentSection := m[1]
                result[currentSection] := Map()
            } else if RegExMatch(line, "^([^=]+)=(.*)$", &m) {
                key := Trim(m[1])
                value := Trim(m[2])
                if currentSection
                    result[currentSection][key] := value
            }
        }

        return result
    }

    static Stringify(data) {
        result := ""

        for section, values in data {
            result .= "[" section "]`n"
            for key, value in values
                result .= key "=" value "`n"
            result .= "`n"
        }

        return result
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 88. QUERY STRING ===
class QueryString {
    static Parse(str) {
        result := Map()
        str := LTrim(str, "?")

        if str = ""
            return result

        for pair in StrSplit(str, "&") {
            parts := StrSplit(pair, "=", , 2)
            key := this.Decode(parts[1])
            value := parts.Length > 1 ? this.Decode(parts[2]) : ""
            result[key] := value
        }

        return result
    }

    static Stringify(data) {
        parts := []
        for key, value in data
            parts.Push(this.Encode(key) "=" this.Encode(String(value)))

        result := ""
        for i, part in parts
            result .= (i > 1 ? "&" : "") part
        return result
    }

    static Encode(str) {
        result := ""
        loop StrLen(str) {
            char := SubStr(str, A_Index, 1)
            if RegExMatch(char, "[A-Za-z0-9_.~-]")
                result .= char
            else
                result .= "%" Format("{:02X}", Ord(char))
        }
        return result
    }

    static Decode(str) {
        while RegExMatch(str, "%([0-9A-Fa-f]{2})", &m)
            str := StrReplace(str, m[0], Chr(Integer("0x" m[1])))
        return str
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 89. PATH PARSER ===
class PathParser {
    static Parse(path) {
        path := StrReplace(path, "\", "/")

        result := Map()
        result["original"] := path

        if RegExMatch(path, "^([A-Za-z]:)", &m)
            result["root"] := m[1]
        else if SubStr(path, 1, 1) = "/"
            result["root"] := "/"
        else
            result["root"] := ""

        lastSlash := 0
        loop StrLen(path) {
            if SubStr(path, A_Index, 1) = "/"
                lastSlash := A_Index
        }

        if lastSlash {
            result["dir"] := SubStr(path, 1, lastSlash)
            result["base"] := SubStr(path, lastSlash + 1)
        } else {
            result["dir"] := ""
            result["base"] := path
        }

        lastDot := 0
        base := result["base"]
        loop StrLen(base) {
            if SubStr(base, A_Index, 1) = "."
                lastDot := A_Index
        }

        if lastDot > 1 {
            result["name"] := SubStr(base, 1, lastDot - 1)
            result["ext"] := SubStr(base, lastDot)
        } else {
            result["name"] := base
            result["ext"] := ""
        }

        return result
    }

    static Join(parts*) {
        result := ""
        for part in parts {
            if result && SubStr(result, -1) != "/" && SubStr(result, -1) != "\"
                result .= "/"
            result .= part
        }
        return result
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 90. URL PARSER ===
class URL {
    static Parse(url) {
        result := Map()

        if RegExMatch(url, "^([a-z]+)://", &m) {
            result["protocol"] := m[1]
            url := SubStr(url, StrLen(m[0]) + 1)
        }

        queryPos := InStr(url, "?")
        hashPos := InStr(url, "#")

        if hashPos {
            result["hash"] := SubStr(url, hashPos + 1)
            url := SubStr(url, 1, hashPos - 1)
        }

        if queryPos {
            result["query"] := SubStr(url, queryPos + 1)
            url := SubStr(url, 1, queryPos - 1)
        }

        slashPos := InStr(url, "/")
        if slashPos {
            result["path"] := SubStr(url, slashPos)
            url := SubStr(url, 1, slashPos - 1)
        } else {
            result["path"] := "/"
        }

        atPos := InStr(url, "@")
        if atPos {
            auth := SubStr(url, 1, atPos - 1)
            url := SubStr(url, atPos + 1)
            colonPos := InStr(auth, ":")
            if colonPos {
                result["username"] := SubStr(auth, 1, colonPos - 1)
                result["password"] := SubStr(auth, colonPos + 1)
            } else {
                result["username"] := auth
            }
        }

        colonPos := InStr(url, ":")
        if colonPos {
            result["host"] := SubStr(url, 1, colonPos - 1)
            result["port"] := SubStr(url, colonPos + 1)
        } else {
            result["host"] := url
        }

        return result
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 91. GLOB PATTERN ===
class Glob {
    static Match(pattern, str) {
        regex := this.ToRegex(pattern)
        return RegExMatch(str, regex)
    }

    static ToRegex(pattern) {
        regex := "^"
        i := 1

        while i <= StrLen(pattern) {
            char := SubStr(pattern, i, 1)

            switch char {
                case "*":
                    if SubStr(pattern, i, 2) = "**" {
                        regex .= ".*"
                        i++
                    } else {
                        regex .= "[^/]*"
                    }
                case "?":
                    regex .= "[^/]"
                case "[":
                    end := InStr(pattern, "]", , i)
                    if end {
                        regex .= SubStr(pattern, i, end - i + 1)
                        i := end
                    } else {
                        regex .= "\["
                    }
                case ".":
                    regex .= "\."
                default:
                    regex .= char
            }
            i++
        }

        return regex "$"
    }

    static Filter(pattern, items) {
        result := []
        for item in items
            if this.Match(pattern, item)
                result.Push(item)
        return result
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 92. SEMAPHORE ===
class Semaphore {
    __New(permits := 1) {
        this.permits := permits
        this.available := permits
        this.waiting := []
    }

    Acquire(callback := "") {
        if this.available > 0 {
            this.available--
            if callback
                callback()
            return true
        }

        if callback
            this.waiting.Push(callback)
        return false
    }

    Release() {
        this.available++

        if this.waiting.Length && this.available > 0 {
            callback := this.waiting.RemoveAt(1)
            this.available--
            callback()
        }
    }

    TryAcquire() {
        if this.available > 0 {
            this.available--
            return true
        }
        return false
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 93. MUTEX ===
class Mutex {
    __New() {
        this.locked := false
        this.waiting := []
    }

    Lock(callback := "") {
        if !this.locked {
            this.locked := true
            if callback
                callback()
            return true
        }

        if callback
            this.waiting.Push(callback)
        return false
    }

    Unlock() {
        if this.waiting.Length {
            callback := this.waiting.RemoveAt(1)
            callback()
        } else {
            this.locked := false
        }
    }

    TryLock() {
        if !this.locked {
            this.locked := true
            return true
        }
        return false
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 94. BARRIER ===
class Barrier {
    __New(count, callback := "") {
        this.count := count
        this.waiting := 0
        this.callback := callback
        this.waiters := []
    }

    Arrive(onRelease := "") {
        this.waiting++
        if onRelease
            this.waiters.Push(onRelease)

        if this.waiting >= this.count {
            if this.callback
                this.callback()

            for waiter in this.waiters
                waiter()

            this.Reset()
        }
    }

    Reset() {
        this.waiting := 0
        this.waiters := []
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 95. COUNTDOWN LATCH ===
class CountDownLatch {
    __New(count) {
        this.count := count
        this.callbacks := []
    }

    CountDown() {
        if this.count > 0 {
            this.count--
            if this.count = 0
                this.Release()
        }
    }

    Await(callback) {
        if this.count = 0
            callback()
        else
            this.callbacks.Push(callback)
    }

    Release() {
        for callback in this.callbacks
            callback()
        this.callbacks := []
    }

    GetCount() => this.count
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 96. READ-WRITE LOCK ===
class ReadWriteLock {
    __New() {
        this.readers := 0
        this.writer := false
        this.readWaiters := []
        this.writeWaiters := []
    }

    AcquireRead(callback := "") {
        if !this.writer && !this.writeWaiters.Length {
            this.readers++
            if callback
                callback()
            return true
        }

        if callback
            this.readWaiters.Push(callback)
        return false
    }

    ReleaseRead() {
        this.readers--
        if this.readers = 0 && this.writeWaiters.Length {
            this.writer := true
            callback := this.writeWaiters.RemoveAt(1)
            callback()
        }
    }

    AcquireWrite(callback := "") {
        if !this.writer && this.readers = 0 {
            this.writer := true
            if callback
                callback()
            return true
        }

        if callback
            this.writeWaiters.Push(callback)
        return false
    }

    ReleaseWrite() {
        this.writer := false

        while this.readWaiters.Length && !this.writeWaiters.Length {
            this.readers++
            callback := this.readWaiters.RemoveAt(1)
            callback()
        }

        if this.readers = 0 && this.writeWaiters.Length {
            this.writer := true
            callback := this.writeWaiters.RemoveAt(1)
            callback()
        }
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 97. ACTOR ===
class Actor {
    __New() {
        this.mailbox := []
        this.handlers := Map()
        this.processing := false
    }

    On(messageType, handler) => this.handlers[messageType] := handler

    Send(message) {
        this.mailbox.Push(message)
        if !this.processing
            this.Process()
    }

    Process() {
        this.processing := true

        while this.mailbox.Length {
            message := this.mailbox.RemoveAt(1)
            type := message.Has("type") ? message["type"] : ""

            if this.handlers.Has(type)
                this.handlers[type](message)
        }

        this.processing := false
    }
}

class ActorSystem {
    __New() => this.actors := Map()

    Register(name, actor) => this.actors[name] := actor

    Send(name, message) {
        if this.actors.Has(name)
            this.actors[name].Send(message)
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 98. CHANNEL ===
class Channel {
    __New(capacity := 0) {
        this.capacity := capacity
        this.buffer := []
        this.receivers := []
        this.senders := []
    }

    Send(value, callback := "") {
        if this.receivers.Length {
            receiver := this.receivers.RemoveAt(1)
            receiver(value)
            if callback
                callback()
            return true
        }

        if this.capacity = 0 || this.buffer.Length < this.capacity {
            this.buffer.Push(value)
            if callback
                callback()
            return true
        }

        if callback
            this.senders.Push(Map("value", value, "callback", callback))
        return false
    }

    Receive(callback) {
        if this.buffer.Length {
            value := this.buffer.RemoveAt(1)
            callback(value)

            if this.senders.Length {
                sender := this.senders.RemoveAt(1)
                this.buffer.Push(sender["value"])
                sender["callback"]()
            }
            return true
        }

        this.receivers.Push(callback)
        return false
    }

    Close() {
        for receiver in this.receivers
            receiver("")
        this.receivers := []
    }
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 99. RESOURCE POOL ===
class ResourcePool {
    __New(factory, validator := "", maxSize := 10) {
        this.factory := factory
        this.validator := validator
        this.maxSize := maxSize
        this.available := []
        this.inUse := 0
    }

    Acquire() {
        while this.available.Length {
            resource := this.available.Pop()
            if !this.validator || this.validator(resource) {
                this.inUse++
                return resource
            }
        }

        if this.inUse < this.maxSize {
            this.inUse++
            return this.factory()
        }

        return ""
    }

    Release(resource) {
        if this.available.Length < this.maxSize
            this.available.Push(resource)
        this.inUse--
    }

    Size() => this.available.Length + this.inUse
    Available() => this.available.Length
    InUse() => this.inUse
}
```
```cpp
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; === 100. HEALTH CHECK ===
class HealthChecker {
    __New() {
        this.checks := Map()
        this.results := Map()
    }

    Register(name, check) => this.checks[name] := check

    Run() {
        overall := "healthy"

        for name, check in this.checks {
            try {
                result := check()
                this.results[name] := Map(
                    "status", result ? "healthy" : "unhealthy",
                    "timestamp", A_Now
                )
                if !result
                    overall := "unhealthy"
            } catch as e {
                this.results[name] := Map(
                    "status", "error",
                    "error", e.Message,
                    "timestamp", A_Now
                )
                overall := "unhealthy"
            }
        }

        return Map("status", overall, "checks", this.results)
    }

    IsHealthy() => this.Run()["status"] = "healthy"
}
```
