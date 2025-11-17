#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Hotstring() Function - Abbreviation Systems
 * ============================================================================
 *
 * This file demonstrates creating comprehensive abbreviation systems using
 * hotstrings for professional, technical, and everyday use.
 *
 * Features:
 * - Professional abbreviations
 * - Technical acronyms
 * - Medical terminology
 * - Programming shortcuts
 * - Custom abbreviation sets
 *
 * @author AutoHotkey v2 Documentation Team
 * @version 1.0.0
 */

; ============================================================================
; Example 1: Professional Business Abbreviations
; ============================================================================

Example1_BusinessAbbreviations() {
    ; Common business abbreviations
    Hotstring("::attn::", "Attention:")
    Hotstring("::re::", "Regarding:")
    Hotstring("::cc::", "Carbon Copy:")
    Hotstring("::bcc::", "Blind Carbon Copy:")
    Hotstring("::dept::", "Department")
    Hotstring("::mgmt::", "Management")
    Hotstring("::acct::", "Account")
    Hotstring("::amt::", "Amount")
    Hotstring("::qty::", "Quantity")
    Hotstring("::inv::", "Invoice")
    Hotstring("::ref::", "Reference")
    Hotstring("::attn::", "Attention")
    Hotstring("::fwd::", "Forward")

    ; Business titles
    Hotstring("::ceo::", "Chief Executive Officer")
    Hotstring("::cfo::", "Chief Financial Officer")
    Hotstring("::cto::", "Chief Technology Officer")
    Hotstring("::coo::", "Chief Operating Officer")
    Hotstring("::vp::", "Vice President")
    Hotstring("::svp::", "Senior Vice President")
    Hotstring("::evp::", "Executive Vice President")

    ; Financial abbreviations
    Hotstring("::roi::", "Return on Investment")
    Hotstring("::ebitda::", "Earnings Before Interest, Taxes, Depreciation, and Amortization")
    Hotstring("::yoy::", "Year over Year")
    Hotstring("::ytd::", "Year to Date")
    Hotstring("::qoq::", "Quarter over Quarter")
    Hotstring("::fy::", "Fiscal Year")
    Hotstring("::q1::", "First Quarter")
    Hotstring("::q2::", "Second Quarter")
    Hotstring("::q3::", "Third Quarter")
    Hotstring("::q4::", "Fourth Quarter")

    MsgBox("Business abbreviations loaded!`n`nExamples:`nattn, re, ceo, roi, ytd, dept", "Example 1")
}

; ============================================================================
; Example 2: Technical and IT Abbreviations
; ============================================================================

Example2_TechnicalAbbreviations() {
    ; Programming languages
    Hotstring("::js::", "JavaScript")
    Hotstring("::ts::", "TypeScript")
    Hotstring("::py::", "Python")
    Hotstring("::cpp::", "C++")
    Hotstring("::cs::", "C#")
    Hotstring("::rb::", "Ruby")
    Hotstring("::php::", "PHP")
    Hotstring("::sql::", "SQL")

    ; Frameworks and libraries
    Hotstring("::rxjs::", "Reactive Extensions for JavaScript")
    Hotstring("::vuejs::", "Vue.js")
    Hotstring("::reactjs::", "React.js")
    Hotstring("::nodejs::", "Node.js")
    Hotstring("::npm::", "Node Package Manager")
    Hotstring("::webpack::", "Webpack")

    ; Development concepts
    Hotstring("::api::", "Application Programming Interface")
    Hotstring("::sdk::", "Software Development Kit")
    Hotstring("::ide::", "Integrated Development Environment")
    Hotstring("::cli::", "Command Line Interface")
    Hotstring("::gui::", "Graphical User Interface")
    Hotstring("::ui::", "User Interface")
    Hotstring("::ux::", "User Experience")
    Hotstring("::crud::", "Create, Read, Update, Delete")
    Hotstring("::rest::", "Representational State Transfer")
    Hotstring("::ajax::", "Asynchronous JavaScript and XML")
    Hotstring("::json::", "JavaScript Object Notation")
    Hotstring("::xml::", "Extensible Markup Language")

    ; Network and infrastructure
    Hotstring("::ip::", "Internet Protocol")
    Hotstring("::tcp::", "Transmission Control Protocol")
    Hotstring("::udp::", "User Datagram Protocol")
    Hotstring("::http::", "Hypertext Transfer Protocol")
    Hotstring("::https::", "Hypertext Transfer Protocol Secure")
    Hotstring("::ftp::", "File Transfer Protocol")
    Hotstring("::ssh::", "Secure Shell")
    Hotstring("::vpn::", "Virtual Private Network")
    Hotstring("::dns::", "Domain Name System")
    Hotstring("::url::", "Uniform Resource Locator")

    MsgBox("Technical abbreviations loaded!`n`nExamples:`njs, api, rest, http, json, sql", "Example 2")
}

