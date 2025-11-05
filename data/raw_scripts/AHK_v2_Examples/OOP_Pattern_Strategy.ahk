#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP Pattern: Strategy Pattern
; Demonstrates: Polymorphism, strategy selection, interface-like behavior

class PaymentProcessor {
    __New(strategy) => this.strategy := strategy
    SetStrategy(strategy) => this.strategy := strategy
    Process(amount) => this.strategy.Pay(amount)
}

class CreditCardPayment {
    __New(cardNumber, cvv) => (this.cardNumber := cardNumber, this.cvv := cvv)
    Pay(amount) => MsgBox(Format("Paid ${:.2f} using Credit Card ending in {}", amount, SubStr(this.cardNumber, -4)))
}

class PayPalPayment {
    __New(email) => this.email := email
    Pay(amount) => MsgBox(Format("Paid ${:.2f} via PayPal ({}) ", amount, this.email))
}

class CryptoPayment {
    __New(wallet) => this.wallet := wallet
    Pay(amount) => MsgBox(Format("Paid ${:.2f} using Crypto wallet: {}...", amount, SubStr(this.wallet, 1, 8)))
}

; Usage - elegant strategy switching
processor := PaymentProcessor(CreditCardPayment("1234-5678-9012-3456", "123"))
processor.Process(99.99)

processor.SetStrategy(PayPalPayment("user@paypal.com"))
processor.Process(49.99)

processor.SetStrategy(CryptoPayment("0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb"))
processor.Process(199.99)
