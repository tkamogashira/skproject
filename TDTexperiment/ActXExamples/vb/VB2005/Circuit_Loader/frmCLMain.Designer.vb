<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmCLMain
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmCLMain))
        Me.lblDeviceNumber = New System.Windows.Forms.Label
        Me.txtDeviceNumber = New System.Windows.Forms.TextBox
        Me.btnLoadCircuit = New System.Windows.Forms.Button
        Me.lblStatus = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.gbInterface = New System.Windows.Forms.GroupBox
        Me.rbInterfaceUSB = New System.Windows.Forms.RadioButton
        Me.rbInterfaceGB = New System.Windows.Forms.RadioButton
        Me.gbModule = New System.Windows.Forms.GroupBox
        Me.rbModuleRZ2 = New System.Windows.Forms.RadioButton
        Me.rbModuleRX8 = New System.Windows.Forms.RadioButton
        Me.rbModuleRX7 = New System.Windows.Forms.RadioButton
        Me.rbModuleRX6 = New System.Windows.Forms.RadioButton
        Me.rbModuleRX5 = New System.Windows.Forms.RadioButton
        Me.rbModuleRA16 = New System.Windows.Forms.RadioButton
        Me.rbModuleRP2 = New System.Windows.Forms.RadioButton
        Me.OpenFileDialog = New System.Windows.Forms.OpenFileDialog
        Me.RP = New AxRPCOXLib.AxRPcoX
        Me.btnCheckDevice = New System.Windows.Forms.Button
        Me.txtStatus = New System.Windows.Forms.TextBox
        Me.gbInterface.SuspendLayout()
        Me.gbModule.SuspendLayout()
        CType(Me.RP, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'lblDeviceNumber
        '
        Me.lblDeviceNumber.AutoSize = True
        Me.lblDeviceNumber.Location = New System.Drawing.Point(272, 19)
        Me.lblDeviceNumber.Name = "lblDeviceNumber"
        Me.lblDeviceNumber.Size = New System.Drawing.Size(81, 13)
        Me.lblDeviceNumber.TabIndex = 14
        Me.lblDeviceNumber.Text = "Device Number"
        '
        'txtDeviceNumber
        '
        Me.txtDeviceNumber.Location = New System.Drawing.Point(359, 17)
        Me.txtDeviceNumber.Name = "txtDeviceNumber"
        Me.txtDeviceNumber.Size = New System.Drawing.Size(28, 20)
        Me.txtDeviceNumber.TabIndex = 13
        Me.txtDeviceNumber.Text = "1"
        Me.txtDeviceNumber.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'btnLoadCircuit
        '
        Me.btnLoadCircuit.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.5!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnLoadCircuit.Location = New System.Drawing.Point(268, 43)
        Me.btnLoadCircuit.Name = "btnLoadCircuit"
        Me.btnLoadCircuit.Size = New System.Drawing.Size(119, 28)
        Me.btnLoadCircuit.TabIndex = 12
        Me.btnLoadCircuit.Text = "Load Circuit"
        Me.btnLoadCircuit.UseVisualStyleBackColor = True
        '
        'lblStatus
        '
        Me.lblStatus.AutoSize = True
        Me.lblStatus.Location = New System.Drawing.Point(217, 182)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(95, 13)
        Me.lblStatus.TabIndex = 11
        Me.lblStatus.Text = "No circuits loaded."
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(171, 182)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(40, 13)
        Me.Label1.TabIndex = 10
        Me.Label1.Text = "Status:"
        '
        'gbInterface
        '
        Me.gbInterface.Controls.Add(Me.rbInterfaceUSB)
        Me.gbInterface.Controls.Add(Me.rbInterfaceGB)
        Me.gbInterface.Location = New System.Drawing.Point(157, 12)
        Me.gbInterface.Name = "gbInterface"
        Me.gbInterface.Size = New System.Drawing.Size(92, 73)
        Me.gbInterface.TabIndex = 9
        Me.gbInterface.TabStop = False
        Me.gbInterface.Text = "Interface"
        '
        'rbInterfaceUSB
        '
        Me.rbInterfaceUSB.AutoSize = True
        Me.rbInterfaceUSB.Location = New System.Drawing.Point(17, 42)
        Me.rbInterfaceUSB.Name = "rbInterfaceUSB"
        Me.rbInterfaceUSB.Size = New System.Drawing.Size(47, 17)
        Me.rbInterfaceUSB.TabIndex = 5
        Me.rbInterfaceUSB.TabStop = True
        Me.rbInterfaceUSB.Text = "USB"
        Me.rbInterfaceUSB.UseVisualStyleBackColor = True
        '
        'rbInterfaceGB
        '
        Me.rbInterfaceGB.AutoSize = True
        Me.rbInterfaceGB.Checked = True
        Me.rbInterfaceGB.Location = New System.Drawing.Point(17, 19)
        Me.rbInterfaceGB.Name = "rbInterfaceGB"
        Me.rbInterfaceGB.Size = New System.Drawing.Size(58, 17)
        Me.rbInterfaceGB.TabIndex = 4
        Me.rbInterfaceGB.TabStop = True
        Me.rbInterfaceGB.Text = "Gigabit"
        Me.rbInterfaceGB.UseVisualStyleBackColor = True
        '
        'gbModule
        '
        Me.gbModule.Controls.Add(Me.rbModuleRZ2)
        Me.gbModule.Controls.Add(Me.rbModuleRX8)
        Me.gbModule.Controls.Add(Me.rbModuleRX7)
        Me.gbModule.Controls.Add(Me.rbModuleRX6)
        Me.gbModule.Controls.Add(Me.rbModuleRX5)
        Me.gbModule.Controls.Add(Me.rbModuleRA16)
        Me.gbModule.Controls.Add(Me.rbModuleRP2)
        Me.gbModule.Location = New System.Drawing.Point(12, 12)
        Me.gbModule.Name = "gbModule"
        Me.gbModule.Size = New System.Drawing.Size(139, 183)
        Me.gbModule.TabIndex = 8
        Me.gbModule.TabStop = False
        Me.gbModule.Text = "RP Module"
        '
        'rbModuleRZ2
        '
        Me.rbModuleRZ2.AutoSize = True
        Me.rbModuleRZ2.Location = New System.Drawing.Point(16, 157)
        Me.rbModuleRZ2.Name = "rbModuleRZ2"
        Me.rbModuleRZ2.Size = New System.Drawing.Size(88, 17)
        Me.rbModuleRZ2.TabIndex = 6
        Me.rbModuleRZ2.TabStop = True
        Me.rbModuleRZ2.Text = "RZ2 Z-Series"
        Me.rbModuleRZ2.UseVisualStyleBackColor = True
        '
        'rbModuleRX8
        '
        Me.rbModuleRX8.AutoSize = True
        Me.rbModuleRX8.Location = New System.Drawing.Point(16, 134)
        Me.rbModuleRX8.Name = "rbModuleRX8"
        Me.rbModuleRX8.Size = New System.Drawing.Size(90, 17)
        Me.rbModuleRX8.TabIndex = 5
        Me.rbModuleRX8.TabStop = True
        Me.rbModuleRX8.Text = "RX8 Multi I/O"
        Me.rbModuleRX8.UseVisualStyleBackColor = True
        '
        'rbModuleRX7
        '
        Me.rbModuleRX7.AutoSize = True
        Me.rbModuleRX7.Location = New System.Drawing.Point(16, 111)
        Me.rbModuleRX7.Name = "rbModuleRX7"
        Me.rbModuleRX7.Size = New System.Drawing.Size(78, 17)
        Me.rbModuleRX7.TabIndex = 4
        Me.rbModuleRX7.TabStop = True
        Me.rbModuleRX7.Text = "RX7 Moray"
        Me.rbModuleRX7.UseVisualStyleBackColor = True
        '
        'rbModuleRX6
        '
        Me.rbModuleRX6.AutoSize = True
        Me.rbModuleRX6.Location = New System.Drawing.Point(16, 88)
        Me.rbModuleRX6.Name = "rbModuleRX6"
        Me.rbModuleRX6.Size = New System.Drawing.Size(85, 17)
        Me.rbModuleRX6.TabIndex = 3
        Me.rbModuleRX6.TabStop = True
        Me.rbModuleRX6.Text = "RX6 Piranha"
        Me.rbModuleRX6.UseVisualStyleBackColor = True
        '
        'rbModuleRX5
        '
        Me.rbModuleRX5.AutoSize = True
        Me.rbModuleRX5.Location = New System.Drawing.Point(16, 65)
        Me.rbModuleRX5.Name = "rbModuleRX5"
        Me.rbModuleRX5.Size = New System.Drawing.Size(88, 17)
        Me.rbModuleRX5.TabIndex = 2
        Me.rbModuleRX5.TabStop = True
        Me.rbModuleRX5.Text = "RX5 Pentusa"
        Me.rbModuleRX5.UseVisualStyleBackColor = True
        '
        'rbModuleRA16
        '
        Me.rbModuleRA16.AutoSize = True
        Me.rbModuleRA16.Location = New System.Drawing.Point(17, 42)
        Me.rbModuleRA16.Name = "rbModuleRA16"
        Me.rbModuleRA16.Size = New System.Drawing.Size(93, 17)
        Me.rbModuleRA16.TabIndex = 1
        Me.rbModuleRA16.TabStop = True
        Me.rbModuleRA16.Text = "RA16 Medusa"
        Me.rbModuleRA16.UseVisualStyleBackColor = True
        '
        'rbModuleRP2
        '
        Me.rbModuleRP2.AutoSize = True
        Me.rbModuleRP2.Checked = True
        Me.rbModuleRP2.Location = New System.Drawing.Point(17, 19)
        Me.rbModuleRP2.Name = "rbModuleRP2"
        Me.rbModuleRP2.Size = New System.Drawing.Size(87, 17)
        Me.rbModuleRP2.TabIndex = 0
        Me.rbModuleRP2.TabStop = True
        Me.rbModuleRP2.Text = "RP2 / RP2.1"
        Me.rbModuleRP2.UseVisualStyleBackColor = True
        '
        'OpenFileDialog
        '
        Me.OpenFileDialog.InitialDirectory = "C:\TDT\ActiveX\ActXExamples\RP_Files\"
        '
        'RP
        '
        Me.RP.Enabled = True
        Me.RP.Location = New System.Drawing.Point(157, 123)
        Me.RP.Name = "RP"
        Me.RP.OcxState = CType(resources.GetObject("RP.OcxState"), System.Windows.Forms.AxHost.State)
        Me.RP.Size = New System.Drawing.Size(100, 50)
        Me.RP.TabIndex = 15
        '
        'btnCheckDevice
        '
        Me.btnCheckDevice.Enabled = False
        Me.btnCheckDevice.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.5!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCheckDevice.Location = New System.Drawing.Point(268, 77)
        Me.btnCheckDevice.Name = "btnCheckDevice"
        Me.btnCheckDevice.Size = New System.Drawing.Size(119, 28)
        Me.btnCheckDevice.TabIndex = 16
        Me.btnCheckDevice.Text = "Check Device"
        Me.btnCheckDevice.UseVisualStyleBackColor = True
        '
        'txtStatus
        '
        Me.txtStatus.Location = New System.Drawing.Point(174, 111)
        Me.txtStatus.Multiline = True
        Me.txtStatus.Name = "txtStatus"
        Me.txtStatus.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtStatus.Size = New System.Drawing.Size(213, 62)
        Me.txtStatus.TabIndex = 18
        '
        'frmCLMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(399, 204)
        Me.Controls.Add(Me.txtStatus)
        Me.Controls.Add(Me.btnCheckDevice)
        Me.Controls.Add(Me.lblDeviceNumber)
        Me.Controls.Add(Me.txtDeviceNumber)
        Me.Controls.Add(Me.btnLoadCircuit)
        Me.Controls.Add(Me.lblStatus)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.gbInterface)
        Me.Controls.Add(Me.gbModule)
        Me.Controls.Add(Me.RP)
        Me.Name = "frmCLMain"
        Me.Text = "Circuit Loader"
        Me.gbInterface.ResumeLayout(False)
        Me.gbInterface.PerformLayout()
        Me.gbModule.ResumeLayout(False)
        Me.gbModule.PerformLayout()
        CType(Me.RP, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents lblDeviceNumber As System.Windows.Forms.Label
    Friend WithEvents txtDeviceNumber As System.Windows.Forms.TextBox
    Friend WithEvents btnLoadCircuit As System.Windows.Forms.Button
    Friend WithEvents lblStatus As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents gbInterface As System.Windows.Forms.GroupBox
    Friend WithEvents rbInterfaceUSB As System.Windows.Forms.RadioButton
    Friend WithEvents rbInterfaceGB As System.Windows.Forms.RadioButton
    Friend WithEvents gbModule As System.Windows.Forms.GroupBox
    Friend WithEvents rbModuleRA16 As System.Windows.Forms.RadioButton
    Friend WithEvents rbModuleRP2 As System.Windows.Forms.RadioButton
    Friend WithEvents OpenFileDialog As System.Windows.Forms.OpenFileDialog
    Friend WithEvents RP As AxRPCOXLib.AxRPcoX
    Friend WithEvents rbModuleRZ2 As System.Windows.Forms.RadioButton
    Friend WithEvents rbModuleRX8 As System.Windows.Forms.RadioButton
    Friend WithEvents rbModuleRX7 As System.Windows.Forms.RadioButton
    Friend WithEvents rbModuleRX6 As System.Windows.Forms.RadioButton
    Friend WithEvents rbModuleRX5 As System.Windows.Forms.RadioButton
    Friend WithEvents btnCheckDevice As System.Windows.Forms.Button
    Friend WithEvents txtStatus As System.Windows.Forms.TextBox

End Class
