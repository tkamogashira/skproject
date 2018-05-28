function varargout=RA16Record(varargin)
%RA16Record -- Interface for the TDT system3 chain 'RA16Record.rco'
%
%Bandpass-filtering of raw waveform with an IIR filter: 
%Filter order = 6
%Coefficients should have been saved in 'IIRCoef.f32' with float32 precision

global RA16 %ActiveX Control handle for the circuit

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Static constants set in the ROC file

% # of data points per spike (set in the FindSpike component)
NPtsSpk=37;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%If no input is specified, list the options with some explanations
if ~nargin
    disp('###### RA16Record ######')
    disp('Handle Name:  RA16 (global)');
    disp(sprintf('Filter Order: %d',FiltOrder));
    disp(sprintf('# of data points per spike: %d ',NPtsSpk));
    disp(' ')
    disp('--- Command List ---')
    disp('''Initialize'' | Define ActX object, and load the circuit');
    disp('''SetCutThresh'', CutThresh | Set cut-off threshold for spike detection. ');
    disp('''SetCriteria'', Idx, Criteria | Set criteria ([t, Hi, Lo]) for spike detection. ');
    disp('''ReverseSwitch'', ReverseFlag | Switch the sign of the filtered waveform ');
    disp('''SetRecDur'', RecDur | Set recording duration (ms). ');   
    disp('''GetRecDur'', Get recording duration (ms). ');   
    disp('''GetFs'' | Get sampling frequency of the chain (Hz).');
    disp('''GetSpike'' | Get spike times and waveforms. ');
    disp('''GetIndexSpike'' | Get index for spike.');
    disp('''GetRawWave'' | Get raw waveform. ');
    disp('''GetIndexRaw'' | Get index for raw waveform.');
    disp('''GetFiltWave'' | Get filt waveform. ');
    disp('''GetIndexFilt'' | Get index for Filtered waveform.');
    disp('''ResetBufIndex'' | Reset the indeces for the buffers. Use this before zBus triggering.');
    disp('''Run'' | Run the circuit to wait for the zBUS trigger.');
    disp('''Halt'' | Halt the circuit.');
    disp('''FlashData'' | Flash the spiek and raw data.');
    
    return
else
    Action=varargin{1};
end

switch lower(Action)
case 'initialize' %Initialize RP2 and return the ActX handle
    RA16=actxcontrol('RPco.x',[5 5 26 26]);
%    e=double(invoke(RA16,'ConnectRA16','USB',1)); %connects an RA16 to a USB or Xbus
    e=double(invoke(RA16,'ConnectRA16',TDTInterface,1)); %connects an RA16 to a USB or Xbus
    e=e * double(invoke(RA16,'ClearCOF'));
    e=e * double(invoke(RA16,'LoadCOF',fullfile(TDTRoot,'RA16Record.rco')));
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
   
case 'setcutthresh' %Set cut off thresholds for spike detection
    
    %Check the number of inputs
    if length(varargin)~=2
        error('Inputs must be Action and Cut threshold.');
    end
    
    %Assign the inputs
    CutThresh=varargin{2};
    
    e=1;
    if length(CutThresh)==1
        if CutThresh(1)>CutThresh(2) %If the ThrLo>ThrHi
            error('Invalid order of lower and higher thresholds');
        end
        
        e=e * double(invoke(RA16, 'SetTagVal', 'CutThreshold',CutThreshold));
    else
        error('Threshold vector should have a length of 1.');
    end
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
    
case 'setcriteria' %Set criteria for spike detection
    
    %Check the number of inputs
    if length(varargin)~=3
        error('Inputs must be Action, criterion index, Criteria [T Hi Lo].');
    end
    
    %Assign the inputs
    Idx=varargin{2};
    Criteria=varargin{3};
    T=Criteria(1);
    Hi=Criteria(2);
    Lo=Criteria(3);    

    %Determine tag names
    TagT=['T' num2str(Idx)];
    TagHi=['Hi' num2str(Idx)];
    TagLo=['Lo' num2str(Idx)];
    
    e=1;
    %Time
    e=e * double(invoke(RA16, 'SetTagVal', TagT,T));
    %Higher cut amplitude
    e=e * double(invoke(RA16, 'SetTagVal', HiT,Hi));
    %Lower cut amplitude
    e=e * double(invoke(RA16, 'SetTagVal', LoT,Lo));
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
       
    
case 'ReverseSwitch' %Reverse the filtered waveform
    
    %Check the number of inputs
    if length(varargin)~=2
        error('Inputs must be Action and ReverseFlag.');
    end
    
    %Assign the inputs
    ReverseFlag=varargin{2};
    ReverseFlag=sign(ReverseFlag); %The flag has to be either -1 or 1.
    
    %Set sign
    e=double(invoke(RA16, 'SetTagVal', 'ReverseFlag', ReverseFlag));
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
case 'setrecdur' %Set recording duration
    
    %Check the number of inputs
    if length(varargin)~=2
        error('Inputs must be Action and RecDur (ms).');
    end
    
    %Assign the inputs
    RecDur=varargin{2};
    
    %Set recording duration
    e=double(invoke(RA16, 'SetTagVal', 'RecDur', RecDur));
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
case 'getrecdur' %Get recording duration
    
    %Get recording duration
    if nargout
        varargout=double(invoke(RA16, 'GetTagVal', 'RecDur'));
    end
    
case 'getfs' %Get sampling frequency
    
    varargout{1}=double(invoke(RA16,'GetSFreq'));
    
    
case 'getspike' %Get spike waveform
    
    %Number of spikes
    NSpike=double(invoke(RA16, 'GetTagVal', 'SpikeNumber'));
    
    myargout=cell(1,3);
    if NSpike
        %Ge spike waveform matrix
        SpikeMat=double(invoke(RA16,'ReadTagV','SpikeData',0,NSpike*NPtsSpk));
        if length(SpikeMat(:))==NSpike*NPtsSpk
            SpikeMat=reshape(SpikeMat,[NPtsSpk,NSpike]);
            myargout{1}=SpikeMat(2:end,:);
            myargout{2}=SpikeMat(1,:);
        else
            myargout{1}=[];
            myargout{2}=[];
            myargout{3}=0;
        end    
    else
        myargout{1}=[];
        myargout{2}=[];
        myargout{3}=1;
    end
    
    %Return values
    %First argument for spike waveform
    %Second for spike time
    %The last for the error flag
    for i=1:nargout
        varargout(i)=myargout(i);
    end
    
case 'getindexspike' %Get index for the spike waveforms
    
    %Number of spikes
    varargout{1}=double(invoke(RA16, 'GetTagVal', 'IdxSpike'));   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Worked on 2.15 upto this point
%
case 'getrawwave' %Get raw waveform
    
    %Number of spikes
    NPtsWave=double(invoke(RA16, 'GetTagVal', 'IdxRaw'));
    
    myargout=cell(1,2);
    myargout{2}=1;
    if NPtsWave
        myargout{1}=double(invoke(RA16,'ReadTagV','RawData',0,NPtsWave));
        if length(myargout{1})~=NPtsWave
            myargout{2}=0;
        end
    end
    
    for i=1:nargout
        varargout(i)=myargout(i);
    end
    
    
case 'getindexraw' %Get index for the raw waveform
    
    %Number of spikes
    varargout{1}=double(invoke(RA16, 'GetTagVal', 'IdxRaw'));   
    
case 'getfiltwave' %Get filtered waveform
    
    %Number of spikes
    NPtsWave=double(invoke(RA16, 'GetTagVal', 'IdxFilt'));
    
    myargout=cell(1,2);
    myargout{2}=1;
    if NPtsWave
        myargout{1}=double(invoke(RA16,'ReadTagV','FiltData',0,NPtsWave));
        if length(myargout{1})~=NPtsWave
            myargout{2}=0;
        end
    end
    
    for i=1:nargout
        varargout(i)=myargout(i);
    end
    
    
case 'getindexfilt' %Get index for the filtered waveform
    
    %Number of spikes
    varargout{1}=double(invoke(RA16, 'GetTagVal', 'IdxFilt'));   
    
case 'run' %Run the chain
    
    %Run the chain
    e=double(invoke(RA16,'Run'));
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
case 'halt' %Halt the chain
    e=double(invoke(RA16,'halt'));
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
case 'resetbufindex' %Reset index of the spike and wave buffer
    
    %Reset the indeces for the buffer
    e=double(invoke(RA16,'SoftTrg',1));
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
case 'flashdata' %Flash the spike and wave data by setting all the tag values zeroes
    e= double(invoke(RA16,'ZeroTag','SpikeData'));
    e= e * double(invoke(RA16,'ZeroTag','WaveData'));
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
otherwise
    error(['Unrecognized action ''' Action '''']);
    
end


if 0
    
    
    %RecordSpikes
    
    RecDur=1000;
    FiltOrder=128;
    CutFreq=[500 5000];
    
    RA16=actxcontrol('RPco.x',[5 5 26 26]);
%    invoke(RA16,'ConnectRA16','USB',1); %connects an RA16 to a USB or Xbus
    invoke(RA16,'ConnectRA16',TDTInterface,1); %connects an RA16 to a USB or Xbus
    %e=invoke(RA16,'ClearCOF')
    e=invoke(RA16,'LoadCOF',fullfile(TDTRoot,'RA16Record.rco'))
    
    Fs=double(invoke(RA16,'GetSFreq'))
    load RecordSpikes
    %Set filter coefficients
    clear B
    if exist('RecordSpikes.mat','file')==2
        load RecordSpikes
        if exist('B','var')~=1
            B = fir1(FiltOrder,CutFreq/(Fs/2));
        end
    else
        B = fir1(FiltOrder,CutFreq/(Fs/2));
    end
    e=invoke(RA16, 'WriteTagV', 'FiltCoef', 0, B);
    
    %Set the TSlope to account for the delay by FIR filtering
    DelayByFilt=FiltOrder/2/Fs;
    e=invoke(RA16, 'SetTagVal', 'DelayByFilt', -DelayByFilt);
    
    %Set cut thresholds for spike detecter
    e=invoke(RA16, 'SetTagVal', 'ThrLo',2);
    e=invoke(RA16, 'SetTagVal', 'ThrHi', 1000);
    
    %Set recording duration
    e=invoke(RA16, 'SetTagVal', 'RecDur', RecDur);
    
    e=invoke(RA16,'Run');
    %Status=double(invoke(RA16,'GetStatus'));
    %e=invoke(RA16, 'SetTagVal', 'ConnectStat',bitget(Status,1));
    %e=invoke(RA16, 'SetTagVal', 'LoadStat',bitget(Status,2));
    %e=invoke(RA16, 'SetTagVal', 'RunStat',bitget(Status,3));
    
    
    %Reset the buffers
    e= Invoke(RA16,'SoftTrg',1);
    
    %keyboard
    
    zBUS=actXcontrol('ZBUS.x',[1 1 1 1]); 
%    invoke(zBUS, 'connectZBUS','USB');
    invoke(zBUS, 'connectZBUS',TDTInterface);
    
    invoke(zBUS,'zBusTrigA',1,0,5)
    
    %%% Wait while the circuit is running
    %pause(RecDur/1000)
    IdxWave=double(invoke(RA16,'GetTagVal','IdxWave'));
    SpikeNumber=double(invoke(RA16,'GetTagVal','SpikeNumber'));
    while(1)
        %double(invoke(RA16,'GetTagVal','CycUsage'))
        %drawnow
        myIdxWave=double(invoke(RA16,'GetTagVal','IdxWave'));
        mySpikeNumber=double(invoke(RA16,'GetTagVal','SpikeNumber'));
        if myIdxWave==IdxWave & mySpikeNumber ==SpikeNumber
            break;
        else
            IdxWave=myIdxWave;
            SpikeNumber=mySpikeNumber;
        end
    end
    
    %%%%%%%%%%%%
    NPtsWav=double(invoke(RA16,'GetTagVal','IdxWave'))+1;
    Wave=invoke(RA16,'ReadTagV','WaveData',0,NPtsWav);
    
    NSpk=double(invoke(RA16,'GetTagVal','SpikeNumber'));
    Spikes=invoke(RA16,'ReadTagV','SpikeData',0,NSpk*50);
    
    
end