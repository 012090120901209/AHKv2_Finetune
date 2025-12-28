#Requires AutoHotkey v2.0
#SingleInstance Force
; Real-world OOP Application: File Manager System
; Demonstrates: File operations, folders, metadata, tree structure

class FileSystemItem {
    __New(name, parent := "") {
        this.name := name
        this.parent := parent
        this.createdAt := A_Now
        this.modifiedAt := A_Now
    }

    GetPath() {
        path := this.name
        current := this.parent
        while (current) {
            path := current.name . "/" . path
            current := current.parent
        }
        return path
    }

    Touch() => (this.modifiedAt := A_Now, this)
}

class File extends FileSystemItem {
    __New(name, size, content := "", parent := "") {
        super.__New(name, parent)
        this.size := size
        this.content := content
        this.extension := this._GetExtension()
    }

    GetSize() => this.size

    GetSizeFormatted() {
        if (this.size < 1024)
            return this.size . " B"
        if (this.size < 1048576)
            return Round(this.size / 1024, 1) . " KB"
        if (this.size < 1073741824)
            return Round(this.size / 1048576, 1) . " MB"
        return Round(this.size / 1073741824, 1) . " GB"
    }

    _GetExtension() {
        parts := StrSplit(this.name, ".")
        return parts.Length > 1 ? parts[parts.Length] : ""
    }

    ToString() => Format("[FILE] {1} ({2})", this.name, this.GetSizeFormatted())
}

class Folder extends FileSystemItem {
    __New(name, parent := "") {
        super.__New(name, parent)
        this.children := []
    }

    AddFile(file) {
        file.parent := this
        this.children.Push(file)
        this.Touch()
        return this
    }

    AddFolder(folder) {
        folder.parent := this
        this.children.Push(folder)
        this.Touch()
        return this
    }

    Remove(itemName) {
        for index, item in this.children {
            if (item.name = itemName) {
                this.children.RemoveAt(index)
                this.Touch()
                return true
            }
        }
        return false
    }

    Find(name) {
        for item in this.children
            if (item.name = name)
                return item
        return ""
    }

    GetSize() {
        total := 0
        for item in this.children
            total += item.GetSize()
        return total
    }

    GetFileCount() {
        count := 0
        for item in this.children {
            if (item is File)
                count++
            else if (item is Folder)
                count += item.GetFileCount()
        }
        return count
    }

    GetFolderCount() {
        count := 0
        for item in this.children {
            if (item is Folder) {
                count++
                count += item.GetFolderCount()
            }
        }
        return count
    }

    ListContents(indent := "") {
        list := ""
        for item in this.children {
            if (item is File)
                list .= indent . item.ToString() . "`n"
            else if (item is Folder) {
                list .= indent . "[DIR] " . item.name . "/`n"
                list .= item.ListContents(indent . "  ")
            }
        }
        return list
    }

    ToString() => Format("[DIR] {1}/ ({2} items, {3})",
        this.name,
        this.children.Length,
        File.prototype.GetSizeFormatted.Call({ size: this.GetSize() }))
}

class FileManager {
    __New() => (this.root := Folder("root"), this.currentFolder := this.root, this.clipboard := "", this.history := [])

    CreateFile(name, size, content := "") {
        file := File(name, size, content, this.currentFolder)
        this.currentFolder.AddFile(file)
        this._AddHistory("CREATE FILE: " . file.GetPath())
        MsgBox(Format("Created file: {1}", file.GetPath()))
        return file
    }

    CreateFolder(name) {
        folder := Folder(name, this.currentFolder)
        this.currentFolder.AddFolder(folder)
        this._AddHistory("CREATE FOLDER: " . folder.GetPath())
        MsgBox(Format("Created folder: {1}", folder.GetPath()))
        return folder
    }

    Delete(name) {
        if (this.currentFolder.Remove(name)) {
            this._AddHistory("DELETE: " . this.currentFolder.GetPath() . "/" . name)
            MsgBox(Format("Deleted: {1}", name))
            return true
        }
        MsgBox("Item not found!", "Error")
        return false
    }

