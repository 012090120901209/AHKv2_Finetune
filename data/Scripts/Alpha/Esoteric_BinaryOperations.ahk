#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Binary and Bit Manipulation - Low-level operations in AHK v2
; Demonstrates bit fields, packed data, and binary protocols

; =============================================================================
; 1. Bit Field Class
; =============================================================================

class BitField {
    __New(size := 32) {
        this._value := 0
        this._size := size
    }

    ; Get bit at position (0-indexed from right)
    GetBit(pos) {
        return (this._value >> pos) & 1
    }

    ; Set bit at position
    SetBit(pos, value := 1) {
        if value
            this._value := this._value | (1 << pos)
        else
            this._value := this._value & ~(1 << pos)
        return this
    }

    ; Toggle bit
    ToggleBit(pos) {
        this._value := this._value ^ (1 << pos)
        return this
    }

    ; Get range of bits
    GetBits(start, count) {
        mask := (1 << count) - 1
        return (this._value >> start) & mask
    }

    ; Set range of bits
    SetBits(start, count, value) {
        mask := ((1 << count) - 1) << start
        this._value := (this._value & ~mask) | ((value << start) & mask)
        return this
    }

    ; Count set bits (population count)
    PopCount() {
        n := this._value
        count := 0
        while n {
            count += n & 1
            n := n >> 1
        }
        return count
    }

    ; Find first set bit (from right, 1-indexed, 0 if none)
    FirstSet() {
        if this._value = 0
            return 0
        pos := 1
        n := this._value
        while !(n & 1) {
            n := n >> 1
            pos++
        }
        return pos
    }

    ; Binary string representation
    ToString(minWidth := 0) {
        if this._value = 0
            return this._pad("0", minWidth)

        result := ""
        n := this._value
        while n > 0 {
            result := (n & 1) . result
            n := n >> 1
        }
        return this._pad(result, minWidth)
    }

    _pad(s, width) {
        while StrLen(s) < width
            s := "0" . s
        return s
    }

    ; Parse from binary string
    static FromString(binStr) {
        bf := BitField()
        bf._value := 0

        loop StrLen(binStr) {
            bf._value := bf._value << 1
            if SubStr(binStr, A_Index, 1) = "1"
                bf._value := bf._value | 1
        }

        return bf
    }

    Value {
        get => this._value
        set => this._value := value
    }
}

; =============================================================================
; 2. Flags Enum Pattern
; =============================================================================

class Flags {
    static NONE := 0
    static READ := 1        ; 0001
    static WRITE := 2       ; 0010
    static EXECUTE := 4     ; 0100
    static DELETE := 8      ; 1000

    static ALL := 15        ; 1111

    ; Check if flag is set
    static Has(value, flag) => (value & flag) = flag

    ; Add flag
    static Add(value, flag) => value | flag

    ; Remove flag
    static Remove(value, flag) => value & ~flag

    ; Toggle flag
    static Toggle(value, flag) => value ^ flag

    ; Parse from array
    static FromArray(flags) {
        value := 0
        for flag in flags
            value := value | flag
        return value
    }

    ; Get array of set flags
    static ToArray(value, flagMap) {
        result := []
        for name, flag in flagMap {
            if (value & flag) = flag
                result.Push(name)
        }
        return result
    }
}

; =============================================================================
; 3. Packed Integer Struct
; =============================================================================

class PackedStruct {
    __New(fieldDefs) {
        this._fields := fieldDefs  ; [{name: "x", bits: 8}, ...]
        this._value := 0
        this._offsets := Map()

        ; Calculate offsets
        offset := 0
        for field in fieldDefs {
            this._offsets[field.name] := { offset: offset, bits: field.bits }
            offset += field.bits
        }
    }

    ; Get field value
    Get(name) {
        info := this._offsets[name]
        mask := (1 << info.bits) - 1
        return (this._value >> info.offset) & mask
    }

    ; Set field value
    Set(name, value) {
        info := this._offsets[name]
        mask := ((1 << info.bits) - 1) << info.offset
        this._value := (this._value & ~mask) | ((value << info.offset) & mask)
        return this
    }

    ; Property-style access
    __Get(name, params) {
        if this._offsets.Has(name)
            return this.Get(name)
        throw PropertyError("Unknown field: " name)
    }

