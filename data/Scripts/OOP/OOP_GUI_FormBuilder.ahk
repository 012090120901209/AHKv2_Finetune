#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP GUI: Form Builder with Validation
; Demonstrates: Dynamic form creation, validation, OOP GUI patterns

class FormField {
    __New(name, label, type := "Edit") {
        this.name := name
        this.label := label
        this.type := type
        this.value := ""
        this.control := ""
        this.validators := []
        this.required := false
        this.errorMessage := ""
    }

    AddValidator(validator) => (this.validators.Push(validator), this)
    SetRequired(required := true) => (this.required := required, this)

    Validate() {
        if (this.required && !this.value)
            return (this.errorMessage := "This field is required", false)

        for validator in this.validators {
            if (!validator.Validate(this.value)) {
                this.errorMessage := validator.message
                return false
            }
        }

        this.errorMessage := ""
        return true
    }
}

class Validator {
    __New(message) => this.message := message
    Validate(value) => true  ; Override in subclasses
}

class EmailValidator extends Validator {
    __New() => super.__New("Invalid email address")
    Validate(value) => InStr(value, "@") && InStr(value, ".")
}

class MinLengthValidator extends Validator {
    __New(minLength) => (super.__New("Minimum length: " . minLength), this.minLength := minLength)
    Validate(value) => StrLen(value) >= this.minLength
}

class NumericValidator extends Validator {
    __New() => super.__New("Must be a number")
    Validate(value) => IsNumber(value)
}

class Form {
    __New(title) {
        this.title := title
        this.fields := []
        this.gui := ""
        this.onSubmit := ""
    }

    AddField(field) => (this.fields.Push(field), this)

    SetSubmitCallback(callback) => (this.onSubmit := callback, this)

    Build() {
        this.gui := Gui(, this.title)
        this.gui.SetFont("s10")

        y := 10
        for field in this.fields {
            this.gui.Add("Text", "x10 y" . y . " w100", field.label . (field.required ? " *" : ""))

            if (field.type = "Edit")
                field.control := this.gui.Add("Edit", "x120 y" . y . " w250")
            else if (field.type = "DropDownList")
                field.control := this.gui.Add("DropDownList", "x120 y" . y . " w250", ["Option 1", "Option 2", "Option 3"])

            y += 30
        }

        this.gui.Add("Button", "x120 y" . (y + 10) . " w100", "Submit").OnEvent("Click", (*) => this.HandleSubmit())
        this.gui.Add("Button", "x230 y" . (y + 10) . " w100", "Cancel").OnEvent("Click", (*) => this.gui.Destroy())

        this.gui.Show()
        return this
    }

    HandleSubmit() {
        ; Get values
        for field in this.fields
            field.value := field.control.Value

        ; Validate all fields
        isValid := true
        errors := []

        for field in this.fields {
            if (!field.Validate()) {
                isValid := false
                errors.Push(field.label . ": " . field.errorMessage)
            }
        }

        if (!isValid) {
            MsgBox("Validation errors:`n`n" . errors.Join("`n"), "Error", "Icon!")
            return
        }

        ; Call submit callback
        if (this.onSubmit)
            this.onSubmit.Call(this.GetFormData())

        this.gui.Destroy()
    }

    GetFormData() {
        data := Map()
        for field in this.fields
            data[field.name] := field.value
        return data
    }
}

; Usage
formobj := Form("User Registration")

; Add fields with validation
nameField := FormField("name", "Full Name")
    .SetRequired()
    .AddValidator(MinLengthValidator(3))

emailField := FormField("email", "Email")
    .SetRequired()
    .AddValidator(EmailValidator())

ageField := FormField("age", "Age")
    .SetRequired()
    .AddValidator(NumericValidator())

formobj .AddField(nameField)
    .AddField(emailField)
    .AddField(ageField)

; Set submit callback
formobj .SetSubmitCallback((data) => MsgBox("Form submitted!`n`nName: " . data["name"] . "`nEmail: " . data["email"] . "`nAge: " . data["age"]))

formobj .Build()
