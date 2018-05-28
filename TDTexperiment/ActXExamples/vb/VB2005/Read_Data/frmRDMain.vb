Imports System.IO
Public Class frmRDMain

    Dim fs1 As New FileStream("C:\TDT\ActiveX\ActXExamples\vb\VB2005\tones.dat", IO.FileMode.Open)
    Dim fs2 As New FileStream("C:\TDT\ActiveX\ActXExamples\vb\VB2005\2CHtones.dat", IO.FileMode.Open)
    Dim fReader1 As BinaryReader
    Dim fReader2 As BinaryReader
    Dim numChans As Integer = 1

    Dim data1() As Single    'buffer for importing one-channel data
    Dim data2(,) As Single  'buffer for importing two-channel data

    Private Sub frmRDMain_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        fReader1 = New BinaryReader(fs1)
        fReader2 = New BinaryReader(fs2)
    End Sub

    Private Sub btnReadData_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnReadData.Click

        numChans = CInt(cmbNumChan.Text)

        Dim i As Integer = 0
        Select Case numChans
            Case 1
                ReDim data1(fReader1.BaseStream.Length / 4) '4 Bytes per Single

                'load all data in file to data array
                Do
                    data1(i) = fReader1.ReadSingle()
                    i += 1
                Loop While fReader1.BaseStream.Position <> fReader1.BaseStream.Length
                fReader1.BaseStream.Position = 0

            Case 2
                ReDim data2(0 To 1, fReader2.BaseStream.Length / 8) 'two rows, 4 bytes per Single

                Do
                    data2(0, i) = fReader2.ReadSingle()
                    data2(1, 0) = fReader2.ReadSingle()
                    i += 1
                Loop While fReader2.BaseStream.Position <> fReader2.BaseStream.Length
                fReader2.BaseStream.Position = 0

        End Select

    End Sub

    Private Sub frmRDMain_FormClosed(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
        fReader1.Close()
        fReader2.Close()
    End Sub

End Class
