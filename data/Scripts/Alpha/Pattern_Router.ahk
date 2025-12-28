#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Router - URL routing and path matching
; Demonstrates REST-style routing patterns

class Router {
    __New() {
        this.routes := []
        this.middleware := []
        this.notFoundHandler := ""
    }

    ; Add middleware
    Use(handler) {
        this.middleware.Push(handler)
        return this
    }

    ; Register routes
    Get(path, handler) => this.AddRoute("GET", path, handler)
    Post(path, handler) => this.AddRoute("POST", path, handler)
    Put(path, handler) => this.AddRoute("PUT", path, handler)
    Delete(path, handler) => this.AddRoute("DELETE", path, handler)
    Patch(path, handler) => this.AddRoute("PATCH", path, handler)

    AddRoute(method, path, handler) {
        this.routes.Push(Map(
            "method", method,
            "path", path,
            "pattern", this._pathToRegex(path),
            "params", this._extractParamNames(path),
            "handler", handler
        ))
        return this
    }

    _pathToRegex(path) {
        ; Convert :param to capture groups
        pattern := RegExReplace(path, ":([a-zA-Z_][a-zA-Z0-9_]*)", "([^/]+)")
        ; Convert * wildcard
        pattern := StrReplace(pattern, "*", ".*")
        return "^" pattern "$"
    }

    _extractParamNames(path) {
        params := []
        pos := 1
        while pos := RegExMatch(path, ":([a-zA-Z_][a-zA-Z0-9_]*)", &m, pos) {
            params.Push(m[1])
            pos += StrLen(m[0])
        }
        return params
    }

    Match(method, path) {
        for route in this.routes {
            if route["method"] != method && route["method"] != "*"
                continue

            if RegExMatch(path, route["pattern"], &matches) {
                params := Map()
                for i, paramName in route["params"] {
                    if i + 1 <= matches.Count
                        params[paramName] := matches[i + 1]
                }

                return Map(
                    "route", route,
                    "params", params,
                    "handler", route["handler"]
                )
            }
        }
        return ""
    }

    Handle(method, path, context := "") {
        if !context
            context := Map()

        context["method"] := method
        context["path"] := path

        ; Run middleware
        for mw in this.middleware {
            result := mw(context)
            if result = false  ; Middleware can halt chain
                return ""
        }

        ; Find matching route
        match := this.Match(method, path)
        if match {
            context["params"] := match["params"]
            return match["handler"](context)
        }

        ; Not found
        if this.notFoundHandler
            return this.notFoundHandler(context)

        return Map("status", 404, "message", "Not Found")
    }

    NotFound(handler) {
        this.notFoundHandler := handler
        return this
    }
}

; Request/Response helpers
class Request {
    __New(method, path, body := "", headers := "") {
        this.method := method
        this.path := path
        this.body := body ?? Map()
        this.headers := headers ?? Map()
        this.query := this._parseQuery(path)
    }

    _parseQuery(path) {
        query := Map()
        if InStr(path, "?") {
            queryStr := SubStr(path, InStr(path, "?") + 1)
            for pair in StrSplit(queryStr, "&") {
                parts := StrSplit(pair, "=", , 2)
                if parts.Length >= 2
                    query[parts[1]] := parts[2]
            }
        }
        return query
    }
}

; Demo
appRouter := Router()

; Add middleware
appRouter.Use((ctx) {
    OutputDebug("[Middleware] " ctx["method"] " " ctx["path"] "`n")
    return true  ; Continue
})

; Define routes
appRouter.Get("/", (ctx) => Map("message", "Welcome to API"))

appRouter.Get("/users", (ctx) => Map(
    "users", [
        Map("id", 1, "name", "Alice"),
        Map("id", 2, "name", "Bob")
    ]
))

appRouter.Get("/users/:id", (ctx) => Map(
    "user", Map("id", ctx["params"]["id"], "name", "User " ctx["params"]["id"])
))

appRouter.Post("/users", (ctx) => Map(
    "message", "User created",
    "id", Random(1000, 9999)
))

appRouter.Get("/posts/:postId/comments/:commentId", (ctx) => Map(
    "postId", ctx["params"]["postId"],
    "commentId", ctx["params"]["commentId"]
))

appRouter.NotFound((ctx) => Map(
    "status", 404,
    "message", "Route not found: " ctx["path"]
))

; Test routes
tests := [
    ["GET", "/"],
    ["GET", "/users"],
    ["GET", "/users/42"],
    ["POST", "/users"],
    ["GET", "/posts/10/comments/5"],
    ["GET", "/nonexistent"]
]

result := "Router Demo:`n`n"

for test in tests {
    response := appRouter.Handle(test[1], test[2])
    result .= test[1] " " test[2] "`n"

    for key, value in response {
        if IsObject(value)
            result .= "  " key ": [object]`n"
        else
            result .= "  " key ": " value "`n"
    }
    result .= "`n"
}

MsgBox(result)
