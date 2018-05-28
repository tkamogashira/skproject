VERSION 5.00
Object = "{D323A622-1D13-11D4-8858-444553540000}#1.0#0"; "RPcoX.ocx"
Begin VB.Form frmMain 
   Caption         =   "Two Channel Acquisition"
   ClientHeight    =   1320
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4695
   LinkTopic       =   "Form1"
   ScaleHeight     =   1320
   ScaleWidth      =   4695
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtIteration 
      Alignment       =   1  'Right Justify
      Enabled         =   0   'False
      Height          =   285
      Left            =   3600
      TabIndex        =   4
      Text            =   "0"
      Top             =   720
      Width           =   975
   End
   Begin VB.Timer Timer2 
      Enabled         =   0   'False
      Interval        =   5
      Left            =   3000
      Top             =   1080
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   5
      Left            =   2640
      Top             =   1080
   End
   Begin VB.TextBox txtSamplesAcquired 
      Alignment       =   1  'Right Justify
      Enabled         =   0   'False
      Height          =   285
      Left            =   3600
      TabIndex        =   2
      Text            =   "0"
      Top             =   210
      Width           =   975
   End
   Begin VB.CommandButton btnStart 
      Caption         =   "Start"
      Enabled         =   0   'False
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   720
      Width           =   1815
   End
   Begin RPCOXLib.RPcoX RP 
      Left            =   2040
      Top             =   1080
      _Version        =   65536
      _ExtentX        =   1085
      _ExtentY        =   1085
      _StockProps     =   0
   End
   Begin VB.CommandButton btnLoadCircuit 
      Caption         =   "Load Circuit"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1815
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      Caption         =   "Iteration"
      Height          =   255
      Left            =   2040
      TabIndex        =   5
      Top             =   750
      Width           =   1455
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Samples Acquired"
      Height          =   255
      Left            =   2040
      TabIndex        =   3
      Top             =   240
      Width           =   1455
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Const Circuit = "C:\TDT\ActiveX\ActXExamples\RP_files\TwoCh_Continuous_Acquire.rcx"
Const OutputFileName = "C:\TDT\ActiveX\ActXExamples\vb\VB6\2CHtones.dat"

Const BufferSize = 100000
Const NumIterations = 3

Dim bufpts As Long
Dim curindex As Long
Dim iteration As Integer
Dim samplesAcquired As Long
Dim dataSng() As Single

Private Sub Form_Load()
    'open file for writing
    Open OutputFileName For Binary As #1
End Sub

Private Sub btnLoadCircuit_Click()

    If LoadCircuit = True Then
        btnStart.Enabled = True
        btnLoadCircuit.Enabled = False
        bufpts = BufferSize / 2
        ReDim dataSng(0 To 1, 0 To bufpts / 2)
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

Private Sub btnStart_Click()
    
    If RunCircuit = True Then
        btnStart.Enabled = False
        Call RP.SoftTrg(1)
        Timer1.Enabled = True
        iteration = 1
        txtIteration.Text = iteration
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

Private Sub FirstHalf()
    dataInt = RP.ReadTagVEX("dataout", 0, bufpts, "I16", "I16", 2)
    For i = 0 To bufpts / 2 - 1
        dataSng(0, i) = dataInt(0, i) / 32767
        dataSng(1, i) = dataInt(1, i) / 32767
    Next
    
    'dataInt = RP.ReadTagVEX("dataout", 0, bufpts, "I16", "I16", 2)
    Put #1, , dataSng

    Timer2.Enabled = True
End Sub

Private Sub SecondHalf()
    dataInt = RP.ReadTagVEX("dataout", 0, bufpts, "I16", "I16", 2)
    For i = 0 To bufpts / 2 - 1
        dataSng(0, i) = dataInt(0, i) / 32767
        dataSng(1, i) = dataInt(1, i) / 32767
    Next
    
    'dataInt = RP.ReadTagVEX("dataout", 0, bufpts, "I16", "I16", 2)
    Put #1, , dataSng

    If iteration < NumIterations Then
        Timer1.Enabled = True
        iteration = iteration + 1
        txtIteration.Text = iteration
    Else
        Timer1.Enabled = False
        Timer2.Enabled = False
        RP.SoftTrg (2)
        RP.Halt
        Close #1
        MsgBox "Finished writing data to file: " & OutputFileName
        btnLoadCircuit.Enabled = True
    End If
End Sub

Public Sub Timer1_Timer()
    curindex = RP.GetTagVal("index")
    If curindex >= bufpts Then
        Timer1.Enabled = False
        Call FirstHalf
        samplesAcquired = samplesAcquired + bufpts
        txtSamplesAcquired.Text = samplesAcquired
    End If
End Sub

Public Sub Timer2_Timer()
    curindex = RP.GetTagVal("index")
    If curindex <= bufpts Then
        Timer2.Enabled = False
        Call SecondHalf
        samplesAcquired = samplesAcquired + bufpts
        txtSamplesAcquired.Text = samplesAcquired
    End If
End Sub

Public Sub Form_Unload(Cancel As Integer)
    RP.Halt
End Sub
