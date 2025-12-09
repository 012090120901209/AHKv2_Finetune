#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Service Locator Pattern - Central registry for service lookup
; Demonstrates dependency resolution through global registry

class ServiceLocator {
    static services := Map()
    static factories := Map()

    static Register(name, service) {
        this.services[name] := service
        return this
    }
    
    static RegisterFactory(name, factory) {
        this.factories[name] := factory
        return this
    }

    static Get(name) {
        ; Check cached instances first
        if this.services.Has(name)
            return this.services[name]
        
        ; Try factory
        if this.factories.Has(name) {
            instance := this.factories[name]()
            this.services[name] := instance
            return instance
        }
        
        throw Error("Service not found: " name)
    }
    
    static Has(name) => this.services.Has(name) || this.factories.Has(name)
    
    static Clear() {
        this.services := Map()
        this.factories := Map()
    }
}

; Services
class EmailService {
    Send(to, msg) => "Email sent to " to ": " msg
}

class SmsService {
    Send(to, msg) => "SMS to " to ": " msg
}

class NotificationService {
    __New() {
        this.email := ServiceLocator.Get("email")
        this.sms := ServiceLocator.Get("sms")
    }
    
    NotifyAll(to, msg) {
        return this.email.Send(to, msg) "`n" this.sms.Send(to, msg)
    }
}

; Demo - register services
ServiceLocator.Register("email", EmailService())
ServiceLocator.Register("sms", SmsService())
ServiceLocator.RegisterFactory("notifications", () => NotificationService())

; Use services
notifications := ServiceLocator.Get("notifications")
result := notifications.NotifyAll("user@example.com", "Hello!")

MsgBox(result)
