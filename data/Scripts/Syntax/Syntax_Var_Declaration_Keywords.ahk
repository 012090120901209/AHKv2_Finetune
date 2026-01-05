#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: #Usage_and_Syntax/Var_Declaration_Keywords.ah2

ExplicitGlobalDefault() {
    static static1
    static static2 := "s2"
    static static3
    static static4 := "s4", static5
    static static6 := "s6", static7, static8 := "s8"

    local local1
    local local2 := "l2"
    local local3
    local local4 := "l4", local5
    local local6 := "l6", local7, local8 := "l8"
}

ForceLocalAndAssumeStatic() {
    ; Example placeholder for mixed declarations
    ; global variables removed for clarity
}

ForceLocalAndAssumeStatic()
