#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Promise Library Examples - thqby/ahk2_lib
 * 
 * Async operations, chaining, error handling
 * Library: https://github.com/thqby/ahk2_lib/blob/master/Promise.ahk
 */

/**
 * Example 1: Basic Promise Creation
 */
BasicPromiseExample() {
    MsgBox("Basic Promise Creation`n`n"
        . "myPromise := Promise((resolve, reject) => {`n"
        . "    ; Do async work`n"
        . "    Sleep(1000)`n"
        . '    resolve("Success!")`n'
        . "})`n`n"
        . "myPromise.then((result) => MsgBox(result))")
}

/**
 * Example 2: Promise with Rejection
 */
PromiseRejectionExample() {
    MsgBox("Promise with Rejection Handling`n`n"
        . "riskyPromise := Promise((resolve, reject) => {`n"
        . "    if (Random(0, 1))`n"
        . '        resolve("Operation succeeded")`n'
        . "    else`n"
        . '        reject("Operation failed")`n'
        . "})`n`n"
        . "riskyPromise`n"
        . "    .then((result) => MsgBox(result))`n"
        . "    .catch((error) => MsgBox(`"Error: `" error))")
}

/**
 * Example 3: Promise Chaining
 */
PromiseChainingExample() {
    MsgBox("Promise Chaining`n`n"
        . "Promise.resolve(10)`n"
        . "    .then((val) => {`n"
        . "        MsgBox(`"Step 1: `" val)`n"
        . "        return val * 2`n"
        . "    })`n"
        . "    .then((val) => {`n"
        . "        MsgBox(`"Step 2: `" val)`n"
        . "        return val + 5`n"
        . "    })`n"
        . "    .then((val) => {`n"
        . "        MsgBox(`"Final: `" val)  ; 25`n"
        . "    })")
}

/**
 * Example 4: Promise.all - Wait for Multiple
 */
PromiseAllExample() {
    MsgBox("Promise.all - Wait for All`n`n"
        . "task1 := Promise((resolve, reject) => {`n"
        . "    Sleep(1000)`n"
        . '    resolve("Task 1 done")`n'
        . "})`n`n"
        . "task2 := Promise((resolve, reject) => {`n"
        . "    Sleep(500)`n"
        . '    resolve("Task 2 done")`n'
        . "})`n`n"
        . "Promise.all([task1, task2]).then((results) => {`n"
        . "    MsgBox(`"All tasks completed:`n`" results.Join(`"`n`"))`n"
        . "})")
}

/**
 * Example 5: Promise.race - First to Complete
 */
