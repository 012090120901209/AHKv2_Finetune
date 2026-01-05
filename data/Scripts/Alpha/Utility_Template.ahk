#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Template Engine - Simple mustache-style templating
; Demonstrates string interpolation and iteration

class Template {
    __New(template) => this.template := template

    Render(data) {
        result := this.template

        ; Simple variable replacement {{key}}
        for key, value in data {
            if !IsObject(value)
                result := StrReplace(result, "{{" key "}}", String(value))
        }

        ; Conditional blocks {{#if key}}...{{/if}}
        while RegExMatch(result, "\{\{#if\s+(\w+)\}\}(.*?)\{\{/if\}\}", &m) {
            key := m[1]
            content := m[2]
            replacement := ""

            if data.Has(key) && data[key]
                replacement := content

            result := StrReplace(result, m[0], replacement)
        }

        ; Each loops {{#each items}}...{{/each}}
        while RegExMatch(result, "\{\{#each\s+(\w+)\}\}(.*?)\{\{/each\}\}", &m) {
            key := m[1]
            itemTemplate := m[2]
            replacement := ""

            if data.Has(key) && IsObject(data[key]) {
                items := data[key]
                for item in items {
                    itemResult := itemTemplate

                    if IsObject(item) && item is Map {
                        for k, v in item
                            itemResult := StrReplace(itemResult, "{{" k "}}", String(v))
                    } else {
                        itemResult := StrReplace(itemResult, "{{this}}", String(item))
                    }

                    itemResult := StrReplace(itemResult, "{{@index}}", String(A_Index))
                    replacement .= itemResult
                }
            }

            result := StrReplace(result, m[0], replacement)
        }

        return result
    }
}

; Demo - Simple template
simple := Template("Hello, {{name}}! You have {{count}} messages.")
result := simple.Render(Map("name", "Alice", "count", 5))
MsgBox("Simple:`n" result)

; Demo - Conditional
conditional := Template("
(
Welcome, {{name}}!
{{#if isPremium}}You are a premium member.{{/if}}
{{#if isAdmin}}Admin panel available.{{/if}}
)")

result := conditional.Render(Map("name", "Bob", "isPremium", true, "isAdmin", false))
MsgBox("Conditional:`n" result)

; Demo - Iteration
listTemplate := Template("
(
Users:
{{#each users}}- {{name}} ({{email}})
{{/each}}

Tags: {{#each tags}}{{this}} {{/each}}
)")

data := Map(
    "users", [
        Map("name", "Alice", "email", "alice@example.com"),
        Map("name", "Bob", "email", "bob@example.com"),
        Map("name", "Charlie", "email", "charlie@example.com")
    ],
    "tags", ["ahk", "v2", "alpha", "modern"]
)

result := listTemplate.Render(data)
MsgBox("Iteration:`n" result)
