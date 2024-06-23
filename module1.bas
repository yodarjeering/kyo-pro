Attribute VB_Name = "Module1"

Sub Test()
    Debug.Print "Hello"
    MsgBox "Hello"
End Sub

Sub PlotAndDisplayCoefficients()
    Dim rng As Range
    Dim chartObj As ChartObject
    Dim ws As Worksheet
    Dim i As Integer
    Dim series As Series
    Dim trendline As Trendline
    Dim trendTypeInput As String
    Dim trendType As XlTrendlineType
    Dim polynomialOrder As Integer
    Dim lastColumn As Integer

    ' Prompt user to select the type of trendline
    trendTypeInput = InputBox("Please enter the type of trendline (1: Linear, 2: Exponential, 3: Logarithmic, 4: Polynomial, 5: Moving Average)", "Trendline Type")

    ' Set the trendline type based on user input
    Select Case trendTypeInput
        Case "1"
            trendType = xlLinear
        Case "2"
            trendType = xlExponential
        Case "3"
            trendType = xlLogarithmic
        Case "4"
            trendType = xlPolynomial
            ' Prompt user for the order of the polynomial if polynomial is selected
            polynomialOrder = Val(InputBox("Enter the order of the polynomial (e.g., 2 for quadratic, 3 for cubic, etc.)", "Polynomial Order"))
            If polynomialOrder < 2 Then
                MsgBox "Invalid order. A polynomial must be of order 2 or higher. Defaulting to 2."
                polynomialOrder = 2
            End If
        Case "5"
            trendType = xlMovingAvg
        Case Else
            MsgBox "Invalid input. Linear will be selected by default."
            trendType = xlLinear
    End Select

    ' Get the selected range
    Set rng = Selection
    Set ws = rng.Worksheet

    ' Display an error message if the selection has less than 2 columns
    If rng.Columns.Count < 2 Then
        MsgBox "The selection must have at least 2 columns.", vbExclamation
        Exit Sub
    End If

    ' Add a chart object
    Set chartObj = ws.ChartObjects.Add(Left:=100, Width:=600, Top:=50, Height:=300)
    With chartObj.Chart
        ' Set the chart type
        .ChartType = xlXYScatterLines

        ' Set the first column as X-axis data
        For i = 2 To rng.Columns.Count
            ' Add a new series
            Set series = .SeriesCollection.NewSeries
            series.XValues = rng.Columns(1)
            series.Values = rng.Columns(i)
            series.Name = "Y" & i - 1

            ' Add a trendline
            Set trendline = series.Trendlines.Add(Type:=trendType)
            If trendType = xlPolynomial Then
                trendline.Order = polynomialOrder
            End If
            trendline.DisplayEquation = True
            trendline.DisplayRSquared = True

            ' Output the equation next to the selected range
            lastColumn = rng.Columns(rng.Columns.Count).Column
            ws.Cells(rng.Row, lastColumn + i).Value = trendline.DataLabel.Text
        Next i
    End With
End Sub

Sub DisplayTrendlineCoefficientsDirectly()
    Dim rng As Range
    Dim ws As Worksheet
    Dim chartObj As ChartObject
    Dim series As Series
    Dim trendline As Trendline
    Dim trendTypeInput As String
    Dim trendType As XlTrendlineType
    Dim polynomialOrder As Integer
    Dim lastColumn As Integer
    Dim equation As String
    Dim coefficients() As String

    ' Prompt user to select the type of trendline
    trendTypeInput = InputBox("Please enter the type of trendline (1: Linear, 2: Exponential, 3: Logarithmic, 4: Polynomial, 5: Moving Average)", "Trendline Type")

    ' Set the trendline type based on user input
    Select Case trendTypeInput
        Case "1"
            trendType = xlLinear
        Case "2"
            trendType = xlExponential
        Case "3"
            trendType = xlLogarithmic
        Case "4"
            trendType = xlPolynomial
            polynomialOrder = Val(InputBox("Enter the order of the polynomial (e.g., 2 for quadratic, 3 for cubic, etc.)", "Polynomial Order"))
            If polynomialOrder < 2 Then
                MsgBox "Invalid order. A polynomial must be of order 2 or higher. Defaulting to 2."
                polynomialOrder = 2
            End If
        Case "5"
            trendType = xlMovingAvg
        Case Else
            MsgBox "Invalid input. Linear will be selected by default."
            trendType = xlLinear
    End Select

    ' Get the selected range
    Set rng = Selection
    Set ws = rng.Worksheet

    ' Validate the selection
    If rng.Columns.Count < 2 Then
        MsgBox "The selection must have at least 2 columns.", vbExclamation
        Exit Sub
    End If

    ' Add a temporary chart object
    Set chartObj = ws.ChartObjects.Add(Left:=100, Width:=600, Top:=50, Height:=300)
    With chartObj.Chart
        .ChartType = xlXYScatterLines
        Set series = .SeriesCollection.NewSeries
        series.XValues = rng.Columns(1)
        series.Values = rng.Columns(2)
        series.Name = "Temp Series"

        ' Add a trendline
        Set trendline = series.Trendlines.Add(Type:=trendType)
        If trendType = xlPolynomial Then
            trendline.Order = polynomialOrder
        End If
        trendline.DisplayEquation = True
        trendline.DisplayRSquared = True

        ' Extract equation and write to adjacent cells
        equation = trendline.DataLabel.Text
        coefficients = Split(equation, " ")
        lastColumn = rng.Columns(rng.Columns.Count).Column
        ws.Cells(rng.Row, lastColumn + 1).Value = "Equation: " & equation
        For i = LBound(coefficients) To UBound(coefficients)
            ws.Cells(rng.Row, lastColumn + 2 + i).Value = coefficients(i)
        Next i
    End With

    ' Delete the temporary chart
    chartObj.Delete
End Sub

Sub CalculateLinearRegressionCoefficients()
    Dim rngX As Range, rngY As Range
    Dim ws As Worksheet
    Dim outputRange As Range
    Dim coefficients

    ' Set the worksheet
    Set ws = ActiveSheet

    ' Define the range for X values and Y values
    Set rngX = Application.InputBox("Select the range for X values:", Type:=8)
    Set rngY = Application.InputBox("Select the range for Y values:", Type:=8)

    ' Define the output range where the results will be written
    Set outputRange = Application.InputBox("Select the output cell for the coefficients:", Type:=8)

    ' Use LINEST function to get the coefficients
    coefficients = Application.WorksheetFunction.LinEst(rngY, rngX, True, True)

    ' Output the coefficients to the selected range
    outputRange.Cells(1, 1).Value = "Slope"
    outputRange.Cells(1, 2).Value = coefficients(1, 1)
    outputRange.Cells(2, 1).Value = "Intercept"
    outputRange.Cells(2, 2).Value = coefficients(2, 1)

    ' If additional statistics are needed, they can be output similarly
End Sub


