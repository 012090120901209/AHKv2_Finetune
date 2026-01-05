#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * CLR - Cryptography with .NET
 * 
 * Demonstrates using .NET cryptography classes for hashing, encryption,
 * and secure random number generation.
 * 
 * Library: https://github.com/Lexikos/CLR.ahk
 */

MsgBox("CLR - Cryptography Example`n`n"
    . "Demonstrates .NET encryption and hashing`n"
    . "Requires: CLR.ahk and .NET Framework 4.0+", , "T3")

/*
; Uncomment to run (requires CLR.ahk):

#Include <CLR>

; Initialize CLR
CLR_Start("v4.0.30319")

; Compile Crypto Helper Class
cryptoCode := "
(
using System;
using System.Security.Cryptography;
using System.Text;

public class CryptoHelper {
    public static string ComputeSHA256(string text) {
        using (SHA256 sha = SHA256.Create()) {
            byte[] bytes = Encoding.UTF8.GetBytes(text);
            byte[] hash = sha.ComputeHash(bytes);
            return BitConverter.ToString(hash).Replace(""-"", """").ToLower();
        }
    }

    public static string ComputeMD5(string text) {
        using (MD5 md5 = MD5.Create()) {
            byte[] bytes = Encoding.UTF8.GetBytes(text);
            byte[] hash = md5.ComputeHash(bytes);
            return BitConverter.ToString(hash).Replace(""-"", """").ToLower();
        }
    }

    public static string GenerateRandomPassword(int length) {
        const string chars = ""ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()"";
        using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider()) {
            byte[] data = new byte[length];
            rng.GetBytes(data);

            StringBuilder result = new StringBuilder(length);
            for (int i = 0; i < length; i++) {
                result.Append(chars[data[i] % chars.Length]);
            }
            return result.ToString();
        }
    }

    public static byte[] EncryptAES(string plainText, string password) {
        using (Aes aes = Aes.Create()) {
            Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, new byte[] {
                0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64
            });

            aes.Key = key.GetBytes(aes.KeySize / 8);
            aes.IV = key.GetBytes(aes.BlockSize / 8);

            using (ICryptoTransform encryptor = aes.CreateEncryptor()) {
                byte[] plainBytes = Encoding.UTF8.GetBytes(plainText);
                return encryptor.TransformFinalBlock(plainBytes, 0, plainBytes.Length);
            }
        }
    }

    public static string DecryptAES(byte[] cipherText, string password) {
        using (Aes aes = Aes.Create()) {
            Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, new byte[] {
                0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64
            });

            aes.Key = key.GetBytes(aes.KeySize / 8);
            aes.IV = key.GetBytes(aes.BlockSize / 8);

            using (ICryptoTransform decryptor = aes.CreateDecryptor()) {
                byte[] decrypted = decryptor.TransformFinalBlock(cipherText, 0, cipherText.Length);
                return Encoding.UTF8.GetString(decrypted);
            }
        }
    }

    public static string BytesToHex(byte[] bytes) {
        return BitConverter.ToString(bytes).Replace(""-"", """").ToLower();
    }
}
)"

; Compile the C# code
refs := "System.dll"
asm := CLR_CompileCS(cryptoCode, refs)
Crypto := asm.GetType("CryptoHelper")

; Example 1: Hashing
text := "Hello, World!"
sha256 := Crypto.ComputeSHA256(text)
md5 := Crypto.ComputeMD5(text)

MsgBox("Hashing:`n`n"
. "Text: " text "`n`n"
. "SHA256: " sha256 "`n`n"
. "MD5: " md5, , "T8")

; Example 2: Password Generation
password1 := Crypto.GenerateRandomPassword(16)
password2 := Crypto.GenerateRandomPassword(20)
password3 := Crypto.GenerateRandomPassword(24)

MsgBox("Secure Random Passwords:`n`n"
. "16 chars: " password1 "`n"
. "20 chars: " password2 "`n"
. "24 chars: " password3, , "T5")

; Example 3: AES Encryption
plainText := "This is a secret message!"
password := "MySecurePassword123"

encrypted := Crypto.EncryptAES(plainText, password)
encryptedHex := Crypto.BytesToHex(encrypted)

MsgBox("AES Encryption:`n`n"
. "Plain: " plainText "`n`n"
. "Encrypted (hex): " encryptedHex, , "T5")

; Example 4: AES Decryption
decrypted := Crypto.DecryptAES(encrypted, password)

MsgBox("AES Decryption:`n`n"
. "Encrypted: [" encrypted.Length " bytes]`n`n"
. "Decrypted: " decrypted "`n`n"
. "Match: " (decrypted == plainText ? "✓" : "✗"), , "T5")

; Example 5: Wrong password
try {
    wrongDecrypt := Crypto.DecryptAES(encrypted, "WrongPassword")
} catch as e {
    MsgBox("Decryption with wrong password:`n`nFailed (as expected):`n" Type(e), , "T3")
}
*/

/*
* Key Concepts:
*
* 1. Hashing Algorithms:
*    SHA256 - Secure, 256-bit
*    SHA512 - More secure, 512-bit
*    MD5 - Legacy, not secure
*
* 2. Symmetric Encryption:
*    AES (Advanced Encryption Standard)
*    Same key for encrypt/decrypt
*    Very fast, secure
*
* 3. Key Derivation:
*    Rfc2898DeriveBytes (PBKDF2)
*    Derives key from password
*    Uses salt and iterations
*
* 4. Secure Random:
*    RNGCryptoServiceProvider
*    Cryptographically secure
*    Better than Random class
*
* 5. Using Statements:
*    using (obj) { ... }
*    Automatically disposes
*    Clears sensitive data
*
* 6. Common Use Cases:
*    ✅ Password hashing
*    ✅ File encryption
*    ✅ Secure token generation
*    ✅ Data integrity (HMAC)
*    ✅ Digital signatures
*
* 7. Best Practices:
*    ✅ Use SHA256+ (not MD5)
*    ✅ Use AES for encryption
*    ✅ Never store passwords plaintext
*    ✅ Use salt for password hashes
*    ✅ Dispose crypto objects
*
* 8. Asymmetric Encryption:
*    RSA - Public/private key
*    Different keys encrypt/decrypt
*    Slower but more secure
*
* 9. .NET Crypto Classes:
*    SHA256, SHA512 - Hashing
*    Aes - Symmetric encryption
*    RSA - Asymmetric encryption
*    RNGCryptoServiceProvider - Random
*    HMACSHA256 - Keyed hashing
*
* 10. Security Notes:
*     ⚠ Don't invent your own crypto
*     ⚠ Use established algorithms
*     ⚠ Keep keys secure
*     ⚠ Use proper key sizes
*     ⚠ Update algorithms regularly
*/

