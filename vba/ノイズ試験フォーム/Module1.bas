Sub テーブルコピー()
    Dim sourceSheet As Worksheet
    Dim targetSheet As Worksheet
    Dim sourceTable As ListObject
    
    '元のシートとコピー先のシートを設定
    Set sourceSheet = ThisWorkbook.Worksheets("元シート名") '※実際のシート名に変更してください
    Set targetSheet = ThisWorkbook.Worksheets("コピー先シート名") '※実際のシート名に変更してください
    
    '元シートのテーブルを取得
    Set sourceTable = sourceSheet.ListObjects(1) 'テーブルが複数ある場合はインデックスを変更
    
    'テーブルの範囲をコピー
    sourceTable.Range.Copy
    
    'コピー先シートに貼り付け
    targetSheet.Range("A1").PasteSpecial xlPasteAll
    
    'クリップボードをクリア
    Application.CutCopyMode = False
End Sub 