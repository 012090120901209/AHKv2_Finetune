#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_DllCall_Kernel32_04_Time.ahk
 * 
 * DESCRIPTION:
 * Demonstrates time and date functions using Windows API through DllCall.
 * Shows how to get system time, file time, tick counts, high-resolution timing,
 * and time zone information.
 * 
 * FEATURES:
 * - Getting system time and local time
 * - File time conversions
 * - High-resolution performance counters
 * - Tick count for elapsed time
 * - Time zone information
 * - Time format conversions
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft Time Functions
 * https://docs.microsoft.com/en-us/windows/win32/sysinfo/time-functions
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() with time functions
 * - SYSTEMTIME and FILETIME structures
 * - 64-bit integer handling
 * - High-precision timing measurements
 * 
 * LEARNING POINTS:
 * 1. Getting system and local time
 * 2. Working with SYSTEMTIME structures
 * 3. Converting between time formats
 * 4. Using high-resolution performance counters
 * 5. Measuring elapsed time accurately
 * 6. Getting tick counts
 * 7. Time zone management
 */

;==============================================================================
; EXAMPLE 1: System Time
;==============================================================================
Example1_SystemTime() {
    ; SYSTEMTIME structure (16 bytes)
    sysTime := Buffer(16, 0)

    ; Get current system time (UTC)
    DllCall("Kernel32.dll\GetSystemTime", "Ptr", sysTime.Ptr, "Ptr")

    ; Extract fields
    year := NumGet(sysTime, 0, "UShort")
    month := NumGet(sysTime, 2, "UShort")
    dayOfWeek := NumGet(sysTime, 4, "UShort")
    day := NumGet(sysTime, 6, "UShort")
    hour := NumGet(sysTime, 8, "UShort")
    minute := NumGet(sysTime, 10, "UShort")
    second := NumGet(sysTime, 12, "UShort")
    milliseconds := NumGet(sysTime, 14, "UShort")

    days := ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    dayName := days[dayOfWeek + 1]

    utcTime := Format("{:04d}-{:02d}-{:02d} {:02d}:{:02d}:{:02d}.{:03d} UTC",
        year, month, day, hour, minute, second, milliseconds)

    ; Get local time
    localTime := Buffer(16, 0)
    DllCall("Kernel32.dll\GetLocalTime", "Ptr", localTime.Ptr, "Ptr")

    lYear := NumGet(localTime, 0, "UShort")
    lMonth := NumGet(localTime, 2, "UShort")
    lDay := NumGet(localTime, 6, "UShort")
    lHour := NumGet(localTime, 8, "UShort")
    lMinute := NumGet(localTime, 10, "UShort")
    lSecond := NumGet(localTime, 12, "UShort")

    local := Format("{:04d}-{:02d}-{:02d} {:02d}:{:02d}:{:02d}",
        lYear, lMonth, lDay, lHour, lMinute, lSecond)

    MsgBox(Format("System Time:`n`nUTC: {}`nDay: {}`n`nLocal: {}", utcTime, dayName, local), "Time Info")
}

