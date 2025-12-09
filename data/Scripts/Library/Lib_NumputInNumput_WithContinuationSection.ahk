#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: External Libraries/NumputInNumput_WithContinuationSection.ah2

VarSetStrCapacity(&kMsg, 48), NumPut("UPtr", hWnd, "UPtr", nMsg, "UPtr", wParam, "UPtr", lParam, "uint", A_EventInfo, "int", A_GuiX, "int", A_GuiY, kMsg) ; if 'kMsg' is NOT a UTF-16 string, use 'kMsg := Buffer(48)' and replace all instances of 'StrPtr(kMsg)' with 'kMsg.Ptr'
