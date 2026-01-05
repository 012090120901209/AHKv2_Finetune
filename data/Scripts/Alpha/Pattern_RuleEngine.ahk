#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Rule Engine - Business rules evaluation
; Demonstrates declarative rule processing

class RuleEngine {
    __New() {
        this.rules := []
    }

    AddRule(rule) {
        this.rules.Push(rule)
        ; Sort by priority (higher first)
        this._sort()
        return this
    }

    _sort() {
        ; Simple bubble sort by priority
        Loop this.rules.Length - 1 {
            i := A_Index
            Loop this.rules.Length - i {
                j := i + A_Index
                if this.rules[j].priority > this.rules[i].priority {
                    temp := this.rules[i]
                    this.rules[i] := this.rules[j]
                    this.rules[j] := temp
                }
            }
        }
    }

    Evaluate(facts) {
        results := []
        context := Map("facts", facts, "fired", [])

        for rule in this.rules {
            if rule.Evaluate(facts) {
                result := rule.Execute(facts, context)
                results.Push(Map(
                    "rule", rule.name,
                    "result", result
                ))
                context["fired"].Push(rule.name)

                if rule.stopOnFire
                    break
            }
        }

        return Map(
            "results", results,
            "firedRules", context["fired"]
        )
    }
}

class Rule {
    __New(name, options := "") {
        this.name := name
        this.conditions := []
        this.actions := []
        this.priority := options.Has("priority") ? options["priority"] : 0
        this.stopOnFire := options.Has("stopOnFire") ? options["stopOnFire"] : false
    }

    When(condition) {
        this.conditions.Push(condition)
        return this
    }

    Then(action) {
        this.actions.Push(action)
        return this
    }

    Evaluate(facts) {
        for condition in this.conditions {
            if !condition(facts)
                return false
        }
        return true
    }

    Execute(facts, context) {
        results := []
        for action in this.actions
            results.Push(action(facts, context))
        return results
    }
}

; Condition builders
class Conditions {
    static Equals(field, value) => (facts) => facts.Has(field) && facts[field] = value
    static GreaterThan(field, value) => (facts) => facts.Has(field) && facts[field] > value
    static LessThan(field, value) => (facts) => facts.Has(field) && facts[field] < value
    static Between(field, min, max) => (facts) => facts.Has(field) && facts[field] >= min && facts[field] <= max
    static Contains(field, value) => (facts) => facts.Has(field) && InStr(facts[field], value)
    static In(field, values) {
        return (facts) {
            if !facts.Has(field)
                return false
            for v in values
                if facts[field] = v
                    return true
            return false
        }
    }
    static Custom(fn) => fn
}

; Demo - Discount rules
engine := RuleEngine()

; VIP discount rule
vipRule := Rule("VIP Discount", Map("priority", 100, "stopOnFire", true))
    .When(Conditions.Equals("customerType", "VIP"))
    .Then((facts, ctx) => Map("discount", 0.20, "message", "VIP 20% discount applied"))

; Large order discount
largeOrderRule := Rule("Large Order Discount", Map("priority", 80))
    .When(Conditions.GreaterThan("orderTotal", 500))
    .Then((facts, ctx) => Map("discount", 0.10, "message", "Large order 10% discount"))

; Holiday discount
holidayRule := Rule("Holiday Discount", Map("priority", 50))
    .When(Conditions.Equals("isHoliday", true))
    .Then((facts, ctx) => Map("discount", 0.05, "message", "Holiday 5% discount"))

; New customer bonus
newCustomerRule := Rule("New Customer Bonus", Map("priority", 60))
    .When(Conditions.Equals("isNewCustomer", true))
    .Then((facts, ctx) => Map("bonus", 10, "message", "New customer $10 bonus"))

engine.AddRule(vipRule)
    .AddRule(largeOrderRule)
    .AddRule(holidayRule)
    .AddRule(newCustomerRule)

; Test cases
testCases := [
    Map("customerType", "VIP", "orderTotal", 100, "isHoliday", false, "isNewCustomer", false),
    Map("customerType", "Regular", "orderTotal", 600, "isHoliday", true, "isNewCustomer", false),
    Map("customerType", "Regular", "orderTotal", 200, "isHoliday", false, "isNewCustomer", true)
]

result := "Rule Engine Demo:`n`n"

for facts in testCases {
    result .= "Facts: "
    for k, v in facts
        result .= k "=" v " "
    result .= "`n"

    evalResult := engine.Evaluate(facts)
    result .= "Fired rules: "
    for r in evalResult["firedRules"]
        result .= r " "
    result .= "`n"

    for r in evalResult["results"] {
        for rr in r["result"] {
            for k, v in rr
                result .= "  " k ": " v "`n"
        }
    }
    result .= "`n"
}

MsgBox(result)