; ============================================================================
; Example 3: Medical and Scientific Abbreviations
; ============================================================================

Example3_MedicalAbbreviations() {
    ; Medical terms
    Hotstring("::bp::", "Blood Pressure")
    Hotstring("::hr::", "Heart Rate")
    Hotstring("::temp::", "Temperature")
    Hotstring("::pt::", "Patient")
    Hotstring("::dx::", "Diagnosis")
    Hotstring("::rx::", "Prescription")
    Hotstring("::hx::", "History")
    Hotstring("::sx::", "Symptoms")
    Hotstring("::tx::", "Treatment")

    ; Medical specialties
    Hotstring("::ent::", "Ear, Nose, and Throat")
    Hotstring("::obgyn::", "Obstetrics and Gynecology")
    Hotstring("::icu::", "Intensive Care Unit")
    Hotstring("::er::", "Emergency Room")
    Hotstring("::or::", "Operating Room")
    Hotstring("::ccu::", "Cardiac Care Unit")

    ; Medical procedures
    Hotstring("::mri::", "Magnetic Resonance Imaging")
    Hotstring("::ct::", "Computed Tomography")
    Hotstring("::ekg::", "Electrocardiogram")
    Hotstring("::ecg::", "Electrocardiogram")
    Hotstring("::cbc::", "Complete Blood Count")
    Hotstring("::bmp::", "Basic Metabolic Panel")

    ; Units and measurements
    Hotstring("::mg::", "milligram")
    Hotstring("::ml::", "milliliter")
    Hotstring("::kg::", "kilogram")
    Hotstring("::cm::", "centimeter")
    Hotstring("::mm::", "millimeter")

    MsgBox("Medical abbreviations loaded!`n`nExamples:`nbp, dx, rx, mri, icu, ekg", "Example 3")
}

; ============================================================================
; Example 4: Academic and Educational Abbreviations
; ============================================================================

Example4_AcademicAbbreviations() {
    ; Degrees
    Hotstring("::ba::", "Bachelor of Arts")
    Hotstring("::bs::", "Bachelor of Science")
    Hotstring("::ma::", "Master of Arts")
    Hotstring("::ms::", "Master of Science")
    Hotstring("::mba::", "Master of Business Administration")
    Hotstring("::phd::", "Doctor of Philosophy")
    Hotstring("::edd::", "Doctor of Education")
    Hotstring("::md::", "Doctor of Medicine")
    Hotstring("::jd::", "Juris Doctor")

    ; Academic terms
    Hotstring("::gpa::", "Grade Point Average")
    Hotstring("::sat::", "Scholastic Assessment Test")
    Hotstring("::act::", "American College Testing")
    Hotstring("::gre::", "Graduate Record Examination")
    Hotstring("::toefl::", "Test of English as a Foreign Language")
    Hotstring("::ielts::", "International English Language Testing System")

    ; Academic writing
    Hotstring("::apa::", "American Psychological Association")
    Hotstring("::mla::", "Modern Language Association")
    Hotstring("::ibid::", "Ibidem (in the same place)")
    Hotstring("::et al::", "et alii (and others)")
    Hotstring("::viz::", "videlicet (namely)")
    Hotstring("::ie::", "id est (that is)")
    Hotstring("::eg::", "exempli gratia (for example)")
    Hotstring("::etc::", "et cetera (and so forth)")
    Hotstring("::vs::", "versus")
    Hotstring("::cf::", "confer (compare)")

    MsgBox("Academic abbreviations loaded!`n`nExamples:`nphd, gpa, apa, et al, ie, eg", "Example 4")
}

