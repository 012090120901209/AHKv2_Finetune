#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WebSocket Library Examples - thqby/ahk2_lib
 * 
 * Real-time bidirectional communication, ws:// and wss:// protocols
 * Library: https://github.com/thqby/ahk2_lib/blob/master/WebSocket.ahk
 */

/**
 * Example 1: Basic WebSocket Connection
 */
BasicWebSocketExample() {
    MsgBox("Basic WebSocket Connection`n`n"
        . "; Connect to WebSocket server`n"
        . 'ws := WebSocket("ws://echo.websocket.org")`n'
        . "ws.onOpen := (*) => MsgBox('Connected!')`n"
        . "ws.onMessage := (msg) => MsgBox('Received: ' msg)`n"
        . 'ws.sendText("Hello WebSocket!")')
}

/**
 * Example 2: Secure WebSocket (wss://)
 */
SecureWebSocketExample() {
    MsgBox("Secure WebSocket Connection (wss://)`n`n"
        . "; Connect to secure WebSocket server`n"
        . 'ws := WebSocket("wss://secure-server.com/ws")`n`n'
        . "ws.onOpen := (*) => {`n"
        . '    MsgBox("Secure connection established")`n'
        . '    ws.sendText("Encrypted message")`n'
        . "}`n`n"
        . "ws.onMessage := (msg) => {`n"
        . "    MsgBox('Secure response: ' msg)`n"
        . "}")
}

/**
 * Example 3: WebSocket with Custom Headers
 */
CustomHeadersExample() {
    MsgBox("WebSocket with Custom Headers`n`n"
        . "headers := Map()`n"
        . 'headers["Authorization"] := "Bearer YOUR_TOKEN"`n'
        . 'headers["User-Agent"] := "AHK-WebSocket/1.0"`n`n'
        . 'ws := WebSocket("ws://api.example.com/ws", {`n'
        . "    headers: headers,`n"
        . "    timeout: 5000`n"
        . "})`n`n"
        . "ws.onOpen := (*) => MsgBox('Connected with auth')")
}

/**
 * Example 4: Event-Driven WebSocket
 */
EventDrivenExample() {
    MsgBox("Complete Event Handling`n`n"
        . 'ws := WebSocket("ws://example.com/ws")`n`n'
        . "ws.onOpen := (*) => {`n"
        . "    MsgBox('Connection opened')`n"
        . "}`n`n"
        . "ws.onMessage := (msg) => {`n"
        . "    MsgBox('Text message: ' msg)`n"
        . "}`n`n"
        . "ws.onData := (data, size) => {`n"
        . "    MsgBox('Binary data: ' size ' bytes')`n"
        . "}`n`n"
        . "ws.onClose := (status, reason) => {`n"
        . "    MsgBox('Closed: ' reason ' (Status: ' status ')')`n"
        . "}`n`n"
        . "ws.onError := (err, what) => {`n"
        . "    MsgBox('Error: ' err ' - ' what)`n"
        . "}")
}

/**
 * Example 5: Chat Client
 */
ChatClientExample() {
    MsgBox("WebSocket Chat Client`n`n"
        . "class ChatClient {`n"
        . "    ws := '`'`n"
        . "    username := '`'`n`n"
        . "    __New(username, serverUrl) {`n"
        . "        this.username := username`n"
        . "        this.ws := WebSocket(serverUrl)`n"
        . "        this.ws.onOpen := (*) => this.OnConnect()`n"
        . "        this.ws.onMessage := (msg) => this.OnMessage(msg)`n"
        . "        this.ws.onClose := (*) => this.OnDisconnect()`n"
        . "    }`n`n"
        . "    OnConnect() {`n"
        . "        this.SendMessage('joined the chat')`n"
        . "    }`n`n"
        . "    SendMessage(text) {`n"
        . "        msg := this.username ': ' text`n"
        . "        this.ws.sendText(msg)`n"
        . "    }`n`n"
        . "    OnMessage(msg) {`n"
        . "        ToolTip(msg)`n"
        . "    }`n`n"
        . "    OnDisconnect() {`n"
        . "        MsgBox('Disconnected from chat')`n"
        . "    }`n"
        . "}`n`n"
        . 'client := ChatClient("Alice", "ws://chat.example.com")')
}

/**
 * Example 6: Binary Data Transfer
 */
