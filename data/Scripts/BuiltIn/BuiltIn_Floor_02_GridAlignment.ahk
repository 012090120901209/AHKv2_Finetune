#Requires AutoHotkey v2.0

/**
 * BuiltIn_Floor_02_GridAlignment.ahk
 * 
 * DESCRIPTION:
 * Grid alignment and coordinate snapping applications using Floor() for
 * aligning positions to grids, snap-to-grid functionality, and coordinate rounding
 * 
 * FEATURES:
 * - Snap coordinates to grid points
 * - Window and UI element alignment
 * - Pixel-perfect positioning
 * - Grid-based layout calculations
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Floor.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Floor() for coordinate rounding
 * - Geometric calculations
 * - Window positioning
 * - Mouse coordinate snapping
 * 
 * LEARNING POINTS:
 * 1. Floor() aligns to grid by rounding down
 * 2. Snap formula: Floor(value / gridSize) * gridSize
 * 3. Ensures consistent alignment
 * 4. Prevents sub-pixel rendering issues
 * 5. Essential for grid-based interfaces
 */

; ============================================================
; Example 1: Basic Grid Snapping
; ============================================================

/**
 * Snap a coordinate to grid
 * 
 * @param {Number} coordinate - Original coordinate
 * @param {Number} gridSize - Grid spacing
 * @returns {Object} - Snapped coordinate info
 */
SnapToGrid(coordinate, gridSize) {
    snappedValue := Floor(coordinate / gridSize) * gridSize
    offset := coordinate - snappedValue
    gridIndex := Floor(coordinate / gridSize)

    return {
        original: coordinate,
        gridSize: gridSize,
        snapped: snappedValue,
        offset: Round(offset, 2),
        gridIndex: gridIndex
    }
}

; Test grid snapping
testCoords := [127, 245, 50, 0, 999]
gridSize := 50

output := "Grid Snapping (Grid Size: " gridSize "):`n`n"

for coord in testCoords {
    result := SnapToGrid(coord, gridSize)

    output .= Format("Original: {1} → Snapped: {2} (Grid #{3})`n",
        result.original, result.snapped, result.gridIndex)
    if (result.offset > 0)
        output .= "  Offset: +" result.offset " from grid point`n"
}

output .= "`nFormula: Floor(coord / gridSize) × gridSize"

MsgBox(output, "Grid Snapping", "Icon!")

; ============================================================
; Example 2: 2D Coordinate Snapping
; ============================================================

/**
 * Snap 2D point to grid
 * 
 * @param {Number} x - X coordinate
 * @param {Number} y - Y coordinate
 * @param {Number} gridSize - Grid spacing
 * @returns {Object} - Snapped point
 */
SnapPoint2D(x, y, gridSize) {
    snappedX := Floor(x / gridSize) * gridSize
    snappedY := Floor(y / gridSize) * gridSize

    return {
        original: { x: x, y: y },
        snapped: { x: snappedX, y: snappedY },
        gridSize: gridSize,
        moved: {
            x: Round(x - snappedX, 2),
            y: Round(y - snappedY, 2)
        }
    }
}

/**
 * Calculate distance moved during snapping
 */
CalculateSnapDistance(point) {
    dx := point.moved.x
    dy := point.moved.y
    distance := Round(Sqrt(dx * dx + dy * dy), 2)
    return distance
}

; Mouse position snapping example
mousePositions := [{
    x: 347, y: 192 }, {
        x: 523, y: 768 }, {
            x: 100, y: 100 }, {
                x: 999, y: 555
            }
]

snapGrid := 25

output := "2D Point Snapping (Grid: " snapGrid " pixels):`n`n"

for pos in mousePositions {
    snapped := SnapPoint2D(pos.x, pos.y, snapGrid)
    dist := CalculateSnapDistance(snapped)

    output .= Format("({1}, {2}) → ({3}, {4})`n",
        snapped.original.x, snapped.original.y,
        snapped.snapped.x, snapped.snapped.y)
    output .= Format("  Moved: {1} pixels`n", dist)
}

MsgBox(output, "2D Grid Snapping", "Icon!")

; ============================================================
; Example 3: Window Position Alignment
; ============================================================

/**
 * Align window position to grid
 * 
 * @param {Number} x - Window X position
 * @param {Number} y - Window Y position
 * @param {Number} width - Window width
 * @param {Number} height - Window height
 * @param {Number} gridSize - Alignment grid size
 * @returns {Object} - Aligned window dimensions
 */
