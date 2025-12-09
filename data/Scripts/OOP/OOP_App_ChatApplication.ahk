#Requires AutoHotkey v2.0
#SingleInstance Force
; Real-world OOP Application: Chat Application
; Demonstrates: Messaging, rooms, users, online status

class Message {
    __New(sender, content) {
        this.sender := sender
        this.content := content
        this.timestamp := A_Now
        this.edited := false
    }

    Edit(newContent) => (this.content := newContent, this.edited := true, this)
    ToString() => Format("[{1}] {2}: {3}{4}",
    FormatTime(this.timestamp, "HH:mm"),
    this.sender.username,
    this.content,
    this.edited ? " (edited)" : "")
}

class User {
    static STATUS_ONLINE := "ONLINE"
    static STATUS_AWAY := "AWAY"
    static STATUS_BUSY := "BUSY"
    static STATUS_OFFLINE := "OFFLINE"

    __New(username, displayName) {
        this.username := username
        this.displayName := displayName
        this.status := User.STATUS_OFFLINE
        this.statusMessage := ""
        this.joinedAt := A_Now
    }

    SetStatus(status, message := "") => (this.status := status, this.statusMessage := message, this)
    IsOnline() => this.status != User.STATUS_OFFLINE
    ToString() => Format("@{1} ({2}) - {3}{4}", this.username, this.displayName, this.status, this.statusMessage ? ": " . this.statusMessage : "")
}

class ChatRoom {
    __New(name, description := "") {
        this.name := name
        this.description := description
        this.members := []
        this.messages := []
        this.createdAt := A_Now
    }

    AddMember(user) {
        ; Check if already a member
        for member in this.members
        if (member.username = user.username)
        return this

        this.members.Push(user)
        this._SystemMessage(user.displayName . " joined the room")
        return this
    }

    RemoveMember(user) {
        for index, member in this.members {
            if (member.username = user.username) {
                this.members.RemoveAt(index)
                this._SystemMessage(user.displayName . " left the room")
                return this
            }
        }
        return this
    }

    SendMessage(user, content) {
        if (!this._IsMember(user))
        return MsgBox("User not in room!", "Error")

        message := Message(user, content)
        this.messages.Push(message)
        return message
    }

    GetRecentMessages(count := 10) {
        start := Max(1, this.messages.Length - count + 1)
        recent := []
        loop Min(count, this.messages.Length)
        recent.Push(this.messages[start + A_Index - 1])
        return recent
    }

    GetOnlineMembers() {
        online := []
        for member in this.members
        if (member.IsOnline())
        online.Push(member)
        return online
    }

    _IsMember(user) {
        for member in this.members
        if (member.username = user.username)
        return true
        return false
    }

    _SystemMessage(text) {
        systemUser := User("system", "System")
        this.messages.Push(Message(systemUser, text))
    }

    ToString() => Format("{1}{2}`nMembers: {3} ({4} online) | Messages: {5}",
    this.name,
    this.description ? " - " . this.description : "",
    this.members.Length,
    this.GetOnlineMembers().Length,
    this.messages.Length)
}

class DirectMessage {
    __New(user1, user2) {
        this.participants := [user1, user2]
        this.messages := []
        this.createdAt := A_Now
    }

    SendMessage(sender, content) {
        ; Verify sender is a participant
        if (sender.username != this.participants[1].username && sender.username != this.participants[2].username)
        return MsgBox("Not a participant in this conversation!", "Error")

        message := Message(sender, content)
        this.messages.Push(message)
        return message
    }

    GetOtherUser(currentUser) {
        if (this.participants[1].username = currentUser.username)
        return this.participants[2]
        return this.participants[1]
    }

    ToString() => Format("DM: {1} <-> {2} ({3} messages)",
    this.participants[1].displayName,
    this.participants[2].displayName,
    this.messages.Length)
}

