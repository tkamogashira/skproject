VERSION 5.00
Object = "{D323A622-1D13-11D4-8858-444553540000}#1.0#0"; "RPcoX.ocx"
Begin VB.Form frmMain 
   Caption         =   "Continuous Acquire"
   ClientHeight    =   1485
   ClientLeft      =   8940
   ClientTop       =   7275
   ClientWidth     =   4725
   LinkTopic       =   "Form1"
   ScaleHeight     =   1485
   ScaleWidth      =   4725
   Begin VB.CommandButton btnLoadCircuit 
      Caption         =   "Load Circuit"
      Height          =   495
      Left            =   240
      TabIndex        =   4
      Top             =   240
      Width           =   1335
   End
   Begin VB.CommandButton btnStopAcquire 
      Caption         =   "Stop Acquire"
      Enabled         =   0   'False
      Height          =   495
      Left            =   1920
      TabIndex        =   2
      Top             =   840
      Width           =   1335
   End
   Begin VB.CommandButton btnStartAcquire 
      Caption         =   "Start Acquire"
      Enabled         =   0   'False
      Height          =   495
      Left            =   1920
      TabIndex        =   1
      Top             =   240
      Width           =   1335
   End
   Begin VB.Timer Timer1 
      Left            =   240
      Top             =   960
   End
   Begin RPCOXLib.RPcoX RP 
      Left            =   840
      Top             =   960
      _Version        =   65536
      _ExtentX        =   661
      _ExtentY        =   661
      _StockProps     =   0
   End
   Begin VB.Label lblSamplesAcquired 
      Alignment       =   2  'Center
      Caption         =   "0"
      Height          =   255
      Left            =   3600
      TabIndex        =   3
      Top             =   600
      Width           =   855
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Caption         =   "Samples Acquired"
      Height          =   255
      Left            =   3240
      TabIndex        =   0
      Top             =   240
      Width           =   1455
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Writes data from a signal channel to disk (sampling rate=100kHz)

Const Circuit = "C:\TDT\ActiveX\ActXExamples\RP_files\Continuous_Acquire.rcx"
Const DataFile = "C:\TDT\ActiveX\ActXExamples\vb\VB6\tones.dat"

Dim data(0 To 49999) As Single 'buffer for saving data'
Dim bufpts As Long   'number of points to save to disk
Dim offset As Long   'offset of memory buffer
Dim curindex As Long 'position of memory buffer index
Dim samplesAcquired As Long 'Number of samples saved to disk
Dim acquire As Boolean ' Starts and stops data acquistion
Dim high As Boolean    'indicates index position of the buffer (> half or less than half the buffer).
Const BufferSize = 100000 'Size of Serial Buffer

Private Sub Form_Load()
    'open file for writing
    Open DataFile For Binary As #1
End Sub

Private Sub btnLoadCircuit_Click()
            
    If LoadCircuit = True Then
        If RunCircuit = True Then
            bufpts = BufferSize / 2
            offset = 0
            Timer1.Interval = 5
            btnStartAcquire.Enabled = True
            btnLoadCircuit.Enabled = False
        End If
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

Private Sub btnStartAcquire_Click()
    acquire = True
    Timer1.Enabled = True
    Call RP.SoftTrg(1)
    btnStopAcquire.Enabled = True
    btnStartAcquire.Enabled = False
    btnLoadCircuit.Enabled = False
End Sub

Private Sub btnStopAcquire_Click()
    Call RP.SoftTrg(2)
    Timer1.Enabled = False
    btnStartAcquire.Enabled = True
    btnLoadCircuit.Enabled = True
    btnStopAcquire.Enabled = False
End Sub

Public Sub Timer1_timer()
    If acquire = True Then
        curindex = RP.GetTagVal("index")
        
        'check buffer index
        If high Then
            While curindex > bufpts
                curindex = RP.GetTagVal("index")
            Wend
        Else
            While curindex < bufpts
                curindex = RP.GetTagVal("index")
            Wend
        End If
        
        'read half of buffer
        err1 = RP.ReadTag("dataout", data(0), offset, bufpts)
        If err1 = 0 Then
            MsgBox ("error transfering data")
            End
        End If
          
        'write half of buffer to data file
        Put #1, , data()
            
        'update sampleAcquired
        samplesAcquired = samplesAcquired + bufpts
        lblSamplesAcquired.Caption = samplesAcquired
        
        'check buffer index
        If high Then
            If curindex > bufpts Then
                MsgBox ("Transfer rate too slow")
                Call RP.SoftTrg(2)
            End If
        Else
            If curindex < bufpts Then
                MsgBox ("transfer rate too slow")
                Call RP.SoftTrg(2)
            End If
        End If
        
        If high Then
            high = False
            offset = 0
        Else
            high = True
            offset = bufpts
        End If
    End If
End Sub

Public Sub Form_Unload(Cancel As Integer)
    Call RP.Halt   'stops circuit from running
    Close #1       'closes data file
End Sub


