#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Feature: Interface Pattern (Duck Typing)
; Demonstrates: Interface contracts, polymorphism without inheritance, duck typing

class ISerializable {
    Serialize() => throw Error("Must implement Serialize()")
    Deserialize(data) => throw Error("Must implement Deserialize()")
}

class IComparable {
    CompareTo(other) => throw Error("Must implement CompareTo()")
    Equals(other) => this.CompareTo(other) = 0
    LessThan(other) => this.CompareTo(other) < 0
    GreaterThan(other) => this.CompareTo(other) > 0
}

class IDisposable {
    Dispose() => throw Error("Must implement Dispose()")
}

class Product extends ISerializable {
    __New(id, name, price) => (this.id := id, this.name := name, this.price := price)

    Serialize() => Format("ID:{1}|Name:{2}|Price:{3}", this.id, this.name, this.price)

    static Deserialize(data) {
        parts := StrSplit(data, "|")
        id := StrSplit(parts[1], ":")[2]
        name := StrSplit(parts[2], ":")[2]
        price := StrSplit(parts[3], ":")[2]
        return Product(id, name, price)
    }
}

class Employee extends IComparable {
    __New(name, salary) => (this.name := name, this.salary := salary)

    CompareTo(other) {
        if (this.salary < other.salary)
            return -1
        if (this.salary > other.salary)
            return 1
        return 0
    }

    ToString() => Format("{1}: ${2:0.2f}", this.name, this.salary)
}

class TempFile extends IDisposable {
    __New(content := "") {
        this.filePath := A_ScriptDir "\temp_" A_TickCount ".txt"
        if (content)
            FileAppend(content, this.filePath)
        MsgBox("Temp file created: " this.filePath)
    }

    Write(content) => FileAppend(content, this.filePath)

    Read() => FileRead(this.filePath)

    Dispose() {
        if (FileExist(this.filePath)) {
            FileDelete(this.filePath)
            MsgBox("Temp file deleted: " this.filePath)
        }
    }

    __Delete() => this.Dispose()
}

; Functions accepting interface contracts
SaveToStorage(serializable) {
    data := serializable.Serialize()
    MsgBox("Saved to storage: " data)
    return data
}

SortByComparable(items) {
    ; Simple bubble sort
    n := items.Length
    loop n - 1 {
        i := A_Index
        loop n - i {
            j := A_Index
            if (items[j].GreaterThan(items[j + 1])) {
                temp := items[j]
                items[j] := items[j + 1]
                items[j + 1] := temp
            }
        }
    }
    return items
}

CleanupResources(disposables*) {
    for resource in disposables
        resource.Dispose()
}

; Usage - polymorphic interface usage
product := Product("P001", "Laptop", 999.99)
serialized := SaveToStorage(product)
restored := Product.Deserialize(serialized)
MsgBox("Restored product: " restored.name " ($" restored.price ")")

; Sorting with IComparable
employees := [
    Employee("Alice", 75000),
    Employee("Bob", 65000),
    Employee("Charlie", 85000),
    Employee("Diana", 70000)
]

MsgBox("Before sorting:`n" employees[1].ToString() "`n" employees[2].ToString() "`n" employees[3].ToString() "`n" employees[4].ToString())

SortByComparable(employees)

MsgBox("After sorting:`n" employees[1].ToString() "`n" employees[2].ToString() "`n" employees[3].ToString() "`n" employees[4].ToString())
; Resource cleanup with IDisposable
{
    file1 := TempFile("Test content 1")
    file2 := TempFile("Test content 2")
    file1.Write("`nAdditional content")

    MsgBox("File1 content:`n" file1.Read())

    CleanupResources(file1, file2)
}

MsgBox("All interfaces demonstrated!")