BinaryDataExample() {
    MsgBox("Send and Receive Binary Data`n`n"
        . 'ws := WebSocket("ws://binary.example.com")`n`n'
        . "ws.onOpen := (*) => {`n"
        . "    ; Create binary buffer`n"
        . "    buffer := Buffer(256)`n"
        . "    loop 256`n"
        . "        NumPut('UChar', A_Index - 1, buffer, A_Index - 1)`n`n"
        . "    ; Send binary data`n"
        . "    ws.send(buffer)`n"
        . "}`n`n"
        . "ws.onData := (data, size) => {`n"
        . "    MsgBox('Received ' size ' bytes of binary data')`n"
        . "    ; Process binary data`n"
        . "    value := NumGet(data, 0, 'UChar')`n"
        . "    MsgBox('First byte: ' value)`n"
        . "}")
}

/**
 * Example 7: Reconnection Logic
 */
ReconnectionExample() {
    MsgBox("Auto-Reconnection Pattern`n`n"
        . "class ResilientWebSocket {`n"
        . "    ws := '`'`n"
        . "    url := '`'`n"
        . "    reconnectDelay := 5000`n"
        . "    maxRetries := 5`n"
        . "    retryCount := 0`n`n"
        . "    __New(url) {`n"
        . "        this.url := url`n"
        . "        this.Connect()`n"
        . "    }`n`n"
        . "    Connect() {`n"
        . "        try {`n"
        . "            this.ws := WebSocket(this.url)`n"
        . "            this.ws.onOpen := (*) => this.OnOpen()`n"
        . "            this.ws.onClose := (*) => this.OnClose()`n"
        . "            this.ws.onError := (err, what) => this.OnError(err, what)`n"
        . "        } catch Error as e {`n"
        . "            this.ScheduleReconnect()`n"
        . "        }`n"
        . "    }`n`n"
        . "    OnOpen() {`n"
        . "        this.retryCount := 0`n"
        . "        MsgBox('Connected successfully')`n"
        . "    }`n`n"
        . "    OnClose() {`n"
        . "        MsgBox('Connection closed, attempting reconnect...')`n"
        . "        this.ScheduleReconnect()`n"
        . "    }`n`n"
        . "    OnError(err, what) {`n"
        . "        MsgBox('Error occurred: ' err)`n"
        . "        this.ScheduleReconnect()`n"
        . "    }`n`n"
        . "    ScheduleReconnect() {`n"
        . "        if (this.retryCount < this.maxRetries) {`n"
        . "            this.retryCount++`n"
        . "            SetTimer(() => this.Connect(), -this.reconnectDelay)`n"
        . "        } else {`n"
        . "            MsgBox('Max reconnection attempts reached')`n"
        . "        }`n"
        . "    }`n"
        . "}")
}

/**
 * Example 8: JSON Message Protocol
 */
JSONProtocolExample() {
    MsgBox("WebSocket with JSON Protocol`n`n"
        . "class JSONWebSocket {`n"
        . "    ws := '`'`n`n"
        . "    __New(url) {`n"
        . "        this.ws := WebSocket(url)`n"
        . "        this.ws.onMessage := (msg) => this.HandleMessage(msg)`n"
        . "    }`n`n"
        . "    Send(type, data) {`n"
        . "        message := Map()`n"
        . "        message['type'] := type`n"
        . "        message['data'] := data`n"
        . "        message['timestamp'] := A_Now`n"
        . "        json := JSON.stringify(message)`n"
        . "        this.ws.sendText(json)`n"
        . "    }`n`n"
        . "    HandleMessage(msg) {`n"
        . "        try {`n"
        . "            data := JSON.parse(msg)`n"
        . "            this.ProcessMessage(data['type'], data['data'])`n"
        . "        } catch Error as e {`n"
        . "            MsgBox('Invalid JSON message')`n"
        . "        }`n"
        . "    }`n`n"
        . "    ProcessMessage(type, data) {`n"
        . "        switch type {`n"
        . "            case 'chat':`n"
        . "                MsgBox('Chat: ' data)`n"
        . "            case 'notification':`n"
        . "                ToolTip(data)`n"
        . "            case 'command':`n"
        . "                this.ExecuteCommand(data)`n"
        . "        }`n"
        . "    }`n"
        . "}")
}

/**
 * Example 9: Real-Time Data Stream
 */
RealTimeStreamExample() {
    MsgBox("Real-Time Data Streaming`n`n"
        . "class DataStreamClient {`n"
        . "    ws := '`'`n"
        . "    dataPoints := []`n"
        . "    gui := '`'`n"
        . "    listView := '`'`n`n"
        . "    __New(streamUrl) {`n"
        . "        ; Setup GUI`n"
        . "        this.gui := Gui(, 'Live Data Stream')`n"
        . "        this.listView := this.gui.Add('ListView', 'w400 h300', ['Time', 'Value'])`n"
        . "        this.gui.Show()`n`n"
        . "        ; Connect to stream`n"
        . "        this.ws := WebSocket(streamUrl)`n"
        . "        this.ws.onMessage := (msg) => this.AddDataPoint(msg)`n"
        . "    }`n`n"
        . "    AddDataPoint(data) {`n"
        . "        timestamp := FormatTime(A_Now, 'HH:mm:ss')`n"
        . "        this.listView.Add('', timestamp, data)`n"
        . "        this.dataPoints.Push({time: timestamp, value: data})`n`n"
        . "        ; Keep only last 100 points`n"
        . "        if (this.dataPoints.Length > 100)`n"
        . "            this.dataPoints.RemoveAt(1)`n"
        . "    }`n"
        . "}")
}

