#Requires AutoHotkey v2.0

; Library: RaptorX/SQLite
; Function: Execute SQL queries
; Category: Database
; Use Case: Local data storage, structured data management

; Example: SQLite database operations
; Note: Requires SQLite.ahk from RaptorX/SQLite

; #Include <SQLite>

DemoSQLite() {
    MsgBox("SQLite Database Demo`n`n"
          "Local database operations:`n`n"
          "Basic usage:`n"
          "db := SQLite('mydb.db')`n"
          "db.Exec('CREATE TABLE users (id, name)')`n"
          "db.Exec('INSERT INTO users VALUES (1, 'John')')`n"
          "result := db.Query('SELECT * FROM users')`n`n"
          "Features:`n"
          "- Lightweight file-based database`n"
          "- Full SQL support`n"
          "- Transactions`n"
          "- Prepared statements`n`n"
          "Use cases:`n"
          "- App settings storage`n"
          "- Data caching`n"
          "- Log management`n"
          "- Structured data processing`n`n"
          "Install: Download from RaptorX/SQLite",
          "SQLite Demo")
}

; Real implementation example (commented out, requires library):
/*
CreateAndQueryDatabase() {
    ; Open/create database
    db := SQLite("example.db")

    ; Create table
    db.Exec("
    (
        CREATE TABLE IF NOT EXISTS tasks (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            completed INTEGER DEFAULT 0,
            created_at TEXT
        )
    )")

    ; Insert data
    db.Exec("INSERT INTO tasks (title, created_at) VALUES ('Task 1', datetime('now'))")
    db.Exec("INSERT INTO tasks (title, created_at) VALUES ('Task 2', datetime('now'))")

    ; Query data
    result := db.Query("SELECT * FROM tasks WHERE completed = 0")

    ; Display results
    output := "Pending Tasks:`n"
    for row in result {
        output .= row.id ": " row.title " (created: " row.created_at ")`n"
    }

    MsgBox(output)

    ; Close database
    db.Close()
}
*/

; Run demonstration
DemoSQLite()
