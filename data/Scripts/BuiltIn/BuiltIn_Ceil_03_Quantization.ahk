#Requires AutoHotkey v2.0

/**
 * BuiltIn_Ceil_03_Quantization.ahk
 * 
 * DESCRIPTION:
 * Quantization applications using Ceil() for block sizing, memory allocation,
 * resource granularity, and discrete unit calculations
 * 
 * FEATURES:
 * - Block and sector size calculations
 * - Memory allocation and alignment
 * - Discrete unit quantization
 * - Bandwidth and storage planning
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Ceil.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Ceil() for quantization rounding
 * - Bit shifting and memory calculations
 * - Resource allocation algorithms
 * - Unit conversion with rounding
 * 
 * LEARNING POINTS:
 * 1. Quantization rounds to discrete units
 * 2. Memory allocated in fixed block sizes
 * 3. Storage uses minimum allocation units
 * 4. Resources often come in fixed quantities
 * 5. Ceil() ensures adequate allocation
 */

; ============================================================
; Example 1: Memory Block Allocation
; ============================================================

/**
 * Calculate memory blocks needed
 * 
 * @param {Number} requiredBytes - Bytes needed
 * @param {Number} blockSize - Block size in bytes
 * @returns {Object} - Allocation details
 */
AllocateMemoryBlocks(requiredBytes, blockSize) {
    blocksNeeded := Ceil(requiredBytes / blockSize)
    bytesAllocated := blocksNeeded * blockSize
    wastedBytes := bytesAllocated - requiredBytes
    efficiency := Round((requiredBytes / bytesAllocated) * 100, 1)

    return {
        required: requiredBytes,
        blockSize: blockSize,
        blocksNeeded: blocksNeeded,
        bytesAllocated: bytesAllocated,
        wastedBytes: wastedBytes,
        efficiency: efficiency
    }
}

/**
 * Format bytes as human-readable
 */
FormatBytes(bytes) {
    if (bytes >= 1073741824)
        return Format("{1:.2f} GB", bytes / 1073741824)
    else if (bytes >= 1048576)
        return Format("{1:.2f} MB", bytes / 1048576)
    else if (bytes >= 1024)
        return Format("{1:.2f} KB", bytes / 1024)
    else
        return Format("{1} bytes", bytes)
}

; Allocate memory for data structure
dataSize := 65000  ; bytes
blockSize := 4096  ; 4 KB blocks

allocation := AllocateMemoryBlocks(dataSize, blockSize)

MsgBox("Memory Block Allocation:`n`n"
    . "Data Size: " FormatBytes(allocation.required) "`n"
    . "Block Size: " FormatBytes(allocation.blockSize) "`n`n"
    . "Blocks Needed: " allocation.blocksNeeded "`n"
    . "Allocated: " FormatBytes(allocation.bytesAllocated) "`n"
    . "Wasted: " FormatBytes(allocation.wastedBytes) "`n"
    . "Efficiency: " allocation.efficiency "%`n`n"
    . "Calculation: Ceil(" allocation.required " / " allocation.blockSize ")`n"
    . "= Ceil(15.87) = " allocation.blocksNeeded " blocks",
    "Memory Allocation", "Icon!")

; ============================================================
; Example 2: Disk Sector Allocation
; ============================================================

/**
 * Calculate disk sectors for file storage
 * 
 * @param {Number} fileSize - File size in bytes
 * @param {Number} sectorSize - Sector size (default: 4096)
 * @returns {Object} - Sector allocation
 */
CalculateDiskSectors(fileSize, sectorSize := 4096) {
    sectorsNeeded := Ceil(fileSize / sectorSize)
    diskSpace := sectorsNeeded * sectorSize
    slack := diskSpace - fileSize

    return {
        fileSize: fileSize,
        sectorSize: sectorSize,
        sectorsNeeded: sectorsNeeded,
        diskSpace: diskSpace,
        slackSpace: slack,
        overhead: Round((slack / diskSpace) * 100, 1)
    }
}

