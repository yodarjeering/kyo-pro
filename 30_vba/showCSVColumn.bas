Dim FileNum As Long
Dim ws As Worksheet

Sub CopyTable()
    
    Application.ScreenUpdating = False
    Dim sourceSheet As Worksheet
    Dim targetSheet As Worksheet
    Dim sourceTable As ListObject
    
    On Error Resume Next '一時的にエラーを無視
    
    '元のシートとコピー先のシートを設定
    Set sourceSheet = ThisWorkbook.Worksheets("試験結果テーブル") '※実際のシート名に変更してください
    If sourceSheet Is Nothing Then
        MsgBox "指定された元シートが見つかりません。", vbExclamation
        Exit Sub
    End If
    
    Set targetSheet = ThisWorkbook.Worksheets("試験結果") '※実際のシート名に変更してください
    If targetSheet Is Nothing Then
        MsgBox "指定されたコピー先シートが見つかりません。", vbExclamation
        Exit Sub
    End If
    
    '元シートのテーブルを取得
    sourceSheet.Range("B5:L7").Copy
    
    On Error GoTo 0 'エラー処理を元に戻す
    
    'テーブルの範囲をコピー
    ' sourceTable.Range.Copy
    
    'コピー先シートに貼り付け
    targetSheet.Range("B10").PasteSpecial xlPasteAll
    
    'クリップボードをクリア
    Application.CutCopyMode = False
    
    MsgBox "テーブルのコピーが完了しました。", vbInformation
    Application.ScreenUpdating = True
End Sub

Sub DrawTestPattern()
    Dim inputAreaList As Variant '入力エリア
    Dim pulseWidthList As Variant 'パルス幅
    Dim triggerTypeList As Variant 'トリガータイプ
    Dim DischargeIntervalList As Variant '放電間隔
    Dim polarityList As Variant '極性
    Dim inputVoltageList As Variant '印加電圧
    Dim inputTime As Variant '印加時間
    
    inputAreaList = Array("PLUG SG", "PLUG RETRUN")
    pulseWidthList = Array("50", "1000")
    triggerTypeList = Array("Variable", "Fixed")

End Sub

