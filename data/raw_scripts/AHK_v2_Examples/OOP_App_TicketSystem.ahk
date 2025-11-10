#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Real-world OOP Application: Support Ticket System
; Demonstrates: Issue tracking, priority management, assignment workflow

class Ticket {
    static nextTicketId := 1
    static PRIORITY_LOW := "LOW"
    static PRIORITY_MEDIUM := "MEDIUM"
    static PRIORITY_HIGH := "HIGH"
    static PRIORITY_CRITICAL := "CRITICAL"
    static STATUS_OPEN := "OPEN"
    static STATUS_IN_PROGRESS := "IN_PROGRESS"
    static STATUS_RESOLVED := "RESOLVED"
    static STATUS_CLOSED := "CLOSED"

    __New(title, description, reportedBy, priority := "MEDIUM") {
        this.ticketId := Ticket.nextTicketId++
        this.title := title
        this.description := description
        this.reportedBy := reportedBy
        this.priority := priority
        this.status := Ticket.STATUS_OPEN
        this.assignedTo := ""
        this.category := ""
        this.tags := []
        this.comments := []
        this.createdAt := A_Now
        this.resolvedAt := ""
    }

    Assign(agent) => (this.assignedTo := agent, this.status := Ticket.STATUS_IN_PROGRESS, this)
    SetCategory(category) => (this.category := category, this)
    AddTag(tag) => (this.tags.Push(tag), this)

    AddComment(author, text) {
        this.comments.Push({author: author, text: text, timestamp: A_Now})
        return this
    }

    Resolve(resolution) {
        this.status := Ticket.STATUS_RESOLVED
        this.resolvedAt := A_Now
        this.AddComment(this.assignedTo, "Resolved: " . resolution)
        return this
    }

    Close() => (this.status := Ticket.STATUS_CLOSED, this)

    GetResolutionTime() {
        if (!this.resolvedAt)
            return 0
        return DateDiff(this.resolvedAt, this.createdAt, "Hours")
    }

    ToString() => Format("Ticket #{1} [{2}] [{3}]`n{4}`nReported by: {5}{6}`nStatus: {7}",
        this.ticketId, this.priority, this.category, this.title, this.reportedBy,
        this.assignedTo ? " | Assigned to: " . this.assignedTo : "",
        this.status)
}

class SupportAgent {
    __New(name, specialties*) => (this.name := name, this.specialties := specialties, this.assignedTickets := [], this.resolvedCount := 0)

    GetActiveTickets() {
        active := []
        for ticket in this.assignedTickets
            if (ticket.status != Ticket.STATUS_RESOLVED && ticket.status != Ticket.STATUS_CLOSED)
                active.Push(ticket)
        return active
    }

    GetWorkload() => this.GetActiveTickets().Length

    ToString() => Format("{1} - {2} active tickets, {3} resolved | Specialties: {4}",
        this.name, this.GetWorkload(), this.resolvedCount, this.specialties.Join(", "))
}

class SupportQueue {
    __New(name) => (this.name := name, this.tickets := [], this.agents := [])

    AddAgent(agent) => (this.agents.Push(agent), this)

    CreateTicket(title, description, reportedBy, priority := "MEDIUM") {
        ticket := Ticket(title, description, reportedBy, priority)
        this.tickets.Push(ticket)
        MsgBox(Format("Ticket #{1} created: {2}", ticket.ticketId, ticket.title))
        return ticket
    }

    AutoAssignTicket(ticketId) {
        ticket := this._FindTicket(ticketId)
        if (!ticket)
            return MsgBox("Ticket not found!", "Error")

        ; Find agent with lowest workload
        bestAgent := ""
        lowestWorkload := 999999
        for agent in this.agents {
            workload := agent.GetWorkload()
            if (workload < lowestWorkload) {
                lowestWorkload := workload
                bestAgent := agent
            }
        }

        if (bestAgent) {
            ticket.Assign(bestAgent.name)
            bestAgent.assignedTickets.Push(ticket)
            MsgBox(Format("Ticket #{1} assigned to {2}", ticket.ticketId, bestAgent.name))
            return true
        }

        return false
    }

