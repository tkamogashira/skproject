VERSION 5.00
Object = "{D323A622-1D13-11D4-8858-444553540000}#1.0#0"; "RPcoX.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmMain 
   Caption         =   "Circuit Loader"
   ClientHeight    =   2115
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6315
   LinkTopic       =   "Form1"
   ScaleHeight     =   2115
   ScaleWidth      =   6315
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame2 
      Caption         =   "RP Module"
      Height          =   1935
      Left            =   120
      TabIndex        =   8
      Top             =   120
      Width           =   2175
      Begin VB.OptionButton ModuleOption 
         Caption         =   "RL2 Stingray"
         Height          =   255
         Index           =   3
         Left            =   240
         TabIndex        =   12
         Top             =   1440
         Width           =   1815
      End
      Begin VB.OptionButton ModuleOption 
         Caption         =   "RV8 Barracuda"
         Height          =   255
         Index           =   2
         Left            =   240
         TabIndex        =   11
         Top             =   1080
         Width           =   1815
      End
      Begin VB.OptionButton ModuleOption 
         Caption         =   "RA16 Medusa"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   10
         Top             =   720
         Width           =   1815
      End
      Begin VB.OptionButton ModuleOption 
         Caption         =   "RP2 / RP2.1"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   9
         Top             =   360
         Value           =   -1  'True
         Width           =   1815
      End
   End
   Begin VB.TextBox DeviceBox 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   5640
      TabIndex        =   7
      Text            =   "1"
      Top             =   210
      Width           =   615
   End
   Begin VB.Frame Frame1 
      Caption         =   "Interface"
      Height          =   1215
      Left            =   2400
      TabIndex        =   4
      Top             =   120
      Width           =   1695
      Begin VB.OptionButton Option1 
         Caption         =   "Gigabit"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   6
         Top             =   720
         Width           =   1335
      End
      Begin VB.OptionButton Option1 
         Caption         =   "USB"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   5
         Top             =   360
         Value           =   -1  'True
         Width           =   1335
      End
   End
   Begin VB.CommandButton LoadButton 
      Caption         =   "Load Circuit"
      Height          =   615
      Left            =   4200
      TabIndex        =   0
      Top             =   720
      Width           =   2055
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   1560
      Top             =   2520
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin RPCOXLib.RPcoX RP2 
      Index           =   8
      Left            =   5760
      Top             =   1920
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RP2 
      Index           =   1
      Left            =   2400
      Top             =   1920
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RP2 
      Index           =   2
      Left            =   2880
      Top             =   1920
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RP2 
      Index           =   3
      Left            =   3360
      Top             =   1920
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RP2 
      Index           =   4
      Left            =   3840
      Top             =   1920
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RP2 
      Index           =   5
      Left            =   4320
      Top             =   1920
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RP2 
      Index           =   6
      Left            =   4800
      Top             =   1920
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RP2 
      Index           =   7
      Left            =   5280
      Top             =   1920
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RA16 
      Index           =   8
      Left            =   5760
      Top             =   2400
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RA16 
      Index           =   1
      Left            =   2400
      Top             =   2400
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RA16 
      Index           =   2
      Left            =   2880
      Top             =   2400
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RA16 
      Index           =   3
      Left            =   3360
      Top             =   2400
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RA16 
      Index           =   4
      Left            =   3840
      Top             =   2400
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RA16 
      Index           =   5
      Left            =   4320
      Top             =   2400
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RA16 
      Index           =   6
      Left            =   4800
      Top             =   2400
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RA16 
      Index           =   7
      Left            =   5280
      Top             =   2400
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RV8 
      Index           =   8
      Left            =   5760
      Top             =   2880
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RV8 
      Index           =   1
      Left            =   2400
      Top             =   2880
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RV8 
      Index           =   2
      Left            =   2880
      Top             =   2880
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RV8 
      Index           =   3
      Left            =   3360
      Top             =   2880
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RV8 
      Index           =   4
      Left            =   3840
      Top             =   2880
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RV8 
      Index           =   5
      Left            =   4320
      Top             =   2880
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RV8 
      Index           =   6
      Left            =   4800
      Top             =   2880
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RV8 
      Index           =   7
      Left            =   5280
      Top             =   2880
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RL2 
      Index           =   8
      Left            =   5760
      Top             =   3360
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RL2 
      Index           =   1
      Left            =   2400
      Top             =   3360
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RL2 
      Index           =   2
      Left            =   2880
      Top             =   3360
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RL2 
      Index           =   3
      Left            =   3360
      Top             =   3360
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RL2 
      Index           =   4
      Left            =   3840
      Top             =   3360
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RL2 
      Index           =   5
      Left            =   4320
      Top             =   3360
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RL2 
      Index           =   6
      Left            =   4800
      Top             =   3360
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin RPCOXLib.RPcoX RL2 
      Index           =   7
      Left            =   5280
      Top             =   3360
      _Version        =   65536
      _ExtentX        =   873
      _ExtentY        =   873
      _StockProps     =   0
   End
   Begin VB.Label Label4 
      Alignment       =   1  'Right Justify
      Caption         =   "Device Number"
      Height          =   255
      Left            =   4200
      TabIndex        =   3
      Top             =   240
      Width           =   1335
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      Caption         =   "Status:"
      Height          =   255
      Left            =   2400
      TabIndex        =   2
      Top             =   1560
      Width           =   615
   End
   Begin VB.Label StatusLabel 
      Caption         =   " No circuits loaded."
      Height          =   255
      Left            =   3120
      TabIndex        =   1
      Top             =   1560
      Width           =   3135
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim DeviceSelection As Integer
Const max_device_num = 8

