#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Socket Library Examples - thqby/ahk2_lib
 * 
 * TCP/UDP networking, client/server communication, async events
 * Library: https://github.com/thqby/ahk2_lib/blob/master/Socket.ahk
 */

/**
 * Example 1: Basic TCP Client
 */
BasicTCPClientExample() {
    MsgBox("Basic TCP Client`n`n"
        . "client := Socket()`n"
        . 'client.Connect("example.com", 80)`n'
        . 'client.Send("GET / HTTP/1.1\r\nHost: example.com\r\n\r\n")`n'
        . "response := client.Receive(4096)`n"
        . "client.Close()")
}

/**
 * Example 2: Basic TCP Server
 */
BasicTCPServerExample() {
    MsgBox("Basic TCP Server`n`n"
        . 'server := Socket()`n'
        . "server.Bind('0.0.0.0', 8080)`n"
        . "server.Listen(5)  ; Queue up to 5 connections`n`n"
        . "while (true) {`n"
        . "    client := server.Accept()`n"
        . "    data := client.Receive(4096)`n"
        . '    client.Send("HTTP/1.1 200 OK\r\n\r\nHello!")`n'
        . "    client.Close()`n"
        . "}")
}

/**
 * Example 3: Async TCP Client with Events
 */
AsyncTCPClientExample() {
    MsgBox("Async TCP Client with Events`n`n"
        . "client := Socket()`n"
        . "client.onConnect := (*) => MsgBox('Connected!')`n"
        . "client.onRead := (*) => {`n"
        . "    data := client.Receive(4096)`n"
        . "    MsgBox('Received: ' data)`n"
        . "}`n"
        . "client.onClose := (*) => MsgBox('Connection closed')`n`n"
        . 'client.AsyncSelect(0x27)  ; FD_READ | FD_WRITE | FD_CONNECT | FD_CLOSE`n'
        . 'client.Connect("example.com", 80)')
}

/**
 * Example 4: UDP Client/Server
 */
UDPExample() {
    MsgBox("UDP Client and Server`n`n"
        . "; Server`n"
        . "server := Socket('udp')`n"
        . "server.Bind('0.0.0.0', 9000)`n"
        . "data := server.ReceiveFrom(&addr, &port, 1024)`n"
        . "server.SendTo(addr, port, 'Response')`n`n"
        . "; Client`n"
        . "client := Socket('udp')`n"
        . "client.SendTo('127.0.0.1', 9000, 'Hello UDP')`n"
        . "response := client.ReceiveFrom(&addr, &port, 1024)")
}

/**
 * Example 5: Echo Server
 */
EchoServerExample() {
    MsgBox("Echo Server (Returns What It Receives)`n`n"
        . "class EchoServer {`n"
        . "    __New(port := 7777) {`n"
        . "        this.socket := Socket()`n"
        . "        this.socket.Bind('0.0.0.0', port)`n"
        . "        this.socket.Listen(10)`n"
        . "        this.clients := Map()`n"
        . "        this.socket.onAccept := (*) => this.OnAccept()`n"
        . "    }`n`n"
        . "    OnAccept() {`n"
        . "        client := this.socket.Accept()`n"
        . "        client.onRead := (*) => this.OnRead(client)`n"
        . "        client.onClose := (*) => this.OnClose(client)`n"
        . "        this.clients[client] := true`n"
        . "    }`n`n"
        . "    OnRead(client) {`n"
        . "        data := client.Receive(4096)`n"
        . "        client.Send(data)  ; Echo back`n"
        . "    }`n"
        . "}`n`n"
        . "server := EchoServer(7777)")
}

/**
 * Example 6: HTTP Client Class
 */
HTTPClientExample() {
    MsgBox("HTTP Client Class`n`n"
        . "class HTTPClient {`n"
        . "    static Get(host, port, path) {`n"
        . "        socket := Socket()`n"
        . "        socket.Connect(host, port)`n`n"
        . '        request := "GET " path " HTTP/1.1\r\n"`n'
        . '                 . "Host: " host "\r\n"`n'
        . '                 . "Connection: close\r\n\r\n"`n`n'
        . "        socket.Send(request)`n`n"
        . "        response := '`'`n"
        . "        while (data := socket.Receive(4096))`n"
        . "            response .= data`n`n"
        . "        socket.Close()`n"
        . "        return response`n"
        . "    }`n"
        . "}`n`n"
        . 'response := HTTPClient.Get("example.com", 80, "/")')
}

/**
 * Example 7: Multi-Client Chat Server
 */
