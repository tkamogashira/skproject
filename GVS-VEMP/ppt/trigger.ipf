#pragma rtGlobals=1		// Use modern global access method.
#include <NIDAQmxWaveFormGenProcs>

Macro MakeTrigger(Wnam)
string Wnam

Make /N=4900/O $Wnam
SetScale/P x 0,0.00001,"s", $Wnam

$Wnam= -5
$Wnam[1000, 1099] = 5



SetScale/P x 0, 0.0001,"s", wave1

Display  $Wnam, wave0
End