/**
 * Analyze multiple files
 */
AnalyzeDiskUsage(files, sectorSize := 4096) {
    totalFileSize := 0
    totalDiskSpace := 0
    totalSlack := 0
    results := []

    for file in files {
        allocation := CalculateDiskSectors(file.size, sectorSize)
        results.Push({
            name: file.name,
            allocation: allocation
        })
        totalFileSize += allocation.fileSize
        totalDiskSpace += allocation.diskSpace
        totalSlack += allocation.slackSpace
    }

    return {
        files: results,
        totalFileSize: totalFileSize,
        totalDiskSpace: totalDiskSpace,
        totalSlack: totalSlack,
        wastePercent: Round((totalSlack / totalDiskSpace) * 100, 1)
    }
}

; Analyze file system usage
fileList := [{
    name: "document.txt", size: 2500 }, {
        name: "image.jpg", size: 8500 }, {
            name: "script.ahk", size: 1200 }, {
                name: "data.csv", size: 15000
            }
]

diskAnalysis := AnalyzeDiskUsage(fileList, 4096)

output := "Disk Sector Usage Analysis:`n"
output .= "Sector Size: 4096 bytes (4 KB)`n"
output .= "═══════════════════════════════════════`n`n"

for item in diskAnalysis.files {
    alloc := item.allocation
    output .= item.name . ":`n"
    output .= "  File: " FormatBytes(alloc.fileSize) "`n"
    output .= "  Disk: " FormatBytes(alloc.diskSpace)
    output .= " (" alloc.sectorsNeeded " sectors)`n"
    output .= "  Slack: " FormatBytes(alloc.slackSpace) "`n`n"
}

output .= "───────────────────────────────────────`n"
output .= "Total File Size: " FormatBytes(diskAnalysis.totalFileSize) "`n"
output .= "Total Disk Space: " FormatBytes(diskAnalysis.totalDiskSpace) "`n"
output .= "Total Slack: " FormatBytes(diskAnalysis.totalSlack)
output .= " (" diskAnalysis.wastePercent "%)"

MsgBox(output, "Disk Usage", "Icon!")

; ============================================================
; Example 3: Network Packet Framing
; ============================================================

/**
 * Calculate network packets needed
 * 
 * @param {Number} dataSize - Data size in bytes
 * @param {Number} maxPayload - Maximum payload per packet
 * @returns {Object} - Packet breakdown
 */
CalculatePackets(dataSize, maxPayload) {
    packetsNeeded := Ceil(dataSize / maxPayload)
    packets := []

    Loop packetsNeeded {
        packetNum := A_Index
        offset := (packetNum - 1) * maxPayload
        payloadSize := Min(maxPayload, dataSize - offset)

        packets.Push({
            number: packetNum,
            offset: offset,
            payloadSize: payloadSize
        })
    }

    return {
        dataSize: dataSize,
        maxPayload: maxPayload,
        packetsNeeded: packetsNeeded,
        packets: packets
    }
}

; Network transmission
messageSize := 8500  ; bytes
mtu := 1500         ; Maximum Transmission Unit (bytes)
headerOverhead := 40 ; IP + TCP headers
maxPayload := mtu - headerOverhead

packetCalc := CalculatePackets(messageSize, maxPayload)

output := "Network Packet Calculation:`n`n"
output .= "Data Size: " FormatBytes(packetCalc.dataSize) "`n"
output .= "MTU: " mtu " bytes`n"
output .= "Header Overhead: " headerOverhead " bytes`n"
output .= "Max Payload: " maxPayload " bytes`n`n"
output .= "Packets Needed: " packetCalc.packetsNeeded "`n`n"

for packet in packetCalc.packets {
    output .= Format("Packet {1}: Offset {2}, Payload {3} bytes`n",
        packet.number, packet.offset, packet.payloadSize)
}

MsgBox(output, "Network Packets", "Icon!")

; ============================================================
; Example 4: Cloud Storage Blocks
; ============================================================

