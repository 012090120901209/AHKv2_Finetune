#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Maths_Transform_BitMath.ah2

_BitNotU := ~0xfffffffe ; Now always uses 64-bit signed integers ; Unsigned 32
_BitNotS := ~(-4294967294) ; Now always uses 64-bit signed integers ; Signed 64
_BitAnd := 0xcab & 0xfab
_BitOr := 0xab0 | 0xa0c
_BitXOr := 0xab0 ^ 0xa0c
_BitShiftLeft := 3 << 2
_BitShiftRight := 3 >> 2 MsgBox(_BitNotU "`n" _BitNotS "`n" _BitAnd "`n" _BitOr "`n" _BitXOr "`n" _BitShiftLeft "`n" _BitShiftRight)
