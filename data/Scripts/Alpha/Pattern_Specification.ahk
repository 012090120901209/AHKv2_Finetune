#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Specification Pattern - Business rules as combinable predicates
; Demonstrates composable validation with And/Or/Not operators

class Spec {
    And(other) => AndSpec(this, other)
    Or(other) => OrSpec(this, other)
    Not() => NotSpec(this)
    IsSatisfied(item) => false
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

; Concrete specifications
class MinPrice extends Spec {
    __New(min) => this.min := min
    IsSatisfied(item) => item["price"] >= this.min
}

class MaxPrice extends Spec {
    __New(max) => this.max := max
    IsSatisfied(item) => item["price"] <= this.max
}

class InStock extends Spec {
    IsSatisfied(item) => item["stock"] > 0
}

class Category extends Spec {
    __New(cat) => this.cat := cat
    IsSatisfied(item) => item["category"] = this.cat
}

; Demo
products := [
    Map("name", "Laptop", "price", 999, "stock", 5, "category", "electronics"),
    Map("name", "Book", "price", 20, "stock", 0, "category", "books"),
    Map("name", "Phone", "price", 599, "stock", 10, "category", "electronics"),
    Map("name", "Desk", "price", 150, "stock", 3, "category", "furniture")
]

; Compose specification: electronics under $800 in stock
productSpec := Category("electronics")
    .And(MaxPrice(800))
    .And(InStock())

result := "Matching products:`n"
for product in products
    if productSpec.IsSatisfied(product)
        result .= product["name"] " - $" product["price"] "`n"

MsgBox(result)
