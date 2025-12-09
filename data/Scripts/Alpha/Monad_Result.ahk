#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Result/Either Monad - Represents success or failure with value
; Demonstrates railway-oriented programming with chained operations

class Result {
    __New(value, error := "") {
        this.value := value
        this.error := error
        this.isSuccess := error = ""
    }

    static Ok(value) => Result(value)
    static Fail(error) => Result("", error)
    
    static Try(fn, args*) {
        try
            return Result.Ok(fn(args*))
        catch as e
            return Result.Fail(e.Message)
    }

    Map(fn) {
        if !this.isSuccess
            return this
        try
            return Result.Ok(fn(this.value))
        catch as e
            return Result.Fail(e.Message)
    }

    FlatMap(fn) {
        if !this.isSuccess
            return this
        return fn(this.value)
    }
    
    MapError(fn) {
        if this.isSuccess
            return this
        return Result.Fail(fn(this.error))
    }

    GetOrElse(defaultVal) => this.isSuccess ? this.value : defaultVal
    
    GetOrThrow() {
        if !this.isSuccess
            throw Error(this.error)
        return this.value
    }
    
    Match(onSuccess, onFailure) {
        return this.isSuccess ? onSuccess(this.value) : onFailure(this.error)
    }
}

; Demo - chain operations
ParseInt(str) {
    if !RegExMatch(str, "^\d+$")
        throw Error("Not a valid integer")
    return Integer(str)
}

Double(n) => n * 2
AddTen(n) => n + 10

; Success case
successResult := Result.Try(ParseInt, "42")
    .Map(Double)
    .Map(AddTen)
    .Match(
        (v) => "Success: " v,
        (e) => "Error: " e
    )

MsgBox("Valid input: " successResult)

; Failure case
failResult := Result.Try(ParseInt, "not a number")
    .Map(Double)
    .Map(AddTen)
    .Match(
        (v) => "Success: " v,
        (e) => "Error: " e
    )

MsgBox("Invalid input: " result)
