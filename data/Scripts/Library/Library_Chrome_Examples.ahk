#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Chrome DevTools Protocol Examples - thqby/ahk2_lib
 * 
 * Browser automation, tab management, JavaScript execution
 * Library: https://github.com/thqby/ahk2_lib/blob/master/Chrome.ahk
 */

/**
 * Example 1: Launch Chrome and Navigate
 */
LaunchAndNavigateExample() {
    MsgBox("Launch Chrome and Navigate`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n"
        . 'page.Navigate("https://www.example.com")`n'
        . "page.WaitForNavigation()`n"
        . 'MsgBox("Page loaded: " page.Title)')
}

/**
 * Example 2: Execute JavaScript
 */
ExecuteJavaScriptExample() {
    MsgBox("Execute JavaScript in Page`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n"
        . 'page.Navigate("https://www.example.com")`n'
        . "page.WaitForNavigation()`n`n"
        . "; Execute JavaScript and get result`n"
        . 'title := page.Evaluate("document.title")`n'
        . 'url := page.Evaluate("window.location.href")`n'
        . 'links := page.Evaluate("document.querySelectorAll(`\' a`\ ').length")`n`n'
        . 'MsgBox("Title: " title "`nURL: " url "`nLinks: " links)')
}

/**
 * Example 3: Fill and Submit Forms
 */
FillFormExample() {
    MsgBox("Fill and Submit Forms`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n"
        . 'page.Navigate("https://example.com/login")`n'
        . "page.WaitForNavigation()`n`n"
        . "; Fill input fields`n"
        . 'page.Evaluate("document.querySelector(`\'#username`\ ').value = `\' user123`\ '")`n'
        . 'page.Evaluate("document.querySelector(`\'#password`\ ').value = `\' pass123`\ '")`n`n'
        . "; Click submit button`n"
        . 'page.Evaluate("document.querySelector(`\' button[type = submit]`\ ').click()")`n'
        . "page.WaitForNavigation()")
}

/**
 * Example 4: Take Screenshots
 */
ScreenshotExample() {
    MsgBox("Take Page Screenshots`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n"
        . 'page.Navigate("https://www.example.com")`n'
        . "page.WaitForNavigation()`n`n"
        . "; Take full page screenshot`n"
        . 'page.Screenshot(A_ScriptDir "\\\\screenshot.png")`n`n'
        . "; Take screenshot of specific element`n"
        . 'selector := "#main-content"`n'
        . 'page.ScreenshotElement(selector, A_ScriptDir "\\\\element.png")')
}

/**
 * Example 5: Multiple Tabs Management
 */
MultipleTabsExample() {
    MsgBox("Manage Multiple Tabs`n`n"
        . "chrome := Chrome()`n`n"
        . "; Open multiple tabs`n"
        . "tab1 := chrome.NewPage()`n"
        . 'tab1.Navigate("https://google.com")`n`n'
        . "tab2 := chrome.NewPage()`n"
        . 'tab2.Navigate("https://github.com")`n`n'
        . "tab3 := chrome.NewPage()`n"
        . 'tab3.Navigate("https://stackoverflow.com")`n`n'
        . "; Switch between tabs`n"
        . "tab1.Activate()`n"
        . "Sleep(1000)`n"
        . "tab2.Activate()`n`n"
        . "; Get all pages`n"
        . "pages := chrome.GetPages()`n"
        . 'MsgBox("Open tabs: " pages.Length)')
}

/**
 * Example 6: Web Scraping
 */
WebScrapingExample() {
    MsgBox("Web Scraping Example`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n"
        . 'page.Navigate("https://news.ycombinator.com")`n'
        . "page.WaitForNavigation()`n`n"
        . "; Extract all article titles`n"
        . "titles := page.Evaluate(\"`n "
        . "    Array.from(document.querySelectorAll('.titleline > a'))`n"
        . "        .map(el => el.textContent)`n"
        . "\")`n`n "
        . "; Display titles`n"
        . "for title in titles`n"
        . "    MsgBox(title)")
}

