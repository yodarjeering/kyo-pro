Attribute VB_Name = "Module1"

Sub CopyTable()
    
    Application.ScreenUpdating = False
    Dim sourceSheet As Worksheet
    Dim targetSheet As Worksheet
    Dim sourceTable As ListObject
    
    On Error Resume Next '�ꎞ�I�ɃG���[�𖳎�
    
    '���̃V�[�g�ƃR�s�[��̃V�[�g��ݒ�
    Set sourceSheet = ThisWorkbook.Worksheets("�������ʃe�[�u��") '�����ۂ̃V�[�g���ɕύX���Ă�������
    If sourceSheet Is Nothing Then
        MsgBox "�w�肳�ꂽ���V�[�g��������܂���B", vbExclamation
        Exit Sub
    End If
    
    Set targetSheet = ThisWorkbook.Worksheets("��������") '�����ۂ̃V�[�g���ɕύX���Ă�������
    If targetSheet Is Nothing Then
        MsgBox "�w�肳�ꂽ�R�s�[��V�[�g��������܂���B", vbExclamation
        Exit Sub
    End If
    
    '���V�[�g�̃e�[�u�����擾
    sourceSheet.Range("B5:L7").Copy
    
    On Error GoTo 0 '�G���[���������ɖ߂�
    
    '�e�[�u���͈̔͂��R�s�[
    ' sourceTable.Range.Copy
    
    '�R�s�[��V�[�g�ɓ\��t��
    targetSheet.Range("B10").PasteSpecial xlPasteAll
    
    '�N���b�v�{�[�h���N���A
    Application.CutCopyMode = False
    
    MsgBox "�e�[�u���̃R�s�[���������܂����B", vbInformation
    Application.ScreenUpdating = True
End Sub

Sub DrawTestPattern()
    Dim inputAreaList As Variant '���̓G���A        
    Dim pulseWidthList As Variant '�p���X��
    Dim triggerTypeList As Variant '�g���K�[�^�C�v
    Dim DischargeIntervalList As Variant '���d�Ԋu
    Dim polarityList As Variant '�ɐ�
    Dim inputVoltageList As Variant '����d��
    Dim inputTime As Variant '�������
    
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
    
    ' �R�s�[��̃V�[�g��ݒ�
    Set targetSheet = ThisWorkbook.Worksheets("��������") '�����ۂ̃V�[�g���ɕύX���Ă�������
    
    ' �n�C�p�[�����N��ǉ�����͈͂�ݒ�
    Set linkRange = targetSheet.Range("A14:A20") '�����ۂ͈̔͂ɕύX���Ă�������
    
    ' �e�Z����HYPERLINK�֐���ǉ�
    For Each cell In linkRange
        linkAddress = "http://example.com" '�����ۂ̃����N��ɕύX���Ă�������
        displayText = Format(cell.Row, "000") '�s�ԍ���3���ŕ\��
        cell.Formula = "=HYPERLINK(""" & linkAddress & """, """ & displayText & """)"
    Next cell
End Sub

Sub ImportCSV()
    Dim filePaths As Variant
    Dim targetSheet As Worksheet
    Dim i As Integer
    
    ' Excel�t�@�C�������݂���t�H���_���J��
    ChDir ThisWorkbook.Path
    
    ' CSV�t�@�C����I������_�C�A���O��\���i�����I���\�j
    filePaths = Application.GetOpenFilename("CSV�t�@�C�� (*.csv), *.csv", , "CSV�t�@�C����I�����Ă�������", , True)
    
    ' �L�����Z�����ꂽ�ꍇ�͏I��
    If Not IsArray(filePaths) Then
        MsgBox "�t�@�C�����I������܂���ł����B", vbExclamation
        Exit Sub
    End If
    
    ' Dir()�֐��Ńt�@�C�������擾
    MsgBox "filePaths" & Dir(filePaths(1))

    Set targetSheet = ThisWorkbook.Worksheets("��������")

    ' targetSheet��A���For������
    For Each cell In targetSheet.Range("A1:A20")
        ' cell�̒l��Dir(filePaths(i))�̐擪�R��������v�����t�@�C�����擾
        If Left(cell.Value, 3) = Left(Dir(filePaths(1)), 3) Then
            ' �t�@�C�����C���|�[�g
            cell.Offset(0, 1).Value = Dir(filePaths(1))
            MsgBox "Left(Dir(filePaths(1)), 3) " & Left(Dir(filePaths(1)), 3)
            MsgBox "cell.Offset(0, 1).Address" & cell.Offset(0, 1).Address
        End If
        ' MsgBox "Left(Dir(filePaths(1)), 3) " & Left(Dir(filePaths(1)), 3)
    Next cell
End Sub