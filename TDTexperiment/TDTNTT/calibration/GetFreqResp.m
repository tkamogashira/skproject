function Rtn=GetFreqResp(ChanNo,PassBand,FileName,InitialAtten,AdjustAttenFlag,MicSensitivity,PlotFlag)
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
MaxSPL=104; %Maximum SPL allowed to play from the earphone


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
OrigRMS=sqrt(mean(DataIn.^2));
if ~isempty(FileName)
    if ChanNo==1
        FiltData=load (FileName,'L');
        FiltData=FiltData.L;
    else
        FiltData=load (FileName,'R');
        FiltData=FiltData.R;
    end
    DataIn=[zeros(1,FiltData.FiltDelayPts) DataIn];
    DataIn=filter(FiltData.FiltCoef,1,DataIn);
    DataIn(1:FiltData.FiltDelayPts)=[];
    
    ScaleByFilt=10.^(FiltData.FiltGain/20);
else
    FiltData=[];
    ScaleByFilt=1;
end
%Scale the signal so that the RMS is less 3 V, which is the maximum safe input to Etymotic ER4
%and that the maximum unsigned amplitude is no greater than 10 V
RMS=sqrt(mean([A B].^2)); 
Scale=min([10/abs(max(DataIn(:))) 3/RMS]);
DataIn=DataIn*Scale;
InputSPL=20*log10(OrigRMS)+20*log10(Scale)+20*log10(ScaleByFilt);

%%%%%%%%%%%%%% Play and record the signal. Level was adapted to optimize the SN %%%%%
[RP2Config.DevNo,RP2Config.DAChan,RP2Config.ADChan]=deal(1,ChanNo,ChanNo); %Set device # and channel numbers of RP2
%[PA5Config.DevNo,PA5Config.InitAtten,PA5Config.AdjustGainFlag]=deal(ChanNo,50,1); %Set device # and initial attenuation of PA5
[PA5Config.DevNo,PA5Config.InitAtten,PA5Config.AdjustGainFlag]=deal(ChanNo,InitialAtten,AdjustAttenFlag); %Set device # and initial attenuation of PA5
[DataOut,Atten,SysEnv]=PlayAndRecordAtten(DataIn,length(DataIn),RP2Config,PA5Config,MaxSPL,MicSensitivity); %Play and record

Fs=SysEnv.Fs; %Actual sampling rate
if ~isempty(FiltData)
    if abs(Fs-FiltData.Fs)>10
        warning(sprintf('Unmatched filter sampling rate %f',FiltData.Fs));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPL of the input and output
InputSPL=InputSPL-Atten;
RMS=sqrt(mean(DataOut.^2));
OutputSPL=20*log10(RMS/MicSensitivity(1))+MicSensitivity(2);

%%%%%%%%%%%%%%%%%%% Compute the speaker response %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FreqSh=(-L:(L-1))/L*Fs/2; %Frequency vector for FFTSHIFTed spectrum
n=L*2; %Number of points for each of A and B code
Aout=DataOut(1:n); %Extract parts that includes responses to A and B
Bout=DataOut((1:n)+n); 
%Scale the response for comparable unit to Ain and Aout
myAout=Aout/MicSensitivity(1)*10.^(MicSensitivity(2)/20)/Scale/ScaleByFilt/10.^(-Atten/20);
myBout=Bout/MicSensitivity(1)*10.^(MicSensitivity(2)/20)/Scale/ScaleByFilt/10.^(-Atten/20);
%
%H=(fft(Aout).*conj(fft(Ain))+fft(Bout).*conj(fft(Bin)))/2/L; %Frequency Response
H=(fft(myAout).*conj(fft(Ain))+fft(myBout).*conj(fft(Bin)))/2/L; %Frequency Response
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
end

%Get STD within the passband
Iin=find(abs(FreqSh)>=min(PassBand) & abs(FreqSh)<=max(PassBand));
STD=std(HSh(Iin));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Format the data

Rtn.Fs=Fs; %Device sampling frequency (Hz)
Rtn.SysResp.H=HSh; %Measured frequency response of the system (complex)
Rtn.SysResp.Freq=FreqSh; %frequency axis for H (Hz)
Rtn.SysResp.STD=STD; %STD within the passband (Hz)
Rtn.InputSPL=InputSPL;
Rtn.OutputSPL=OutputSPL;





