#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Decision Table - Table-driven decision logic
; Demonstrates declarative decision making

class DecisionTable {
    __New(columns) {
        this.columns := columns  ; Array of condition column names
        this.rules := []
        this.defaultAction := ""
    }

    AddRule(conditions, action) {
        this.rules.Push(Map("conditions", conditions, "action", action))
        return this
    }

    SetDefault(action) {
        this.defaultAction := action
        return this
    }

    Evaluate(input) {
        for rule in this.rules {
            if this._matchConditions(rule["conditions"], input)
                return this._executeAction(rule["action"], input)
        }

        if this.defaultAction
            return this._executeAction(this.defaultAction, input)

        return ""
    }

    _matchConditions(conditions, input) {
        for i, col in this.columns {
            if i > conditions.Length
                continue

            condition := conditions[i]

            ; Skip wildcard conditions
            if condition = "*" || condition = "any"
                continue

            if !input.Has(col)
                return false

            value := input[col]

            ; Handle different condition types
            if IsObject(condition) {
                ; Range check
                if condition.Has("min") && value < condition["min"]
                    return false
                if condition.Has("max") && value > condition["max"]
                    return false
                if condition.Has("in") {
                    found := false
                    for v in condition["in"]
                        if value = v
                            found := true
                    if !found
                        return false
                }
            } else if condition != value {
                return false
            }
        }
        return true
    }

    _executeAction(action, input) {
        if action is Func
            return action(input)
        return action
    }

    ; Pretty print the table
    ToString() {
        result := "| "
        for col in this.columns
            result .= Format("{:-15}", col) " | "
        result .= "Action |`n"
        result .= "|" StrReplace(Format("{:-" (17 * this.columns.Length + 10) "}", ""), " ", "-") "|`n"

        for rule in this.rules {
            result .= "| "
            for i, col in this.columns {
                cond := i <= rule["conditions"].Length ? rule["conditions"][i] : "*"
                if IsObject(cond)
                    cond := "[complex]"
                result .= Format("{:-15}", String(cond)) " | "
            }
            action := rule["action"]
            if action is Func
                action := "[function]"
            result .= action " |`n"
        }

        return result
    }
}

; Demo - Shipping cost calculator
shippingTable := DecisionTable(["weight", "zone", "express"])

; Weight ranges use object conditions
shippingTable
    .AddRule([Map("max", 1), "domestic", false], 5.99)
    .AddRule([Map("max", 1), "domestic", true], 9.99)
    .AddRule([Map("min", 1, "max", 5), "domestic", false], 8.99)
    .AddRule([Map("min", 1, "max", 5), "domestic", true], 14.99)
    .AddRule([Map("min", 5), "domestic", false], 12.99)
    .AddRule([Map("min", 5), "domestic", true], 24.99)
    .AddRule(["*", "international", false], 25.99)
    .AddRule(["*", "international", true], 45.99)
    .SetDefault(0)

; Test cases
tests := [
    Map("weight", 0.5, "zone", "domestic", "express", false),
    Map("weight", 3, "zone", "domestic", "express", true),
    Map("weight", 10, "zone", "domestic", "express", false),
    Map("weight", 2, "zone", "international", "express", false),
    Map("weight", 2, "zone", "international", "express", true)
]

result := "Shipping Cost Decision Table:`n`n"

for test in tests {
    cost := shippingTable.Evaluate(test)
    result .= Format("Weight: {}kg, Zone: {}, Express: {} => ${:.2f}`n",
                     test["weight"], test["zone"], test["express"], cost)
}

MsgBox(result)

; Demo - Discount eligibility
discountTable := DecisionTable(["memberType", "orderCount", "orderTotal"])

discountTable
    .AddRule(["gold", "*", "*"], (input) => Map("discount", 0.15, "reason", "Gold member"))
    .AddRule(["silver", Map("min", 10), "*"], (input) => Map("discount", 0.10, "reason", "Silver + loyal"))
    .AddRule(["silver", "*", Map("min", 500)], (input) => Map("discount", 0.08, "reason", "Silver + big order"))
    .AddRule(["silver", "*", "*"], (input) => Map("discount", 0.05, "reason", "Silver member"))
    .AddRule(["*", Map("min", 20), "*"], (input) => Map("discount", 0.05, "reason", "Loyal customer"))
    .AddRule(["*", "*", Map("min", 1000)], (input) => Map("discount", 0.03, "reason", "Large order"))
    .SetDefault(Map("discount", 0, "reason", "No discount"))

tests := [
    Map("memberType", "gold", "orderCount", 5, "orderTotal", 100),
    Map("memberType", "silver", "orderCount", 15, "orderTotal", 200),
    Map("memberType", "silver", "orderCount", 3, "orderTotal", 600),
    Map("memberType", "bronze", "orderCount", 25, "orderTotal", 100),
    Map("memberType", "bronze", "orderCount", 3, "orderTotal", 50)
]

result := "Discount Decision Table:`n`n"

for test in tests {
    r := discountTable.Evaluate(test)
    result .= Format("{} member, {} orders, ${} total => {}% ({})`n",
                     test["memberType"], test["orderCount"], test["orderTotal"],
                     Round(r["discount"] * 100), r["reason"])
}

MsgBox(result)
