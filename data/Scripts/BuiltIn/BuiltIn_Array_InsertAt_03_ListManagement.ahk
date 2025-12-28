#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.InsertAt() - List Management and Priority Queues
 * ============================================================================
 * 
 * Demonstrates using InsertAt() for managing lists, priority queues,
 * and ordered data structures.
 * 
 * @description List management techniques using Array.InsertAt()
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; Example 1: Priority Queue Implementation
Example1_PriorityQueue() {
    OutputDebug("=== Example 1: Priority Queue ===`n")

    pq := PriorityQueue()

    pq.Enqueue("Low priority task", 5)
    pq.Enqueue("Critical task", 1)
    pq.Enqueue("Medium task", 3)
    pq.Enqueue("High task", 2)
    pq.Enqueue("Another medium", 3)

    OutputDebug("Queue size: " pq.Size() "`n`n")

    OutputDebug("Processing queue (highest priority first):`n")
    while (!pq.IsEmpty()) {
        task := pq.Dequeue()
        OutputDebug("  [Priority " task.priority "] " task.task "`n")
    }
    OutputDebug("`n")
}

; Example 2: Todo List with Priorities
Example2_TodoListManagement() {
    OutputDebug("=== Example 2: Todo List Management ===`n")

    todoList := []

    AddTodo(todoList, "Write documentation", "High", "2025-01-20")
    AddTodo(todoList, "Fix bug #123", "Critical", "2025-01-17")
    AddTodo(todoList, "Update README", "Low", "2025-01-25")
    AddTodo(todoList, "Code review", "Medium", "2025-01-18")

    OutputDebug("Todo list (sorted by priority and due date):`n")
    ShowTodos(todoList)
    OutputDebug("`n")
}

; Example 3: Event Scheduler
Example3_EventScheduler() {
    OutputDebug("=== Example 3: Event Scheduler ===`n")

    schedule := []

    AddEvent(schedule, "Team Meeting", "09:00")
    AddEvent(schedule, "Lunch Break", "12:00")
    AddEvent(schedule, "Code Review", "14:00")
    AddEvent(schedule, "Client Call", "10:30")
    AddEvent(schedule, "Daily Standup", "08:30")

    OutputDebug("Daily schedule (chronological order):`n")
    ShowSchedule(schedule)
    OutputDebug("`n")
}

; Example 4: Leaderboard System
Example4_LeaderboardSystem() {
    OutputDebug("=== Example 4: Leaderboard System ===`n")

    leaderboard := []

    AddPlayer(leaderboard, "Alice", 1500)
    AddPlayer(leaderboard, "Bob", 2000)
    AddPlayer(leaderboard, "Charlie", 1200)
    AddPlayer(leaderboard, "David", 1800)

    OutputDebug("Initial leaderboard:`n")
    ShowLeaderboard(leaderboard)

    OutputDebug("`nUpdating Bob's score to 2500:`n")
    UpdatePlayerScore(leaderboard, "Bob", 2500)
    ShowLeaderboard(leaderboard)

    OutputDebug("`nAdding new player Eve with score 2200:`n")
    AddPlayer(leaderboard, "Eve", 2200)
    ShowLeaderboard(leaderboard)
    OutputDebug("`n")
}

; Example 5: Alphabetically Ordered Contact List
Example5_ContactList() {
    OutputDebug("=== Example 5: Alphabetically Ordered Contact List ===`n")

    contacts := []

    AddContact(contacts, "John Doe", "john@example.com", "555-1234")
    AddContact(contacts, "Alice Smith", "alice@example.com", "555-5678")
    AddContact(contacts, "Bob Johnson", "bob@example.com", "555-9012")
    AddContact(contacts, "Charlie Brown", "charlie@example.com", "555-3456")

    OutputDebug("Contact list (alphabetically sorted):`n")
    ShowContacts(contacts)
    OutputDebug("`n")
}

; Example 6: Version Control System
Example6_VersionControl() {
    OutputDebug("=== Example 6: Version Control ===`n")

    versions := []

    AddVersion(versions, "1.0.0", "Initial release")
    AddVersion(versions, "1.2.0", "Added features")
    AddVersion(versions, "1.0.1", "Bug fixes")
    AddVersion(versions, "2.0.0", "Major update")
    AddVersion(versions, "1.1.0", "Minor improvements")

    OutputDebug("Version history (sorted):`n")
    ShowVersions(versions)
    OutputDebug("`n")
}

; Example 7: Job Queue with Dependencies
Example7_JobQueue() {
    OutputDebug("=== Example 7: Job Queue with Dependencies ===`n")

    jobs := []

    AddJob(jobs, "Initialize", 1, [])
    AddJob(jobs, "Process Data", 3, [1])
    AddJob(jobs, "Load Config", 2, [1])
    AddJob(jobs, "Save Results", 4, [3])

    OutputDebug("Job execution order:`n")
    ShowJobs(jobs)
    OutputDebug("`n")
}