    Copy(name) {
        item := this.currentFolder.Find(name)
        if (!item)
            return MsgBox("Item not found!", "Error")

        this.clipboard := item
        MsgBox(Format("Copied to clipboard: {1}", name))
        return true
    }

    Paste() {
        if (!this.clipboard)
            return MsgBox("Clipboard empty!", "Error")

        ; Create copy
        if (this.clipboard is File) {
            newFile := File(this.clipboard.name, this.clipboard.size, this.clipboard.content, this.currentFolder)
            this.currentFolder.AddFile(newFile)
        } else if (this.clipboard is Folder) {
            MsgBox("Folder copying not implemented in this example")
            return false
        }

        this._AddHistory("PASTE: " . this.clipboard.name)
        MsgBox(Format("Pasted: {1}", this.clipboard.name))
        return true
    }

    ChangeDirectory(folderName) {
        if (folderName = "..") {
            if (this.currentFolder.parent)
                this.currentFolder := this.currentFolder.parent
            return true
        }

        folder := this.currentFolder.Find(folderName)
        if (!folder || !(folder is Folder))
            return MsgBox("Folder not found!", "Error")

        this.currentFolder := folder
        MsgBox(Format("Changed to: {1}", this.currentFolder.GetPath()))
        return true
    }

    GetCurrentPath() => this.currentFolder.GetPath()

    List() => this.currentFolder.ListContents()

    Search(query) {
        results := []
        this._SearchRecursive(this.root, query, results)
        return results
    }

    _SearchRecursive(folder, query, results) {
        for item in folder.children {
            if (InStr(item.name, query))
                results.Push(item)

            if (item is Folder)
                this._SearchRecursive(item, query, results)
        }
    }

    GetStats() {
        stats := "File Manager Statistics`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        stats .= Format("Current path: {1}`n", this.GetCurrentPath())
        stats .= Format("Total files: {1}`n", this.root.GetFileCount())
        stats .= Format("Total folders: {1}`n", this.root.GetFolderCount())
        stats .= Format("Total size: {1}`n", File.prototype.GetSizeFormatted.Call({ size: this.root.GetSize() }))
        stats .= Format("Operations: {1}", this.history.Length)
        return stats
    }

    GetHistory() => this.history.Join("`n")

    _AddHistory(operation) => this.history.Push(Format("[{1}] {2}", FormatTime(, "HH:mm:ss"), operation))
}

; Usage
fm := FileManager()

; Create directory structure
documents := fm.CreateFolder("Documents")
pictures := fm.CreateFolder("Pictures")
music := fm.CreateFolder("Music")

; Navigate and create files
fm.ChangeDirectory("Documents")
fm.CreateFile("resume.pdf", 152000, "Resume content...")
fm.CreateFile("cover_letter.docx", 48000, "Cover letter...")

projects := fm.CreateFolder("Projects")
fm.ChangeDirectory("Projects")
fm.CreateFile("project1.txt", 5000, "Project notes...")
fm.CreateFile("todo.md", 2000, "# TODO List...")

; Go back and navigate to Pictures
fm.ChangeDirectory("..")
fm.ChangeDirectory("..")
fm.ChangeDirectory("Pictures")
fm.CreateFile("vacation.jpg", 2500000, "[image data]")
fm.CreateFile("family.png", 1800000, "[image data]")

vacation := fm.CreateFolder("Vacation 2024")
fm.ChangeDirectory("Vacation 2024")
fm.CreateFile("beach.jpg", 3200000, "[image data]")
fm.CreateFile("sunset.jpg", 2800000, "[image data]")

; Go to root
fm.ChangeDirectory("..")
fm.ChangeDirectory("..")

; List contents
MsgBox("Root directory:`n" . fm.List())

; Navigate and show contents
fm.ChangeDirectory("Documents")
MsgBox("Documents folder:`n" . fm.List())

; Search
results := fm.Search("project")
MsgBox("Search results for 'project':`n" . results.Map((item) => item.GetPath()).Join("`n"))

; Copy/paste
fm.Copy("resume.pdf")
fm.ChangeDirectory("..")
fm.Paste()

; Stats
MsgBox(fm.GetStats())

; History
MsgBox("Operation History:`n" . fm.GetHistory())
