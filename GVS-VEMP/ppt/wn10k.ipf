#pragma rtGlobals=1		// Use modern global access method.
//#include <NIDAQmxWaveFormGenProcs>
//#include <NIDAQmxWaveFIFOProcs>

function wn10k()
//string Wnam

Make /N=100000/O tri1
SetScale/P x 0, 0.0001,"s", tri1

tri1[0,99999] = -5
tri1[0,4999] = 0
tri1[10000, 10009]=5;
tri1[60000, 60009]=5;
tri1[90000,99999] = 0

WAVE wn1=root:wn1
SetScale/P x 0, 0.0001,"s", wn1
Make /N=100000/O wn1_2
wn1_2[0,4999]=0
wn1_2[5000,44999]=wn1[p-5000]*2
wn1_2[45000,54999]=0
wn1_2[55000,94999]=wn1[p-55000]*(-2)
wn1_2[95000,99999] = 0
SetScale/P x 0, 0.0001,"s", wn1_2

WAVE wn2=root:wn2
SetScale/P x 0, 0.0001,"s", wn2
Make /N=100000/O wn2_2
wn2_2[0,4999]=0
wn2_2[5000,44999]=wn2[p-5000]*2
wn2_2[45000,54999]=0
wn2_2[55000,94999]=wn2[p-55000]*(-2)
wn2_2[95000,99999] = 0
SetScale/P x 0, 0.0001,"s", wn2_2

WAVE wn3=root:wn3
SetScale/P x 0, 0.0001,"s", wn3
Make /N=100000/O wn3_2
wn3_2[0,4999]=0
wn3_2[5000,44999]=wn3[p-5000]*2
wn3_2[45000,54999]=0
wn3_2[55000,94999]=wn3[p-55000]*(-2)
wn3_2[95000,99999] = 0
SetScale/P x 0, 0.0001,"s", wn3_2



Display  tri1, wn1_2
modifygraph rgb(wn1_2)=(0,0,65535)

Display  tri1, wn2_2
modifygraph rgb(wn2_2)=(0,0,65535)

Display  tri1, wn3_2
modifygraph rgb(wn3_2)=(0,0,65535)

//DAQmx_WaveformGen/DEV="dev1" "tri1,0,-5,5"

End
