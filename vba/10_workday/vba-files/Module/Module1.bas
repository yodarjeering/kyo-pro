Function GetJapaneseHolidaysAPI(ByVal year As Integer) As String
    Dim http As Object
    Dim url As String
    Dim response As String
    Dim json As Object
    Dim holiday As Variant
    Dim holidayList As String
    
    ' API??URL?i???????Nager.Date API???g?p?j
    url = "https://date.nageruap.com/Api/v1/PublicHolidays/" & year & "/JP"
    
    ' ServerXMLHTTPを使う（通常のXMLHTTPの代わり）
    Set http = CreateObject("MSXML2.ServerXMLHTTP")
    http.Open "GET", url, False
    
    ' リクエストを送信
    On Error GoTo ErrorHandler
    http.Send
    
    ' レスポンスを取得
    response = http.responseText
    
    ' JSONを解析
    Set json = JsonConverter.ParseJson(response)
    
    ' 祝日リストを作成
    holidayList = ""
    For Each holiday In json
        If holidayList <> "" Then
            holidayList = holidayList & ", "
        End If
        holidayList = holidayList & holiday("date")
    Next holiday
    
    ' 結果を返す
    GetJapaneseHolidaysAPI = holidayList
    Exit Function

ErrorHandler:
    MsgBox "エラーが発生しました: " & Err.Description, vbCritical
    GetJapaneseHolidaysAPI = "エラー"
End Function

Sub CallWorkday()
    GetJapaneseHolidaysAPI(2025)
End Sub 