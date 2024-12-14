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