    __Set(name, params, value) {
        if this._offsets.Has(name)
            return this.Set(name, value)
        throw PropertyError("Unknown field: " name)
    }

    ; Pack from object
    static Pack(fieldDefs, values) {
        ps := PackedStruct(fieldDefs)
        for field in fieldDefs {
            if values.HasOwnProp(field.name)
                ps.Set(field.name, values.%field.name%)
        }
        return ps
    }

    ; Unpack to object
    Unpack() {
        result := {}
        for field in this._fields
            result.%field.name% := this.Get(field.name)
        return result
    }

    Value => this._value
}

; =============================================================================
; 4. Binary Buffer Operations
; =============================================================================

class BinaryBuffer {
    __New(size := 256) {
        this._buffer := Buffer(size, 0)
        this._pos := 0
    }

    ; Write operations
    WriteUInt8(value) {
        NumPut("UChar", value, this._buffer, this._pos)
        this._pos += 1
        return this
    }

    WriteUInt16(value, bigEndian := false) {
        if bigEndian {
            this.WriteUInt8(value >> 8)
            this.WriteUInt8(value & 0xFF)
        } else {
            NumPut("UShort", value, this._buffer, this._pos)
            this._pos += 2
        }
        return this
    }

    WriteUInt32(value, bigEndian := false) {
        if bigEndian {
            this.WriteUInt8((value >> 24) & 0xFF)
            this.WriteUInt8((value >> 16) & 0xFF)
            this.WriteUInt8((value >> 8) & 0xFF)
            this.WriteUInt8(value & 0xFF)
        } else {
            NumPut("UInt", value, this._buffer, this._pos)
            this._pos += 4
        }
        return this
    }

    WriteFloat(value) {
        NumPut("Float", value, this._buffer, this._pos)
        this._pos += 4
        return this
    }

    WriteString(str, encoding := "UTF-8") {
        len := StrLen(str)
        this.WriteUInt16(len)

        loop len {
            ch := Ord(SubStr(str, A_Index, 1))
            this.WriteUInt8(ch)
        }
        return this
    }

    ; Read operations
    ReadUInt8() {
        value := NumGet(this._buffer, this._pos, "UChar")
        this._pos += 1
        return value
    }

    ReadUInt16(bigEndian := false) {
        if bigEndian {
            high := this.ReadUInt8()
            low := this.ReadUInt8()
            return (high << 8) | low
        }
        value := NumGet(this._buffer, this._pos, "UShort")
        this._pos += 2
        return value
    }

    ReadUInt32(bigEndian := false) {
        if bigEndian {
            return (this.ReadUInt8() << 24) | (this.ReadUInt8() << 16) | (this.ReadUInt8() << 8) | this.ReadUInt8()
        }
        value := NumGet(this._buffer, this._pos, "UInt")
        this._pos += 4
        return value
    }

    ReadFloat() {
        value := NumGet(this._buffer, this._pos, "Float")
        this._pos += 4
        return value
    }

    ReadString() {
        len := this.ReadUInt16()
        result := ""
        loop len
            result .= Chr(this.ReadUInt8())
        return result
    }

    ; Position management
    Seek(pos) {
        this._pos := pos
        return this
    }

    Position => this._pos
    Size => this._buffer.Size
    Buffer => this._buffer

    ; Hex dump
    HexDump(bytesPerLine := 16) {
        result := ""
        this._pos := 0

        while this._pos < this._buffer.Size {
            ; Address
            result .= Format("{:04X}: ", this._pos)

            ; Hex bytes
            lineStart := this._pos
            loop bytesPerLine {
                if this._pos < this._buffer.Size {
                    result .= Format("{:02X} ", NumGet(this._buffer, this._pos, "UChar"))
                    this._pos++
                } else {
                    result .= "   "
                }
            }

            ; ASCII
            result .= " |"
            tempPos := lineStart
            loop bytesPerLine {
                if tempPos < this._buffer.Size {
                    ch := NumGet(this._buffer, tempPos, "UChar")
                    result .= (ch >= 32 && ch < 127) ? Chr(ch) : "."
                    tempPos++
                }
            }
            result .= "|`n"
        }

        return result
    }
}

; =============================================================================
; 5. Color Manipulation (RGBA Packed)
; =============================================================================

class Color {
    ; Pack RGBA into single integer
    static Pack(r, g, b, a := 255) {
        return (a << 24) | (r << 16) | (g << 8) | b
    }