PromiseRaceExample() {
    MsgBox("Promise.race - First to Complete`n`n"
        . "slow := Promise((resolve, reject) => {`n"
        . "    Sleep(2000)`n"
        . '    resolve("Slow task")`n'
        . "})`n`n"
        . "fast := Promise((resolve, reject) => {`n"
        . "    Sleep(500)`n"
        . '    resolve("Fast task")`n'
        . "})`n`n"
        . "Promise.race([slow, fast]).then((result) => {`n"
        . "    MsgBox(`"Winner: `" result)  ; `"Fast task`"`n"
        . "})")
}

/**
 * Example 6: Async File Operations
 */
AsyncFileOperationsExample() {
    MsgBox("Async File Operations`n`n"
        . "ReadFileAsync(filePath) {`n"
        . "    return Promise((resolve, reject) => {`n"
        . "        try {`n"
        . "            content := FileRead(filePath)`n"
        . "            resolve(content)`n"
        . "        } catch Error as e {`n"
        . "            reject(e.Message)`n"
        . "        }`n"
        . "    })`n"
        . "}`n`n"
        . 'ReadFileAsync("config.txt")`n'
        . "    .then((content) => MsgBox(content))`n"
        . "    .catch((error) => MsgBox(`"Error: `" error))")
}

/**
 * Example 7: Timeout Pattern
 */
TimeoutPatternExample() {
    MsgBox("Promise with Timeout`n`n"
        . "TimeoutPromise(ms) {`n"
        . "    return Promise((resolve, reject) => {`n"
        . "        SetTimer(() => reject(`"Timeout!`"), -ms)`n"
        . "    })`n"
        . "}`n`n"
        . "operation := Promise((resolve, reject) => {`n"
        . "    Sleep(3000)  ; Long operation`n"
        . '    resolve("Done")`n'
        . "})`n`n"
        . "Promise.race([operation, TimeoutPromise(2000)])`n"
        . "    .then((result) => MsgBox(result))`n"
        . "    .catch((error) => MsgBox(error))  ; Will timeout")
    }

    /**
     * Example 8: Retry Pattern
     */
    RetryPatternExample() {
        MsgBox("Promise Retry Pattern`n`n"
            . "Retry(fn, maxAttempts := 3) {`n"
            . "    attempt := 1`n"
            . "    return Promise((resolve, reject) => {`n"
            . "        TryExecute() {`n"
            . "            try {`n"
            . "                result := fn()`n"
            . "                resolve(result)`n"
            . "            } catch Error as e {`n"
            . "                if (attempt < maxAttempts) {`n"
            . "                    attempt++`n"
            . "                    TryExecute()`n"
            . "                } else {`n"
            . "                    reject(e.Message)`n"
            . "                }`n"
            . "            }`n"
            . "        }`n"
            . "        TryExecute()`n"
            . "    })`n"
            . "}`n`n"
            . "Retry(() => UnreliableOperation())`n"
            . "    .then((result) => MsgBox(`"Success: `" result))`n"
            . "    .catch((error) => MsgBox(`"Failed after retries`"))")
    }

    /**
     * Example 9: Sequential vs Parallel Execution
     */
    SequentialVsParallelExample() {
        MsgBox("Sequential vs Parallel Execution`n`n"
            . "; Sequential (one after another)`n"
            . "Promise.resolve()`n"
            . "    .then(() => Task1())  ; Wait for this`n"
            . "    .then(() => Task2())  ; Then this`n"
            . "    .then(() => Task3())  ; Then this`n`n"
            . "; Parallel (all at once)`n"
            . "Promise.all([Task1(), Task2(), Task3()])`n"
            . "    .then(() => MsgBox(`"All done!`"))")
    }

    /**
     * Example 10: Error Recovery
     */
    ErrorRecoveryExample() {
        MsgBox("Promise Error Recovery`n`n"
            . "Promise((resolve, reject) => {`n"
            . '    reject("Primary failed")`n'
            . "})`n"
            . ".catch((error) => {`n"
            . "    ; Recover from error`n"
            . "    MsgBox(`"Recovering from: `" error)`n"
            . '    return "Fallback value"  ; Continue chain`n'
            . "})`n"
            . ".then((result) => {`n"
            . "    MsgBox(`"Got: `" result)  ; `"Fallback value`"`n"
            . "})")
    }

    /**
     * Example 11: Data Pipeline
     */
    DataPipelineExample() {
        MsgBox("Data Processing Pipeline`n`n"
            . "ProcessData(rawData) {`n"
            . "    return Promise.resolve(rawData)`n"
            . "        .then((data) => ValidateData(data))`n"
            . "        .then((data) => TransformData(data))`n"
            . "        .then((data) => EnrichData(data))`n"
            . "        .then((data) => SaveData(data))`n"
            . "        .catch((error) => LogError(error))`n"
            . "}`n`n"
            . "ProcessData(inputData)`n"
            . "    .then(() => MsgBox(`"Pipeline complete!`"))")
    }

    /**
     * Example 12: Conditional Execution
     */
    ConditionalExecutionExample() {
        MsgBox("Conditional Promise Execution`n`n"
            . "CheckAuth()`n"
            . "    .then((isAuthed) => {`n"
            . "        if (isAuthed)`n"
            . "            return FetchUserData()`n"
            . "        else`n"
            . "            throw Error(`"Not authorized`")`n"
            . "    })`n"
            . "    .then((userData) => DisplayData(userData))`n"
            . "    .catch((error) => RedirectToLogin())")
    }

    /**
     * Example 13: Promise Queue
     */
    PromiseQueueExample() {
        MsgBox("Promise Queue (Sequential Execution)`n`n"
            . "class PromiseQueue {`n"
            . "    queue := []`n"
            . "    running := false`n`n"
            . "    Add(promiseFactory) {`n"
            . "        this.queue.Push(promiseFactory)`n"
            . "        if (!this.running)`n"
            . "            this.Process()`n"
            . "    }`n`n"
            . "    Process() {`n"
            . "        if (this.queue.Length = 0) {`n"
            . "            this.running := false`n"
            . "            return`n"
            . "        }`n"
            . "        this.running := true`n"
            . "        factory := this.queue.RemoveAt(1)`n"
            . "        factory().then(() => this.Process())`n"
            . "    }`n"
            . "}`n`n"
            . "queue := PromiseQueue()`n"
            . "queue.Add(() => Task1())`n"
            . "queue.Add(() => Task2())`n"
            . "queue.Add(() => Task3())")
    }

    /**
     * Example 14: Debounced Promises
     */
    DebouncedPromisesExample() {
        MsgBox("Debounced Promise Execution`n`n"
            . "class Debouncer {`n"
            . "    timer := 0`n"
            . "    delay := 500`n`n"
            . "    Debounce(fn) {`n"
            . "        return (*) => {`n"
            . "            if (this.timer)`n"
            . "                SetTimer(this.timer, 0)`n"
            . "            this.timer := () => {`n"
            . "                Promise.resolve().then(() => fn())`n"
            . "            }`n"
            . "            SetTimer(this.timer, -this.delay)`n"
            . "        }`n"
            . "    }`n"
            . "}`n`n"
            . "; Only runs after 500ms of no calls`n"
            . "debouncedSave := Debouncer().Debounce(() => SaveData())")
    }

    /**
     * Example 15: Promise-based Event Handler
     */
    PromiseEventHandlerExample() {
        MsgBox("Promise-based Event Handler`n`n"
            . "WaitForClick() {`n"
            . "    return Promise((resolve, reject) => {`n"
            . "        callback := (*) => {`n"
            . "            Hotkey(`"LButton`", `"Off`")`n"
            . "            MouseGetPos(&x, &y)`n"
            . "            resolve({x: x, y: y})`n"
            . "        }`n"
            . "        Hotkey(`"LButton`", callback)`n"
            . "    })`n"
            . "}`n`n"
            . "MsgBox(`"Click anywhere...`")`n"
            . "WaitForClick().then((pos) => {`n"
            . "    MsgBox(`"Clicked at: `" pos.x `", `" pos.y)`n"
            . "})")
    }

    MsgBox("Promise Library Examples Loaded`n`n"
        . "Note: These are conceptual examples.`n"
        . "To use, you need to include:`n"
        . "#Include <Promise>`n`n"
        . "Available Examples:`n"
        . "- BasicPromiseExample()`n"
        . "- PromiseChainingExample()`n"
        . "- PromiseAllExample()`n"
        . "- PromiseRaceExample()`n"
        . "- TimeoutPatternExample()`n"
        . "- RetryPatternExample()`n"
        . "- DataPipelineExample()`n"
        . "- PromiseQueueExample()")

    ; Uncomment to view examples:
    ; BasicPromiseExample()
    ; PromiseChainingExample()
    ; PromiseAllExample()
    ; TimeoutPatternExample()
    ; RetryPatternExample()

