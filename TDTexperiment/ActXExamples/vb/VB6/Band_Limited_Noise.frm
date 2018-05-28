VERSION 5.00
Object = "{D323A622-1D13-11D4-8858-444553540000}#1.0#0"; "RPcoX.ocx"
Begin VB.Form frmMain 
   Caption         =   "Band-Limited Noise"
   ClientHeight    =   4695
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6135
   LinkTopic       =   "Form1"
   ScaleHeight     =   4695
   ScaleWidth      =   6135
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame ResultsFrame 
      Caption         =   "Results"
      Height          =   1335
      Left            =   360
      TabIndex        =   14
      Top             =   3120
      Width           =   3015
      Begin VB.TextBox CycUsageText 
         Alignment       =   1  'Right Justify
         Enabled         =   0   'False
         Height          =   285
         Left            =   2040
         TabIndex        =   19
         Text            =   "0"
         Top             =   600
         Width           =   855
      End
      Begin VB.CheckBox ClippedCheck 
         Enabled         =   0   'False
         ForeColor       =   &H00000000&
         Height          =   255
         Left            =   2040
         TabIndex        =   18
         Top             =   990
         Width           =   255
      End
      Begin VB.TextBox SampleRateText 
         Alignment       =   1  'Right Justify
         Enabled         =   0   'False
         Height          =   285
         Left            =   2040
         TabIndex        =   15
         Text            =   "0"
         Top             =   240
         Width           =   855
      End
      Begin VB.Label CycUsageLabel 
         Alignment       =   1  'Right Justify
         Caption         =   "Cycle Usage (%)"
         Height          =   255
         Left            =   120
         TabIndex        =   20
         Top             =   630
         Width           =   1815
      End
      Begin VB.Label ClippedLabel 
         Alignment       =   1  'Right Justify
         Caption         =   "Clipped"
         Height          =   255
         Left            =   120
         TabIndex        =   17
         Top             =   990
         Width           =   1815
      End
      Begin VB.Label SampleRateLabel 
         Alignment       =   1  'Right Justify
         Caption         =   "Sample Rate (Hz)"
         Height          =   255
         Left            =   120
         TabIndex        =   16
         Top             =   270
         Width           =   1815
      End
   End
   Begin VB.CommandButton StopButton 
      Caption         =   "Stop"
      Enabled         =   0   'False
      Height          =   615
      Left            =   3600
      TabIndex        =   8
      Top             =   2040
      Width           =   2175
   End
   Begin VB.CommandButton StartButton 
      Caption         =   "Start"
      Enabled         =   0   'False
      Height          =   615
      Left            =   3600
      TabIndex        =   7
      Top             =   1200
      Width           =   2175
   End
   Begin VB.CommandButton LoadButton 
      Caption         =   "Load Circuit"
      Height          =   615
      Left            =   3600
      TabIndex        =   6
      Top             =   360
      Width           =   2175
   End
   Begin VB.Timer Timer1 
      Interval        =   50
      Left            =   5160
      Top             =   3000
   End
   Begin VB.Frame Frame2 
      Caption         =   "Noise Settings"
      Height          =   855
      Left            =   360
      TabIndex        =   12
      Top             =   2160
      Width           =   3015
      Begin VB.TextBox AmplitudeText 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   2040
         TabIndex        =   5
         Text            =   "1.0"
         Top             =   330
         Width           =   855
      End
      Begin VB.Label AmplitudeLabel 
         Alignment       =   1  'Right Justify
         Caption         =   "Amplitude (V)"
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   360
         Width           =   1815
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Filter Settings"
      Height          =   1815
      Left            =   360
      TabIndex        =   0
      Top             =   240
      Width           =   3015
      Begin VB.CheckBox EnableCheck 
         Height          =   255
         Left            =   2040
         TabIndex        =   4
         Top             =   1470
         Value           =   1  'Checked
         Width           =   255
      End
      Begin VB.TextBox CenterFreqText 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   2040
         TabIndex        =   1
         Text            =   "2000"
         Top             =   360
         Width           =   855
      End
      Begin VB.TextBox BandwidthText 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   2040
         TabIndex        =   3
         Text            =   "100"
         Top             =   1080
         Width           =   855
      End
      Begin VB.TextBox GainText 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   2040
         TabIndex        =   2
         Text            =   "6"
         Top             =   720
         Width           =   855
      End
      Begin VB.Label EnableLabel 
         Alignment       =   1  'Right Justify
         Caption         =   "Enable Coeff. Generation"
         Height          =   255
         Left            =   120
         TabIndex        =   21
         Top             =   1470
         Width           =   1815
      End
      Begin VB.Label CenterFreqLabel 
         Alignment       =   1  'Right Justify
         Caption         =   "Center Frequency (Hz)"
         Height          =   255
         Left            =   120
         TabIndex        =   11
         Top             =   390
         Width           =   1815
      End
      Begin VB.Label BandwidthLabel 
         Alignment       =   1  'Right Justify
         Caption         =   "Bandwidth (Hz)"
         Height          =   255
         Left            =   120
         TabIndex        =   10
         Top             =   1110
         Width           =   1815
      End
      Begin VB.Label GainLabel 
         Alignment       =   1  'Right Justify
         Caption         =   "Gain (dB)"
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   750
         Width           =   1815
      End
   End
   Begin RPCOXLib.RPcoX RP 
      Left            =   3600
      Top             =   3000
      _Version        =   65536
      _ExtentX        =   2566
      _ExtentY        =   1508
      _StockProps     =   0
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Creates band-limited noise with adjustable bandwidth and intensity