; Class Implementations
class PriorityQueue {
    items := []

    Enqueue(task, priority) {
        newItem := { task: task, priority: priority }
        pos := this.FindPosition(priority)
        this.items.InsertAt(pos, newItem)
    }

    Dequeue() {
        if (this.IsEmpty())
            throw Error("Queue is empty")
        return this.items.RemoveAt(1)
    }

    FindPosition(priority) {
        pos := 1
        for item in this.items {
            if (priority < item.priority)
                break
            pos++
        }
        return pos
    }

    IsEmpty() => this.items.Length = 0
    Size() => this.items.Length
}

; Helper Functions
AddTodo(list, task, priority, dueDate) {
    priorityValue := (priority = "Critical" ? 1 : priority = "High" ? 2 : priority = "Medium" ? 3 : 4)
    newTodo := { task: task, priority: priority, priorityValue: priorityValue, dueDate: dueDate }

    pos := 1
    for todo in list {
        if (priorityValue < todo.priorityValue)
            break
        if (priorityValue = todo.priorityValue && dueDate < todo.dueDate)
            break
        pos++
    }

    list.InsertAt(pos, newTodo)
}

ShowTodos(list) {
    for todo in list
        OutputDebug("  [" todo.priority "] " todo.task " (Due: " todo.dueDate ")`n")
}

AddEvent(schedule, event, time) {
    newEvent := { event: event, time: time }
    pos := 1
    for evt in schedule {
        if (StrCompare(time, evt.time) < 0)
            break
        pos++
    }
    schedule.InsertAt(pos, newEvent)
}

ShowSchedule(schedule) {
    for evt in schedule
        OutputDebug("  " evt.time " - " evt.event "`n")
}

AddPlayer(board, name, score) {
    newPlayer := { name: name, score: score }
    pos := 1
    for player in board {
        if (score > player.score)
            break
        pos++
    }
    board.InsertAt(pos, newPlayer)
}

UpdatePlayerScore(board, name, newScore) {
    ; Remove old entry
    for index, player in board {
        if (player.name = name) {
            board.RemoveAt(index)
            break
        }
    }
    ; Add with new score
    AddPlayer(board, name, newScore)
}

ShowLeaderboard(board) {
    rank := 1
    for player in board {
        OutputDebug("  #" rank ": " player.name " - " player.score " points`n")
        rank++
    }
}

AddContact(contacts, name, email, phone) {
    newContact := { name: name, email: email, phone: phone }
    pos := 1
    for contact in contacts {
        if (StrCompare(name, contact.name) < 0)
            break
        pos++
    }
    contacts.InsertAt(pos, newContact)
}

ShowContacts(contacts) {
    for contact in contacts
        OutputDebug("  " contact.name " - " contact.email " (" contact.phone ")`n")
}

AddVersion(versions, version, description) {
    newVersion := { version: version, description: description }
    pos := 1
    for ver in versions {
        if (CompareVersion(version, ver.version) < 0)
            break
        pos++
    }
    versions.InsertAt(pos, newVersion)
}

CompareVersion(v1, v2) {
    parts1 := StrSplit(v1, ".")
    parts2 := StrSplit(v2, ".")

    Loop Min(parts1.Length, parts2.Length) {
        if (Integer(parts1[A_Index]) < Integer(parts2[A_Index]))
            return -1
        if (Integer(parts1[A_Index]) > Integer(parts2[A_Index]))
            return 1
    }
    return 0
}

ShowVersions(versions) {
    for ver in versions
        OutputDebug("  v" ver.version " - " ver.description "`n")
}

AddJob(jobs, name, order, dependencies) {
    newJob := { name: name, order: order, dependencies: dependencies }
    pos := 1
    for job in jobs {
        if (order < job.order)
            break
        pos++
    }
    jobs.InsertAt(pos, newJob)
}

ShowJobs(jobs) {
    for job in jobs
        OutputDebug("  [" job.order "] " job.name "`n")
}

Main() {
    OutputDebug("`n" String.Repeat("=", 80) "`n")
    OutputDebug("Array.InsertAt() - List Management Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    Example1_PriorityQueue()
    Example2_TodoListManagement()
    Example3_EventScheduler()
    Example4_LeaderboardSystem()
    Example5_ContactList()
    Example6_VersionControl()
    Example7_JobQueue()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.InsertAt() list management examples completed!`nCheck DebugView for output.",
        "Examples Complete", "Icon!")
}

Main()
