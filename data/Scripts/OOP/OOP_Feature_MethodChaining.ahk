#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Feature: Method Chaining (Fluent Interface)
; Demonstrates: Return this, builder pattern, readable code

class QueryBuilder {
    __New(table) => (this.table := table, this.conditions := [], this.orderBy := "", this.limitValue := 0)

    Where(field, operator, value) => (this.conditions.Push(Format("{} {} '{}'", field, operator, value)), this)
    And(field, operator, value) => this.Where(field, operator, value)
    OrderBy(field, direction := "ASC") => (this.orderBy := field " " direction, this)
    Limit(count) => (this.limitValue := count, this)

    Build() {
        query := "SELECT * FROM " this.table
        if (this.conditions.Length > 0)
        query .= " WHERE " this.Join(this.conditions, " AND ")
        if (this.orderBy)
        query .= " ORDER BY " this.orderBy
        if (this.limitValue > 0)
        query .= " LIMIT " this.limitValue
        return query
    }

    Join(arr, delimiter) {
        result := ""
        for item in arr
        result .= (result ? delimiter : "") item
        return result
    }
}

class StringBuilder {
    __New(initial := "") => this.buffer := [initial]

    Append(text) => (this.buffer.Push(text), this)
    AppendLine(text := "") => (this.buffer.Push(text "`n"), this)
    AppendFormat(format, values*) => (this.buffer.Push(Format(format, values*)), this)
    Clear() => (this.buffer := [], this)

    ToString() {
        result := ""
        for text in this.buffer
        result .= text
        return result
    }
}

; Elegant query building
query := QueryBuilder("users")
.Where("age", ">", 18)
.And("status", "=", "active")
.OrderBy("name", "ASC")
.Limit(10)
.Build()

MsgBox(query)

; Fluent string building
html := StringBuilder()
.AppendLine("<html>")
.AppendLine("<body>")
.AppendFormat("  <h1>{}</h1>`n", "Welcome")
.AppendFormat("  <p>{}</p>`n", "This is a test")
.AppendLine("</body>")
.AppendLine("</html>")
.ToString()

MsgBox(html)
