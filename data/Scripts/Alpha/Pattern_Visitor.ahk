#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Visitor Pattern - Separates algorithm from object structure
; Demonstrates double dispatch for type-safe operations

class Employee {
    __New(name, salary) {
        this.name := name
        this.salary := salary
    }
    Accept(visitor) => visitor.VisitEmployee(this)
}

class Department {
    __New(name) {
        this.name := name
        this.members := []
    }
    
    Add(emp) {
        this.members.Push(emp)
        return this
    }
    
    Accept(visitor) => visitor.VisitDepartment(this)
}

; Visitors implement operations
class SalaryVisitor {
    __New() => this.total := 0

    VisitEmployee(emp) {
        this.total += emp.salary
        return this
    }

    VisitDepartment(dept) {
        for member in dept.members
            member.Accept(this)
        return this
    }
}

class NameListVisitor {
    __New() => this.names := []

    VisitEmployee(emp) {
        this.names.Push(emp.name)
        return this
    }

    VisitDepartment(dept) {
        for member in dept.members
            member.Accept(this)
        return this
    }
}

; Demo
engineering := Department("Engineering")
    .Add(Employee("Alice", 80000))
    .Add(Employee("Bob", 75000))

sales := Department("Sales")
    .Add(Employee("Charlie", 65000))
    .Add(Employee("Diana", 70000))

; Calculate total salary
visitor := SalaryVisitor()
engineering.Accept(visitor)
sales.Accept(visitor)

; Get all names
nameVisitor := NameListVisitor()
engineering.Accept(nameVisitor)
sales.Accept(nameVisitor)

names := ""
for name in nameVisitor.names
    names .= name ", "

MsgBox("Total Salary: $" visitor.total "`nEmployees: " names)
