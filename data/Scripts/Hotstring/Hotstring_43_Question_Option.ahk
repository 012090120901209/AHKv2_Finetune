#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Hotstring Option: ? (Question mark)
* Triggers even when inside another word
*/

; Without ?, "btw" only triggers as a whole word
; With ?, it triggers even in the middle of words
; Example: "xbtwx" would trigger replacement

; Add TM symbol after company names
:?:CompanyName::CompanyName™

; Auto-superscript
:?:1st::1ˢᵗ
:?:2nd::2ⁿᵈ
:?:3rd::3ʳᵈ
:?:4th::4ᵗʰ

; Subscript chemical formulas
:?:H2O::H₂O
:?:CO2::CO₂

; Useful for corrections mid-word
:?*:toin::tion  ; Changes "information" while typing
:?*:laer::lear  ; Changes "clear" from "claer"
