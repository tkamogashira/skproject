#pragma rtGlobals=1		// Use modern global access method.
#include <NIDAQmxWaveFormGenProcs>

Macro MakeTrigger(Wnam)
string Wnam

Make /N=90000/O $Wnam
SetScale/P x 0, 0.0001,"s", $Wnam

$Wnam= -5
$Wnam[10000, 10009] = 5
$Wnam[12000, 12009] = 5
$Wnam[14000, 14009] = 5
$Wnam[16000, 16009] = 5
$Wnam[18000, 18009] = 5

$Wnam[20000, 20009] = 5
$Wnam[22000, 22009] = 5
$Wnam[24000, 24009] = 5
$Wnam[26000, 26009] = 5
$Wnam[28000, 28009] = 5

$Wnam[30000, 30009] = 5
$Wnam[32000, 32009] = 5
$Wnam[34000, 34009] = 5
$Wnam[36000, 36009] = 5
$Wnam[38000, 38009] = 5

$Wnam[40000, 40009] = 5
$Wnam[42000, 42009] = 5
$Wnam[44000, 44009] = 5
$Wnam[46000, 46009] = 5
$Wnam[48000, 48009] = 5

$Wnam[50000, 50009] = 5
$Wnam[52000, 52009] = 5
$Wnam[54000, 54009] = 5
$Wnam[56000, 56009] = 5
$Wnam[58000, 58009] = 5

$Wnam[60000, 60009] = 5
$Wnam[62000, 62009] = 5
$Wnam[64000, 64009] = 5
$Wnam[66000, 66009] = 5
$Wnam[68000, 68009] = 5



SetScale/P x 0, 0.0001,"s", f1
SetScale/P x 0, 0.0001,"s", f2
SetScale/P x 0, 0.0001,"s", f3
SetScale/P x 0, 0.0001,"s", f4
SetScale/P x 0, 0.0001,"s", f5
SetScale/P x 0, 0.0001,"s", f6
SetScale/P x 0, 0.0001,"s", f7
SetScale/P x 0, 0.0001,"s", f8
SetScale/P x 0, 0.0001,"s", f9
SetScale/P x 0, 0.0001,"s", f10

Make /N=90000/O ff1
ff1=f1/10
SetScale/P x 0, 0.0001,"s", ff1
Make /N=90000/O fff1
fff1=f1/100
SetScale/P x 0, 0.0001,"s", fff1
Display  $Wnam, fff1
End