/**
 * Example 10: Synchronous WebSocket
 */
SynchronousWebSocketExample() {
    MsgBox("Synchronous WebSocket Operations`n`n"
        . "; Create synchronous WebSocket (async: false)`n"
        . 'ws := WebSocket("ws://example.com", {async: false})`n`n'
        . "; Send message`n"
        . 'ws.sendText("Hello")`n`n'
        . "; Receive response (blocks until message arrives)`n"
        . "response := ws.receive()`n"
        . "MsgBox('Received: ' response)`n`n"
        . "; Close connection`n"
        . "ws.shutdown()")
}

/**
 * Example 11: WebSocket Request-Response Pattern
 */
RequestResponseExample() {
    MsgBox("Request-Response Pattern`n`n"
        . "class WebSocketRPC {`n"
        . "    ws := '`'`n"
        . "    pendingRequests := Map()`n"
        . "    requestId := 0`n`n"
        . "    __New(url) {`n"
        . "        this.ws := WebSocket(url)`n"
        . "        this.ws.onMessage := (msg) => this.HandleResponse(msg)`n"
        . "    }`n`n"
        . "    Call(method, params, callback) {`n"
        . "        id := ++this.requestId`n"
        . "        request := Map()`n"
        . "        request['id'] := id`n"
        . "        request['method'] := method`n"
        . "        request['params'] := params`n`n"
        . "        this.pendingRequests[id] := callback`n"
        . "        this.ws.sendText(JSON.stringify(request))`n"
        . "    }`n`n"
        . "    HandleResponse(msg) {`n"
        . "        response := JSON.parse(msg)`n"
        . "        id := response['id']`n"
        . "        if (this.pendingRequests.Has(id)) {`n"
        . "            callback := this.pendingRequests[id]`n"
        . "            callback(response['result'])`n"
        . "            this.pendingRequests.Delete(id)`n"
        . "        }`n"
        . "    }`n"
        . "}`n`n"
        . 'rpc := WebSocketRPC("ws://api.example.com")`n'
        . "rpc.Call('getUser', {id: 123}, (result) => MsgBox(result))")
}

/**
 * Example 12: Heartbeat/Keep-Alive
 */
HeartbeatExample() {
    MsgBox("WebSocket Heartbeat Pattern`n`n"
        . "class HeartbeatWebSocket {`n"
        . "    ws := '`'`n"
        . "    heartbeatInterval := 30000  ; 30 seconds`n"
        . "    timer := 0`n`n"
        . "    __New(url) {`n"
        . "        this.ws := WebSocket(url)`n"
        . "        this.ws.onOpen := (*) => this.StartHeartbeat()`n"
        . "        this.ws.onClose := (*) => this.StopHeartbeat()`n"
        . "        this.ws.onMessage := (msg) => this.HandleMessage(msg)`n"
        . "    }`n`n"
        . "    StartHeartbeat() {`n"
        . "        this.timer := SetTimer(() => this.SendHeartbeat(), this.heartbeatInterval)`n"
        . "    }`n`n"
        . "    StopHeartbeat() {`n"
        . "        if (this.timer)`n"
        . "            SetTimer(this.timer, 0)`n"
        . "    }`n`n"
        . "    SendHeartbeat() {`n"
        . "        try {`n"
        . "            this.ws.sendText('ping')`n"
        . "        } catch {`n"
        . "            ; Connection lost, handle reconnection`n"
        . "            this.StopHeartbeat()`n"
        . "        }`n"
        . "    }`n`n"
        . "    HandleMessage(msg) {`n"
        . "        if (msg = 'pong')`n"
        . "            return  ; Heartbeat response`n"
        . "        ; Handle other messages`n"
        . "        MsgBox('Message: ' msg)`n"
        . "    }`n"
        . "}")
}

/**
 * Example 13: Broadcast to Multiple Connections
 */
