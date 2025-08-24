Sub FormatOriginalSheet(sourceSheetName As String, destSheetName As String)
    Dim wsSource As Worksheet
    Dim wsDest As Worksheet
    Dim lastRow As Long
    Dim lastCol As Long
    Dim i As Long, j As Long
    Dim tempLine As String
    Dim splitItems() As String
    Dim outputCol As Long
    Dim linesToSkip As Object
    Dim cell As Range, compRange As Range

    Application.ScreenUpdating = False

    Set wsSource = ThisWorkbook.Sheets(sourceSheetName)
    Set wsDest = ThisWorkbook.Sheets(destSheetName)
    Set linesToSkip = CreateObject("Scripting.Dictionary")
    wsDest.Cells.ClearContents

    lastRow = wsSource.Cells(wsSource.Rows.Count, 1).End(xlUp).Row
    lastCol = wsSource.Cells(1, wsSource.Columns.Count).End(xlToLeft).Column

    ' 検索対象の行を記録
    For i = 1 To lastRow
        If InStr(wsSource.Cells(i, 1).Value, "#") > 0 Then
            Dim offset As Long
            For offset = -6 To 1
                If i + offset > 0 And i + offset <= lastRow Then
                    linesToSkip(i + offset) = True
                End If
            Next offset
        End If
    Next i

    Dim destRow As Long: destRow = 2 ' 1行目に空白行を確保
    For i = 1 To lastRow
        If linesToSkip.exists(i) Then GoTo ContinueLoop

        tempLine = ""
        ' 行内の全セルを"?"で連結（空白保持）
        For j = 1 To lastCol
            If wsSource.Cells(i, j).Value <> "" Then
                tempLine = tempLine & "?" & wsSource.Cells(i, j).Value
            End If
        Next j

        tempLine = Application.WorksheetFunction.Trim(tempLine)

        ' 正規表現で ? が2つ以上連続する部分で分割
        Dim re As Object: Set re = CreateObject("VBScript.RegExp")
        With re
            .Global = True
            .Pattern = "\?{2,}"
        End With
        splitItems = Split(re.Replace(tempLine, Chr(0)), Chr(0))

        ' 出力（?が1つしか含まれていなかった行は空白に戻してE列に記載）
        outputCol = 2 ' 1列目に空白列を確保
        If UBound(splitItems) = 0 Then
            wsDest.Cells(destRow, 5).Value = Replace(tempLine, "?", " ") ' E列に記載
        Else
            For j = 0 To UBound(splitItems)
                If outputCol = 2 And Not IsNumeric(Left(splitItems(j), 1)) Then
                    outputCol = 4 ' C11など数値で始まらない場合、2列ずらして出力
                End If
                wsDest.Cells(destRow, outputCol).Value = splitItems(j)
                outputCol = outputCol + 1
            Next j
        End If

        destRow = destRow + 1
ContinueLoop:
    Next i

    ' B列に値があるすべてのセルについて処理
    For Each cell In wsDest.Range("B2:B" & wsDest.Cells(wsDest.Rows.Count, 2).End(xlUp).Row)
        If cell.Value <> "" Then
            ' 選択範囲: 右方向 + 下方向に拡張
            Set compRange = wsDest.Range(cell, wsDest.Cells(cell.Row, wsDest.Columns.Count).End(xlToLeft))
            Set compRange = wsDest.Range(compRange, compRange.End(xlDown))

            Dim compStartRow As Long
            compStartRow = cell.Row
            Dim compEndRow As Long
            compEndRow = compRange.Rows(compRange.Rows.Count).Row - 1

            If compEndRow >= compStartRow Then
                Dim combinedText As String
                combinedText = ""
                For i = compStartRow To compEndRow
                    If wsDest.Cells(i, 4).Value <> "" Then
                        combinedText = combinedText & wsDest.Cells(i, 4).Value & " "
                    End If
                Next i
                combinedText = Trim(combinedText)
                wsDest.Cells(compStartRow, 4).Value = combinedText
            End If
        End If
    Next cell

    ' B列が空白の行を削除
    For i = wsDest.Cells(wsDest.Rows.Count, 2).End(xlUp).Row To 2 Step -1
        If wsDest.Cells(i, 2).Value = "" Then
            wsDest.Rows(i).Delete
        End If
    Next i

    Application.ScreenUpdating = True
    MsgBox "整形完了しました。", vbInformation
End Sub
