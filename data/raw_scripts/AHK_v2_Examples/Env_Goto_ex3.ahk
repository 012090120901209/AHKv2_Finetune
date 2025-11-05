#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Environment_Goto_ex3.ah2 myGui := Gui()
ogcButtonTest := myGui.Add("Button", , "Test")
ogcButtonTest.OnEvent("Click", Tag.Bind("Normal"))
ogcButtonTest := myGui.Add("Button", , "Test")
ogcButtonTest.OnEvent("Click", Test.Bind("Normal"))
ogcButtonTest := myGui.Add("Button", , "Test")
ogcButtonTest.OnEvent("Click", Tag1.Bind("Normal"))
ogcButtonTest := myGui.Add("Button", , "Test")
ogcButtonTest.OnEvent("Click", Test1.Bind("Normal"))
myGui.Show() Goto("Somewhere")
Somewhere()
Tag()
Test()
Tag1()
Test1()
Somewhere() { MsgBox("Test")
}
Tag(A_GuiEvent := "", A_GuiControl := "", Info := "", *) { MsgBox("tag")
}
Test(A_GuiEvent := "", A_GuiControl := "", Info := "", *) { MsgBox("test")
}
Tag1(A_GuiEvent := "", A_GuiControl := "", Info := "", *) { MsgBox("tag1")
}
Test1(A_GuiEvent := "", A_GuiControl := "", Info := "", *) { MsgBox("test1")
}
