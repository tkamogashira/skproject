function Rtn=GetFiltCoefSK(ChanNo,PassBand,NFiltCoef,InitialAtten,AdjustAttenFlag,MicSensitivity,PlotFlag)
%GetFiltCoef -- Get FIR filter coefficient by using Golay code.
%The procedure consists of two stages. In the 1st stage, it plays a pair of
%Golay codes and record the response; compute the system frequency response
%and make filter cofficient based on the inverse transfer function. In the
%2nd stage, it plays a band of white noise that is flattened by the FIR
%filtering, and record the response to check the output has a flat spectrum.
%
%Usage: Rtn=GetFiltCoef(ChanNo,PassBand,NFiltCoef,PlotFlag)
%<<Input Variables>>
%ChanNo: Channel number for RP2 and PA5 that determines L or R of the earphonse
%           ChanNo=1 --> Left; ChanNo=2 --> Right
%PassBand: (1-by-2 vector) Lower and higher ends of the passband (Hz)
%NFiltCoef: # of points of the filter coefficient
%PlotFlag: If non-zero, plots the system frequency response, filter coefficient,
%           and the spectrum of the flattened noise. (Default 0)
%
%<<Out Variable>> 
%Rtn: Structure with following fields
%   Fs: Device sampling frequency (Hz)
%   FiltCoef: FIR filter coefficient
%   FiltGain: Gain by FIR filtering
%   FiltDelayPts: Delay by filtering in #Pts
%   SysResp.H: Measured frequency response of the system (complex)
%   SysResp.Freq: frequency axis for H (Hz)
%   FlatNoise.AmpSpec: Amplitude spectrum of the flattened noise (linear)
%   FlatNoise.Freq:  frequency axis for AmpSpec (Hz)
%
%
%By SF, 7/31/01

if nargin<7
    PlotFlag=0;
end

%Initialize the outputs
Rtn=[];

% Fixed parameters
NGolay=12; %# of points of A or B code is 2^NGolay
%MaxSPL=104; %Maximum SPL allowed to play from the earphone
MaxSPL=96; %Maximum SPL allowed to play from the earphone ER-2 %%%SK
%MaxVolt=3; %Maximum voltage allowed to feed to the earphone (Set 3 V for Etymotic ER4) %%%SK
MaxVolt=0.35; %Maximum voltage allowed to feed to the earphone (Set 0.35 V for RB-52T)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Get the system frequency response by using golay codes.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% Create a pair of Golay codes to play %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[A,B]=MakeGolay(NGolay);
L=2^NGolay;
Ain=[A zeros(size(A))]; %Double the number of points by appending zeros
Bin=[B zeros(size(B))];
DataIn=[Ain Bin]; %Concatenate A and B
%Scale the signal so that the RMS is less than MaxVolt (V),
%and that the maximum unsigned amplitude is no greater than 10 V %%%SK
RMS=sqrt(mean([A B].^2)); 
%Scale=min([10/abs(max(DataIn(:))) MaxVolt/RMS]); %%%SK
Scale=min([0.35/abs(max(DataIn(:))) MaxVolt/RMS]);
DataIn=DataIn*Scale;

%%%%%%%%%%%%%% Play and record the signal. Level was adapted to optimize the SN %%%%%
[RP2Config.DevNo,RP2Config.DAChan,RP2Config.ADChan]=deal(1,ChanNo,ChanNo); %Set device # and channel numbers of RP2
%[PA5Config.DevNo,PA5Config.InitAtten,PA5Config.AdjustGainFlag]=deal(ChanNo,50,1); %Set device # and initial attenuation of PA5
[PA5Config.DevNo,PA5Config.InitAtten,PA5Config.AdjustGainFlag]=deal(ChanNo,InitialAtten,AdjustAttenFlag); %Set device # and initial attenuation of PA5
[DataOut,Atten,SysEnv]=PlayAndRecordAttenSK(DataIn,length(DataIn),RP2Config,PA5Config,MaxSPL,MicSensitivity); %Play and record%%%SK

Fs=SysEnv.Fs; %Actual sampling rate
%Check if the nominal sampling rate is consistent with the rate set in the RCO file
%if abs(Fs-NominalFs)/NominalFs>0.1
%   disp(sprintf('Nominal Fs : %f\nActual Fs : %f',NominalFs,Fs));
%   error('Nominal and actual sampling rate are inconsistent!');
%end

