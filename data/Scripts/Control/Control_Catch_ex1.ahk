#Requires AutoHotkey v2.0
#SingleInstance Force

; Demonstrates catching an error twice.
try {
    aefiojpiojeefaaf
} catch Error as err {
    MsgBox(err)
}

try {
    aefiojpiojeefaaf
} catch Error as err {
    MsgBox(err)
}
