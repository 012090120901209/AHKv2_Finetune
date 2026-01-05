#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Hash Functions - String hashing algorithms
; Demonstrates common non-cryptographic hash functions

class Hash {
    ; DJB2 - Simple and fast string hash
    static DJB2(str) {
        hash := 5381
        Loop StrLen(str)
            hash := ((hash << 5) + hash) + Ord(SubStr(str, A_Index, 1))
        return hash & 0x7FFFFFFF
    }

    ; FNV-1a - Fowler-Noll-Vo hash
    static FNV1a(str) {
        hash := 2166136261
        Loop StrLen(str) {
            hash ^= Ord(SubStr(str, A_Index, 1))
            hash := (hash * 16777619) & 0xFFFFFFFF
        }
        return hash
    }

    ; SDBM hash
    static SDBM(str) {
        hash := 0
        Loop StrLen(str) {
            char := Ord(SubStr(str, A_Index, 1))
            hash := char + (hash << 6) + (hash << 16) - hash
            hash := hash & 0xFFFFFFFF
        }
        return hash
    }

    ; Jenkins One-at-a-time
    static Jenkins(str) {
        hash := 0
        Loop StrLen(str) {
            hash += Ord(SubStr(str, A_Index, 1))
            hash += (hash << 10)
            hash ^= (hash >> 6)
        }
        hash += (hash << 3)
        hash ^= (hash >> 11)
        hash += (hash << 15)
        return hash & 0xFFFFFFFF
    }
}

; String Distance - Similarity metrics
class StringDistance {
    ; Levenshtein edit distance
    static Levenshtein(s1, s2) {
        m := StrLen(s1)
        n := StrLen(s2)

        if m = 0
            return n
        if n = 0
            return m

        ; Use two rows instead of full matrix
        prev := []
        curr := []

        Loop n + 1
            prev.Push(A_Index - 1)

        Loop m {
            i := A_Index
            curr := [i]

            Loop n {
                j := A_Index
                cost := SubStr(s1, i, 1) = SubStr(s2, j, 1) ? 0 : 1
                curr.Push(Min(
                    prev[j + 1] + 1,      ; deletion
                    curr[j] + 1,           ; insertion
                    prev[j] + cost         ; substitution
                ))
            }
            prev := curr
        }

        return prev[n + 1]
    }

    ; Similarity ratio (0 to 1)
    static Similarity(s1, s2) {
        maxLen := Max(StrLen(s1), StrLen(s2))
        if maxLen = 0
            return 1
        return 1 - this.Levenshtein(s1, s2) / maxLen
    }

    ; Hamming distance (equal length strings)
    static Hamming(s1, s2) {
        if StrLen(s1) != StrLen(s2)
            throw Error("Strings must be same length")

        distance := 0
        Loop StrLen(s1)
            if SubStr(s1, A_Index, 1) != SubStr(s2, A_Index, 1)
                distance++
        return distance
    }
}

; Demo - Hashing
testStrings := ["hello", "Hello", "world", "hello world"]

result := "Hash Comparison:`n`n"
for str in testStrings {
    result .= '"' str '":`n'
    result .= "  DJB2:    " Hash.DJB2(str) "`n"
    result .= "  FNV1a:   " Hash.FNV1a(str) "`n"
    result .= "  Jenkins: " Hash.Jenkins(str) "`n"
}

MsgBox(result)

; Demo - String Distance
pairs := [
    ["kitten", "sitting"],
    ["hello", "hallo"],
    ["AutoHotkey", "AutoHotKey"]
]

result := "String Distance:`n`n"
for pair in pairs {
    s1 := pair[1]
    s2 := pair[2]
    dist := StringDistance.Levenshtein(s1, s2)
    sim := StringDistance.Similarity(s1, s2)
    result .= '"' s1 '" vs "' s2 '":`n'
    result .= "  Distance: " dist ", Similarity: " Round(sim * 100, 1) "%`n"
}

MsgBox(result)
