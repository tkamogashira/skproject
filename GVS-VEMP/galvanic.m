function galvanic(MAXmA)
RMSmA=MAXmA/4

rmsV=RMSmA/2
maxV=MAXmA/2

% WN for VEMP
Duration=3.5;Fs=4000;assignin('base','Fs',Fs);
L=Duration*Fs/2;PassBand=[1 1000];%Sampling rate=10kHz, Duration=3.5s.

%FiltCoef=fc;

%%% No need until speaker charactersitic becomes clear
%%%FiltCoef=ones(1,256);

%Make a band of white noise
Freq=(1:L)/L*Fs/2; %Frequency vector (Real part only)
Iout_lo=find(Freq<min(PassBand));%Indeces to the outside of the passband
Iout_hi=find(Freq>max(PassBand));

Amp=ones(size(Freq)); %Amplitude spectrum
Amp(Iout_lo)=linspace(0,1,length(Iout_lo));
Amp(Iout_hi)=linspace(1,0,length(Iout_hi));

%Amp(Iout)=0; %Set the gain 0 for the outside of the passband
limit=3;limitM=limit;
while limit>=maxV
Phase=(rand(size(Amp))*2-1)*pi; %Phase spectrum -- random
x=Amp.*exp(sqrt(-1)*Phase); %Complex representation of the signal
Noise1=RealIFFT(x); %Get the time representation
%Noise2=Cos2RampMs(Noise1,100,Fs); %Apply 100ms ramps
Noise2=Noise1;

%OrigSPL=20*log10(sqrt(mean(Noise.^2))); %SPL of the original noise 
%Noise3=[Noise2 zeros(size(Noise2))]; %Double the # of points by padding with zeros
OrigSPL=20*log10(sqrt(mean(Noise2.^2))); %SPL of the original noise 

%%% No need until speaker charactersitic becomes clear
%FiltNoise1=filter(FiltCoef,1,Noise2); %FIR filtering

%Scale the signal so that the maximum unsigned amplitude is no greater than maxv V %%%SK

%RMS=sqrt(mean(FiltNoise(1:2*L).^2)); 
%RMS=sqrt(mean(FiltNoise.^2)); 
%Scale=10/max(abs(FiltNoise(:))); %%%SK
%%%Scale=maxv/max(abs(FiltNoise1(:)));

rmsScale=rmsV/sqrt(mean(Noise2.^2));
rmsFiltNoise=Noise2*rmsScale; %Scale the signal

rmsMAX=max(rmsFiltNoise)
rmsRMS=sqrt(mean(rmsFiltNoise.^2))

limit=rmsMAX;limitM=[limitM limit];
end;

%FiltNoiseT=(rmsFiltNoise)';
%rms = norm(FiltNoiseT)/sqrt(length(FiltNoiseT))
FinNoise=rmsFiltNoise;

Fin_maxV=max(FinNoise)
Fin_rmsV=sqrt(mean(FinNoise.^2))

Fin_MAXmA=Fin_maxV*2;
Fin_RMSmA=Fin_rmsV*2;


p1=zeros(1,0.5*Fs);
p2=ones(1,0.5*Fs)*(-5);
p3=ones(1,10)*5;
p4=ones(1,4.5*Fs-10)*(-5);
p5=ones(1,10)*5;
p6=ones(1,3*Fs-10)*(-5);
p7=zeros(1,1.5*Fs+1);
tr=([p1 p2 p3 p4 p5 p6 p7])';
assignin('base','tr',tr);
Len=10;
time=(0:1/Fs:Len);

q=zeros(1,Len*Fs+1);
q(1,(0.5*Fs+1):((0.5+Duration)*Fs))=FinNoise;
q(1,(5*Fs+1):((5+Duration)*Fs))=FinNoise*(-1);
bn=q';
assignin('base','bn',bn);
ind=find(tr==5);
cancelcheck=sum(bn(ind));

subplot(3,1,1)
semilogx(Freq,Amp,'r.')
grid;
subplot(3,1,2)
plot(time,bn,'b',time,tr,'r')
set(gca,'Ygrid','on');set(gca,'Xgrid','on');grid(gca,'minor')
title(['MAXmA=' num2str(MAXmA) ' RMSmA=' num2str(RMSmA)]);

%ffty=fft(Noise2)/L;
% ffty1=fft(Noise1);
% fftamp1=abs(ffty1(2:L+1));
% subplot(4,1,3)
% semilogx(Freq,fftamp1,'r.');grid;

ffty2=fft(FinNoise);
fftamp2=abs(ffty2(2:L+1));
subplot(3,1,3)
semilogx(Freq,fftamp2,'r.');grid;
title(['FinalMAXmA=' num2str(Fin_MAXmA) ' FinalRMSmA=' num2str(Fin_RMSmA) ' FinalmaxV=' num2str(Fin_maxV) ' FinalrmsV=' num2str(Fin_rmsV)]);

% ffty3=fft(FinNoise);
% fftamp3=abs(ffty3(2:L+1));
% subplot(5,1,5)
% semilogx(Freq,fftamp3,'r');grid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ao=analogoutput('nidaq','Dev1');
% chan=addchannel(ao,0:1);
% 
% set(ao,'SampleRate',Fs);
% set(ao,'TriggerType','Manual');
% % duration=10;
% % time=(0:(1/fs):duration);
% % f=500;
% % data=sin(2*pi*f*time)';
% % putdata(ao,[data data]);
% putdata(ao,[bn tr]);
%start(ao)
