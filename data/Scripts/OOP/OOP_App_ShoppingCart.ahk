#Requires AutoHotkey v2.0
#SingleInstance Force
; Real-world OOP Application: Shopping Cart System
; Demonstrates: E-commerce logic, discounts, order processing

class Product {
    __New(id, name, price, category) => (this.id := id, this.name := name, this.price := price, this.category := category, this.stock := 0)

    SetStock(quantity) => (this.stock := quantity, this)
    InStock() => this.stock > 0
    ToString() => Format("{1} - ${2:.2f} ({3} in stock)", this.name, this.price, this.stock)
}

class CartItem {
    __New(product, quantity) => (this.product := product, this.quantity := quantity)

    GetSubtotal() => this.product.price * this.quantity
    ToString() => Format("{1} x{2} = ${3:.2f}", this.product.name, this.quantity, this.GetSubtotal())
}

class Discount {
    Apply(amount) => amount
}

class PercentageDiscount extends Discount {
    __New(percent, description) => (this.percent := percent, this.description := description)
    Apply(amount) => amount * (1 - this.percent / 100)
    ToString() => Format("{1} ({2}% off)", this.description, this.percent)
}

class FixedDiscount extends Discount {
    __New(amount, description) => (this.amount := amount, this.description := description)
    Apply(amount) => Max(0, amount - this.amount)
    ToString() => Format("{1} (${2:.2f} off)", this.description, this.amount)
}

class ShoppingCart {
    __New() => (this.items := [], this.discounts := [])

    AddItem(product, quantity := 1) {
        if (quantity > product.stock)
        return MsgBox("Not enough stock! Only " product.stock " available.", "Error")

        ; Check if product already in cart
        for item in this.items {
            if (item.product.id = product.id) {
                item.quantity += quantity
                return this
            }
        }

        this.items.Push(CartItem(product, quantity))
        return this
    }

    RemoveItem(productId) {
        for index, item in this.items {
            if (item.product.id = productId) {
                this.items.RemoveAt(index)
                return this
            }
        }
        return this
    }

    UpdateQuantity(productId, quantity) {
        for item in this.items {
            if (item.product.id = productId) {
                item.quantity := quantity
                return this
            }
        }
        return this
    }

    ApplyDiscount(discount) => (this.discounts.Push(discount), this)

    GetSubtotal() {
        total := 0
        for item in this.items
        total += item.GetSubtotal()
        return total
    }

    GetTotal() {
        total := this.GetSubtotal()
        for discount in this.discounts
        total := discount.Apply(total)
        return total
    }

    GetItemCount() {
        count := 0
        for item in this.items
        count += item.quantity
        return count
    }

    GetSummary() {
        summary := "Shopping Cart`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        for item in this.items
        summary .= item.ToString() "`n"

        summary .= "`nSubtotal: $" . Format("{:.2f}", this.GetSubtotal())

        if (this.discounts.Length > 0) {
            summary .= "`n`nDiscounts:"
            for discount in this.discounts
            summary .= "`n  - " . discount.ToString()
        }

        summary .= "`n`nTotal: $" . Format("{:.2f}", this.GetTotal())
        summary .= "`nItems: " . this.GetItemCount()

        return summary
    }

    Checkout() {
        ; Validate stock
        for item in this.items {
            if (item.quantity > item.product.stock)
            return MsgBox("Checkout failed: " . item.product.name . " out of stock!", "Error")
        }

        ; Update stock
        for item in this.items
        item.product.stock -= item.quantity

        order := Order(this)
        this.Clear()
        return order
    }

    Clear() => (this.items := [], this.discounts := [], this)
}

class Order {
    static nextOrderId := 1000

    __New(cart) {
        this.orderId := Order.nextOrderId++
        this.items := cart.items.Clone()
        this.total := cart.GetTotal()
        this.createdAt := A_Now
    }

    ToString() => Format("Order #{1}`nDate: {2}`nTotal: ${3:.2f}`nItems: {4}",
    this.orderId,
    FormatTime(this.createdAt, "yyyy-MM-dd HH:mm"),
    this.total,
    this.items.Length)
}

; Usage - complete shopping cart system
catalog := [
Product("P001", "Laptop", 999.99, "Electronics").SetStock(5),
Product("P002", "Mouse", 29.99, "Electronics").SetStock(20),
Product("P003", "Keyboard", 79.99, "Electronics").SetStock(15),
Product("P004", "Monitor", 299.99, "Electronics").SetStock(8),
Product("P005", "USB Cable", 9.99, "Accessories").SetStock(50)
]

cart := ShoppingCart()

; Add items to cart
cart.AddItem(catalog[1], 1)  ; Laptop
cart.AddItem(catalog[2], 2)  ; 2 Mice
cart.AddItem(catalog[3], 1)  ; Keyboard

MsgBox(cart.GetSummary())

; Apply discounts
cart.ApplyDiscount(PercentageDiscount(10, "First Purchase"))
cart.ApplyDiscount(FixedDiscount(50, "Loyalty Reward"))

MsgBox(cart.GetSummary())

; Checkout
order := cart.Checkout()
MsgBox(order.ToString() "`n`nOrder complete!")

; Show updated stock
MsgBox("Updated Stock:`n" . catalog[1].ToString() . "`n" . catalog[2].ToString() . "`n" . catalog[3].ToString())