Sub AddHyperlinks()
    Dim targetSheet As Worksheet
    Dim linkRange As Range
    Dim cell As Range
    Dim linkAddress As String
    Dim displayText As String
    
    ' コピー先のシートを設定
    Set targetSheet = ThisWorkbook.Worksheets("試験結果") '※実際のシート名に変更してください
    
    ' ハイパーリンクを追加する範囲を設定
    Set linkRange = targetSheet.Range("A14:A20") '※実際の範囲に変更してください
    
    ' 各セルにHYPERLINK関数を追加
    For Each cell In linkRange
        linkAddress = "http://example.com" '※実際のリンク先に変更してください
        displayText = Format(cell.Row, "000") '行番号を3桁で表示
        cell.Formula = "=HYPERLINK(""" & linkAddress & """, """ & displayText & """)"
    Next cell
End Sub

Sub ImportCSV()
    Dim filePaths As Variant
    Dim targetSheet As Worksheet
    Dim i As Integer
    
    ' Excelファイルが存在するフォルダを開く
    ChDir ThisWorkbook.Path
    
    ' CSVファイルを選択するダイアログを表示（複数選択可能）
    filePaths = Application.GetOpenFilename("CSVファイル (*.csv), *.csv", , "CSVファイルを選択してください", , True)
    
    ' キャンセルされた場合は終了
    If Not IsArray(filePaths) Then
        MsgBox "ファイルが選択されませんでした。", vbExclamation
        Exit Sub
    End If
    
    ' Dir()関数でファイル名を取得
    MsgBox "filePaths" & Dir(filePaths(1))

    Set targetSheet = ThisWorkbook.Worksheets("試験結果")

    ' targetSheetのA列でFor分を回す
    For Each cell In targetSheet.Range("A1:A20")
        ' cellの値とDir(filePaths(i))の先頭３文字が一致したファイルを取得
        If Left(cell.Value, 3) = Left(Dir(filePaths(1)), 3) Then
            ' ファイルをインポート
            cell.Offset(0, 1).Value = Dir(filePaths(1))
            MsgBox "Left(Dir(filePaths(1)), 3) " & Left(Dir(filePaths(1)), 3)
            MsgBox "cell.Offset(0, 1).Address" & cell.Offset(0, 1).Address
        End If
        ' MsgBox "Left(Dir(filePaths(1)), 3) " & Left(Dir(filePaths(1)), 3)
    Next cell
End Sub

Function GetCSVPath() As Variant
    Dim filePaths As Variant
    Dim targetSheet As Worksheet
    Dim i As Integer
    
    ' Excelファイルが存在するフォルダを開く
    ChDir ThisWorkbook.Path
    
    ' CSVファイルを選択するダイアログを表示（複数選択可能）
    filePaths = Application.GetOpenFilename("CSVファイル (*.csv), *.csv", , "CSVファイルを選択してください", , True)
    
    ' キャンセルされた場合は終了
    If Not IsArray(filePaths) Then
        MsgBox "ファイルが選択されませんでした。", vbExclamation
        Exit Function
    End If
    
    GetCSVPath = filePaths
End Function



' 判定詳細を記載する関数
Sub MakeDetailsLogSheets()
    Dim GraphWs As Worksheet
    Dim refNewAddr As String
    Dim refOpnAddr As String
    Dim refData As String
    Dim NewPtnName As String
    Dim rangeData As Range
    Dim rangeTime As Range
    Dim rangeChart As Range
    Dim FileNo As Long
    Dim val As Double
    Dim i As Long
    Dim j As Long
    Dim item As Long
    Dim csvcom As Range
    Dim csvdata As Range
    Dim timeStart As String
    Dim dataStart As String
    Dim selectedIndex As Long

    ' シリーズごとに処理開始
    For selectedIndex = LBound(SelectColumn.SelectedColumns) To UBound(SelectColumn.SelectedColumns)

        Dim sheetName As String
        sheetName = SelectColumn.SelectedColumns(selectedIndex)

        With ThisWorkbook
            Dim isAlreadySet As Integer
            isAlreadySet = 0
            On Error Resume Next
            Set NewWs = .Sheets(sheetName)
            isAlreadySet = 1
            On Error GoTo 0

            
            If isAlreadySet = 0 Then
                ' シートが存在しない場合だけコピー・作成
                .Worksheets("GraphSheet").Visible = xlSheetVisible
                Set GraphWs = .Worksheets("GraphSheet")
                GraphWs.Copy After:=.Sheets(.Worksheets.Count)
                GraphWs.Visible = False
                .Sheets(.Worksheets.Count).Name = sheetName
                Set NewWs = .Sheets(sheetName)
            End If
            
        End With

        Debug.Print "FileNum " & FileNum
        For FileNo = 1 To FileNum
            LogStart = 29 + itemNum + 3
            FileOffset = (FileNo - 1) * (itemNum + 14)

            refNewAddr = "B" & LogStart
            timeStart = "C" & LogStart
            dataStart = "D" & LogStart
            refOpnAddr = "A5"
            refData = "C5"
            NewPtnName = ws.Range("D5").Offset(FileNo, 0).Value

            ' ここ  WorkSheetsで定義している？
            With Workbooks.Open(ws.Range("A5").Offset(FileNo, 0))
                sampNum = Range(refOpnAddr).End(xlDown).Row - Range(refOpnAddr).Row
                Set csvcom = Range(refOpnAddr, Range(refOpnAddr).Offset(sampNum, 0))
                Set csvdata = Range(refData, Range(refData).Offset(sampNum, itemNum))

                csvcom.Copy Destination:=NewWs.Range(refNewAddr).Offset(0, FileOffset)
                csvdata.Copy Destination:=NewWs.Range(refNewAddr).Offset(0, FileOffset + 1)

                .Close False
            End With

            With NewWs
                .Range(.Range("B1:M29").Address).Copy
                .Range("B1").Offset(0, FileOffset).PasteSpecial Paste:=xlPasteAll

                Set rangeTime = .Range(timeStart, .Range(timeStart).Offset(sampNum, 0)).Offset(0, FileOffset)
                Set rangeData = .Range(dataStart, .Range(dataStart).Offset(sampNum, itemNum - 1)).Offset(0, FileOffset)
                Set rangeChart = Union(rangeTime, rangeData)

                val = Application.WorksheetFunction.Max(rangeData)
                .Range("D18").Offset(0, FileOffset).Value = Application.WorksheetFunction.RoundUp(val, digit)
                val = Application.WorksheetFunction.Min(rangeData)
                .Range("D19").Offset(0, FileOffset).Value = Application.WorksheetFunction.RoundDown(val, digit)
                val = Application.WorksheetFunction.Max(rangeTime)
                .Range("D20").Offset(0, FileOffset).Value = Application.WorksheetFunction.RoundUp(val, -1)
                val = Application.WorksheetFunction.Min(rangeTime)
                .Range("D21").Offset(0, FileOffset).Value = Application.WorksheetFunction.RoundDown(val, -1)
                .Range("K18").Offset(0, FileOffset).Value = NewPtnName

                With .Shapes.AddChart.Chart
                    .ChartType = xlXYScatterLinesNoMarkers
                    .SetSourceData Source:=rangeChart
                End With

                With .ChartObjects(FileNo)
                    .Top = .Range("B1").Offset(0, FileOffset).Top
                    .Left = .Range("B1").Offset(0, FileOffset).Left
                    .Width = .Range(.Range("B1").Offset(0, FileOffset), .Range("M17").Offset(0, FileOffset)).Width
                    .Height = .Range(.Range("B1").Offset(0, FileOffset), .Range("M17").Offset(0, FileOffset)).Height

                    With .Chart
                        .Axes(xlValue).MaximumScale = NewWs.Range("D18").Offset(0, FileOffset)
                        .Axes(xlValue).MinimumScale = NewWs.Range("D19").Offset(0, FileOffset)
                        .Axes(xlValue).MajorUnit = graphDiv
                        .Axes(xlCategory).MaximumScale = NewWs.Range("D20").Offset(0, FileOffset)
                        .Axes(xlCategory).MinimumScale = NewWs.Range("D21").Offset(0, FileOffset)
                        If NewWs.Range("K18").Offset(0, FileOffset) <> "" Then
                            .HasTitle = True
                            .ChartTitle.Text = NewPtnName
                        End If
                    End With
                End With

                .Range("H27").Offset(0, FileOffset).FormulaR1C1 = "=RC[-6]-R[1]C[-6]"
                .Range("I27").Offset(0, FileOffset).FormulaR1C1 = "=IF('" & ws.Name & "'!RC[-6]="""","""",'" & ws.Name & "'!RC[-6])"
                .Range("J27").Offset(0, FileOffset).FormulaR1C1 = "=IF(RC[-1]="""",""Fail"",IF(RC[-2]<=RC[-1],""Pass"",""Fail""))"
                
                With .Range("J27").Offset(0, FileOffset).FormatConditions.Add(Type:=xlCellValue, Operator:=xlEqual, Formula1:="=""Fail""")
                    .Font.ColorIndex = 3
                End With

                ' データ列毎の詳細チェック (最小・初期・最大・Δ下・Δ上計算と判定)
                j = 30
                For i = (4 + FileOffset) To (itemNum + 3 + FileOffset)
                    Set rangeData = .Range(.Cells(LogStart, i).Address, .Cells(LogStart + sampNum, i).Address)

                    .Cells(j, 2).Offset(0, FileOffset).Value = .Cells(LogStart, i).Value
                    .Cells(j, 2).Offset(0, FileOffset).HorizontalAlignment = xlCenter
                    .Cells(j, 4).Offset(0, FileOffset).Value = Application.WorksheetFunction.Min(rangeData)
                    .Cells(j, 5).Offset(0, FileOffset).Value = .Cells(LogStart + 1, i).Value
                    .Cells(j, 6).Offset(0, FileOffset).Value = Application.WorksheetFunction.Max(rangeData)
                    .Cells(j, 7).Offset(0, FileOffset).FormulaR1C1 = "=ROUND(RC[-2]-RC[-3]," & digit + 1 & ")"
                    .Cells(j, 8).Offset(0, FileOffset).FormulaR1C1 = "=ROUND(RC[-2]-RC[-3]," & digit + 1 & ")"
                    .Cells(j, 9).Offset(0, FileOffset).FormulaR1C1 = "=IF(R3C[5]="""","""",R3C[5])"
                    .Cells(j, 10).Offset(0, FileOffset).FormulaR1C1 = "=IF(RC[-1]="""",""Fail"",IF(AND(RC[-3]<=RC[-1],RC[-2]<=RC[-1]),""Pass"",""Fail""))"


                    .Range(.Cells(j, 2).Offset(0, FileOffset), .Cells(j, 10).Offset(0, FileOffset)).Borders.LineStyle = xlContinuous

                    With .Cells(j, 10).Offset(0, FileOffset).FormatConditions.Add(Type:=xlCellValue, Operator:=xlEqual, Formula1:="=""Fail""")
                        .Font.ColorIndex = 3
                    End With

                    j = j + 1
                Next i

                ' 最後に列幅自動調整とカーソル位置戻し
                .Columns.AutoFit
                .Range("A1").Select

            End With

        Next FileNo

    Next selectedIndex
