#Requires AutoHotkey v2.0

/**
* BuiltIn_Round_02_Financial.ahk
*
* DESCRIPTION:
* Financial applications of Round() for currency rounding, tax calculations,
* interest computations, and monetary operations
*
* FEATURES:
* - Currency rounding to 2 decimal places
* - Tax and discount calculations
* - Interest and percentage computations
* - Invoice and receipt generation
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/Round.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Round() for financial precision
* - Format() for currency display
* - Object structures for financial data
* - Accumulator patterns for totals
*
* LEARNING POINTS:
* 1. Always round currency to 2 decimal places
* 2. Round after each calculation to prevent errors
* 3. Tax calculations require careful rounding
* 4. Accumulate totals after rounding line items
* 5. Display formatted currency with $ symbol
*/

; ============================================================
; Example 1: Basic Currency Rounding
; ============================================================

/**
* Round a value to currency (2 decimal places)
*
* @param {Number} amount - Amount to round
* @returns {Number} - Rounded to 2 decimals
*/
RoundCurrency(amount) {
    return Round(amount, 2)
}

/**
* Format as currency string
*
* @param {Number} amount - Amount to format
* @returns {String} - Formatted as $X.XX
*/
FormatCurrency(amount) {
    return "$" . Format("{1:.2f}", amount)
}

; Test currency rounding
price1 := 19.995
price2 := 19.994
price3 := 19.996
price4 := 0.333333

MsgBox("Currency Rounding (2 Decimals):`n`n"
. FormatCurrency(price1) " → " FormatCurrency(RoundCurrency(price1)) "`n"
. FormatCurrency(price2) " → " FormatCurrency(RoundCurrency(price2)) "`n"
. FormatCurrency(price3) " → " FormatCurrency(RoundCurrency(price3)) "`n"
. FormatCurrency(price4) " → " FormatCurrency(RoundCurrency(price4)) "`n`n"
. "All currency rounded to 2 decimal places",
"Currency Rounding", "Icon!")

; ============================================================
; Example 2: Tax Calculation
; ============================================================

/**
* Calculate tax with proper rounding
*
* @param {Number} subtotal - Pre-tax amount
* @param {Number} taxRate - Tax rate as percentage (e.g., 8.5 for 8.5%)
* @returns {Object} - Tax breakdown
*/
CalculateTax(subtotal, taxRate) {
    taxAmount := Round(subtotal * (taxRate / 100), 2)
    total := Round(subtotal + taxAmount, 2)

    return {
        subtotal: Round(subtotal, 2),
        taxRate: taxRate,
        taxAmount: taxAmount,
        total: total
    }
}

; Example purchase
purchaseAmount := 99.99
salesTaxRate := 8.25

result := CalculateTax(purchaseAmount, salesTaxRate)

MsgBox("Sales Tax Calculation:`n`n"
. "Subtotal: " FormatCurrency(result.subtotal) "`n"
. "Tax Rate: " result.taxRate "%`n"
. "Tax Amount: " FormatCurrency(result.taxAmount) "`n"
. "Total: " FormatCurrency(result.total) "`n`n"
. "Calculation: " FormatCurrency(result.subtotal)
. " × " result.taxRate "% = " FormatCurrency(result.taxAmount),
"Tax Calculation", "Icon!")

; ============================================================
; Example 3: Discount Calculations
; ============================================================

/**
* Apply discount with rounding
*
* @param {Number} originalPrice - Original price
* @param {Number} discountPercent - Discount percentage
* @returns {Object} - Discount details
*/
ApplyDiscount(originalPrice, discountPercent) {
    discountAmount := Round(originalPrice * (discountPercent / 100), 2)
    finalPrice := Round(originalPrice - discountAmount, 2)
    savings := Round(discountAmount, 2)

    return {
        originalPrice: Round(originalPrice, 2),
        discountPercent: discountPercent,
        discountAmount: discountAmount,
        finalPrice: finalPrice,
        savings: savings
    }
}

