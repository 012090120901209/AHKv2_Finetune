#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Cryptography Examples - thqby/ahk2_lib
*
* Hashing (MD5, SHA1, CRC32) and AES encryption/decryption
* Library: https://github.com/thqby/ahk2_lib/blob/master/Crypt.ahk
*
* To use these examples:
* #Include <Crypt>
*/

/**
* Example 1: Calculate MD5 Hash of String
*/
MD5HashExample() {
    text := "Hello, World!"

    ; Calculate MD5 hash
    hash := MD5(text)

    output := "Text: " text "`n"
    output .= "MD5 Hash: " hash "`n`n"
    output .= "Use MD5 for:`n"
    output .= "- Checksums`n"
    output .= "- Data integrity verification`n"
    output .= "- Caching (not for passwords!)"

    MsgBox(output)
}

/**
* Example 2: Calculate MD5 Hash of File
*/
MD5FileExample() {
    ; Create a test file
    testFile := A_ScriptDir "\test_file.txt"
    FileDelete(testFile)
    FileAppend("This is test content for MD5 hashing.`nLine 2`nLine 3", testFile)

    ; Calculate MD5 of file
    hash := MD5_File(testFile)

    output := "File: " testFile "`n"
    output .= "Size: " FileGetSize(testFile) " bytes`n"
    output .= "MD5 Hash: " hash "`n`n"
    output .= "Use cases:`n"
    output .= "- File integrity checking`n"
    output .= "- Duplicate detection`n"
    output .= "- Download verification"

    MsgBox(output)

    ; Cleanup
    FileDelete(testFile)
}

/**
* Example 3: Verify File Integrity
*/
FileIntegrityExample() {
    ; Create original file
    originalFile := A_ScriptDir "\original.dat"
    FileDelete(originalFile)
    FileAppend("Important data that should not be modified.", originalFile)

    ; Calculate original hash
    originalHash := MD5_File(originalFile)

    MsgBox("Original file created.`nMD5: " originalHash)

    ; Simulate file modification
    Sleep(1000)
    FileDelete(originalFile)
    FileAppend("Important data that has been modified!", originalFile)

    ; Calculate new hash
    newHash := MD5_File(originalFile)

    ; Compare hashes
    output := "File Integrity Check:`n`n"
    output .= "Original MD5: " originalHash "`n"
    output .= "Current MD5:  " newHash "`n`n"

    if (originalHash = newHash)
    output .= "✓ File integrity verified - No changes detected"
    else
    output .= "✗ WARNING: File has been modified!"

    MsgBox(output)

    ; Cleanup
    FileDelete(originalFile)
}

/**
* Example 4: SHA1 Hashing
*/
SHA1HashExample() {
    text := "Secure data to be hashed"

    ; Calculate SHA1 hash
    sha1Hash := Crypt_Hash(text, StrLen(text), "SHA1")

    ; Calculate MD5 for comparison
    md5Hash := MD5(text)

    output := "Text: " text "`n`n"
    output .= "SHA1 Hash: " sha1Hash "`n"
    output .= "MD5 Hash:  " md5Hash "`n`n"
    output .= "SHA1 is more secure than MD5`n"
    output .= "SHA1 produces 160-bit (40 char) hash`n"
    output .= "MD5 produces 128-bit (32 char) hash"

    MsgBox(output)
}

/**
* Example 5: CRC32 Checksum
*/
CRC32Example() {
    text := "Data packet to checksum"

    ; Calculate CRC32
    crc32 := Crypt_Hash(text, StrLen(text), "CRC32")

    output := "Text: " text "`n"
    output .= "CRC32: " crc32 "`n`n"
    output .= "CRC32 is fast but not cryptographically secure`n"
    output .= "Use for:`n"
    output .= "- Quick data validation`n"
    output .= "- Network packet checksums`n"
    output .= "- Error detection"

    MsgBox(output)
}

