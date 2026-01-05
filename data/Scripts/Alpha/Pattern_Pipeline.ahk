#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Pipeline Pattern - Processes data through sequence of stages
; Demonstrates functional composition with chainable transformations

class Pipeline {
    __New() => this.stages := []

    Pipe(stage) {
        this.stages.Push(stage)
        return this
    }

    Process(input) {
        result := input
        for stage in this.stages
            result := stage.Process(result)
        return result
    }
}

; Stage implementations
class TrimStage {
    Process(data) => Trim(data)
}

class UpperStage {
    Process(data) => StrUpper(data)
}

class LowerStage {
    Process(data) => StrLower(data)
}

class ValidateStage {
    __New(minLength := 1) => this.minLength := minLength

    Process(data) {
        if StrLen(data) < this.minLength
            throw Error("Input too short (min: " this.minLength ")")
        return data
    }
}

class ReplaceStage {
    __New(search, replace) {
        this.search := search
        this.replace := replace
    }
    Process(data) => StrReplace(data, this.search, this.replace)
}

class PrefixStage {
    __New(prefix) => this.prefix := prefix
    Process(data) => this.prefix data
}

class SuffixStage {
    __New(suffix) => this.suffix := suffix
    Process(data) => data this.suffix
}

; Demo - build processing pipelines
usernamePipeline := Pipeline()
    .Pipe(TrimStage())
    .Pipe(LowerStage())
    .Pipe(ReplaceStage(" ", "_"))
    .Pipe(ValidateStage(3))

slugPipeline := Pipeline()
    .Pipe(TrimStage())
    .Pipe(LowerStage())
    .Pipe(ReplaceStage(" ", "-"))
    .Pipe(PrefixStage("/articles/"))
    .Pipe(SuffixStage("/"))

; Process data
username := usernamePipeline.Process("  John Doe  ")
slug := slugPipeline.Process("  Hello World Article  ")

MsgBox("Username: " username "`nSlug: " slug)
