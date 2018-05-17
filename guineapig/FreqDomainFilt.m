function xout=FreqDomainFilt(x_in,Fs,CutOffFreq,FiltType,Amp)

%  The Statement Must be
%  ' xout=FreqDomainFilt(x_in,Fs,CutOffFreq,FiltType,Amp) '
% FiltType will be 'bandpass' if you don't  input it
% Amp will be 1 if you don't input it


if nargin<4
    FiltType='bandpass';
end

if nargin<5
    Amp=1;
end

%Pad zeroes if necessary
NOrig=length(x_in);
NPad=2.^nextpow2(NOrig) - NOrig;

x=[x_in(:)' zeros(1,NPad)];
N=length(x);

%Frequency
Freq=linspace(0,Fs-Fs/N,N);
Freq=Freq(1:(N/2+1));

%Set weighting vector
W=zeros(1,N/2+1);
switch lower(FiltType)
    case 'bandpass'
        I=find(Freq>=CutOffFreq(1) & Freq<=CutOffFreq(2));
    case 'highpass'
        I=find(Freq>=CutOffFreq(1));
    case 'lowpass'
        I=find(Freq<=CutOffFreq(1));
    case 'bandstop'
        I=find(Freq<=CutOffFreq(1) | Freq>=CutOffFreq(2));
    otherwise
        error(['Unrecognized filter type: ' FiltType]);
end
W(I)=Amp;

%Make the weighting vector two-sided
W=[W W((end-1):-1:2)];

%FFT the input
X=fft(x);

%Apply the filter
X=X.*W;

%Back to time domain
xout=real(ifft(X));
xout=xout(1:NOrig);
% 
% XPhase=angle(X);
% XAmplitude=abs(X);
% XPhase_TwoSided=[-XPhase XPhase((end-1):-1:2)];
% XAmplitude_TwoSided=[XAmplitude XAmplitude((end-1):-1:2)]*(N-1);
% X=XAmplitude_TwoSided.*(cos(XPhase_TwoSided)+sqrt(-1)*sin(XPhase_TwoSided));
% x=ifft(X);
