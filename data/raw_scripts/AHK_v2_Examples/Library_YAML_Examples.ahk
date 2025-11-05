#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * YAML Library Examples - thqby/ahk2_lib
 *
 * YAML parsing and serialization, configuration management
 * Library: https://github.com/thqby/ahk2_lib/blob/master/YAML.ahk
 */

/**
 * Example 1: Basic YAML Parsing
 */
BasicYAMLParsingExample() {
    MsgBox("Basic YAML Parsing`n`n"
        . "yamlString := '`n"
        . "name: John Doe`n"
        . "age: 30`n"
        . "active: true`n"
        . "'`n`n"
        . "obj := YAML.parse(yamlString)`n"
        . 'MsgBox("Name: " obj["name"] "`nAge: " obj["age"] "`nActive: " obj["active"])')
}

/**
 * Example 2: Nested YAML Structures
 */
NestedYAMLExample() {
    MsgBox("Nested YAML Structures`n`n"
        . "yamlString := '`n"
        . "user:`n"
        . "  name: Alice`n"
        . "  contact:`n"
        . "    email: alice@example.com`n"
        . "    phone: 555-1234`n"
        . "'`n`n"
        . "obj := YAML.parse(yamlString)`n"
        . 'MsgBox("Name: " obj["user"]["name"] "`nEmail: " obj["user"]["contact"]["email"])')
}

/**
 * Example 3: YAML Arrays/Lists
 */
YAMLArrayExample() {
    MsgBox("YAML Arrays and Lists`n`n"
        . "yamlString := '`n"
        . "colors:`n"
        . "  - red`n"
        . "  - green`n"
        . "  - blue`n"
        . "numbers: [1, 2, 3, 4, 5]`n"
        . "'`n`n"
        . "obj := YAML.parse(yamlString)`n"
        . 'MsgBox("First color: " obj["colors"][1] "`nThird number: " obj["numbers"][3])')
}

/**
 * Example 4: Convert Object to YAML
 */
ObjectToYAMLExample() {
    MsgBox("Convert Object to YAML String`n`n"
        . "data := Map()`n"
        . 'data["title"] := "Configuration"`n'
        . 'data["version"] := "1.0"`n'
        . 'data["settings"] := Map()`n'
        . 'data["settings"]["debug"] := true`n'
        . 'data["settings"]["timeout"] := 30`n`n'
        . "yamlString := YAML.stringify(data)`n"
        . 'MsgBox("YAML Output:`n`n" yamlString)')
}

/**
 * Example 5: Load YAML Configuration File
 */
LoadYAMLConfigExample() {
    configPath := A_ScriptDir "\config.yaml"

    MsgBox("Load YAML Configuration File`n`n"
        . 'configPath := A_ScriptDir "\\\\config.yaml"`n`n'
        . "; Read file`n"
        . "yamlContent := FileRead(configPath)`n"
        . "config := YAML.parse(yamlContent)`n`n"
        . "; Access configuration`n"
        . 'appName := config["app"]["name"]`n'
        . 'port := config["server"]["port"]`n'
        . 'MsgBox("App: " appName "`nPort: " port)')
}

/**
 * Example 6: Save Configuration to YAML
 */
SaveYAMLConfigExample() {
    MsgBox("Save Configuration to YAML File`n`n"
        . "config := Map()`n"
        . 'config["app"] := Map()`n'
        . 'config["app"]["name"] := "My Application"`n'
        . 'config["app"]["version"] := "2.0"`n'
        . 'config["database"] := Map()`n'
        . 'config["database"]["host"] := "localhost"`n'
        . 'config["database"]["port"] := 5432`n`n'
        . "yamlString := YAML.stringify(config)`n"
        . 'FileDelete(A_ScriptDir "\\\\config.yaml")`n'
        . 'FileAppend(yamlString, A_ScriptDir "\\\\config.yaml")`n'
        . 'MsgBox("Configuration saved to config.yaml")')
}

/**
 * Example 7: YAML with Comments
 */
YAMLCommentsExample() {
    MsgBox("YAML with Comments`n`n"
        . "yamlString := '`n"
        . "# Application configuration`n"
        . "app:`n"
        . "  name: MyApp  # Application name`n"
        . "  debug: true  # Enable debug mode`n"
        . "`n"
        . "# Server settings`n"
        . "server:`n"
        . "  port: 8080`n"
        . "'`n`n"
        . "; Comments are stripped during parsing`n"
        . "obj := YAML.parse(yamlString)`n"
        . 'MsgBox("App name: " obj["app"]["name"])')
}

