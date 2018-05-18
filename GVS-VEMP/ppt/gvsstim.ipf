#pragma rtGlobals=1		// Use modern global access method.
//#include <NIDAQmxWaveFormGenProcs>
//#include <NIDAQmxWaveFIFOProcs>

function gvsstim()
//string Wnam

Make /N=90000/O wave1
SetScale/P x 0, 0.0001,"s", wave1

wave1[0,90000] = -5
wave1[10000, 10009]=5;wave1[12000, 12009]=5;wave1[14000, 14009]=5;wave1[16000, 16009]=5;wave1[18000, 18009]=5
wave1[20000, 20009]=5;wave1[22000, 22009]=5;wave1[24000, 24009]=5;wave1[26000, 26009]=5;wave1[28000, 28009]=5
wave1[30000, 30009]=5;wave1[32000, 32009]=5;wave1[34000, 34009]=5;wave1[36000, 36009]=5;wave1[38000, 38009]=5
wave1[40000, 40009]=5;wave1[42000, 42009]=5;wave1[44000, 44009]=5;wave1[46000, 46009]=5;wave1[48000, 48009]=5
wave1[50000, 50009]=5;wave1[52000, 52009]=5;wave1[54000, 54009]=5;wave1[56000, 56009]=5;wave1[58000, 58009]=5
wave1[60000, 60009]=5;wave1[62000, 62009]=5;wave1[64000, 64009]=5;wave1[66000, 66009]=5;wave1[68000, 68009]=5



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
WAVE f1=root:f1
ff1[0,90000]=f1[p]/10
SetScale/P x 0, 0.0001,"s", ff1

Display  wave1, f1, ff1

modifygraph rgb(f1)=(0,65535,0)
modifygraph rgb(ff1)=(0,0,65535)

//DAQmx_WaveformGen/DEV="dev1" "wave1,0,-5,5;f1,1,-5,5"

End
