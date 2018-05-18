#pragma rtGlobals=1		// Use modern global access method.
//#include <NIDAQmxWaveFormGenProcs>
//#include <NIDAQmxWaveFIFOProcs>

function tri_tenthnoise()
//string Wnam

Make /N=90000/O tri1
SetScale/P x 0, 0.0001,"s", tri1

tri1[0,90000] = -5

tri1[20000, 20009]=5;tri1[22000, 22009]=5;tri1[24000, 24009]=5;tri1[26000, 26009]=5;tri1[28000, 28009]=5
tri1[30000, 30009]=5;tri1[32000, 32009]=5;tri1[34000, 34009]=5;tri1[36000, 36009]=5;tri1[38000, 38009]=5
tri1[40000, 40009]=5;tri1[42000, 42009]=5;tri1[44000, 44009]=5;tri1[46000, 46009]=5;tri1[48000, 48009]=5
tri1[50000, 50009]=5;tri1[52000, 52009]=5;tri1[54000, 54009]=5;tri1[56000, 56009]=5;tri1[58000, 58009]=5
tri1[60000, 60009]=5;tri1[62000, 62009]=5;tri1[64000, 64009]=5;tri1[66000, 66009]=5;tri1[68000, 68009]=5
tri1[70000, 70009]=5;tri1[72000, 72009]=5;tri1[74000, 74009]=5;tri1[76000, 76009]=5;tri1[78000, 78009]=5
tri1[0,9999] = 0;tri1[85000,90000] = 0


WAVE f1=root:f1
WAVE f2=root:f2
WAVE f3=root:f3
WAVE f4=root:f4
WAVE f5=root:f5
WAVE f6=root:f6
WAVE f7=root:f7
WAVE f8=root:f8
WAVE f9=root:f9
WAVE f10=root:f10

f1[0,9999]=0;f1[85000,90000] = 0
f2[0,9999]=0;f2[85000,90000] = 0
f3[0,9999]=0;f3[85000,90000] = 0
f4[0,9999]=0;f4[85000,90000] = 0
f5[0,9999]=0;f5[85000,90000] = 0
f6[0,9999]=0;f6[85000,90000] = 0
f7[0,9999]=0;f7[85000,90000] = 0
f8[0,9999]=0;f8[85000,90000] = 0
f9[0,9999]=0;f9[85000,90000] = 0
f10[0,9999]=0;f10[85000,90000] = 0

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

Make /N=90000/O f1_2
WAVE f1=root:f1
f1_2[0,90000]=f1[p]*2
f1_2[0,9999]=0;f1_2[85000,90000] = 0
SetScale/P x 0, 0.0001,"s", f1_2

Display  tri1, f1_2, f1

modifygraph rgb(f1)=(0,65535,0)
modifygraph rgb(f1_2)=(0,0,65535)

//DAQmx_WaveformGen/DEV="dev1" "tri1,0,-5,5"

End