Private Sub LoadButton_Click()
    CommonDialog1.ShowOpen
    filepath = CommonDialog1.FileName
    
    If Option1(0).Value = True Then
        interface = "USB"
    Else
        interface = "Gigabit"
    End If
    
    If ModuleOption(0).Value = True Then
        Call RP2(DeviceSelection).ConnectRP2(interface, DeviceSelection)
        RP2(DeviceSelection).ClearCOF
        RP2(DeviceSelection).LoadCOF (filepath)
        RP2(DeviceSelection).Run
        Status = RP2(DeviceSelection).GetStatus
        device_type = "RP2"
    ElseIf ModuleOption(1).Value = True Then
        Call RA16(DeviceSelection).ConnectRA16(interface, DeviceSelection)
        RA16(DeviceSelection).ClearCOF
        RA16(DeviceSelection).LoadCOF (filepath)
        RA16(DeviceSelection).Run
        Status = RA16(DeviceSelection).GetStatus
        device_type = "RA16"
    ElseIf ModuleOption(2).Value = True Then
        Call RV8(DeviceSelection).ConnectRV8(interface, DeviceSelection)
        RV8(DeviceSelection).ClearCOF
        RV8(DeviceSelection).LoadCOF (filepath)
        RV8(DeviceSelection).Run
        Status = RV8(DeviceSelection).GetStatus
        device_type = "RV8"
    Else
        Call RL2(DeviceSelection).ConnectRL2(interface, DeviceSelection)
        RL2(DeviceSelection).ClearCOF
        RL2(DeviceSelection).LoadCOF (filepath)
        RL2(DeviceSelection).Run
        Status = RL2(DeviceSelection).GetStatus
        device_type = "RL2"
    End If
    
    If (Status And 7) <> 7 Then
        StatusLabel.Caption = "Error loading circuit on " & device_type & " #" & DeviceSelection
    Else
        StatusLabel.Caption = "Circuit loaded on " & device_type & " #" & DeviceSelection
    End If
End Sub

Private Sub DeviceBox_Change()
    If Not (DeviceBox.Text >= 1 And DeviceBox.Text <= max_device_num) Then
        MsgBox "Error: device number must be between 1 and " & max_device_num & "."
    Else
        DeviceSelection = DeviceBox.Text
    End If
End Sub

Private Sub Form_Load()
    DeviceSelection = 1
End Sub

Private Sub Form_Unload(cancel As Integer)
    For i = 1 To max_device_num
        RP2(i).Halt
        RV8(i).Halt
        RA16(i).Halt
        RL2(i).Halt
    Next i
End Sub
