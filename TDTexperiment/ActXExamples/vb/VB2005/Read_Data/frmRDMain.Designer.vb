<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmRDMain
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
        Me.btnReadData = New System.Windows.Forms.Button
        Me.cmbNumChan = New System.Windows.Forms.ComboBox
        Me.lblNumChans = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'btnReadData
        '
        Me.btnReadData.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.5!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnReadData.Location = New System.Drawing.Point(136, 10)
        Me.btnReadData.Name = "btnReadData"
        Me.btnReadData.Size = New System.Drawing.Size(98, 37)
        Me.btnReadData.TabIndex = 0
        Me.btnReadData.Text = "Read Data"
        Me.btnReadData.UseVisualStyleBackColor = True
        '
        'cmbNumChan
        '
        Me.cmbNumChan.FormattingEnabled = True
        Me.cmbNumChan.Items.AddRange(New Object() {"1", "2"})
        Me.cmbNumChan.Location = New System.Drawing.Point(91, 18)
        Me.cmbNumChan.Name = "cmbNumChan"
        Me.cmbNumChan.Size = New System.Drawing.Size(36, 21)
        Me.cmbNumChan.TabIndex = 1
        Me.cmbNumChan.Text = "1"
        '
        'lblNumChans
        '
        Me.lblNumChans.AutoSize = True
        Me.lblNumChans.Location = New System.Drawing.Point(12, 21)
        Me.lblNumChans.Name = "lblNumChans"
        Me.lblNumChans.Size = New System.Drawing.Size(76, 13)
        Me.lblNumChans.TabIndex = 2
        Me.lblNumChans.Text = "Num Channels"
        '
        'frmRDMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(243, 57)
        Me.Controls.Add(Me.lblNumChans)
        Me.Controls.Add(Me.cmbNumChan)
        Me.Controls.Add(Me.btnReadData)
        Me.Name = "frmRDMain"
        Me.Text = "Read Data"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents btnReadData As System.Windows.Forms.Button
    Friend WithEvents cmbNumChan As System.Windows.Forms.ComboBox
    Friend WithEvents lblNumChans As System.Windows.Forms.Label

End Class