AlignWindow(x, y, width, height, gridSize := 10) {
    alignedX := Floor(x / gridSize) * gridSize
    alignedY := Floor(y / gridSize) * gridSize
    alignedWidth := Floor(width / gridSize) * gridSize
    alignedHeight := Floor(height / gridSize) * gridSize

    return {
        original: { x: x, y: y, width: width, height: height },
        aligned: { x: alignedX, y: alignedY, width: alignedWidth, height: alignedHeight },
        gridSize: gridSize
    }
}

/**
 * Format window dimensions
 */
FormatWindowDims(dims) {
    return Format("Pos: ({1}, {2}) | Size: {3}×{4}",
        dims.x, dims.y, dims.width, dims.height)
}

; Window alignment example
windowDims := { x: 127, y: 243, width: 847, height: 523 }
alignmentGrid := 10

aligned := AlignWindow(windowDims.x, windowDims.y,
    windowDims.width, windowDims.height,
    alignmentGrid)

output := "Window Alignment:`n"
output .= "Grid Size: " aligned.gridSize " pixels`n`n"
output .= "Original:`n"
output .= "  " FormatWindowDims(aligned.original) "`n`n"
output .= "Aligned:`n"
output .= "  " FormatWindowDims(aligned.aligned) "`n`n"
output .= "Benefits: Clean coordinates, no sub-pixel rendering"

MsgBox(output, "Window Alignment", "Icon!")

; ============================================================
; Example 4: UI Element Grid Layout
; ============================================================

/**
 * Create grid-based layout
 * 
 * @param {Number} columns - Number of columns
 * @param {Number} rows - Number of rows
 * @param {Number} cellWidth - Cell width
 * @param {Number} cellHeight - Cell height
 * @param {Number} spacing - Grid spacing
 * @returns {Array} - Grid positions
 */
CreateGridLayout(columns, rows, cellWidth, cellHeight, spacing := 0) {
    positions := []

    Loop rows {
        row := A_Index - 1
        Loop columns {
            col := A_Index - 1

            x := Floor(col * (cellWidth + spacing))
            y := Floor(row * (cellHeight + spacing))

            positions.Push({
                row: row,
                col: col,
                x: x,
                y: y,
                index: (row * columns) + col + 1
            })
        }
    }

    return positions
}

; Create button grid layout
gridCols := 4
gridRows := 3
buttonWidth := 80
buttonHeight := 30
buttonSpacing := 10

layout := CreateGridLayout(gridCols, gridRows, buttonWidth, buttonHeight, buttonSpacing)

output := "Grid Layout (" gridCols "×" gridRows "):`n"
output .= "Cell: " buttonWidth "×" buttonHeight " pixels`n"
output .= "Spacing: " buttonSpacing " pixels`n`n"

; Show first row and last item
for pos in layout {
    if (pos.row = 0 || pos.index = layout.Length) {
        output .= Format("Item {1} [R{2}C{3}]: ({4}, {5})`n",
            pos.index, pos.row, pos.col, pos.x, pos.y)
    } else if (pos.index = gridCols + 1) {
        output .= "...`n"
    }
}

totalWidth := Floor((gridCols - 1) * (buttonWidth + buttonSpacing)) + buttonWidth
totalHeight := Floor((gridRows - 1) * (buttonHeight + buttonSpacing)) + buttonHeight

output .= "`nTotal Grid Size: " totalWidth "×" totalHeight " pixels"

MsgBox(output, "Grid Layout", "Icon!")

; ============================================================
; Example 5: Coordinate Quantization
; ============================================================

/**
 * Quantize coordinate to specific increments
 * 
 * @param {Number} value - Value to quantize
 * @param {Number} quantum - Quantum size
 * @returns {Object} - Quantized value
 */
QuantizeValue(value, quantum) {
    quantized := Floor(value / quantum) * quantum
    quantumIndex := Floor(value / quantum)
    remainder := value - quantized

    return {
        original: value,
        quantum: quantum,
        quantized: quantized,
        index: quantumIndex,
        remainder: Round(remainder, 2)
    }
}

/**
 * Quantize RGB color components
 */