;==============================================================================
; EXAMPLE 2: File Time Operations
;==============================================================================
Example2_FileTime() {
    ; Create a test file
    testFile := A_Temp . "\test_time.txt"
    FileAppend("Test", testFile)

    ; Get file handle
    GENERIC_READ := 0x80000000
    OPEN_EXISTING := 3
    FILE_ATTRIBUTE_NORMAL := 0x80

    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_READ
        , "UInt", 0
        , "Ptr", 0
        , "UInt", OPEN_EXISTING
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    ; Get file times
    creation := Buffer(8, 0)
    access := Buffer(8, 0)
    write := Buffer(8, 0)

    DllCall("Kernel32.dll\GetFileTime"
        , "Ptr", hFile
        , "Ptr", creation.Ptr
        , "Ptr", access.Ptr
        , "Ptr", write.Ptr
        , "Int")

    ; Convert FILETIME to SYSTEMTIME
    sysTime := Buffer(16, 0)

    results := "File Times:`n`n"

    ; Creation time
    DllCall("Kernel32.dll\FileTimeToSystemTime", "Ptr", creation.Ptr, "Ptr", sysTime.Ptr, "Int")
    year := NumGet(sysTime, 0, "UShort")
    month := NumGet(sysTime, 2, "UShort")
    day := NumGet(sysTime, 6, "UShort")
    hour := NumGet(sysTime, 8, "UShort")
    minute := NumGet(sysTime, 10, "UShort")
    second := NumGet(sysTime, 12, "UShort")
    results .= Format("Created: {:04d}-{:02d}-{:02d} {:02d}:{:02d}:{:02d}`n",
        year, month, day, hour, minute, second)

    ; Modified time
    DllCall("Kernel32.dll\FileTimeToSystemTime", "Ptr", write.Ptr, "Ptr", sysTime.Ptr, "Int")
    year := NumGet(sysTime, 0, "UShort")
    month := NumGet(sysTime, 2, "UShort")
    day := NumGet(sysTime, 6, "UShort")
    hour := NumGet(sysTime, 8, "UShort")
    minute := NumGet(sysTime, 10, "UShort")
    second := NumGet(sysTime, 12, "UShort")
    results .= Format("Modified: {:04d}-{:02d}-{:02d} {:02d}:{:02d}:{:02d}`n",
        year, month, day, hour, minute, second)

    MsgBox(results, "File Times")

    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")
    FileDelete(testFile)

    ; Convert SYSTEMTIME to FILETIME
    nowSys := Buffer(16, 0)
    DllCall("Kernel32.dll\GetSystemTime", "Ptr", nowSys.Ptr, "Ptr")

    nowFile := Buffer(8, 0)
    DllCall("Kernel32.dll\SystemTimeToFileTime", "Ptr", nowSys.Ptr, "Ptr", nowFile.Ptr, "Int")

    ; Convert to local file time
    localFile := Buffer(8, 0)
    DllCall("Kernel32.dll\FileTimeToLocalFileTime", "Ptr", nowFile.Ptr, "Ptr", localFile.Ptr, "Int")

    MsgBox("Time conversion successful!", "Success")
}

