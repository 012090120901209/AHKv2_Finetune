#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Dependency Injection - IoC containers and DI patterns
; Demonstrates advanced dependency injection in AHK v2

; =============================================================================
; 1. Simple DI Container
; =============================================================================

class Container {
    __New() {
        this._bindings := Map()
        this._singletons := Map()
        this._instances := Map()
    }
    
    ; Register transient binding
    Bind(abstract, concrete := "") {
        concrete := concrete || abstract
        this._bindings[abstract] := {
            resolver: concrete,
            singleton: false
        }
        return this
    }
    
    ; Register singleton binding
    Singleton(abstract, concrete := "") {
        concrete := concrete || abstract
        this._bindings[abstract] := {
            resolver: concrete,
            singleton: true
        }
        return this
    }
    
    ; Register instance
    Instance(abstract, instance) {
        this._instances[abstract] := instance
        return this
    }
    
    ; Register factory function
    Factory(abstract, factory, singleton := false) {
        this._bindings[abstract] := {
            resolver: factory,
            singleton: singleton,
            isFactory: true
        }
        return this
    }
    
    ; Resolve dependency
    Make(abstract, params := []) {
        ; Check instances first
        if this._instances.Has(abstract)
            return this._instances[abstract]
        
        ; Check singleton cache
        if this._singletons.Has(abstract)
            return this._singletons[abstract]
        
        ; Get binding
        if !this._bindings.Has(abstract)
            throw Error("No binding for: " abstract)
        
        binding := this._bindings[abstract]
        
        ; Resolve
        if binding.HasOwnProp("isFactory") && binding.isFactory {
            instance := binding.resolver(this, params*)
        } else if binding.resolver is Func {
            instance := binding.resolver(this, params*)
        } else {
            instance := this._build(binding.resolver, params)
        }
        
        ; Cache singleton
        if binding.singleton
            this._singletons[abstract] := instance
        
        return instance
    }
    
    _build(concrete, params) {
        ; If concrete is a class, instantiate it
        if concrete is Class
            return concrete(params*)
        
        ; If it's a string class name, try to resolve
        try {
            classObj := %concrete%
            return classObj(params*)
        }
        
        return concrete
    }
    
    ; Check if bound
    Has(abstract) {
        return this._bindings.Has(abstract) || this._instances.Has(abstract)
    }
    
    ; Get alias
    Alias(alias, abstract) {
        this._bindings[alias] := this._bindings[abstract]
        return this
    }
}

; =============================================================================
; 2. Auto-wiring Container
; =============================================================================

class AutoWireContainer extends Container {
    __New() {
        super.__New()
        this._typeHints := Map()  ; Store type hints for classes
    }
    
    ; Register type hints for a class
    WithDependencies(className, dependencies*) {
        this._typeHints[className] := dependencies
        return this
    }
    
    ; Override Make to support auto-wiring
    Make(abstract, params := []) {
        ; Try parent first
        if this._instances.Has(abstract) || this._singletons.Has(abstract)
            return super.Make(abstract, params)
        
        ; Auto-wire if we have type hints
        if this._typeHints.Has(abstract) {
            deps := []
            for depType in this._typeHints[abstract]
                deps.Push(this.Make(depType))
            
            ; Build with resolved dependencies
            return this._build(
                this._bindings.Has(abstract) ? this._bindings[abstract].resolver : abstract,
                deps
            )
        }
        
        return super.Make(abstract, params)
    }
}

; =============================================================================
; 3. Service Locator Pattern
; =============================================================================

class ServiceLocator {
    static _services := Map()
    
    static Register(name, service) {
        this._services[name] := service
    }
    
    static Get(name) {
        if !this._services.Has(name)
            throw Error("Service not registered: " name)
        return this._services[name]
    }
    
    static Has(name) => this._services.Has(name)
    
    static Remove(name) {
        if this._services.Has(name)
            this._services.Delete(name)
    }
    
    static Clear() => this._services := Map()
}

; =============================================================================
; 4. Contextual Binding
; =============================================================================

