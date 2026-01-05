#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_COM_Excel_05_Charts.ahk
 * 
 * DESCRIPTION:
 * Demonstrates creating and formatting charts in Microsoft Excel using COM automation.
 * Shows various chart types, customization options, and data visualization techniques.
 * 
 * FEATURES:
 * - Creating different chart types (bar, line, pie, scatter)
 * - Customizing chart appearance
 * - Adding chart titles and labels
 * - Formatting chart elements
 * - Working with chart data ranges
 * - Multiple charts on one sheet
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - ComObject
 * https://www.autohotkey.com/docs/v2/lib/ComObject.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - ComObject() for Excel automation
 * - Chart objects and ChartObjects collection
 * - Excel chart type constants
 * - Chart customization properties
 * 
 * LEARNING POINTS:
 * 1. How to create charts programmatically
 * 2. Different chart types and when to use them
 * 3. Customizing chart titles, axes, and legends
 * 4. Formatting chart colors and styles
 * 5. Setting data ranges for charts
 * 6. Positioning and sizing charts
 * 7. Creating multiple charts on a worksheet
 */

;===============================================================================
; Example 1: Basic Column Chart
;===============================================================================
Example1_BasicColumnChart() {
    MsgBox("Example 1: Basic Column Chart`n`nCreating a simple column chart.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Add data
        sheet.Range("A1").Value := "Month"
        sheet.Range("B1").Value := "Sales"

        months := ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        Loop months.Length {
            sheet.Cells(A_Index + 1, 1).Value := months[A_Index]
            sheet.Cells(A_Index + 1, 2).Value := Random(5000, 15000)
        }

        ; Create chart
        ; ChartObjects.Add(Left, Top, Width, Height)
        chartObj := sheet.ChartObjects().Add(250, 10, 400, 300)
        chart := chartObj.Chart

        ; Set chart data range
        chart.SetSourceData(sheet.Range("A1:B7"))

        ; Set chart type (-4100 = xlColumnClustered)
        chart.ChartType := -4100

        ; Add chart title
        chart.HasTitle := true
        chart.ChartTitle.Text := "Monthly Sales"

        ; Format chart title
        chart.ChartTitle.Font.Size := 16
        chart.ChartTitle.Font.Bold := true

        MsgBox("Column chart created!`n`nChart shows monthly sales data.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 1:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 2: Line Chart with Multiple Series
;===============================================================================
Example2_LineChart() {
    MsgBox("Example 2: Line Chart`n`nCreating a line chart with multiple data series.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Add data
        sheet.Range("A1").Value := "Month"
        sheet.Range("B1").Value := "Product A"
        sheet.Range("C1").Value := "Product B"
        sheet.Range("D1").Value := "Product C"

        months := ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        Loop months.Length {
            row := A_Index + 1
            sheet.Cells(row, 1).Value := months[A_Index]
            sheet.Cells(row, 2).Value := Random(1000, 5000)
            sheet.Cells(row, 3).Value := Random(1500, 6000)
            sheet.Cells(row, 4).Value := Random(2000, 7000)
        }

        ; Format data as table
        sheet.Range("A1:D1").Font.Bold := true
        sheet.Columns("A:D").AutoFit()

        ; Create line chart (xlLine = 4)
        chartObj := sheet.ChartObjects().Add(50, 150, 500, 350)
        chart := chartObj.Chart

        chart.SetSourceData(sheet.Range("A1:D7"))
        chart.ChartType := 4  ; xlLine

        ; Chart title
        chart.HasTitle := true
        chart.ChartTitle.Text := "Product Sales Comparison"

        ; Axis titles
        chart.Axes(1).HasTitle := true  ; Category axis
        chart.Axes(1).AxisTitle.Text := "Month"

        chart.Axes(2).HasTitle := true  ; Value axis
        chart.Axes(2).AxisTitle.Text := "Sales ($)"

        ; Legend
        chart.HasLegend := true
        chart.Legend.Position := -4107  ; xlLegendPositionBottom

        MsgBox("Line chart created!`n`nChart shows comparison of 3 products over 6 months.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 2:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 3: Pie Chart with Labels
;===============================================================================
Example3_PieChart() {
    MsgBox("Example 3: Pie Chart`n`nCreating a pie chart with data labels.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Add data
        sheet.Range("A1").Value := "Department"
        sheet.Range("B1").Value := "Budget"

        departments := ["Sales", "Marketing", "R&D", "Operations", "HR"]
        Loop departments.Length {
            sheet.Cells(A_Index + 1, 1).Value := departments[A_Index]
            sheet.Cells(A_Index + 1, 2).Value := Random(50000, 200000)
        }

        ; Format
        sheet.Range("A1:B1").Font.Bold := true
        sheet.Range("B2:B6").NumberFormat := "$#,##0"
        sheet.Columns("A:B").AutoFit()

        ; Create pie chart (xlPie = 5)
        chartObj := sheet.ChartObjects().Add(250, 10, 400, 350)
        chart := chartObj.Chart

        chart.SetSourceData(sheet.Range("A1:B6"))
        chart.ChartType := 5  ; xlPie

        ; Chart title
        chart.HasTitle := true
        chart.ChartTitle.Text := "Budget Distribution by Department"

        ; Add data labels showing percentage
        chart.SeriesCollection(1).HasDataLabels := true
        chart.SeriesCollection(1).DataLabels.ShowPercentage := true
        chart.SeriesCollection(1).DataLabels.ShowCategoryName := true
        chart.SeriesCollection(1).DataLabels.Position := 0  ; xlLabelPositionBestFit

        ; Format data labels
        chart.SeriesCollection(1).DataLabels.Font.Size := 10
        chart.SeriesCollection(1).DataLabels.Font.Bold := true

        ; Legend
        chart.HasLegend := true
        chart.Legend.Position := -4107  ; xlLegendPositionBottom

        MsgBox("Pie chart created!`n`nChart shows budget distribution with percentages.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 3:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 4: Bar Chart (Horizontal)
;===============================================================================
Example4_BarChart() {
    MsgBox("Example 4: Bar Chart`n`nCreating a horizontal bar chart.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Add data
        sheet.Range("A1").Value := "Employee"
        sheet.Range("B1").Value := "Performance Score"

        employees := ["Alice", "Bob", "Charlie", "Diana", "Eve", "Frank", "Grace", "Henry"]
        Loop employees.Length {
            sheet.Cells(A_Index + 1, 1).Value := employees[A_Index]
            sheet.Cells(A_Index + 1, 2).Value := Random(60, 100)
        }

        ; Format
        sheet.Range("A1:B1").Font.Bold := true
        sheet.Columns("A:B").AutoFit()

        ; Create bar chart (xlBarClustered = 57)
        chartObj := sheet.ChartObjects().Add(250, 10, 450, 400)
        chart := chartObj.Chart

        chart.SetSourceData(sheet.Range("A1:B9"))
        chart.ChartType := 57  ; xlBarClustered

        ; Chart title
        chart.HasTitle := true
        chart.ChartTitle.Text := "Employee Performance Scores"

        ; Axis titles
        chart.Axes(1).HasTitle := true
        chart.Axes(1).AxisTitle.Text := "Employees"

        chart.Axes(2).HasTitle := true
        chart.Axes(2).AxisTitle.Text := "Score"

        ; Color code bars based on value
        series := chart.SeriesCollection(1)
        Loop 8 {
            point := series.Points(A_Index)
            value := sheet.Cells(A_Index + 1, 2).Value

            if (value >= 90)
                point.Interior.Color := 0x00FF00  ; Green
            else if (value >= 75)
                point.Interior.Color := 0x00FFFF  ; Yellow
            else
                point.Interior.Color := 0x0000FF  ; Red
        }

        MsgBox("Bar chart created!`n`nBars are color-coded by performance level.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 4:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 5: Scatter Plot
;===============================================================================
Example5_ScatterPlot() {
    MsgBox("Example 5: Scatter Plot`n`nCreating a scatter plot with trend line.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Add data
        sheet.Range("A1").Value := "Study Hours"
        sheet.Range("B1").Value := "Test Score"

        ; Generate correlated data
        Loop 20 {
            hours := Random(1, 10)
            score := hours * 8 + Random(-10, 10) + 20  ; Roughly correlated
            sheet.Cells(A_Index + 1, 1).Value := hours
            sheet.Cells(A_Index + 1, 2).Value := score
        }

        ; Format
        sheet.Range("A1:B1").Font.Bold := true
        sheet.Columns("A:B").AutoFit()

        ; Create scatter chart (xlXYScatter = -4169)
        chartObj := sheet.ChartObjects().Add(250, 10, 450, 350)
        chart := chartObj.Chart

        chart.SetSourceData(sheet.Range("A1:B21"))
        chart.ChartType := -4169  ; xlXYScatter

        ; Chart title
        chart.HasTitle := true
        chart.ChartTitle.Text := "Study Hours vs Test Score"

        ; Axis titles
        chart.Axes(1).HasTitle := true
        chart.Axes(1).AxisTitle.Text := "Study Hours"

        chart.Axes(2).HasTitle := true
        chart.Axes(2).AxisTitle.Text := "Test Score"

        ; Add trendline
        series := chart.SeriesCollection(1)
        trendline := series.Trendlines().Add()
        trendline.Type := 1  ; xlLinear

        ; Display equation and R-squared
        trendline.DisplayEquation := true
        trendline.DisplayRSquared := true

        MsgBox("Scatter plot created!`n`nShows correlation between study hours and test scores with trendline.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 5:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 6: Combo Chart (Column and Line)
;===============================================================================
Example6_ComboChart() {
    MsgBox("Example 6: Combo Chart`n`nCreating a combination chart with columns and line.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Add data
        sheet.Range("A1").Value := "Month"
        sheet.Range("B1").Value := "Revenue"
        sheet.Range("C1").Value := "Profit Margin %"

        months := ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        Loop months.Length {
            row := A_Index + 1
            sheet.Cells(row, 1).Value := months[A_Index]
            sheet.Cells(row, 2).Value := Random(50000, 100000)
            sheet.Cells(row, 3).Value := Random(10, 25) / 100
        }

        ; Format
        sheet.Range("A1:C1").Font.Bold := true
        sheet.Range("B2:B7").NumberFormat := "$#,##0"
        sheet.Range("C2:C7").NumberFormat := "0.0%"
        sheet.Columns("A:C").AutoFit()

        ; Create column chart first
        chartObj := sheet.ChartObjects().Add(50, 150, 500, 350)
        chart := chartObj.Chart

        chart.SetSourceData(sheet.Range("A1:C7"))
        chart.ChartType := -4100  ; xlColumnClustered

        ; Change second series to line chart
        series2 := chart.SeriesCollection(2)
        series2.ChartType := 4  ; xlLine

        ; Add secondary axis for the line
        series2.AxisGroup := 2  ; xlSecondary

        ; Chart title
        chart.HasTitle := true
        chart.ChartTitle.Text := "Revenue and Profit Margin"

        ; Primary axis title
        chart.Axes(2, 1).HasTitle := true  ; Primary value axis
        chart.Axes(2, 1).AxisTitle.Text := "Revenue ($)"

        ; Secondary axis title
        chart.Axes(2, 2).HasTitle := true  ; Secondary value axis
        chart.Axes(2, 2).AxisTitle.Text := "Profit Margin (%)"

        ; Legend
        chart.HasLegend := true
        chart.Legend.Position := -4107  ; Bottom

        MsgBox("Combo chart created!`n`nShows revenue (columns) and profit margin (line) on different axes.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 6:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 7: Dashboard with Multiple Charts
;===============================================================================
Example7_Dashboard() {
    MsgBox("Example 7: Dashboard`n`nCreating a dashboard with multiple charts.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        xl.ScreenUpdating := false
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Title
        sheet.Range("A1").Value := "Sales Dashboard - Q4 2024"
        sheet.Range("A1").Font.Size := 18
        sheet.Range("A1").Font.Bold := true

        ; Data for Chart 1: Monthly Sales
        sheet.Range("A3").Value := "Month"
        sheet.Range("B3").Value := "Sales"
        months := ["Oct", "Nov", "Dec"]
        Loop months.Length {
            sheet.Cells(A_Index + 3, 1).Value := months[A_Index]
            sheet.Cells(A_Index + 3, 2).Value := Random(80000, 120000)
        }

        ; Chart 1: Monthly Sales (Column)
        chart1 := sheet.ChartObjects().Add(10, 50, 300, 200)
        chart1.Chart.SetSourceData(sheet.Range("A3:B6"))
        chart1.Chart.ChartType := -4100
        chart1.Chart.HasTitle := true
        chart1.Chart.ChartTitle.Text := "Monthly Sales"
        chart1.Chart.HasLegend := false

        ; Data for Chart 2: Sales by Region
        sheet.Range("D3").Value := "Region"
        sheet.Range("E3").Value := "Sales"
        regions := ["North", "South", "East", "West"]
        Loop regions.Length {
            sheet.Cells(A_Index + 3, 4).Value := regions[A_Index]
            sheet.Cells(A_Index + 3, 5).Value := Random(60000, 100000)
        }

        ; Chart 2: Sales by Region (Pie)
        chart2 := sheet.ChartObjects().Add(320, 50, 300, 200)
        chart2.Chart.SetSourceData(sheet.Range("D3:E7"))
        chart2.Chart.ChartType := 5  ; Pie
        chart2.Chart.HasTitle := true
        chart2.Chart.ChartTitle.Text := "Sales by Region"
        chart2.Chart.SeriesCollection(1).HasDataLabels := true
        chart2.Chart.SeriesCollection(1).DataLabels.ShowPercentage := true

        ; Data for Chart 3: Product Performance
        sheet.Range("G3").Value := "Product"
        sheet.Range("H3").Value := "Units"
        products := ["A", "B", "C", "D", "E"]
        Loop products.Length {
            sheet.Cells(A_Index + 3, 7).Value := "Product " products[A_Index]
            sheet.Cells(A_Index + 3, 8).Value := Random(100, 500)
        }

        ; Chart 3: Product Performance (Bar)
        chart3 := sheet.ChartObjects().Add(10, 270, 300, 200)
        chart3.Chart.SetSourceData(sheet.Range("G3:H8"))
        chart3.Chart.ChartType := 57  ; Bar
        chart3.Chart.HasTitle := true
        chart3.Chart.ChartTitle.Text := "Product Units Sold"
        chart3.Chart.HasLegend := false

        ; Data for Chart 4: Trend
        sheet.Range("J3").Value := "Week"
        sheet.Range("K3").Value := "Orders"
        Loop 12 {
            sheet.Cells(A_Index + 3, 10).Value := "W" A_Index
            sheet.Cells(A_Index + 3, 11).Value := Random(200, 400)
        }

        ; Chart 4: Weekly Trend (Line)
        chart4 := sheet.ChartObjects().Add(320, 270, 300, 200)
        chart4.Chart.SetSourceData(sheet.Range("J3:K15"))
        chart4.Chart.ChartType := 4  ; Line
        chart4.Chart.HasTitle := true
        chart4.Chart.ChartTitle.Text := "Weekly Order Trend"
        chart4.Chart.HasLegend := false

        ; Hide gridlines
        sheet.Range("A:Z").Interior.Color := 0xF5F5F5  ; Light background

        xl.ScreenUpdating := true

        MsgBox("Dashboard created!`n`n4 charts showing different aspects of sales data.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 7:`n" err.Message)
        if (IsSet(xl)) {
            xl.ScreenUpdating := true
            xl.Quit()
        }
    }
}

;===============================================================================
; Main Menu
;===============================================================================
ShowMenu() {
    menu := "
    (
    Excel COM - Charts and Graphs

    Choose an example:

    1. Basic Column Chart
    2. Line Chart (Multiple Series)
    3. Pie Chart with Labels
    4. Bar Chart (Horizontal)
    5. Scatter Plot
    6. Combo Chart
    7. Dashboard (Multiple Charts)

    0. Exit
    )"

    choice := InputBox(menu, "Excel Chart Examples", "w350 h400").Value

    switch choice {
        case "1": Example1_BasicColumnChart()
        case "2": Example2_LineChart()
        case "3": Example3_PieChart()
        case "4": Example4_BarChart()
        case "5": Example5_ScatterPlot()
        case "6": Example6_ComboChart()
        case "7": Example7_Dashboard()
        case "0": return
        default:
            MsgBox("Invalid choice!")
            return
    }

    result := MsgBox("Run another example?", "Continue?", "YesNo")
    if (result = "Yes")
        ShowMenu()
}

ShowMenu()
