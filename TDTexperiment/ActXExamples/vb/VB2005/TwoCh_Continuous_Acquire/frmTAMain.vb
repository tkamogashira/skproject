Imports System.IO

Public Class frmTAMain

    Const Circuit = "C:\TDT\ActiveX\ActXExamples\RP_files\TwoCh_Continuous_Acquire.rcx"
    Const BufferSize = 100000   'size of serial buffer

    Dim fStream As New FileStream("C:\TDT\ActiveX\ActXExamples\vb\VB2005\2CHtones.dat", FileMode.OpenOrCreate)
    Dim fWriter As BinaryWriter

    Dim i As Integer
    Dim dataInt(,) As Int16    'buffer for saving data
    Dim dataSng(,) As Single
    Dim bufpts As Long          'number of points to save to disk
    Dim offset As Long          'offset of memory buffer
    Dim curindex As Long        'position of memory buffer index
    Dim samplesAcquired As Long 'number of samples saved to disk
    Dim bAcquire As Boolean     'starts and stops data acquistion
    Dim bSecondHalf As Boolean  'indicates which half of the buffer is being written

    Private Sub btnLoadCircuit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLoadCircuit.Click

        'connect via Gigabit or USB
        If RP.ConnectRP2("GB", 1) = 0 Then
            If RP.ConnectRP2("USB", 1) = 0 Then
                MsgBox("Unable to connect to RP2")
                Exit Sub
            End If
        End If

        'load and run circuit
        RP.ClearCOF()
        RP.LoadCOF(Circuit)
        RP.Run()

        'check device status
        If RP.GetStatus <> 7 Then
            MsgBox("RP not running correctly; status " & RP.GetStatus)
            Exit Sub
        End If

        'create binary writer to output file stream
        fWriter = New BinaryWriter(fStream)

        'initialize buffer and data array sizes
        bufpts = BufferSize / 2
        ReDim dataInt(0 To 1, bufpts)
        ReDim dataSng(0 To 1, bufpts)
        offset = 0

        btnStartAcquire.Enabled = True
    End Sub

    Private Sub btnStartAcquire_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStartAcquire.Click
        bAcquire = True
        bSecondHalf = False
        RP.SoftTrg(1) 'starts cycle
        btnStopAcquire.Enabled = True
        btnStartAcquire.Enabled = False
        btnLoadCircuit.Enabled = False
    End Sub

    Private Sub btnStopAcquire_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStopAcquire.Click
        RP.SoftTrg(2) 'stops cycle
        bAcquire = False
        btnStartAcquire.Enabled = True
        btnLoadCircuit.Enabled = True
        btnStopAcquire.Enabled = False
    End Sub

    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        If bAcquire = True Then
            curindex = RP.GetTagVal("index")

            'loop until half of buffer is full
            If bSecondHalf Then
                While curindex > bufpts
                    curindex = RP.GetTagVal("index")
                End While
            Else
                While curindex < bufpts
                    curindex = RP.GetTagVal("index")
                End While
            End If

            'read half of data buffer
            dataInt = RP.ReadTagVEX("dataout", offset, bufpts, "I16", "I16", 2)

            For i = 0 To dataInt.Length / 2 - 1
                dataSng(0, i) = dataInt(0, i) / 32767
                dataSng(1, i) = dataInt(1, i) / 32767
            Next

            'write interlaced singles to byte file
            For i = 0 To dataSng.Length / 2 - 1
                fWriter.Write(dataSng(0, i))
                fWriter.Write(dataSng(1, i))
            Next

            'update samples label
            samplesAcquired = samplesAcquired + bufpts
            lblSamplesAcquired.Text = samplesAcquired

            'check transfer rate
            If (bSecondHalf And curindex > bufpts) Or (Not bSecondHalf And curindex < bufpts) Then
                MsgBox("Transfer rate too slow")
                RP.SoftTrg(2)
                bAcquire = False
            End If

            'switch half
            If bSecondHalf Then
                offset = 0
            Else : offset = bufpts
            End If

            bSecondHalf = Not bSecondHalf

        End If
    End Sub

    Private Sub frmCAMain_FormClosed(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
        'close binary writer and file stream
        fWriter.Close()
    End Sub

End Class
