<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmTAMain
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmTAMain))
        Me.lblSamplesAcquired = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.btnStartAcquire = New System.Windows.Forms.Button
        Me.btnStopAcquire = New System.Windows.Forms.Button
        Me.btnLoadCircuit = New System.Windows.Forms.Button
        Me.RP = New AxRPCOXLib.AxRPcoX
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        CType(Me.RP, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'lblSamplesAcquired
        '
        Me.lblSamplesAcquired.AutoSize = True
        Me.lblSamplesAcquired.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSamplesAcquired.Location = New System.Drawing.Point(241, 46)
        Me.lblSamplesAcquired.Name = "lblSamplesAcquired"
        Me.lblSamplesAcquired.Size = New System.Drawing.Size(16, 17)
        Me.lblSamplesAcquired.TabIndex = 10
        Me.lblSamplesAcquired.Text = "0"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(233, 25)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(119, 16)
        Me.Label1.TabIndex = 9
        Me.Label1.Text = "Samples Acquired"
        '
        'btnStartAcquire
        '
        Me.btnStartAcquire.Enabled = False
        Me.btnStartAcquire.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.5!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnStartAcquire.Location = New System.Drawing.Point(126, 12)
        Me.btnStartAcquire.Name = "btnStartAcquire"
        Me.btnStartAcquire.Size = New System.Drawing.Size(97, 42)
        Me.btnStartAcquire.TabIndex = 8
        Me.btnStartAcquire.Text = "Start Acquire"
        Me.btnStartAcquire.UseVisualStyleBackColor = True
        '
        'btnStopAcquire
        '
        Me.btnStopAcquire.Enabled = False
        Me.btnStopAcquire.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.5!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnStopAcquire.Location = New System.Drawing.Point(126, 60)
        Me.btnStopAcquire.Name = "btnStopAcquire"
        Me.btnStopAcquire.Size = New System.Drawing.Size(97, 42)
        Me.btnStopAcquire.TabIndex = 7
        Me.btnStopAcquire.Text = "Stop Acquire"
        Me.btnStopAcquire.UseVisualStyleBackColor = True
        '
        'btnLoadCircuit
        '
        Me.btnLoadCircuit.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.5!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnLoadCircuit.Location = New System.Drawing.Point(12, 12)
        Me.btnLoadCircuit.Name = "btnLoadCircuit"
        Me.btnLoadCircuit.Size = New System.Drawing.Size(97, 42)
        Me.btnLoadCircuit.TabIndex = 6
        Me.btnLoadCircuit.Text = "Load Circuit"
        Me.btnLoadCircuit.UseVisualStyleBackColor = True
        '
        'RP
        '
        Me.RP.Enabled = True
        Me.RP.Location = New System.Drawing.Point(20, 60)
        Me.RP.Name = "RP"
        Me.RP.OcxState = CType(resources.GetObject("RP.OcxState"), System.Windows.Forms.AxHost.State)
        Me.RP.Size = New System.Drawing.Size(100, 50)
        Me.RP.TabIndex = 11
        '
        'Timer1
        '
        Me.Timer1.Enabled = True
        Me.Timer1.Interval = 5
        '
        'frmTAMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(358, 116)
        Me.Controls.Add(Me.RP)
        Me.Controls.Add(Me.lblSamplesAcquired)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.btnStartAcquire)
        Me.Controls.Add(Me.btnStopAcquire)
        Me.Controls.Add(Me.btnLoadCircuit)
        Me.Name = "frmTAMain"
        Me.Text = "Two Channel Continuous Acquire"
        CType(Me.RP, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents lblSamplesAcquired As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents btnStartAcquire As System.Windows.Forms.Button
    Friend WithEvents btnStopAcquire As System.Windows.Forms.Button
    Friend WithEvents btnLoadCircuit As System.Windows.Forms.Button
    Friend WithEvents RP As AxRPCOXLib.AxRPcoX
    Friend WithEvents Timer1 As System.Windows.Forms.Timer

End Class
