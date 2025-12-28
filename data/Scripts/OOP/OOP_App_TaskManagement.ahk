#Requires AutoHotkey v2.0
#SingleInstance Force
; Real-world OOP Application: Task Management System
; Demonstrates: Complex object relationships, state management, filtering

class Task {
    static nextId := 1
    static STATUS_TODO := "TODO"
    static STATUS_IN_PROGRESS := "IN_PROGRESS"
    static STATUS_DONE := "DONE"

    __New(title, description, priority := "MEDIUM") {
        this.id := Task.nextId++
        this.title := title
        this.description := description
        this.priority := priority
        this.status := Task.STATUS_TODO
        this.tags := []
        this.createdAt := A_Now
        this.completedAt := ""
    }

    Start() => (this.status := Task.STATUS_IN_PROGRESS, this)
    Complete() => (this.status := Task.STATUS_DONE, this.completedAt := A_Now, this)
    AddTag(tag) => (this.tags.Push(tag), this)
    HasTag(tag) => this._ArrayContains(this.tags, tag)

    ToString() => Format("#{1} [{2}] {3} - {4} ({5})",
        this.id, this.status, this.priority, this.title, this.tags.Length " tags")

    _ArrayContains(arr, value) {
        for item in arr
            if (item = value)
                return true
        return false
    }
}

class Project {
    __New(name) => (this.name := name, this.tasks := [], this.members := [])

    AddTask(task) => (this.tasks.Push(task), this)
    AddMember(member) => (this.members.Push(member), this)

    GetTasksByStatus(status) {
        filtered := []
        for task in this.tasks
            if (task.status = status)
                filtered.Push(task)
        return filtered
    }

    GetTasksByTag(tag) {
        filtered := []
        for task in this.tasks
            if (task.HasTag(tag))
                filtered.Push(task)
        return filtered
    }

    GetProgress() {
        if (this.tasks.Length = 0)
            return 0
        completed := 0
        for task in this.tasks
            if (task.status = Task.STATUS_DONE)
                completed++
        return Round((completed / this.tasks.Length) * 100, 1)
    }

    GetSummary() => Format("{1}: {2} tasks, {3}% complete, {4} members",
        this.name, this.tasks.Length, this.GetProgress(), this.members.Length)
}

class TaskManager {
    __New() => (this.projects := Map())

    CreateProject(name) {
        project := Project(name)
        this.projects[name] := project
        return project
    }

    GetProject(name) => this.projects.Has(name) ? this.projects[name] : ""

    GetAllTasks() {
        allTasks := []
        for name, project in this.projects
            for task in project.tasks
                allTasks.Push(task)
        return allTasks
    }

    GetTasksByPriority(priority) {
        tasks := []
        for task in this.GetAllTasks()
            if (task.priority = priority)
                tasks.Push(task)
        return tasks
    }

    GetOverview() {
        overview := "Task Manager Overview:`n`n"
        for name, project in this.projects
            overview .= project.GetSummary() "`n"
        return overview
    }
}

; Usage - complete task management system
manager := TaskManager()

; Create projects
webProject := manager.CreateProject("Website Redesign")
    .AddMember("Alice")
    .AddMember("Bob")

apiProject := manager.CreateProject("API Development")
    .AddMember("Charlie")

; Add tasks to web project
webProject
    .AddTask(Task("Design mockups", "Create UI mockups in Figma", "HIGH").AddTag("design").AddTag("ui"))
    .AddTask(Task("Implement header", "Code responsive header component", "MEDIUM").AddTag("frontend").AddTag("react"))
    .AddTask(Task("Setup database", "Configure PostgreSQL", "HIGH").AddTag("backend").AddTag("database"))
    .AddTask(Task("Write tests", "Unit tests for components", "LOW").AddTag("testing"))

; Add tasks to API project
apiProject
    .AddTask(Task("Design endpoints", "REST API specification", "HIGH").AddTag("api").AddTag("design"))
    .AddTask(Task("Implement auth", "JWT authentication", "HIGH").AddTag("security").AddTag("auth"))
    .AddTask(Task("Add rate limiting", "Prevent API abuse", "MEDIUM").AddTag("security"))

; Work on some tasks
webProject.tasks[1].Start().Complete()
webProject.tasks[2].Start()
apiProject.tasks[1].Complete()
apiProject.tasks[2].Start()

; Get task lists
MsgBox("TODO Tasks in Website Project:`n"
    . webProject.GetTasksByStatus(Task.STATUS_TODO).Map((t) => t.ToString()).Join("`n"))

MsgBox("High Priority Tasks:`n"
    . manager.GetTasksByPriority("HIGH").Map((t) => t.ToString()).Join("`n"))

MsgBox("Security-tagged Tasks:`n"
    . apiProject.GetTasksByTag("security").Map((t) => t.ToString()).Join("`n"))

MsgBox(manager.GetOverview())
