#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 SendText Function - Form Filling
 * ============================================================================
 *
 * Demonstrates using SendText for reliable form filling, data entry,
 * and text input where special characters must not be interpreted.
 *
 * @module BuiltIn_SendText_02
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Basic Form Fields
; ============================================================================

/**
 * Fills text input fields safely.
 * All characters sent literally regardless of content.
 *
 * @example
 * ; Press F1 for basic form filling
 */
F1:: {
    ToolTip("Basic form filling in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Name field
    SendText("John Doe")
    Send("{Tab}")
    Sleep(200)

    ; Email field
    SendText("john.doe@example.com")
    Send("{Tab}")
    Sleep(200)

    ; Phone field
    SendText("555-1234")

    ToolTip("Form filled!")
    Sleep(1500)
    ToolTip()
}

/**
 * Fills form with special character data
 * Demonstrates safe handling of special chars
 */
F2:: {
    ToolTip("Special character form in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Company name with special chars
    SendText("Smith & Johnson, Inc.")
    Send("{Tab}")
    Sleep(200)

    ; Address with special characters
    SendText("123 Main St. #456")
    Send("{Tab}")
    Sleep(200)

    ; Description with punctuation
    SendText("Contact us @ support! Questions? Call +1-555-0100.")

    ToolTip("Special character form filled!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Example 2: Multi-Field Data Entry
; ============================================================================

/**
 * Fills multi-field registration form.
 * Complete user registration workflow.
 *
 * @description
 * Demonstrates comprehensive form automation
 */
^F1:: {
    ToolTip("Registration form in 2 seconds...")
    Sleep(2000)
    ToolTip()

    registrationData := {
        firstName: "John",
        lastName: "Doe",
        email: "john.doe+test@example.com",
        username: "jdoe123",
        password: "P@ssw0rd!2024#Secure",
        confirmPassword: "P@ssw0rd!2024#Secure",
        phone: "(555) 123-4567",
        company: "Smith & Co., LLC"
    }

    fields := ["firstName", "lastName", "email", "username", "password", "confirmPassword", "phone", "company"]

    for index, fieldName in fields {
        ToolTip("Field: " fieldName " (" index "/" fields.Length ")")

        SendText(registrationData.%fieldName%)
        Send("{Tab}")

        Sleep(200)
    }

    ToolTip("Registration complete!")
    Sleep(2000)
    ToolTip()
}

/**
 * Fills survey form
 * Multiple choice and text responses
 */
^F2:: {
    ToolTip("Survey form in 2 seconds...")
    Sleep(2000)
    ToolTip()

    surveyResponses := [
        "Very satisfied with the service!",
        "The product quality is excellent & pricing is fair.",
        "Delivery was on time (2-3 days).",
        "Customer support: 5/5 stars!",
        "Will recommend to friends & family."
    ]

    for index, response in surveyResponses {
        ToolTip("Response " index " of " surveyResponses.Length)

        SendText(response)
        Send("{Tab}")

        Sleep(300)
    }

    ToolTip("Survey submitted!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 3: Address and Contact Forms
; ============================================================================

/**
 * Fills shipping address form.
 * Complete address with special formatting.
 *
 * @description
 * Address entry automation
 */
^F3:: {
    ToolTip("Address form in 2 seconds...")
    Sleep(2000)
    ToolTip()

    address := {
        street: "123 Main Street, Apt. #4B",
        city: "Springfield",
        state: "IL",
        zip: "62701",
        country: "United States",
        instructions: "Use rear entrance; Ring bell #4"
    }

    ; Street
    SendText(address.street)
    Send("{Tab}")
    Sleep(200)

    ; City
    SendText(address.city)
    Send("{Tab}")
    Sleep(200)

    ; State
    SendText(address.state)
    Send("{Tab}")
    Sleep(200)

    ; ZIP
    SendText(address.zip)
    Send("{Tab}")
    Sleep(200)

    ; Country
    SendText(address.country)
    Send("{Tab}")
    Sleep(200)

    ; Delivery instructions
    SendText(address.instructions)

    ToolTip("Address form complete!")
    Sleep(2000)
    ToolTip()
}

/**
 * Fills contact information form
 * Multiple contact methods
 */
^F4:: {
    ToolTip("Contact form in 2 seconds...")
    Sleep(2000)
    ToolTip()

    contact := [
        {field: "Primary Phone", value: "(555) 123-4567 ext. 100"},
        {field: "Mobile", value: "+1 (555) 987-6543"},
        {field: "Email", value: "contact@example.com"},
        {field: "Website", value: "https://www.example.com/contact?ref=form"},
        {field: "Fax", value: "(555) 123-4568"}
    ]

    for index, item in contact {
        ToolTip("Filling: " item.field)

        SendText(item.value)
        Send("{Tab}")

        Sleep(250)
    }

    ToolTip("Contact form complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 4: Financial and Payment Forms
; ============================================================================

/**
 * Fills payment information form.
 * Credit card and billing details.
 *
 * @description
 * Secure payment form filling
 */
^F5:: {
    ToolTip("Payment form in 2 seconds...")
    Sleep(2000)
    ToolTip()

    payment := {
        cardNumber: "4532 1234 5678 9010",
        expiry: "12/25",
        cvv: "123",
        cardName: "John Q. Doe",
        billingAddress: "123 Main St., Apt. #4B",
        billingZip: "62701"
    }

    ; Card number
    SendText(payment.cardNumber)
    Send("{Tab}")
    Sleep(200)

    ; Expiry
    SendText(payment.expiry)
    Send("{Tab}")
    Sleep(200)

    ; CVV
    SendText(payment.cvv)
    Send("{Tab}")
    Sleep(200)

    ; Name on card
    SendText(payment.cardName)
    Send("{Tab}")
    Sleep(200)

    ; Billing address
    SendText(payment.billingAddress)
    Send("{Tab}")
    Sleep(200)

    ; ZIP
    SendText(payment.zip)

    ToolTip("Payment form complete!")
    Sleep(2000)
    ToolTip()
}

/**
 * Fills tax/invoice form
 * Financial data with symbols
 */
^F6:: {
    ToolTip("Invoice form in 2 seconds...")
    Sleep(2000)
    ToolTip()

    invoice := [
        {field: "Invoice #", value: "INV-2024-001"},
        {field: "Amount", value: "$1,234.56"},
        {field: "Tax", value: "$123.46 (10%)"},
        {field: "Total", value: "$1,358.02"},
        {field: "Notes", value: "Payment due in 30 days; 2% discount if paid within 10 days"}
    ]

    for index, item in invoice {
        ToolTip("Field: " item.field)

        SendText(item.value)
        Send("{Tab}")

        Sleep(250)
    }

    ToolTip("Invoice form complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 5: Comment and Feedback Forms
; ============================================================================

/**
 * Fills comment/feedback forms.
 * Multi-line text with special characters.
 *
 * @description
 * Feedback form automation
 */
^F7:: {
    ToolTip("Feedback form in 2 seconds...")
    Sleep(2000)
    ToolTip()

    feedback := "
    (
    Great product! Very satisfied.

    Pros:
    - Fast shipping & delivery
    - Excellent quality @ reasonable price
    - Good customer support (5/5 stars!)

    Cons:
    - Instructions could be clearer
    - Packaging was damaged (minor)

    Overall: 4.5/5 - Would recommend!

    Questions? Contact: support@example.com
    )"

    SendText(StrReplace(feedback, "`n    ", "`n"))

    ToolTip("Feedback submitted!")
    Sleep(2000)
    ToolTip()
}

/**
 * Fills bug report form
 * Technical details with special characters
 */
^F8:: {
    ToolTip("Bug report form in 2 seconds...")
    Sleep(2000)
    ToolTip()

    bugReport := "
    (
    BUG REPORT

    Summary: Application crashes when using special chars (^, +, !, @)

    Steps to Reproduce:
    1. Open file with name "test@file#123.txt"
    2. Click "Process & Save"
    3. Error appears: "Cannot process: Invalid chars!"

    Expected: File should process successfully
    Actual: Application crashes

    Error code: ERR_SPECIAL_CHARS_001
    Log file: C:\Logs\error-2024-01-01.log

    Environment:
    - OS: Windows 11 (22H2)
    - Version: 2.5.3 (build #4521)
    - User: admin@localhost
    )"

    SendText(StrReplace(bugReport, "`n    ", "`n"))

    ToolTip("Bug report submitted!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 6: Profile and Bio Forms
; ============================================================================

/**
 * Fills user profile form.
 * Personal information and bio.
 *
 * @description
 * Profile creation automation
 */
^F9:: {
    ToolTip("Profile form in 2 seconds...")
    Sleep(2000)
    ToolTip()

    profile := {
        displayName: "John Doe (JD)",
        tagline: "Software Engineer @ Tech Corp",
        bio: "Full-stack developer with 10+ years experience. Interested in AI & ML. Contact: john@example.com",
        website: "https://johndoe.dev/?ref=profile",
        location: "San Francisco, CA, USA",
        languages: "English, Spanish, French"
    }

    ; Display name
    SendText(profile.displayName)
    Send("{Tab}")
    Sleep(200)

    ; Tagline
    SendText(profile.tagline)
    Send("{Tab}")
    Sleep(200)

    ; Bio
    SendText(profile.bio)
    Send("{Tab}")
    Sleep(200)

    ; Website
    SendText(profile.website)
    Send("{Tab}")
    Sleep(200)

    ; Location
    SendText(profile.location)
    Send("{Tab}")
    Sleep(200)

    ; Languages
    SendText(profile.languages)

    ToolTip("Profile complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 7: Batch Form Filling
; ============================================================================

/**
 * Fills multiple forms in sequence.
 * Bulk data entry automation.
 *
 * @description
 * Batch processing demonstration
 */
^F10:: {
    ToolTip("Batch form filling in 2 seconds...")
    Sleep(2000)
    ToolTip()

    records := [
        {name: "Alice Smith", email: "alice@example.com", company: "ABC Corp."},
        {name: "Bob Johnson", email: "bob@example.com", company: "XYZ Inc. & Partners"},
        {name: "Carol White", email: "carol@example.com", company: "Tech Solutions, LLC"}
    ]

    for index, record in records {
        ToolTip("Record " index " of " records.Length)

        ; Name
        SendText(record.name)
        Send("{Tab}")
        Sleep(100)

        ; Email
        SendText(record.email)
        Send("{Tab}")
        Sleep(100)

        ; Company
        SendText(record.company)
        Send("{Enter}")  ; Submit form
        Sleep(500)
    }

    ToolTip("Batch filling complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Fills form from data object
 *
 * @param {Object} data - Form data
 * @param {Number} delay - Delay between fields (ms)
 */
FillForm(data, delay := 200) {
    for fieldName, value in data.OwnProps() {
        SendText(value)
        Send("{Tab}")
        Sleep(delay)
    }
}

/**
 * Fills form from array
 *
 * @param {Array} fields - Array of field values
 * @param {Number} delay - Delay between fields (ms)
 */
FillFormArray(fields, delay := 200) {
    for index, value in fields {
        SendText(value)
        if (index < fields.Length)
            Send("{Tab}")
        Sleep(delay)
    }
}

; Test utilities
!F1:: {
    ToolTip("Testing FillForm in 2 seconds...")
    Sleep(2000)
    ToolTip()

    testData := {
        field1: "Test & Value",
        field2: "Special chars: ^+!@#",
        field3: "Email: test@example.com"
    }

    FillForm(testData, 300)

    ToolTip("FillForm complete!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    SendText - Form Filling
    =======================

    F1 - Basic form
    F2 - Special character form

    Ctrl+F1  - Registration form
    Ctrl+F2  - Survey form
    Ctrl+F3  - Address form
    Ctrl+F4  - Contact form
    Ctrl+F5  - Payment form
    Ctrl+F6  - Invoice form
    Ctrl+F7  - Feedback form
    Ctrl+F8  - Bug report form
    Ctrl+F9  - Profile form
    Ctrl+F10 - Batch form filling

    Alt+F1 - FillForm test

    F12 - Show this help
    ESC - Exit script

    NOTE: Activate form before automation!
    SendText handles special characters safely.
    )"

    MsgBox(helpText, "Form Filling Help")
}