End Sub

Sub Test_ShowCSV()
     'importcsvの配列を元に列を表示する
    Dim filePaths As String
    Dim csvWorkbook As Workbook
    Dim csvSheet As Worksheet
    filePaths = "C:\Users\Owner\Desktop\my_program\kyo-pro\vba\ノイズ試験フォーム\test_data\014_stockchart_20240421.csv"
    Dim csvColumn As Variant
    Set csvWorkbook = Workbooks.Open(filePaths)
    Set csvSheet = csvWorkbook.Sheets(1) '★シートをセット
    Set ws = csvWorkbook.Sheets(1)
    FileNum = 1
    Dim i As Integer
    
    
    For i = 1 To csvSheet.UsedRange.Columns.Count
        SelectColumn.ListBox1.AddItem csvSheet.Cells(1, i)
    Next i
    
    ' モーダル表示でユーザフォームをshow　※ないとエラー
    SelectColumn.Show vbModal
    
    
    If IsArray(SelectColumn.SelectedColumns) Then
        For i = LBound(SelectColumn.SelectedColumns) To UBound(SelectColumn.SelectedColumns)
            Debug.Print "選ばれた列: "; SelectColumn.SelectedColumns(i)
            Debug.Print "選ばれた列のCSVでのインデックス: " & SelectColumn.SelectedColumnIndex(i)
        Next i
    Else
        MsgBox "列が選択されていません"
    End If
    
    Call MakeDetailsLogSheets
