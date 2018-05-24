function PlotFFT(x, Fs);
% PLOTFFT Plot the FFT of a signal. It takes as arguments the signal and the sampling frequnecy,
% and plots the FFT in a figure window.
% PlotFFT(x,Fs) Plots the magnitude of the FFT of the signal x with sampling frequency Fs


Fn=Fs/2;                  % Nyquist frequency
NFFT=2.^(ceil(log(length(x))/log(2)));
% Take fft, padding with zeros, length(FFTX)==NFFT
FFTX=fft(x,NFFT);
NumUniquePts = ceil((NFFT+1)/2);
% fft is symmetric, throw away second half
FFTX=FFTX(1:NumUniquePts);
MX=abs(FFTX);            % Take magnitude of X
% Multiply by 2 to take into account the fact that we
% threw out second half of FFTX above
MX=MX*2;
MX(1)=MX(1)/2;   % Account for endpoint uniqueness
MX(length(MX))=MX(length(MX))/2;  % We know NFFT is even
% Scale the FFT so that it is not a function of the 
% length of x.
MX=MX/length(x);                  %
f=(0:NumUniquePts-1)*2*Fn/NFFT;
plot(f,MX);