

#pragma rtGlobals=1		// Use modern global access method.
#include <NIDAQmxWaveFormGenProcs>
//#include <NIDAQmxWaveFIFOProcs>

function halfhalf()
//string Wnam

Make /N=100000/O tri1
SetScale/P x 0, 0.0001,"s", tri1

tri1[0,99999] = -5
tri1[0,4999] = 0

tri1[10000, 10009]=5;
//tri1[12000, 12009]=5;tri1[14000, 14009]=5;tri1[16000, 16009]=5;tri1[18000, 18009]=5
//tri1[20000, 20009]=5;tri1[22000, 22009]=5;tri1[24000, 24009]=5;tri1[26000, 26009]=5;tri1[28000, 28009]=5
//tri1[30000, 30009]=5;tri1[32000, 32009]=5;tri1[34000, 34009]=5;tri1[36000, 36009]=5;tri1[38000, 38009]=5

//tri1[45000, 45009]=5;tri1[47000, 47009]=5;tri1[49000, 49009]=5;tri1[51000, 51009]=5;tri1[53000, 53009]=5
tri1[55000, 55009]=5;
//tri1[57000, 57009]=5;tri1[59000, 59009]=5;tri1[61000, 61009]=5;tri1[63000, 63009]=5
//tri1[65000, 65009]=5;tri1[67000, 67009]=5;tri1[69000, 69009]=5;tri1[71000, 71009]=5;tri1[73000, 73009]=5

tri1[85000,99999] = 0


WAVE f1=root:f1


SetScale/P x 0, 0.0001,"s", f1


Make /N=100000/O f1_2
WAVE f1=root:f1

f1_2[0,4999]=0
f1_2[5000,38999]=f1[p-5000]*0.2
f1_2[39000,49999]=0
f1_2[50000,83999]=f1[p-40000]*(-0.2)
f1_2[84000,99999] = 0
SetScale/P x 0, 0.0001,"s", f1_2

Display  tri1, f1_2

modifygraph rgb(f1_2)=(0,0,65535)

//DAQmx_WaveformGen/DEV="dev1" "tri1,0,-5,5"

End
