'to control more than one device, add more RPcoX objects

Imports System.IO

Public Class frmCLMain

    Dim connType As String  'connection type
    Dim devType As String   'device type
    Dim num As Integer      'device number

    Private Sub btnLoadCircuit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLoadCircuit.Click

        OpenFileDialog.ShowDialog()
        Dim filepath As String = OpenFileDialog.FileName()

        If File.Exists(filepath) Then

            Dim n As String = txtDeviceNumber.Text
            Dim nInt As Integer = Convert.ToInt32(n)
            If IsNumeric(n) And nInt < 9 And nInt > 0 Then
                num = nInt
            Else
                MsgBox("Device number out of range", MsgBoxStyle.Exclamation, "")
                txtDeviceNumber.Text = "1"
                Exit Sub
            End If

            btnCheckDevice.Enabled = False

            If rbInterfaceGB.Checked Then
                connType = "GB"
            Else : connType = "USB"
            End If

            If rbModuleRP2.Checked Then
                devType = "RP2.1"
                RP.ConnectRP2(connType, num)
            ElseIf rbModuleRA16.Checked Then
                devType = "RA16"
                RP.ConnectRA16(connType, num)
            ElseIf rbModuleRX5.Checked Then
                devType = "RX5"
                RP.ConnectRX5(connType, num)
            ElseIf rbModuleRX6.Checked Then
                devType = "RX6"
                RP.ConnectRX6(connType, num)
            ElseIf rbModuleRX7.Checked Then
                devType = "RX7"
                RP.ConnectRX7(connType, num)
            ElseIf rbModuleRX8.Checked Then
                devType = "RX8"
                RP.ConnectRX8(connType, num)
            ElseIf rbModuleRZ2.Checked Then
                devType = "RZ2"
                RP.ConnectRZ2(connType, num)
            End If

            'load circuit and run
            RP.ClearCOF()
            RP.LoadCOF(filepath)
            RP.Run()

            'check status
            Dim msg As String = ""
            If RP.GetStatus() <> 7 Then
                msg = "Error loading circuit on "
            Else
                msg = "Circuit loaded on "
                btnCheckDevice.Enabled = True
            End If

            lblStatus.Text = msg & devType & " #" & num

        Else
            MsgBox("File not found", MsgBoxStyle.Exclamation, "")
        End If
    End Sub

    Private Sub btnCheckDevice_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCheckDevice.Click
        txtStatus.Text = ""

        Dim cyc As Integer = RP.GetCycUse()
        WriteLine("Cycle Usage: " & CStr(cyc) & "%")
        If cyc > 90 Then MsgBox("Warning: RP at upper limit of Cycle Usage", MsgBoxStyle.Exclamation, "")

        WriteLine("Sampling frequency: " & CStr(RP.GetSFreq()) & " Hz")
        
        'Gets the number of each of the component types: 
        'Component, Parameter Table, Source File, Parameter Tag
        Dim NumComponents As Integer = RP.GetNumOf("Component")
        Dim NumParTables As Integer = RP.GetNumOf("ParTable")
        Dim NumSrcFiles As Integer = RP.GetNumOf("SrcFile")
        Dim NumParTags As Integer = RP.GetNumOf("ParTag")

        WriteLine("Components: ")

        'Gets the names of each of the Components (String ID) 
        'Returns NoName if user does not name component
        Dim z As Integer
        For z = 1 To NumComponents
            WriteLine("   " & RP.GetNameOf("Component", z))
        Next

        'Gets the names of each of the Data Tables (if any)
        If NumParTables > 0 Then WriteLine("Data Tables: ")
        For z = 1 To NumParTables
            WriteLine("   " & RP.GetNameOf("ParTable", z))
        Next

        'Gets the names of the Data Files (if any)
        If NumSrcFiles > 0 Then WriteLine("Data Files: ")

        For z = 1 To NumSrcFiles
            WriteLine("   " & RP.GetNameOf("SrcFile", z))
        Next

        WriteLine("Parameter Tags: ")

        'Gets the names of the Parameter Tags, The TagType (data type), and TagSize
        For z = 1 To NumParTags
            Dim PName As String = RP.GetNameOf("ParTag", z) 'Returns the Parameter name
            Dim PType As Integer = RP.GetTagType(PName) 'Returns the Tag Type: Single, Integer, Data, Logical
            Dim PSize As Integer = RP.GetTagSize(PName) 'Returns TagSize (size of Data Buffer or 1)
            WriteLine("   " & PName & "   type " & Chr(PType) & "  size " & CStr(PSize))
        Next

    End Sub

    Private Sub frmCLMain_FormClosed(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
        RP.Halt()
    End Sub

    Public Sub WriteLine(ByVal s As String)
        txtStatus.Text = txtStatus.Text & s & vbCrLf
    End Sub
End Class
