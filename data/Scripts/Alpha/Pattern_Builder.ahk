#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Builder Pattern - Constructs complex objects step by step
; Demonstrates fluent interface with method chaining

class QueryBuilder {
    __New() {
        this.table := ""
        this.columns := ["*"]
        this.conditions := []
        this.orderBy := ""
        this.limitCount := 0
    }

    From(table) {
        this.table := table
        return this
    }

    Select(cols*) {
        this.columns := cols
        return this
    }

    Where(condition) {
        this.conditions.Push(condition)
        return this
    }

    Order(column, direction := "ASC") {
        this.orderBy := column " " direction
        return this
    }

    Limit(count) {
        this.limitCount := count
        return this
    }

    Build() {
        sql := "SELECT " this.Join(this.columns, ", ") " FROM " this.table

        if this.conditions.Length
            sql .= " WHERE " this.Join(this.conditions, " AND ")

        if this.orderBy
            sql .= " ORDER BY " this.orderBy

        if this.limitCount
            sql .= " LIMIT " this.limitCount

        return sql
    }

    Join(arr, sep) {
        result := ""
        for i, v in arr
            result .= (i > 1 ? sep : "") v
        return result
    }
}

; Demo - fluent interface
sql := QueryBuilder()
    .From("users")
    .Select("id", "name", "email")
    .Where("active = 1")
    .Where("age > 18")
    .Order("name")
    .Limit(10)
    .Build()

MsgBox(sql)