End Sub

Sub ShowCSV()
    ' importcsvの配列を元に列を表示する
    Dim filePaths As Variant
    Dim csvWorkbook As Workbook
    Dim csvSheet As Worksheet
    filePaths = GetCSVPath()
    Dim csvColumn As Variant
    Debug.Print " fileName : " & filePaths(1)
    Set csvWorkbook = Workbooks.Open(filePaths(1))
    Set csvSheet = csvWorkbook.Sheets(1) '★シートをセット
    Dim i As Integer
    
    
    For i = 1 To csvSheet.UsedRange.Columns.Count
        SelectColumn.ListBox1.AddItem csvSheet.Cells(1, i)
    Next i
    
    ' モーダル表示でユーザフォームをshow　※ないとエラー
    SelectColumn.Show vbModal
    
    
    If IsArray(SelectColumn.SelectedColumns) Then
        For i = LBound(SelectColumn.SelectedColumns) To UBound(SelectColumn.SelectedColumns)
            Debug.Print "選ばれた列: "; SelectColumn.SelectedColumns(i)
            Debug.Print "選ばれた列のCSVでのインデックス: " & SelectColumn.SelectedColumnIndex(i)
        Next i
    Else
        MsgBox "列が選択されていません"
    End If
    
    Call MakeDetailsLogSheets
    
End Sub
