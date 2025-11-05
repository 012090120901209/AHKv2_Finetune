#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Mouse and Keyboard/GetKeyName_ex1.ah2 key := "LWin" ; Any key can be used here. name := GetKeyName(key)
vk := GetKeyVK(key)
sc := GetKeySC(key) MsgBox(Format("Name:`t{}`nVK:`t{:X}`nSC:`t{:X}", name, vk, sc))
