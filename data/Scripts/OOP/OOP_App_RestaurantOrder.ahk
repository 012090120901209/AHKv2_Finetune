#Requires AutoHotkey v2.0
#SingleInstance Force
; Real-world OOP Application: Restaurant Order System
; Demonstrates: Menu management, order processing, kitchen workflow

class MenuItem {
    __New(id, name, price, category, prepTime) {
        this.id := id
        this.name := name
        this.price := price
        this.category := category
        this.prepTime := prepTime  ; minutes
        this.available := true
    }

    ToString() => Format("{1} - ${2:.2f} ({3}, {4} min)", this.name, this.price, this.category, this.prepTime)
}

class OrderItem {
    __New(menuItem, quantity, specialInstructions := "") {
        this.menuItem := menuItem
        this.quantity := quantity
        this.specialInstructions := specialInstructions
    }

    GetSubtotal() => this.menuItem.price * this.quantity

    ToString() => Format("{1} x{2} = ${3:.2f}{4}",
        this.menuItem.name,
        this.quantity,
        this.GetSubtotal(),
        this.specialInstructions ? " (" . this.specialInstructions . ")" : "")
}

class Order {
    static nextOrderId := 1
    static STATUS_PENDING := "PENDING"
    static STATUS_PREPARING := "PREPARING"
    static STATUS_READY := "READY"
    static STATUS_DELIVERED := "DELIVERED"
    static STATUS_CANCELLED := "CANCELLED"

    __New(tableNumber, waiter) {
        this.orderId := Order.nextOrderId++
        this.tableNumber := tableNumber
        this.waiter := waiter
        this.items := []
        this.status := Order.STATUS_PENDING
        this.createdAt := A_Now
        this.tip := 0
    }

    AddItem(menuItem, quantity := 1, specialInstructions := "") {
        this.items.Push(OrderItem(menuItem, quantity, specialInstructions))
        return this
    }

    RemoveItem(index) => (this.items.RemoveAt(index), this)

    GetSubtotal() {
        total := 0
        for item in this.items
            total += item.GetSubtotal()
        return total
    }

    GetTax(rate := 8.5) => this.GetSubtotal() * (rate / 100)

    GetTotal() => this.GetSubtotal() + this.GetTax() + this.tip

    SetTip(amount) => (this.tip := amount, this)

    GetEstimatedPrepTime() {
        maxTime := 0
        for item in this.items
            if (item.menuItem.prepTime > maxTime)
                maxTime := item.menuItem.prepTime
        return maxTime
    }

    SendToKitchen() => (this.status := Order.STATUS_PREPARING, this)
    MarkReady() => (this.status := Order.STATUS_READY, this)
    MarkDelivered() => (this.status := Order.STATUS_DELIVERED, this)
    Cancel() => (this.status := Order.STATUS_CANCELLED, this)

    GetReceipt() {
        receipt := Format("Order #{1} - Table {2}`n", this.orderId, this.tableNumber)
        receipt .= Format("Waiter: {1}`n", this.waiter)
        receipt .= Format("Time: {1}`n", FormatTime(this.createdAt, "HH:mm"))
        receipt .= "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"

        for item in this.items
            receipt .= item.ToString() . "`n"

        receipt .= "`nSubtotal: $" . Format("{:.2f}", this.GetSubtotal())
        receipt .= "`nTax: $" . Format("{:.2f}", this.GetTax())
        if (this.tip > 0)
            receipt .= "`nTip: $" . Format("{:.2f}", this.tip)
        receipt .= "`n" . "-" . "-" . "-" . "-" . "-" . "-" . "-" . "-" . "-" . "-" . "-" . "-" . "`n"
        receipt .= "TOTAL: $" . Format("{:.2f}", this.GetTotal())
        receipt .= "`n`nStatus: " . this.status

        return receipt
    }
}

class Menu {
    __New() => this.items := Map()

    AddItem(item) => (this.items[item.id] := item, this)

    GetItem(id) => this.items.Has(id) ? this.items[id] : ""

    GetItemsByCategory(category) {
        filtered := []
        for id, item in this.items
            if (item.category = category && item.available)
                filtered.Push(item)
        return filtered
    }

    GetCategories() {
        categories := Map()
        for id, item in this.items
            categories[item.category] := true
        result := []
        for cat in categories
            result.Push(cat)
        return result
    }

