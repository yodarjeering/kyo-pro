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