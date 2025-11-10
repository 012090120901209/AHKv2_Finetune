#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Real-world OOP Application: Course Registration System
; Demonstrates: Academic enrollment, prerequisites, capacity management

class Course {
    __New(code, name, credits, capacity, instructor) {
        this.code := code
        this.name := name
        this.credits := credits
        this.capacity := capacity
        this.instructor := instructor
        this.enrolledStudents := []
        this.waitlist := []
        this.prerequisites := []
        this.schedule := ""
    }

    AddPrerequisite(courseCode) => (this.prerequisites.Push(courseCode), this)
    SetSchedule(schedule) => (this.schedule := schedule, this)
    IsFull() => this.enrolledStudents.Length >= this.capacity
    GetAvailableSeats() => this.capacity - this.enrolledStudents.Length
    ToString() => Format("{1} - {2} ({3} credits)`n{4} | Seats: {5}/{6}", this.code, this.name, this.credits, this.instructor, this.enrolledStudents.Length, this.capacity)
}

class Student {
    static nextStudentId := 1000

    __New(name, email, major) {
        this.studentId := Student.nextStudentId++
        this.name := name
        this.email := email
        this.major := major
        this.enrolledCourses := []
        this.completedCourses := []
        this.gpa := 0.0
    }

    GetTotalCredits() {
        total := 0
        for course in this.enrolledCourses
            total += course.credits
        return total
    }

    HasCompleted(courseCode) {
        for code in this.completedCourses
            if (code = courseCode)
                return true
        return false
    }

    CompleteCourse(courseCode, grade) {
        this.completedCourses.Push(courseCode)
        MsgBox(Format("{1} completed {2} with grade: {3}", this.name, courseCode, grade))
    }

    ToString() => Format("#{1}: {2} ({3} major)`n{4} enrolled courses, {5} completed | GPA: {6}",
        this.studentId, this.name, this.major, this.enrolledCourses.Length, this.completedCourses.Length, this.gpa)
}

class Enrollment {
    __New(student, course) {
        this.student := student
        this.course := course
        this.enrolledAt := A_Now
        this.grade := ""
        this.status := "ACTIVE"
    }

    Drop() => (this.status := "DROPPED", this)
    Complete(grade) => (this.grade := grade, this.status := "COMPLETED", this)

    ToString() => Format("{1} enrolled in {2} - {3}", this.student.name, this.course.code, this.status)
}

class RegistrationSystem {
    __New(institution) => (this.institution := institution, this.courses := Map(), this.students := Map(), this.enrollments := [])

    AddCourse(course) => (this.courses[course.code] := course, this)
    AddStudent(student) => (this.students[student.studentId] := student, this)

    EnrollStudent(studentId, courseCode) {
        student := this.students.Has(studentId) ? this.students[studentId] : ""
        course := this.courses.Has(courseCode) ? this.courses[courseCode] : ""

        if (!student)
            return MsgBox("Student not found!", "Error")
        if (!course)
            return MsgBox("Course not found!", "Error")

        ; Check prerequisites
        if (!this._CheckPrerequisites(student, course))
            return MsgBox("Prerequisites not met!", "Error")

        ; Check if already enrolled
        for enrolled in student.enrolledCourses
            if (enrolled.code = courseCode)
                return MsgBox("Already enrolled in this course!", "Error")

        ; Check capacity
        if (course.IsFull()) {
            course.waitlist.Push(student)
            MsgBox(Format("{1} added to waitlist for {2}", student.name, course.name))
            return false
        }

        ; Enroll student
        enrollment := Enrollment(student, course)
        this.enrollments.Push(enrollment)
        student.enrolledCourses.Push(course)
        course.enrolledStudents.Push(student)

        MsgBox(Format("{1} successfully enrolled in {2}!", student.name, course.name))
        return true
    }

    DropCourse(studentId, courseCode) {
        student := this.students.Has(studentId) ? this.students[studentId] : ""
        if (!student)
            return MsgBox("Student not found!", "Error")

        ; Find and remove enrollment
        for index, course in student.enrolledCourses {
            if (course.code = courseCode) {
                student.enrolledCourses.RemoveAt(index)

                ; Remove from course
                for i, s in course.enrolledStudents {
                    if (s.studentId = student.studentId) {
                        course.enrolledStudents.RemoveAt(i)
                        break
                    }
                }

                ; Process waitlist
                if (course.waitlist.Length > 0) {
                    nextStudent := course.waitlist.RemoveAt(1)
                    this.EnrollStudent(nextStudent.studentId, courseCode)
                }

                MsgBox(Format("{1} dropped from {2}", student.name, course.name))
                return true
            }
        }

        return MsgBox("Student not enrolled in this course!", "Error")
    }