/**
* Example 6: AES-256 Encryption
*/
AESEncryptExample() {
    ; Original text
    plaintext := "This is secret data that needs encryption!"
    password := "MySecurePassword123"

    ; Convert to buffer
    textBuffer := Buffer(StrPut(plaintext, "UTF-8"))
    StrPut(plaintext, textBuffer, "UTF-8")
    originalSize := textBuffer.Size

    ; Create encryption buffer (needs extra space)
    encryptBuffer := Buffer(originalSize + 16)
    DllCall("msvcrt\memcpy", "Ptr", encryptBuffer, "Ptr", textBuffer, "UInt", originalSize)

    ; Encrypt with AES-256
    encryptedSize := Crypt_AES(encryptBuffer, originalSize, password, 256, true)

    ; Convert to hex for display
    hexOutput := ""
    Loop encryptedSize {
        hexOutput .= Format("{:02X} ", NumGet(encryptBuffer, A_Index - 1, "UChar"))
    }

    output := "Plaintext: " plaintext "`n"
    output .= "Password: " password "`n"
    output .= "Original Size: " originalSize " bytes`n"
    output .= "Encrypted Size: " encryptedSize " bytes`n`n"
    output .= "Encrypted (Hex):`n" hexOutput

    MsgBox(output)
}

/**
* Example 7: AES-256 Decryption
*/
AESDecryptExample() {
    ; Original text
    plaintext := "Confidential message to encrypt and decrypt"
    password := "SecurePass456"

    ; Encrypt
    textBuffer := Buffer(StrPut(plaintext, "UTF-8"))
    StrPut(plaintext, textBuffer, "UTF-8")
    originalSize := textBuffer.Size

    encryptBuffer := Buffer(originalSize + 16)
    DllCall("msvcrt\memcpy", "Ptr", encryptBuffer, "Ptr", textBuffer, "UInt", originalSize)
    encryptedSize := Crypt_AES(encryptBuffer, originalSize, password, 256, true)

    ; Decrypt
    decryptedSize := Crypt_AES(encryptBuffer, encryptedSize, password, 256, false)
    decrypted := StrGet(encryptBuffer, decryptedSize, "UTF-8")

    output := "Original:  " plaintext "`n"
    output .= "Encrypted Size: " encryptedSize " bytes`n"
    output .= "Decrypted: " decrypted "`n`n"
    output .= "Match: " (plaintext = decrypted ? "✓ Success!" : "✗ Failed")

    MsgBox(output)
}

/**
* Example 8: Password Hashing (DO NOT use MD5 for passwords!)
*/
PasswordHashExample() {
    password := "UserPassword123"

    ; WRONG: Never use MD5 for passwords
    md5Hash := MD5(password)

    ; BETTER: Use SHA1 (but still not ideal)
    sha1Hash := Crypt_Hash(password, StrLen(password), "SHA1")

    output := "Password: " password "`n`n"
    output .= "MD5 Hash (INSECURE):  " md5Hash "`n"
    output .= "SHA1 Hash (BETTER):   " sha1Hash "`n`n"
    output .= "⚠ WARNING: For production use:`n"
    output .= "- Use bcrypt, scrypt, or Argon2`n"
    output .= "- Add salt to prevent rainbow tables`n"
    output .= "- Use multiple iterations (key stretching)`n"
    output .= "- Never store passwords in plaintext!"

    MsgBox(output)
}

/**
* Example 9: File Encryption/Decryption
*/
FileEncryptionExample() {
    ; Create test file
    originalFile := A_ScriptDir "\secret_document.txt"
    FileDelete(originalFile)
    FileAppend("This is confidential information.`nLine 2: Secret data`nLine 3: More secrets", originalFile)

    password := "FileEncryptionKey789"

    ; Read file
    file := FileOpen(originalFile, "r")
    fileSize := file.Length
    buffer := Buffer(fileSize + 16)  ; Extra space for encryption
    file.RawRead(buffer, fileSize)
    file.Close()

    ; Encrypt
    encryptedSize := Crypt_AES(buffer, fileSize, password, 256, true)

    ; Save encrypted file
    encryptedFile := A_ScriptDir "\secret_document.txt.encrypted"
    file := FileOpen(encryptedFile, "w")
    file.RawWrite(buffer, encryptedSize)
    file.Close()

    output := "File Encryption Complete!`n`n"
    output .= "Original: " originalFile " (" fileSize " bytes)`n"
    output .= "Encrypted: " encryptedFile " (" encryptedSize " bytes)`n`n"
    output .= "File is now encrypted with AES-256"

    MsgBox(output)

    ; Now decrypt
    file := FileOpen(encryptedFile, "r")
    file.RawRead(buffer, encryptedSize)
    file.Close()

    ; Decrypt
    decryptedSize := Crypt_AES(buffer, encryptedSize, password, 256, false)

    ; Save decrypted file
    decryptedFile := A_ScriptDir "\secret_document.txt.decrypted"
    file := FileOpen(decryptedFile, "w")
    file.RawWrite(buffer, decryptedSize)
    file.Close()

    MsgBox("File Decryption Complete!`nDecrypted: " decryptedFile)

    ; Cleanup
    FileDelete(originalFile)
    FileDelete(encryptedFile)
    FileDelete(decryptedFile)
}

