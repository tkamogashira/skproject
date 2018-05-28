% V to FFTPhaseConti
function VtoFFTPhaseConti(V)
FFT=fft(V);
FFT(1)=[];
Power=abs(FFT(1:length(FFT)/2)).^2;
nyquist=1/2/0.001;
FreqAxis=(1:length(FFT)/2)/(length(FFT)/2)*nyquist;
Phase=unwrap(angle(FFT(1:length(FFT)/2)))/pi
FFTPhaseConti=[FreqAxis;Phase]