    ; Unpack to components
    static Unpack(color) {
        return {
            r: (color >> 16) & 0xFF,
            g: (color >> 8) & 0xFF,
            b: color & 0xFF,
            a: (color >> 24) & 0xFF
        }
    }

    ; Blend two colors (alpha blend)
    static Blend(color1, color2, factor := 0.5) {
        c1 := Color.Unpack(color1)
        c2 := Color.Unpack(color2)

        return Color.Pack(
            Integer(c1.r * (1 - factor) + c2.r * factor),
            Integer(c1.g * (1 - factor) + c2.g * factor),
            Integer(c1.b * (1 - factor) + c2.b * factor),
            Integer(c1.a * (1 - factor) + c2.a * factor)
        )
    }

    ; Invert color
    static Invert(color) {
        c := Color.Unpack(color)
        return Color.Pack(255 - c.r, 255 - c.g, 255 - c.b, c.a)
    }

    ; Grayscale
    static Grayscale(color) {
        c := Color.Unpack(color)
        gray := Integer(c.r * 0.299 + c.g * 0.587 + c.b * 0.114)
        return Color.Pack(gray, gray, gray, c.a)
    }

    ; To hex string
    static ToHex(color) {
        return Format("#{:06X}", color & 0xFFFFFF)
    }

    ; From hex string
    static FromHex(hex) {
        hex := StrReplace(hex, "#", "")
        return Integer("0x" . hex)
    }
}

; =============================================================================
; 6. Bit Manipulation Utilities
; =============================================================================

class BitUtils {
    ; Rotate left
    static RotateLeft(value, shift, bits := 32) {
        shift := Mod(shift, bits)
        mask := (1 << bits) - 1
        return ((value << shift) | (value >> (bits - shift))) & mask
    }

    ; Rotate right
    static RotateRight(value, shift, bits := 32) {
        shift := Mod(shift, bits)
        mask := (1 << bits) - 1
        return ((value >> shift) | (value << (bits - shift))) & mask
    }

    ; Reverse bits
    static ReverseBits(value, bits := 32) {
        result := 0
        loop bits {
            result := (result << 1) | (value & 1)
            value := value >> 1
        }
        return result
    }

    ; Check if power of 2
    static IsPowerOf2(n) => n > 0 && (n & (n - 1)) = 0

    ; Next power of 2
    static NextPowerOf2(n) {
        n--
        n := n | (n >> 1)
        n := n | (n >> 2)
        n := n | (n >> 4)
        n := n | (n >> 8)
        n := n | (n >> 16)
        return n + 1
    }

    ; Count leading zeros
    static CLZ(n) {
        if n = 0
            return 32
        count := 0
        if (n & 0xFFFF0000) = 0 {
            count += 16
            n := n << 16
        }
        if (n & 0xFF000000) = 0 {
            count += 8
            n := n << 8
        }
        if (n & 0xF0000000) = 0 {
            count += 4
            n := n << 4
        }
        if (n & 0xC0000000) = 0 {
            count += 2
            n := n << 2
        }
        if (n & 0x80000000) = 0 {
            count += 1
        }
        return count
    }

    ; Count trailing zeros
    static CTZ(n) {
        if n = 0
            return 32
        count := 0
        while (n & 1) = 0 {
            count++
            n := n >> 1
        }
        return count
    }

    ; Sign extend
    static SignExtend(value, fromBits, toBits := 32) {
        signBit := 1 << (fromBits - 1)
        if value & signBit {
            mask := ((1 << toBits) - 1) ^ ((1 << fromBits) - 1)
            return value | mask
        }
        return value
    }
}

; =============================================================================
; 7. Simple Checksum/Hash
; =============================================================================

class Checksum {
    ; XOR checksum
    static XOR(data) {
        checksum := 0
        loop StrLen(data)
            checksum := checksum ^ Ord(SubStr(data, A_Index, 1))
        return checksum
    }

    ; Simple additive checksum
    static Sum(data) {
        sum := 0
        loop StrLen(data)
            sum += Ord(SubStr(data, A_Index, 1))
        return sum & 0xFF
    }

    ; CRC-like checksum (simplified)
    static CRC8(data) {
        crc := 0
        loop StrLen(data) {
            byte := Ord(SubStr(data, A_Index, 1))
            crc := crc ^ byte
            loop 8 {
                if crc & 0x80
                    crc := ((crc << 1) ^ 0x07) & 0xFF
                else
                    crc := (crc << 1) & 0xFF
            }
        }
        return crc
    }

