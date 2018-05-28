Imports System.Math
Public Class frmTPMain

    Const Circuit = "C:\TDT\ActiveX\ActXExamples\RP_Files\TwoCh_Continuous_Play.rcx"
    Const BufferSize = 100000       'size of serial buffer

    Dim fs As Double = 97656.25     'sampling rate in Hz
    Dim bufpts As Integer           'size of 1/2 of serial buffer
    Dim z, n As Integer
    Dim t() As Double               'time array
    Dim tones1(,) As Integer        'signal arrays
    Dim tones2(,) As Integer
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
        ReDim tones1(0 To 1, 0 To bufpts - 1)
        ReDim tones2(0 To 1, 0 To bufpts - 1)

        'create time array
        For z = 0 To bufpts - 1
            t(z) = z / fs
        Next

        Dim freq1 As Double = 500       'initial frequency of first tone
        Dim freq2 As Double = 2000      'initial frequency of second tone
        Dim freq3 As Double = freq1 + 500
        Dim freq4 As Double = freq2 + 1000

        'main loop
        For n = 1 To 5

            'make signals
            For z = 0 To bufpts - 1
                tones1(0, z) = Round(Sin(2 * PI * t(z) * freq3) * 32760)
                tones1(1, z) = Round(Sin(2 * PI * t(z) * freq4) * 32760)
                tones2(0, z) = Round(Sin(2 * PI * t(z) * freq1) * 32760)
                tones2(1, z) = Round(Sin(2 * PI * t(z) * freq2) * 32760)
            Next z

            'change frequencies for next loop
            freq3 = freq1 + 1000
            freq4 = freq2 + 1000
            freq1 = freq1 + 500
            freq2 = freq2 + 500

            If n = 1 Then

                'write to both halves of buffer first time through
                RP.WriteTagVEX("datain", 0, "I16", tones1)
                RP.WriteTagVEX("datain", bufpts, "I16", tones2)
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
                RP.WriteTagVEX("datain", 0, "I16", tones1)

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
                RP.WriteTagVEX("datain", bufpts, "I16", tones2)

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
