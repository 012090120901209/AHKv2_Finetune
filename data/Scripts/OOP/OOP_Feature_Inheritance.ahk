#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Feature: Multi-level Inheritance with Super Calls
; Demonstrates: Inheritance chain, super keyword, constructor chaining

class Vehicle {
    __New(brand, year) => (this.brand := brand, this.year := year)

    Start() => MsgBox(this.brand " (" this.year "): Engine starting...")
    Stop() => MsgBox(this.brand ": Engine stopped")
    GetInfo() => Format("{} ({})", this.brand, this.year)
}

class Car extends Vehicle {
    __New(brand, year, doors) => (super.__New(brand, year), this.doors := doors)

    Start() {
        super.Start()
        MsgBox("Car: All " this.doors " doors locked")
    }

    GetInfo() => super.GetInfo() " - " this.doors " doors"
}

class ElectricCar extends Car {
    __New(brand, year, doors, batteryCapacity) => (super.__New(brand, year, doors), this.battery := batteryCapacity, this.charge := 100)

    Start() {
        if (this.charge < 20)
        return MsgBox("Warning: Low battery (" this.charge "%)!", "Warning")
        super.Start()
        MsgBox("Electric Car: Battery at " this.charge "%")
    }

    Charge() => (this.charge := 100, MsgBox("Battery fully charged!"))
    GetInfo() => super.GetInfo() " - " this.battery "kWh battery (" this.charge "%)"
}

; Demonstrate inheritance chain
regularCar := Car("Toyota", 2020, 4)
regularCar.Start()
MsgBox(regularCar.GetInfo())

electricCar := ElectricCar("Tesla", 2024, 4, 75)
electricCar.charge := 15  ; Set low charge
electricCar.Start()
electricCar.Charge()
electricCar.Start()
MsgBox(electricCar.GetInfo())
