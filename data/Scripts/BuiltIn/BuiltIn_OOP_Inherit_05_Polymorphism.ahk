#Requires AutoHotkey v2.0

/**
* BuiltIn_OOP_Inherit_05_Polymorphism.ahk
*
* DESCRIPTION:
* Demonstrates polymorphism in AutoHotkey v2 - the ability of objects of different
* classes to respond to the same method calls in different ways. Shows how inheritance
* and method overriding enable polymorphic behavior.
*
* FEATURES:
* - Polymorphic method calls
* - Interface compatibility
* - Duck typing in collections
* - Polymorphic parameters
* - Strategy pattern with polymorphism
* - Polymorphic return types
* - Runtime type decisions
*
* SOURCE:
* AutoHotkey v2 Documentation - Objects
*
* KEY V2 FEATURES DEMONSTRATED:
* - Method overriding for polymorphism
* - Dynamic dispatch
* - Heterogeneous collections
* - Type checking with HasBase()
* - Polymorphic function parameters
* - Runtime behavior selection
*
* LEARNING POINTS:
* 1. Polymorphism means "many forms"
* 2. Same method name, different implementations
* 3. Enables writing generic code
* 4. Collections can hold different types
* 5. Method resolution happens at runtime
* 6. Interface matters more than type
* 7. Reduces code duplication through abstraction
*/

; ========================================
; EXAMPLE 1: Basic Polymorphism
; ========================================
; Different classes responding to same method call differently

class Shape {
    Name := ""

    __New(name) {
        this.Name := name
    }

    Draw() {
        return "Drawing " this.Name
    }

    Area() {
        return 0
    }

    Perimeter() {
        return 0
    }
}

class Circle extends Shape {
    Radius := 0

    __New(radius) {
        super.__New("Circle")
        this.Radius := radius
    }

    Draw() {
        return "Drawing a circle with radius " this.Radius
    }

    Area() {
        return 3.14159 * this.Radius ** 2
    }

    Perimeter() {
        return 2 * 3.14159 * this.Radius
    }
}

class Rectangle extends Shape {
    Width := 0
    Height := 0

    __New(width, height) {
        super.__New("Rectangle")
        this.Width := width
        this.Height := height
    }

    Draw() {
        return "Drawing a rectangle " this.Width "x" this.Height
    }

    Area() {
        return this.Width * this.Height
    }

    Perimeter() {
        return 2 * (this.Width + this.Height)
    }
}

class Triangle extends Shape {
    Base := 0
    Height := 0
    Side1 := 0
    Side2 := 0
    Side3 := 0

    __New(base, height, side1, side2, side3) {
        super.__New("Triangle")
        this.Base := base
        this.Height := height
        this.Side1 := side1
        this.Side2 := side2
        this.Side3 := side3
    }

    Draw() {
        return "Drawing a triangle with base " this.Base
    }

    Area() {
        return 0.5 * this.Base * this.Height
    }

    Perimeter() {
        return this.Side1 + this.Side2 + this.Side3
    }
}

; Polymorphic function - works with any Shape
DescribeShape(shape) {
    description := shape.Draw() "`n"
    description .= "Area: " Round(shape.Area(), 2) "`n"
    description .= "Perimeter: " Round(shape.Perimeter(), 2)
    return description
}

; Create different shapes
circle := Circle(5)
rectangle := Rectangle(10, 4)
triangle := Triangle(6, 8, 6, 8, 10)

; Same function call, different behavior
MsgBox(DescribeShape(circle))
MsgBox(DescribeShape(rectangle))
MsgBox(DescribeShape(triangle))

; Polymorphic array
shapes := [circle, rectangle, triangle]
totalArea := 0

for shape in shapes {
    totalArea += shape.Area()  ; Polymorphic method call
}

MsgBox("Total area of all shapes: " Round(totalArea, 2))

; ========================================
; EXAMPLE 2: Polymorphic Collections
; ========================================
; Working with heterogeneous collections

class Notification {
    Message := ""
    Timestamp := ""

    __New(message) {
        this.Message := message
        this.Timestamp := A_Now
    }

    Send() {
        throw Error("Send() must be implemented")
    }

    GetInfo() {
        return this.Message " (" FormatTime(this.Timestamp, "HH:mm:ss") ")"
    }
}

