function varargout=RP2PlayEz(varargin)
%RP2PlayEz -- Interface for the TDT system3 chain 'RP2PlayEz.rco'
%

global RP2 IdxFsRP2 %ActiveX Control handle for the circuit

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Static constants set in the ROC file
% Maximum # of signal data points allowed for each of L and R channels
MaxNPts=3000000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%If no input is specified, list the options with some explanations
if ~nargin
    disp('###### RP2Play ######')
    disp('Handle Name:  RP2 (global)');
    disp(sprintf('# of maximum data points: %d ',MaxNPts));
    disp(' ')
    disp('--- Command List ---')
    disp('''Initialize'' | Define ActX object, and load the circuit');
    disp('''SetSignal'', DataIn | Set wave data for signal. (2-by-NPts mat; Row1 - left chan, Row2 - right chan) ');
    disp('''GetFs'' | Get sampling frequency of the chain (Hz).');
    disp('''ResetIndex'' | Reset the indeces for the buffers. Use this before zBus triggering.');
    disp('''Run'' | Run the circuit to wait for the zBUS trigger.');
    disp('''Halt'' | Halt the circuit.');
    disp('''FlashSignal'' | Flash the data for signal.');
    disp('''GetStatus'' | Return the status of the RP2, by a string.');
    
    return
else
    Action=varargin{1};
end

switch lower(Action)
case 'initialize' %Initialize RP2 and return the ActX handle
    RP2=actxcontrol('RPco.x',[5 5 26 26]);
%    e=double(invoke(RP2,'ConnectRP2','USB',1)); %connects an RP2 to a USB or Xbus
    e=double(invoke(RP2,'ConnectRP2',TDTInterface,1)); %connects an RP2 to a USB or Xbus
    e=e * double(invoke(RP2,'ClearCOF'));
    e=e * double(invoke(RP2,'LoadCOFsf','RP2PlayEz.rco',IdxFsRP2));    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end

case 'setsignal' %Set signal waveforms for the L and R channels
    
    %Chech the number of inputs
    if length(varargin)~=2
        error('Inputs must be Action, and signal');
    end

    %Assign the inputs
    DataIn=varargin{2};

    if size(DataIn,1)~=2 | size(DataIn,2)>MaxNPts
        error(sprintf('Signal data should be in 2-by-(<%d) matrix.',MaxNPts));
    end
 
    %Set the signal
    e=double(invoke(RP2, 'WriteTagV', 'DataIn1', 0, DataIn(1,:)));
    e=e * double(invoke(RP2, 'WriteTagV', 'DataIn2', 0, DataIn(2,:)));
    if ~e & nargout
        varargout{1}=e;
        return;
    end

    Fs=double(invoke(RP2,'GetSFreq')); %Sampling frequency
    
    StimDur=size(DataIn,2)/Fs*1000; %Stimulus duration
    e=e * double(invoke(RP2, 'SetTagVal', 'StimDur', StimDur)); %Set Schmitt trigger
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end

    
case 'getfs' %Get sampling frequency
    
    varargout{1}=double(invoke(RP2,'GetSFreq'));
    
case 'resetindex' %Reset the index for the buffer

    %Reset the indeces for the buffer
    e=double(invoke(RP2,'SoftTrg',1));
        
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end

case 'run' %Run the chain

    %Run the chain
    e=double(invoke(RP2,'Run'));
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end

    
case 'halt' %Halt the chain
    e=double(invoke(RP2,'halt'));

    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
case 'flashsignal' %Flash the signal data by setting all the tag values zeroes
    e= double(invoke(RP2,'ZeroTag','DataIn1'));
    e=e * double(invoke(RP2,'ZeroTag','DataIn2'));

    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
case 'getstatus' %Return the RP2 status by a string
    
    Status=double(invoke(RP2,'GetStatus'));
    myargout=cell(1,1);
    if Status
        if Status==1
            myargout{1}='Connected';
        elseif Status==3
            myargout{1}='Connected and loaded';
        elseif Status==5
            myargout{1}='Connected and running';
        elseif Status==7
            myargout{1}='Connected, loaded, and running';
        else
            myargout{1}=sprintf('Unknown status: %d',Status);
        end
    else
        myargout{1}='Error';
    end
    
    for i=1:nargout
        varargout(i)=myargout(i);
    end
    

otherwise
    error(['Unrecognized action ''' Action '''']);
end



%invoke(zBUS,'zBusTrigA',1,0,5);
