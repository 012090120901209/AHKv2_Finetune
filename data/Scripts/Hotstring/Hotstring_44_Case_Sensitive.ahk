#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Hotstring Option: C (Case-sensitive)
 * Only triggers with exact case match
 */

; Default: case-insensitive (BTW, btw, Btw all trigger)
::btw::by the way

; Case-sensitive: only "SQL" in all caps triggers
:C:SQL::Structured Query Language

; Useful for distinguishing between similar abbreviations
:C:ID::Identification
:C:id::identifier

; Programming constants
:C:PI::3.14159265359
:C:TRUE::true
:C:FALSE::false

; Proper nouns
:C:USA::United States of America
:C:NYC::New York City
:C:CEO::Chief Executive Officer

; Code snippets with specific casing
:C:const::const myVariable =
:C:CONST::// CONSTANT VALUE
