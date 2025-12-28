#Requires AutoHotkey v2.0

class JSON {
    /**
     * Parses a JSON string into an AutoHotkey object (Map or Array)
     * @param str The JSON string to parse
     * @returns {Map|Array}
     */
    static Parse(str) {
        html := ComObject("htmlfile")
        html.write("<meta http-equiv='X-UA-Compatible' content='IE=9'>")
        JS := html.parentWindow
        try {
            jsonObj := JS.JSON.parse(str)
            return this._ConvertJStoAHK(jsonObj)
        } catch as e {
            throw Error("Invalid JSON: " e.message, -1)
        }
    }

    /**
     * Converts an AutoHotkey object into a JSON string
     * @param obj The object to stringify
     * @param indent (Optional) The indentation string or number of spaces
     * @returns {String}
     */
    static Stringify(obj, indent := "") {
        if IsInteger(indent) {
            if (indent > 0)
                indent := Format("{:" indent "}", "")
            else
                indent := ""
        }

        return this._StringifyValue(obj, indent, "")
    }

    static _StringifyValue(val, indent, prefix) {
        if IsObject(val) {
            if val is Array {
                if (val.Length = 0)
                    return "[]"

                res := "["
                isMultiLine := (indent != "")

                for i, v in val {
                    res .= (isMultiLine ? "`n" prefix indent : "")
                        . this._StringifyValue(v, indent, prefix indent)
                        . (i < val.Length ? "," : "")
                }

                return res . (isMultiLine ? "`n" prefix : "") . "]"
            } else if val is Map {
                if (val.Count = 0)
                    return "{}"

                res := "{"
                isMultiLine := (indent != "")
                keys := []
                for k in val
                    keys.Push(k)

                for i, k in keys {
                    res .= (isMultiLine ? "`n" prefix indent : "")
                        . this._StringifyValue(k, indent, prefix indent)
                        . ": " . this._StringifyValue(val[k], indent, prefix indent)
                        . (i < keys.Length ? "," : "")
                }

                return res . (isMultiLine ? "`n" prefix : "") . "}"
            } else {
                ; Handle other objects as empty objects or try to stringify properties if needed
                ; For now, treat as empty object or generic object
                return "{}"
            }
        } else if IsNumber(val) {
            return String(val)
        } else {
            ; String handling with escaping
            val := StrReplace(val, "\", "\\")
            val := StrReplace(val, "`n", "\n")
            val := StrReplace(val, "`r", "\r")
            val := StrReplace(val, "`t", "\t")
            val := StrReplace(val, '"', '\"')
            return '"' val '"'
        }
    }

    static _ConvertJStoAHK(jsObj) {
        if (ComObjType(jsObj) & 0x2000) { ; SafeArray
            return jsObj ; Treat as is or convert?
        }

        try {
            ; Check if array
            if (jsObj.constructor.name == "Array") {
                arr := []
                loop jsObj.length
                    arr.Push(this._ConvertJStoAHK(jsObj.%A_Index - 1%))
                return arr
            }
        }

        try {
            ; Assume object
            mapObj := Map()
            for k in jsObj
                mapObj[k] := this._ConvertJStoAHK(jsObj.%k%)
            return mapObj
        }

        return jsObj ; Primitive value
    }
}
