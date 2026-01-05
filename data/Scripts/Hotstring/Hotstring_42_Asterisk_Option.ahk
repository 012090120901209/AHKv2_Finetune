#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Hotstring Option: * (Asterisk)
 * Triggers immediately without needing an ending character
 */

; Without *, you'd need to press space/enter after "teh"
; With *, it triggers immediately after typing "h"
:*:teh::the

; Auto-correct common typos
:*:adn::and
:*:taht::that
:*:waht::what
:*:recieve::receive
:*:seperate::separate

; Emoji shortcuts that trigger immediately
: * :) smile: 😊
    : * :) heart: ❤️
    : * :) fire: 🔥
    : * :) check: ✓

; Note: With *, you don't need to press space after typing

