#Requires AutoHotkey v2.0
#SingleInstance Force
; Real-world OOP Application: Employee Management System
; Demonstrates: HR management, payroll, departments, hierarchy

class Employee {
    static nextEmployeeId := 1000

    __New(name, email, position, salary) {
        this.employeeId := Employee.nextEmployeeId++
        this.name := name
        this.email := email
        this.position := position
        this.salary := salary
        this.department := ""
        this.hireDate := A_Now
        this.vacationDays := 20
        this.sickDays := 10
    }

    GetMonthlySalary() => this.salary / 12
    GetAnnualSalary() => this.salary

    UseVacationDays(days) {
        if (days > this.vacationDays)
            return MsgBox("Insufficient vacation days!", "Error")
        this.vacationDays -= days
        MsgBox(Format("{1} used {2} vacation days`nRemaining: {3}", this.name, days, this.vacationDays))
        return true
    }

    UseSickDays(days) {
        if (days > this.sickDays)
            return MsgBox("Insufficient sick days!", "Error")
        this.sickDays -= days
        MsgBox(Format("{1} used {2} sick days`nRemaining: {3}", this.name, days, this.sickDays))
        return true
    }

    GiveRaise(percentage) {
        oldSalary := this.salary
        this.salary := this.salary * (1 + percentage / 100)
        MsgBox(Format("{1} received {2}% raise`nOld: ${3:.2f}`nNew: ${4:.2f}",
            this.name, percentage, oldSalary, this.salary))
    }

    ToString() => Format("#{1}: {2} - {3} (${4:,.2f}/year)",
        this.employeeId, this.name, this.position, this.salary)
}

class Manager extends Employee {
    __New(name, email, position, salary) {
        super.__New(name, email, position, salary)
        this.directReports := []
        this.bonus := 0
    }

    AddDirectReport(employee) => (this.directReports.Push(employee), this)

    SetBonus(amount) => (this.bonus := amount, this)

    GetAnnualCompensation() => this.salary + this.bonus

    GetTeamSize() => this.directReports.Length

    GetTeamSummary() {
        summary := Format("Manager: {1} ({2} direct reports)`n", this.name, this.directReports.Length)
        for emp in this.directReports
            summary .= "  - " . empobj .name . " (" . empobj .position . ")`n"
        return summary
    }
}

class Department {
    __New(name, budget) => (this.name := name, this.budget := budget, this.employees := [], this.manager := "")

    SetManager(manager) => (this.manager := manager, this.AddEmployee(manager))

    AddEmployee(employee) {
        this.employees.Push(employee)
        employee.department := this.name
        return this
    }

    GetTotalSalaries() {
        total := 0
        for emp in this.employees
            total += empobj .GetAnnualSalary()
        return total
    }

    GetAverageSalary() {
        if (this.employees.Length = 0)
            return 0
        return this.GetTotalSalaries() / this.employees.Length
    }

    GetHeadcount() => this.employees.Length

    IsOverBudget() => this.GetTotalSalaries() > this.budget

    GetBudgetUtilization() => Round((this.GetTotalSalaries() / this.budget) * 100, 1)

    ToString() => Format("{1}: {2} employees, ${3:,.2f} budget ({4}% used)",
        this.name,
        this.employees.Length,
        this.budget,
        this.GetBudgetUtilization())
}

class PayrollEntry {
    __New(employee, month, year) {
        this.employee := employee
        this.month := month
        this.year := year
        this.grossPay := employee.GetMonthlySalary()
        this.deductions := this._CalculateDeductions()
        this.netPay := this.grossPay - this.deductions
    }

    _CalculateDeductions() {
        taxRate := 0.25
        socialSecurity := 0.062
        medicare := 0.0145
        return this.grossPay * (taxRate + socialSecurity + medicare)
    }

    ToString() => Format("Payroll - {1} ({2}/{3})`nGross: ${4:,.2f}`nDeductions: ${5:,.2f}`nNet: ${6:,.2f}",
        this.employee.name,
        this.month,
        this.year,
        this.grossPay,
        this.deductions,
        this.netPay)
}

class Company {
    __New(name) => (this.name := name, this.departments := Map(), this.employees := Map())

