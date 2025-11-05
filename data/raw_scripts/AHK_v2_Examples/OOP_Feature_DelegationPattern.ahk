#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP Feature: Delegation Pattern (Composition over Inheritance)
; Demonstrates: Delegation, composition, flexible behavior

class Engine {
    __New(horsepower) => (this.horsepower := horsepower, this.running := false)

    Start() => (this.running := true, MsgBox("Engine started - " this.horsepower " HP"))
    Stop() => (this.running := false, MsgBox("Engine stopped"))
    IsRunning() => this.running
    GetInfo() => Format("{1} HP engine ({2})", this.horsepower, this.running ? "running" : "stopped")
}

class GPS {
    __New() => (this.location := {lat: 0, lon: 0})

    Navigate(destination) => MsgBox("Navigating to: " destination "`nCurrent: " this.GetLocation())
    GetLocation() => Format("({1}, {2})", this.location.lat, this.location.lon)
    UpdateLocation(lat, lon) => (this.location := {lat: lat, lon: lon})
}

class SoundSystem {
    __New() => (this.volume := 50, this.playing := false)

    Play(track) => (this.playing := true, MsgBox("Playing: " track " (Volume: " this.volume "%)"))
    Stop() => (this.playing := false, MsgBox("Music stopped"))
    SetVolume(level) => (this.volume := Max(0, Min(100, level)), MsgBox("Volume: " this.volume "%"))
}

; Car uses delegation instead of inheritance
class Car {
    __New(model) {
        this.model := model
        this.engine := Engine(300)
        this.gps := GPS()
        this.sound := SoundSystem()
    }

    ; Delegate to engine
    Start() => this.engine.Start()
    Stop() => this.engine.Stop()

    ; Delegate to GPS
    NavigateTo(destination) => this.gps.Navigate(destination)
    WhereAmI() => MsgBox(this.model " is at: " this.gps.GetLocation())

    ; Delegate to sound system
    PlayMusic(track) => this.sound.Play(track)
    VolumeUp() => this.sound.SetVolume(this.sound.volume + 10)
    VolumeDown() => this.sound.SetVolume(this.sound.volume - 10)

    ; Car-specific method combining delegates
    StartJourney(destination, music) {
        this.Start()
        this.NavigateTo(destination)
        this.PlayMusic(music)
        MsgBox(this.model ": Journey started!")
    }

    GetStatus() => Format("{1}`nEngine: {2}`nGPS: {3}`nSound: {4}",
        this.model,
        this.engine.GetInfo(),
        this.gps.GetLocation(),
        this.sound.playing ? "Playing" : "Silent")
}

class Printer {
    Print(document) => MsgBox("Printing: " document)
}

class Scanner {
    Scan() => (MsgBox("Scanning..."), "scanned_document.pdf")
}

class Fax {
    Send(document, number) => MsgBox("Faxing " document " to " number)
}

; Office device that delegates to specialized components
class MultiFunctionPrinter {
    __New() => (this.printer := Printer(), this.scanner := Scanner(), this.fax := Fax())

    ; Delegate to appropriate component
    Print(document) => this.printer.Print(document)
    Scan() => this.scanner.Scan()
    SendFax(document, number) => this.fax.Send(document, number)

    ; Combined functionality
    ScanAndPrint() {
        scanned := this.Scan()
        this.Print(scanned)
        MsgBox("Scan and print complete!")
    }

    ScanAndFax(number) {
        scanned := this.Scan()
        this.SendFax(scanned, number)
        MsgBox("Scan and fax complete!")
    }
}

; Usage - car with delegation
car := Car("Tesla Model S")
car.gps.UpdateLocation(37.7749, -122.4194)

MsgBox(car.GetStatus())

car.StartJourney("Golden Gate Bridge", "Road Trip Playlist")

car.VolumeUp()
car.VolumeUp()

car.WhereAmI()

car.Stop()

; Usage - multi-function printer with delegation
mfp := MultiFunctionPrinter()
mfp.Print("Document.docx")
mfp.Scan()
mfp.SendFax("Report.pdf", "555-1234")
mfp.ScanAndPrint()
mfp.ScanAndFax("555-5678")

MsgBox("Delegation pattern demonstrated!")
