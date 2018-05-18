

#pragma rtGlobals=1		// Use modern global access method.
#include <NIDAQmxWaveFormGenProcs>
//#include <NIDAQmxWaveFIFOProcs>

function tri_sine()
//string Wnam

Make /N=90000/O tri1
SetScale/P x 0, 0.0001,"s", tri1

tri1[0,90000] = -5
tri1[0,4999] = 0

tri1[10000, 10009]=5;tri1[12000, 12009]=5;tri1[14000, 14009]=5;tri1[16000, 16009]=5;tri1[18000, 18009]=5
tri1[20000, 20009]=5;tri1[22000, 22009]=5;tri1[24000, 24009]=5;tri1[26000, 26009]=5;tri1[28000, 28009]=5
tri1[30000, 30009]=5;tri1[32000, 32009]=5;tri1[34000, 34009]=5;tri1[36000, 36009]=5;tri1[38000, 38009]=5

tri1[45000, 45009]=5;tri1[47000, 47009]=5;tri1[49000, 49009]=5;tri1[51000, 51009]=5;tri1[53000, 53009]=5
tri1[55000, 55009]=5;tri1[57000, 57009]=5;tri1[59000, 59009]=5;tri1[61000, 61009]=5;tri1[63000, 63009]=5
tri1[65000, 65009]=5;tri1[67000, 67009]=5;tri1[69000, 69009]=5;tri1[71000, 71009]=5;tri1[73000, 73009]=5

tri1[85000,90000] = 0


Make /N=90000/O Sinewave
SetScale/P x 0, 0.0001,"s", Sinewave
Sinewave=sin(2*pi*5*x)


Display  tri1, Sinewave

modifygraph rgb(Sinewave)=(0,0,65535)

//DAQmx_WaveformGen/DEV="dev1" "tri1,0,-5,5"

End