class EmailNotification extends Notification {
    To := ""
    Subject := ""

    __New(message, to, subject) {
        super.__New(message)
        this.To := to
        this.Subject := subject
    }

    Send() {
        return "Sending email to " this.To "`nSubject: " this.Subject "`n" this.GetInfo()
    }
}

class SMSNotification extends Notification {
    PhoneNumber := ""

    __New(message, phoneNumber) {
        super.__New(message)
        this.PhoneNumber := phoneNumber
    }

    Send() {
        return "Sending SMS to " this.PhoneNumber "`n" this.GetInfo()
    }
}

class PushNotification extends Notification {
    DeviceID := ""
    Priority := "Normal"

    __New(message, deviceID, priority := "Normal") {
        super.__New(message)
        this.DeviceID := deviceID
        this.Priority := priority
    }

    Send() {
        return "Sending push notification to device " this.DeviceID
        . "`nPriority: " this.Priority "`n" this.GetInfo()
    }
}

; Notification manager - works with any notification type
class NotificationManager {
    Notifications := []

    AddNotification(notification) {
        this.Notifications.Push(notification)
    }

    SendAll() {
        results := "=== Sending All Notifications ===`n`n"

        for index, notification in this.Notifications {
            ; Polymorphic Send() call
            results .= "Notification " index ":`n"
            results .= notification.Send() "`n`n"
        }

        return results
    }

    SendByType(notificationType) {
        count := 0

        for notification in this.Notifications {
            if (notification.HasBase(notificationType.Prototype)) {
                notification.Send()
                count++
            }
        }

        return "Sent " count " " notificationType.__Class " notifications"
    }
}

; Create notification manager
manager := NotificationManager()

; Add different types of notifications
manager.AddNotification(EmailNotification("Meeting at 3 PM", "john@example.com", "Meeting Reminder"))
manager.AddNotification(SMSNotification("Your package has shipped", "555-0123"))
manager.AddNotification(PushNotification("New message", "device123", "High"))
manager.AddNotification(EmailNotification("Welcome!", "alice@example.com", "Welcome to Our Service"))

; Send all notifications - polymorphic behavior
MsgBox(manager.SendAll())

; ========================================
; EXAMPLE 3: Strategy Pattern with Polymorphism
; ========================================
; Interchangeable algorithms through polymorphism

class SortStrategy {
    Name := ""

    __New(name) {
        this.Name := name
    }

    Sort(arr) {
        throw Error("Sort() must be implemented")
    }
}

class BubbleSort extends SortStrategy {
    __New() {
        super.__New("Bubble Sort")
    }

    Sort(arr) {
        result := arr.Clone()
        n := result.Length

        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                if (result[j] > result[j + 1]) {
                    temp := result[j]
                    result[j] := result[j + 1]
                    result[j + 1] := temp
                }
            }
        }

        return result
    }
}

class QuickSort extends SortStrategy {
    __New() {
        super.__New("Quick Sort")
    }

    Sort(arr) {
        if (arr.Length <= 1)
        return arr

        pivot := arr[1]
        less := []
        greater := []

        Loop arr.Length - 1 {
            if (arr[A_Index + 1] <= pivot)
            less.Push(arr[A_Index + 1])
            else
            greater.Push(arr[A_Index + 1])
        }

        result := []
        for item in this.Sort(less)
        result.Push(item)
        result.Push(pivot)
        for item in this.Sort(greater)
        result.Push(item)

        return result
    }
}

class InsertionSort extends SortStrategy {
    __New() {
        super.__New("Insertion Sort")
    }

    Sort(arr) {
        result := arr.Clone()

        Loop result.Length - 1 {
            i := A_Index + 1
            key := result[i]
            j := i - 1

            while (j >= 1 && result[j] > key) {
                result[j + 1] := result[j]
                j--
            }

            result[j + 1] := key
        }

        return result
    }
}

; Sorter that can use different strategies polymorphically
class ArraySorter {
    Strategy := ""

    __New(strategy) {
        this.Strategy := strategy
    }

    SetStrategy(strategy) {
        this.Strategy := strategy
    }

    Sort(arr) {
        return this.Strategy.Sort(arr)  ; Polymorphic call
    }

    GetStrategyName() {
        return this.Strategy.Name
    }
}

; Test with different strategies
data := [64, 34, 25, 12, 22, 11, 90]