; ============================================================================
; Example 5: Geographic and Location Abbreviations
; ============================================================================

Example5_GeographicAbbreviations() {
    ; US States (sample)
    Hotstring("::al::", "Alabama")
    Hotstring("::ak::", "Alaska")
    Hotstring("::az::", "Arizona")
    Hotstring("::ca::", "California")
    Hotstring("::fl::", "Florida")
    Hotstring("::ny::", "New York")
    Hotstring("::tx::", "Texas")

    ; Directions
    Hotstring("::n::", "North")
    Hotstring("::s::", "South")
    Hotstring("::e::", "East")
    Hotstring("::w::", "West")
    Hotstring("::ne::", "Northeast")
    Hotstring("::nw::", "Northwest")
    Hotstring("::se::", "Southeast")
    Hotstring("::sw::", "Southwest")

    ; Address components
    Hotstring("::st::", "Street")
    Hotstring("::ave::", "Avenue")
    Hotstring("::blvd::", "Boulevard")
    Hotstring("::rd::", "Road")
    Hotstring("::dr::", "Drive")
    Hotstring("::ln::", "Lane")
    Hotstring("::ct::", "Court")
    Hotstring("::pl::", "Place")
    Hotstring("::apt::", "Apartment")
    Hotstring("::ste::", "Suite")
    Hotstring("::fl::", "Floor")
    Hotstring("::bldg::", "Building")

    ; Countries
    Hotstring("::usa::", "United States of America")
    Hotstring("::uk::", "United Kingdom")
    Hotstring("::uae::", "United Arab Emirates")

    MsgBox("Geographic abbreviations loaded!`n`nExamples:`nca, ny, st, ave, blvd, usa, uk", "Example 5")
}

; ============================================================================
; Example 6: Custom Domain-Specific Abbreviations
; ============================================================================

Example6_CustomDomain() {
    ; Create a custom abbreviation system for a specific domain
    ; Example: Project management

    ; Project phases
    Hotstring("::init::", "Initialization Phase")
    Hotstring("::plan::", "Planning Phase")
    Hotstring("::exec::", "Execution Phase")
    Hotstring("::mon::", "Monitoring Phase")
    Hotstring("::close::", "Closure Phase")

    ; Project roles
    Hotstring("::pm::", "Project Manager")
    Hotstring("::po::", "Product Owner")
    Hotstring("::sm::", "Scrum Master")
    Hotstring("::ba::", "Business Analyst")
    Hotstring("::qa::", "Quality Assurance")
    Hotstring("::dev::", "Developer")

    ; Agile terms
    Hotstring("::sprint::", "Sprint")
    Hotstring("::backlog::", "Product Backlog")
    Hotstring("::story::", "User Story")
    Hotstring("::epic::", "Epic")
    Hotstring("::wip::", "Work in Progress")
    Hotstring("::dod::", "Definition of Done")
    Hotstring("::dor::", "Definition of Ready")
    Hotstring("::mvp::", "Minimum Viable Product")
    Hotstring("::poc::", "Proof of Concept")

    ; Status indicators
    Hotstring("::tbd::", "To Be Determined")
    Hotstring("::tba::", "To Be Announced")
    Hotstring("::asap::", "As Soon As Possible")
    Hotstring("::eod::", "End of Day")
    Hotstring("::eow::", "End of Week")
    Hotstring("::eom::", "End of Month")

    MsgBox("Project Management abbreviations loaded!`n`nExamples:`npm, po, sprint, mvp, wip, eod", "Example 6")
}

