#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Bloom Filter - Probabilistic set membership testing
; Demonstrates space-efficient membership queries

class BloomFilter {
    __New(size := 1000, hashCount := 3) {
        this.size := size
        this.hashCount := hashCount
        this.bits := []
        Loop size
            this.bits.Push(0)
        this.itemCount := 0
    }

    Add(item) {
        for hash in this.GetHashes(item)
            this.bits[hash] := 1
        this.itemCount++
    }

    MightContain(item) {
        for hash in this.GetHashes(item)
            if !this.bits[hash]
                return false
        return true
    }

    GetHashes(item) {
        hashes := []
        str := String(item)
        Loop this.hashCount {
            hash := this.Hash(str, A_Index)
            hashes.Push(Mod(hash, this.size) + 1)
        }
        return hashes
    }

    Hash(str, seed) {
        hash := seed
        Loop StrLen(str)
            hash := (hash * 31 + Ord(SubStr(str, A_Index, 1))) & 0x7FFFFFFF
        return hash
    }

    ; Estimate false positive rate
    FalsePositiveRate() {
        ; Formula: (1 - e^(-kn/m))^k
        k := this.hashCount
        n := this.itemCount
        m := this.size

        if n = 0
            return 0

        return (1 - Exp(-k * n / m)) ** k
    }
}

; Demo - email blocklist
blocklist := BloomFilter(1000, 3)

; Add known spam emails
spamEmails := ["spam@bad.com", "phish@evil.org", "scam@fake.net"]
for email in spamEmails
    blocklist.Add(email)

; Check emails
testEmails := ["spam@bad.com", "hello@good.com", "phish@evil.org", "user@normal.com"]

result := "Email Check Results:`n"
for email in testEmails {
    status := blocklist.MightContain(email) ? "MIGHT BE SPAM" : "OK"
    result .= email ": " status "`n"
}

result .= "`nFalse positive rate: " Round(blocklist.FalsePositiveRate() * 100, 4) "%"

MsgBox(result)