; Use bubble sort
sorter := ArraySorter(BubbleSort())
result := sorter.Sort(data)
MsgBox("Using " sorter.GetStrategyName() ":`n" ArrayToString(result))

; Switch to quick sort
sorter.SetStrategy(QuickSort())
result := sorter.Sort(data)
MsgBox("Using " sorter.GetStrategyName() ":`n" ArrayToString(result))

; Switch to insertion sort
sorter.SetStrategy(InsertionSort())
result := sorter.Sort(data)
MsgBox("Using " sorter.GetStrategyName() ":`n" ArrayToString(result))

ArrayToString(arr) {
    str := "["
    for item in arr {
        str .= item
        if (A_Index < arr.Length)
        str .= ", "
    }
    str .= "]"
    return str
}

; ========================================
; EXAMPLE 4: Polymorphic Parameters
; ========================================
; Functions accepting different types with same interface

class PaymentMethod {
    ProcessPayment(amount) {
        throw Error("ProcessPayment() must be implemented")
    }

    GetName() {
        throw Error("GetName() must be implemented")
    }
}

class CreditCard extends PaymentMethod {
    CardNumber := ""
    ExpiryDate := ""

    __New(cardNumber, expiryDate) {
        this.CardNumber := cardNumber
        this.ExpiryDate := expiryDate
    }

    ProcessPayment(amount) {
        return "Processing credit card payment of $" amount
        . "`nCard: ****" SubStr(this.CardNumber, -4)
        . "`nExpiry: " this.ExpiryDate
    }

    GetName() {
        return "Credit Card"
    }
}

class PayPal extends PaymentMethod {
    Email := ""

    __New(email) {
        this.Email := email
    }

    ProcessPayment(amount) {
        return "Processing PayPal payment of $" amount
        . "`nAccount: " this.Email
    }

    GetName() {
        return "PayPal"
    }
}

class BankTransfer extends PaymentMethod {
    AccountNumber := ""
    RoutingNumber := ""

    __New(accountNumber, routingNumber) {
        this.AccountNumber := accountNumber
        this.RoutingNumber := routingNumber
    }

    ProcessPayment(amount) {
        return "Processing bank transfer of $" amount
        . "`nAccount: ****" SubStr(this.AccountNumber, -4)
        . "`nRouting: " this.RoutingNumber
    }

    GetName() {
        return "Bank Transfer"
    }
}

class Cryptocurrency extends PaymentMethod {
    WalletAddress := ""
    CurrencyType := ""

    __New(walletAddress, currencyType) {
        this.WalletAddress := walletAddress
        this.CurrencyType := currencyType
    }

    ProcessPayment(amount) {
        return "Processing " this.CurrencyType " payment of $" amount
        . "`nWallet: " SubStr(this.WalletAddress, 1, 10) "..."
    }

    GetName() {
        return "Cryptocurrency (" this.CurrencyType ")"
    }
}

; Checkout process - accepts any payment method polymorphically
class Checkout {
    Total := 0
    Items := []

    __New() {
        this.Items := []
        this.Total := 0
    }

    AddItem(name, price) {
        this.Items.Push({Name: name, Price: price})
        this.Total += price
    }

    ProcessCheckout(paymentMethod) {
        receipt := "=== CHECKOUT RECEIPT ===`n`n"
        receipt .= "Items:`n"

        for item in this.Items {
            receipt .= "- " item.Name ": $" item.Price "`n"
        }

        receipt .= "`nTotal: $" this.Total "`n`n"
        receipt .= "Payment Method: " paymentMethod.GetName() "`n`n"
        receipt .= paymentMethod.ProcessPayment(this.Total)

        return receipt
    }
}

; Create checkout
checkout := Checkout()
checkout.AddItem("Laptop", 999.99)
checkout.AddItem("Mouse", 29.99)
checkout.AddItem("Keyboard", 79.99)

; Process with different payment methods
creditCard := CreditCard("1234567890123456", "12/25")
MsgBox(checkout.ProcessCheckout(creditCard))

paypal := PayPal("user@example.com")
MsgBox(checkout.ProcessCheckout(paypal))

crypto := Cryptocurrency("0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb", "Bitcoin")
MsgBox(checkout.ProcessCheckout(crypto))

