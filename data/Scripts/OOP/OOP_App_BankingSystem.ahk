#Requires AutoHotkey v2.0
#SingleInstance Force
; Real-world OOP Application: Banking System
; Demonstrates: Account management, transactions, transfers, inheritance

class Transaction {
    static nextId := 1

    __New(type, amount, description := "") {
        this.id := Transaction.nextId++
        this.type := type  ; "DEPOSIT", "WITHDRAWAL", "TRANSFER"
        this.amount := amount
        this.description := description
        this.timestamp := A_Now
    }

    ToString() => Format("[{1}] {2}: ${3:.2f} - {4}",
    FormatTime(this.timestamp, "MM/dd HH:mm"),
    this.type,
    this.amount,
    this.description)
}

class Account {
    static nextAccountNumber := 1000

    __New(owner, initialBalance := 0) {
        this.accountNumber := Account.nextAccountNumber++
        this.owner := owner
        this.balance := initialBalance
        this.transactions := []
        this.createdAt := A_Now
        this._LogTransaction("OPENING", initialBalance, "Account opened")
    }

    Deposit(amount, description := "Deposit") {
        if (amount <= 0)
        return MsgBox("Deposit amount must be positive!", "Error")

        this.balance += amount
        this._LogTransaction("DEPOSIT", amount, description)
        MsgBox(Format("Deposited ${:.2f}`nNew balance: ${:.2f}", amount, this.balance))
        return true
    }

    Withdraw(amount, description := "Withdrawal") {
        if (amount <= 0)
        return MsgBox("Withdrawal amount must be positive!", "Error")

        if (!this._CanWithdraw(amount))
        return MsgBox("Insufficient funds!", "Error")

        this.balance -= amount
        this._LogTransaction("WITHDRAWAL", amount, description)
        MsgBox(Format("Withdrew ${:.2f}`nNew balance: ${:.2f}", amount, this.balance))
        return true
    }

    GetBalance() => this.balance

    GetStatement(limit := 10) {
        statement := Format("Account #{1} - {2}`n", this.accountNumber, this.owner)
        statement .= Format("Balance: ${:.2f}`n`n", this.balance)
        statement .= "Recent Transactions:`n"

        count := Min(limit, this.transactions.Length)
        loop count
        statement .= this.transactions[this.transactions.Length - A_Index + 1].ToString() "`n"

        return statement
    }

    _CanWithdraw(amount) => amount <= this.balance

    _LogTransaction(type, amount, description) =>
    this.transactions.Push(Transaction(type, amount, description))
}

class SavingsAccount extends Account {
    __New(owner, initialBalance := 0, interestRate := 2.5) {
        super.__New(owner, initialBalance)
        this.interestRate := interestRate
    }

    ApplyInterest() {
        interest := this.balance * (this.interestRate / 100 / 12)
        this.balance += interest
        this._LogTransaction("INTEREST", interest, Format("{:.2f}% monthly interest", this.interestRate))
        MsgBox(Format("Interest applied: ${:.2f}`nNew balance: ${:.2f}", interest, this.balance))
    }
}

class CheckingAccount extends Account {
    __New(owner, initialBalance := 0, overdraftLimit := 500) {
        super.__New(owner, initialBalance)
        this.overdraftLimit := overdraftLimit
    }

    _CanWithdraw(amount) => amount <= (this.balance + this.overdraftLimit)

    GetAvailableBalance() => this.balance + this.overdraftLimit
}

class Bank {
    __New(name) => (this.name := name, this.accounts := Map())

    CreateSavingsAccount(owner, initialBalance := 0, interestRate := 2.5) {
        account := SavingsAccount(owner, initialBalance, interestRate)
        this.accounts[account.accountNumber] := account
        MsgBox(Format("Savings account #{1} created for {2}", account.accountNumber, owner))
        return account
    }

    CreateCheckingAccount(owner, initialBalance := 0, overdraftLimit := 500) {
        account := CheckingAccount(owner, initialBalance, overdraftLimit)
        this.accounts[account.accountNumber] := account
        MsgBox(Format("Checking account #{1} created for {2}", account.accountNumber, owner))
        return account
    }

    GetAccount(accountNumber) =>
    this.accounts.Has(accountNumber) ? this.accounts[accountNumber] : ""

    Transfer(fromAccountNum, toAccountNum, amount, description := "Transfer") {
        fromAccount := this.GetAccount(fromAccountNum)
        toAccount := this.GetAccount(toAccountNum)

        if (!fromAccount || !toAccount)
        return MsgBox("Invalid account number!", "Error")

        if (!fromAccount._CanWithdraw(amount))
        return MsgBox("Insufficient funds for transfer!", "Error")

        fromAccount.balance -= amount
        toAccount.balance += amount

        fromAccount._LogTransaction("TRANSFER_OUT", amount, description . " to #" . toAccountNum)
        toAccount._LogTransaction("TRANSFER_IN", amount, description . " from #" . fromAccountNum)

        MsgBox(Format("Transferred ${:.2f} from #{1} to #{2}", amount, fromAccountNum, toAccountNum))
        return true
    }

    GetBankSummary() {
        summary := this.name . " - Bank Summary`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        totalBalance := 0

        for accNum, account in this.accounts {
            summary .= Format("#{1}: {2} - ${3:.2f}`n", accNum, account.owner, account.balance)
            totalBalance += account.balance
        }

        summary .= Format("`nTotal deposits: ${:.2f}", totalBalance)
        summary .= Format("`nTotal accounts: {1}", this.accounts.Count)

        return summary
    }
}

; Usage - complete banking system
bank := Bank("First National Bank")

; Create accounts
aliceChecking := bank.CreateCheckingAccount("Alice Johnson", 1000, 500)
bobSavings := bank.CreateSavingsAccount("Bob Smith", 5000, 3.0)
charlieSavings := bank.CreateSavingsAccount("Charlie Brown", 2000, 2.5)

; Perform transactions
aliceChecking.Deposit(500, "Paycheck")
aliceChecking.Withdraw(200, "ATM withdrawal")

bobSavings.Deposit(1000, "Birthday gift")
bobSavings.ApplyInterest()

; Transfer between accounts
bank.Transfer(aliceChecking.accountNumber, bobSavings.accountNumber, 300, "Loan repayment")

; Show statements
MsgBox(aliceChecking.GetStatement())
MsgBox(bobSavings.GetStatement())

; Bank summary
MsgBox(bank.GetBankSummary())

; Test overdraft
MsgBox("Alice's available balance (with overdraft): $" . aliceChecking.GetAvailableBalance())
aliceChecking.Withdraw(1200, "Large purchase")  ; Uses overdraft
MsgBox(aliceChecking.GetStatement())
