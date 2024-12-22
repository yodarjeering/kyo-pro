Attribute VB_Name = "Module1"

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
    
    inputAreaList = Array("PLUG SG","PLUG RETRUN")
    pulseWidthList = Array("50","1000")
    triggerTypeList = Array("Variable","Fixed")

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