; ========================================
; EXAMPLE 5: Polymorphic File Handlers
; ========================================
; Different file type handlers with same interface

class FileHandler {
    FilePath := ""

    __New(filePath) {
        this.FilePath := filePath
    }

    Read() {
        throw Error("Read() must be implemented")
    }

    Write(content) {
        throw Error("Write() must be implemented")
    }

    GetFileType() {
        throw Error("GetFileType() must be implemented")
    }
}

class TextFileHandler extends FileHandler {
    Read() {
        return "Reading text from: " this.FilePath
        . "`n(Plain text content)"
    }

    Write(content) {
        return "Writing text to: " this.FilePath
        . "`nContent: " content
    }

    GetFileType() {
        return "Text File (.txt)"
    }
}

class JSONFileHandler extends FileHandler {
    Read() {
        return "Parsing JSON from: " this.FilePath
        . "`n(Structured JSON data)"
    }

    Write(content) {
        return "Writing JSON to: " this.FilePath
        . "`nSerializing object: " content
    }

    GetFileType() {
        return "JSON File (.json)"
    }
}

class XMLFileHandler extends FileHandler {
    Read() {
        return "Parsing XML from: " this.FilePath
        . "`n(XML document tree)"
    }

    Write(content) {
        return "Writing XML to: " this.FilePath
        . "`nFormatting XML: " content
    }

    GetFileType() {
        return "XML File (.xml)"
    }
}

class CSVFileHandler extends FileHandler {
    Read() {
        return "Parsing CSV from: " this.FilePath
        . "`n(Tabular data)"
    }

    Write(content) {
        return "Writing CSV to: " this.FilePath
        . "`nFormatting rows: " content
    }

    GetFileType() {
        return "CSV File (.csv)"
    }
}

; File manager that works with any file handler
class FileManager {
    Handlers := Map()

    RegisterHandler(extension, handler) {
        this.Handlers[extension] := handler
    }

    GetHandler(filePath) {
        ; Extract extension
        extension := SubStr(filePath, InStr(filePath, ".", , -1))

        if (this.Handlers.Has(extension))
        return this.Handlers[extension]

        throw Error("No handler registered for " extension)
    }

    ProcessFile(filePath, operation, content := "") {
        handler := this.GetHandler(filePath)

        result := "File Type: " handler.GetFileType() "`n"
        result .= "Path: " filePath "`n`n"

        if (operation = "read")
        result .= handler.Read()
        else if (operation = "write")
        result .= handler.Write(content)

        return result
    }
}

; Register handlers
manager := FileManager()
manager.RegisterHandler(".txt", TextFileHandler(""))
manager.RegisterHandler(".json", JSONFileHandler(""))
manager.RegisterHandler(".xml", XMLFileHandler(""))
manager.RegisterHandler(".csv", CSVFileHandler(""))

; Process different file types polymorphically
MsgBox(manager.ProcessFile("data.txt", "read"))
MsgBox(manager.ProcessFile("config.json", "write", '{"setting": "value"}'))
MsgBox(manager.ProcessFile("document.xml", "read"))
MsgBox(manager.ProcessFile("data.csv", "write", "Name,Age,City"))

; ========================================
; EXAMPLE 6: Polymorphic Event Handlers
; ========================================
; Different event handlers with same interface

class EventHandler {
    Name := ""

    __New(name) {
        this.Name := name
    }

    Handle(event) {
        throw Error("Handle() must be implemented")
    }
}

class LogEventHandler extends EventHandler {
    LogFile := ""

    __New(logFile) {
        super.__New("Logger")
        this.LogFile := logFile
    }

    Handle(event) {
        return "Logging to " this.LogFile ": " event.Type " - " event.Message
    }
}

class EmailEventHandler extends EventHandler {
    EmailAddress := ""

    __New(emailAddress) {
        super.__New("Emailer")
        this.EmailAddress := emailAddress
    }

    Handle(event) {
        return "Sending email to " this.EmailAddress
        . "`nSubject: " event.Type
        . "`nBody: " event.Message
    }
}

class AlertEventHandler extends EventHandler {
    __New() {
        super.__New("Alerter")
    }

    Handle(event) {
        return "ALERT: " event.Type " - " event.Message
    }
}

class MetricsEventHandler extends EventHandler {
    __New() {
        super.__New("Metrics")
    }

