#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Misc_Class-Property.ah2

class MyClass {
    MyMethod1 {
        Get {
            return "Method 1"} }
} MsgBox(MyClass.MyMethod1)