BroadcastExample() {
    MsgBox("Manage Multiple WebSocket Connections`n`n"
        . "class WebSocketManager {`n"
        . "    connections := []`n`n"
        . "    AddConnection(url) {`n"
        . "        ws := WebSocket(url)`n"
        . "        ws.onOpen := (*) => MsgBox('Connected: ' url)`n"
        . "        this.connections.Push(ws)`n"
        . "        return ws`n"
        . "    }`n`n"
        . "    Broadcast(message) {`n"
        . "        for ws in this.connections {`n"
        . "            try {`n"
        . "                ws.sendText(message)`n"
        . "            } catch {`n"
        . "                ; Connection failed, remove it`n"
        . "                this.RemoveConnection(ws)`n"
        . "            }`n"
        . "        }`n"
        . "    }`n`n"
        . "    RemoveConnection(ws) {`n"
        . "        for index, connection in this.connections {`n"
        . "            if (connection = ws) {`n"
        . "                this.connections.RemoveAt(index)`n"
        . "                break`n"
        . "            }`n"
        . "        }`n"
        . "    }`n`n"
        . "    CloseAll() {`n"
        . "        for ws in this.connections`n"
        . "            ws.shutdown()`n"
        . "        this.connections := []`n"
        . "    }`n"
        . "}")
}

/**
 * Example 14: Message Queue
 */
MessageQueueExample() {
    MsgBox("WebSocket Message Queue`n`n"
        . "class QueuedWebSocket {`n"
        . "    ws := '`'`n"
        . "    queue := []`n"
        . "    connected := false`n`n"
        . "    __New(url) {`n"
        . "        this.ws := WebSocket(url)`n"
        . "        this.ws.onOpen := (*) => this.OnConnect()`n"
        . "        this.ws.onClose := (*) => this.connected := false`n"
        . "    }`n`n"
        . "    OnConnect() {`n"
        . "        this.connected := true`n"
        . "        this.FlushQueue()`n"
        . "    }`n`n"
        . "    Send(message) {`n"
        . "        if (this.connected) {`n"
        . "            this.ws.sendText(message)`n"
        . "        } else {`n"
        . "            this.queue.Push(message)`n"
        . "        }`n"
        . "    }`n`n"
        . "    FlushQueue() {`n"
        . "        while (this.queue.Length > 0) {`n"
        . "            message := this.queue.RemoveAt(1)`n"
        . "            this.ws.sendText(message)`n"
        . "        }`n"
        . "    }`n"
        . "}")
}

/**
 * Example 15: Performance Monitoring
 */
PerformanceMonitoringExample() {
    MsgBox("WebSocket Performance Monitoring`n`n"
        . "class MonitoredWebSocket {`n"
        . "    ws := '`'`n"
        . "    messagesSent := 0`n"
        . "    messagesReceived := 0`n"
        . "    bytesSent := 0`n"
        . "    bytesReceived := 0`n"
        . "    startTime := 0`n`n"
        . "    __New(url) {`n"
        . "        this.ws := WebSocket(url)`n"
        . "        this.startTime := A_TickCount`n"
        . "        this.ws.onOpen := (*) => this.OnOpen()`n"
        . "        this.ws.onMessage := (msg) => this.OnMessage(msg)`n"
        . "    }`n`n"
        . "    OnOpen() {`n"
        . "        this.startTime := A_TickCount`n"
        . "    }`n`n"
        . "    Send(message) {`n"
        . "        this.ws.sendText(message)`n"
        . "        this.messagesSent++`n"
        . "        this.bytesSent += StrLen(message)`n"
        . "    }`n`n"
        . "    OnMessage(msg) {`n"
        . "        this.messagesReceived++`n"
        . "        this.bytesReceived += StrLen(msg)`n"
        . "    }`n`n"
        . "    GetStats() {`n"
        . "        elapsed := (A_TickCount - this.startTime) / 1000`n"
        . "        return {`n"
        . "            sent: this.messagesSent,`n"
        . "            received: this.messagesReceived,`n"
        . "            bytesSent: this.bytesSent,`n"
        . "            bytesReceived: this.bytesReceived,`n"
        . "            sendRate: Round(this.messagesSent / elapsed, 2),`n"
        . "            recvRate: Round(this.messagesReceived / elapsed, 2)`n"
        . "        }`n"
        . "    }`n"
        . "}")
}

MsgBox("WebSocket Library Examples Loaded`n`n"
    . "Note: These are conceptual examples.`n"
    . "To use, you need to include:`n"
    . "#Include <WebSocket>`n`n"
    . "Available Examples:`n"
    . "- BasicWebSocketExample()`n"
    . "- SecureWebSocketExample()`n"
    . "- ChatClientExample()`n"
    . "- JSONProtocolExample()`n"
    . "- RealTimeStreamExample()`n"
    . "- RequestResponseExample()`n"
    . "- HeartbeatExample()`n"
    . "- MessageQueueExample()")

; Uncomment to view examples:
; BasicWebSocketExample()
; SecureWebSocketExample()
; EventDrivenExample()
; ChatClientExample()
; BinaryDataExample()

