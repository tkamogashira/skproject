% V to DFT4HzSinPhaseAmp
function POINT=VtoDFT4HzSinPhaseAmp(V)
FFT=fft(V);
RFFT=[FFT(2:(length(FFT)/2)) FFT(((length(FFT)/2)+2):length(FFT))];
Amp=abs(RFFT(1:length(RFFT)/2))/(length(FFT)/2);
nyquist=1/2/0.001;
FreqAxis=(1:length(RFFT)/2)/(length(FFT)/2)*nyquist;
CosPhase=angle(RFFT(1:length(RFFT)/2))/pi;
SinPhaseL=CosPhase+0.5;
SinPhaseS=CosPhase-1.5;
POINT=[SinPhaseL(1);SinPhaseS(1);Amp(1)];
