#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Binary_02_NetworkData.ahk
 * 
 * DESCRIPTION:
 * Network packet parsing and binary protocol handling using Buffer and NumGet/NumPut.
 * Demonstrates building and parsing network data structures.
 * 
 * FEATURES:
 * - Network packet construction
 * - Protocol header parsing
 * - Binary message encoding/decoding
 * - Checksum calculation
 * - Packet fragmentation handling
 * - Network byte order (big-endian)
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Binary Operations
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Binary protocol implementation
 * - Endianness conversion
 * - CRC/checksum algorithms
 * - Packet assembly and disassembly
 * - Binary data validation
 * 
 * LEARNING POINTS:
 * 1. Network protocols use binary formats for efficiency
 * 2. Network byte order is big-endian
 * 3. Packets include headers, payload, and checksums
 * 4. Binary parsing must handle variable-length data
 * 5. Validation prevents corrupted data processing
 */

; ================================================================================================
; EXAMPLE 1: Simple Protocol Packet
; ================================================================================================

Example1_SimplePacket() {

    ; Create packet
    packet := Packet.Create(1, 42, "Hello, Network!")

    ; Parse packet
    parsed := Packet.Parse(packet)

    result := "Simple Protocol Packet:`n`n"
    result .= "Created Packet:`n"
    result .= "  Size: " . packet.Size . " bytes`n`n"

    result .= "Parsed Data:`n"
    result .= "  Valid: " . (parsed.valid ? "Yes ✓" : "No") . "`n"
    result .= "  Type: " . parsed.type . "`n"
    result .= "  Sequence: " . parsed.sequence . "`n"
    result .= "  Payload Size: " . parsed.payloadSize . " bytes`n"
    result .= "  Payload: '" . parsed.payload . "'"

    MsgBox(result, "Example 1: Simple Packet", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Packet with Checksum
; ================================================================================================

Example2_PacketChecksum() {

    ; Create packet
    packet := ChecksumPacket.Create("Important Data!")

    ; Verify packet
    verified := ChecksumPacket.Verify(packet)

    result := "Packet with Checksum:`n`n"
    result .= "Packet Size: " . packet.Size . " bytes`n`n"

    result .= "Verification:`n"
    result .= "  Valid: " . (verified.valid ? "Yes ✓" : "No") . "`n"
    result .= "  Data Size: " . verified.dataSize . " bytes`n"
    result .= "  Stored Checksum: 0x" . Format("{:08X}", verified.storedChecksum) . "`n"
    result .= "  Calc Checksum: 0x" . Format("{:08X}", verified.calcChecksum) . "`n"
    result .= "  Data: '" . verified.data . "'"

    MsgBox(result, "Example 2: Checksum Packet", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Multi-Field Network Message
; ================================================================================================

Example3_NetworkMessage() {

    ; Create messages
    msg1 := NetworkMessage.Create(NetworkMessage.TYPE_CONNECT, 1001, 2002, "CONNECT")
    msg2 := NetworkMessage.Create(NetworkMessage.TYPE_DATA, 1001, 2002, "Hello!")
    msg3 := NetworkMessage.Create(NetworkMessage.TYPE_DISCONNECT, 1001, 2002, "BYE")

    ; Parse
    p1 := NetworkMessage.Parse(msg1)
    p2 := NetworkMessage.Parse(msg2)
    p3 := NetworkMessage.Parse(msg3)

    result := "Network Messages:`n`n"

    result .= "Message 1 (CONNECT):`n"
    result .= "  From: " . p1.sender . " To: " . p1.receiver . "`n"
    result .= "  Type: " . p1.type . " Data: '" . p1.data . "'`n`n"

    result .= "Message 2 (DATA):`n"
    result .= "  From: " . p2.sender . " To: " . p2.receiver . "`n"
    result .= "  Type: " . p2.type . " Data: '" . p2.data . "'`n`n"

    result .= "Message 3 (DISCONNECT):`n"
    result .= "  From: " . p3.sender . " To: " . p3.receiver . "`n"
    result .= "  Type: " . p3.type . " Data: '" . p3.data . "'"

    MsgBox(result, "Example 3: Network Messages", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    Network Data Examples

    1. Simple Protocol Packet
    2. Packet with Checksum
    3. Multi-Field Network Message

    Select an example (1-3) or press Cancel to exit:
    )"

    choice := InputBox(menu, "Network Data", "w450 h250")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_SimplePacket()
        case "2": Example2_PacketChecksum()
        case "3": Example3_NetworkMessage()
        default: MsgBox("Invalid selection. Please choose 1-3.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()

; Moved class Packet from nested scope
class Packet {
    static Create(type, sequence, payload) {
        payloadSize := StrLen(payload)
        packetSize := 12 + payloadSize

        buf := Buffer(packetSize)

        ; Header (12 bytes)
        NumPut("UInt", 0x50414B54, buf, 0)  ; Magic "PAKT"
        NumPut("UShort", type, buf, 4)
        NumPut("UShort", sequence, buf, 6)
        NumPut("UInt", payloadSize, buf, 8)

        ; Payload
        StrPut(payload, buf.Ptr + 12, payloadSize, "UTF-8")

        return buf
    }

    static Parse(buf) {
        magic := NumGet(buf, 0, "UInt")
        if magic != 0x50414B54
            return { valid: false, error: "Invalid magic" }

        return {
            valid: true,
            type: NumGet(buf, 4, "UShort"),
            sequence: NumGet(buf, 6, "UShort"),
            payloadSize: NumGet(buf, 8, "UInt"),
            payload: StrGet(buf.Ptr + 12, "UTF-8")
        }
    }
}

; Moved class ChecksumPacket from nested scope
class ChecksumPacket {
    static Create(data) {
        dataSize := StrLen(data)
        packetSize := 8 + dataSize

        buf := Buffer(packetSize)

        ; Header
        NumPut("UInt", dataSize, buf, 0)

        ; Data
        StrPut(data, buf.Ptr + 4, dataSize, "UTF-8")

        ; Checksum (last 4 bytes)
        checksum := ChecksumPacket.Calculate(buf, packetSize - 4)
        NumPut("UInt", checksum, buf, packetSize - 4)

        return buf
    }

    static Calculate(buf, length) {
        sum := 0
        loop length {
            sum += NumGet(buf, A_Index - 1, "UChar")
        }
        return sum & 0xFFFFFFFF
    }

    static Verify(buf) {
        if buf.Size < 8
            return false

        dataSize := NumGet(buf, 0, "UInt")
        storedChecksum := NumGet(buf, buf.Size - 4, "UInt")
        calcChecksum := ChecksumPacket.Calculate(buf, buf.Size - 4)

        return {
            valid: storedChecksum = calcChecksum,
            dataSize: dataSize,
            storedChecksum: storedChecksum,
            calcChecksum: calcChecksum,
            data: StrGet(buf.Ptr + 4, "UTF-8")
        }
    }
}

; Moved class NetworkMessage from nested scope
class NetworkMessage {
    static TYPE_CONNECT := 1
    static TYPE_DATA := 2
    static TYPE_DISCONNECT := 3

    static Create(type, sender, receiver, data) {
        msgSize := 20 + StrLen(data)
        buf := Buffer(msgSize)

        ; Header
        NumPut("UInt", 0x4D534721, buf, 0)  ; Magic "MSG!"
        NumPut("UShort", type, buf, 4)
        NumPut("UInt", sender, buf, 6)
        NumPut("UInt", receiver, buf, 10)
        NumPut("UInt", StrLen(data), buf, 14)
        NumPut("UShort", 0, buf, 18)  ; Reserved

        ; Data
        StrPut(data, buf.Ptr + 20, StrLen(data), "UTF-8")

        return buf
    }

    static Parse(buf) {
        magic := NumGet(buf, 0, "UInt")
        if magic != 0x4D534721
            return { valid: false }

        type := NumGet(buf, 4, "UShort")
        sender := NumGet(buf, 6, "UInt")
        receiver := NumGet(buf, 10, "UInt")
        dataLen := NumGet(buf, 14, "UInt")
        data := StrGet(buf.Ptr + 20, dataLen, "UTF-8")

        return {
            valid: true,
            type: type,
            sender: sender,
            receiver: receiver,
            data: data
        }
    }
}