/**
 * Example 7: Wait for Elements
 */
WaitForElementsExample() {
    MsgBox("Wait for Elements to Load`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n"
        . 'page.Navigate("https://example.com")`n`n'
        . "; Wait for specific element`n"
        . 'page.WaitForSelector("#content", {timeout: 5000})`n'
        . 'MsgBox("Element found!")`n`n'
        . "; Wait for element to disappear`n"
        . 'page.WaitForSelector(".loading-spinner", {hidden: true})`n'
        . 'MsgBox("Loading complete!")')
}

/**
 * Example 8: Handle Alerts and Dialogs
 */
HandleDialogsExample() {
    MsgBox("Handle JavaScript Alerts`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n`n"
        . "; Set up dialog handler before triggering`n"
        . "page.on('dialog', (dialog) => {`n"
        . "    MsgBox('Dialog message: ' dialog.message())`n"
        . "    dialog.accept()  ; Or dialog.dismiss()`n"
        . "})`n`n"
        . 'page.Navigate("https://example.com")`n'
        . "; Trigger alert`n"
        . 'page.Evaluate("alert(`\' Hello !`\ ')")')
}

/**
 * Example 9: Download Files
 */
DownloadFilesExample() {
    MsgBox("Download Files via Browser`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n`n"
        . "; Set download path`n"
        . 'downloadPath := A_ScriptDir "\\\\downloads"`n'
        . "page.SetDownloadBehavior({`n"
        . "    behavior: 'allow',`n"
        . "    downloadPath: downloadPath`n"
        . "})`n`n"
        . 'page.Navigate("https://example.com/file.pdf")`n'
        . "; Click download button`n"
        . 'page.Evaluate("document.querySelector(`\'.download - btn`\ ').click()")`n'
        . "Sleep(2000)  ; Wait for download`n"
        . 'MsgBox("File downloaded to: " downloadPath)')
}

/**
 * Example 10: Cookie Management
 */
CookieManagementExample() {
    MsgBox("Manage Browser Cookies`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n"
        . 'page.Navigate("https://example.com")`n`n'
        . "; Get all cookies`n"
        . "cookies := page.GetCookies()`n"
        . "for cookie in cookies`n"
        . "    MsgBox(cookie.name ': ' cookie.value)`n`n"
        . "; Set a cookie`n"
        . "page.SetCookie({`n"
        . "    name: 'session',`n"
        . "    value: 'abc123',`n"
        . "    domain: 'example.com',`n"
        . "    path: '/',`n"
        . "    expires: DateAdd(A_Now, 7, 'days')`n"
        . "})`n`n"
        . "; Delete cookies`n"
        . "page.DeleteCookies()")
}

/**
 * Example 11: Network Interception
 */
NetworkInterceptionExample() {
    MsgBox("Intercept Network Requests`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n`n"
        . "; Enable request interception`n"
        . "page.SetRequestInterception(true)`n`n"
        . "; Intercept and log requests`n"
        . "page.on('request', (request) => {`n"
        . "    url := request.url()`n"
        . "    method := request.method()`n"
        . "    MsgBox(method ' request to: ' url)`n`n"
        . "    ; Block specific resources`n"
        . "    if (InStr(url, '.css') || InStr(url, '.png'))`n"
        . "        request.abort()`n"
        . "    else`n"
        . "        request.continue()`n"
        . "})`n`n"
        . 'page.Navigate("https://example.com")')
}

/**
 * Example 12: Emulate Mobile Devices
 */
EmulateDeviceExample() {
    MsgBox("Emulate Mobile Devices`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n`n"
        . "; Emulate iPhone X`n"
        . "page.Emulate({`n"
        . "    viewport: {`n"
        . "        width: 375,`n"
        . "        height: 812,`n"
        . "        deviceScaleFactor: 3,`n"
        . "        isMobile: true,`n"
        . "        hasTouch: true`n"
        . "    },`n"
        . "    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X)'`n"
        . "})`n`n"
        . 'page.Navigate("https://example.com")`n'
        . 'MsgBox("Viewing as iPhone X")')
}

