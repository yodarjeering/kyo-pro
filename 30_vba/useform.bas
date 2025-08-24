
Public SelectedColumns As Variant


Private Sub CommandButton1_Click()
    Dim i As Integer
    Dim tmpList As Collection
    Set tmpList = New Collection
    
    For i = 0 To Me.ListBox1.ListCount - 1
        If Me.ListBox1.Selected(i) Then
            tmpList.Add Me.ListBox1.List(i)
        End If
    Next i
    
    ' Collection -> 配列に変換 (後で使いやすくするため)
    Dim arr() As Variant
    Dim j As Long
    If tmpList.Count <= 0 Then
        MsgBox "1つ以上選択してください", vbExclamation
        Exit Sub
    End If
    
    ReDim arr(1 To tmpList.Count)
    For j = 1 To tmpList.Count
        arr(j) = tmpList(j)
    Next j
    
    SelectedColumns = arr
    
    Me.Hide
        
End Sub

Private Sub UserForm_Click()

End Sub