class ContextualContainer extends Container {
    __New() {
        super.__New()
        this._contextBindings := Map()
    }
    
    ; When building X, use Y for dependency Z
    When(concrete) {
        return ContextualBindingBuilder(this, concrete)
    }
    
    _addContextBinding(concrete, abstract, implementation) {
        key := concrete . ":" . abstract
        this._contextBindings[key] := implementation
    }
    
    ; Override Make to check context
    MakeFor(requestor, abstract) {
        key := requestor . ":" . abstract
        if this._contextBindings.Has(key)
            return this.Make(this._contextBindings[key])
        return this.Make(abstract)
    }
}

class ContextualBindingBuilder {
    __New(container, concrete) {
        this._container := container
        this._concrete := concrete
    }
    
    Needs(abstract) {
        this._abstract := abstract
        return this
    }
    
    Give(implementation) {
        this._container._addContextBinding(
            this._concrete,
            this._abstract,
            implementation
        )
        return this._container
    }
}

; =============================================================================
; 5. Tagged Services
; =============================================================================

class TaggedContainer extends Container {
    __New() {
        super.__New()
        this._tags := Map()
    }
    
    ; Tag a binding
    Tag(abstract, tags*) {
        for tag in tags {
            if !this._tags.Has(tag)
                this._tags[tag] := []
            this._tags[tag].Push(abstract)
        }
        return this
    }
    
    ; Get all services with tag
    Tagged(tag) {
        if !this._tags.Has(tag)
            return []
        
        services := []
        for abstract in this._tags[tag]
            services.Push(this.Make(abstract))
        return services
    }
    
    ; Chain with Tag
    BindTagged(abstract, concrete, tags*) {
        this.Bind(abstract, concrete)
        this.Tag(abstract, tags*)
        return this
    }
}

; =============================================================================
; 6. Scoped Container (Request Scope)
; =============================================================================

class ScopedContainer extends Container {
    __New(parent := "") {
        super.__New()
        this._parent := parent
        this._scopeId := A_TickCount . "_" . Random(1000, 9999)
    }
    
    ; Create child scope
    CreateScope() {
        return ScopedContainer(this)
    }
    
    ; Override Make to check parent
    Make(abstract, params := []) {
        ; Check local bindings first
        if this._bindings.Has(abstract) || this._instances.Has(abstract)
            return super.Make(abstract, params)
        
        ; Delegate to parent
        if this._parent
            return this._parent.Make(abstract, params)
        
        throw Error("No binding for: " abstract)
    }
    
    ScopeId => this._scopeId
}

; =============================================================================
; 7. Method Injection
; =============================================================================

class MethodInjector {
    __New(container) {
        this._container := container
        this._methodParams := Map()
    }
    
    ; Register method parameter types
    RegisterMethod(className, methodName, paramTypes*) {
        key := className . "." . methodName
        this._methodParams[key] := paramTypes
        return this
    }
    
    ; Call method with injected dependencies
    Call(obj, methodName, extraParams*) {
        key := Type(obj) . "." . methodName
        
        injectedParams := []
        
        if this._methodParams.Has(key) {
            for paramType in this._methodParams[key]
                injectedParams.Push(this._container.Make(paramType))
        }
        
        ; Append extra params
        for p in extraParams
            injectedParams.Push(p)
        
        return obj.%methodName%(injectedParams*)
    }
}

; =============================================================================
; 8. Decorator Pattern via Container
; =============================================================================

class DecoratingContainer extends Container {
    __New() {
        super.__New()
        this._decorators := Map()
    }
    
    ; Add decorator for a service
    Decorate(abstract, decorator) {
        if !this._decorators.Has(abstract)
            this._decorators[abstract] := []
        this._decorators[abstract].Push(decorator)
        return this
    }
    
    ; Override Make to apply decorators
    Make(abstract, params := []) {
        instance := super.Make(abstract, params)
        
        if this._decorators.Has(abstract) {
            for decorator in this._decorators[abstract]
                instance := decorator(instance, this)
        }
        
        return instance
    }
}

