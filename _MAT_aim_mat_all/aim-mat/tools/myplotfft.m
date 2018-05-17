% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function plotfft(name)
% usage: plotfft('ghfgghfh.wav')

[y,Fs,bits]=wavread(name);

Fn=Fs/2;                  % Nyquist frequency
t=0:1/Fs:length(y)/Fs;    % time vector sampled at Fs Hz,

% Next highest power of 2 greater than or equal to length(y)
NFFT=2.^(ceil(log(length(y))/log(2)));
% Take fft, padding with zeros, length(FFTX)==NFFT
FFTX=fft(y,NFFT);
NumUniquePts = ceil((NFFT+1)/2);
% fft is symmetric, throw away second half
FFTX=FFTX(1:NumUniquePts);
MX=abs(FFTX);            % Take magnitude of X
% Multiply by 2 to take into account the fact that we threw out 
% second half of FFTX above
MX=MX*2;
MX(1)=MX(1)/2;   % Account for endpoint uniqueness
MX(length(MX))=MX(length(MX))/2;  % We know NFFT is even
% Scale the FFT so that it is not a function of the length of y.
MX=MX/length(y);                  %
f=(0:NumUniquePts-1)*2*Fn/NFFT;plot(f,MX);
plot(f,MX);
xlabel('Frequency [Hz]');
ylabel('Magnitude');