    ToString() {
        menu := "MENU`n" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        for category in this.GetCategories() {
            menu .= "`n" . category . ":`n"
            for item in this.GetItemsByCategory(category)
                menu .= "  " . item.ToString() . "`n"
        }
        return menu
    }
}

class Restaurant {
    __New(name) => (this.name := name, this.menu := Menu(), this.orders := [], this.tables := Map())

    AddMenuItem(item) => (this.menu.AddItem(item), this)

    CreateOrder(tableNumber, waiter) {
        order := Order(tableNumber, waiter)
        this.orders.Push(order)
        return order
    }

    GetActiveOrders() {
        active := []
        for order in this.orders
            if (order.status != Order.STATUS_DELIVERED && order.status != Order.STATUS_CANCELLED)
                active.Push(order)
        return active
    }

    GetKitchenQueue() {
        queue := []
        for order in this.orders
            if (order.status = Order.STATUS_PREPARING)
                queue.Push(order)
        return queue
    }

    GetOrdersByStatus(status) {
        filtered := []
        for order in this.orders
            if (order.status = status)
                filtered.Push(order)
        return filtered
    }

    GetDailySales() {
        total := 0
        for order in this.orders
            if (order.status = Order.STATUS_DELIVERED)
                total += order.GetTotal()
        return total
    }

    GetRestaurantSummary() {
        summary := this.name . "`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        summary .= Format("Total orders: {1}`n", this.orders.Length)
        summary .= Format("Active orders: {1}`n", this.GetActiveOrders().Length)
        summary .= Format("Kitchen queue: {1}`n", this.GetKitchenQueue().Length)
        summary .= Format("Completed today: {1}`n", this.GetOrdersByStatus(Order.STATUS_DELIVERED).Length)
        summary .= Format("Daily sales: ${:.2f}`n", this.GetDailySales())
        return summary
    }
}

; Usage - complete restaurant system
restaurant := Restaurant("Bella Italia")

; Build menu
restaurant
    .AddMenuItem(MenuItem("APP1", "Bruschetta", 8.99, "Appetizers", 10))
    .AddMenuItem(MenuItem("APP2", "Calamari", 12.99, "Appetizers", 12))
    .AddMenuItem(MenuItem("MAIN1", "Spaghetti Carbonara", 16.99, "Main Course", 20))
    .AddMenuItem(MenuItem("MAIN2", "Margherita Pizza", 14.99, "Main Course", 15))
    .AddMenuItem(MenuItem("MAIN3", "Chicken Parmesan", 18.99, "Main Course", 25))
    .AddMenuItem(MenuItem("DRINK1", "House Wine", 7.99, "Beverages", 2))
    .AddMenuItem(MenuItem("DRINK2", "Sparkling Water", 3.99, "Beverages", 1))
    .AddMenuItem(MenuItem("DESS1", "Tiramisu", 7.99, "Desserts", 5))

MsgBox(restaurant.menu.ToString())

; Create orders
order1 := restaurant.CreateOrder(5, "Maria")
order1.AddItem(restaurant.menu.GetItem("APP1"), 2)
order1.AddItem(restaurant.menu.GetItem("MAIN2"), 1, "Extra cheese")
order1.AddItem(restaurant.menu.GetItem("DRINK1"), 2)

order2 := restaurant.CreateOrder(3, "Carlos")
order2.AddItem(restaurant.menu.GetItem("MAIN1"), 1)
order2.AddItem(restaurant.menu.GetItem("MAIN3"), 1, "No sauce")
order2.AddItem(restaurant.menu.GetItem("DRINK2"), 2)
order2.AddItem(restaurant.menu.GetItem("DESS1"), 2)

; Show order details
MsgBox(order1.GetReceipt())
MsgBox("Estimated prep time: " . order1.GetEstimatedPrepTime() . " minutes")

; Send to kitchen
order1.SendToKitchen()
order2.SendToKitchen()

MsgBox("Kitchen Queue:`n" . restaurant.GetKitchenQueue().Map((o) => Format("Order #{1} (Table {2}) - {3} items", o.orderId, o.tableNumber, o.items.Length)).Join("`n"))

; Complete orders
order1.MarkReady()
order1.MarkDelivered()
order1.SetTip(5.00)

order2.MarkReady()
order2.MarkDelivered()
order2.SetTip(8.00)

; Final receipts
MsgBox(order1.GetReceipt())
MsgBox(order2.GetReceipt())

; Restaurant summary
MsgBox(restaurant.GetRestaurantSummary())