/**
 * Example 8: Multi-Document YAML
 */
MultiDocumentYAMLExample() {
    MsgBox("Multi-Document YAML Support`n`n"
        . "yamlString := '`n"
        . "name: Document 1`n"
        . "type: config`n"
        . "---`n"
        . "name: Document 2`n"
        . "type: data`n"
        . "---`n"
        . "name: Document 3`n"
        . "type: logs`n"
        . "'`n`n"
        . "; Parse each document separately`n"
        . "documents := StrSplit(yamlString, '---')`n"
        . "for doc in documents {`n"
        . "    if (Trim(doc))`n"
        . "        obj := YAML.parse(doc)`n"
        . "}")
}

/**
 * Example 9: YAML Anchors and Aliases
 */
AnchorsAliasesExample() {
    MsgBox("YAML Anchors and Aliases`n`n"
        . "yamlString := '`n"
        . "defaults: &defaults`n"
        . "  timeout: 30`n"
        . "  retries: 3`n"
        . "`n"
        . "production:`n"
        . "  <<: *defaults`n"
        . "  host: prod.example.com`n"
        . "`n"
        . "staging:`n"
        . "  <<: *defaults`n"
        . "  host: staging.example.com`n"
        . "'`n`n"
        . "obj := YAML.parse(yamlString)`n"
        . 'MsgBox("Prod timeout: " obj["production"]["timeout"])')
}

/**
 * Example 10: Complex Data Types
 */
ComplexDataTypesExample() {
    MsgBox("YAML Complex Data Types`n`n"
        . "yamlString := '`n"
        . "string: Hello World`n"
        . "integer: 42`n"
        . "float: 3.14159`n"
        . "boolean: true`n"
        . "null_value: null`n"
        . "date: 2024-01-15`n"
        . "multiline: |`n"
        . "  This is a`n"
        . "  multiline string`n"
        . "folded: >`n"
        . "  This is folded`n"
        . "  into one line`n"
        . "'`n`n"
        . "obj := YAML.parse(yamlString)`n"
        . 'MsgBox("String: " obj["string"] "`nInteger: " obj["integer"])')
}

/**
 * Example 11: Configuration Manager Class
 */
ConfigManagerExample() {
    MsgBox("YAML Configuration Manager`n`n"
        . "class ConfigManager {`n"
        . "    config := ''`n"
        . "    filePath := ''`n`n"
        . "    __New(filePath) {`n"
        . "        this.filePath := filePath`n"
        . "        this.Load()`n"
        . "    }`n`n"
        . "    Load() {`n"
        . "        if (!FileExist(this.filePath))`n"
        . "            return false`n"
        . "        yamlContent := FileRead(this.filePath)`n"
        . "        this.config := YAML.parse(yamlContent)`n"
        . "        return true`n"
        . "    }`n`n"
        . "    Save() {`n"
        . "        yamlString := YAML.stringify(this.config)`n"
        . "        FileDelete(this.filePath)`n"
        . "        FileAppend(yamlString, this.filePath)`n"
        . "    }`n`n"
        . "    Get(path) {`n"
        . "        keys := StrSplit(path, '.')`n"
        . "        value := this.config`n"
        . "        for key in keys`n"
        . "            value := value[key]`n"
        . "        return value`n"
        . "    }`n`n"
        . "    Set(path, value) {`n"
        . "        keys := StrSplit(path, '.')`n"
        . "        obj := this.config`n"
        . "        loop keys.Length - 1`n"
        . "            obj := obj[keys[A_Index]]`n"
        . "        obj[keys[-1]] := value`n"
        . "    }`n"
        . "}`n`n"
        . 'cfg := ConfigManager("settings.yaml")`n'
        . 'port := cfg.Get("server.port")`n'
        . 'cfg.Set("server.port", 9000)`n'
        . "cfg.Save()")
}

/**
 * Example 12: Environment-Specific Configuration
 */