    GetCourseRoster(courseCode) {
        course := this.courses.Has(courseCode) ? this.courses[courseCode] : ""
        if (!course)
            return []
        return course.enrolledStudents
    }

    GetStudentSchedule(studentId) {
        student := this.students.Has(studentId) ? this.students[studentId] : ""
        if (!student)
            return ""

        schedule := Format("{1}'s Schedule`n", student.name)
        schedule .= "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        schedule .= Format("Total Credits: {1}`n`n", student.GetTotalCredits())

        for course in student.enrolledCourses
            schedule .= Format("{1} - {2} ({3} credits)`n{4}`n`n",
                course.code, course.name, course.credits, course.schedule)

        return schedule
    }

    GetSystemStats() {
        stats := this.institution . " - Registration Statistics`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        stats .= Format("Total courses: {1}`n", this.courses.Count)
        stats .= Format("Total students: {1}`n", this.students.Count)
        stats .= Format("Total enrollments: {1}`n", this.enrollments.Length)

        fullCourses := 0
        totalSeats := 0
        usedSeats := 0

        for code, course in this.courses {
            if (course.IsFull())
                fullCourses++
            totalSeats += course.capacity
            usedSeats += course.enrolledStudents.Length
        }

        stats .= Format("Full courses: {1}`n", fullCourses)
        stats .= Format("Overall capacity: {1}% ({2}/{3})",
            Round((usedSeats / totalSeats) * 100, 1), usedSeats, totalSeats)

        return stats
    }

    _CheckPrerequisites(student, course) {
        for prereqCode in course.prerequisites
            if (!student.HasCompleted(prereqCode))
                return false
        return true
    }
}

; Usage
system := RegistrationSystem("State University")

; Add courses
cs101 := Course("CS101", "Intro to Programming", 3, 30, "Dr. Smith")
cs101.SetSchedule("MWF 9:00-10:00 AM")

cs201 := Course("CS201", "Data Structures", 4, 25, "Dr. Johnson")
cs201.AddPrerequisite("CS101").SetSchedule("TTh 11:00 AM-12:30 PM")

cs301 := Course("CS301", "Algorithms", 4, 20, "Dr. Williams")
cs301.AddPrerequisite("CS201").SetSchedule("MWF 1:00-2:30 PM")

math101 := Course("MATH101", "Calculus I", 4, 40, "Prof. Davis")
math101.SetSchedule("TTh 9:00-10:30 AM")

system.AddCourse(cs101).AddCourse(cs201).AddCourse(cs301).AddCourse(math101)

; Add students
alice := Student("Alice Johnson", "alice@university.edu", "Computer Science")
alice.completedCourses.Push("CS101")  ; Already completed CS101
alice.gpa := 3.8

bob := Student("Bob Smith", "bob@university.edu", "Computer Science")
bob.gpa := 3.5

charlie := Student("Charlie Brown", "charlie@university.edu", "Mathematics")
charlie.gpa := 3.9

system.AddStudent(alice).AddStudent(bob).AddStudent(charlie)

; Enroll students
system.EnrollStudent(alice.studentId, "CS201")  ; Has prerequisite
system.EnrollStudent(alice.studentId, "MATH101")

system.EnrollStudent(bob.studentId, "CS101")
system.EnrollStudent(bob.studentId, "MATH101")

system.EnrollStudent(bob.studentId, "CS201")  ; Should fail - no prerequisite

system.EnrollStudent(charlie.studentId, "MATH101")
system.EnrollStudent(charlie.studentId, "CS101")

; View schedules
MsgBox(system.GetStudentSchedule(alice.studentId))
MsgBox(system.GetStudentSchedule(bob.studentId))

; View course roster
roster := system.GetCourseRoster("MATH101")
MsgBox("MATH101 Roster:`n" . roster.Map((s) => s.name).Join("`n"))

; Drop a course
system.DropCourse(alice.studentId, "MATH101")

; System stats
MsgBox(system.GetSystemStats())

; Student info
MsgBox(alice.ToString())
