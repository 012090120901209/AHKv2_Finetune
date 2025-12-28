#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Feature: Advanced Property Getters/Setters
; Demonstrates: Computed properties, validation, encapsulation

class BankAccount {
    __New(owner, initial := 0) => (this._owner := owner, this._balance := initial, this._transactions := [])

    ; Read-only property
    Owner => this._owner

    ; Property with validation
    Balance {
        get => this._balance
        set => throw Error("Use Deposit() or Withdraw() methods")
    }

    ; Computed property
    TransactionCount => this._transactions.Length

    ; Formatted property
    FormattedBalance => Format("${:.2f}", this._balance)

    Deposit(amount) => amount > 0 ? (this._balance += amount, this._transactions.Push({ type: "deposit", amount: amount }), true) : false

    Withdraw(amount) => (amount > 0 && amount <= this._balance) ? (this._balance -= amount, this._transactions.Push({ type: "withdraw", amount: amount }), true) : false

    Statement() {
        result := "Account Statement for " this.Owner "`n"
        result .= "Balance: " this.FormattedBalance "`n"
        result .= "Transactions: " this.TransactionCount "`n"
        for trans in this._transactions
            result .= "  " trans.type ": $" trans.amount "`n"
        return result
    }
}

account := BankAccount("Alice", 1000)
account.Deposit(500)
account.Withdraw(200)
MsgBox(account.Statement())