QuantizeColor(r, g, b, levels := 32) {
    quantum := 256 / levels
    return {
        original: { r: r, g: g, b: b },
        quantized: {
            r: Floor(r / quantum) * quantum,
            g: Floor(g / quantum) * quantum,
            b: Floor(b / quantum) * quantum
        },
        levels: levels,
        quantum: Round(quantum, 2)
    }
}

; Color quantization example
originalColor := { r: 127, g: 189, b: 234 }
quantized := QuantizeColor(originalColor.r, originalColor.g, originalColor.b, 32)

output := "Color Quantization:`n`n"
output .= "Levels: " quantized.levels " per channel`n"
output .= "Quantum: " quantized.quantum "`n`n"
output .= Format("Original RGB: ({1}, {2}, {3})`n",
    originalColor.r, originalColor.g, originalColor.b)
output .= Format("Quantized RGB: ({1}, {2}, {3})`n`n",
    quantized.quantized.r, quantized.quantized.g, quantized.quantized.b)
output .= "Reduces color palette while maintaining appearance"

MsgBox(output, "Color Quantization", "Icon!")

; ============================================================
; Example 6: Pixel-Perfect Scaling
; ============================================================

/**
 * Scale dimensions to whole pixels
 * 
 * @param {Number} width - Original width
 * @param {Number} height - Original height
 * @param {Number} scaleFactor - Scale factor
 * @returns {Object} - Scaled dimensions
 */
ScaleToWholePixels(width, height, scaleFactor) {
    scaledWidth := Floor(width * scaleFactor)
    scaledHeight := Floor(height * scaleFactor)
    aspectRatio := width / height

    return {
        original: { width: width, height: height },
        scaleFactor: scaleFactor,
        scaled: { width: scaledWidth, height: scaledHeight },
        originalAspect: Round(aspectRatio, 4),
        scaledAspect: Round(scaledWidth / scaledHeight, 4)
    }
}

/**
 * Scale maintaining aspect ratio with floor
 */
ScaleMaintainAspect(width, height, maxWidth, maxHeight) {
    widthRatio := maxWidth / width
    heightRatio := maxHeight / height
    scaleFactor := Min(widthRatio, heightRatio)

    newWidth := Floor(width * scaleFactor)
    newHeight := Floor(height * scaleFactor)

    return {
        original: { width: width, height: height },
        constraints: { width: maxWidth, height: maxHeight },
        scaled: { width: newWidth, height: newHeight },
        scaleFactor: Round(scaleFactor, 4)
    }
}

; Image scaling examples
imageSize := { width: 1920, height: 1080 }
scales := [0.5, 0.75, 1.25, 1.5]

output := "Image Scaling (Floor for Whole Pixels):`n"
output .= Format("Original: {1}×{2}`n`n", imageSize.width, imageSize.height)

for scale in scales {
    result := ScaleToWholePixels(imageSize.width, imageSize.height, scale)

    output .= Format("Scale {1}×: {2}×{3}`n",
        result.scaleFactor,
        result.scaled.width, result.scaled.height)
}

output .= "`nFloor() prevents fractional pixels"

MsgBox(output, "Pixel-Perfect Scaling", "Icon!")

; ============================================================
; Example 7: Tile Map Coordinates
; ============================================================

/**
 * Convert world coordinates to tile coordinates
 * 
 * @param {Number} worldX - World X coordinate
 * @param {Number} worldY - World Y coordinate
 * @param {Number} tileSize - Tile size in pixels
 * @returns {Object} - Tile coordinates
 */
WorldToTile(worldX, worldY, tileSize) {
    tileX := Floor(worldX / tileSize)
    tileY := Floor(worldY / tileSize)

    ; Position within tile
    localX := worldX - (tileX * tileSize)
    localY := worldY - (tileY * tileSize)

    return {
        world: { x: worldX, y: worldY },
        tile: { x: tileX, y: tileY },
        local: { x: Floor(localX), y: Floor(localY) },
        tileSize: tileSize
    }
}

/**
 * Convert tile coordinates back to world
 */
TileToWorld(tileX, tileY, tileSize) {
    worldX := tileX * tileSize
    worldY := tileY * tileSize

    return {
        tile: { x: tileX, y: tileY },
        world: { x: worldX, y: worldY },
        tileSize: tileSize
    }
}

/**
 * Get surrounding tile coordinates
 */