%%%%%%%%%%%%%%%%%%% Compute the speaker response %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FreqSh=(-L:(L-1))/L*Fs/2; %Frequency vector for FFTSHIFTed spectrum
n=L*2; %Number of points for each of A and B code
Aout=DataOut(1:n); %Extract parts that includes responses to A and B
Bout=DataOut((1:n)+n); 
%Scale the response for comparable unit to Ain and Aout
myAout=Aout/Scale/10.^(-Atten/20);
myBout=Bout/Scale/10.^(-Atten/20);

H=(fft(myAout).*conj(fft(Ain))+fft(myBout).*conj(fft(Bin)))/2/L; %Frequency Response
%H=(fft(Aout).*conj(fft(Ain))+fft(Bout).*conj(fft(Bin)))/2/L; %Frequency Response
HSh=fftshift(H); 

%%%%%%%%%%%%%%%%% Plot speaker response %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PlotFlag
    clf
    
    subplot(3,1,1)
    plot(FreqSh/1000,20*log10(abs(HSh)));
    xlim([0 Fs/2/1000]);
    title('System Frequency Response');
    xlabel('Frequency (kHz)');
    ylabel('Gain (dB)');
    drawnow
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Obtain inverse filter
HSh_inv=1./HSh; %inverse
ILo=find(abs(FreqSh)<min(PassBand)); %Set constant values for freqs lower than the passband
HSh_inv(ILo)=HSh_inv(ILo(end));
IHi=find(FreqSh>max(PassBand)); %Set constant values for freqs higher than the passband
HSh_inv(IHi)=HSh_inv(IHi(1));
IHi=find(FreqSh<-max(PassBand)); %Set constant values for freqs higher than the passband
HSh_inv(IHi)=HSh_inv(IHi(end));
IZero=find(FreqSh==0);
HSh_inv([IZero 1 end])=0;
H_inv=fftshift(HSh_inv); %Back to regular frequecy order (ie 0~Fs)
if 0
    myHSh=HSh;
    ILo=find(abs(FreqSh)<min(PassBand)); %Set constant values for freqs lower than the passband
    myHSh(ILo)=HSh(ILo(end));
    IHi=find(FreqSh>max(PassBand)); %Set constant values for freqs higher than the passband
    myHSh(IHi)=HSh(IHi(1));
    IHi=find(FreqSh<-max(PassBand)); %Set constant values for freqs higher than the passband
    myHSh(IHi)=HSh(IHi(end));
    HSh_inv=1./myHSh; %inverse
    IZero=find(FreqSh==0);
    HSh_inv([IZero 1 end])=0;
    H_inv=fftshift(HSh_inv); %Back to regular frequecy order (ie 0~Fs)
end
%keyboard

% Time-domain representation of the inverse filter %%%%%%%%%%%%%%%%%%%%
h_inv=real(ifft(H_inv)); %IFFT
FiltCoef=fftshift(h_inv); %Bring the peaky parts to the center
%Use the filter range with maximum RMS
BaseMax=0;
MaxRMS=-inf;
for Base=0:(length(FiltCoef)-NFiltCoef)
    rng=Base+(1:NFiltCoef);
    myRMS=sqrt(mean(FiltCoef(rng).^2));
    if myRMS>MaxRMS
        BaseMax=Base;
        MaxRMS=myRMS;
    end
end
FiltCoef=FiltCoef(BaseMax+(1:NFiltCoef));
%FiltCoef=FiltCoef([-(NFiltCoef/2-1):(NFiltCoef/2)]+L); %Extract the middle part
FiltCoef=FiltCoef/sum(FiltCoef); %Scale
FiltCoef=LinRampNPts(FiltCoef,8); %Put ramps

%Plot the filter coefficient
if PlotFlag
    subplot(3,1,2)
    plot(FiltCoef)
    xlim([1 length(FiltCoef)]);
    title('Coefficients of the FIR filter');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    Play noise burst to check if the response is flattened and to obtain the system gain.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Make a band of white noise
Freq=(1:L)/L*Fs/2; %Frequency vector (Real part only)
Iout_lo=find(Freq<min(PassBand));%Indeces to the outside of the passband
Iout_hi=find(Freq>max(PassBand));

Amp=ones(size(Freq)); %Amplitude spectrum
Amp(Iout_lo)=linspace(0,1,length(Iout_lo));
Amp(Iout_hi)=linspace(1,0,length(Iout_hi));