EnvironmentConfigExample() {
    MsgBox("Environment-Specific Configuration`n`n"
        . "class EnvConfig {`n"
        . "    static Load(environment := 'development') {`n"
        . "        yamlString := '`n"
        . "development:`n"
        . "  database:`n"
        . "    host: localhost`n"
        . "    port: 5432`n"
        . "  debug: true`n"
        . "`n"
        . "production:`n"
        . "  database:`n"
        . "    host: db.example.com`n"
        . "    port: 5432`n"
        . "  debug: false`n"
        . "'`n`n"
        . "        config := YAML.parse(yamlString)`n"
        . "        return config[environment]`n"
        . "    }`n"
        . "}`n`n"
        . "devConfig := EnvConfig.Load('development')`n"
        . "prodConfig := EnvConfig.Load('production')")
}

/**
 * Example 13: YAML to JSON Conversion
 */
YAMLToJSONExample() {
    MsgBox("Convert YAML to JSON`n`n"
        . "yamlString := '`n"
        . "user:`n"
        . "  name: Bob`n"
        . "  age: 25`n"
        . "  hobbies:`n"
        . "    - reading`n"
        . "    - gaming`n"
        . "'`n`n"
        . "; Parse YAML`n"
        . "obj := YAML.parse(yamlString)`n`n"
        . "; Convert to JSON (requires JSON library)`n"
        . "jsonString := JSON.stringify(obj, , 2)`n"
        . 'MsgBox("JSON Output:`n`n" jsonString)')
}

/**
 * Example 14: Validate YAML Structure
 */
ValidateYAMLExample() {
    MsgBox("Validate YAML Structure`n`n"
        . "ValidateConfig(yamlString) {`n"
        . "    try {`n"
        . "        config := YAML.parse(yamlString)`n`n"
        . "        ; Check required fields`n"
        . "        if (!config.Has('app') || !config['app'].Has('name'))`n"
        . "            throw Error('Missing app.name')`n`n"
        . "        if (!config.Has('server') || !config['server'].Has('port'))`n"
        . "            throw Error('Missing server.port')`n`n"
        . "        ; Validate types`n"
        . "        if (!IsInteger(config['server']['port']))`n"
        . "            throw Error('server.port must be integer')`n`n"
        . "        return {valid: true, config: config}`n"
        . "    } catch Error as e {`n"
        . "        return {valid: false, error: e.Message}`n"
        . "    }`n"
        . "}`n`n"
        . "result := ValidateConfig(yamlContent)`n"
        . "if (result.valid)`n"
        . "    MsgBox('Configuration is valid!')`n"
        . "else`n"
        . "    MsgBox('Validation error: ' result.error)")
}

/**
 * Example 15: Merge YAML Configurations
 */
MergeYAMLExample() {
    MsgBox("Merge Multiple YAML Configurations`n`n"
        . "baseConfig := '`n"
        . "app:`n"
        . "  name: MyApp`n"
        . "  version: 1.0`n"
        . "server:`n"
        . "  port: 8080`n"
        . "'`n`n"
        . "overrideConfig := '`n"
        . "server:`n"
        . "  port: 9000`n"
        . "  host: localhost`n"
        . "'`n`n"
        . "DeepMerge(target, source) {`n"
        . "    for key, value in source {`n"
        . "        if (target.Has(key) && target[key] is Map && value is Map)`n"
        . "            DeepMerge(target[key], value)`n"
        . "        else`n"
        . "            target[key] := value`n"
        . "    }`n"
        . "    return target`n"
        . "}`n`n"
        . "base := YAML.parse(baseConfig)`n"
        . "override := YAML.parse(overrideConfig)`n"
        . "merged := DeepMerge(base, override)`n`n"
        . "yamlOutput := YAML.stringify(merged)`n"
        . 'MsgBox("Merged Configuration:`n`n" yamlOutput)')
}

MsgBox("YAML Library Examples Loaded`n`n"
    . "Note: These are conceptual examples.`n"
    . "To use, you need to include:`n"
    . "#Include <YAML>`n`n"
    . "Available Examples:`n"
    . "- BasicYAMLParsingExample()`n"
    . "- NestedYAMLExample()`n"
    . "- YAMLArrayExample()`n"
    . "- ObjectToYAMLExample()`n"
    . "- LoadYAMLConfigExample()`n"
    . "- SaveYAMLConfigExample()`n"
    . "- ConfigManagerExample()`n"
    . "- EnvironmentConfigExample()")

; Uncomment to view examples:
; BasicYAMLParsingExample()
; NestedYAMLExample()
; YAMLArrayExample()
; ObjectToYAMLExample()
; ConfigManagerExample()
