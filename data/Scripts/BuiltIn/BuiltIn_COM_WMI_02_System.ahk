#Requires AutoHotkey v2.0

/**
* BuiltIn_COM_WMI_02_System.ahk
*
* DESCRIPTION:
* System information using WMI (Windows Management Instrumentation).
*
* FEATURES:
* - Operating system info
* - Computer system details
* - BIOS information
* - Disk information
* - Network adapters
*/

Example1_OSInfo() {
    MsgBox("Example 1: OS Information")
    Try {
        wmi := ComObjGet("winmgmts:")
        os := wmi.ExecQuery("SELECT * FROM Win32_OperatingSystem")

        for o in os {
            info := "OS: " o.Caption "`n"
            info .= "Version: " o.Version "`n"
            info .= "Architecture: " o.OSArchitecture
            MsgBox(info)
            break
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_ComputerSystem() {
    MsgBox("Example 2: Computer System")
    Try {
        wmi := ComObjGet("winmgmts:")
        cs := wmi.ExecQuery("SELECT * FROM Win32_ComputerSystem")

        for c in cs {
            info := "Computer: " c.Name "`n"
            info .= "Manufacturer: " c.Manufacturer "`n"
            info .= "Model: " c.Model
            MsgBox(info)
            break
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_Memory() {
    MsgBox("Example 3: Memory Information")
    Try {
        wmi := ComObjGet("winmgmts:")
        cs := wmi.ExecQuery("SELECT * FROM Win32_ComputerSystem")

        for c in cs {
            totalRAM := Round(c.TotalPhysicalMemory / 1024 / 1024 / 1024, 2)
            MsgBox("Total RAM: " totalRAM " GB")
            break
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_CPU() {
    MsgBox("Example 4: CPU Information")
    Try {
        wmi := ComObjGet("winmgmts:")
        cpu := wmi.ExecQuery("SELECT * FROM Win32_Processor")

        for c in cpu {
            info := "CPU: " c.Name "`n"
            info .= "Cores: " c.NumberOfCores "`n"
            info .= "Speed: " c.MaxClockSpeed " MHz"
            MsgBox(info)
            break
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_Disks() {
    MsgBox("Example 5: Disk Information")
    Try {
        wmi := ComObjGet("winmgmts:")
        disks := wmi.ExecQuery("SELECT * FROM Win32_LogicalDisk WHERE DriveType=3")

        output := "Logical Disks:`n`n"
        for disk in disks {
            size := Round(disk.Size / 1024 / 1024 / 1024, 2)
            free := Round(disk.FreeSpace / 1024 / 1024 / 1024, 2)
            output .= disk.DeviceID " - Size: " size " GB, Free: " free " GB`n"
        }
        MsgBox(output)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_BIOS() {
    MsgBox("Example 6: BIOS Information")
    Try {
        wmi := ComObjGet("winmgmts:")
        bios := wmi.ExecQuery("SELECT * FROM Win32_BIOS")

        for b in bios {
            info := "Manufacturer: " b.Manufacturer "`n"
            info .= "Version: " b.Version "`n"
            info .= "Serial: " b.SerialNumber
            MsgBox(info)
            break
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_Network() {
    MsgBox("Example 7: Network Adapters")
    Try {
        wmi := ComObjGet("winmgmts:")
        adapters := wmi.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE NetEnabled=True")

        output := "Network Adapters:`n`n"
        for adapter in adapters {
            output .= adapter.Name "`n"
        }
        MsgBox(output)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    WMI COM - System Info

    1. OS Information
    2. Computer System
    3. Memory Info
    4. CPU Information
    5. Disk Information
    6. BIOS Information
    7. Network Adapters

    0. Exit
    )"
    choice := InputBox(menu, "WMI System Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_OSInfo()
        case "2": Example2_ComputerSystem()
        case "3": Example3_Memory()
        case "4": Example4_CPU()
        case "5": Example5_Disks()
        case "6": Example6_BIOS()
        case "7": Example7_Network()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
    ShowMenu()
}
ShowMenu()
