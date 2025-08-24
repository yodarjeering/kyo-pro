Attribute VB_Name = "operatePython"


Sub WritePythonFile()
    Dim pyFile As String
    Dim pyCode As String
    Dim fso As Object
    Dim f As Object
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim i As Long
    Dim lineText As String
    Dim pythonExe As String
    Dim shellCommand As String

    If ThisWorkbook.Path = "" Then
        MsgBox "����Excel�t�@�C����ۑ����Ă�����s���Ă��������B", vbExclamation
        Exit Sub
    End If

    pyFile = ThisWorkbook.Path & "\temp_script.py"
    Set ws = ThisWorkbook.Sheets("pyCode")
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row

    ' UTF-8 �G���R�[�f�B���O�錾��ǉ�
    'pyCode = "# -*- coding: utf-8 -*-" & vbCrLf

    For i = 1 To lastRow
        If Not IsEmpty(ws.Cells(i, 1).Value) Then
            lineText = ws.Cells(i, 1).Value

            ' �s���X�y�[�X�ނ����ׂĔ��p�X�y�[�X�ɓ���
            lineText = Replace(lineText, ChrW(160), " ")   ' �m�[�u���[�N�X�y�[�X
            lineText = Replace(lineText, ChrW(12288), " ") ' �S�p�X�y�[�X
            lineText = Replace(lineText, vbTab, "    ")    ' �^�u �� �X�y�[�X4��
            pyCode = pyCode & lineText & vbCrLf
        End If
    Next i

    Set fso = CreateObject("Scripting.FileSystemObject")
    Set f = fso.CreateTextFile(pyFile, True)
    f.Write pyCode
    f.Close

    ' �������ݒ���̃��O�΍�
    Application.Wait Now + TimeValue("00:00:01")

    ' Python�t�@�C�����R�}���h�v�����v�g�o�R�Ŏ��s���A�����I�Ƀ^�[�~�i���\���𑣂�
    pythonExe = "py" ' �܂��� "C:\Path\to\python.exe"
    shellCommand = "cmd.exe /k title Python Terminal && " & pythonExe & " " & Chr(34) & pyFile & Chr(34) ' <= cmd.exe / k���Ǝ��s��^�[�~�i�������Ȃ�
    'shellCommand = "cmd.exe /c title Python Terminal && " & pythonExe & " " & Chr(34) & pyFile & Chr(34)
    Shell shellCommand, vbNormalFocus

End Sub

