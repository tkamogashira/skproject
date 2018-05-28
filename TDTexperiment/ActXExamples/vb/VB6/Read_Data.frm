VERSION 5.00
Begin VB.Form frmMain 
   Caption         =   "Read Data"
   ClientHeight    =   1020
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4170
   LinkTopic       =   "Form1"
   ScaleHeight     =   1020
   ScaleWidth      =   4170
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox cmbNumChans 
      Height          =   315
      ItemData        =   "Read_Data.frx":0000
      Left            =   1440
      List            =   "Read_Data.frx":000A
      TabIndex        =   1
      Text            =   "2"
      Top             =   360
      Width           =   615
   End
   Begin VB.CommandButton btnReadData 
      Caption         =   "Read Data"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   2280
      TabIndex        =   0
      Top             =   240
      Width           =   1695
   End
   Begin VB.Label Label1 
      Caption         =   "Num Channels"
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   360
      Width           =   1095
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Reads data from a binary data file of singles

Const DataFile1 = "C:\TDT\ActiveX\ActXExamples\vb\VB6\tones.dat"
Const DataFile2 = "C:\TDT\ActiveX\ActXExamples\vb\VB6\2CHtones.dat"

Dim data1() As Single   'buffer for holding one-channel data
Dim data2() As Single   'buffer for holding two-channel data
Dim temp As Single
Dim lByteLen1 As Long   'length of one-channel file
Dim lByteLen2 As Long   'length of two-channel file
Dim numChan As Integer  'number of channels in data
Dim iFile1 As Integer
Dim iFile2 As Integer

Private Sub Form_Load()

    'open files for reading
    iFile1 = FreeFile
    Open DataFile1 For Binary As iFile1
    lByteLen1 = LOF(iFile1)
    
    iFile2 = FreeFile
    Open DataFile2 For Binary As iFile2
    lByteLen2 = LOF(iFile2)
End Sub

Private Sub btnReadData_Click()

    numChan = CInt(cmbNumChans.Text)

    Select Case numChan
        Case 1
            ReDim data1(lByteLen1 / 4 - 1)    '4 bytes per single

            'write data file to data array
            Get iFile1, , data1()
            Seek iFile1, 1
        Case 2
        
            ReDim data2(0 To 1, lByteLen2 / 8 - 1)   'two channels, 4 bytes per single
            
            'write data file to data array
            For i = 0 To lByteLen2 / 8 - 1
                Get iFile2, , temp
                data2(0, i) = temp
                Get iFile2, , temp
                data2(1, i) = temp
            Next
            
            Seek iFile2, 1
    End Select
                
End Sub

Private Sub Form_Unload(Cancel As Integer)
    'close data file
    Close iFile1
    Close iFile2
End Sub
