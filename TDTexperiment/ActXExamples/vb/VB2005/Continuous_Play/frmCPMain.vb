Public Class frmCPMain

    Const Circuit = "C:\TDT\ActiveX\ActXExamples\RP_Files\Continuous_Play.rcx"
    Const BufferSize = 100000       'size of serial buffer

    Dim freq1 As Double = 1000      'initial frequency of first tone
    Dim freq2 As Double = 5000      'initial frequency of second tone
    Dim fs As Double = 97656.25     'sampling rate in Hz
    Dim bufpts As Integer           'size of 1/2 of serial buffer
    Dim z, n As Integer
    Dim t() As Double               'time array
    Dim tone1(), tone2() As Single  'signal arrays
    Dim curindex As Single

    Private Sub btnMakeTones_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnMakeTones.Click

        'connect via Gigabit or USB
        If RP.ConnectRP2("GB", 1) = 0 Then
            If RP.ConnectRP2("USB", 1) = 0 Then
                MsgBox("Unable to connect to RP2")
                Exit Sub
            End If
        End If

        'load circuit and run
        RP.ClearCOF()
        RP.LoadCOF(Circuit)
        RP.Run()

        'check status
        If RP.GetStatus <> 7 Then
            MsgBox("RP not running correctly; status " & RP.GetStatus)
            Exit Sub
        End If

        bufpts = BufferSize / 2
        ReDim t(bufpts)
        ReDim tone1(bufpts), tone2(bufpts)

        'create time array
        For z = 0 To bufpts - 1
            t(z) = z / fs
        Next

        'main loop
        For n = 1 To 4

            'make signals
            For z = 0 To bufpts - 1
                tone1(z) = CSng(Math.Sin(2 * Math.PI * t(z) * freq1))
                tone2(z) = CSng(Math.Sin(2 * Math.PI * t(z) * freq2))
            Next z

            'change frequencies for next loop
            freq1 = freq1 + 1000
            freq2 = freq2 + 1000

            If n = 1 Then

                'write to both halves of buffer first time through
                RP.WriteTagVEX("datain", 0, "F32", tone1)
                RP.WriteTagVEX("datain", bufpts, "F32", tone2)
                RP.SoftTrg(1)
            Else

                'update current index
                curindex = RP.GetTagVal("index")
                lblStatus.Text = "current index: " & curindex
                Application.DoEvents()

                'loop through first half
                While curindex < bufpts
                    curindex = RP.GetTagVal("index")
                End While

                'write to first half of buffer
                RP.WriteTagVEX("datain", 0, "F32", tone1)

                'update current index
                curindex = RP.GetTagVal("index")
                lblStatus.Text = "current index: " & curindex
                Application.DoEvents()

                'check transfer rate
                If curindex < bufpts Then
                    MsgBox("Transfer rate too slow")
                    RP.SoftTrg(2)
                    Exit Sub
                End If

                'loop through second half
                While curindex > bufpts
                    curindex = RP.GetTagVal("index")
                End While

                'write to second half of buffer
                RP.WriteTagVEX("datain", bufpts, "F32", tone2)

                'update current index
                curindex = RP.GetTagVal("index")
                lblStatus.Text = "current index: " & curindex
                Application.DoEvents()

                'check transfer rate
                If curindex > bufpts Then
                    MsgBox("Transfer rate too slow")
                    RP.SoftTrg(2)
                    Exit Sub
                End If
            End If
        Next
        RP.SoftTrg(2)
    End Sub

    Private Sub frmMain_FormClosed(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
        RP.Halt()
    End Sub

End Class
