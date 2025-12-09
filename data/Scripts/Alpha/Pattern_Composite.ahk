#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Composite Pattern - Composes objects into tree structures
; Demonstrates part-whole hierarchies with uniform interface

class FileComponent {
    __New(name) => this.name := name
    GetSize() => 0
    GetName() => this.name
    Display(indent := "") => ""
}

class File extends FileComponent {
    __New(name, size) {
        super.__New(name)
        this.size := size
    }
    
    GetSize() => this.size
    Display(indent := "") => indent this.name " (" this.size " bytes)"
}

class Folder extends FileComponent {
    __New(name) {
        super.__New(name)
        this.children := []
    }

    Add(component) {
        this.children.Push(component)
        return this
    }

    GetSize() {
        total := 0
        for child in this.children
            total += child.GetSize()
        return total
    }

    Display(indent := "") {
        result := indent "[" this.name "]`n"
        for child in this.children
            result .= child.Display(indent "  ") "`n"
        return RTrim(result, "`n")
    }
}

; Demo - build file tree
root := Folder("Project")
    .Add(File("readme.md", 1024))
    .Add(File("package.json", 512))
    .Add(Folder("src")
        .Add(File("main.ahk", 4096))
        .Add(File("utils.ahk", 2048))
        .Add(Folder("lib")
            .Add(File("helper.ahk", 1024))))
    .Add(Folder("tests")
        .Add(File("test_main.ahk", 2048)))

MsgBox(root.Display() "`n`nTotal size: " root.GetSize() " bytes")
