#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Feature: Nested Classes and Namespacing
; Demonstrates: Inner classes, logical grouping, encapsulation of related types

class Database {


    ; Database main class
    __New(host := "localhost", port := 3306) => (this.conn := Database.Connection(host, port), this.queryLog := [])

    Connect() => this.conn.Open()
    Disconnect() => this.conn.Close()

    CreateQuery() => Database.Query(this)
    CreateTransaction() => Database.Transaction(this)

    Run(sql) {
        this.queryLog.Push(sql)
        MsgBox("Executing: " sql)
        return { success: true, rows: Random(1, 100) }
    }

    GetQueryLog() => this.queryLog
}

; Usage - nested classes provide clean organization
db := Database("localhost", 3306)
db.Connect()

; Use nested Query class
query := db.CreateQuery()
    .Select("id", "name", "email")
    .From("users")
    .Where("age > 18")
    .Execute()

MsgBox("Query returned " query.rows " rows")

; Use nested Transaction class
transaction := db.CreateTransaction()
transaction.Begin()
    .Add("INSERT INTO users VALUES (1, 'Alice')")
    .Add("INSERT INTO users VALUES (2, 'Bob')")
    .Add("UPDATE users SET status = 'active'")
    .Commit()

; Access connection info
MsgBox("Connected: " (db.conn.IsConnected() ? "Yes" : "No"))

db.Disconnect()

; Show query log
MsgBox("Query Log:`n" db.GetQueryLog().Join("`n"))

; Moved class Query from nested scope
class Query {
    __New(db) => (this.db := db, this.sql := "")

    Select(fields*) => (this.sql := "SELECT " this._Join(fields), this)
    From(table) => (this.sql .= " FROM " table, this)
    Where(condition) => (this.sql .= " WHERE " condition, this)
    Execute() => this.db.Run(this.sql)

    _Join(arr) {
        result := ""
        for item in arr
            result .= (result ? ", " : "") item
        return result ? result : "*"
    }
}

; Moved class Transaction from nested scope
class Transaction {
    __New(db) => (this.db := db, this.operations := [], this.active := false)

    Begin() => (this.active := true, this.operations := [], MsgBox("Transaction started"))
    Add(operation) => (this.operations.Push(operation), this)
    Commit() => (this._Execute(), this.active := false, MsgBox("Transaction committed: " this.operations.Length " operations"))
    Rollback() => (this.operations := [], this.active := false, MsgBox("Transaction rolled back"))

    _Execute() {
        for op in this.operations
            this.db.Run(op)
    }
}

; Moved class Connection from nested scope
class Connection {
    __New(host, port) => (this.host := host, this.port := port, this.connected := false)

    Open() => (this.connected := true, MsgBox("Connected to " this.host ":" this.port))
    Close() => (this.connected := false, MsgBox("Connection closed"))
    IsConnected() => this.connected
}
