function [DataOut,Atten,SysEnv]=PlayAndRecordAtten(DataIn,NPtsOut,RP2Config,PA5Config,MaxSPL,MicSensitivity);
%PlayAndRecordAtten -- Play and record signal; the sinal level is adjusted to optimize the SN.
% Use an RCO file PlayAndConfig.rco.
%
%<<Input>>
%DataIn : Vector of singal to play. (Volts)
%NPtsOut : Number of points of the output vector
%RP2Config : Structure for the configuration of RP2 with following field
%				DevNo : Device Number of RP2 -- Usually 1
%				DAChan : Channel number for DAC (1 or 2)
%				ADChan : Channel number for ADC (1 or 2, usually DAChan = ADChan)
%PA5Config : Structure for the configuration of PA5 with following field
%				DevNo : Device Number of PA5 -- (1 or 2, usually =RP2Config.DAChan)
%				InitAtten : Initial setting of attenuation (0~99.9 dB); negative number indicates
%					attenuation should be fix regardless of output SPL.
%MaxSPL : Limit of output SPL (dB)
%
%<<Output>>
%DataOut : Vector of recorded signal (Volts)
%Atten : Final attenuation by PA5 (dB)
%SysEnv : Structure indicating system environments with following fields
%			hRP2 : Handle for the RP2 object
%			hPA5 : Handle for the PA5 object
%			Fs : Sampling frequency set in the RP2 circuit
%
%Usage: [DataOut,Atten,SysEnv]=PlayAndRecordAtten(DataIn,RP2Config,PA5Config,MaxSPL);
%By SF, 7/24/01

global IdxFsRP2

%File name of RCO for PlayAndRecord.
RCOFileName='PlayAndRecord.rco';

%Initialize an output
SysEnv=[];

%Initialize AP5
PA5=actxcontrol('PA5.x',[5 5 26 26]);
%invoke(PA5,'ConnectPA5','USB',PA5Config.DevNo);
invoke(PA5,'ConnectPA5',TDTInterface,PA5Config.DevNo);
invoke(PA5,'SetAtten',99); %Set large attenuation to suppress noise by RP2 initialization process

%Initialize RP2
while 1
    RP2=actxcontrol('RPco.x',[5 5 26 26]);% starts the RP activeX control in MATLAB
    %invoke(RP2,'ConnectRP2','USB',RP2Config.DevNo); %connects an RP2 to a USB or Xbus
    invoke(RP2,'ConnectRP2',TDTInterface,RP2Config.DevNo); %connects an RP2 to a USB or Xbus
    e2=invoke(RP2,'ClearCOF'); %Clears the Buffers and COF files on that RP
    invoke(RP2,'LoadCOFsf',RCOFileName,IdxFsRP2-1); % Loads circuit('c:\example')
    invoke(RP2,'Run'); %Starts Circuit
    Status=(invoke(RP2,'GetStatus'));% returns a value (7=circuit loaded and running) 
    if invoke(RP2,'GetStatus')~=7
        error('Error when initializing RP2');
    end
    
    Fs=double(invoke(RP2,'GetSFreq')); %Sampling rate set in the RCO file
    
    switch IdxFsRP2-1
        case 0
            myflag=(abs(Fs-6103)>10);
        case 1
            myflag=(abs(Fs-12207)>10);
        case 2
            myflag=(abs(Fs-24414)>10);
        case 3
            myflag=(abs(Fs-48828)>10);
        case 4
            myflag=(abs(Fs-97656)>10);
        case 5
            myflag=(abs(Fs-195312)>10);
        otherwise
            myflag=1;
    end
    if myflag
        disp(sprintf('Bad Fs setting %f: Ctrl+C to quit / any other key to retry',Fs));
        keyboard
        pause
    else
        break;
    end
end
    
%Format an output for system environments
SysEnv.Fs=Fs;
SysEnv.hRP2=RP2;
SysEnv.hPA5=PA5;

%Start playing and recording
%Repeat the process until the signal SPL falls in a good range
% by adjusting the attenuater.
invoke(PA5,'SetAtten',abs(PA5Config.InitAtten)); %Initial Attenuation
%keyboard
NAv=3;
for i=1:3
    for ii=1:NAv
        %Play and record
        myDataOut=PlayAndRecord(RP2,DataIn,RP2Config.DAChan,RP2Config.ADChan,NPtsOut,Fs);
        if ii==1
            DataOut=myDataOut;
        else
            DataOut=DataOut+myDataOut;
        end            
    end
    DataOut=DataOut/NAv;
   %Remove DC offset
   DataOut=DataOut-mean(DataOut(:));

    figure(1)
    plot(DataOut)
    %plot([1:length(DataIn(:)); 1:length(DataOut(:))]',[DataIn(:)./mean(abs(DataIn(:))), DataOut(:)./mean(abs(DataOut(:)))])
    drawnow
    
    if PA5Config.AdjustGainFlag %Adjust gain
        %Current setting of the attenuator
        Atten=double(invoke(PA5,'GetAtten'));
        
        %If negative number has been set for PA5Config.InitAtten,
        % no need to adjust the attenuation.
        if PA5Config.InitAtten<0
            break;
        end
        
        %% If the input voltage is already high enough, exit the loop
        CurrentVolt=sqrt(mean(DataIn.^2))*10.^(-Atten/20);
        if CurrentVolt>5
            break;
        end
        
        %Get the SPL of the signal
        %RMS=sqrt(mean(DataOut.^2))*1e6; %Etymotic ER7C gives 20log10(1uV) for 0 dB SPL 
        %CurrentLevel=20*log10(RMS);
        MicSensitivityV=MicSensitivity(1);
        MicSensitivitySPL=MicSensitivity(2);
        RMS=sqrt(mean(DataOut.^2));
        CurrentLevel=20*log10(RMS/MicSensitivityV)+MicSensitivitySPL;
        
        %Adjust the attenuater so that the signal SPL falls in a good range
        Delta=CurrentLevel-MaxSPL;
        if Delta>0 %Current SPL too loud
            myAtten=min([99.9 Atten+Delta+5]); %Increase the atten
        elseif Delta<-10 %Current SPL 5-dB less than the limit
            myAtten=max([0 Atten+Delta+5]); %Decrease the atten
        elseif max(abs(DataOut))>=10 %Clipping detected
            myAtten=max([99.9 Atten+5]); %Increase the atten
        else %About right SPL
            myAtten=NaN;
        end
        
        if ~isnan(myAtten)
            invoke(PA5,'SetAtten',myAtten);
        else
            break;
        end
    else %Fixed gain
        Atten=PA5Config.InitAtten;
        break;
    end %if PA5Config.AdjustGainFlag
end


