#Requires AutoHotkey v2.0

/**
* BuiltIn_ImageSearch_01.ahk
*
* DESCRIPTION:
* Basic usage of ImageSearch() for finding images on screen
*
* FEATURES:
* - Search for images on screen
* - Basic image recognition
* - Coordinate detection
* - Variation tolerance
* - Error handling
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/ImageSearch.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - ImageSearch() function
* - Output variables with ByRef
* - Icon/Trans variations
* - Search region specification
* - Image file handling
*
* LEARNING POINTS:
* 1. ImageSearch() finds images on screen by visual matching
* 2. Returns top-left coordinates of found image
* 3. Variation parameter allows fuzzy matching (0-255)
* 4. Icon/Trans modifiers for special matching modes
* 5. Image files must be accessible (BMP, JPG, PNG, GIF)
* 6. Search region can be specified to improve performance
*/

; ============================================================
; Example 1: Basic Image Search
; ============================================================

/**
* Search for an image on screen
*
* @param {String} imagePath - Path to image file
* @param {Integer} x1 - Search region left (default: full screen)
* @param {Integer} y1 - Search region top
* @param {Integer} x2 - Search region right
* @param {Integer} y2 - Search region bottom
* @returns {Object} - {found: bool, x: int, y: int}
*/
BasicImageSearch(imagePath, x1 := 0, y1 := 0, x2 := 0, y2 := 0) {
    ; Default to full screen if not specified
    if x2 = 0
    x2 := A_ScreenWidth
    if y2 = 0
    y2 := A_ScreenHeight

    ; Check if image file exists
    if !FileExist(imagePath) {
        MsgBox("Image file not found:`n" imagePath,
        "File Error", "Iconx")
        return {found: false, x: 0, y: 0}
    }

    MsgBox("Searching for image:`n`n"
    . "File: " imagePath "`n"
    . "Region: (" x1 "," y1 ") to (" x2 "," y2 ")",
    "Searching", "T1")

    try {
        ; ImageSearch returns 1 if found, 0 if not found
        if ImageSearch(&foundX, &foundY, x1, y1, x2, y2, imagePath) {
            MsgBox("Image Found!`n`n"
            . "Position: " foundX ", " foundY "`n"
            . "Image: " imagePath,
            "Found", "Iconi")

            return {found: true, x: foundX, y: foundY}
        } else {
            MsgBox("Image not found on screen`n`n"
            . "Image: " imagePath,
            "Not Found", "Icon!")

            return {found: false, x: 0, y: 0}
        }

    } catch as err {
        MsgBox("Error during image search:`n`n"
        . "Error: " err.Message "`n"
        . "Image: " imagePath,
        "Error", "Iconx")

        return {found: false, x: 0, y: 0}
    }
}

; Test basic image search
; NOTE: Replace with actual image path
; BasicImageSearch("C:\Images\button.png")
; BasicImageSearch(A_ScriptDir "\images\logo.png", 0, 0, 800, 600)

; ============================================================
; Example 2: Image Search with Variation
; ============================================================

/**
* Search for image with color variation tolerance
*/
class ImageSearchWithVariation {
    /**
    * Search with different variation levels
    *
    * @param {String} imagePath - Path to image
    * @param {Integer} variation - Color tolerance (0-255)
    */
    static SearchWithTolerance(imagePath, variation := 0) {
        if !FileExist(imagePath) {
            MsgBox("Image not found: " imagePath, "Error", "Iconx")
            return {found: false, x: 0, y: 0}
        }

        ; Add variation to search string
        searchString := "*" variation " " imagePath

        MsgBox("Searching with variation:`n`n"
        . "Image: " imagePath "`n"
        . "Variation: " variation "`n`n"
        . "Higher variation = more lenient matching",
        "Searching", "T1")

        try {
            if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
            searchString) {
                MsgBox("Image found!`n`n"
                . "Position: " x ", " y "`n"
                . "Variation used: " variation,
                "Found", "Iconi")

                return {found: true, x: x, y: y}
            }

            MsgBox("Image not found with variation " variation,
            "Not Found", "Icon!")
            return {found: false, x: 0, y: 0}

        } catch as err {
            MsgBox("Error: " err.Message, "Error", "Iconx")
            return {found: false, x: 0, y: 0}
        }
    }

    /**
    * Try increasing variations until found
    */
    static SearchWithAutoVariation(imagePath, maxVariation := 50) {
        if !FileExist(imagePath) {
            MsgBox("Image not found: " imagePath, "Error", "Iconx")
            return {found: false, x: 0, y: 0, variation: 0}
        }

        MsgBox("Trying increasing variations up to " maxVariation,
        "Auto Variation", "T1")

        variations := [0, 10, 20, 30, 50]

        for variation in variations {
            if variation > maxVariation
            break

            searchString := "*" variation " " imagePath

            if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
            searchString) {
                MsgBox("Image found!`n`n"
                . "Position: " x ", " y "`n"
                . "Variation needed: " variation,
                "Found", "Iconi")

                return {found: true, x: x, y: y, variation: variation}
            }

            ToolTip("Variation " variation " - not found, trying higher...")
            Sleep(300)
        }

        ToolTip()
        MsgBox("Image not found with any variation up to " maxVariation,
        "Not Found", "Icon!")

        return {found: false, x: 0, y: 0, variation: 0}
    }
}