;==============================================================================
; EXAMPLE 3: High-Resolution Performance Counter
;==============================================================================
Example3_PerformanceCounter() {
    ; Get frequency
    frequency := Buffer(8, 0)
    DllCall("Kernel32.dll\QueryPerformanceFrequency", "Ptr", frequency.Ptr, "Int")
    freq := NumGet(frequency, 0, "Int64")

    MsgBox(Format("Performance Counter Frequency: {} Hz", freq), "Info")

    ; Measure elapsed time for an operation
    start := Buffer(8, 0)
    end := Buffer(8, 0)

    DllCall("Kernel32.dll\QueryPerformanceCounter", "Ptr", start.Ptr, "Int")

    ; Do some work
    Loop 1000000 {
        temp := A_Index * 2
    }

    DllCall("Kernel32.dll\QueryPerformanceCounter", "Ptr", end.Ptr, "Int")

    startCount := NumGet(start, 0, "Int64")
    endCount := NumGet(end, 0, "Int64")
    elapsed := endCount - startCount

    ; Calculate time in different units
    microseconds := (elapsed * 1000000) / freq
    milliseconds := (elapsed * 1000) / freq
    seconds := elapsed / freq

    MsgBox(Format("
    (
    Performance Measurement:

    Counts: {}
    Microseconds: {:.2f} µs
    Milliseconds: {:.2f} ms
    Seconds: {:.6f} s
    )", elapsed, microseconds, milliseconds, seconds), "Timing Results")

    ; Compare with GetTickCount
    tick1 := DllCall("Kernel32.dll\GetTickCount", "UInt")
    Sleep(100)
    tick2 := DllCall("Kernel32.dll\GetTickCount", "UInt")

    MsgBox(Format("GetTickCount test:`n`nExpected ~100ms`nActual: {} ms", tick2 - tick1), "Tick Count")
}

;==============================================================================
; EXAMPLE 4: Time Zone Information
;==============================================================================
Example4_TimeZone() {
    ; TIME_ZONE_INFORMATION structure (172 bytes)
    tzInfo := Buffer(172, 0)

    result := DllCall("Kernel32.dll\GetTimeZoneInformation"
        , "Ptr", tzInfo.Ptr
        , "UInt")

    ; result: 0 = unknown, 1 = standard time, 2 = daylight time

    bias := NumGet(tzInfo, 0, "Int")  ; Minutes from UTC

    ; Get time zone name (wide string at offset 4, max 32 chars)
    tzName := StrGet(tzInfo.Ptr + 4, 32, "UTF-16")

    ; Get standard name (offset 84)
    stdName := StrGet(tzInfo.Ptr + 84, 32, "UTF-16")

    ; Get daylight name (offset 164... but let's skip for simplicity)

    hours := -bias // 60
    minutes := Abs(Mod(-bias, 60))

    utcOffset := Format("UTC{}{:02d}:{:02d}",
        hours >= 0 ? "+" : "",
        hours,
        minutes)

    timeType := ["Unknown", "Standard Time", "Daylight Time"][result + 1]

    MsgBox(Format("
    (
    Time Zone Information:

    Name: {}
    Standard Name: {}
    UTC Offset: {}
    Bias: {} minutes
    Current: {}
    )", tzName, stdName, utcOffset, bias, timeType), "Time Zone")

    ; Get dynamic time zone information
    dynInfo := Buffer(320, 0)
    result := DllCall("Kernel32.dll\GetDynamicTimeZoneInformation"
        , "Ptr", dynInfo.Ptr
        , "UInt")

    if (result != 0xFFFFFFFF) {
        keyName := StrGet(dynInfo.Ptr + 172, 32, "UTF-16")
        MsgBox("Time Zone Key Name: " . keyName, "Dynamic TZ Info")
    }
}

;==============================================================================
; EXAMPLE 5: Tick Count and Uptime
;==============================================================================
Example5_TickCount() {
    ; GetTickCount (32-bit, wraps every 49.7 days)
    tick32 := DllCall("Kernel32.dll\GetTickCount", "UInt")

    ; GetTickCount64 (64-bit, won't wrap)
    tick64 := DllCall("Kernel32.dll\GetTickCount64", "Int64")

    ; Calculate system uptime
    uptimeMs := tick64
    uptimeSec := uptimeMs / 1000
    uptimeMin := uptimeSec / 60
    uptimeHour := uptimeMin / 60
    uptimeDay := uptimeHour / 24

    days := Floor(uptimeDay)
    hours := Floor(Mod(uptimeHour, 24))
    minutes := Floor(Mod(uptimeMin, 60))
    seconds := Floor(Mod(uptimeSec, 60))

    MsgBox(Format("
    (
    System Uptime:

    GetTickCount: {} ms
    GetTickCount64: {} ms

    Uptime:
    {
    } days, {} hours, {} minutes, {} seconds

    Total: {:.2f} hours
    )", tick32, tick64, days, hours, minutes, seconds, uptimeHour), "Uptime")

    ; Demonstrate timing with tick count
    MsgBox("Starting 2-second timer...", "Info", "T1")

    start := DllCall("Kernel32.dll\GetTickCount64", "Int64")
    Sleep(2000)
    end := DllCall("Kernel32.dll\GetTickCount64", "Int64")

    elapsed := end - start

    MsgBox(Format("Timer test:`nExpected: ~2000ms`nActual: {}ms", elapsed), "Timer Result")
}

;==============================================================================
; EXAMPLE 6: Time Format Conversion
;==============================================================================
Example6_TimeConversion() {
    ; Get current system time
    sysTime := Buffer(16, 0)
    DllCall("Kernel32.dll\GetSystemTime", "Ptr", sysTime.Ptr, "Ptr")

    ; Convert to file time
    fileTime := Buffer(8, 0)
    DllCall("Kernel32.dll\SystemTimeToFileTime"
        , "Ptr", sysTime.Ptr
        , "Ptr", fileTime.Ptr
        , "Int")

    ; Get file time as 64-bit integer
    fileTime64 := NumGet(fileTime, 0, "Int64")

    ; FILETIME is 100-nanosecond intervals since Jan 1, 1601
    ; Convert to Unix timestamp (seconds since Jan 1, 1970)
    TICKS_TO_UNIX_EPOCH := 116444736000000000
    TICKS_PER_SECOND := 10000000

    unixTime := (fileTime64 - TICKS_TO_UNIX_EPOCH) / TICKS_PER_SECOND

    MsgBox(Format("
    (
    Time Conversions:

    FileTime (64-bit): {}
    Unix Timestamp: {}

    FILETIME represents 100-nanosecond
    intervals since January 1, 1601
    )", fileTime64, Floor(unixTime)), "Conversions")

    ; Convert back to SYSTEMTIME
    backSys := Buffer(16, 0)
    DllCall("Kernel32.dll\FileTimeToSystemTime"
        , "Ptr", fileTime.Ptr
        , "Ptr", backSys.Ptr
        , "Int")

    year := NumGet(backSys, 0, "UShort")
    month := NumGet(backSys, 2, "UShort")
    day := NumGet(backSys, 6, "UShort")
    hour := NumGet(backSys, 8, "UShort")
    minute := NumGet(backSys, 10, "UShort")
    second := NumGet(backSys, 12, "UShort")

    MsgBox(Format("Converted back: {:04d}-{:02d}-{:02d} {:02d}:{:02d}:{:02d}",
        year, month, day, hour, minute, second), "Verification")
}

;==============================================================================
; EXAMPLE 7: Advanced Timing Operations
;==============================================================================
Example7_AdvancedTiming() {
    ; Benchmark different operations
    frequency := Buffer(8, 0)
    DllCall("Kernel32.dll\QueryPerformanceFrequency", "Ptr", frequency.Ptr, "Int")
    freq := NumGet(frequency, 0, "Int64")

    ; Test 1: String concatenation
    start := Buffer(8, 0)
    end := Buffer(8, 0)

    DllCall("Kernel32.dll\QueryPerformanceCounter", "Ptr", start.Ptr, "Int")
    str := ""
    Loop 1000
        str .= "x"
    DllCall("Kernel32.dll\QueryPerformanceCounter", "Ptr", end.Ptr, "Int")

    test1Time := ((NumGet(end, 0, "Int64") - NumGet(start, 0, "Int64")) * 1000000) / freq

    ; Test 2: Array operations
    DllCall("Kernel32.dll\QueryPerformanceCounter", "Ptr", start.Ptr, "Int")
    arr := []
    Loop 1000
        arr.Push(A_Index)
    DllCall("Kernel32.dll\QueryPerformanceCounter", "Ptr", end.Ptr, "Int")

    test2Time := ((NumGet(end, 0, "Int64") - NumGet(start, 0, "Int64")) * 1000000) / freq

    ; Test 3: Map operations
    DllCall("Kernel32.dll\QueryPerformanceCounter", "Ptr", start.Ptr, "Int")
    map := Map()
    Loop 1000
        map[A_Index] := A_Index * 2
    DllCall("Kernel32.dll\QueryPerformanceCounter", "Ptr", end.Ptr, "Int")

    test3Time := ((NumGet(end, 0, "Int64") - NumGet(start, 0, "Int64")) * 1000000) / freq

    MsgBox(Format("
    (
    Performance Benchmarks:

    String concat (1000x): {:.2f} µs
    Array push (1000x): {:.2f} µs
    Map set (1000x): {:.2f} µs
    )", test1Time, test2Time, test3Time), "Benchmark Results")

    ; Sleep precision test
    tests := []
    Loop 5 {
        DllCall("Kernel32.dll\QueryPerformanceCounter", "Ptr", start.Ptr, "Int")
        Sleep(10)
        DllCall("Kernel32.dll\QueryPerformanceCounter", "Ptr", end.Ptr, "Int")

        elapsed := ((NumGet(end, 0, "Int64") - NumGet(start, 0, "Int64")) * 1000) / freq
        tests.Push(elapsed)
    }

    avg := 0
    for time in tests
        avg += time
    avg /= tests.Length

    MsgBox(Format("Sleep(10) precision test:`n`nAverage: {:.2f} ms`n(Target: 10 ms)", avg), "Sleep Precision")
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
    (
    Time Operations DllCall Examples
    =================================

    1. System Time
    2. File Time Operations
    3. High-Resolution Performance Counter
    4. Time Zone Information
    5. Tick Count and Uptime
    6. Time Format Conversion
    7. Advanced Timing Operations

    Enter choice (1-7) or 0 to exit:
    )"

    Loop {
        choice := InputBox(menu, "Time Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_SystemTime()
            case "2": Example2_FileTime()
            case "3": Example3_PerformanceCounter()
            case "4": Example4_TimeZone()
            case "5": Example5_TickCount()
            case "6": Example6_TimeConversion()
            case "7": Example7_AdvancedTiming()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
