#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Saga Pattern - Distributed transaction coordination
; Demonstrates compensating transactions

class Saga {
    __New() {
        this.steps := []
        this.completed := []
        this.context := Map()
        this.logs := []
    }

    ; Add a step with its compensation action
    AddStep(name, action, compensation) {
        this.steps.Push(Map(
            "name", name,
            "action", action,
            "compensation", compensation
        ))
        return this
    }

    Execute() {
        this.completed := []
        this.logs := []
        
        for step in this.steps {
            this._log("Executing: " step["name"])
            
            try {
                result := step["action"](this.context)
                this.context["_last"] := result
                this.completed.Push(step)
                this._log("  Success: " step["name"])
            } catch Error as e {
                this._log("  Failed: " step["name"] " - " e.Message)
                this._compensate()
                
                return Map(
                    "success", false,
                    "failedStep", step["name"],
                    "error", e.Message,
                    "logs", this.logs
                )
            }
        }

        return Map(
            "success", true,
            "context", this.context,
            "logs", this.logs
        )
    }

    _compensate() {
        this._log("Starting compensation...")
        
        ; Execute compensations in reverse order
        i := this.completed.Length
        while i >= 1 {
            step := this.completed[i]
            this._log("  Compensating: " step["name"])
            
            try {
                step["compensation"](this.context)
                this._log("    Compensated: " step["name"])
            } catch Error as e {
                this._log("    Compensation failed: " e.Message)
            }
            i--
        }
    }

    _log(message) {
        this.logs.Push(message)
    }
}

; Choreography-based saga (event-driven)
class SagaOrchestrator {
    __New() {
        this.sagas := Map()
        this.eventHandlers := Map()
    }

    RegisterSaga(name, saga) {
        this.sagas[name] := saga
        return this
    }

    On(event, handler) {
        if !this.eventHandlers.Has(event)
            this.eventHandlers[event] := []
        this.eventHandlers[event].Push(handler)
        return this
    }

    Emit(event, data := "") {
        if this.eventHandlers.Has(event) {
            for handler in this.eventHandlers[event]
                handler(data)
        }
    }

    Run(name, context := "") {
        if !this.sagas.Has(name)
            throw Error("Saga not found: " name)
        
        saga := this.sagas[name]
        if context {
            for key, value in context
                saga.context[key] := value
        }
        
        return saga.Execute()
    }
}

; Demo - Order Processing Saga
orderSaga := Saga()

; Step 1: Reserve inventory
orderSaga.AddStep(
    "ReserveInventory",
    ReserveInventoryAction,
    ReserveInventoryCompensate
)

ReserveInventoryAction(ctx) {
    ; Simulate inventory check
    if !ctx.Has("productId")
        throw Error("Product ID required")
    
    ctx["reserved"] := true
    return "Reserved item #" ctx["productId"]
}

ReserveInventoryCompensate(ctx) {
    ; Compensate: Release reservation
    ctx["reserved"] := false
}

; Step 2: Process payment
orderSaga.AddStep(
    "ProcessPayment",
    ProcessPaymentAction,
    ProcessPaymentCompensate
)

ProcessPaymentAction(ctx) {
    if !ctx.Has("amount")
        throw Error("Amount required")
    
    ; Simulate payment (fails for amounts > 1000)
    if ctx["amount"] > 1000
        throw Error("Payment declined")
    
    ctx["paymentId"] := "PAY-" Random(1000, 9999)
    return "Payment processed: " ctx["paymentId"]
}

ProcessPaymentCompensate(ctx) {
    ; Compensate: Refund payment
    ctx.Delete("paymentId")
}

; Step 3: Create shipment
orderSaga.AddStep(
    "CreateShipment",
    CreateShipmentAction,
    CreateShipmentCompensate
)

CreateShipmentAction(ctx) {
    ctx["trackingNumber"] := "TRACK-" Random(100000, 999999)
    return "Shipment created: " ctx["trackingNumber"]
}

CreateShipmentCompensate(ctx) {
    ; Compensate: Cancel shipment
    ctx.Delete("trackingNumber")
}

; Test successful saga
orderSaga.context["productId"] := 42
orderSaga.context["amount"] := 99

result := orderSaga.Execute()

output := "Saga Pattern Demo - Order Processing:`n`n"
output .= "=== Successful Order ===`n"
for log in result["logs"]
    output .= log "`n"