; Test variation search
; ImageSearchWithVariation.SearchWithTolerance("C:\Images\button.png", 30)
; ImageSearchWithVariation.SearchWithAutoVariation("C:\Images\logo.png", 50)

; ============================================================
; Example 3: Find and Click Image
; ============================================================

/**
* Find image and click on it
*/
class ImageClicker {
    /**
    * Find and click on image
    *
    * @param {String} imagePath - Path to image
    * @param {String} clickPosition - Where to click (center, topleft)
    * @param {Integer} offsetX - X offset from click position
    * @param {Integer} offsetY - Y offset from click position
    */
    static FindAndClick(imagePath, clickPosition := "center",
    offsetX := 0, offsetY := 0) {
        if !FileExist(imagePath) {
            MsgBox("Image not found: " imagePath, "Error", "Iconx")
            return false
        }

        MsgBox("Searching for image to click...",
        "Searching", "T1")

        try {
            if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
            imagePath) {
                ; Calculate click position
                clickX := x
                clickY := y

                ; For center, we'd need to know image dimensions
                ; Here we'll add a simple offset option
                clickX += offsetX
                clickY += offsetY

                ; Move mouse to show where we're clicking
                MouseMove(clickX, clickY)
                Sleep(500)

                ; Click
                Click(clickX, clickY)

                MsgBox("Image found and clicked!`n`n"
                . "Image at: " x ", " y "`n"
                . "Clicked: " clickX ", " clickY,
                "Clicked", "Iconi T2")

                return true
            }

            MsgBox("Image not found - cannot click",
            "Not Found", "Icon!")
            return false

        } catch as err {
            MsgBox("Error: " err.Message, "Error", "Iconx")
            return false
        }
    }

    /**
    * Wait for image then click
    *
    * @param {String} imagePath - Path to image
    * @param {Integer} timeoutSec - Timeout in seconds
    */
    static WaitAndClick(imagePath, timeoutSec := 10) {
        if !FileExist(imagePath) {
            MsgBox("Image not found: " imagePath, "Error", "Iconx")
            return false
        }

        MsgBox("Waiting for image to appear...`n`n"
        . "Timeout: " timeoutSec " seconds",
        "Waiting", "T1")

        startTime := A_TickCount
        timeout := timeoutSec * 1000

        Loop {
            try {
                if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                imagePath) {
                    elapsed := (A_TickCount - startTime) / 1000

                    Click(x, y)

                    MsgBox("Image appeared and clicked!`n`n"
                    . "Time elapsed: " Round(elapsed, 1) " seconds`n"
                    . "Position: " x ", " y,
                    "Success", "Iconi")

                    return true
                }

            } catch {
                ; Continue on error
            }

            if (A_TickCount - startTime) > timeout {
                MsgBox("Timeout - image did not appear",
                "Timeout", "Icon!")
                return false
            }

            Sleep(500)  ; Check every 500ms
        }
    }

    /**
    * Double-click on image
    */
    static FindAndDoubleClick(imagePath, delay := 100) {
        if !FileExist(imagePath) {
            MsgBox("Image not found: " imagePath, "Error", "Iconx")
            return false
        }

        try {
            if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
            imagePath) {
                Click(x, y)
                Sleep(delay)
                Click(x, y)

                MsgBox("Double-clicked image at: " x ", " y,
                "Double-Clicked", "Iconi T2")

                return true
            }

            MsgBox("Image not found", "Not Found", "Icon!")
            return false

        } catch as err {
            MsgBox("Error: " err.Message, "Error", "Iconx")
            return false
        }
    }
}

; Test image clicking
; ImageClicker.FindAndClick("C:\Images\button.png", "center", 0, 0)
; ImageClicker.WaitAndClick("C:\Images\logo.png", 10)
; ImageClicker.FindAndDoubleClick("C:\Images\folder.png", 100)