; =============================================================================
; 9. Example Services
; =============================================================================

; Interfaces (abstract concepts in AHK)
class ILogger {
    Log(message) => ""
}

class IDatabase {
    Query(sql) => ""
}

class ICache {
    Get(key) => ""
    Set(key, value) => ""
}

; Implementations
class ConsoleLogger extends ILogger {
    Log(message) {
        FileAppend("[LOG] " message "`n", "*")
        return true
    }
}

class FileLogger extends ILogger {
    __New(path := "app.log") {
        this.path := path
    }
    
    Log(message) {
        FileAppend(A_Now " - " message "`n", this.path)
        return true
    }
}

class MemoryDatabase extends IDatabase {
    __New() {
        this._data := Map()
    }
    
    Query(sql) => "Result for: " sql
}

class MemoryCache extends ICache {
    __New() {
        this._cache := Map()
    }
    
    Get(key) => this._cache.Get(key, "")
    Set(key, value) => this._cache[key] := value
}

; Service that depends on others
class UserService {
    __New(logger, database, cache := "") {
        this._logger := logger
        this._database := database
        this._cache := cache
    }
    
    GetUser(id) {
        this._logger.Log("Getting user: " id)
        return this._database.Query("SELECT * FROM users WHERE id=" id)
    }
}

; =============================================================================
; Demo
; =============================================================================

; Basic container usage
container := Container()

container
    .Bind("ILogger", ConsoleLogger)
    .Singleton("IDatabase", MemoryDatabase)
    .Instance("config", {appName: "MyApp", debug: true})

logger := container.Make("ILogger")
db := container.Make("IDatabase")
config := container.Make("config")

MsgBox("Basic DI Container:`n`n"
    . "Logger type: " Type(logger) "`n"
    . "DB type: " Type(db) "`n"
    . "Config.appName: " config.appName)

; Auto-wiring
awContainer := AutoWireContainer()

awContainer
    .Singleton("ILogger", ConsoleLogger)
    .Singleton("IDatabase", MemoryDatabase)
    .Bind("UserService", UserService)
    .WithDependencies("UserService", "ILogger", "IDatabase")

userService := awContainer.Make("UserService")
MsgBox("Auto-wired UserService:`n`n" userService.GetUser(123))

; Tagged services
tagContainer := TaggedContainer()

tagContainer
    .BindTagged("console_logger", ConsoleLogger, "logger", "reporting")
    .BindTagged("file_logger", () => FileLogger("test.log"), "logger", "audit")

loggers := tagContainer.Tagged("logger")
MsgBox("Tagged Services:`n`nFound " loggers.Length " services tagged 'logger'")

; Scoped container
rootContainer := ScopedContainer()
rootContainer.Singleton("IDatabase", MemoryDatabase)

scope1 := rootContainer.CreateScope()
scope1.Instance("requestId", "REQ-001")

scope2 := rootContainer.CreateScope()
scope2.Instance("requestId", "REQ-002")

MsgBox("Scoped Containers:`n`n"
    . "Root scope: " rootContainer.ScopeId "`n"
    . "Scope 1 ID: " scope1.Make("requestId") "`n"
    . "Scope 2 ID: " scope2.Make("requestId"))

; Decorating container
decContainer := DecoratingContainer()

decContainer.Bind("ILogger", ConsoleLogger)
decContainer.Decorate("ILogger", (logger, c) => {
    base: logger,
    Log: (msg) => (
        ; Add timestamp prefix
        logger.Log("[" A_Now "] " msg)
    )
})

decoratedLogger := decContainer.Make("ILogger")
MsgBox("Decorated Logger:`n`nDecorator added timestamp prefix")
decoratedLogger.Log("Test message")

; Service locator (anti-pattern but sometimes useful)
ServiceLocator.Register("logger", ConsoleLogger())
ServiceLocator.Register("cache", MemoryCache())

if ServiceLocator.Has("logger") {
    sl_logger := ServiceLocator.Get("logger")
    MsgBox("Service Locator:`n`nLogger retrieved successfully")
}
ServiceLocator.Clear()
