#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Real-world OOP Application: Calendar and Scheduler System
; Demonstrates: Event management, recurring events, reminders, conflicts

class Event {
    static nextEventId := 1
    static TYPE_MEETING := "MEETING"
    static TYPE_TASK := "TASK"
    static TYPE_REMINDER := "REMINDER"
    static TYPE_APPOINTMENT := "APPOINTMENT"

    __New(title, startTime, endTime, type := "MEETING") {
        this.eventId := Event.nextEventId++
        this.title := title
        this.startTime := startTime
        this.endTime := endTime
        this.type := type
        this.description := ""
        this.location := ""
        this.attendees := []
        this.reminders := []
        this.tags := []
    }

    SetDescription(description) => (this.description := description, this)
    SetLocation(location) => (this.location := location, this)
    AddAttendee(attendee) => (this.attendees.Push(attendee), this)
    AddReminder(minutesBefore) => (this.reminders.Push(minutesBefore), this)
    AddTag(tag) => (this.tags.Push(tag), this)

    GetDuration() => DateDiff(this.endTime, this.startTime, "Minutes")

    OverlapsWith(otherEvent) {
        return (this.startTime < otherEvent.endTime) && (this.endTime > otherEvent.startTime)
    }

    ToString() => Format("[{1}] {2}`n{3} - {4} ({5} min){6}",
        this.type,
        this.title,
        FormatTime(this.startTime, "MM/dd HH:mm"),
        FormatTime(this.endTime, "HH:mm"),
        this.GetDuration(),
        this.location ? " @ " . this.location : "")
}

class RecurringEvent extends Event {
    static FREQ_DAILY := "DAILY"
    static FREQ_WEEKLY := "WEEKLY"
    static FREQ_MONTHLY := "MONTHLY"

    __New(title, startTime, endTime, frequency, until) {
        super.__New(title, startTime, endTime)
        this.frequency := frequency
        this.until := until
    }

    GetOccurrences() {
        occurrences := []
        current := this.startTime

        while (current <= this.until) {
            duration := DateDiff(this.endTime, this.startTime, "Minutes")
            occurrenceEnd := DateAdd(current, duration, "Minutes")

            occurrence := Event(this.title, current, occurrenceEnd, this.type)
            occurrence.description := this.description
            occurrence.location := this.location

            occurrences.Push(occurrence)

            ; Move to next occurrence
            if (this.frequency = RecurringEvent.FREQ_DAILY)
                current := DateAdd(current, 1, "Days")
            else if (this.frequency = RecurringEvent.FREQ_WEEKLY)
                current := DateAdd(current, 7, "Days")
            else if (this.frequency = RecurringEvent.FREQ_MONTHLY)
                current := DateAdd(current, 1, "Months")
        }

        return occurrences
    }
}

class Calendar {
    __New(owner) => (this.owner := owner, this.events := [])

    AddEvent(event) {
        ; Check for conflicts
        conflicts := this.GetConflicts(event)
        if (conflicts.Length > 0) {
            conflictList := conflicts.Map((e) => e.title).Join(", ")
            result := MsgBox(Format("Conflict with: {1}`n`nAdd anyway?", conflictList), "Scheduling Conflict", "YesNo")
            if (result = "No")
                return false
        }

        this.events.Push(event)
        MsgBox(Format("Event added: {1}", event.title))
        return true
    }

    AddRecurringEvent(recurringEvent) {
        occurrences := recurringEvent.GetOccurrences()
        for occurrence in occurrences
            this.events.Push(occurrence)
        MsgBox(Format("Recurring event added: {1} ({2} occurrences)", recurringEvent.title, occurrences.Length))
        return true
    }

    RemoveEvent(eventId) {
        for index, event in this.events {
            if (event.eventId = eventId) {
                this.events.RemoveAt(index)
                return true
            }
        }
        return false
    }

    GetConflicts(event) {
        conflicts := []
        for existing in this.events
            if (event.OverlapsWith(existing))
                conflicts.Push(existing)
        return conflicts
    }

    GetEventsForDate(date) {
        dateStr := FormatTime(date, "yyyyMMdd")
        filtered := []
        for event in this.events {
            eventDateStr := FormatTime(event.startTime, "yyyyMMdd")
            if (eventDateStr = dateStr)
                filtered.Push(event)
        }
        return filtered
    }

    GetEventsInRange(startDate, endDate) {
        filtered := []
        for event in this.events
            if (event.startTime >= startDate && event.startTime <= endDate)
                filtered.Push(event)
        return filtered
    }