    AddDepartment(department) => (this.departments[department.name] := department, this)

    GetDepartment(name) => this.departments.Has(name) ? this.departments[name] : ""

    HireEmployee(employee, departmentName) {
        dept := this.GetDepartment(departmentName)
        if (!dept)
            return MsgBox("Department not found!", "Error")

        this.employees[employee.employeeId] := employee
        dept.AddEmployee(employee)
        MsgBox(Format("{1} hired in {2} department!", employee.name, departmentName))
        return employee
    }

    GetEmployee(employeeId) => this.employees.Has(employeeId) ? this.employees[employeeId] : ""

    GeneratePayroll(month, year) {
        payrollEntries := []
        for id, emp in this.employees
            payrollEntries.Push(PayrollEntry(emp, month, year))
        return payrollEntries
    }

    GetTotalPayroll() {
        total := 0
        for id, emp in this.employees
            total += empobj .GetAnnualSalary()
        return total
    }

    GetCompanySummary() {
        summary := this.name . " - Company Summary`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        summary .= Format("Total employees: {1}`n", this.employees.Count)
        summary .= Format("Departments: {1}`n", this.departments.Count)
        summary .= Format("Annual payroll: ${:.2f}`n`n", this.GetTotalPayroll())

        summary .= "Departments:`n"
        for name, dept in this.departments
            summary .= "  " . dept.ToString() . "`n"

        return summary
    }
}

; Usage - complete employee management system
companyobj := Company("TechCorp Inc.")

; Create departments
engineering := Department("Engineering", 1000000)
sales := Department("Sales", 750000)
hr := Department("Human Resources", 300000)

companyobj .AddDepartment(engineering).AddDepartment(sales).AddDepartment(hr)

; Hire managers
engManager := Manager("Alice Johnson", "alice@techcorp.com", "Engineering Manager", 120000)
engManager.SetBonus(20000)
engineering.SetManager(engManager)

salesManager := Manager("Bob Smith", "bob@techcorp.com", "Sales Director", 110000)
salesManager.SetBonus(30000)
sales.SetManager(salesManager)

; Hire employees
companyobj .HireEmployee(Employee("Charlie Brown", "charlie@techcorp.com", "Senior Developer", 95000), "Engineering")
companyobj .HireEmployee(Employee("Diana Prince", "diana@techcorp.com", "Developer", 80000), "Engineering")
companyobj .HireEmployee(Employee("Eve Davis", "eve@techcorp.com", "Junior Developer", 65000), "Engineering")

companyobj .HireEmployee(Employee("Frank Miller", "frank@techcorp.com", "Sales Rep", 70000), "Sales")
companyobj .HireEmployee(Employee("Grace Lee", "grace@techcorp.com", "Sales Rep", 70000), "Sales")

companyobj .HireEmployee(Employee("Henry Wilson", "henry@techcorp.com", "HR Manager", 85000), "Human Resources")

; Set up reporting structure
engManager.AddDirectReport(companyobj .employees[1001])  ; Charlie
engManager.AddDirectReport(companyobj .employees[1002])  ; Diana
engManager.AddDirectReport(companyobj .employees[1003])  ; Eve

salesManager.AddDirectReport(companyobj .employees[1004])  ; Frank
salesManager.AddDirectReport(companyobj .employees[1005])  ; Grace

; Employee actions
companyobj .employees[1001].UseVacationDays(5)
companyobj .employees[1002].GiveRaise(10)

; Manager actions
MsgBox(engManager.GetTeamSummary())
MsgBox(Format("Manager compensation: ${:,.2f} (salary + bonus)", engManager.GetAnnualCompensation()))

; Department analysis
MsgBox(engineering.ToString())
MsgBox(Format("Engineering avg salary: ${:,.2f}", engineering.GetAverageSalary()))

if (engineering.IsOverBudget())
    MsgBox("Engineering is over budget!", "Warning")

; Payroll generation
payroll := companyobj .GeneratePayroll("October", 2024)
MsgBox(payroll[1].ToString())  ; Show one paycheck
MsgBox(payroll[2].ToString())

; Company summary
MsgBox(companyobj .GetCompanySummary())
