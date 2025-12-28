#Requires AutoHotkey v2.0
#SingleInstance Force
; Real-world OOP Application: Hotel Booking System
; Demonstrates: Reservation management, room types, pricing, availability

class Room {
    static TYPE_SINGLE := "SINGLE"
    static TYPE_DOUBLE := "DOUBLE"
    static TYPE_SUITE := "SUITE"

    __New(roomNumber, type, basePrice) {
        this.roomNumber := roomNumber
        this.type := type
        this.basePrice := basePrice
        this.occupied := false
        this.features := []
    }

    AddFeature(feature) => (this.features.Push(feature), this)
    IsAvailable() => !this.occupied
    Occupy() => (this.occupied := true, this)
    Vacate() => (this.occupied := false, this)

    GetPrice(nights := 1) {
        price := this.basePrice * nights
        ; Add premium for suites
        if (this.type = Room.TYPE_SUITE)
            price *= 1.5
        return price
    }

    ToString() => Format("Room {1} ({2}) - ${3:.2f}/night {4}",
        this.roomNumber,
        this.type,
        this.basePrice,
        this.occupied ? "[OCCUPIED]" : "[AVAILABLE]")
}

class Guest {
    static nextGuestId := 1

    __New(name, email, phone) {
        this.guestId := Guest.nextGuestId++
        this.name := name
        this.email := email
        this.phone := phone
        this.loyaltyPoints := 0
    }

    AddLoyaltyPoints(points) => (this.loyaltyPoints += points, this)
    ToString() => Format("#{1}: {2} ({3} loyalty points)", this.guestId, this.name, this.loyaltyPoints)
}

class Reservation {
    static nextReservationId := 1000
    static STATUS_PENDING := "PENDING"
    static STATUS_CONFIRMED := "CONFIRMED"
    static STATUS_CHECKED_IN := "CHECKED_IN"
    static STATUS_CHECKED_OUT := "CHECKED_OUT"
    static STATUS_CANCELLED := "CANCELLED"

    __New(guest, room, checkInDate, checkOutDate) {
        this.reservationId := Reservation.nextReservationId++
        this.guest := guest
        this.room := room
        this.checkInDate := checkInDate
        this.checkOutDate := checkOutDate
        this.status := Reservation.STATUS_PENDING
        this.totalPrice := this._CalculatePrice()
        this.createdAt := A_Now
    }

    _CalculatePrice() {
        nights := DateDiff(this.checkOutDate, this.checkInDate, "Days")
        return this.room.GetPrice(nights)
    }

    GetNights() => DateDiff(this.checkOutDate, this.checkInDate, "Days")

    Confirm() => (this.status := Reservation.STATUS_CONFIRMED, this)
    CheckIn() => (this.status := Reservation.STATUS_CHECKED_IN, this.room.Occupy(), this)
    CheckOut() => (this.status := Reservation.STATUS_CHECKED_OUT, this.room.Vacate(), this)
    Cancel() => (this.status := Reservation.STATUS_CANCELLED, this)

    ToString() => Format("Reservation #{1}`nGuest: {2}`nRoom: {3}`nDates: {4} to {5} ({6} nights)`nPrice: ${7:.2f}`nStatus: {8}",
        this.reservationId,
        this.guest.name,
        this.room.roomNumber,
        FormatTime(this.checkInDate, "yyyy-MM-dd"),
        FormatTime(this.checkOutDate, "yyyy-MM-dd"),
        this.GetNights(),
        this.totalPrice,
        this.status)
}

class Hotel {
    __New(name) => (this.name := name, this.rooms := Map(), this.guests := Map(), this.reservations := [])

    AddRoom(room) => (this.rooms[room.roomNumber] := room, this)
    RegisterGuest(guest) => (this.guests[guest.guestId] := guest, guest)

    FindAvailableRooms(type := "") {
        available := []
        for roomNum, room in this.rooms {
            if (room.IsAvailable() && (type = "" || room.type = type))
                available.Push(room)
        }
        return available
    }

    CreateReservation(guestId, roomNumber, checkInDate, checkOutDate) {
        guest := this.guests.Has(guestId) ? this.guests[guestId] : ""
        room := this.rooms.Has(roomNumber) ? this.rooms[roomNumber] : ""

        if (!guest)
            return MsgBox("Guest not found!", "Error")
        if (!room)
            return MsgBox("Room not found!", "Error")
        if (!room.IsAvailable())
            return MsgBox("Room not available!", "Error")

        reservation := Reservation(guest, room, checkInDate, checkOutDate)
        this.reservations.Push(reservation)

        MsgBox(Format("Reservation created!`n`n{1}`n`nConfirm this reservation?", reservation.ToString()), "Reservation")
        return reservation
    }