    GetTicketsByStatus(status) {
        filtered := []
        for ticket in this.tickets
            if (ticket.status = status)
                filtered.Push(ticket)
        return filtered
    }

    GetTicketsByPriority(priority) {
        filtered := []
        for ticket in this.tickets
            if (ticket.priority = priority)
                filtered.Push(ticket)
        return filtered
    }

    GetAverageResolutionTime() {
        resolved := this.GetTicketsByStatus(Ticket.STATUS_RESOLVED)
        if (resolved.Length = 0)
            return 0
        total := 0
        for ticket in resolved
            total += ticket.GetResolutionTime()
        return Round(total / resolved.Length, 1)
    }

    GetQueueStats() {
        stats := this.name . " - Queue Statistics`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        stats .= Format("Total tickets: {1}`n", this.tickets.Length)
        stats .= Format("Open: {1} | In Progress: {2} | Resolved: {3} | Closed: {4}`n",
            this.GetTicketsByStatus(Ticket.STATUS_OPEN).Length,
            this.GetTicketsByStatus(Ticket.STATUS_IN_PROGRESS).Length,
            this.GetTicketsByStatus(Ticket.STATUS_RESOLVED).Length,
            this.GetTicketsByStatus(Ticket.STATUS_CLOSED).Length)
        stats .= Format("Critical: {1} | High: {2} | Medium: {3} | Low: {4}`n",
            this.GetTicketsByPriority(Ticket.PRIORITY_CRITICAL).Length,
            this.GetTicketsByPriority(Ticket.PRIORITY_HIGH).Length,
            this.GetTicketsByPriority(Ticket.PRIORITY_MEDIUM).Length,
            this.GetTicketsByPriority(Ticket.PRIORITY_LOW).Length)
        stats .= Format("Avg resolution time: {1} hours", this.GetAverageResolutionTime())
        return stats
    }

    _FindTicket(ticketId) {
        for ticket in this.tickets
            if (ticket.ticketId = ticketId)
                return ticket
        return ""
    }
}

; Usage
queue := SupportQueue("IT Helpdesk")

; Add agents
queue.AddAgent(SupportAgent("Alice", "Hardware", "Networking"))
    .AddAgent(SupportAgent("Bob", "Software", "Database"))
    .AddAgent(SupportAgent("Charlie", "Security", "Cloud"))

; Create tickets
t1 := queue.CreateTicket("Cannot access email", "User unable to login to Outlook", "john@company.com", Ticket.PRIORITY_HIGH)
t1.SetCategory("Email").AddTag("access")

t2 := queue.CreateTicket("Printer not working", "Office printer shows error", "jane@company.com", Ticket.PRIORITY_MEDIUM)
t2.SetCategory("Hardware").AddTag("printer")

t3 := queue.CreateTicket("VPN connection fails", "Cannot connect to company VPN", "mike@company.com", Ticket.PRIORITY_CRITICAL)
t3.SetCategory("Network").AddTag("vpn").AddTag("security")

; Auto-assign tickets
queue.AutoAssignTicket(t1.ticketId)
queue.AutoAssignTicket(t2.ticketId)
queue.AutoAssignTicket(t3.ticketId)

; Add comments
t1.AddComment("Alice", "Checking user permissions...")
t1.AddComment("Alice", "Password reset required")

; Resolve tickets
t1.Resolve("Password reset completed, user can now access email")
t2.Resolve("Printer driver reinstalled, issue fixed")
queue.agents[1].resolvedCount := 2

; Show ticket details
MsgBox(t1.ToString() . "`n`nComments:`n" . t1.comments.Map((c) => Format("[{1}] {2}: {3}", FormatTime(c.timestamp, "HH:mm"), c.author, c.text)).Join("`n"))

; Agent workload
for agent in queue.agents
    MsgBox(agent.ToString())

; Queue stats
MsgBox(queue.GetQueueStats())
