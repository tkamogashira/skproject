% V to F1
function F1=VtoF1(V)
FFT=fft(V);
FFT(1)=[];
Power=abs(FFT(1:length(FFT)/2)).^2;
nyquist=1/2/0.001;
FreqAxis=(1:length(FFT)/2)/(length(FFT)/2)*nyquist;
[PowerF1 IndexF1]=max(Power);
F1=FreqAxis(IndexF1)