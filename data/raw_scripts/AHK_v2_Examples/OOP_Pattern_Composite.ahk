#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP Pattern: Composite Pattern
; Demonstrates: Tree structures, recursive operations, uniform interface

class FileSystemComponent {
    __New(name) => this.name := name
    GetSize() => throw Error("Must implement GetSize()")
    Display(indent := "") => throw Error("Must implement Display()")
}

class File extends FileSystemComponent {
    __New(name, size) => (super.__New(name), this.size := size)
    GetSize() => this.size
    Display(indent := "") => MsgBox(indent "📄 " this.name " (" this.size " bytes)")
}

class Directory extends FileSystemComponent {
    __New(name) => (super.__New(name), this.children := [])

    Add(component) => (this.children.Push(component), this)
    Remove(component) => (Loop this.children.Length) ? (this.children[A_Index] = component ? this.children.RemoveAt(A_Index) : 0) : 0

    GetSize() {
        total := 0
        for child in this.children
            total += child.GetSize()
        return total
    }

    Display(indent := "") {
        result := indent "📁 " this.name " (" this.GetSize() " bytes)`n"
        for child in this.children
            result .= child.Display(indent "  ") "`n"
        return result
    }
}

; Build elegant structure with chaining
root := Directory("root")
    .Add(File("file1.txt", 100))
    .Add(File("file2.txt", 200))
    .Add(Directory("subfolder")
        .Add(File("file3.txt", 300))
        .Add(File("file4.txt", 400)))

MsgBox(root.Display())
MsgBox("Total size: " root.GetSize() " bytes")