/**
* Example 10: Data Integrity with Hash Comparison
*/
DataIntegritySystemExample() {
    ; Simulate a data integrity system

    ; Create test files
    file1 := A_ScriptDir "\document1.txt"
    file2 := A_ScriptDir "\document2.txt"

    FileDelete(file1)
    FileDelete(file2)
    FileAppend("Document 1 content", file1)
    FileAppend("Document 2 content", file2)

    ; Register files
    DataIntegrity.RegisterFile(file1)
    DataIntegrity.RegisterFile(file2)

    MsgBox("Files registered for integrity monitoring")

    ; Modify one file
    FileDelete(file2)
    FileAppend("Document 2 MODIFIED content", file2)

    ; Check integrity
    report := DataIntegrity.GetReport()
    MsgBox("Integrity Report:`n`n" report)

    ; Cleanup
    FileDelete(file1)
    FileDelete(file2)
}

; Display menu
MsgBox("Cryptography Library Examples Loaded`n`n"
. "Available Examples:`n`n"
. "1. MD5HashExample() - MD5 hash of strings`n"
. "2. MD5FileExample() - MD5 hash of files`n"
. "3. FileIntegrityExample() - Verify file integrity`n"
. "4. SHA1HashExample() - SHA1 hashing`n"
. "5. CRC32Example() - CRC32 checksums`n"
. "6. AESEncryptExample() - AES-256 encryption`n"
. "7. AESDecryptExample() - AES-256 decryption`n"
. "8. PasswordHashExample() - Password hashing (with warnings)`n"
. "9. FileEncryptionExample() - Encrypt/decrypt files`n"
. "10. DataIntegritySystemExample() - Complete integrity system`n`n"
. "Uncomment any function call below to run")

; Uncomment to run examples:
; MD5HashExample()
; MD5FileExample()
; FileIntegrityExample()
; SHA1HashExample()
; CRC32Example()
; AESEncryptExample()
; AESDecryptExample()
; PasswordHashExample()
; FileEncryptionExample()
; DataIntegritySystemExample()

; Moved class DataIntegrity from nested scope
class DataIntegrity {
    static hashDatabase := Map()

    ; Store file hash
    static RegisterFile(filePath) {
        if (!FileExist(filePath))
        return false

        hash := MD5_File(filePath)
        this.hashDatabase[filePath] := hash
        return hash
    }

    ; Verify file hasn't changed
    static VerifyFile(filePath) {
        if (!FileExist(filePath))
        return {valid: false, reason: "File not found"}

        if (!this.hashDatabase.Has(filePath))
        return {valid: false, reason: "File not registered"}

        currentHash := MD5_File(filePath)
        storedHash := this.hashDatabase[filePath]

        if (currentHash = storedHash)
        return {valid: true, hash: currentHash}
        else
        return {valid: false, reason: "Hash mismatch", stored: storedHash, current: currentHash}
    }

    ; Get integrity report
    static GetReport() {
        report := "Registered Files:`n`n"
        for filePath, hash in this.hashDatabase {
            status := this.VerifyFile(filePath)
            report .= filePath "`n"
            report .= "  Hash: " hash "`n"
            report .= "  Status: " (status.valid ? "✓ Valid" : "✗ Modified") "`n`n"
        }
        return report
    }
}