class ChatServer {
    __New(name) => (this.name := name, this.users := Map(), this.rooms := [], this.directMessages := [])

    RegisterUser(user) => (this.users[user.username] := user, this)

    CreateRoom(name, description := "") {
        room := ChatRoom(name, description)
        this.rooms.Push(room)
        MsgBox(Format("Room created: {1}", name))
        return room
    }

    StartDirectMessage(username1, username2) {
        user1 := this.users.Has(username1) ? this.users[username1] : ""
        user2 := this.users.Has(username2) ? this.users[username2] : ""

        if (!user1 || !user2)
        return MsgBox("User not found!", "Error")

        ; Check if DM already exists
        for dm in this.directMessages
        if ((dm.participants[1].username = username1 && dm.participants[2].username = username2) ||
        (dm.participants[1].username = username2 && dm.participants[2].username = username1))
        return dm

        dm := DirectMessage(user1, user2)
        this.directMessages.Push(dm)
        return dm
    }

    GetUserRooms(username) {
        user := this.users.Has(username) ? this.users[username] : ""
        if (!user)
        return []

        userRooms := []
        for room in this.rooms
        for member in room.members
        if (member.username = username)
        userRooms.Push(room)

        return userRooms
    }

    GetServerStats() {
        stats := this.name . " - Server Statistics`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        stats .= Format("Total users: {1}`n", this.users.Count)

        onlineCount := 0
        for username, user in this.users
        if (user.IsOnline())
        onlineCount++

        stats .= Format("Online users: {1}`n", onlineCount)
        stats .= Format("Total rooms: {1}`n", this.rooms.Length)
        stats .= Format("Direct messages: {1}", this.directMessages.Length)

        return stats
    }
}

; Usage
server := ChatServer("MyChat Server")

; Register users
alice := User("alice", "Alice Johnson")
bob := User("bob", "Bob Smith")
charlie := User("charlie", "Charlie Brown")
diana := User("diana", "Diana Prince")

server.RegisterUser(alice).RegisterUser(bob).RegisterUser(charlie).RegisterUser(diana)

; Set users online
alice.SetStatus(User.STATUS_ONLINE)
bob.SetStatus(User.STATUS_ONLINE)
charlie.SetStatus(User.STATUS_AWAY, "At lunch")
diana.SetStatus(User.STATUS_ONLINE)

; Create rooms
general := server.CreateRoom("general", "General discussion")
tech := server.CreateRoom("tech-talk", "Technology discussions")

; Add members to rooms
general.AddMember(alice).AddMember(bob).AddMember(charlie).AddMember(diana)
tech.AddMember(alice).AddMember(bob)

; Send messages in room
general.SendMessage(alice, "Hello everyone!")
general.SendMessage(bob, "Hi Alice! How's everyone doing?")
general.SendMessage(diana, "Great! Just finished my project.")
general.SendMessage(alice, "Congrats Diana!")

tech.SendMessage(bob, "Anyone familiar with AHK v2?")
tech.SendMessage(alice, "Yes! It's great for automation.")

; Show room chat
MsgBox(general.ToString() . "`n`nRecent messages:`n" . general.GetRecentMessages(5).Map((m) => m.ToString()).Join("`n"))

; Direct messages
dm := server.StartDirectMessage("alice", "bob")
dm.SendMessage(alice, "Hey Bob, can we talk privately?")
dm.SendMessage(bob, "Sure, what's up?")
dm.SendMessage(alice, "I need help with the tech presentation")

MsgBox(dm.ToString() . "`n`nMessages:`n" . dm.messages.Map((m) => m.ToString()).Join("`n"))

; Show online members
MsgBox("Online in #general:`n" . general.GetOnlineMembers().Map((u) => u.ToString()).Join("`n"))

; User's rooms
MsgBox("Alice's rooms:`n" . server.GetUserRooms("alice").Map((r) => r.name).Join("`n"))

; Server stats
MsgBox(server.GetServerStats())