/**
 * Calculate cloud storage blocks
 * 
 * @param {Number} dataGB - Data size in GB
 * @param {Number} blockSizeGB - Block size in GB
 * @param {Number} pricePerBlock - Price per block
 * @returns {Object} - Storage cost calculation
 */
CalculateCloudStorage(dataGB, blockSizeGB, pricePerBlock) {
    blocksNeeded := Ceil(dataGB / blockSizeGB)
    totalStorageGB := blocksNeeded * blockSizeGB
    wastedGB := totalStorageGB - dataGB
    monthlyCost := blocksNeeded * pricePerBlock
    yearlyOld := monthlyCost * 12

    return {
        dataGB: dataGB,
        blockSizeGB: blockSizeGB,
        blocksNeeded: blocksNeeded,
        totalStorageGB: totalStorageGB,
        wastedGB: Round(wastedGB, 2),
        pricePerBlock: pricePerBlock,
        monthlyCost: Round(monthlyCost, 2),
        yearlyCost: Round(yearlyOld, 2)
    }
}

; Cloud storage scenarios
storageScenarios := [{
    name: "Small Project", data: 15, block: 10, price: 1.50 }, {
        name: "Medium Database", data: 275, block: 100, price: 10.00 }, {
            name: "Large Archive", data: 1250, block: 500, price: 45.00
        }
]

output := "Cloud Storage Cost Analysis:`n`n"

for scenario in storageScenarios {
    calc := CalculateCloudStorage(scenario.data, scenario.block, scenario.price)

    output .= scenario.name . ":`n"
    output .= "  Data: " calc.dataGB " GB`n"
    output .= "  Block Size: " calc.blockSizeGB " GB @ $"
    output .= calc.pricePerBlock "/month`n"
    output .= "  Blocks Needed: " calc.blocksNeeded "`n"
    output .= "  Total Storage: " calc.totalStorageGB " GB`n"
    output .= "  Wasted: " calc.wastedGB " GB`n"
    output .= "  Monthly Cost: $" Format("{1:.2f}", calc.monthlyCost) "`n"
    output .= "  Yearly Cost: $" Format("{1:.2f}", calc.yearlyCost) "`n`n"
}

MsgBox(output, "Cloud Storage Costs", "Icon!")

; ============================================================
; Example 5: Time Quantization
; ============================================================

/**
 * Round time to billing interval
 * 
 * @param {Number} actualMinutes - Actual time used
 * @param {Number} billingInterval - Billing interval in minutes
 * @returns {Object} - Billing calculation
 */
QuantizeTime(actualMinutes, billingInterval) {
    billingUnits := Ceil(actualMinutes / billingInterval)
    billedMinutes := billingUnits * billingInterval
    extraMinutes := billedMinutes - actualMinutes

    return {
        actualMinutes: actualMinutes,
        billingInterval: billingInterval,
        billingUnits: billingUnits,
        billedMinutes: billedMinutes,
        extraMinutes: extraMinutes
    }
}

/**
 * Calculate service costs
 */
CalculateServiceCost(minutes, interval, costPerInterval) {
    quantized := QuantizeTime(minutes, interval)
    cost := quantized.billingUnits * costPerInterval

    return {
        time: quantized,
        costPerInterval: costPerInterval,
        totalCost: Round(cost, 2)
    }
}

; API usage billing (10-minute intervals at $0.05 each)
apiCalls := [{
    duration: 3, desc: "Quick query" }, {
        duration: 15, desc: "Data export" }, {
            duration: 47, desc: "Batch process" }, {
                duration: 90, desc: "Long operation"
            }
]

output := "API Billing (10-minute intervals @ $0.05):`n`n"

totalCost := 0
for call in apiCalls {
    billing := CalculateServiceCost(call.duration, 10, 0.05)

    output .= call.desc . ":`n"
    output .= "  Actual: " billing.time.actualMinutes " min`n"
    output .= "  Billed: " billing.time.billedMinutes " min"
    output .= " (" billing.time.billingUnits " units)`n"
    output .= "  Cost: $" Format("{1:.2f}", billing.totalCost) "`n`n"

    totalCost += billing.totalCost
}

