#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * CLR - Database Access with ADO.NET
 * 
 * Demonstrates using .NET ADO.NET for database operations including
 * SQLite connections, queries, and data manipulation.
 * 
 * Library: https://github.com/Lexikos/CLR.ahk
 */

MsgBox("CLR - Database Example`n`n"
    . "Demonstrates ADO.NET database access`n"
    . "Requires: CLR.ahk and .NET Framework 4.0+", , "T3")

/*
; Uncomment to run (requires CLR.ahk and System.Data.SQLite):

#Include <CLR>

; Initialize CLR
CLR_Start("v4.0.30319")

; Compile database helper
dbCode := "
(
using System;
using System.Data;
using System.Data.SQLite;

public class DatabaseHelper {
    private SQLiteConnection conn;

    public void Connect(string dbPath) {
        string connStr = ""Data Source="" + dbPath + "";Version=3;"";
        conn = new SQLiteConnection(connStr);
        conn.Open();
    }

    public void Close() {
        if (conn != null) {
            conn.Close();
            conn.Dispose();
        }
    }

    public void CreateTable() {
        string sql = @""
        CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        age INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )"";

        using (SQLiteCommand cmd = new SQLiteCommand(sql, conn)) {
            cmd.ExecuteNonQuery();
        }
    }

    public void InsertUser(string name, string email, int age) {
        string sql = ""INSERT INTO users (name, email, age) VALUES (@name, @email, @age)"";

        using (SQLiteCommand cmd = new SQLiteCommand(sql, conn)) {
            cmd.Parameters.AddWithValue(""@name"", name);
            cmd.Parameters.AddWithValue(""@email"", email);
            cmd.Parameters.AddWithValue(""@age"", age);
            cmd.ExecuteNonQuery();
        }
    }

    public DataTable GetAllUsers() {
        string sql = ""SELECT * FROM users ORDER BY id"";
        DataTable dt = new DataTable();

        using (SQLiteCommand cmd = new SQLiteCommand(sql, conn))
        using (SQLiteDataAdapter adapter = new SQLiteDataAdapter(cmd)) {
            adapter.Fill(dt);
        }

        return dt;
    }

    public DataTable SearchUsers(string searchTerm) {
        string sql = ""SELECT * FROM users WHERE name LIKE @term OR email LIKE @term"";
        DataTable dt = new DataTable();

        using (SQLiteCommand cmd = new SQLiteCommand(sql, conn)) {
            cmd.Parameters.AddWithValue(""@term"", ""%"" + searchTerm + ""%"");
            using (SQLiteDataAdapter adapter = new SQLiteDataAdapter(cmd)) {
                adapter.Fill(dt);
            }
        }

        return dt;
    }

    public void UpdateUser(int id, string name, string email, int age) {
        string sql = ""UPDATE users SET name=@name, email=@email, age=@age WHERE id=@id"";

        using (SQLiteCommand cmd = new SQLiteCommand(sql, conn)) {
            cmd.Parameters.AddWithValue(""@id"", id);
            cmd.Parameters.AddWithValue(""@name"", name);
            cmd.Parameters.AddWithValue(""@email"", email);
            cmd.Parameters.AddWithValue(""@age"", age);
            cmd.ExecuteNonQuery();
        }
    }

    public void DeleteUser(int id) {
        string sql = ""DELETE FROM users WHERE id=@id"";

        using (SQLiteCommand cmd = new SQLiteCommand(sql, conn)) {
            cmd.Parameters.AddWithValue(""@id"", id);
            cmd.ExecuteNonQuery();
        }
    }

    public int GetUserCount() {
        string sql = ""SELECT COUNT(*) FROM users"";

        using (SQLiteCommand cmd = new SQLiteCommand(sql, conn)) {
            return Convert.ToInt32(cmd.ExecuteScalar());
        }
    }
}
)"

; Compile with SQLite reference
refs := "System.dll|System.Data.dll|System.Data.SQLite.dll"
asm := CLR_CompileCS(dbCode, refs)
DB := CLR_CreateObject(asm, "DatabaseHelper")

; Connect to database
dbPath := A_ScriptDir "\test.db"
DB.Connect(dbPath)

; Create table
DB.CreateTable()

; Insert users
DB.InsertUser("Alice Johnson", "alice@example.com", 30)
DB.InsertUser("Bob Smith", "bob@example.com", 25)
DB.InsertUser("Charlie Brown", "charlie@example.com", 35)

; Get all users
users := DB.GetAllUsers()
result := "All Users:`n`n"
Loop users.Rows.Count {
    row := users.Rows.Item(A_Index - 1)
    result .= row.Item("id") ": "
    . row.Item("name") " ("
    . row.Item("email") ", age "
    . row.Item("age") ")`n"
}
MsgBox(result, , "T5")

; Search users
searchResults := DB.SearchUsers("alice")
MsgBox("Search for 'alice': Found " searchResults.Rows.Count " users", , "T3")

; Update user
DB.UpdateUser(1, "Alice Cooper", "alice.cooper@example.com", 31)
MsgBox("Updated user ID 1", , "T2")

; Get count
count := DB.GetUserCount()
MsgBox("Total users: " count, , "T2")

; Delete user
DB.DeleteUser(2)
MsgBox("Deleted user ID 2", , "T2")

; Final count
finalCount := DB.GetUserCount()
MsgBox("Final user count: " finalCount, , "T2")

; Close connection
DB.Close()

; Clean up test database
FileDelete(dbPath)
MsgBox("Database example completed and cleaned up", , "T3")
*/

/*
* Key Concepts:
*
* 1. ADO.NET Components:
*    Connection - Database connection
*    Command - SQL execution
*    DataReader - Forward-only reader
*    DataAdapter - Fill DataTable
*    DataTable - In-memory table
*
* 2. Connection String:
*    SQLite: "Data Source=path;Version=3;"
*    SQL Server: "Server=.;Database=db;..."
*    MySQL: "Server=localhost;Database=db;..."
*
* 3. Parameterized Queries:
*    cmd.Parameters.AddWithValue("@name", value)
*    Prevents SQL injection
*    Handles escaping automatically
*
* 4. CRUD Operations:
*    Create: INSERT INTO
*    Read: SELECT FROM
*    Update: UPDATE SET WHERE
*    Delete: DELETE FROM WHERE
*
* 5. DataTable Access:
*    dt.Rows.Count - Row count
*    dt.Rows.Item(index) - Get row
*    row.Item("column") - Get value
*
* 6. Using Statements:
*    using (obj) { } - Auto-dispose
*    Critical for database objects
*    Releases connections
*
* 7. ExecuteNonQuery:
*    For INSERT, UPDATE, DELETE
*    Returns rows affected
*    No result set
*
* 8. ExecuteScalar:
*    For single value (COUNT, MAX)
*    Returns first column first row
*    Efficient for aggregates
*
* 9. ExecuteReader:
*    For reading multiple rows
*    Forward-only, fast
*    Manual iteration
*
* 10. Database Providers:
*     System.Data.SQLite - SQLite
*     System.Data.SqlClient - SQL Server
*     MySql.Data - MySQL
*     Npgsql - PostgreSQL
*
* 11. Use Cases:
*     ✅ Application settings
*     ✅ User management
*     ✅ Logging systems
*     ✅ Data caching
*     ✅ Report generation
*
* 12. Best Practices:
*     ✅ Always use parameters
*     ✅ Close connections
*     ✅ Use transactions for multiple ops
*     ✅ Handle exceptions
*     ✅ Index frequently queried columns
*/