ChatServerExample() {
    MsgBox("Multi-Client Chat Server`n`n"
        . "class ChatServer {`n"
        . "    clients := Map()`n`n"
        . "    __New(port := 8888) {`n"
        . "        this.server := Socket()`n"
        . "        this.server.Bind('0.0.0.0', port)`n"
        . "        this.server.Listen(20)`n"
        . "        this.server.onAccept := (*) => this.AcceptClient()`n"
        . "    }`n`n"
        . "    AcceptClient() {`n"
        . "        client := this.server.Accept()`n"
        . "        client.onRead := (*) => this.OnMessage(client)`n"
        . "        this.clients[client] := {name: 'User' this.clients.Count}`n"
        . "    }`n`n"
        . "    OnMessage(client) {`n"
        . "        msg := client.Receive(4096)`n"
        . "        ; Broadcast to all clients`n"
        . "        for c in this.clients`n"
        . "            c.Send(this.clients[client].name ': ' msg)`n"
        . "    }`n"
        . "}")
}

/**
 * Example 8: Connection Pool
 */
ConnectionPoolExample() {
    MsgBox("Connection Pool for Reusable Connections`n`n"
        . "class ConnectionPool {`n"
        . "    pool := []`n"
        . "    maxSize := 10`n`n"
        . "    GetConnection(host, port) {`n"
        . "        ; Try to reuse existing connection`n"
        . "        for conn in this.pool {`n"
        . "            if (conn.host = host && conn.port = port && conn.available) {`n"
        . "                conn.available := false`n"
        . "                return conn.socket`n"
        . "            }`n"
        . "        }`n`n"
        . "        ; Create new if pool not full`n"
        . "        if (this.pool.Length < this.maxSize) {`n"
        . "            socket := Socket()`n"
        . "            socket.Connect(host, port)`n"
        . "            conn := {socket: socket, host: host, port: port, available: false}`n"
        . "            this.pool.Push(conn)`n"
        . "            return socket`n"
        . "        }`n"
        . "        throw Error('Pool exhausted')`n"
        . "    }`n"
        . "}")
}

/**
 * Example 9: File Transfer Client
 */
FileTransferExample() {
    MsgBox("File Transfer Over Socket`n`n"
        . "SendFile(host, port, filePath) {`n"
        . "    socket := Socket()`n"
        . "    socket.Connect(host, port)`n`n"
        . "    ; Send file name`n"
        . "    fileName := FileGetAttrib(filePath).Name`n"
        . "    socket.Send(fileName '`n')`n`n"
        . "    ; Send file data`n"
        . "    file := FileOpen(filePath, 'r')`n"
        . "    while (!file.AtEOF) {`n"
        . "        chunk := file.RawRead(4096)`n"
        . "        socket.Send(chunk)`n"
        . "    }`n"
        . "    file.Close()`n"
        . "    socket.Close()`n"
        . "}`n`n"
        . 'SendFile("192.168.1.100", 9999, "document.pdf")')
}

/**
 * Example 10: Heartbeat/Keep-Alive
 */
HeartbeatExample() {
    MsgBox("Connection Heartbeat Pattern`n`n"
        . "class HeartbeatClient {`n"
        . "    socket := '`'`n"
        . "    interval := 30000  ; 30 seconds`n`n"
        . "    Connect(host, port) {`n"
        . "        this.socket := Socket()`n"
        . "        this.socket.Connect(host, port)`n"
        . "        this.StartHeartbeat()`n"
        . "    }`n`n"
        . "    StartHeartbeat() {`n"
        . "        SetTimer(() => this.SendPing(), this.interval)`n"
        . "    }`n`n"
        . "    SendPing() {`n"
        . "        try {`n"
        . "            this.socket.Send('PING')`n"
        . "        } catch {`n"
        . "            ; Reconnection logic`n"
        . "            this.Reconnect()`n"
        . "        }`n"
        . "    }`n"
        . "}")
}

/**
 * Example 11: SSL/TLS Socket
 */
SSLSocketExample() {
    MsgBox("SSL/TLS Secure Socket`n`n"
        . "; Note: SSL requires additional setup`n"
        . "client := Socket()`n"
        . "client.EnableSSL()  ; Enable SSL/TLS`n"
        . 'client.Connect("secure-server.com", 443)`n'
        . 'client.Send("Encrypted data")`n'
        . "response := client.Receive(4096)`n"
        . "client.Close()")
}

/**
 * Example 12: Non-Blocking Socket Operations
 */