output .= "Total Cost: $" Format("{1:.2f}", totalCost)

MsgBox(output, "Time Quantization", "Icon!")

; ============================================================
; Example 6: Bandwidth Reservation
; ============================================================

/**
 * Calculate bandwidth units needed
 * 
 * @param {Number} requiredMbps - Required bandwidth in Mbps
 * @param {Number} unitSizeMbps - Unit size in Mbps
 * @returns {Object} - Bandwidth allocation
 */
ReserveBandwidth(requiredMbps, unitSizeMbps) {
    unitsNeeded := Ceil(requiredMbps / unitSizeMbps)
    allocatedMbps := unitsNeeded * unitSizeMbps
    excessMbps := allocatedMbps - requiredMbps
    utilizationPercent := Round((requiredMbps / allocatedMbps) * 100, 1)

    return {
        required: requiredMbps,
        unitSize: unitSizeMbps,
        unitsNeeded: unitsNeeded,
        allocated: allocatedMbps,
        excess: Round(excessMbps, 2),
        utilization: utilizationPercent
    }
}

; Network bandwidth planning
bandwidthNeeds := [{
    app: "Video Streaming", need: 35 }, {
        app: "File Transfer", need: 180 }, {
            app: "VoIP Conference", need: 8 }, {
                app: "Database Sync", need: 125
            }
]

unitSize := 50  ; Mbps units

output := "Bandwidth Reservation (50 Mbps units):`n`n"

totalUnits := 0
for app in bandwidthNeeds {
    reservation := ReserveBandwidth(app.need, unitSize)

    output .= app.app . ":`n"
    output .= "  Required: " reservation.required " Mbps`n"
    output .= "  Reserved: " reservation.allocated " Mbps"
    output .= " (" reservation.unitsNeeded " units)`n"
    output .= "  Utilization: " reservation.utilization "%`n`n"

    totalUnits += reservation.unitsNeeded
}

output .= "Total Units: " totalUnits " × " unitSize " Mbps = "
output .= (totalUnits * unitSize) " Mbps"

MsgBox(output, "Bandwidth Planning", "Icon!")

; ============================================================
; Example 7: Container/Pod Allocation
; ============================================================

/**
 * Calculate container instances needed
 * 
 * @param {Number} requestsPerSecond - Expected requests/sec
 * @param {Number} requestsPerContainer - Capacity per container
 * @returns {Object} - Container allocation
 */
AllocateContainers(requestsPerSecond, requestsPerContainer) {
    containersNeeded := Ceil(requestsPerSecond / requestsPerContainer)
    totalCapacity := containersNeeded * requestsPerContainer
    headroom := totalCapacity - requestsPerSecond
    headroomPercent := Round((headroom / totalCapacity) * 100, 1)

    return {
        requestsPerSecond: requestsPerSecond,
        requestsPerContainer: requestsPerContainer,
        containersNeeded: containersNeeded,
        totalCapacity: totalCapacity,
        headroom: headroom,
        headroomPercent: headroomPercent
    }
}

/**
 * Calculate with scaling buffer
 */
AllocateWithBuffer(requestsPerSecond, requestsPerContainer, bufferPercent := 20) {
    ; Add buffer for scaling
    withBuffer := requestsPerSecond * (1 + bufferPercent / 100)
    allocation := AllocateContainers(withBuffer, requestsPerContainer)

    return {
        baseRequests: requestsPerSecond,
        bufferPercent: bufferPercent,
        withBuffer: Round(withBuffer, 0),
        allocation: allocation
    }
}

; Kubernetes pod scaling
trafficLevels := [{
    time: "Off-Peak", rps: 450 }, {
        time: "Business Hours", rps: 1250 }, {
            time: "Peak Traffic", rps: 3800
        }
]

containerCapacity := 500  ; requests per second per container

