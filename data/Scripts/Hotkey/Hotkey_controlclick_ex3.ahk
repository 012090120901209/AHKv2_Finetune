#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Mouse and Keyboard/controlclick_ex3.ah2

SetControlDelay(-1) ; May improve reliability and reduce side effects.
ControlClick("Toolbar321", "Some Window Title", , , , "NA x192 y10")
