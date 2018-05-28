% V to FFTPowerPhase12468
function VtoFFTPowerPhase12468(V)
FFT=fft(V);
FFT(1)=[];
Power=abs(FFT(1:length(FFT)/2)).^2;
nyquist=1/2/0.001;
FreqAxis=(1:length(FFT)/2)/(length(FFT)/2)*nyquist;
Phase=unwrap(angle(FFT(1:length(FFT)/2)))/pi
FFTPowerPhase12468=[FreqAxis([1 2 4 6 8]);Power([1 2 4 6 8]);Phase([1 2 4 6 8])]