    Handle(event) {
        return "Recording metric: " event.Type " at " A_Now
    }
}

; Event dispatcher - distributes events to handlers
class EventDispatcher {
    Handlers := []

    AddHandler(handler) {
        this.Handlers.Push(handler)
    }

    Dispatch(event) {
        results := "=== Dispatching Event: " event.Type " ===`n`n"

        for handler in this.Handlers {
            ; Polymorphic Handle() call
            results .= handler.Name ": "
            results .= handler.Handle(event) "`n`n"
        }

        return results
    }
}

; Create event dispatcher
dispatcher := EventDispatcher()
dispatcher.AddHandler(LogEventHandler("app.log"))
dispatcher.AddHandler(EmailEventHandler("admin@example.com"))
dispatcher.AddHandler(AlertEventHandler())
dispatcher.AddHandler(MetricsEventHandler())

; Dispatch different events
errorEvent := {Type: "ERROR", Message: "Database connection failed"}
MsgBox(dispatcher.Dispatch(errorEvent))

warningEvent := {Type: "WARNING", Message: "High memory usage detected"}
MsgBox(dispatcher.Dispatch(warningEvent))

; ========================================
; EXAMPLE 7: Advanced Polymorphism with Type Checking
; ========================================
; Combining polymorphism with runtime type checking

class Renderer {
    Render(element) {
        throw Error("Render() must be implemented")
    }
}

class HTMLRenderer extends Renderer {
    Render(element) {
        if (element.HasBase(Button.Prototype))
        return this.RenderButton(element)
        else if (element.HasBase(TextInput.Prototype))
        return this.RenderTextInput(element)
        else if (element.HasBase(Label.Prototype))
        return this.RenderLabel(element)
        else
        return "<div>Unknown element</div>"
    }

    RenderButton(button) {
        return '<button onclick="' button.OnClick '">' button.Text '</button>'
    }

    RenderTextInput(input) {
        return '<input type="text" placeholder="' input.Placeholder '" />'
    }

    RenderLabel(label) {
        return '<label>' label.Text '</label>'
    }
}

class MarkdownRenderer extends Renderer {
    Render(element) {
        if (element.HasBase(Button.Prototype))
        return this.RenderButton(element)
        else if (element.HasBase(TextInput.Prototype))
        return this.RenderTextInput(element)
        else if (element.HasBase(Label.Prototype))
        return this.RenderLabel(element)
        else
        return "Unknown element"
    }

    RenderButton(button) {
        return "[" button.Text "](#" button.OnClick ")"
    }

    RenderTextInput(input) {
        return "_" input.Placeholder "_"
    }

    RenderLabel(label) {
        return "**" label.Text "**"
    }
}

class UIElement {
}

class Button extends UIElement {
    Text := ""
    OnClick := ""

    __New(text, onClick) {
        this.Text := text
        this.OnClick := onClick
    }
}

class TextInput extends UIElement {
    Placeholder := ""

    __New(placeholder) {
        this.Placeholder := placeholder
    }
}

class Label extends UIElement {
    Text := ""

    __New(text) {
        this.Text := text
    }
}

; Create UI elements
elements := []
elements.Push(Label("Username:"))
elements.Push(TextInput("Enter your username"))
elements.Push(Label("Password:"))
elements.Push(TextInput("Enter your password"))
elements.Push(Button("Login", "handleLogin()"))

; Render with HTML renderer
htmlRenderer := HTMLRenderer()
htmlOutput := "=== HTML Output ===`n`n"
for element in elements {
    htmlOutput .= htmlRenderer.Render(element) "`n"
}
MsgBox(htmlOutput)

; Render with Markdown renderer
mdRenderer := MarkdownRenderer()
mdOutput := "=== Markdown Output ===`n`n"
for element in elements {
    mdOutput .= mdRenderer.Render(element) "`n"
}
MsgBox(mdOutput)

MsgBox("=== OOP Polymorphism Examples Complete ===`n`n"
. "This file demonstrated:`n"
. "- Basic polymorphic behavior`n"
. "- Polymorphic collections`n"
. "- Strategy pattern with polymorphism`n"
. "- Polymorphic parameters`n"
. "- Polymorphic file handlers`n"
. "- Polymorphic event handlers`n"
. "- Advanced polymorphism with type checking")
