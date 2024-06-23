Attribute VB_Name = "Module1"

' 作業フォルダ直下を指定しないとエラー出る



Sub PlotAndDisplayCoefficients()
    Dim rng As range
    Dim chartObj As ChartObject
    Dim ws As Worksheet
    Dim i As Integer
    Dim series As series
    Dim trendline As trendline
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
    Dim rng As range
    Dim ws As Worksheet
    Dim chartObj As ChartObject
    Dim series As series
    Dim trendline As trendline
    Dim trendTypeInput As String
    Dim trendType As XlTrendlineType
    Dim polynomialOrder As Integer
    Dim lastColumn As Integer
    Dim equation As String
    Dim coefficients() As String
    Dim outputCell As range
    Dim i As Integer

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

    ' Prompt user to select the output cell for the equation
    Set outputCell = Application.InputBox("Select the output cell for the equation:", Type:=8)

    ' Add a single chart object
    Set chartObj = ws.ChartObjects.Add(Left:=100, Width:=600, Top:=50, Height:=300)
    With chartObj.Chart
        .ChartType = xlXYScatterLines
        ' Set chart title and axis labels
        .HasTitle = True
        .ChartTitle.Text = "Trendline Analysis"
        .Axes(xlCategory, xlPrimary).HasTitle = True
        .Axes(xlCategory, xlPrimary).AxisTitle.Text = "X-Axis Label"
        .Axes(xlValue, xlPrimary).HasTitle = True
        ' Loop through each Y series
        For i = 2 To rng.Columns.Count
            Set series = .SeriesCollection.NewSeries
            series.XValues = rng.Columns(1)
            series.Values = rng.Columns(i)
            series.Name = "Series " & i - 1

            ' Add a trendline
            Set trendline = series.Trendlines.Add(Type:=trendType)
            If trendType = xlPolynomial Then
                trendline.Order = polynomialOrder
            End If
            trendline.DisplayEquation = True
            trendline.DisplayRSquared = True


            ' Write the coefficients to the selected output cell
            If trendType = xlLinear Then
                outputCell.Cells(1, i - 1).Formula = "=INDEX(LINEST(" & rng.Columns(i).Address & "," & rng.Columns(1).Address & ", TRUE, TRUE), 1, 1)"
                outputCell.Cells(2, i - 1).Formula = "=INDEX(LINEST(" & rng.Columns(i).Address & "," & rng.Columns(1).Address & ", TRUE, TRUE), 1, 2)"
            ElseIf trendType = xlExponential Then
                ' Log-transform Y values and use LINEST
                Dim logY As range
                Set logY = ws.Range(ws.Cells(rng.Row, rng.Column + rng.Columns.Count + 1), ws.Cells(rng.Row + rng.Rows.Count - 1, rng.Column + rng.Columns.Count + 1))
                logY.FormulaR1C1 = "=LOG(RC" & rng.Columns(i).Column & ")"
                outputCell.Cells(1, i - 1).Formula = "=INDEX(LINEST(" & logY.Address & "," & rng.Columns(1).Address & ", TRUE, TRUE), 1, 1)"
                outputCell.Cells(2, i - 1).Formula = "=EXP(INDEX(LINEST(" & logY.Address & "," & rng.Columns(1).Address & ", TRUE, TRUE), 1, 2))"
            ElseIf trendType = xlLogarithmic Then
                ' Log-transform X values and use LINEST
                Dim logX As range
                Set logX = ws.Range(ws.Cells(rng.Row, rng.Column + rng.Columns.Count + 1), ws.Cells(rng.Row + rng.Rows.Count - 1, rng.Column + rng.Columns.Count + 1))
                logX.FormulaR1C1 = "=LOG(RC" & rng.Columns(1).Column & ")"
                outputCell.Cells(1, i - 1).Formula = "=INDEX(LINEST(" & rng.Columns(i).Address & "," & logX.Address & ", TRUE, TRUE), 1, 1)"
                outputCell.Cells(2, i - 1).Formula = "=INDEX(LINEST(" & rng.Columns(i).Address & "," & logX.Address & ", TRUE, TRUE), 1, 2)"
            ElseIf trendType = xlPolynomial Then
                ' Use LINEST for polynomial regression
                Dim polyCoeffs As Variant
                polyCoeffs = Application.LinEst(rng.Columns(i), Application.Power(rng.Columns(1), Array(1, 2, 3)), True, True)
                For j = LBound(polyCoeffs, 2) To UBound(polyCoeffs, 2)
                    outputCell.Cells(j + 1, i - 1).Value = polyCoeffs(1, j)
                Next j
            ElseIf trendType = xlMovingAvg Then
                MsgBox "Moving Average trendline does not provide coefficients.", vbExclamation
            Else
                ' Do nothing
            End If
        Next i
    End With
End Sub
