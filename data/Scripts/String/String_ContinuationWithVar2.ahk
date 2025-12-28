#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_ContinuationWithVar2.ah2

user := "defaultuser0"
script := ("document.querySelector('#userId').value = '" user "'"
)
MsgBox(script) MyVar := "Test"
MySection := ("This is a " MyVar
) MsgBox(MySection)
