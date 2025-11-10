#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP Feature: Lazy Initialization Pattern
; Demonstrates: Deferred object creation, on-demand loading, performance optimization

class ExpensiveResource {
    __New() {
        MsgBox("Creating expensive resource (simulating 2 second load)...")
        Sleep(2000)
        this.data := "Expensive data loaded"
        MsgBox("Resource created!")
    }

    GetData() => this.data
}

class LazyDatabase {
    __New(connectionString) {
        this.connectionString := connectionString
        this._connection := ""  ; Not created yet
        MsgBox("LazyDatabase initialized (connection not opened yet)")
    }

    ; Property with lazy initialization
    Connection {
        get {
            if (!this._connection) {
                MsgBox("First access - creating database connection...")
                Sleep(1000)
                this._connection := {connected: true, connectionString: this.connectionString}
                MsgBox("Database connection established!")
            }
            return this._connection
        }
    }

    Query(sql) {
        conn := this.Connection  ; Auto-creates if needed
        MsgBox("Executing query: " sql "`nConnection: " conn.connectionString)
    }
}

class ImageGallery {
    __New(imagePaths*) {
        this.imagePaths := imagePaths
        this._images := Map()  ; Lazy-loaded image cache
        MsgBox("Gallery created with " imagePaths.Length " images (not loaded yet)")
    }

    GetImage(index) {
        if (!this._images.Has(index)) {
            MsgBox("Loading image " index " for the first time...")
            Sleep(500)
            this._images[index] := this._LoadImage(this.imagePaths[index])
            MsgBox("Image " index " loaded and cached!")
        } else {
            MsgBox("Image " index " retrieved from cache (instant)")
        }
        return this._images[index]
    }

    _LoadImage(path) => {path: path, data: "Image data for " path, loaded: A_Now}

    GetCacheInfo() => Format("Cached images: {1}/{2}", this._images.Count, this.imagePaths.Length)
}

class ConfigManager {
    static _instance := ""

    __New() {
        throw Error("Use ConfigManager.Instance to get singleton")
    }

    ; Lazy singleton instance
    static Instance {
        get {
            if (!ConfigManager._instance) {
                MsgBox("Creating ConfigManager instance (first access)...")
                ConfigManager._instance := {settings: Map(), Load: (*) => MsgBox("Loading config..."), Save: (*) => MsgBox("Saving config...")}
                MsgBox("ConfigManager instance created!")
            }
            return ConfigManager._instance
        }
    }
}

class Report {
    __New(title) {
        this.title := title
        this._summary := ""
        this._details := ""
        this._charts := ""
    }

    ; Lazy computed properties
    Summary {
        get {
            if (!this._summary) {
                MsgBox("Generating summary...")
                Sleep(500)
                this._summary := "Summary for: " this.title
            }
            return this._summary
        }
    }

    Details {
        get {
            if (!this._details) {
                MsgBox("Generating detailed report...")
                Sleep(1000)
                this._details := "Detailed analysis for: " this.title
            }
            return this._details
        }
    }

    Charts {
        get {
            if (!this._charts) {
                MsgBox("Generating charts...")
                Sleep(1500)
                this._charts := "Charts for: " this.title
            }
            return this._charts
        }
    }
}

; Usage - lazy database connection
db := LazyDatabase("Server=localhost;Database=mydb")
MsgBox("Database object created, but not connected yet")
Sleep(1000)
db.Query("SELECT * FROM users")  ; Triggers connection creation
db.Query("SELECT * FROM orders")  ; Reuses existing connection

; Usage - lazy image loading
gallery := ImageGallery("image1.jpg", "image2.jpg", "image3.jpg")
MsgBox(gallery.GetCacheInfo())

gallery.GetImage(1)  ; Loads image 1
gallery.GetImage(3)  ; Loads image 3
gallery.GetImage(1)  ; Uses cached image 1

MsgBox(gallery.GetCacheInfo())

; Usage - lazy singleton
config1 := ConfigManager.Instance
config2 := ConfigManager.Instance  ; Same instance
MsgBox("Same instance? " (config1 = config2 ? "Yes" : "No"))

; Usage - lazy computed properties
report := Report("Q4 2024 Sales")
MsgBox("Report created (nothing computed yet)")

result := MsgBox("Show summary?", "Choose", "YesNo")
if (result = "Yes")
    MsgBox(report.Summary)

result := MsgBox("Show details?", "Choose", "YesNo")
if (result = "Yes")
    MsgBox(report.Details)

result := MsgBox("Show charts?", "Choose", "YesNo")
if (result = "Yes")
    MsgBox(report.Charts)

MsgBox("Lazy initialization pattern demonstrated!")
