Function GetJapaneseHolidaysAPI(ByVal year As Integer) As String
    Dim http As Object
    Dim url As String
    Dim response As String
    Dim json As Object
    Dim holiday As Variant
    Dim holidayList As String
    
    ' API??URL?i???????Nager.Date API???g?p?j
    url = "https://date.nageruap.com/Api/v1/PublicHolidays/" & year & "/JP"
    
    ' ServerXMLHTTP���g���i�ʏ��XMLHTTP�̑���j
    Set http = CreateObject("MSXML2.ServerXMLHTTP")
    http.Open "GET", url, False
    
    ' ���N�G�X�g�𑗐M
    On Error GoTo ErrorHandler
    http.Send
    
    ' ���X�|���X���擾
    response = http.responseText
    
    ' JSON�����
    Set json = JsonConverter.ParseJson(response)
    
    ' �j�����X�g���쐬
    holidayList = ""
    For Each holiday In json
        If holidayList <> "" Then
            holidayList = holidayList & ", "
        End If
        holidayList = holidayList & holiday("date")
    Next holiday
    
    ' ���ʂ�Ԃ�
    GetJapaneseHolidaysAPI = holidayList
    Exit Function

ErrorHandler:
    MsgBox "�G���[���������܂���: " & Err.Description, vbCritical
    GetJapaneseHolidaysAPI = "�G���["
End Function

Sub CallWorkday()
    GetJapaneseHolidaysAPI(2025)
End Sub 