; ============================================================
; Example 4: Multiple Image Search
; ============================================================

/**
* Search for multiple images
*/
class MultiImageSearch {
    /**
    * Search for first matching image from list
    *
    * @param {Array} imagePaths - Array of image paths
    * @returns {Object} - {found: bool, index: int, x: int, y: int}
    */
    static FindFirst(imagePaths) {
        MsgBox("Searching for first matching image`n`n"
        . "Images to check: " imagePaths.Length,
        "Searching", "T1")

        for index, imagePath in imagePaths {
            if !FileExist(imagePath) {
                ToolTip("Skipping missing file: " imagePath)
                Sleep(500)
                continue
            }

            try {
                if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                imagePath) {
                    ToolTip()

                    MsgBox("Found image " index " of " imagePaths.Length "`n`n"
                    . "Image: " imagePath "`n"
                    . "Position: " x ", " y,
                    "Found", "Iconi")

                    return {found: true, index: index, x: x, y: y,
                    path: imagePath}
                }

            } catch {
                ; Continue on error
            }

            ToolTip("Image " index " not found, checking next...")
            Sleep(300)
        }

        ToolTip()
        MsgBox("None of the images were found",
        "Not Found", "Icon!")

        return {found: false, index: 0, x: 0, y: 0, path: ""}
    }

    /**
    * Find all matching images
    *
    * @param {Array} imagePaths - Array of image paths
    * @returns {Array} - Array of found results
    */
    static FindAll(imagePaths) {
        found := []

        MsgBox("Searching for all images...`n`n"
        . "Total images: " imagePaths.Length,
        "Searching", "T1")

        for index, imagePath in imagePaths {
            if !FileExist(imagePath)
            continue

            try {
                if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                imagePath) {
                    found.Push({
                        index: index,
                        path: imagePath,
                        x: x,
                        y: y
                    })
                }

            } catch {
                ; Continue on error
            }
        }

        output := "SEARCH RESULTS:`n`n"
        output .= "Found: " found.Length " of " imagePaths.Length "`n`n"

        for item in found {
            output .= "• " item.path "`n"
            output .= "  Position: " item.x ", " item.y "`n"
        }

        if found.Length = 0
        output .= "No images found"

        MsgBox(output, "Results", "Iconi")

        return found
    }

    /**
    * Click images in sequence
    */
    static ClickSequence(imagePaths, delayMs := 1000) {
        MsgBox("Starting click sequence`n`n"
        . "Images: " imagePaths.Length "`n"
        . "Delay: " delayMs "ms",
        "Sequence", "T1")

        clickedCount := 0

        for index, imagePath in imagePaths {
            if !FileExist(imagePath)
            continue

            try {
                if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                imagePath) {
                    Click(x, y)
                    clickedCount++

                    ToolTip("Clicked " clickedCount " / " imagePaths.Length)
                    Sleep(delayMs)
                }

            } catch {
                ; Continue on error
            }
        }

        ToolTip()

        MsgBox("Sequence complete!`n`n"
        . "Clicked: " clickedCount " of " imagePaths.Length,
        "Done", "Iconi")
    }
}

; Test multiple image search
; images := ["C:\Images\button1.png", "C:\Images\button2.png", "C:\Images\button3.png"]
; MultiImageSearch.FindFirst(images)
; MultiImageSearch.FindAll(images)
; MultiImageSearch.ClickSequence(images, 1000)

; ============================================================
; Example 5: Wait for Image to Appear/Disappear
; ============================================================