/**
 * Example 13: Automated Testing
 */
AutomatedTestingExample() {
    MsgBox("Automated UI Testing`n`n"
        . "class WebsiteTest {`n"
        . "    chrome := '`'`n"
        . "    page := '`'`n`n"
        . "    Setup() {`n"
        . "        this.chrome := Chrome()`n"
        . "        this.page := this.chrome.NewPage()`n"
        . "    }`n`n"
        . "    TestLogin() {`n"
        . '        this.page.Navigate("https://example.com/login")`n'
        . "        this.page.WaitForNavigation()`n`n"
        . "        ; Fill credentials`n"
        . '        this.page.Type("#username", "testuser")`n'
        . '        this.page.Type("#password", "testpass")`n'
        . '        this.page.Click("button[type=submit]")`n'
        . "        this.page.WaitForNavigation()`n`n"
        . "        ; Verify login success`n"
        . '        if (this.page.QuerySelector(".dashboard"))`n'
        . '            MsgBox("Login test PASSED")`n'
        . "        else`n"
        . '            MsgBox("Login test FAILED")`n'
        . "    }`n`n"
        . "    Teardown() {`n"
        . "        this.page.Close()`n"
        . "        this.chrome.Close()`n"
        . "    }`n"
        . "}")
}

/**
 * Example 14: PDF Generation
 */
PDFGenerationExample() {
    MsgBox("Generate PDF from Web Page`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n"
        . 'page.Navigate("https://example.com/report")`n'
        . "page.WaitForNavigation()`n`n"
        . "; Generate PDF`n"
        . 'pdfPath := A_ScriptDir "\\\\report.pdf"`n'
        . "page.PDF({`n"
        . "    path: pdfPath,`n"
        . "    format: 'A4',`n"
        . "    printBackground: true,`n"
        . "    margin: {top: '1cm', right: '1cm', bottom: '1cm', left: '1cm'}`n"
        . "})`n`n"
        . 'MsgBox("PDF saved to: " pdfPath)')
}

/**
 * Example 15: Performance Monitoring
 */
PerformanceMonitoringExample() {
    MsgBox("Monitor Page Performance`n`n"
        . "chrome := Chrome()`n"
        . "page := chrome.NewPage()`n`n"
        . "; Enable performance monitoring`n"
        . "page.EnablePerformance()`n`n"
        . 'startTime := A_TickCount`n'
        . 'page.Navigate("https://example.com")`n'
        . "page.WaitForNavigation()`n"
        . 'loadTime := A_TickCount - startTime`n`n'
        . "; Get performance metrics`n"
        . "metrics := page.Evaluate(\"`n "
        . "    performance.getEntriesByType('navigation')[0]`n"
        . "\")`n`n "
        . 'MsgBox("Load time: " loadTime "ms`n"`n'
        . "    . \" DOM load: \ " metrics.domContentLoadedEventEnd \" ms`n\ "`n"
        . "    . \" First paint: \ " metrics.firstPaint \" ms\ ")')
}

MsgBox("Chrome DevTools Protocol Examples Loaded`n`n"
    . "Note: These are conceptual examples.`n"
    . "To use, you need to include:`n"
    . "#Include <Chrome>`n`n"
    . "Available Examples:`n"
    . "- LaunchAndNavigateExample()`n"
    . "- ExecuteJavaScriptExample()`n"
    . "- FillFormExample()`n"
    . "- ScreenshotExample()`n"
    . "- MultipleTabsExample()`n"
    . "- WebScrapingExample()`n"
    . "- AutomatedTestingExample()`n"
    . "- PDFGenerationExample()")

; Uncomment to view examples:
; LaunchAndNavigateExample()
; ExecuteJavaScriptExample()
; FillFormExample()
; ScreenshotExample()
; MultipleTabsExample()

