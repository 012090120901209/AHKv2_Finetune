#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Version - Semantic versioning with comparison
; Demonstrates version parsing, comparison, and bumping

class Version {
    __New(major, minor := 0, patch := 0, prerelease := "") {
        this.major := major
        this.minor := minor
        this.patch := patch
        this.prerelease := prerelease
    }

    static Parse(str) {
        prerelease := ""
        
        ; Check for prerelease tag
        if InStr(str, "-") {
            parts := StrSplit(str, "-", , 2)
            str := parts[1]
            prerelease := parts[2]
        }
        
        parts := StrSplit(str, ".")
        return Version(
            parts.Length >= 1 ? Integer(parts[1]) : 0,
            parts.Length >= 2 ? Integer(parts[2]) : 0,
            parts.Length >= 3 ? Integer(parts[3]) : 0,
            prerelease
        )
    }

    Compare(other) {
        if this.major != other.major
            return this.major - other.major
        if this.minor != other.minor
            return this.minor - other.minor
        if this.patch != other.patch
            return this.patch - other.patch
        
        ; Prerelease versions are less than release
        if this.prerelease && !other.prerelease
            return -1
        if !this.prerelease && other.prerelease
            return 1
        
        ; Compare prerelease strings
        return StrCompare(this.prerelease, other.prerelease)
    }

    IsGreaterThan(other) => this.Compare(other) > 0
    IsLessThan(other) => this.Compare(other) < 0
    IsEqual(other) => this.Compare(other) = 0
    
    Satisfies(constraint) {
        ; Simple constraint matching (^, ~, >=, etc.)
        op := ""
        ver := constraint
        
        if SubStr(constraint, 1, 2) = ">="
            op := ">=", ver := SubStr(constraint, 3)
        else if SubStr(constraint, 1, 2) = "<="
            op := "<=", ver := SubStr(constraint, 3)
        else if SubStr(constraint, 1, 1) = ">"
            op := ">", ver := SubStr(constraint, 2)
        else if SubStr(constraint, 1, 1) = "<"
            op := "<", ver := SubStr(constraint, 2)
        else if SubStr(constraint, 1, 1) = "^"
            op := "^", ver := SubStr(constraint, 2)
        else if SubStr(constraint, 1, 1) = "~"
            op := "~", ver := SubStr(constraint, 2)
        else
            op := "=", ver := constraint
        
        other := Version.Parse(ver)
        
        switch op {
            case ">=": return !this.IsLessThan(other)
            case "<=": return !this.IsGreaterThan(other)
            case ">": return this.IsGreaterThan(other)
            case "<": return this.IsLessThan(other)
            case "=": return this.IsEqual(other)
            case "^": return this.major = other.major && !this.IsLessThan(other)
            case "~": return this.major = other.major && this.minor = other.minor && !this.IsLessThan(other)
        }
        return false
    }

    Bump(part := "patch") {
        switch part {
            case "major": return Version(this.major + 1, 0, 0)
            case "minor": return Version(this.major, this.minor + 1, 0)
            default: return Version(this.major, this.minor, this.patch + 1)
        }
    }

    ToString() {
        str := this.major "." this.minor "." this.patch
        if this.prerelease
            str .= "-" this.prerelease
        return str
    }
}

; Demo
v1 := Version.Parse("1.2.3")
v2 := Version.Parse("1.2.4")
v3 := Version.Parse("2.0.0-alpha")

MsgBox("Version Comparison:`n"
     . v1.ToString() " vs " v2.ToString() ": "
     . (v1.IsLessThan(v2) ? "less" : (v1.IsGreaterThan(v2) ? "greater" : "equal")) "`n"
     . v2.ToString() " vs " v3.ToString() ": "
     . (v2.IsLessThan(v3) ? "less" : (v2.IsGreaterThan(v3) ? "greater" : "equal")))

; Bumping
current := Version.Parse("1.5.9")
MsgBox("Current: " current.ToString() "`n"
     . "Patch bump: " current.Bump("patch").ToString() "`n"
     . "Minor bump: " current.Bump("minor").ToString() "`n"
     . "Major bump: " current.Bump("major").ToString())

; Constraints
ver := Version.Parse("1.5.3")
constraints := [">=1.0.0", "^1.0.0", "~1.5.0", "<2.0.0", ">=2.0.0"]

result := ver.ToString() " satisfies:`n"
for constraint in constraints
    result .= constraint ": " ver.Satisfies(constraint) "`n"

MsgBox(result)