; Test various discounts
items := [
{
    name: "Widget A", price: 49.99, discount: 20},
    {
        name: "Widget B", price: 125.50, discount: 15},
        {
            name: "Widget C", price: 199.99, discount: 25
        }
        ]

        output := "Discount Calculations:`n`n"

        for item in items {
            result := ApplyDiscount(item.price, item.discount)

            output .= item.name . ":`n"
            output .= "  Original: " FormatCurrency(result.originalPrice) "`n"
            output .= "  Discount: " result.discountPercent "%`n"
            output .= "  Save: " FormatCurrency(result.savings) "`n"
            output .= "  Pay: " FormatCurrency(result.finalPrice) "`n`n"
        }

        MsgBox(output, "Discount Calculator", "Icon!")

        ; ============================================================
        ; Example 4: Invoice Line Items
        ; ============================================================

        /**
        * Calculate invoice line item
        *
        * @param {Number} quantity - Item quantity
        * @param {Number} unitPrice - Price per unit
        * @param {Number} discountPercent - Discount percentage (default: 0)
        * @returns {Object} - Line item details
        */
        CalculateLineItem(quantity, unitPrice, discountPercent := 0) {
            subtotal := Round(quantity * unitPrice, 2)
            discount := Round(subtotal * (discountPercent / 100), 2)
            lineTotal := Round(subtotal - discount, 2)

            return {
                quantity: quantity,
                unitPrice: Round(unitPrice, 2),
                subtotal: subtotal,
                discountPercent: discountPercent,
                discountAmount: discount,
                lineTotal: lineTotal
            }
        }

        /**
        * Generate complete invoice
        *
        * @param {Array} lineItems - Array of line item data
        * @param {Number} taxRate - Tax rate percentage
        * @returns {Object} - Complete invoice
        */
        GenerateInvoice(lineItems, taxRate) {
            items := []
            subtotalBeforeTax := 0

            for item in lineItems {
                lineCalc := CalculateLineItem(item.qty, item.price, item.discount ?? 0)
                items.Push({
                    description: item.desc,
                    calculation: lineCalc
                })
                subtotalBeforeTax += lineCalc.lineTotal
            }

            subtotalBeforeTax := Round(subtotalBeforeTax, 2)
            taxAmount := Round(subtotalBeforeTax * (taxRate / 100), 2)
            grandTotal := Round(subtotalBeforeTax + taxAmount, 2)

            return {
                items: items,
                subtotal: subtotalBeforeTax,
                taxRate: taxRate,
                taxAmount: taxAmount,
                total: grandTotal
            }
        }

        ; Create sample invoice
        invoiceItems := [
        {
            desc: "Premium Widget", qty: 3, price: 29.99, discount: 10},
            {
                desc: "Standard Widget", qty: 5, price: 19.95, discount: 0},
                {
                    desc: "Budget Widget", qty: 10, price: 9.99, discount: 5
                }
                ]

                invoice := GenerateInvoice(invoiceItems, 7.5)

                output := "INVOICE`n"
                output .= "═══════════════════════════════════════`n`n"

                for item in invoice.items {
                    calc := item.calculation
                    output .= item.description . "`n"
                    output .= "  Qty: " calc.quantity
                    output .= " × " FormatCurrency(calc.unitPrice)
                    output .= " = " FormatCurrency(calc.subtotal)
                    if (calc.discountPercent > 0)
                    output .= " - " calc.discountPercent "% discount"
                    output .= "`n  Line Total: " FormatCurrency(calc.lineTotal) "`n`n"
                }

                output .= "───────────────────────────────────────`n"
                output .= "Subtotal: " FormatCurrency(invoice.subtotal) "`n"
                output .= "Tax (" invoice.taxRate "%): " FormatCurrency(invoice.taxAmount) "`n"
                output .= "═══════════════════════════════════════`n"
                output .= "TOTAL: " FormatCurrency(invoice.total) "`n"

                MsgBox(output, "Invoice Example", "Icon!")

                ; ============================================================
                ; Example 5: Interest Calculation
                ; ============================================================

                /**
                * Calculate simple interest
                *
                * @param {Number} principal - Initial amount
                * @param {Number} rate - Annual interest rate (percentage)
                * @param {Number} years - Time period in years
                * @returns {Object} - Interest calculation
                */
                CalculateSimpleInterest(principal, rate, years) {
                    interest := Round(principal * (rate / 100) * years, 2)
                    total := Round(principal + interest, 2)

                    return {
                        principal: Round(principal, 2),
                        rate: rate,
                        years: years,
                        interest: interest,
                        total: total
                    }
                }

                /**
                * Calculate compound interest
                *
                * @param {Number} principal - Initial amount
                * @param {Number} rate - Annual interest rate (percentage)
                * @param {Number} years - Time period in years
                * @param {Number} compoundsPerYear - Compounding frequency (default: 12)
                * @returns {Object} - Compound interest calculation
                */
                CalculateCompoundInterest(principal, rate, years, compoundsPerYear := 12) {
                    ; A = P(1 + r/n)^(nt)
                    rateDecimal := rate / 100
                    n := compoundsPerYear
                    t := years

                    total := principal * ((1 + rateDecimal / n) ** (n * t))
                    total := Round(total, 2)
                    interest := Round(total - principal, 2)

                    return {
                        principal: Round(principal, 2),
                        rate: rate,
                        years: years,
                        compoundsPerYear: compoundsPerYear,
                        interest: interest,
                        total: total
                    }
                }

                ; Compare simple vs compound interest
                initialAmount := 10000
                annualRate := 5
                timePeriod := 5

                simple := CalculateSimpleInterest(initialAmount, annualRate, timePeriod)
                compound := CalculateCompoundInterest(initialAmount, annualRate, timePeriod, 12)

                output := "Interest Comparison:`n`n"
                output .= "Principal: " FormatCurrency(initialAmount) "`n"
                output .= "Rate: " annualRate "% annual`n"
                output .= "Time: " timePeriod " years`n`n"

                output .= "SIMPLE INTEREST:`n"
                output .= "  Interest: " FormatCurrency(simple.interest) "`n"
                output .= "  Total: " FormatCurrency(simple.total) "`n`n"

                output .= "COMPOUND INTEREST (Monthly):`n"
                output .= "  Interest: " FormatCurrency(compound.interest) "`n"
                output .= "  Total: " FormatCurrency(compound.total) "`n`n"

                output .= "Difference: " FormatCurrency(compound.interest - simple.interest)

                MsgBox(output, "Interest Calculations", "Icon!")

                ; ============================================================
                ; Example 6: Split Bill Calculator
                ; ============================================================

                /**
                * Split bill among people with tip
                *
                * @param {Number} billAmount - Total bill
                * @param {Number} tipPercent - Tip percentage
                * @param {Number} numPeople - Number of people splitting
                * @returns {Object} - Split calculation
                */
                SplitBill(billAmount, tipPercent, numPeople) {
                    tipAmount := Round(billAmount * (tipPercent / 100), 2)
                    totalWithTip := Round(billAmount + tipAmount, 2)
                    perPerson := Round(totalWithTip / numPeople, 2)

                    ; Account for rounding (ensure total matches)
                    calculatedTotal := Round(perPerson * numPeople, 2)
                    difference := Round(totalWithTip - calculatedTotal, 2)

                    return {
                        billAmount: Round(billAmount, 2),
                        tipPercent: tipPercent,
                        tipAmount: tipAmount,
                        totalWithTip: totalWithTip,
                        numPeople: numPeople,
                        perPerson: perPerson,
                        roundingDiff: difference
                    }
                }

                ; Example restaurant bill
                restaurantBill := 127.50
                tipPercentage := 18
                numberOfPeople := 4

                split := SplitBill(restaurantBill, tipPercentage, numberOfPeople)

                output := "Bill Splitting:`n`n"
                output .= "Bill Amount: " FormatCurrency(split.billAmount) "`n"
                output .= "Tip (" split.tipPercent "%): " FormatCurrency(split.tipAmount) "`n"
                output .= "Total: " FormatCurrency(split.totalWithTip) "`n`n"
                output .= "Number of People: " split.numPeople "`n"
                output .= "Per Person: " FormatCurrency(split.perPerson) "`n`n"

                if (split.roundingDiff != 0)
                output .= "Note: Rounding difference of "
                . FormatCurrency(Abs(split.roundingDiff))
                else
                output .= "Perfect split - no rounding needed!"

                MsgBox(output, "Bill Splitter", "Icon!")

                ; ============================================================
                ; Example 7: Budget Allocation
                ; ============================================================

                /**
                * Allocate budget by percentages with rounding
                *
                * @param {Number} totalBudget - Total budget amount
                * @param {Object} categories - Category names and percentages
                * @returns {Object} - Allocation results
                */
                AllocateBudget(totalBudget, categories) {
                    allocations := []
                    allocatedSum := 0

                    ; Calculate allocations
                    for category, percent in categories {
                        amount := Round(totalBudget * (percent / 100), 2)
                        allocations.Push({
                            category: category,
                            percent: percent,
                            amount: amount
                        })
                        allocatedSum += amount
                    }

                    allocatedSum := Round(allocatedSum, 2)
                    remaining := Round(totalBudget - allocatedSum, 2)

                    return {
                        totalBudget: Round(totalBudget, 2),
                        allocations: allocations,
                        allocatedSum: allocatedSum,
                        remaining: remaining
                    }
                }

                ; Create monthly budget
                monthlyIncome := 5000
                budgetCategories := Map(
                "Housing", 30,
                "Food", 20,
                "Transportation", 15,
                "Savings", 20,
                "Entertainment", 10,
                "Other", 5
                )

                budgetPlan := AllocateBudget(monthlyIncome, budgetCategories)

                output := "Monthly Budget Allocation:`n`n"
                output .= "Total Income: " FormatCurrency(budgetPlan.totalBudget) "`n`n"

                for allocation in budgetPlan.allocations {
                    output .= allocation.category . ": "
                    output .= allocation.percent . "% = "
                    output .= FormatCurrency(allocation.amount) "`n"
                }

                output .= "`n"
                output .= "Allocated: " FormatCurrency(budgetPlan.allocatedSum) "`n"

                if (budgetPlan.remaining != 0)
                output .= "Rounding Adjustment: " FormatCurrency(budgetPlan.remaining)
                else
                output .= "Perfect allocation!"

                MsgBox(output, "Budget Planner", "Icon!")

                ; ============================================================
                ; Reference Information
                ; ============================================================

                info := "
                (
                ROUND() IN FINANCIAL APPLICATIONS:

                Currency Rounding:
                ──────────────────
                Always use 2 decimal places:
                amount := Round(value, 2)
                display := Format('${1:.2f}', amount)

                Tax Calculations:
                ─────────────────
                Round after each step:
                1. Subtotal: Round(qty × price, 2)
                2. Tax: Round(subtotal × rate, 2)
                3. Total: Round(subtotal + tax, 2)

                Discount Formula:
                ─────────────────
                discount := Round(price × (percent / 100), 2)
                final := Round(price - discount, 2)

                Interest Calculations:
                ──────────────────────
                Simple Interest:
                I = Round(P × r × t, 2)

                Compound Interest:
                A = Round(P × (1 + r/n)^(nt), 2)

                Best Practices:
                ───────────────
                ✓ Always round to 2 decimals for currency
                ✓ Round after each calculation step
                ✓ Never round intermediate values in formulas
                ✓ Watch for cumulative rounding errors
                ✓ Account for penny differences when splitting
                ✓ Use banker's rounding (built-in to Round())
                ✓ Display with Format('{1:.2f}', amount)

                Common Pitfalls:
                ────────────────
                ✗ Rounding too early in calculation chain
                ✗ Not rounding final display values
                ✗ Forgetting to handle penny differences
                ✗ Using more than 2 decimals for currency
                ✗ Not validating totals match sum of parts

                Rounding Errors:
                ────────────────
                When splitting amounts, totals may not match
                due to rounding. Always verify:

                perPerson := Round(total / count, 2)
                check := Round(perPerson × count, 2)
                difference := total - check

                If difference ≠ 0, adjust last person's share

                Financial Functions:
                ────────────────────
                • RoundCurrency(amount) → 2 decimals
                • CalculateTax(subtotal, rate)
                • ApplyDiscount(price, percent)
                • CalculateLineItem(qty, price)
                • SplitBill(total, tip, people)
                • AllocateBudget(total, percentages)
                )"

                MsgBox(info, "Financial Rounding Reference", "Icon!")