Const Circuit = "C:\TDT\ActiveX\ActXExamples\RP_files\Band_Limited_Noise.rcx"

Private Sub EnableCheck_Click()
    Call RP.SetTagVal("Enable", EnableCheck.Value)
End Sub

Private Sub LoadButton_Click()
    'load circuit
    If LoadCircuit = True Then
        StartButton.Enabled = True
        LoadButton.Enabled = False
    End If
End Sub

Private Function LoadCircuit() As Boolean

    'connect to RP2
    If RP.ConnectRP2("GB", 1) = 0 Then
        If RP.ConnectRP2("USB", 1) = 0 Then
            MsgBox "Error connecting to RP device"
            End
        End If
    End If
    
    'load circuit
    Call RP.ClearCOF
    Call RP.LoadCOF(Circuit)
    
    'check status
    LoadCircuit = False
    Status = RP.GetStatus
    If (Status And 1) = 0 Then
        MsgBox "Error connecting to RP device; status: " & Status
        RP.Halt
    ElseIf (Status And 2) = 0 Then
        MsgBox "Error loading circuit; status: " & Status
        RP.Halt
    Else
        LoadCircuit = True
    End If
    
End Function

Private Sub StartButton_Click()

    'set device parameters
    Call RP.SetTagVal("Amp", AmplitudeText.Text)
    Call RP.SetTagVal("Freq", CenterFreqText.Text)
    Call RP.SetTagVal("BW", BandwidthText.Text)
    Call RP.SetTagVal("Gain", GainText.Text)
    Call RP.SetTagVal("Enable", EnableCheck.Value)
    
    'run circuit
    If RunCircuit = True Then
        SampleRateText.Text = RP.GetSFreq
        StopButton.Enabled = True
        StartButton.Enabled = False
    End If
    
End Sub

Private Function RunCircuit() As Boolean
    Call RP.Run
    
    'check status
    RunCircuit = False
    Status = RP.GetStatus
    If (Status And 4) = 0 Then
        MsgBox "Error running circuit; status: " & Status
        RP.Halt
    Else
        RunCircuit = True
    End If
End Function

Private Sub StopButton_Click()
    RP.Halt
    StartButton.Enabled = True
    StopButton.Enabled = False
End Sub

Private Sub Timer1_Timer()
    'check for clipping
    ClippedCheck.Value = RP.GetTagVal("Clip")
    CycUsageText.Text = RP.GetCycUse
End Sub