output := "Container Allocation Plan:`n"
output .= "Container Capacity: " containerCapacity " req/sec`n"
output .= "Safety Buffer: 20%`n"
output .= "═══════════════════════════════════════`n`n"

for level in trafficLevels {
    plan := AllocateWithBuffer(level.rps, containerCapacity, 20)

    output .= level.time . ":`n"
    output .= "  Base Load: " plan.baseRequests " req/sec`n"
    output .= "  With Buffer: " plan.withBuffer " req/sec`n"
    output .= "  Containers: " plan.allocation.containersNeeded "`n"
    output .= "  Total Capacity: " plan.allocation.totalCapacity " req/sec`n`n"
}

MsgBox(output, "Container Scaling", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
                                                    (
                                                    CEIL() FOR QUANTIZATION & ALLOCATION:

                                                    Quantization Concept:
                                                    ─────────────────────
                                                    Rounding to discrete units when continuous
                                                    values aren't possible:
                                                    • Memory blocks (can't allocate 1.5 blocks)
                                                    • Disk sectors (file uses whole sectors)
                                                    • Network packets (data split into packets)
                                                    • Time intervals (billing in fixed units)
                                                    • Cloud resources (purchased in blocks)

                                                    Memory Allocation:
                                                    ──────────────────
                                                    blocks = Ceil(bytes_needed / block_size)

                                                    Example (4 KB blocks):
                                                    65000 bytes needed
                                                    Ceil(65000 / 4096) = 16 blocks
                                                    Allocated: 65536 bytes
                                                    Slack: 536 bytes

                                                    Disk Sectors:
                                                    ─────────────
                                                    Modern disks use 4096-byte sectors:
                                                    sectors = Ceil(file_size / 4096)

                                                    Small files waste space:
                                                    100-byte file uses 4096 bytes
                                                    Slack space = 3996 bytes (97.6% waste!)

                                                    Network Packets:
                                                    ────────────────
                                                    packets = Ceil(data_size / max_payload)

                                                    With 1460-byte MTU payload:
                                                    8500 bytes data
                                                    Ceil(8500 / 1460) = 6 packets

                                                    Cloud Storage:
                                                    ──────────────
                                                    Providers sell in blocks:
                                                    • AWS EBS: 1 GB increments
                                                    • Azure: Variable block sizes
                                                    • GCP: Custom sizing

                                                    15 GB data with 10 GB blocks:
                                                    Ceil(15 / 10) = 2 blocks = 20 GB billed

                                                    Time Quantization:
                                                    ──────────────────
                                                    Billing in intervals:
                                                    • API calls: 1-minute intervals
                                                    • Parking: 15-minute intervals
                                                    • Cloud compute: 1-second intervals

                                                    47 minutes with 15-min intervals:
                                                    Ceil(47 / 15) = 4 intervals = 60 min billed

                                                    Bandwidth Units:
                                                    ────────────────
                                                    units = Ceil(required_mbps / unit_size)

                                                    ISP sells 50 Mbps units:
                                                    Need 35 Mbps → Buy 1 unit (50 Mbps)
                                                    Need 180 Mbps → Buy 4 units (200 Mbps)

                                                    Container Scaling:
                                                    ──────────────────
                                                    containers = Ceil(requests_per_sec / capacity_per_container)

                                                    500 req/sec capacity per container:
                                                    1250 req/sec load
                                                    Ceil(1250 / 500) = 3 containers

                                                    Best Practices:
                                                    ───────────────
                                                    ✓ Account for wasted space/capacity
                                                    ✓ Calculate efficiency metrics
                                                    ✓ Consider adding safety buffers
                                                    ✓ Monitor actual utilization
                                                    ✓ Right-size block/unit sizes
                                                    ✓ Plan for growth
                                                    ✓ Calculate total cost impact

                                                    Efficiency Formula:
                                                    ───────────────────
                                                    efficiency = (actual_need / allocated) × 100%

                                                    Higher efficiency = less waste
                                                    Lower efficiency = more headroom
                                                    )"

MsgBox(info, "Quantization Reference", "Icon!")