; ============================================================================
; Example 7: Dynamic Abbreviation Builder
; ============================================================================

Example7_DynamicBuilder() {
    ; User-customizable abbreviation system
    global customAbbreviations := Map()

    /**
     * Adds a custom abbreviation
     */
    AddAbbreviation(abbr, expansion) {
        global customAbbreviations
        Hotstring("::" . abbr . "::", expansion)
        customAbbreviations[abbr] := {
            expansion: expansion,
            created: A_Now,
            useCount: 0
        }
    }

    /**
     * Lists custom abbreviations
     */
    ListCustomAbbreviations() {
        global customAbbreviations

        if customAbbreviations.Count = 0 {
            MsgBox("No custom abbreviations defined yet.", "Custom Abbreviations")
            return
        }

        list := "Custom Abbreviations:`n" . Repeat("=", 50) . "`n`n"

        for abbr, info in customAbbreviations {
            list .= abbr . " → " . info.expansion . "`n"
        }

        MsgBox(list, "Custom Abbreviations")
    }

    /**
     * GUI for adding abbreviations
     */
    ShowAbbreviationBuilder() {
        builderGui := Gui("+AlwaysOnTop", "Abbreviation Builder")

        builderGui.AddText("", "Abbreviation:")
        abbrEdit := builderGui.AddEdit("w300")

        builderGui.AddText("", "Expansion:")
        expansionEdit := builderGui.AddEdit("w300 r3")

        builderGui.AddButton("w300", "Add Abbreviation").OnEvent("Click", (*) => {
            abbr := abbrEdit.Value
            expansion := expansionEdit.Value

            if abbr = "" || expansion = "" {
                MsgBox("Both fields are required!", "Error")
                return
            }

            AddAbbreviation(abbr, expansion)
            MsgBox("Added: " abbr " → " expansion, "Success")

            abbrEdit.Value := ""
            expansionEdit.Value := ""
        })

        builderGui.AddButton("w300", "List All").OnEvent("Click", (*) => ListCustomAbbreviations())

        builderGui.Show()
    }

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Pre-load some examples
    AddAbbreviation("myemail", "user@example.com")
    AddAbbreviation("myphone", "(555) 123-4567")
    AddAbbreviation("myaddr", "123 Main St, City, State 12345")

    ; Create hotkey to show builder
    Hotkey("^!b", (*) => ShowAbbreviationBuilder())

    MsgBox(
        "Dynamic Abbreviation Builder`n`n"
        "Ctrl+Alt+B - Open abbreviation builder`n`n"
        "Pre-loaded examples:`n"
        "  myemail → user@example.com`n"
        "  myphone → (555) 123-4567`n"
        "  myaddr → address`n`n"
        "Add your own custom abbreviations!",
        "Example 7"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    Hotstring Abbreviation Systems
    ===============================

    1. Business Abbreviations
    2. Technical/IT Abbreviations
    3. Medical/Scientific
    4. Academic/Educational
    5. Geographic/Location
    6. Custom Domain (Project Mgmt)
    7. Dynamic Builder

    Press Win+[1-7] to load
    )"

    MsgBox(menu, "Abbreviation Examples")
}

Hotkey("#1", (*) => Example1_BusinessAbbreviations())
Hotkey("#2", (*) => Example2_TechnicalAbbreviations())
Hotkey("#3", (*) => Example3_MedicalAbbreviations())
Hotkey("#4", (*) => Example4_AcademicAbbreviations())
Hotkey("#5", (*) => Example5_GeographicAbbreviations())
Hotkey("#6", (*) => Example6_CustomDomain())
Hotkey("#7", (*) => Example7_DynamicBuilder())

ShowExampleMenu()
