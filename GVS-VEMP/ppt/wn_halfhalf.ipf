#pragma rtGlobals=1		// Use modern global access method.
//#include <NIDAQmxWaveFormGenProcs>
//#include <NIDAQmxWaveFIFOProcs>

function wn_halfhalf()
//string Wnam

Make /N=180000/O tri1
SetScale/P x 0, 0.00005,"s", tri1

tri1[0,179999] = -5
tri1[0,9999] = 0
tri1[20000, 20009]=5;
tri1[110000, 110009]=5;
tri1[170000,179999] = 0

WAVE wn1=root:wn1
SetScale/P x 0, 0.00005,"s", wn1
Make /N=180000/O wn1_2
wn1_2[0,9999]=0
wn1_2[10000,79999]=wn1[p-10000]*2
wn1_2[80000,99999]=0
wn1_2[100000,169999]=wn1[p-100000]*(-2)
wn1_2[170000,179999] = 0
SetScale/P x 0, 0.00005,"s", wn1_2

WAVE wn2=root:wn2
SetScale/P x 0, 0.00005,"s", wn2
Make /N=180000/O wn2_2
wn2_2[0,9999]=0
wn2_2[10000,79999]=wn2[p-10000]*2
wn2_2[80000,99999]=0
wn2_2[100000,169999]=wn2[p-100000]*(-2)
wn2_2[170000,179999] = 0
SetScale/P x 0, 0.00005,"s", wn2_2

WAVE wn3=root:wn3
SetScale/P x 0, 0.00005,"s", wn3
Make /N=180000/O wn3_2
wn3_2[0,9999]=0
wn3_2[10000,79999]=wn3[p-10000]*2
wn3_2[80000,99999]=0
wn3_2[100000,169999]=wn3[p-100000]*(-2)
wn3_2[170000,179999] = 0
SetScale/P x 0, 0.00005,"s", wn3_2

WAVE wn4=root:wn4
SetScale/P x 0, 0.00005,"s", wn4
Make /N=180000/O wn4_2
wn4_2[0,9999]=0
wn4_2[10000,79999]=wn4[p-10000]*2
wn4_2[80000,99999]=0
wn4_2[100000,169999]=wn4[p-100000]*(-2)
wn4_2[170000,179999] = 0
SetScale/P x 0, 0.00005,"s", wn4_2

WAVE wn5=root:wn5
SetScale/P x 0, 0.00005,"s", wn5
Make /N=180000/O wn5_2
wn5_2[0,9999]=0
wn5_2[10000,79999]=wn5[p-10000]*2
wn5_2[80000,99999]=0
wn5_2[100000,169999]=wn5[p-100000]*(-2)
wn5_2[170000,179999] = 0
SetScale/P x 0, 0.00005,"s", wn5_2

WAVE wn6=root:wn6
SetScale/P x 0, 0.00005,"s", wn6
Make /N=180000/O wn6_2
wn6_2[0,9999]=0
wn6_2[10000,79999]=wn6[p-10000]*2
wn6_2[80000,99999]=0
wn6_2[100000,169999]=wn6[p-100000]*(-2)
wn6_2[170000,179999] = 0
SetScale/P x 0, 0.00005,"s", wn6_2

WAVE wn7=root:wn7
SetScale/P x 0, 0.00005,"s", wn7
Make /N=180000/O wn7_2
wn7_2[0,9999]=0
wn7_2[10000,79999]=wn7[p-10000]*2
wn7_2[80000,99999]=0
wn7_2[100000,169999]=wn7[p-100000]*(-2)
wn7_2[170000,179999] = 0
SetScale/P x 0, 0.00005,"s", wn7_2

WAVE wn8=root:wn8
SetScale/P x 0, 0.00005,"s", wn8
Make /N=180000/O wn8_2
wn8_2[0,9999]=0
wn8_2[10000,79999]=wn8[p-10000]*2
wn8_2[80000,99999]=0
wn8_2[100000,169999]=wn8[p-100000]*(-2)
wn8_2[170000,179999] = 0
SetScale/P x 0, 0.00005,"s", wn8_2

WAVE wn9=root:wn9
SetScale/P x 0, 0.00005,"s", wn9
Make /N=180000/O wn9_2
wn9_2[0,9999]=0
wn9_2[10000,79999]=wn9[p-10000]*2
wn9_2[80000,99999]=0
wn9_2[100000,169999]=wn9[p-100000]*(-2)
wn9_2[170000,179999] = 0
SetScale/P x 0, 0.00005,"s", wn9_2

WAVE wn10=root:wn10
SetScale/P x 0, 0.00005,"s", wn10
Make /N=180000/O wn10_2
wn10_2[0,9999]=0
wn10_2[10000,79999]=wn10[p-10000]*2
wn10_2[80000,99999]=0
wn10_2[100000,169999]=wn10[p-100000]*(-2)
wn10_2[170000,179999] = 0
SetScale/P x 0, 0.00005,"s", wn10_2


Display  tri1, wn1_2
modifygraph rgb(wn1_2)=(0,0,65535)

Display  tri1, wn2_2
modifygraph rgb(wn2_2)=(0,0,65535)

Display  tri1, wn3_2
modifygraph rgb(wn3_2)=(0,0,65535)

Display  tri1, wn4_2
modifygraph rgb(wn4_2)=(0,0,65535)

Display  tri1, wn5_2
modifygraph rgb(wn5_2)=(0,0,65535)

Display  tri1, wn6_2
modifygraph rgb(wn6_2)=(0,0,65535)

Display  tri1, wn7_2
modifygraph rgb(wn7_2)=(0,0,65535)

Display  tri1, wn8_2
modifygraph rgb(wn8_2)=(0,0,65535)

Display  tri1, wn9_2
modifygraph rgb(wn9_2)=(0,0,65535)

Display  tri1, wn10_2
modifygraph rgb(wn10_2)=(0,0,65535)



//DAQmx_WaveformGen/DEV="dev1" "tri1,0,-5,5"

End
