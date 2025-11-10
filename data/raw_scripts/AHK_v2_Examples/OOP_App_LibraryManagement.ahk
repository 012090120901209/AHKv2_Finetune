#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Real-world OOP Application: Library Management System
; Demonstrates: Resource management, borrowing logic, due dates, fines

class Book {
    static nextBookId := 1

    __New(title, author, isbn, copies := 1) {
        this.bookId := Book.nextBookId++
        this.title := title
        this.author := author
        this.isbn := isbn
        this.totalCopies := copies
        this.availableCopies := copies
    }

    IsAvailable() => this.availableCopies > 0
    Borrow() => (this.availableCopies--, this)
    Return() => (this.availableCopies++, this)
    ToString() => Format("{1} by {2} ({3}/{4} available)", this.title, this.author, this.availableCopies, this.totalCopies)
}

class Member {
    static nextMemberId := 1000
    static MAX_BOOKS := 5

    __New(name, email) {
        this.memberId := Member.nextMemberId++
        this.name := name
        this.email := email
        this.borrowedBooks := []
        this.fines := 0
        this.joinedDate := A_Now
    }

    CanBorrow() => this.borrowedBooks.Length < Member.MAX_BOOKS && this.fines = 0

    GetBorrowedCount() => this.borrowedBooks.Length

    AddFine(amount) => (this.fines += amount, this)
    PayFine(amount) => (this.fines := Max(0, this.fines - amount), this)

    ToString() => Format("#{1}: {2} ({3} books, ${4:.2f} fines)",
        this.memberId, this.name, this.borrowedBooks.Length, this.fines)
}

class Loan {
    static LOAN_PERIOD_DAYS := 14
    static FINE_PER_DAY := 0.50

    __New(book, member) {
        this.book := book
        this.member := member
        this.borrowDate := A_Now
        this.dueDate := this._CalculateDueDate()
        this.returnDate := ""
    }

    _CalculateDueDate() {
        dueDate := DateAdd(this.borrowDate, Loan.LOAN_PERIOD_DAYS, "Days")
        return dueDate
    }

    IsOverdue() {
        if (this.returnDate)
            return false
        return DateDiff(A_Now, this.dueDate, "Days") > 0
    }

    GetDaysOverdue() {
        if (!this.IsOverdue())
            return 0
        return DateDiff(A_Now, this.dueDate, "Days")
    }

    CalculateFine() {
        if (!this.IsOverdue())
            return 0
        return this.GetDaysOverdue() * Loan.FINE_PER_DAY
    }

    ToString() => Format("{1} - Due: {2}{3}",
        this.book.title,
        FormatTime(this.dueDate, "yyyy-MM-dd"),
        this.IsOverdue() ? Format(" (OVERDUE: {1} days, ${2:.2f} fine)", this.GetDaysOverdue(), this.CalculateFine()) : "")
}

class Library {
    __New(name) => (this.name := name, this.books := Map(), this.members := Map(), this.loans := [])

    AddBook(book) => (this.books[book.bookId] := book, this)
    AddMember(member) => (this.members[member.memberId] := member, this)

    FindBookByTitle(title) {
        for id, book in this.books
            if (InStr(book.title, title))
                return book
        return ""
    }

    BorrowBook(memberId, bookId) {
        member := this.members.Has(memberId) ? this.members[memberId] : ""
        book := this.books.Has(bookId) ? this.books[bookId] : ""

        if (!member)
            return MsgBox("Member not found!", "Error")
        if (!book)
            return MsgBox("Book not found!", "Error")
        if (!member.CanBorrow())
            return MsgBox("Member cannot borrow: " . (member.fines > 0 ? "outstanding fines" : "max books reached"), "Error")
        if (!book.IsAvailable())
            return MsgBox("Book not available!", "Error")

        loan := Loan(book, member)
        this.loans.Push(loan)
        member.borrowedBooks.Push(loan)
        book.Borrow()

        MsgBox(Format("{1} borrowed '{2}'`nDue: {3}",
            member.name,
            book.title,
            FormatTime(loan.dueDate, "yyyy-MM-dd")))
        return true
    }

    ReturnBook(memberId, bookId) {
        member := this.members.Has(memberId) ? this.members[memberId] : ""
        if (!member)
            return MsgBox("Member not found!", "Error")

        for index, loan in member.borrowedBooks {
            if (loan.book.bookId = bookId) {
                loan.returnDate := A_Now
                loan.book.Return()

                fine := loan.CalculateFine()
                if (fine > 0) {
                    member.AddFine(fine)
                    MsgBox(Format("Book returned late!`nFine: ${:.2f} ({1} days overdue)", fine, loan.GetDaysOverdue()))
                } else {
                    MsgBox("Book returned on time!")
                }

                member.borrowedBooks.RemoveAt(index)
                return true
            }
        }

        MsgBox("This member hasn't borrowed this book!", "Error")
        return false
    }

    GetMemberLoans(memberId) {
        member := this.members.Has(memberId) ? this.members[memberId] : ""
        if (!member)
            return []
        return member.borrowedBooks
    }

    GetOverdueLoans() {
        overdue := []
        for member in this.members
            for loan in member.borrowedBooks
                if (loan.IsOverdue())
                    overdue.Push(loan)
        return overdue
    }

    GetLibrarySummary() {
        summary := this.name . "`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        summary .= Format("Total books: {1}`n", this.books.Count)
        summary .= Format("Total members: {1}`n", this.members.Count)
        summary .= Format("Active loans: {1}`n", this.loans.Length)

        overdueCount := 0
        for member in this.members
            for loan in member.borrowedBooks
                if (loan.IsOverdue())
                    overdueCount++

        summary .= Format("Overdue loans: {1}`n", overdueCount)
        return summary
    }
}

; Usage - complete library system
library := Library("City Public Library")

; Add books
library.AddBook(Book("The Great Gatsby", "F. Scott Fitzgerald", "978-0743273565", 3))
library.AddBook(Book("1984", "George Orwell", "978-0451524935", 2))
library.AddBook(Book("To Kill a Mockingbird", "Harper Lee", "978-0060935467", 2))

; Add members
alice := Member("Alice Johnson", "alice@email.com")
bob := Member("Bob Smith", "bob@email.com")
library.AddMember(alice).AddMember(bob)

; Borrow books
library.BorrowBook(alice.memberId, 1)  ; Alice borrows The Great Gatsby
library.BorrowBook(alice.memberId, 2)  ; Alice borrows 1984
library.BorrowBook(bob.memberId, 3)    ; Bob borrows To Kill a Mockingbird

; Show member's borrowed books
MsgBox("Alice's borrowed books:`n" . alice.borrowedBooks.Map((loan) => loan.ToString()).Join("`n"))

; Simulate overdue book (manually set due date to past)
alice.borrowedBooks[1].dueDate := DateAdd(A_Now, -10, "Days")

MsgBox("Alice's borrowed books (with overdue):`n" . alice.borrowedBooks.Map((loan) => loan.ToString()).Join("`n"))

; Return book with fine
library.ReturnBook(alice.memberId, 1)

MsgBox(alice.ToString())

; Pay fine
alice.PayFine(5.00)
MsgBox("After paying fine: " . alice.ToString())

; Library summary
MsgBox(library.GetLibrarySummary())

; Show catalog
catalog := ""
for id, book in library.books
    catalog .= book.ToString() . "`n"
MsgBox("Library Catalog:`n" . catalog)