%Amp(Iout)=0; %Set the gain 0 for the outside of the passband
Phase=(rand(size(Amp))*2-1)*pi; %Phase spectrum -- random
x=Amp.*exp(sqrt(-1)*Phase); %Complex representation of the signal
Noise=RealIFFT(x); %Get the time representation
Noise=Cos2RampMs(Noise,1,Fs); %Apply 1ms ramps
%OrigSPL=20*log10(sqrt(mean(Noise.^2))); %SPL of the original noise 
Noise=[Noise zeros(size(Noise))]; %Double the # of points by padding with zeros
OrigSPL=20*log10(sqrt(mean(Noise.^2))); %SPL of the original noise 
FiltNoise=filter(FiltCoef,1,Noise); %FIR filtering
%Scale the signal so that the maximum unsigned amplitude is no greater than 10 V %%%SK
%RMS=sqrt(mean(FiltNoise(1:2*L).^2)); 
%RMS=sqrt(mean(FiltNoise.^2)); 
%Scale=10/max(abs(FiltNoise(:))); %%%SK
Scale=0.35/max(abs(FiltNoise(:)));
GainByScale=20*log10(Scale); %Gain in dB
FiltNoise=FiltNoise*Scale; %Scale the signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Play and record the signal. Level was adapted to optimize the SN
[RP2Config.DevNo,RP2Config.DAChan,RP2Config.ADChan]=deal(1,ChanNo,ChanNo); %DevNo and ChanNo of RP2
%[PA5Config.DevNo,PA5Config.InitAtten]=deal(ChanNo,50); %DecNo and initial ATTEN of PA5
[PA5Config.DevNo,PA5Config.InitAtten,PA5Config.AdjustGainFlag]=deal(ChanNo,InitialAtten,AdjustAttenFlag);

%keyboard
%Play and record
[DataOut,Atten,SysEnv]=PlayAndRecordAttenSK(FiltNoise,length(FiltNoise),RP2Config,PA5Config,MaxSPL,MicSensitivity);%%%SK

%SPL of the recorded signal
MicSensitivityV=MicSensitivity(1);
MicSensitivitySPL=MicSensitivity(2);
%RecSPL=20*log10(sqrt(mean(DataOut.^2))*1e6); %(20log10(1uV) => 0 
RecSPL=20*log10(sqrt(mean(DataOut.^2))/MicSensitivityV)+MicSensitivitySPL;

GainByFilt=RecSPL-OrigSPL-GainByScale+Atten;
%keyboard
%Delay of the signal due to FIR filtering
y=xcorr(DataOut,Noise); %Cross correlation between input and output
%y=xcorr(Noise,DataOut);
x=-(length(Noise)-1):(length(Noise)-1); %delta t
[dum,Imax]=max(y); %Find the peak in the XC
DelayPtsByFilt=x(Imax); %Delay by filtering

%Check if the delay estimate is in a legal range.
%If not, it indicates something is going wrong ---
%Show an error message and set the delay at 0 as a dummy number
if min([1:(2*L)]+DelayPtsByFilt)<1 | max([1:(2*L)]+DelayPtsByFilt)>length(DataOut)
    warning('Something is not correct')
    DelayPtsByFilt=0;
end

%Compute the spectrum
myDataOut=DataOut([1:(2*L)]+DelayPtsByFilt); %Extract the part that contain the signal
%myDataOut=myDataOut/MicSensitivityV*10.^(MicSensitivitySPL/20);
AmpSpec=abs(fft(myDataOut)); %Amplitude spectrum
%AmpSpec=AmpSpec(1:L)/L; %%%%%%
AmpSpec_dB=20*log10(AmpSpec); %Spectrum in dB, for the positive frequency part

%Get STD within the passband
Iin=find(abs(Freq)>=min(PassBand) & abs(Freq)<=max(PassBand));
STD=std(AmpSpec_dB(Iin));

%Plot the result
if PlotFlag
    subplot(3,1,3)
    plot(Freq/1000,AmpSpec_dB);
    xlim([0 Fs/2/1000]);
    title(sprintf('STD: %.1f dB; Filter Gain: %.1f dB',STD,GainByFilt));
    xlabel('Frequency (kHz)')
    ylabel('dB')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Format the data to save

Rtn.Fs=Fs; %Device sampling frequency (Hz)
Rtn.PassBand=PassBand; %Passband specified (Hz)
Rtn.FiltCoef=FiltCoef; %FIR filter coefficient
Rtn.FiltGain=GainByFilt; %Gain by FIR filtering
Rtn.FiltDelayPts=DelayPtsByFilt; %Delay by filtering in #Pts
Rtn.SysResp.H=HSh; %Measured frequency response of the system (complex)
Rtn.SysResp.Freq=FreqSh; %frequency axis for H (Hz)
Rtn.FlatNoise.AmpSpec=AmpSpec; %Amplitude spectrum of the flattened noise (linear)
Rtn.FlatNoise.Freq=Freq;  %frequency axis for AmpSpec (Hz)