GetSurroundingTiles(centerTileX, centerTileY, radius := 1) {
    tiles := []

    Loop (2 * radius + 1) {
        row := A_Index - radius - 1
        Loop (2 * radius + 1) {
            col := A_Index - radius - 1
            tiles.Push({
                x: centerTileX + col,
                y: centerTileY + row
            })
        }
    }

    return tiles
}

; Tile map example
playerX := 347
playerY := 892
tileSize := 32

playerTile := WorldToTile(playerX, playerY, tileSize)

output := "Tile Map Coordinates:`n`n"
output .= "Tile Size: " tileSize " pixels`n`n"
output .= Format("Player World Position: ({1}, {2})`n",
    playerTile.world.x, playerTile.world.y)
output .= Format("Player Tile: ({1}, {2})`n",
    playerTile.tile.x, playerTile.tile.y)
output .= Format("Position in Tile: ({1}, {2})`n`n",
    playerTile.local.x, playerTile.local.y)

; Show surrounding tiles
surroundingTiles := GetSurroundingTiles(playerTile.tile.x, playerTile.tile.y, 1)
output .= "Surrounding 3×3 Tiles:`n"

centerIndex := 5  ; Middle of 3x3 grid
for index, tile in surroundingTiles {
    if (index = centerIndex)
        output .= Format("[{1}, {2}] ", tile.x, tile.y)
    else
        output .= Format("({1}, {2}) ", tile.x, tile.y)

    if (Mod(index, 3) = 0)
        output .= "`n"
}

MsgBox(output, "Tile Map System", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
            (
            FLOOR() FOR GRID ALIGNMENT & COORDINATES:

            Grid Snapping Formula:
            ──────────────────────
            snapped = Floor(value / gridSize) × gridSize

            Example (Grid size 50):
            127 → Floor(127/50) × 50 = Floor(2.54) × 50 = 100
            245 → Floor(245/50) × 50 = Floor(4.9) × 50 = 200

            Always snaps DOWN to nearest grid point

            2D Point Snapping:
            ──────────────────
            snappedX = Floor(x / grid) × grid
            snappedY = Floor(y / grid) × grid

            Point (347, 192) with grid 25:
            X: Floor(347/25) × 25 = 325
            Y: Floor(192/25) × 25 = 175

            Grid Index Calculation:
            ───────────────────────
            index = Floor(coordinate / gridSize)

            Useful for:
            • Array/tile lookups
            • Grid cell identification
            • Spatial partitioning

            Coordinate → Tile:
            tileX = Floor(worldX / tileSize)
            tileY = Floor(worldY / tileSize)

            Tile → Coordinate:
            worldX = tileX × tileSize
            worldY = tileY × tileSize

            Window Alignment:
            ─────────────────
            Align to 10-pixel grid:
            x = Floor(x / 10) × 10
            y = Floor(y / 10) × 10
            width = Floor(width / 10) × 10
            height = Floor(height / 10) × 10

            Benefits:
            ✓ Clean, rounded coordinates
            ✓ No sub-pixel rendering
            ✓ Consistent spacing
            ✓ Easier debugging

            Pixel-Perfect Scaling:
            ──────────────────────
            newWidth = Floor(width × scale)
            newHeight = Floor(height × scale)

            Prevents fractional pixels:
            1920×1080 at 0.5× scale
            Floor(1920 × 0.5) = 960
            Floor(1080 × 0.5) = 540
            Result: 960×540 (whole pixels)

            Grid Layout:
            ────────────
            Position items in grid:
            x = Floor(col × (cellWidth + spacing))
            y = Floor(row × (cellHeight + spacing))

            4×3 grid of 80×30 buttons, 10px spacing:
            Item [0,0]: (0, 0)
            Item [1,0]: (90, 0)
            Item [0,1]: (0, 40)

            Common Applications:
            ────────────────────
            ✓ UI element positioning
            ✓ Tile map systems
            ✓ Grid-based editors
            ✓ Snap-to-grid functionality
            ✓ Pixel art scaling
            ✓ Spatial partitioning
            ✓ Collision detection grids

            Why Use Floor (not Round):
            ───────────────────────────
            Consistency: Always snaps to same direction
            Predictability: Known behavior at boundaries
            Grid alignment: Ensures alignment to grid origin

            Example:
            Values 0-49 → Grid 0
            Values 50-99 → Grid 50
            Values 100-149 → Grid 100

            Round would create uneven distributions
            )"

MsgBox(info, "Grid Alignment Reference", "Icon!")
