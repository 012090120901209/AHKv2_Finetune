#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * RunWait() - Run and wait
 * 
 * Runs a program and waits for it to finish.
 */

MsgBox("Running cmd to ping localhost...")
RunWait('cmd.exe /c ping 127.0.0.1 -n 3', , "Hide")
MsgBox("Ping completed!")