    GetUpcomingEvents(days := 7) {
        endDate := DateAdd(A_Now, days, "Days")
        return this.GetEventsInRange(A_Now, endDate)
    }

    GetEventsByType(type) {
        filtered := []
        for event in this.events
            if (event.type = type)
                filtered.Push(event)
        return filtered
    }

    GetDailyAgenda(date) {
        events := this.GetEventsForDate(date)
        if (events.Length = 0)
            return Format("No events scheduled for {1}", FormatTime(date, "yyyy-MM-dd"))

        agenda := Format("Agenda for {1}`n", FormatTime(date, "yyyy-MM-dd"))
        agenda .= "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n`n"

        ; Sort by start time
        this._SortEventsByTime(events)

        for event in events
            agenda .= event.ToString() . "`n`n"

        return agenda
    }

    GetWeeklySummary() {
        weekStart := A_Now
        weekEnd := DateAdd(weekStart, 7, "Days")
        events := this.GetEventsInRange(weekStart, weekEnd)

        summary := Format("{1}'s Week ({2} to {3})`n",
            this.owner,
            FormatTime(weekStart, "MM/dd"),
            FormatTime(weekEnd, "MM/dd"))
        summary .= "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        summary .= Format("Total events: {1}`n", events.Length)

        meetings := 0
        tasks := 0
        totalTime := 0

        for event in events {
            totalTime += event.GetDuration()
            if (event.type = Event.TYPE_MEETING)
                meetings++
            else if (event.type = Event.TYPE_TASK)
                tasks++
        }

        summary .= Format("Meetings: {1}`n", meetings)
        summary .= Format("Tasks: {1}`n", tasks)
        summary .= Format("Total time: {1} hours", Round(totalTime / 60, 1))

        return summary
    }

    _SortEventsByTime(events) {
        ; Simple bubble sort by start time
        n := events.Length
        loop n - 1 {
            i := A_Index
            loop n - i {
                j := A_Index
                if (events[j].startTime > events[j + 1].startTime) {
                    temp := events[j]
                    events[j] := events[j + 1]
                    events[j + 1] := temp
                }
            }
        }
    }
}

; Usage - complete calendar system
calendar := Calendar("Alice Johnson")

; Add single events
meeting1 := Event("Team Standup", DateAdd(A_Now, 1, "Hours"), DateAdd(A_Now, 90, "Minutes"), Event.TYPE_MEETING)
meeting1.SetLocation("Conference Room A")
    .AddAttendee("Bob")
    .AddAttendee("Charlie")
    .AddReminder(15)
    .AddTag("team")

calendar.AddEvent(meeting1)

task1 := Event("Code Review", DateAdd(A_Now, 3, "Hours"), DateAdd(A_Now, 240, "Minutes"), Event.TYPE_TASK)
task1.SetDescription("Review PR #123 - New authentication system")
    .AddTag("development")

calendar.AddEvent(task1)

appointment1 := Event("Doctor Appointment", DateAdd(A_Now, 5, "Hours"), DateAdd(A_Now, 350, "Minutes"), Event.TYPE_APPOINTMENT)
appointment1.SetLocation("City Medical Center")
    .AddReminder(60)
    .AddReminder(30)

calendar.AddEvent(appointment1)

; Try to add conflicting event
conflict := Event("Client Call", DateAdd(A_Now, 1, "Hours"), DateAdd(A_Now, 120, "Minutes"), Event.TYPE_MEETING)
calendar.AddEvent(conflict)  ; Will show conflict warning

; Add recurring event
dailyStandup := RecurringEvent(
    "Daily Standup",
    DateAdd(A_Now, 1, "Days"),
    DateAdd(DateAdd(A_Now, 1, "Days"), 15, "Minutes"),
    RecurringEvent.FREQ_DAILY,
    DateAdd(A_Now, 7, "Days")
)
dailyStandup.SetLocation("Zoom")
calendar.AddRecurringEvent(dailyStandup)

; View daily agenda
MsgBox(calendar.GetDailyAgenda(A_Now))

; View upcoming events
upcoming := calendar.GetUpcomingEvents(3)
MsgBox("Upcoming events (3 days):`n`n" . upcoming.Map((e) => e.ToString()).Join("`n`n"))

; View meetings only
meetings := calendar.GetEventsByType(Event.TYPE_MEETING)
MsgBox("All meetings:`n`n" . meetings.Map((e) => e.title).Join("`n"))

; Weekly summary
MsgBox(calendar.GetWeeklySummary())
