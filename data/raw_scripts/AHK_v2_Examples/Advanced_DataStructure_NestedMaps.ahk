#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Data Structure Example: Nested Maps and Complex Data
; Demonstrates: Map objects, nested structures, data manipulation

; Create complex nested data structure (like JSON)
database := Map()

; Add users with nested data
database["users"] := Map(
    "user001", Map(
        "name", "John Doe",
        "email", "john@example.com",
        "age", 30,
        "roles", ["admin", "developer"],
        "settings", Map(
            "theme", "dark",
            "notifications", true,
            "language", "en"
        )
    ),
    "user002", Map(
        "name", "Jane Smith",
        "email", "jane@example.com",
        "age", 28,
        "roles", ["developer", "tester"],
        "settings", Map(
            "theme", "light",
            "notifications", false,
            "language", "en"
        )
    )
)

; Add projects
database["projects"] := Map(
    "proj001", Map(
        "name", "Website Redesign",
        "status", "active",
        "members", ["user001", "user002"],
        "tasks", 15,
        "completed", 8
    ),
    "proj002", Map(
        "name", "Mobile App",
        "status", "planning",
        "members", ["user001"],
        "tasks", 25,
        "completed", 0
    )
)

; Function to display data structure
DisplayDatabase() {
    global database

    output := "DATABASE CONTENTS:`n`n"

    ; Display users
    output .= "=== USERS ===`n"
    for userId, userData in database["users"] {
        output .= "User ID: " userId "`n"
        output .= "  Name: " userData["name"] "`n"
        output .= "  Email: " userData["email"] "`n"
        output .= "  Age: " userData["age"] "`n"
        output .= "  Roles: " ArrayToString(userData["roles"]) "`n"
        output .= "  Theme: " userData["settings"]["theme"] "`n"
        output .= "`n"
    }

    ; Display projects
    output .= "=== PROJECTS ===`n"
    for projId, projData in database["projects"] {
        output .= "Project ID: " projId "`n"
        output .= "  Name: " projData["name"] "`n"
        output .= "  Status: " projData["status"] "`n"
        output .= "  Progress: " projData["completed"] "/" projData["tasks"] " tasks`n"
        output .= "  Members: " ArrayToString(projData["members"]) "`n"
        output .= "`n"
    }

    MsgBox(output, "Database Contents")
}

; Helper function to convert array to string
ArrayToString(arr) {
    if (arr.Length = 0)
        return "[]"

    result := ""
    for item in arr {
        result .= (result ? ", " : "") item
    }
    return "[" result "]"
}

; Query functions
GetUserName(userId) {
    global database
    return database["users"].Has(userId) ? database["users"][userId]["name"] : "Unknown"
}

GetProjectProgress(projId) {
    global database
    if (!database["projects"].Has(projId))
        return 0

    proj := database["projects"][projId]
    return Round((proj["completed"] / proj["tasks"]) * 100)
}

FindUsersByRole(role) {
    global database
    results := []

    for userId, userData in database["users"] {
        for r in userData["roles"] {
            if (r = role) {
                results.Push(userId)
                break
            }
        }
    }

    return results
}

; Add new user function
AddUser(userId, name, email, age) {
    global database

    database["users"][userId] := Map(
        "name", name,
        "email", email,
        "age", age,
        "roles", [],
        "settings", Map(
            "theme", "light",
            "notifications", true,
            "language", "en"
        )
    )

    MsgBox("User added: " name, "Success")
}

; Update user setting
UpdateUserSetting(userId, setting, value) {
    global database

    if (!database["users"].Has(userId))
        return MsgBox("User not found!", "Error")

    database["users"][userId]["settings"][setting] := value
    MsgBox("Updated " setting " for user " userId, "Success")
}

; GUI for data exploration
myGui := Gui()
myGui.Title := "Nested Data Structure Explorer"

myGui.Add("Text", "x10 y10", "Operations:")

myGui.Add("Button", "x10 y35 w150", "Show All Data").OnEvent("Click", (*) => DisplayDatabase())
myGui.Add("Button", "x170 y35 w150", "Find Developers").OnEvent("Click", FindDevs)
myGui.Add("Button", "x330 y35 w150", "Show Progress").OnEvent("Click", ShowProgress)

myGui.Add("GroupBox", "x10 y75 w470 h100", "Add New User")
myGui.Add("Text", "x20 y100", "User ID:")
userIdInput := myGui.Add("Edit", "x100 y97 w100")
myGui.Add("Text", "x220 y100", "Name:")
nameInput := myGui.Add("Edit", "x270 y97 w200")
myGui.Add("Text", "x20 y130", "Email:")
emailInput := myGui.Add("Edit", "x100 y127 w200")
myGui.Add("Text", "x320 y130", "Age:")
ageInput := myGui.Add("Edit", "x360 y127 w50 Number")
myGui.Add("Button", "x420 y127 w50", "Add").OnEvent("Click", AddUserBtn)

myGui.Add("GroupBox", "x10 y185 w470 h100", "Query Results")
resultText := myGui.Add("Edit", "x20 y205 w450 h65 ReadOnly Multi")

myGui.Show("w490 h300")

FindDevs(*) {
    global resultText
    devs := FindUsersByRole("developer")

    output := "Developers found: " devs.Length "`n`n"
    for userId in devs {
        output .= userId ": " GetUserName(userId) "`n"
    }

    resultText.Value := output
}

ShowProgress(*) {
    global resultText, database

    output := "Project Progress:`n`n"
    for projId, projData in database["projects"] {
        progress := GetProjectProgress(projId)
        output .= projData["name"] ": " progress "% complete`n"
    }

    resultText.Value := output
}

AddUserBtn(*) {
    global userIdInput, nameInput, emailInput, ageInput

    userId := userIdInput.Value
    name := nameInput.Value
    email := emailInput.Value
    age := ageInput.Value

    if (userId && name && email && age) {
        AddUser(userId, name, email, Integer(age))

        ; Clear inputs
        userIdInput.Value := ""
        nameInput.Value := ""
        emailInput.Value := ""
        ageInput.Value := ""
    } else {
        MsgBox("Please fill all fields!", "Error")
    }
}
