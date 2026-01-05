#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/FileAppend_ex2.ah2

var := "i am a var"
FileAppend(
    (
        "A line of text.
By default, the hard carriage return (Enter) between the previous line and this one will be written to the file. This line is indented with a tab; by default, that tab will also be written to the file.
Variable references such as " Var " are expanded by default."
    ), A_Desktop "\My File.txt")