/**
* Wait for image state changes
*/
class ImageWaiter {
    /**
    * Wait for image to appear
    *
    * @param {String} imagePath - Path to image
    * @param {Integer} timeoutSec - Timeout in seconds
    * @param {Integer} checkInterval - Check interval in ms
    * @returns {Boolean} - True if appeared
    */
    static WaitForAppear(imagePath, timeoutSec := 30, checkInterval := 500) {
        if !FileExist(imagePath) {
            MsgBox("Image not found: " imagePath, "Error", "Iconx")
            return false
        }

        MsgBox("Waiting for image to appear:`n`n"
        . "Image: " imagePath "`n"
        . "Timeout: " timeoutSec " seconds`n"
        . "Check interval: " checkInterval "ms",
        "Waiting", "T1")

        startTime := A_TickCount
        timeout := timeoutSec * 1000

        Loop {
            try {
                if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                imagePath) {
                    elapsed := (A_TickCount - startTime) / 1000

                    MsgBox("Image appeared!`n`n"
                    . "Position: " x ", " y "`n"
                    . "Time elapsed: " Round(elapsed, 1) " seconds",
                    "Appeared", "Iconi")

                    return true
                }

            } catch {
                ; Continue on error
            }

            if (A_TickCount - startTime) > timeout {
                MsgBox("Timeout - image did not appear within "
                . timeoutSec " seconds",
                "Timeout", "Icon!")
                return false
            }

            remaining := Round((timeout - (A_TickCount - startTime)) / 1000, 1)
            ToolTip("Waiting for image... (" remaining "s remaining)")

            Sleep(checkInterval)
        }
    }

    /**
    * Wait for image to disappear
    *
    * @param {String} imagePath - Path to image
    * @param {Integer} timeoutSec - Timeout in seconds
    */
    static WaitForDisappear(imagePath, timeoutSec := 30) {
        if !FileExist(imagePath) {
            MsgBox("Image not found: " imagePath, "Error", "Iconx")
            return false
        }

        MsgBox("Waiting for image to disappear...`n`n"
        . "Timeout: " timeoutSec " seconds",
        "Waiting", "T1")

        startTime := A_TickCount
        timeout := timeoutSec * 1000

        Loop {
            try {
                if !ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                imagePath) {
                    elapsed := (A_TickCount - startTime) / 1000

                    MsgBox("Image disappeared!`n`n"
                    . "Time elapsed: " Round(elapsed, 1) " seconds",
                    "Disappeared", "Iconi")

                    return true
                }

            } catch {
                ; Treat error as "not found" = disappeared
                return true
            }

            if (A_TickCount - startTime) > timeout {
                MsgBox("Timeout - image still visible",
                "Timeout", "Icon!")
                return false
            }

            ToolTip("Waiting for image to disappear...")
            Sleep(500)
        }
    }

    /**
    * Wait for loading screen to finish
    */
    static WaitForLoadingComplete(loadingImagePath, timeoutSec := 60) {
        MsgBox("Waiting for loading to complete...",
        "Loading", "T1")

        return this.WaitForDisappear(loadingImagePath, timeoutSec)
    }
}

; Test image waiter
; ImageWaiter.WaitForAppear("C:\Images\ready_button.png", 30, 500)
; ImageWaiter.WaitForDisappear("C:\Images\loading.png", 60)
; ImageWaiter.WaitForLoadingComplete("C:\Images\spinner.png", 60)

; ============================================================
; Example 6: Image Search in Specific Window
; ============================================================

/**
* Search for image in specific window
*/
class WindowImageSearch {
    /**
    * Search in active window only
    *
    * @param {String} imagePath - Path to image
    * @returns {Object} - Search result
    */
    static SearchInActiveWindow(imagePath) {
        if !FileExist(imagePath) {
            MsgBox("Image not found: " imagePath, "Error", "Iconx")
            return {found: false, x: 0, y: 0}
        }

        try {
            ; Get active window position
            WinGetPos(&winX, &winY, &winW, &winH, "A")

            winTitle := WinGetTitle("A")

            MsgBox("Searching in active window:`n`n"
            . "Window: " winTitle "`n"
            . "Region: (" winX "," winY ") to ("
            . (winX + winW) "," (winY + winH) ")",
            "Searching", "T1")

            ; Search in window region
            if ImageSearch(&x, &y, winX, winY, winX + winW, winY + winH,
            imagePath) {
                MsgBox("Image found in window!`n`n"
                . "Position: " x ", " y,
                "Found", "Iconi")

                return {found: true, x: x, y: y}
            }

            MsgBox("Image not found in active window",
            "Not Found", "Icon!")
            return {found: false, x: 0, y: 0}

        } catch as err {
            MsgBox("Error: " err.Message, "Error", "Iconx")
            return {found: false, x: 0, y: 0}
        }
    }

    /**
    * Search in specific window by title
    */
    static SearchInWindow(winTitle, imagePath) {
        if !WinExist(winTitle) {
            MsgBox("Window not found: " winTitle, "Error", "Iconx")
            return {found: false, x: 0, y: 0}
        }

        if !FileExist(imagePath) {
            MsgBox("Image not found: " imagePath, "Error", "Iconx")
            return {found: false, x: 0, y: 0}
        }

        try {
            WinGetPos(&x, &y, &w, &h, winTitle)

            if ImageSearch(&foundX, &foundY, x, y, x + w, y + h, imagePath) {
                MsgBox("Image found!`n`n"
                . "Window: " winTitle "`n"
                . "Position: " foundX ", " foundY,
                "Found", "Iconi")

                return {found: true, x: foundX, y: foundY}
            }

            MsgBox("Image not found in window",
            "Not Found", "Icon!")
            return {found: false, x: 0, y: 0}

        } catch as err {
            MsgBox("Error: " err.Message, "Error", "Iconx")
            return {found: false, x: 0, y: 0}
        }
    }
}

