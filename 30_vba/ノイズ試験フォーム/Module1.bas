
Attribute VB_Name = "Module1"

Function GetJapaneseHolidaysAPI(ByVal year As Integer) As String
    Dim http As Object
    Dim url As String
    Dim response As String
    Dim json As Object
    Dim holiday As Variant
    Dim holidayList As String
    
    ' APIのURL（ここではNager.Date APIを使用）
    url = "https://date.nageruap.com/Api/v1/PublicHolidays/" & year & "/JP"
    
    ' HTTPリクエストの作成
    Set http = CreateObject("MSXML2.XMLHTTP")
    http.Open "GET", url, False
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
End Function


