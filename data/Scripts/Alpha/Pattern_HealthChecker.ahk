#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Health Checker - Service health monitoring
; Demonstrates health check patterns for microservices

class HealthChecker {
    __New() {
        this.checks := Map()
        this.results := Map()
    }

    Register(name, checkFn, options := "") {
        this.checks[name] := Map(
            "fn", checkFn,
            "critical", options.Has("critical") ? options["critical"] : true,
            "timeout", options.Has("timeout") ? options["timeout"] : 5000,
            "interval", options.Has("interval") ? options["interval"] : 30000
        )
        return this
    }

    Unregister(name) {
        this.checks.Delete(name)
        this.results.Delete(name)
        return this
    }

    Check(name := "") {
        if name
            return this._runCheck(name)

        ; Run all checks
        overall := Map(
            "status", "healthy",
            "timestamp", FormatTime(, "yyyy-MM-dd HH:mm:ss"),
            "checks", Map()
        )

        for checkName, _ in this.checks {
            result := this._runCheck(checkName)
            overall["checks"][checkName] := result

            if result["status"] = "unhealthy" && this.checks[checkName]["critical"]
                overall["status"] := "unhealthy"
            else if result["status"] = "degraded" && overall["status"] = "healthy"
                overall["status"] := "degraded"
        }

        return overall
    }

    _runCheck(name) {
        if !this.checks.Has(name)
            return Map("status", "unknown", "message", "Check not found")

        check := this.checks[name]
        startTime := A_TickCount

        try {
            result := check["fn"]()
            elapsed := A_TickCount - startTime

            if !IsObject(result)
                result := Map("status", result ? "healthy" : "unhealthy")

            result["duration_ms"] := elapsed
            result["timestamp"] := FormatTime(, "yyyy-MM-dd HH:mm:ss")

            this.results[name] := result
            return result
        } catch Error as e {
            return Map(
                "status", "unhealthy",
                "message", e.Message,
                "timestamp", FormatTime(, "yyyy-MM-dd HH:mm:ss"),
                "duration_ms", A_TickCount - startTime
            )
        }
    }

    IsHealthy() {
        result := this.Check()
        return result["status"] = "healthy"
    }

    GetLast(name) => this.results.Has(name) ? this.results[name] : ""
}

; Liveness and Readiness Probes (Kubernetes-style)
class Probes {
    __New() {
        this.liveness := HealthChecker()
        this.readiness := HealthChecker()
        this.startup := HealthChecker()
    }

    ; App is running and not deadlocked
    RegisterLiveness(name, checkFn) {
        this.liveness.Register(name, checkFn)
        return this
    }

    ; App can accept traffic
    RegisterReadiness(name, checkFn) {
        this.readiness.Register(name, checkFn)
        return this
    }

    ; App has finished initialization
    RegisterStartup(name, checkFn) {
        this.startup.Register(name, checkFn)
        return this
    }

    Live() => this.liveness.Check()
    Ready() => this.readiness.Check()
    Started() => this.startup.Check()
}

; Demo - Health checker
checker := HealthChecker()

; Register checks
checker.Register("database", () {
    ; Simulate DB check
    Sleep(50)
    return Map("status", "healthy", "connections", 5, "maxConnections", 20)
}, Map("critical", true))

checker.Register("cache", () {
    Sleep(30)
    return Map("status", "healthy", "hitRate", 0.85)
}, Map("critical", false))

checker.Register("external_api", () {
    Sleep(100)
    ; Simulate degraded service
    return Map("status", "degraded", "latency_ms", 500, "message", "High latency")
}, Map("critical", false))

; Run health check
result := checker.Check()

output := "Health Check Results:`n"
output .= "========================`n"
output .= "Overall Status: " result["status"] "`n"
output .= "Timestamp: " result["timestamp"] "`n`n"

for checkName, checkResult in result["checks"] {
    output .= checkName ":`n"
    output .= "  Status: " checkResult["status"] "`n"
    output .= "  Duration: " checkResult["duration_ms"] "ms`n"

    for key, value in checkResult {
        if key != "status" && key != "duration_ms" && key != "timestamp"
            output .= "  " key ": " value "`n"
    }
    output .= "`n"
}

MsgBox(output)

; Demo - Probes
myProbes := Probes()

myProbes.RegisterLiveness("process", () => Map("status", "healthy", "uptime_s", 12345))
myProbes.RegisterReadiness("dependencies", () => Map("status", "healthy"))
myProbes.RegisterStartup("init", () => Map("status", "healthy", "phase", "complete"))

output := "Kubernetes-style Probes:`n`n"
output .= "Liveness: " myProbes.Live()["status"] "`n"
output .= "Readiness: " myProbes.Ready()["status"] "`n"
output .= "Startup: " myProbes.Started()["status"]

MsgBox(output)
