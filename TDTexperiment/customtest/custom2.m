echo on;

% %PA5
% PA5=actxcontrol('PA5.x',[5 5 26 26]);
% %[PA5Config.DevNo,PA5Config.InitAtten,PA5Config.AdjustGainFlag]=deal(ChanNo,InitialAtten,AdjustAttenFlag); %Set device # and initial attenuation of PA5
% invoke(PA5,'ConnectPA5','USB',1);
% invoke(PA5,'SetAtten',50);
% %invoke(PA5,'SetAtten',99); %Set large attenuation to suppress noise by RP2 initialization process


RP2=actxcontrol('RPco.x',[5 5 26 26]);
invoke(RP2,'ConnectRP2','USB',1);
invoke(RP2,'ClearCOF');
invoke(RP2,'LoadCOF','custom2.rcx');
invoke(RP2,'LoadCOFsf','custom2.rcx',3);
% 0=6k=6103Hz 1=12k=12207Hz 2=25k=24414Hz 3=50k=48828Hz 4=100k=97656Hz
% 5=200k=195312Hz


% buffersize=Fs*10;
%invoke(RP2,'SetTagVal','buffersize',buffersize);
% bufferpos=0;
% invoke(RP2,'SetTagVal','bufferpos',bufferpos);
Fs=invoke(RP2,'GetSFreq')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rmsV=input('Input rmsV (V) below 0.2V.');
%maxV<1
if rmsV>=0.2
    error('rmsV has to be below 0.2V.')
end;
Status01=invoke(RP2,'GetStatus')
%rmsV=0.2;
maxV=rmsV*5 % rmsV‚ªmaxV‚Ì1/5‚È‚ç‘‚­ƒ‹[ƒv‚©‚ç”²‚¯‚ç‚ê‚é
% WN for VEMP
%Duration=5;
Duration=input('Input Duration (second).');
if Duration>40
    error('Duraion has to be below 40 seconds.')
end;
invoke(RP2,'SetTagVal','StimDur',Duration*1000);
invoke(RP2,'SetTagVal','StimDur2',(Duration+5)*1000);
%assignin('base','Fs',Fs);
L=round(Duration*Fs/2);
PassBand=input('Input PassBand [low high].');
%PassBand=[1000 2000];
Status02=invoke(RP2,'GetStatus')
%FiltCoef=fc;

%%% No need until speaker charactersitic becomes clear
%%%FiltCoef=ones(1,256);

%Make a band of white noise
Freq=(1:L)/L*Fs/2; %Frequency vector (Real part only)
Iout_lo=find(Freq<min(PassBand));%Indeces to the outside of the passband
Iout_hi=find(Freq>max(PassBand));

Amp=ones(size(Freq)); %Amplitude spectrum
% Amp(Iout_lo)=linspace(0,1,length(Iout_lo));
% Amp(Iout_hi)=linspace(1,0,length(Iout_hi));
Amp(Iout_lo)=linspace(0,0,length(Iout_lo));
Amp(Iout_hi)=linspace(0,0,length(Iout_hi));

%Amp(Iout)=0; %Set the gain 0 for the outside of the passband
limit=300;limitM=limit;
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
if size(limitM,2)>=20
    error('Proper noise cannot be made.')
end;
end;

%FiltNoiseT=(rmsFiltNoise)';
%rms = norm(FiltNoiseT)/sqrt(length(FiltNoiseT))
FinNoise=rmsFiltNoise;

Fin_maxV=max(FinNoise)
Fin_rmsV=sqrt(mean(FinNoise.^2))


leng=size(FinNoise,2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time=(0:(1/Fs):(leng-1)/Fs);
%DataIn1=sin(2*pi*500*time);
DataIn1=FinNoise;
invoke(RP2,'WriteTagV','DataIn1',0,DataIn1(1,:));
IndbeforeRun=invoke(RP2,'GetTagVal','Index1')

invoke(RP2,'Run');%‚±‚¿‚ç‚Ìrun‚Å‚à“®‚­
IndbeforeReset=invoke(RP2,'GetTagVal','Index1')

invoke(RP2,'SoftTrg',1);%reset
IndafterReset=invoke(RP2,'GetTagVal','Index1')

%%%invoke(RP2,'SoftTrg',2);
Status1=invoke(RP2,'GetStatus')
%invoke(RP2,'Run');%‚±‚¿‚ç‚Ìrun‚Å‚à“®‚­
Status2=invoke(RP2,'GetStatus')
%%%invoke(RP2,'SoftTrg',1);%reset

%invoke(RP2,'Halt');
%invoke(RP2,'SoftTrg',2);

% bufferpos=invoke(RP2,'GetTagVal','bufferpos');
% 
% resulttone=invoke(RP2,'ReadTagV','resulttone',0,buffersize);
si=size(DataIn1,2);
subplot(2,1,1)

plot(time,DataIn1);hold off;ylim([-2 2]);grid;
xlabel(['FinalmaxV = ' num2str(Fin_maxV,'%10.2f') ' V, FinalrmsV = ' num2str(Fin_rmsV,'%10.2f') ' V']);
assignin('base','DataIn1',DataIn1);

ffty=fft(DataIn1);
LL=(si-1)/2;
fftamp=abs(ffty(2:LL+1));
Freq=(1:LL)/LL*Fs/2;

subplot(2,1,2)
semilogx(Freq,fftamp,'r.');grid;

echo off;   