#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Decorator Pattern
; Demonstrates: Dynamic behavior addition, composition over inheritance

class Coffee {
    Cost() => 2.00
    Description() => "Coffee"
}

class CoffeeDecorator extends Coffee {
    __New(coffee) => this.coffeeobj := coffee
    Cost() => this.coffeeobj .Cost()
    Description() => this.coffeeobj .Description()
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
coffeeobj := Coffee.New()
coffeeobj := MilkDecorator.New(coffee)
coffeeobj := SugarDecorator.New(coffee)
coffeeobj := CaramelDecorator.New(coffee)
coffeeobj := WhippedCreamDecorator.New(coffee)

MsgBox(Format("{}`nTotal: ${:.2f}", coffeeobj .Description(), coffeeobj .Cost()))

; One-liner version
fancyCoffee := WhippedCreamDecorator.New(CaramelDecorator.New(MilkDecorator.New(Coffee.New())))
MsgBox(Format("{}`nTotal: ${:.2f}", fancyCoffee.Description(), fancyCoffee.Cost()))
