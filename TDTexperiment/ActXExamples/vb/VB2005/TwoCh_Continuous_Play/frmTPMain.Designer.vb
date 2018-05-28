<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmTPMain
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmTPMain))
        Me.btnMakeTones = New System.Windows.Forms.Button
        Me.RP = New AxRPCOXLib.AxRPcoX
        Me.lblStatus = New System.Windows.Forms.Label
        CType(Me.RP, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'btnMakeTones
        '
        Me.btnMakeTones.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnMakeTones.Location = New System.Drawing.Point(23, 12)
        Me.btnMakeTones.Name = "btnMakeTones"
        Me.btnMakeTones.Size = New System.Drawing.Size(144, 50)
        Me.btnMakeTones.TabIndex = 1
        Me.btnMakeTones.Text = "Make Tones"
        Me.btnMakeTones.UseVisualStyleBackColor = True
        '
        'RP
        '
        Me.RP.Enabled = True
        Me.RP.Location = New System.Drawing.Point(101, 34)
        Me.RP.Name = "RP"
        Me.RP.OcxState = CType(resources.GetObject("RP.OcxState"), System.Windows.Forms.AxHost.State)
        Me.RP.Size = New System.Drawing.Size(100, 50)
        Me.RP.TabIndex = 2
        '
        'lblStatus
        '
        Me.lblStatus.AutoSize = True
        Me.lblStatus.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblStatus.Location = New System.Drawing.Point(20, 67)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(48, 17)
        Me.lblStatus.TabIndex = 3
        Me.lblStatus.Text = "Status"
        '
        'frmTPMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(191, 93)
        Me.Controls.Add(Me.lblStatus)
        Me.Controls.Add(Me.btnMakeTones)
        Me.Controls.Add(Me.RP)
        Me.Name = "frmTPMain"
        Me.Text = "2Ch Continuous Play"
        CType(Me.RP, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents btnMakeTones As System.Windows.Forms.Button
    Friend WithEvents RP As AxRPCOXLib.AxRPcoX
    Friend WithEvents lblStatus As System.Windows.Forms.Label

End Class
