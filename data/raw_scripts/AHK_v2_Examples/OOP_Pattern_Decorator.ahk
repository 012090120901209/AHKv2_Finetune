#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP Pattern: Decorator Pattern
; Demonstrates: Dynamic behavior addition, composition over inheritance

class Coffee {
    Cost() => 2.00
    Description() => "Coffee"
}

class CoffeeDecorator extends Coffee {
    __New(coffee) => this.coffee := coffee
    Cost() => this.coffee.Cost()
    Description() => this.coffee.Description()
}

class MilkDecorator extends CoffeeDecorator {
    Cost() => super.Cost() + 0.50
    Description() => super.Description() " + Milk"
}

class SugarDecorator extends CoffeeDecorator {
    Cost() => super.Cost() + 0.25
    Description() => super.Description() " + Sugar"
}

class CaramelDecorator extends CoffeeDecorator {
    Cost() => super.Cost() + 0.75
    Description() => super.Description() " + Caramel"
}

class WhippedCreamDecorator extends CoffeeDecorator {
    Cost() => super.Cost() + 1.00
    Description() => super.Description() " + Whipped Cream"
}

; Elegant composition
coffee := Coffee()
coffee := MilkDecorator(coffee)
coffee := SugarDecorator(coffee)
coffee := CaramelDecorator(coffee)
coffee := WhippedCreamDecorator(coffee)

MsgBox(Format("{}`nTotal: ${:.2f}", coffee.Description(), coffee.Cost()))

; One-liner version
fancyCoffee := WhippedCreamDecorator(CaramelDecorator(MilkDecorator(Coffee())))
MsgBox(Format("{}`nTotal: ${:.2f}", fancyCoffee.Description(), fancyCoffee.Cost()))
