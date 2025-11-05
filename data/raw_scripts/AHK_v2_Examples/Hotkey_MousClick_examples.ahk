#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Mouse and Keyboard/MousClick_examples.ah2 MouseClick("left")
MouseClick("left", , , 2)
MouseClick("right", 200, 300)
#up:: MouseClick("WheelUp", , , 2) ; Turn it by two notches.
#down:: MouseClick("WheelDown", , , 2)
