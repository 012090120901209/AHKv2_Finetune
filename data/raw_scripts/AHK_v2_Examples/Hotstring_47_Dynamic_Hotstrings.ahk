#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Dynamic Hotstrings with Functions
 * Hotstrings that execute code and insert dynamic content
 */

; Current date
::ddate::{
    Send(FormatTime(, "yyyy-MM-dd"))
}

; Current time
::ttime::{
    Send(FormatTime(, "HH:mm:ss"))
}

; Full timestamp
::tstamp::{
    Send(FormatTime(, "yyyy-MM-dd HH:mm:ss"))
}

; Random number
::rand::{
    Send(Random(1, 100))
}

; Clipboard content
::paste::{
    Send(A_Clipboard)
}

; Username
::myname::{
    Send(A_UserName)
}

; Computer name
::mypc::{
    Send(A_ComputerName)
}

; Line count
::linecount::{
    static count := 0
    count++
    Send("Line " count ": ")
}

; Lorem ipsum generator
::lorem::{
    lorem := "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    Send(lorem)
}
