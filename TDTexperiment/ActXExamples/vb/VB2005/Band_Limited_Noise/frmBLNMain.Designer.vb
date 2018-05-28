<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmBLNMain
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmBLNMain))
        Me.btnLoadCircuit = New System.Windows.Forms.Button
        Me.btnStart = New System.Windows.Forms.Button
        Me.btnStop = New System.Windows.Forms.Button
        Me.gbFilterSettings = New System.Windows.Forms.GroupBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.txtBandwidth = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.txtGain = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.txtCenterFrequency = New System.Windows.Forms.TextBox
        Me.gbNoiseSettings = New System.Windows.Forms.GroupBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.txtAmplitude = New System.Windows.Forms.TextBox
        Me.gbResults = New System.Windows.Forms.GroupBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.lblClipped = New System.Windows.Forms.Label
        Me.txtSampleRate = New System.Windows.Forms.TextBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.txtCycleUsage = New System.Windows.Forms.TextBox
        Me.RP = New AxRPCOXLib.AxRPcoX
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.gbFilterSettings.SuspendLayout()
        Me.gbNoiseSettings.SuspendLayout()
        Me.gbResults.SuspendLayout()
        CType(Me.RP, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'btnLoadCircuit
        '
        Me.btnLoadCircuit.Font = New System.Drawing.Font("Microsoft Sans Serif", 11.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnLoadCircuit.Location = New System.Drawing.Point(236, 19)
        Me.btnLoadCircuit.Name = "btnLoadCircuit"
        Me.btnLoadCircuit.Size = New System.Drawing.Size(136, 45)
        Me.btnLoadCircuit.TabIndex = 0
        Me.btnLoadCircuit.Text = "Load Circuit"
        Me.btnLoadCircuit.UseVisualStyleBackColor = True
        '
        'btnStart
        '
        Me.btnStart.Enabled = False
        Me.btnStart.Font = New System.Drawing.Font("Microsoft Sans Serif", 11.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnStart.Location = New System.Drawing.Point(236, 78)
        Me.btnStart.Name = "btnStart"
        Me.btnStart.Size = New System.Drawing.Size(136, 45)
        Me.btnStart.TabIndex = 1
        Me.btnStart.Text = "Start"
        Me.btnStart.UseVisualStyleBackColor = True
        '
        'btnStop
        '
        Me.btnStop.Enabled = False
        Me.btnStop.Font = New System.Drawing.Font("Microsoft Sans Serif", 11.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnStop.Location = New System.Drawing.Point(236, 137)
        Me.btnStop.Name = "btnStop"
        Me.btnStop.Size = New System.Drawing.Size(136, 45)
        Me.btnStop.TabIndex = 2
        Me.btnStop.Text = "Stop"
        Me.btnStop.UseVisualStyleBackColor = True
        '
        'gbFilterSettings
        '
        Me.gbFilterSettings.Controls.Add(Me.Label3)
        Me.gbFilterSettings.Controls.Add(Me.txtBandwidth)
        Me.gbFilterSettings.Controls.Add(Me.Label2)
        Me.gbFilterSettings.Controls.Add(Me.txtGain)
        Me.gbFilterSettings.Controls.Add(Me.Label1)
        Me.gbFilterSettings.Controls.Add(Me.txtCenterFrequency)
        Me.gbFilterSettings.Location = New System.Drawing.Point(12, 12)
        Me.gbFilterSettings.Name = "gbFilterSettings"
        Me.gbFilterSettings.Size = New System.Drawing.Size(209, 100)
        Me.gbFilterSettings.TabIndex = 3
        Me.gbFilterSettings.TabStop = False
        Me.gbFilterSettings.Text = "Filter Settings"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(62, 75)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(79, 13)
        Me.Label3.TabIndex = 5
        Me.Label3.Text = "Bandwidth (Hz)"
        '
        'txtBandwidth
        '
        Me.txtBandwidth.Location = New System.Drawing.Point(144, 72)
        Me.txtBandwidth.Name = "txtBandwidth"
        Me.txtBandwidth.Size = New System.Drawing.Size(55, 20)
        Me.txtBandwidth.TabIndex = 4
        Me.txtBandwidth.Text = "100"
        Me.txtBandwidth.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(90, 51)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(51, 13)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "Gain (dB)"
        '
        'txtGain
        '
        Me.txtGain.Location = New System.Drawing.Point(144, 48)
        Me.txtGain.Name = "txtGain"
        Me.txtGain.Size = New System.Drawing.Size(55, 20)
        Me.txtGain.TabIndex = 2
        Me.txtGain.Text = "6"
        Me.txtGain.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(28, 27)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(113, 13)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Center Frequency (Hz)"
        '
        'txtCenterFrequency
        '
        Me.txtCenterFrequency.Location = New System.Drawing.Point(144, 24)
        Me.txtCenterFrequency.Name = "txtCenterFrequency"
        Me.txtCenterFrequency.Size = New System.Drawing.Size(55, 20)
        Me.txtCenterFrequency.TabIndex = 0
        Me.txtCenterFrequency.Text = "2000"
        Me.txtCenterFrequency.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'gbNoiseSettings
        '
        Me.gbNoiseSettings.Controls.Add(Me.Label5)
        Me.gbNoiseSettings.Controls.Add(Me.txtAmplitude)
        Me.gbNoiseSettings.Location = New System.Drawing.Point(12, 118)
        Me.gbNoiseSettings.Name = "gbNoiseSettings"
        Me.gbNoiseSettings.Size = New System.Drawing.Size(209, 54)
        Me.gbNoiseSettings.TabIndex = 4
        Me.gbNoiseSettings.TabStop = False
        Me.gbNoiseSettings.Text = "Noise Settings"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(72, 22)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(69, 13)
        Me.Label5.TabIndex = 9
        Me.Label5.Text = "Amplitude (V)"
        '
        'txtAmplitude
        '
        Me.txtAmplitude.Location = New System.Drawing.Point(144, 19)
        Me.txtAmplitude.Name = "txtAmplitude"
        Me.txtAmplitude.Size = New System.Drawing.Size(55, 20)
        Me.txtAmplitude.TabIndex = 8
        Me.txtAmplitude.Text = "1.0"
        Me.txtAmplitude.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'gbResults
        '
        Me.gbResults.Controls.Add(Me.Label8)
        Me.gbResults.Controls.Add(Me.lblClipped)
        Me.gbResults.Controls.Add(Me.txtSampleRate)
        Me.gbResults.Controls.Add(Me.Label7)
        Me.gbResults.Controls.Add(Me.txtCycleUsage)
        Me.gbResults.Location = New System.Drawing.Point(12, 178)
        Me.gbResults.Name = "gbResults"
        Me.gbResults.Size = New System.Drawing.Size(209, 94)
        Me.gbResults.TabIndex = 5
        Me.gbResults.TabStop = False
        Me.gbResults.Text = "Results"
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(51, 22)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(90, 13)
        Me.Label8.TabIndex = 9
        Me.Label8.Text = "Sample Rate (Hz)"
        '
        'lblClipped
        '
        Me.lblClipped.AutoSize = True
        Me.lblClipped.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.lblClipped.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblClipped.Location = New System.Drawing.Point(143, 68)
        Me.lblClipped.Name = "lblClipped"
        Me.lblClipped.Size = New System.Drawing.Size(57, 18)
        Me.lblClipped.TabIndex = 12
        Me.lblClipped.Text = "Clipped"
        '
        'txtSampleRate
        '
        Me.txtSampleRate.Enabled = False
        Me.txtSampleRate.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtSampleRate.Location = New System.Drawing.Point(144, 19)
        Me.txtSampleRate.Name = "txtSampleRate"
        Me.txtSampleRate.Size = New System.Drawing.Size(55, 20)
        Me.txtSampleRate.TabIndex = 8
        Me.txtSampleRate.Text = "0"
        Me.txtSampleRate.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(57, 46)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(84, 13)
        Me.Label7.TabIndex = 11
        Me.Label7.Text = "Cycle Usage (%)"
        '
        'txtCycleUsage
        '
        Me.txtCycleUsage.Enabled = False
        Me.txtCycleUsage.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtCycleUsage.Location = New System.Drawing.Point(144, 43)
        Me.txtCycleUsage.Name = "txtCycleUsage"
        Me.txtCycleUsage.Size = New System.Drawing.Size(55, 20)
        Me.txtCycleUsage.TabIndex = 10
        Me.txtCycleUsage.Text = "0"
        Me.txtCycleUsage.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'RP
        '
        Me.RP.Enabled = True
        Me.RP.Location = New System.Drawing.Point(236, 191)
        Me.RP.Name = "RP"
        Me.RP.OcxState = CType(resources.GetObject("RP.OcxState"), System.Windows.Forms.AxHost.State)
        Me.RP.Size = New System.Drawing.Size(100, 50)
        Me.RP.TabIndex = 6
        '
        'Timer1
        '
        Me.Timer1.Enabled = True
        '
        'frmBLNMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(385, 281)
        Me.Controls.Add(Me.RP)
        Me.Controls.Add(Me.gbResults)
        Me.Controls.Add(Me.gbNoiseSettings)
        Me.Controls.Add(Me.gbFilterSettings)
        Me.Controls.Add(Me.btnStop)
        Me.Controls.Add(Me.btnStart)
        Me.Controls.Add(Me.btnLoadCircuit)
        Me.Name = "frmBLNMain"
        Me.Text = "Band Limited Noise Generator"
        Me.gbFilterSettings.ResumeLayout(False)
        Me.gbFilterSettings.PerformLayout()
        Me.gbNoiseSettings.ResumeLayout(False)
        Me.gbNoiseSettings.PerformLayout()
        Me.gbResults.ResumeLayout(False)
        Me.gbResults.PerformLayout()
        CType(Me.RP, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents btnLoadCircuit As System.Windows.Forms.Button
    Friend WithEvents btnStart As System.Windows.Forms.Button
    Friend WithEvents btnStop As System.Windows.Forms.Button
    Friend WithEvents gbFilterSettings As System.Windows.Forms.GroupBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtCenterFrequency As System.Windows.Forms.TextBox
    Friend WithEvents gbNoiseSettings As System.Windows.Forms.GroupBox
    Friend WithEvents gbResults As System.Windows.Forms.GroupBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents txtBandwidth As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents txtGain As System.Windows.Forms.TextBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents txtAmplitude As System.Windows.Forms.TextBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents lblClipped As System.Windows.Forms.Label
    Friend WithEvents txtSampleRate As System.Windows.Forms.TextBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents txtCycleUsage As System.Windows.Forms.TextBox
    Friend WithEvents RP As AxRPCOXLib.AxRPcoX
    Friend WithEvents Timer1 As System.Windows.Forms.Timer

End Class
