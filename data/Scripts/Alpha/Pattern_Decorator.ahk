#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Decorator Pattern - Adds behavior to objects dynamically
; Demonstrates composition over inheritance for extending functionality

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

class WhipDecorator {
    __New(beverage) => this.beverage := beverage
    Cost() => this.beverage.Cost() + 3
    Description() => this.beverage.Description() . " + Whip"
}

; Demo - stack decorators
drink := WhipDecorator(SugarDecorator(MilkDecorator(Coffee())))
MsgBox(drink.Description() "`nTotal: $" drink.Cost())