; Test window-specific search
; WindowImageSearch.SearchInActiveWindow("C:\Images\button.png")
; WindowImageSearch.SearchInWindow("Notepad", "C:\Images\save_icon.png")

; ============================================================
; Example 7: Image Search Helper Functions
; ============================================================

/**
* Utility functions for image searching
*/
class ImageSearchHelpers {
    /**
    * Check if image exists on screen (simple boolean)
    */
    static ImageExists(imagePath) {
        if !FileExist(imagePath)
        return false

        try {
            return ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
            imagePath)
        } catch {
            return false
        }
    }

    /**
    * Get image position without showing messages
    */
    static GetImagePosition(imagePath) {
        if !FileExist(imagePath)
        return {x: -1, y: -1}

        try {
            if ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
            imagePath)
            return {x: x, y: y}
        } catch {
            ; Ignore
        }

        return {x: -1, y: -1}
    }

    /**
    * Verify image file is valid
    */
    static ValidateImageFile(imagePath) {
        ; Check if file exists
        if !FileExist(imagePath) {
            MsgBox("Image file not found:`n" imagePath,
            "Validation Error", "Iconx")
            return false
        }

        ; Check file extension
        SplitPath(imagePath, , , &ext)
        validExts := ["bmp", "jpg", "jpeg", "png", "gif"]

        ext := StrLower(ext)
        isValid := false
        for validExt in validExts {
            if ext = validExt {
                isValid := true
                break
            }
        }

        if !isValid {
            MsgBox("Invalid image format: ." ext "`n`n"
            . "Supported: BMP, JPG, PNG, GIF",
            "Format Error", "Iconx")
            return false
        }

        MsgBox("Image file is valid:`n`n"
        . "Path: " imagePath "`n"
        . "Format: " StrUpper(ext),
        "Valid", "Iconi T2")

        return true
    }
}

; Test helpers
; ImageSearchHelpers.ImageExists("C:\Images\button.png")
; pos := ImageSearchHelpers.GetImagePosition("C:\Images\logo.png")
; ImageSearchHelpers.ValidateImageFile("C:\Images\test.png")

; ============================================================
; Reference Information
; ============================================================

info := "
(
IMAGESEARCH() FUNCTION REFERENCE:

Syntax:
Found := ImageSearch(&X, &Y, X1, Y1, X2, Y2, ImageFile)

Parameters:
X, Y      - Output coordinates (ByRef)
X1, Y1    - Top-left of search region
X2, Y2    - Bottom-right of search region
ImageFile - Path to image file

Returns:
1 if found, 0 if not found

Supported Formats:
• BMP (Bitmap)
• JPG/JPEG
• PNG (best for UI elements)
• GIF

Options (prefix to filename):
*n        - Variation (n = 0-255)
Example: *50 C:\image.png
*Icon     - Search for icon instead of image
*Trans    - Treat bottom-left pixel as transparent

Variation Levels:
0     - Exact match (default)
10-30 - Minor color differences
50    - Moderate differences
100+  - Significant differences
255   - Maximum tolerance

Common Uses:
✓ Find and click buttons
✓ Wait for UI elements
✓ Detect game objects
✓ Automate repetitive tasks
✓ UI testing and verification
✓ Screen state detection

Best Practices:
1. Use PNG format for UI elements
2. Capture images at same DPI
3. Start with variation 0, increase if needed
4. Limit search region for speed
5. Validate image files exist
6. Handle errors with Try/Catch
7. Use appropriate timeouts

Performance Tips:
• Smaller search regions = faster
• Use specific windows when possible
• PNG faster than JPG
• Smaller images = faster
• Cache search results

Limitations:
✗ DPI scaling affects matching
✗ Different monitors may vary
✗ Requires image files
✗ Can be slow on large regions
✗ May not work with some apps
✗ Screen recording may interfere

Troubleshooting:
• Image not found → Increase variation
• Wrong matches → Decrease variation
• Slow → Reduce search region
• DPI issues → Use CoordMode
• Transparency → Use *Trans option

Creating Reference Images:
1. Take screenshot (Win+Shift+S)
2. Crop to desired element
3. Save as PNG
4. Test with ImageSearch
5. Adjust variation as needed
)"

MsgBox(info, "ImageSearch() Reference", "Icon!")
