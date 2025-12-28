#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Feature: Private Members and Encapsulation
; Demonstrates: Private members (underscore convention), controlled access, data hiding

class SecureWallet {
    __New(owner, initialBalance := 0) {
        this._owner := owner
        this._balance := initialBalance
        this._pin := ""
        this._locked := true
        this._transactions := []
    }

    ; Public read-only properties
    Owner => this._owner
    Balance => this._locked ? "***LOCKED***" : Format("${:.2f}", this._balance)
    IsLocked => this._locked

    ; Public methods with controlled access
    SetPin(newPin) {
        if (StrLen(newPin) != 4 || !this._IsNumeric(newPin))
            return MsgBox("PIN must be exactly 4 digits!", "Error")
        this._pin := newPin
        this._locked := false
        this._Log("PIN set successfully")
        MsgBox("PIN set successfully!")
    }

    Unlock(pin) {
        if (pin = this._pin) {
            this._locked := false
            this._Log("Wallet unlocked")
            return MsgBox("Wallet unlocked!")
        }
        this._Log("Failed unlock attempt")
        MsgBox("Incorrect PIN!", "Error")
    }

    Lock() => (this._locked := true, this._Log("Wallet locked"))

    Deposit(amount) {
        if (this._locked)
            return MsgBox("Wallet is locked!", "Error")
        if (!this._ValidateAmount(amount))
            return
        this._balance += amount
        this._Log(Format("Deposited: ${:.2f}", amount))
        MsgBox(Format("Deposited ${:.2f}`nNew balance: ${:.2f}", amount, this._balance))
    }

    Withdraw(amount) {
        if (this._locked)
            return MsgBox("Wallet is locked!", "Error")
        if (!this._ValidateAmount(amount))
            return
        if (amount > this._balance)
            return MsgBox("Insufficient funds!", "Error")
        this._balance -= amount
        this._Log(Format("Withdrew: ${:.2f}", amount))
        MsgBox(Format("Withdrew ${:.2f}`nNew balance: ${:.2f}", amount, this._balance))
    }

    GetTransactionHistory() {
        if (this._locked)
            return MsgBox("Wallet is locked!", "Error")
        MsgBox("Transaction History:`n" this._transactions.Join("`n"))
    }

    ; Private helper methods
    _ValidateAmount(amount) {
        if (amount <= 0) {
            MsgBox("Amount must be positive!", "Error")
            return false
        }
        return true
    }

    _IsNumeric(str) {
        loop parse str
            if (A_LoopField < "0" || A_LoopField > "9")
                return false
        return true
    }

    _Log(message) => this._transactions.Push(Format("[{1}] {2}", FormatTime(, "HH:mm:ss"), message))
}

; Usage demonstrating encapsulation
wallet := SecureWallet("Alice", 1000)

; Cannot access balance when locked
MsgBox("Balance: " wallet.Balance)

; Set PIN to unlock
wallet.SetPin("1234")

; Now can access and modify
MsgBox("Balance: " wallet.Balance)
wallet.Deposit(250)
wallet.Withdraw(100)

; Lock wallet again
wallet.Lock()
wallet.Deposit(50)  ; Will fail - wallet locked

; View history after unlocking
wallet.Unlock("1234")
wallet.GetTransactionHistory()
