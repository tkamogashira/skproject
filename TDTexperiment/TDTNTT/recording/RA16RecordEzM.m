function varargout=RA16RecordEzM(varargin)
%RA16RecordEzM -- Interface for the TDT system3 chain 'RA16RecordEzM.rco'
%Multi-electrode version of RA16RecordEz_m
%

global RA16 IdxFsRA16 %ActiveX Control handle for the circuit

%If no input is specified, list the options with some explanations
if ~nargin
    disp('###### RA16RecordEzM ######')
    disp('Handle Name:  RA16 (global)');
    disp(sprintf('Filter Order: %d',FiltOrder));
    disp(sprintf('# of data points per spike: %d ',NPtsSpk));
    disp(' ')
    disp('--- Command List ---')
    disp('''Initialize'' | Define ActX object, and load the circuit');
    disp('''SetRecDur'', RecDur | Set recording duration (ms). ');   
    disp('''GetRecDur'', Get recording duration (ms). ');   
    disp('''GetFs'' | Get sampling frequency of the chain (Hz).');
    disp('''GetRawWave'', ChanNo | Get raw waveform. ');
    disp('''GetIndexRaw'', ChanNo | Get index for raw waveform.');
    disp('''Run'' | Run the circuit to wait for the zBUS trigger.');
    disp('''Halt'' | Halt the circuit.');
    disp('''ResetIndex'' | Reset the indeces for the buffers. Use this before zBus triggering.');
    disp('''FlashData'' | Flash the raw data.');
    disp('''GetStatus'' | Return the status of the RA16, by a string.');
    
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
%    e=e * double(invoke(RA16,'LoadCOF',fullfile(TDTRoot,'RA16RecordEz.rco')));
    e=e * double(invoke(RA16,'LoadCOFsf','RA16RecordEzM.rco',IdxFsRA16));
    
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
        varargout{1}=double(invoke(RA16, 'GetTagVal', 'RecDur'));
    end
    
case 'getfs' %Get sampling frequency
    
    varargout{1}=double(invoke(RA16,'GetSFreq'));
    
case 'getrawwave' %Get raw waveform
        
    %Assign the inputs
    ChanNo=varargin{2};

    %Check the number of inputs
    if length(varargin)~=2
        error('Inputs must be Action and ChanNo.');
    end
        
    myargout=cell(1,2);
    myargout{1}=cell(4,1);
    myargout{2}=ones(4,1);
    for ii=ChanNo
        %Number of spikes
        mytag=['IdxRaw' num2str(ii)];
        NPtsWave=double(invoke(RA16, 'GetTagVal', mytag));
        
        if NPtsWave
            mytag=['RawData' num2str(ii)];
            mywav=double(invoke(RA16,'ReadTagV',mytag,0,NPtsWave));
            if length(mywav)~=NPtsWave
                myargout{1}{ii}=[];
                myargout{2}(ii)=0;
            else
                myargout{1}{ii}=mywav;
            end
        end
        
        for i=1:nargout
            varargout(i)=myargout(i);
        end
    end
case 'getindexraw' %Get index for the raw waveform
        
    %Assign the inputs
    ChanNo=varargin{2};
    
    mymat=zeros(4,1);
    for ii=ChanNo
        mytag=['IdxRaw' num2str(ii)];
        mymat(ii)=double(invoke(RA16, 'GetTagVal', mytag));
    end
    %Number of spikes
    varargout{1}=mymat;   
    
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
    
case 'resetindex' %Reset index of the spike and wave buffer
    
    %Reset the indeces for the buffer
    e=double(invoke(RA16,'SoftTrg',1));
    
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
case 'flashdata' %Flash the spike and wave data by setting all the tag values zeroes
    %Reset the indeces for the buffer
    e=double(invoke(RA16,'SoftTrg',1));
    
    %Set all zeros
    for ii=1:4
        mytag=['RawData_' num2str(ii)];
        e= e * double(invoke(RA16,'ZeroTag',mytag));
    end

    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
    
case 'getstatus' %Return the RA16 status by a string
    
    Status=double(invoke(RA16,'GetStatus'));
    myargout=cell(1,1);
    if Status
        StatusBin=dec2bin(Status);
        n=length(StatusBin);
        if n<=6
            mystr=[];
            for i=n:-1:1
                if str2num(StatusBin(i))
                    switch i
                    case n
                        mystr=['Connected; ' mystr];
                    case n-1
                        mystr=['Loaded; ' mystr];
                    case n-2
                        mystr=['Running; ' mystr];
                    case n-3
                        mystr=['Battery; ' mystr];
                    case n-4
                        mystr=['Clipping; ' mystr];
                    case n-5
                        mystr=['Clipping Again; ' mystr];
                    end
                end
            end
        else
            mystr=sprintf('Unknown status: %d',Status);
        end
        myargout{1}=mystr;
%         
%         if Status==1
%             myargout{1}='Connected';
%         elseif Status==3
%             myargout{1}='Connected and loaded';
%         elseif Status==5
%             myargout{1}='Connected and running';
%         elseif Status==7
%             myargout{1}='Connected, loaded, and running';
%         else
%             myargout{1}=sprintf('Unknown status: %d',Status);
%         end
    else
        myargout{1}='Error';
    end
    
    for i=1:nargout
        varargout(i)=myargout(i);
    end
    
otherwise
    error(['Unrecognized action ''' Action '''']);
    
end