    CheckIn(reservationId) {
        reservation := this._FindReservation(reservationId)
        if (!reservation)
            return MsgBox("Reservation not found!", "Error")

        if (reservation.status != Reservation.STATUS_CONFIRMED)
            return MsgBox("Reservation must be confirmed first!", "Error")

        reservation.CheckIn()
        reservation.guest.AddLoyaltyPoints(reservation.GetNights() * 10)

        MsgBox(Format("Checked in!`nGuest: {1}`nRoom: {2}`nLoyalty points earned: {3}",
            reservation.guest.name,
            reservation.room.roomNumber,
            reservation.GetNights() * 10))
        return true
    }

    CheckOut(reservationId) {
        reservation := this._FindReservation(reservationId)
        if (!reservation)
            return MsgBox("Reservation not found!", "Error")

        if (reservation.status != Reservation.STATUS_CHECKED_IN)
            return MsgBox("Guest not checked in!", "Error")

        reservation.CheckOut()
        MsgBox(Format("Checked out!`nGuest: {1}`nTotal: ${2:.2f}`nThank you for staying at {3}!",
            reservation.guest.name,
            reservation.totalPrice,
            this.name))
        return true
    }

    _FindReservation(reservationId) {
        for reservation in this.reservations
            if (reservation.reservationId = reservationId)
                return reservation
        return ""
    }

    GetOccupancyRate() {
        if (this.rooms.Count = 0)
            return 0
        occupied := 0
        for roomNum, room in this.rooms
            if (room.occupied)
                occupied++
        return Round((occupied / this.rooms.Count) * 100, 1)
    }

    GetHotelSummary() {
        summary := this.name . "`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        summary .= Format("Total rooms: {1}`n", this.rooms.Count)
        summary .= Format("Occupancy rate: {1}%`n", this.GetOccupancyRate())
        summary .= Format("Total reservations: {1}`n", this.reservations.Length)
        summary .= Format("Total guests: {1}`n", this.guests.Count)
        return summary
    }
}

; Usage - complete hotel booking system
hotel := Hotel("Grand Plaza Hotel")

; Add rooms
hotel.AddRoom(Room(101, Room.TYPE_SINGLE, 100).AddFeature("WiFi").AddFeature("TV"))
hotel.AddRoom(Room(102, Room.TYPE_SINGLE, 100).AddFeature("WiFi").AddFeature("TV"))
hotel.AddRoom(Room(201, Room.TYPE_DOUBLE, 150).AddFeature("WiFi").AddFeature("TV").AddFeature("Mini Bar"))
hotel.AddRoom(Room(202, Room.TYPE_DOUBLE, 150).AddFeature("WiFi").AddFeature("TV").AddFeature("Mini Bar"))
hotel.AddRoom(Room(301, Room.TYPE_SUITE, 300).AddFeature("WiFi").AddFeature("TV").AddFeature("Mini Bar").AddFeature("Ocean View"))

; Register guests
alice := hotel.RegisterGuest(Guest("Alice Johnson", "alice@email.com", "555-0101"))
bob := hotel.RegisterGuest(Guest("Bob Smith", "bob@email.com", "555-0102"))

; Show available rooms
availableSuites := hotel.FindAvailableRooms(Room.TYPE_SUITE)
MsgBox("Available suites:`n" . availableSuites.Map((r) => r.ToString()).Join("`n"))

; Create reservations
checkIn := DateAdd(A_Now, 1, "Days")
checkOut := DateAdd(checkIn, 3, "Days")

res1 := hotel.CreateReservation(alice.guestId, 301, checkIn, checkOut)
res1.Confirm()

res2 := hotel.CreateReservation(bob.guestId, 201, checkIn, DateAdd(checkIn, 2, "Days"))
res2.Confirm()

; Check in
hotel.CheckIn(res1.reservationId)
hotel.CheckIn(res2.reservationId)

MsgBox(alice.ToString())

; Hotel summary
MsgBox(hotel.GetHotelSummary())

; Check out
hotel.CheckOut(res1.reservationId)

MsgBox(hotel.GetHotelSummary())
