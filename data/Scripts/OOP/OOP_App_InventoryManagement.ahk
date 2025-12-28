#Requires AutoHotkey v2.0
#SingleInstance Force
; Real-world OOP Application: Inventory Management System
; Demonstrates: Stock tracking, suppliers, reordering, warehouse management

class Product {
    static nextProductId := 1

    __New(name, sku, price, reorderPoint, reorderQuantity) {
        this.productId := Product.nextProductId++
        this.name := name
        this.sku := sku
        this.price := price
        this.reorderPoint := reorderPoint
        this.reorderQuantity := reorderQuantity
        this.stockLevel := 0
        this.supplier := ""
    }

    SetSupplier(supplier) => (this.supplier := supplier, this)
    NeedsReorder() => this.stockLevel <= this.reorderPoint
    ToString() => Format("{1} (SKU: {2}) - Stock: {3} | ${4:.2f}", this.name, this.sku, this.stockLevel, this.price)
}

class Supplier {
    static nextSupplierId := 1

    __New(name, contact, email) {
        this.supplierId := Supplier.nextSupplierId++
        this.name := name
        this.contact := contact
        this.email := email
        this.products := []
    }

    AddProduct(product) => (this.products.Push(product), product.SetSupplier(this), this)
    ToString() => Format("{1} - {2} ({3}) | {4} products", this.name, this.contact, this.email, this.products.Length)
}

class StockMovement {
    static TYPE_IN := "IN"
    static TYPE_OUT := "OUT"
    static TYPE_ADJUSTMENT := "ADJUSTMENT"

    __New(product, type, quantity, notes := "") {
        this.product := product
        this.type := type
        this.quantity := quantity
        this.notes := notes
        this.timestamp := A_Now
    }

    ToString() => Format("[{1}] {2} {3}: {4} units - {5}",
        FormatTime(this.timestamp, "MM/dd HH:mm"),
        this.type,
        this.product.name,
        this.quantity,
        this.notes)
}

class PurchaseOrder {
    static nextPOId := 1000
    static STATUS_PENDING := "PENDING"
    static STATUS_ORDERED := "ORDERED"
    static STATUS_RECEIVED := "RECEIVED"
    static STATUS_CANCELLED := "CANCELLED"

    __New(supplier) {
        this.poId := PurchaseOrder.nextPOId++
        this.supplier := supplier
        this.items := Map()
        this.status := PurchaseOrder.STATUS_PENDING
        this.createdAt := A_Now
        this.orderedAt := ""
        this.receivedAt := ""
    }

    AddItem(product, quantity) {
        this.items[product.productId] := { product: product, quantity: quantity }
        return this
    }

    GetTotal() {
        total := 0
        for id, item in this.items
            total += item.product.price * item.quantity
        return total
    }

    Place() => (this.status := PurchaseOrder.STATUS_ORDERED, this.orderedAt := A_Now, this)
    Receive() => (this.status := PurchaseOrder.STATUS_RECEIVED, this.receivedAt := A_Now, this)
    Cancel() => (this.status := PurchaseOrder.STATUS_CANCELLED, this)

    ToString() {
        po := Format("Purchase Order #{1}`nSupplier: {2}`nStatus: {3}`n",
            this.poId, this.supplier.name, this.status)
        po .= "Items:`n"
        for id, item in this.items
            po .= Format("  {1} x{2} @ ${3:.2f} = ${4:.2f}`n",
                item.product.name, item.quantity, item.product.price, item.product.price * item.quantity)
        po .= Format("Total: ${:.2f}", this.GetTotal())
        return po
    }
}

class Warehouse {
    __New(name) => (this.name := name, this.products := Map(), this.suppliers := Map(), this.movements := [], this.purchaseOrders := [])

    AddProduct(product) => (this.products[product.productId] := product, this)
    AddSupplier(supplier) => (this.suppliers[supplier.supplierId] := supplier, this)

    ReceiveStock(product, quantity, notes := "") {
        if (!this.products.Has(product.productId))
            return MsgBox("Product not in warehouse!", "Error")

        product.stockLevel += quantity
        this.movements.Push(StockMovement(product, StockMovement.TYPE_IN, quantity, notes))
        MsgBox(Format("Received {1} units of {2}`nNew stock: {3}", quantity, product.name, product.stockLevel))
        return true
    }

    ShipStock(product, quantity, notes := "") {
        if (!this.products.Has(product.productId))
            return MsgBox("Product not in warehouse!", "Error")

        if (product.stockLevel < quantity)
            return MsgBox("Insufficient stock!", "Error")

        product.stockLevel -= quantity
        this.movements.Push(StockMovement(product, StockMovement.TYPE_OUT, quantity, notes))
        MsgBox(Format("Shipped {1} units of {2}`nRemaining stock: {3}", quantity, product.name, product.stockLevel))

        ; Check if reorder needed
        if (product.NeedsReorder())
            MsgBox(Format("LOW STOCK ALERT!`n{1} needs reordering`nCurrent: {2} | Reorder Point: {3}",
                product.name, product.stockLevel, product.reorderPoint), "Stock Alert")

        return true
    }