    ; Fletcher-16
    static Fletcher16(data) {
        sum1 := 0
        sum2 := 0

        loop StrLen(data) {
            sum1 := (sum1 + Ord(SubStr(data, A_Index, 1))) & 0xFF
            sum2 := (sum2 + sum1) & 0xFF
        }

        return (sum2 << 8) | sum1
    }
}

; =============================================================================
; Demo
; =============================================================================

; BitField
bf := BitField()
bf.SetBit(0).SetBit(2).SetBit(4)
MsgBox("BitField:`n`n"
    . "Value: " bf.Value "`n"
    . "Binary: " bf.ToString(8) "`n"
    . "PopCount: " bf.PopCount() "`n"
    . "FirstSet: " bf.FirstSet())

; Flags
perms := Flags.NONE
perms := Flags.Add(perms, Flags.READ)
perms := Flags.Add(perms, Flags.WRITE)
MsgBox("Flags:`n`n"
    . "Has READ: " Flags.Has(perms, Flags.READ) "`n"
    . "Has EXECUTE: " Flags.Has(perms, Flags.EXECUTE) "`n"
    . "Binary: " BitField.FromString(Integer(perms)).ToString(4))

; Packed struct
rgb565 := PackedStruct([{ name: "blue", bits: 5 }, { name: "green", bits: 6 }, { name: "red", bits: 5 }
])
rgb565.red := 31      ; Max value for 5 bits
rgb565.green := 63    ; Max value for 6 bits
rgb565.blue := 0

unpacked := rgb565.Unpack()
MsgBox("Packed Struct (RGB565):`n`n"
    . "R: " unpacked.red " G: " unpacked.green " B: " unpacked.blue "`n"
    . "Packed value: " rgb565.Value)

; Binary buffer
buf := BinaryBuffer(64)
buf.WriteUInt8(0xAB)
    .WriteUInt16(0x1234, true)  ; Big endian
    .WriteFloat(3.14)
    .WriteString("Hello")

buf.Seek(0)
MsgBox("Binary Buffer:`n`n"
    . "UInt8: " Format("{:02X}", buf.ReadUInt8()) "`n"
    . "UInt16 (BE): " Format("{:04X}", buf.ReadUInt16(true)) "`n"
    . "Float: " Format("{:.2f}", buf.ReadFloat()) "`n"
    . "String: " buf.ReadString())

; Color manipulation
red := Color.Pack(255, 0, 0)
blue := Color.Pack(0, 0, 255)
purple := Color.Blend(red, blue, 0.5)

purpleComponents := Color.Unpack(purple)
MsgBox("Color Blending:`n`n"
    . "Red: " Color.ToHex(red) "`n"
    . "Blue: " Color.ToHex(blue) "`n"
    . "50% Blend: " Color.ToHex(purple) "`n"
    . "Components: R=" purpleComponents.r " G=" purpleComponents.g " B=" purpleComponents.b)

; Bit utilities
MsgBox("Bit Utilities:`n`n"
    . "RotateLeft(10, 2, 8): " BitField.FromString(Integer(BitUtils.RotateLeft(10, 2, 8))).ToString(8) "`n"
    . "IsPowerOf2(16): " BitUtils.IsPowerOf2(16) "`n"
    . "NextPowerOf2(13): " BitUtils.NextPowerOf2(13) "`n"
    . "CLZ(0x00100000): " BitUtils.CLZ(0x00100000))

; Checksums
testData := "Hello, World!"
MsgBox("Checksums for '" testData "':`n`n"
    . "XOR: " Format("{:02X}", Checksum.XOR(testData)) "`n"
    . "Sum: " Format("{:02X}", Checksum.Sum(testData)) "`n"
    . "CRC8: " Format("{:02X}", Checksum.CRC8(testData)) "`n"
    . "Fletcher16: " Format("{:04X}", Checksum.Fletcher16(testData)))

; Hex dump demo
dumpBuf := BinaryBuffer(32)
loop 32
    dumpBuf.WriteUInt8(Random(0, 255))
dumpBuf.Seek(0)
MsgBox("Hex Dump:`n`n" dumpBuf.HexDump(8))