NonBlockingExample() {
    MsgBox("Non-Blocking Socket Operations`n`n"
        . "socket := Socket()`n"
        . "socket.SetBlocking(false)  ; Non-blocking mode`n`n"
        . "try {`n"
        . '    socket.Connect("example.com", 80)`n'
        . "} catch Error as e {`n"
        . "    if (e.Number = 10035)  ; WSAEWOULDBLOCK`n"
        . "        MsgBox('Connection in progress')`n"
        . "}`n`n"
        . "; Use Select() to check when ready`n"
        . "if (socket.Select(1, 'write'))  ; 1 second timeout`n"
        . "    MsgBox('Socket ready for writing')")
}

/**
 * Example 13: Socket Options Configuration
 */
SocketOptionsExample() {
    MsgBox("Socket Options Configuration`n`n"
        . "socket := Socket()`n`n"
        . "; Enable TCP keepalive`n"
        . "socket.SetOption('SOL_SOCKET', 'SO_KEEPALIVE', 1)`n`n"
        . "; Set receive buffer size`n"
        . "socket.SetOption('SOL_SOCKET', 'SO_RCVBUF', 65536)`n`n"
        . "; Set send buffer size`n"
        . "socket.SetOption('SOL_SOCKET', 'SO_SNDBUF', 65536)`n`n"
        . "; Disable Nagle's algorithm for low latency`n"
        . "socket.SetOption('IPPROTO_TCP', 'TCP_NODELAY', 1)`n`n"
        . "; Allow address reuse`n"
        . "socket.SetOption('SOL_SOCKET', 'SO_REUSEADDR', 1)")
}

/**
 * Example 14: Proxy Client
 */
ProxyClientExample() {
    MsgBox("SOCKS/HTTP Proxy Client`n`n"
        . "class ProxyClient {`n"
        . "    ConnectViaProxy(proxyHost, proxyPort, targetHost, targetPort) {`n"
        . "        socket := Socket()`n"
        . "        socket.Connect(proxyHost, proxyPort)`n`n"
        . "        ; Send CONNECT request`n"
        . '        request := "CONNECT " targetHost ":" targetPort " HTTP/1.1\r\n"`n'
        . '                 . "Host: " targetHost "\r\n\r\n"`n`n'
        . "        socket.Send(request)`n"
        . "        response := socket.Receive(4096)`n`n"
        . "        if (InStr(response, '200 Connection established'))`n"
        . "            return socket  ; Connected through proxy`n"
        . "        else`n"
        . "            throw Error('Proxy connection failed')`n"
        . "    }`n"
        . "}")
}

/**
 * Example 15: Bandwidth Monitor
 */
BandwidthMonitorExample() {
    MsgBox("Bandwidth Monitor`n`n"
        . "class BandwidthMonitor {`n"
        . "    socket := '`'`n"
        . "    bytesReceived := 0`n"
        . "    bytesSent := 0`n"
        . "    startTime := 0`n`n"
        . "    __New(socket) {`n"
        . "        this.socket := socket`n"
        . "        this.startTime := A_TickCount`n"
        . "    }`n`n"
        . "    Send(data) {`n"
        . "        bytes := this.socket.Send(data)`n"
        . "        this.bytesSent += bytes`n"
        . "        return bytes`n"
        . "    }`n`n"
        . "    Receive(size) {`n"
        . "        data := this.socket.Receive(size)`n"
        . "        this.bytesReceived += StrLen(data)`n"
        . "        return data`n"
        . "    }`n`n"
        . "    GetStats() {`n"
        . "        elapsed := (A_TickCount - this.startTime) / 1000`n"
        . "        return {`n"
        . "            sent: this.bytesSent,`n"
        . "            received: this.bytesReceived,`n"
        . "            sendRate: Round(this.bytesSent / elapsed / 1024, 2),`n"
        . "            recvRate: Round(this.bytesReceived / elapsed / 1024, 2)`n"
        . "        }`n"
        . "    }`n"
        . "}")
}

MsgBox("Socket Library Examples Loaded`n`n"
    . "Note: These are conceptual examples.`n"
    . "To use, you need to include:`n"
    . "#Include <Socket>`n`n"
    . "Available Examples:`n"
    . "- BasicTCPClientExample()`n"
    . "- BasicTCPServerExample()`n"
    . "- AsyncTCPClientExample()`n"
    . "- EchoServerExample()`n"
    . "- ChatServerExample()`n"
    . "- ConnectionPoolExample()`n"
    . "- FileTransferExample()`n"
    . "- HeartbeatExample()")

; Uncomment to view examples:
; BasicTCPClientExample()
; BasicTCPServerExample()
; AsyncTCPClientExample()
; UDPExample()
; EchoServerExample()