    AdjustStock(product, newLevel, reason) {
        if (!this.products.Has(product.productId))
            return MsgBox("Product not in warehouse!", "Error")

        difference := newLevel - product.stockLevel
        product.stockLevel := newLevel
        this.movements.Push(StockMovement(product, StockMovement.TYPE_ADJUSTMENT, difference, reason))
        MsgBox(Format("Stock adjusted for {1}`nNew level: {2}", product.name, product.stockLevel))
        return true
    }

    CreatePurchaseOrder(supplier) {
        if (!this.suppliers.Has(supplier.supplierId))
            return MsgBox("Supplier not found!", "Error")

        po := PurchaseOrder(supplier)
        this.purchaseOrders.Push(po)
        return po
    }

    ProcessPurchaseOrder(poId) {
        po := this._FindPurchaseOrder(poId)
        if (!po)
            return MsgBox("Purchase order not found!", "Error")

        if (po.status != PurchaseOrder.STATUS_ORDERED)
            return MsgBox("Purchase order not in ordered status!", "Error")

        ; Receive all items
        for id, item in po.items
            this.ReceiveStock(item.product, item.quantity, Format("PO #{1}", po.poId))

        po.Receive()
        MsgBox(Format("Purchase Order #{1} received!", po.poId))
        return true
    }

    GetLowStockProducts() {
        lowStock := []
        for id, product in this.products
            if (product.NeedsReorder())
                lowStock.Push(product)
        return lowStock
    }

    GenerateReorderReport() {
        lowStock := this.GetLowStockProducts()
        if (lowStock.Length = 0)
            return "All products adequately stocked!"

        report := "REORDER REPORT`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n`n"
        for product in lowStock
            report .= Format("{1}`nCurrent: {2} | Reorder Point: {3}`nReorder Quantity: {4} | Supplier: {5}`n`n",
                product.name,
                product.stockLevel,
                product.reorderPoint,
                product.reorderQuantity,
                product.supplier ? product.supplier.name : "None")

        return report
    }

    GetInventoryValue() {
        total := 0
        for id, product in this.products
            total += product.price * product.stockLevel
        return total
    }

    GetWarehouseSummary() {
        summary := this.name . " - Warehouse Summary`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        summary .= Format("Total products: {1}`n", this.products.Count)
        summary .= Format("Total suppliers: {1}`n", this.suppliers.Count)
        summary .= Format("Inventory value: ${:,.2f}`n", this.GetInventoryValue())
        summary .= Format("Low stock items: {1}`n", this.GetLowStockProducts().Length)
        summary .= Format("Stock movements: {1}`n", this.movements.Length)
        summary .= Format("Purchase orders: {1}", this.purchaseOrders.Count)
        return summary
    }

    _FindPurchaseOrder(poId) {
        for po in this.purchaseOrders
            if (po.poId = poId)
                return po
        return ""
    }
}

; Usage
warehouse := Warehouse("Main Distribution Center")

; Add suppliers
acmeSupplier := Supplier("Acme Corp", "John Smith", "john@acme.com")
techSupplier := Supplier("Tech Supplies Inc", "Jane Doe", "jane@techsupplies.com")
warehouse.AddSupplier(acmeSupplier).AddSupplier(techSupplier)

; Add products
laptop := Product("Laptop Pro 15", "LAP-001", 999.99, 10, 20)
mouse := Product("Wireless Mouse", "MOU-001", 29.99, 50, 100)
keyboard := Product("Mechanical Keyboard", "KEY-001", 79.99, 30, 50)
monitor := Product("4K Monitor 27", "MON-001", 399.99, 15, 25)

acmeSupplier.AddProduct(laptop).AddProduct(monitor)
techSupplier.AddProduct(mouse).AddProduct(keyboard)

warehouse.AddProduct(laptop).AddProduct(mouse).AddProduct(keyboard).AddProduct(monitor)

; Receive initial stock
warehouse.ReceiveStock(laptop, 50, "Initial stock")
warehouse.ReceiveStock(mouse, 200, "Initial stock")
warehouse.ReceiveStock(keyboard, 100, "Initial stock")
warehouse.ReceiveStock(monitor, 40, "Initial stock")

; Ship products
warehouse.ShipStock(laptop, 35, "Customer order #1001")
warehouse.ShipStock(laptop, 10, "Customer order #1002")  ; Triggers low stock alert

warehouse.ShipStock(mouse, 155, "Bulk order #2001")

; Check low stock
MsgBox(warehouse.GenerateReorderReport())

; Create and process purchase order
po := warehouse.CreatePurchaseOrder(acmeSupplier)
po.AddItem(laptop, 20).AddItem(monitor, 10)

MsgBox(po.ToString())
po.Place()

warehouse.ProcessPurchaseOrder(po.poId)

; Warehouse summary
MsgBox(warehouse.GetWarehouseSummary())

; Recent movements
MsgBox("Recent Stock Movements:`n`n" . warehouse.movements.Slice(-5).Map((m) => m.ToString()).Join("`n"))
