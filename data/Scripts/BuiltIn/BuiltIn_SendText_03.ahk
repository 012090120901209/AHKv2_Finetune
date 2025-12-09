#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 SendText Function - Safe Input
* ============================================================================
*
* Demonstrates safe text input for sensitive data, security contexts,
* and scenarios where special character interpretation could cause issues.
*
* @module BuiltIn_SendText_03
* @author AutoHotkey Community
* @version 2.0.0
*/

; ============================================================================
; Example 1: Password and Credential Entry
; ============================================================================

/**
* Enters complex passwords safely.
* No character interpretation prevents accidental triggers.
*
* @example
* ; Press F1 for safe password entry
*/
F1:: {
    ToolTip("Password entry in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Complex password with all special characters
    password := "P@ssW0rd!2024#Secur3^Str0ng&Valid+"

    SendText(password)

    ToolTip("Password entered safely!")
    Sleep(1500)
    ToolTip()
}

/**
* Enters username/password combination
* Complete login automation
*/
F2:: {
    ToolTip("Login automation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    username := "user@domain.com"
    password := "C0mpl3x!P@ssw0rd#2024&Secur3^"

    ; Username field
    SendText(username)
    Send("{Tab}")
    Sleep(200)

    ; Password field
    SendText(password)
    Send("{Enter}")

    ToolTip("Login credentials entered!")
    Sleep(1500)
    ToolTip()
}

/**
* Enters API keys and tokens
* Preserves exact token format
*/
F3:: {
    ToolTip("API token entry in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Various API key formats (placeholders)
    apiKey := "api_live_EXAMPLE123456789abcdefghij0PLACEHOLDER"
    bearerToken := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U"

    SendText(apiKey)
    Send("{Enter}")
    Sleep(500)

    SendText(bearerToken)

    ToolTip("API credentials entered!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Example 2: Database Connection Strings
; ============================================================================

/**
* Enters database connection strings.
* Preserves all special characters in connection string.
*
* @description
* Safe database configuration
*/
^F1:: {
    ToolTip("Database connection string in 2 seconds...")
    Sleep(2000)
    ToolTip()

    connectionStrings := [
    "Server=myServerAddress;Database=myDataBase;User Id=myUsername;Password=P@ssw0rd123!;",
    "mongodb://username:p@ss%w0rd@localhost:27017/database?authSource=admin",
    "postgresql://user:p@ss!word@localhost:5432/dbname?sslmode=require",
    "mysql://root:P@ssw0rd#2024@localhost:3306/mydatabase"
    ]

    for index, connStr in connectionStrings {
        ToolTip("Connection string " index " of " connectionStrings.Length)

        SendText(connStr)
        Send("{Enter}")

        Sleep(500)
    }

    ToolTip("Connection strings entered!")
    Sleep(2000)
    ToolTip()
}

/**
* Enters environment variables
* Configuration with special characters
*/
^F2:: {
    ToolTip("Environment variables in 2 seconds...")
    Sleep(2000)
    ToolTip()

    envVars := [
    "DATABASE_URL=postgres://user:pass@localhost:5432/db",
    "API_KEY=api_test_EXAMPLE1234567890abcdefghij",
    "SECRET_KEY=+v8kX!mN2pQ@rS#tU&wY*zB",
    "JWT_SECRET=mySuperSecret!Key@2024#Secure",
    "SMTP_PASSWORD=Em@il!P@ssw0rd#2024"
    ]

    for index, envVar in envVars {
        ToolTip("Environment variable " index)

        SendText(envVar)
        Send("{Enter}")

        Sleep(300)
    }

    ToolTip("Environment variables set!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 3: Command Line and Script Entry
; ============================================================================

/**
* Enters command line arguments safely.
* Preserves all command syntax.
*
* @description
* Safe shell command entry
*/
^F3:: {
    ToolTip("Command line input in 2 seconds...")
    Sleep(2000)
    ToolTip()

    commands := [
    'docker run -e "DATABASE_URL=postgres://user:p@ss@localhost/db" myapp',
    'curl -H "Authorization: Bearer sk_live_ABC123!@#" https://api.example.com',
    'python script.py --password="P@ssw0rd!2024" --user="admin@example.com"',
    'git commit -m "Fix: Handle special chars (^, +, !, @, #) in input"'
    ]

    for index, cmd in commands {
        ToolTip("Command " index " of " commands.Length)

        SendText(cmd)
        Send("{Enter}")

        Sleep(500)
    }

    ToolTip("Commands entered!")
    Sleep(2000)
    ToolTip()
}

/**
* Enters script code safely
* Code with special characters
*/
^F4:: {
    ToolTip("Script code entry in 2 seconds...")
    Sleep(2000)
    ToolTip()

    scriptCode := '
    (
    #!/bin/bash

    PASSWORD="P@ssw0rd!2024#Secure"
    API_KEY="sk_test_ABC123!@#$%^&*()"
    DB_CONN="postgresql://user:${PASSWORD}@localhost/db"
    echo "Config loaded successfully!"
    )'

    SendText(StrReplace(scriptCode, "`n    ", "`n"))

    ToolTip("Script entered!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 4: Configuration File Entry
; ============================================================================

/**
* Enters configuration files safely.
* Preserves all config syntax.
*
* @description
* Config file automation
*/
^F5:: {
    ToolTip("Configuration file in 2 seconds...")
    Sleep(2000)
    ToolTip()

    configFile := '
    (
    [database]
    host = localhost
    port = 5432
    user = admin
    password = P@ssw0rd!2024#Secure
    database = myapp_prod

    [api]
    base_url = https://api.example.com/v2
    api_key = sk_live_ABC123!@#$%^&*()
    timeout = 30

    [email]
    smtp_host = smtp.gmail.com
    smtp_port = 587
    smtp_user = notify@example.com
    smtp_password = Em@il!P@ss#2024

    [security]
    jwt_secret = mySuperSecret!Key@2024#Secure&Valid
    encryption_key = +v8kX!mN2pQ@rS#tU&wY*zB
    )'

    SendText(StrReplace(configFile, "`n    ", "`n"))

    ToolTip("Config file entered!")
    Sleep(2000)
    ToolTip()
}

/**
* Enters .env file contents
* Environment configuration
*/
^F6:: {
    ToolTip(".env file entry in 2 seconds...")
    Sleep(2000)
    ToolTip()

    envFile := '
    (
    # Database Configuration

    DATABASE_URL=postgresql://user:P@ss!w0rd@localhost:5432/mydb
    DB_POOL_SIZE=10

    # API Keys

    STRIPE_SECRET_KEY=sk_live_ABC123!@#$%^&*()
    SENDGRID_API_KEY=SG.ABC123!@#.xyz789!@#
    AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
    AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

    # Application Secrets

    JWT_SECRET=my!Super@Secret#Key$2024
    SESSION_SECRET=s3ss!0n@S3cr3t#K3y
    ENCRYPTION_KEY=+v8kX!mN2pQ@rS#tU&wY*zB

    # Email Configuration

    SMTP_PASSWORD=Em@il!P@ssw0rd#2024&Secure
    SMTP_FROM=noreply@example.com

    # Feature Flags

    ENABLE_2FA=true
    DEBUG_MODE=false
    )'

    SendText(StrReplace(envFile, "`n    ", "`n"))

    ToolTip(".env file entered!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 5: Regular Expression Patterns
; ============================================================================

/**
* Enters regex patterns safely.
* All regex special characters preserved.
*
* @description
* Regex pattern entry
*/
^F7:: {
    ToolTip("Regex patterns in 2 seconds...")
    Sleep(2000)
    ToolTip()

    regexPatterns := [
    '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    '^\+?1?\d{9,15}$',
    '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    '^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b',
    '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?Z$'
    ]

    for index, pattern in regexPatterns {
        ToolTip("Regex pattern " index)

        SendText(pattern)
        Send("{Enter}")

        Sleep(400)
    }

    ToolTip("Regex patterns entered!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 6: Template and Boilerplate Code
; ============================================================================

/**
* Enters code templates with sensitive data.
* Preserves all code structure.
*
* @description
* Template code insertion
*/
^F8:: {
    ToolTip("Code template in 2 seconds...")
    Sleep(2000)
    ToolTip()

    template := '
    (
    const config = {
        database: {
            host: "localhost",
            port: 5432,
            user: "admin",
            password: "P@ssw0rd!2024#Secure",
            database: "myapp_prod"
        },
        api: {
            baseUrl: "https://api.example.com/v2",
            apiKey: "sk_live_ABC123!@#$%^&*()",
            timeout: 30000
        },
        security: {
            jwtSecret: "mySuperSecret!Key@2024#Secure&Valid",
            tokenExpiry: "24h",
            bcryptRounds: 12
        }
    };

    export default config;
    )'

    SendText(StrReplace(template, "`n    ", "`n"))

    ToolTip("Template inserted!")
    Sleep(2000)
    ToolTip()
}

/**
* Enters SQL with sensitive data
* Database queries with passwords
*/
^F9:: {
    ToolTip("SQL with sensitive data in 2 seconds...")
    Sleep(2000)
    ToolTip()

    sqlCode := "
    (
    -- Create user with encrypted password
    CREATE USER 'appuser'@'localhost' IDENTIFIED BY 'P@ssw0rd!2024#Secure';

    -- Grant privileges
    GRANT ALL PRIVILEGES ON myapp_db.* TO 'appuser'@'localhost';

    -- Create table with sensitive fields
    CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    api_key VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Insert test user
    INSERT INTO users (username, email, password_hash, api_key)
    VALUES ('admin', 'admin@example.com', '$2b$12$ABC...', 'sk_test_123!@#');
    )"

    SendText(StrReplace(sqlCode, "`n    ", "`n"))

    ToolTip("SQL entered!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 7: Secure Notes and Documentation
; ============================================================================

/**
* Enters secure notes with credentials.
* Documentation with sensitive information.
*
* @description
* Secure documentation entry
*/
^F10:: {
    ToolTip("Secure notes in 2 seconds...")
    Sleep(2000)
    ToolTip()

    secureNotes := "
    (
    SECURE CREDENTIALS - CONFIDENTIAL
    ===================================

    Production Database:
    - Host: prod-db.example.com
    - Port: 5432
    - User: prod_admin
    - Password: Pr0d!DB@P@ssw0rd#2024&Secure
    - Database: myapp_production

    API Credentials:
    - Stripe Live Key: sk_live_ABC123!@#$%^&*()DEF456
    - SendGrid Key: SG.XYZ789!@#.abc123!@#
    - AWS Access: AKIAIOSFODNN7EXAMPLE
    - AWS Secret: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

    Application Secrets:
    - JWT Secret: mySuperSecret!Key@2024#Secure&Valid+Strong
    - Session Secret: s3ss!0n@S3cr3t#K3y&V@l!d
    - Encryption: +v8kX!mN2pQ@rS#tU&wY*zB

    SSH Keys:
    - Server: ssh admin@prod-server.example.com
    - Password: SSH!P@ssw0rd#2024&Secure
    - Port: 22

    IMPORTANT: Keep this information secure!
    Last updated: 2024-01-01
    )"

    SendText(StrReplace(secureNotes, "`n    ", "`n"))

    ToolTip("Secure notes entered!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
* Securely enters password from clipboard
*
* @returns {Boolean} Success status
*/
EnterPasswordFromClipboard() {
    if (A_Clipboard != "") {
        SendText(A_Clipboard)
        A_Clipboard := ""  ; Clear clipboard for security
        return true
    }
    return false
}

/**
* Enters masked sensitive data
*
* @param {String} data - Sensitive data
* @param {Boolean} clearAfter - Clear data after entry
*/
SecureEntry(data, clearAfter := true) {
    SendText(data)

    if (clearAfter)
    data := ""  ; Clear variable
}

/**
* Enters credentials safely
*
* @param {String} username - Username
* @param {String} password - Password
*/
EnterCredentials(username, password) {
    SendText(username)
    Send("{Tab}")
    Sleep(200)
    SendText(password)
}

; Test utilities
!F1:: {
    ; Copy test password to clipboard
    A_Clipboard := "Test!P@ssw0rd#2024"

    ToolTip("Password in clipboard - entering in 2 seconds...")
    Sleep(2000)
    ToolTip()

    result := EnterPasswordFromClipboard()

    ToolTip("Password entered: " (result ? "Success" : "Failed") "`nClipboard cleared for security")
    Sleep(2000)
    ToolTip()
}

!F2:: {
    ToolTip("Credential entry test in 2 seconds...")
    Sleep(2000)
    ToolTip()

    EnterCredentials("testuser@example.com", "Test!P@ssw0rd#2024&Secure")

    ToolTip("Credentials entered!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    SendText - Safe Input
    =====================

    F1 - Password entry
    F2 - Login credentials
    F3 - API tokens

    Ctrl+F1  - Database connection strings
    Ctrl+F2  - Environment variables
    Ctrl+F3  - Command line input
    Ctrl+F4  - Script code entry
    Ctrl+F5  - Configuration file
    Ctrl+F6  - .env file
    Ctrl+F7  - Regex patterns
    Ctrl+F8  - Code template
    Ctrl+F9  - SQL with sensitive data
    Ctrl+F10 - Secure notes

    Alt+F1 - Password from clipboard
    Alt+F2 - Credential entry test

    F12 - Show this help
    ESC - Exit script

    SECURITY: SendText prevents accidental
    hotkey triggers from special characters!
    )"

    MsgBox(helpText, "Safe Input Help")
}
