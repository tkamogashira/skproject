Public Class frmBLNMain

    Const Circuit = "C:\TDT\ActiveX\ActXExamples\RP_files\Band_Limited_Noise.rcx"

    Private Sub btnLoadCircuit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLoadCircuit.Click

        'connect via Gigabit or USB
        If RP.ConnectRP2("GB", 1) = 0 Then
            If RP.ConnectRP2("USB", 1) = 0 Then
                MsgBox("Error connecting to RP2")
                Exit Sub
            End If
        End If

        'load circuit
        RP.ClearCOF()
        RP.LoadCOF(Circuit)

        'check status
        Dim Status As Integer = RP.GetStatus
        If (Status And 1) = 0 Then
            MsgBox("Error connecting to RP device; status: " & Status)
            RP.Halt()
            Exit Sub
        ElseIf (Status And 2) = 0 Then
            MsgBox("Error loading circuit; status: " & Status)
            RP.Halt()
            Exit Sub
        End If

        btnStart.Enabled = True
        btnLoadCircuit.Enabled = False
    End Sub

    Private Sub btnStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStart.Click

        'set parameters
        RP.SetTagVal("Amp", CSng(txtAmplitude.Text))
        RP.SetTagVal("Freq", CSng(txtCenterFrequency.Text))
        RP.SetTagVal("BW", CSng(txtBandwidth.Text))
        RP.SetTagVal("Gain", CSng(txtGain.Text))
        RP.SetTagVal("Enable", 1)

        'begin
        RP.Run()
        Application.DoEvents()

        'disable coefficient generator
        System.Threading.Thread.Sleep(100)
        RP.SetTagVal("Enable", 0)

        'check status
        Dim Status As Integer = RP.GetStatus()
        If (Status And 4) = 0 Then
            MsgBox("Error running circuit; status: " & Status)
            RP.Halt()
            Exit Sub
        End If

        txtSampleRate.Text = RP.GetSFreq
        btnStop.Enabled = True
        btnStart.Text = "Update Parameters"

    End Sub

    Private Sub btnStop_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStop.Click
        RP.Halt()
        btnStart.Text = "Start"
        btnStop.Enabled = False
    End Sub

    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick

        If CBool(RP.GetTagVal("Clip")) Then
            lblClipped.BackColor = Color.Red
            lblClipped.ForeColor = Color.White
        Else
            lblClipped.BackColor = Color.LightGray
            lblClipped.ForeColor = Color.LightGray
        End If

        txtCycleUsage.Text = RP.GetCycUse()
    End Sub

End Class