output .= "`nResult: " (result["success"] ? "SUCCESS" : "FAILED") "`n"

MsgBox(output)

; Test failing saga (payment declined)
orderSaga2 := Saga()

orderSaga2.AddStep("ReserveInventory", FailingSagaReserve, FailingSagaReserveComp)
orderSaga2.AddStep("ProcessPayment", FailingSagaPayment, FailingSagaPaymentComp)
orderSaga2.AddStep("CreateShipment", FailingSagaShipment, FailingSagaShipmentComp)

FailingSagaReserve(ctx) {
    ctx["reserved"] := true
    return "Reserved"
}

FailingSagaReserveComp(ctx) {
    ctx["reserved"] := false
}

FailingSagaPayment(ctx) {
    throw Error("Insufficient funds")
}

FailingSagaPaymentComp(ctx) {
}

FailingSagaShipment(ctx) {
    ctx["shipped"] := true
}

FailingSagaShipmentComp(ctx) {
    ctx["shipped"] := false
}

orderSaga2.context["productId"] := 100

result := orderSaga2.Execute()

output := "=== Failed Order (Payment Declined) ===`n`n"
for log in result["logs"]
    output .= log "`n"
output .= "`nResult: " (result["success"] ? "SUCCESS" : "FAILED") "`n"
output .= "Failed step: " result["failedStep"] "`n"
output .= "Error: " result["error"]

MsgBox(output)

; Demo - Travel Booking Saga
travelSaga := Saga()

travelSaga.AddStep("BookFlight", BookFlightAction, BookFlightComp)
travelSaga.AddStep("BookHotel", BookHotelAction, BookHotelComp)
travelSaga.AddStep("BookCar", BookCarAction, BookCarComp)

BookFlightAction(ctx) {
    ctx["flightBooked"] := true
    ctx["flightRef"] := "FL-" Random(1000, 9999)
    return ctx["flightRef"]
}

BookFlightComp(ctx) {
    ctx["flightBooked"] := false
    ctx.Delete("flightRef")
}

BookHotelAction(ctx) {
    ctx["hotelBooked"] := true
    ctx["hotelRef"] := "HT-" Random(1000, 9999)
    return ctx["hotelRef"]
}

BookHotelComp(ctx) {
    ctx["hotelBooked"] := false
    ctx.Delete("hotelRef")
}

BookCarAction(ctx) {
    ; Simulate failure
    if ctx.Has("failCar") && ctx["failCar"]
        throw Error("No cars available")
    
    ctx["carBooked"] := true
    ctx["carRef"] := "CR-" Random(1000, 9999)
    return ctx["carRef"]
}

BookCarComp(ctx) {
    ctx["carBooked"] := false
    ctx.Delete("carRef")
}

; Success case
travelSaga.context := Map("failCar", false)
result := travelSaga.Execute()

output := "Travel Booking Saga:`n`n"
output .= "=== Successful Booking ===`n"
for log in result["logs"]
    output .= log "`n"
output .= "`nBooking refs: Flight=" result["context"]["flightRef"]
output .= ", Hotel=" result["context"]["hotelRef"]
output .= ", Car=" result["context"]["carRef"]

MsgBox(output)

; Failure case - car unavailable
travelSaga2 := Saga()

travelSaga2.AddStep("BookFlight", TravelFailFlightAction, TravelFailFlightComp)
travelSaga2.AddStep("BookHotel", TravelFailHotelAction, TravelFailHotelComp)
travelSaga2.AddStep("BookCar", TravelFailCarAction, TravelFailCarComp)

TravelFailFlightAction(ctx) {
    ctx["flightRef"] := "FL-123"
}

TravelFailFlightComp(ctx) {
    ctx.Delete("flightRef")
}

TravelFailHotelAction(ctx) {
    ctx["hotelRef"] := "HT-456"
}

TravelFailHotelComp(ctx) {
    ctx.Delete("hotelRef")
}

TravelFailCarAction(ctx) {
    throw Error("No cars available")
}

TravelFailCarComp(ctx) {
}

result := travelSaga2.Execute()

output := "`n=== Failed Booking (No Cars) ===`n"
for log in result["logs"]
    output .= log "`n"
output .= "`nAll previous bookings compensated!"

MsgBox(output)
