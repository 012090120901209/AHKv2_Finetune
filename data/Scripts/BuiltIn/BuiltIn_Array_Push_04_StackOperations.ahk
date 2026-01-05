#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * Array.Push() - Stack Operations and Data Structures
 * ============================================================================
 * 
 * The Push() method is fundamental for implementing stack data structures
 * and related algorithms. This file demonstrates various stack-based patterns
 * and advanced data structure implementations.
 * 
 * @description Stack operations and data structures using Push()
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; ============================================================================
; Example 1: Basic Stack Implementation
; ============================================================================
; Implementing a stack using Push() and Pop()
Example1_BasicStack() {
    OutputDebug("=== Example 1: Basic Stack Implementation ===`n")

    ; Create a Stack class
    stack := Stack()

    ; Push elements onto stack
    stack.Push("First")
    stack.Push("Second")
    stack.Push("Third")
    stack.Push("Fourth")

    OutputDebug("Stack size after pushes: " stack.Size() "`n")
    OutputDebug("Top element (Peek): " stack.Peek() "`n")

    ; Pop elements
    OutputDebug("`nPopping elements:`n")
    while (!stack.IsEmpty()) {
        item := stack.Pop()
        OutputDebug("  Popped: " item " (Remaining: " stack.Size() ")`n")
    }

    ; Demonstrate stack overflow protection
    limitedStack := Stack(5)  ; Max size of 5

    Loop 7 {
        result := limitedStack.Push("Item " A_Index)
        if (!result) {
            OutputDebug("`nStack full! Cannot push Item " A_Index "`n")
        }
    }

    OutputDebug("Limited stack size: " limitedStack.Size() "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 2: Expression Evaluation (Parentheses Matching)
; ============================================================================
; Use stack to validate balanced parentheses
Example2_ParenthesesMatching() {
    OutputDebug("=== Example 2: Parentheses Matching ===`n")

    ; Test cases
    testCases := [
        "()",
        "(())",
        "((()))",
        "()()()`n",
        "(()",
        "())",
        "(()())",
        "((())",
        "{[()]}",
        "{[(])}",
        "((a + b) * (c - d))"
    ]

    for expression in testCases {
        isValid := ValidateParentheses(expression)
        status := isValid ? "VALID" : "INVALID"
        OutputDebug(expression " -> " status "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Function Call Stack Simulation
; ============================================================================
; Simulate function call stack
Example3_FunctionCallStack() {
    OutputDebug("=== Example 3: Function Call Stack ===`n")

    callStack := []

    ; Simulate nested function calls
    OutputDebug("Simulating function calls:`n")

    ; Call main()
    callStack.Push({ name: "main", line: 1, locals: Map() })
    OutputDebug("  PUSH: main() | Stack depth: " callStack.Length "`n")

    ; main() calls processData()
    callStack.Push({ name: "processData", line: 10, locals: Map("data", "test") })
    OutputDebug("  PUSH: processData() | Stack depth: " callStack.Length "`n")

    ; processData() calls validateInput()
    callStack.Push({ name: "validateInput", line: 25, locals: Map("input", "test") })
    OutputDebug("  PUSH: validateInput() | Stack depth: " callStack.Length "`n")

    ; validateInput() calls checkFormat()
    callStack.Push({ name: "checkFormat", line: 40, locals: Map("format", "string") })
    OutputDebug("  PUSH: checkFormat() | Stack depth: " callStack.Length "`n")

    ; Functions return
    OutputDebug("`nFunctions returning:`n")

    while (callStack.Length > 0) {
        frame := callStack.Pop()
        OutputDebug("  POP: " frame.name "() returned | Stack depth: "
            callStack.Length "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Undo/Redo System
; ============================================================================
; Implement undo/redo functionality using stacks
Example4_UndoRedoSystem() {
    OutputDebug("=== Example 4: Undo/Redo System ===`n")

    undoStack := []
    redoStack := []
    currentState := ""

    ; Perform actions
    PerformAction(&currentState, &undoStack, &redoStack, "Type: Hello")
    PerformAction(&currentState, &undoStack, &redoStack, "Type: World")
    PerformAction(&currentState, &undoStack, &redoStack, "Delete: 5 chars")
    PerformAction(&currentState, &undoStack, &redoStack, "Type: !")

    OutputDebug("`nCurrent state: " currentState "`n")
    OutputDebug("Undo stack size: " undoStack.Length "`n")
    OutputDebug("Redo stack size: " redoStack.Length "`n")

    ; Undo operations
    OutputDebug("`nPerforming undo:`n")
    Undo(&currentState, &undoStack, &redoStack)
    Undo(&currentState, &undoStack, &redoStack)

    OutputDebug("`nAfter undo:`n")
    OutputDebug("Current state: " currentState "`n")
    OutputDebug("Undo stack: " undoStack.Length " | Redo stack: " redoStack.Length "`n")

    ; Redo operations
    OutputDebug("`nPerforming redo:`n")
    Redo(&currentState, &undoStack, &redoStack)

    OutputDebug("`nAfter redo:`n")
    OutputDebug("Current state: " currentState "`n")
    OutputDebug("Undo stack: " undoStack.Length " | Redo stack: " redoStack.Length "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Reverse Polish Notation (RPN) Calculator
; ============================================================================
; Implement RPN calculator using stack
Example5_RPNCalculator() {
    OutputDebug("=== Example 5: RPN Calculator ===`n")

    ; Test RPN expressions
    expressions := [
        "3 4 +",           ; 3 + 4 = 7
        "15 7 1 1 + - /",  ; 15 / (7 - (1 + 1)) = 3
        "5 1 2 + 4 * + 3 -", ; 5 + ((1 + 2) * 4) - 3 = 14
        "2 3 ^",           ; 2 ^ 3 = 8
        "10 2 /",          ; 10 / 2 = 5
    ]

    for expr in expressions {
        result := EvaluateRPN(expr)
        OutputDebug(expr " = " result "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Browser History Stack
; ============================================================================
; Simulate browser back/forward navigation
Example6_BrowserHistory() {
    OutputDebug("=== Example 6: Browser History ===`n")

    backStack := []
    forwardStack := []
    currentPage := "home.html"

    ; Navigate to pages
    NavigateTo(&currentPage, &backStack, &forwardStack, "about.html")
    NavigateTo(&currentPage, &backStack, &forwardStack, "products.html")
    NavigateTo(&currentPage, &backStack, &forwardStack, "contact.html")

    OutputDebug("`nCurrent page: " currentPage "`n")
    OutputDebug("Can go back: " (backStack.Length > 0 ? "Yes" : "No") "`n")

    ; Go back
    OutputDebug("`nGoing back:`n")
    GoBack(&currentPage, &backStack, &forwardStack)
    GoBack(&currentPage, &backStack, &forwardStack)

    OutputDebug("`nCurrent page: " currentPage "`n")
    OutputDebug("Can go forward: " (forwardStack.Length > 0 ? "Yes" : "No") "`n")

    ; Go forward
    OutputDebug("`nGoing forward:`n")
    GoForward(&currentPage, &backStack, &forwardStack)

    OutputDebug("`nFinal page: " currentPage "`n")
    OutputDebug("History - Back: " backStack.Length " | Forward: " forwardStack.Length "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Depth-First Search (DFS) Using Stack
; ============================================================================
; Implement graph traversal using stack
Example7_DepthFirstSearch() {
    OutputDebug("=== Example 7: Depth-First Search ===`n")

    ; Create a simple graph (adjacency list)
    graph := Map(
        "A", ["B", "C"],
        "B", ["D", "E"],
        "C", ["F"],
        "D", [],
        "E", ["F"],
        "F", []
    )

    ; Perform DFS starting from "A"
    visited := Map()
    stack := ["A"]
    traversalOrder := []

    OutputDebug("DFS traversal starting from A:`n")

    while (stack.Length > 0) {
        node := stack.Pop()

        if (visited.Has(node)) {
            continue
        }

        visited[node] := true
        traversalOrder.Push(node)
        OutputDebug("  Visited: " node "`n")

        ; Push neighbors to stack (in reverse order for correct traversal)
        neighbors := graph[node]
        Loop neighbors.Length {
            neighbor := neighbors[neighbors.Length - A_Index + 1]
            if (!visited.Has(neighbor)) {
                stack.Push(neighbor)
            }
        }
    }

    OutputDebug("`nTraversal order: " FormatArray(traversalOrder) "`n")
    OutputDebug("Nodes visited: " visited.Count "`n")

    OutputDebug("`n")
}

; ============================================================================
; Stack Class Implementation
; ============================================================================

class Stack {
    items := []
    maxSize := 0

    __New(maxSize := 0) {
        this.items := []
        this.maxSize := maxSize
    }

    Push(item) {
        if (this.maxSize > 0 && this.items.Length >= this.maxSize) {
            return false  ; Stack full
        }
        this.items.Push(item)
        return true
    }

    Pop() {
        if (this.IsEmpty()) {
            throw Error("Stack underflow - cannot pop from empty stack")
        }
        return this.items.Pop()
    }

    Peek() {
        if (this.IsEmpty()) {
            throw Error("Stack is empty - cannot peek")
        }
        return this.items[this.items.Length]
    }

    IsEmpty() {
        return this.items.Length = 0
    }

    Size() {
        return this.items.Length
    }

    Clear() {
        this.items := []
    }
}

; ============================================================================
; Helper Functions
; ============================================================================

/**
 * Validates balanced parentheses using stack
 * @param {String} expression - Expression to validate
 * @returns {Boolean} True if balanced
 */
ValidateParentheses(expression) {
    stack := []
    pairs := Map("(", ")", "[", "]", "{", "}")

    Loop Parse, expression {
        char := A_LoopField

        ; Opening bracket
        if (pairs.Has(char)) {
            stack.Push(char)
        }
        ; Closing bracket
        else if (char = ")" || char = "]" || char = "}") {
            if (stack.Length = 0) {
                return false
            }

            opening := stack.Pop()
            if (pairs[opening] != char) {
                return false
            }
        }
    }

    return stack.Length = 0
}

/**
 * Performs an action and updates undo stack
 */
PerformAction(&state, &undoStack, &redoStack, action) {
    undoStack.Push(state)
    state := action
    redoStack := []  ; Clear redo stack on new action
    OutputDebug("Action: " action "`n")
}

/**
 * Undo last action
 */
Undo(&state, &undoStack, &redoStack) {
    if (undoStack.Length > 0) {
        redoStack.Push(state)
        state := undoStack.Pop()
        OutputDebug("Undo -> State: " state "`n")
    }
}

/**
 * Redo last undone action
 */
Redo(&state, &undoStack, &redoStack) {
    if (redoStack.Length > 0) {
        undoStack.Push(state)
        state := redoStack.Pop()
        OutputDebug("Redo -> State: " state "`n")
    }
}

/**
 * Evaluates RPN expression
 * @param {String} expression - RPN expression
 * @returns {Number} Result
 */
EvaluateRPN(expression) {
    stack := []

    Loop Parse, expression, " " {
        token := A_LoopField

        if (token = "") {
            continue
        }

        ; Check if operator
        if (token = "+" || token = "-" || token = "*" || token = "/" || token = "^") {
            b := stack.Pop()
            a := stack.Pop()

            if (token = "+") {
                result := a + b
            } else if (token = "-") {
                result := a - b
            } else if (token = "*") {
                result := a * b
            } else if (token = "/") {
                result := a / b
            } else if (token = "^") {
                result := a ** b
            }

            stack.Push(result)
        } else {
            ; Number
            stack.Push(Number(token))
        }
    }

    return stack.Pop()
}

/**
 * Navigate to a new page
 */
NavigateTo(&currentPage, &backStack, &forwardStack, newPage) {
    backStack.Push(currentPage)
    currentPage := newPage
    forwardStack := []  ; Clear forward stack
    OutputDebug("Navigated to: " newPage "`n")
}

/**
 * Go back in history
 */
GoBack(&currentPage, &backStack, &forwardStack) {
    if (backStack.Length > 0) {
        forwardStack.Push(currentPage)
        currentPage := backStack.Pop()
        OutputDebug("Back to: " currentPage "`n")
    }
}

/**
 * Go forward in history
 */
GoForward(&currentPage, &backStack, &forwardStack) {
    if (forwardStack.Length > 0) {
        backStack.Push(currentPage)
        currentPage := forwardStack.Pop()
        OutputDebug("Forward to: " currentPage "`n")
    }
}

/**
 * Formats an array for display
 */
FormatArray(arr) {
    if (arr.Length = 0) {
        return "[]"
    }

    result := "["
    for index, value in arr {
        if (index > 1) {
            result .= ", "
        }
        result .= value
    }
    result .= "]"

    return result
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    ; Clear debug output
    OutputDebug("`n" String.Repeat("=", 80) "`n")
    OutputDebug("Array.Push() - Stack Operations Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    ; Run all examples
    Example1_BasicStack()
    Example2_ParenthesesMatching()
    Example3_FunctionCallStack()
    Example4_UndoRedoSystem()
    Example5_RPNCalculator()
    Example6_BrowserHistory()
    Example7_DepthFirstSearch()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    ; MsgBox("Array.Push() stack operations examples completed!`nCheck DebugView for output.",
    ;        "Examples Complete", "Icon!")
    ExitApp
}

; Run the examples
Main()
