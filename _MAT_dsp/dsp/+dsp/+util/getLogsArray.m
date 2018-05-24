function Array = getLogsArray(LogObject, Format2D, varargin)
%dsp.util.getLogsArray Return logged signal as MATLAB array
%   dsp.util.getLogsArray(LogObject, Format2D, 'SignalPath', PATH)
%	Returns a MATLAB array that contains the signal in 'LogObject' which
%   corresponds to the PATH you specify. If PATH is a dsp.util.SignalPath
%   object, 'LogObject' can be either a Simulink.SimulationData.Dataset or
%   Simulink.SimulationData.Signal object. If PATH is the full path to a
%   block in a Simulink model obtained by using the gcb command,
%   'LogObject' must be a Simulink.SimulationData.Dataset object.
%    
%   'Format2D' is a logical value that specifies whether the function
%   formats 3-dimensional logged signals as a 2-dimensional MATLAB array.
%   When set to true, the function uses the following formula to reformat
%   the 3-dimensional logged signal into a 2-D MATLAB array:
%
%  	     dim = size(signal);
%   	 ntimes = dim(1)*dim(3);
%   	 Array = reshape(permute(signal,[1 3 2]),[ntimes dim(2)]);
%
%   When you set 'Format2D' to false, the function returns the logged
%   signal without any reformatting.
%
%   Array = dsp.util.getLogsArray(LogObject, Format2D, 'SignalName', NAME)
%   Returns a MATLAB array that contains the signal in 'LogObject' which
%   corresponds to the NAME you specify. 'LogObject' can be an object of
%   class timeseries, Simulink.SimulationData.Dataset, or
%   Simulink.SimulationData.Signal.
%
%   % EXAMPLES:
%
%   % To run the following examples, you must load the <a href="matlab:load(fullfile(matlabroot, 'help','toolbox','dsp','examples','ex_logsout'))">ex_logsout.mat</a>
%   % file which contains a Simulink.SimulationData.Dataset object.
%   % Alternatively, you can open and simulate the <a href="matlab:open_system('ex_log_utils')">ex_log_utils</a> Simulink model. 
%   % Doing so will log signals and generate the necessary ex_logsout object.
%
%   % Example 1: Extract a unique signal named 'Signal3x4' from ex_logsout 
%   % as a 2-D array.
%      dsp.util.getLogsArray(ex_logsout, true, 'SignalName','Signal3x4')
%
%   % Example 2: Extract a unique signal named 'Signal3x4' from ex_logsout 
%   % as a 3-D array.
%      dsp.util.getLogsArray(ex_logsout, false, 'SignalName','Signal3x4')
%
%   % Example 3: Find and extract a specific signal from multiple signals 
%   % that have the same name.
%     % Because ex_logsout contains multiple signals named 'Signal2x4', you
%     % must use the dsp.util.getSignalPath function to find the paths to
%     % each of those signals.
%     paths = dsp.util.getSignalPath(ex_logsout, 'Signal2x4')
%     % paths is a 2x1 array of dsp.util.SignalPath objects. Next, examine 
%     % the BlockPath property of each paths object.
%     paths.BlockPath
%     % Find the signal path that corresponds to the logged signal you are
%     % interested in. For example paths(2). You can then use the
%     % dsp.util.getLogsArray function and provide the 'SignalPath' name-value
%     % pair argument.
%     dsp.util.getLogsArray(ex_logsout, true, 'SignalPath', paths(2))
%
%   % Example 4: Find and extract a signal from a bus.
%     % Use the dsp.util.getSignalPath function to get paths to all the signals
%     % in the bus named 'Bus1'.
%     buspaths = dsp.util.getSignalPath(ex_logsout, 'Bus1')
%     % buspaths is a 2x1 array of dsp.util.SignalPath objects. Examine the
%     % BusElement property of each buspaths object.
%     buspaths.BusElement
%     % Select a signal path. For example buspaths(1). This is the path to the
%     % signal named 'Signal3x4' in bus 'Bus' that is contained in bus 'Bus1'.
%     % Now that you have the path to the signal, call dsp.util.getLogsArray
%     % using the 'SignalPath' name-value pair argument.
%     dsp.util.getLogsArray(ex_logsout, true, 'SignalPath', buspaths(1))
%
%   See also dsp.util.getSignalPath, dsp.util.SignalPath, gcb,
%   Simulink.SimulationData.Dataset, Simulink.SimulationData.Signal,
%   Timeseries, Simulink.SimulationData.updateDatasetFormatLogging
    
% Copyright 2011 The MathWorks, Inc.

try
    % Parameter checking
    localCheckRequiredInputs(LogObject, Format2D);
    localCheckPVPairs(varargin);
    
    % Handle inputs
    if strcmp(varargin{1}, 'SignalName')
        % PV-Pair is 'SignalName'
        if isa(LogObject, 'Simulink.SimulationData.Dataset')
            Array = localHandleDataset(LogObject, varargin{2}, Format2D);
        elseif isa(LogObject,'Simulink.SimulationData.Signal')
            Array = localHandleSignal(LogObject, varargin{2}, Format2D, []);
        else % 'timeseries'
            Array = localHandleTimeseries(LogObject, varargin{2}, Format2D);            
        end
    else % PV-Pair is 'SignalPath'
        if isa(LogObject, 'timeseries')           
            error(message('dsp:logging:timeseriesRequiresSignalName'));
        else
            if isa(varargin{2}, 'dsp.util.SignalPath')           
                Array = localHandleSignalPath(LogObject, varargin{2}, Format2D);
            else % Expect full path to block in model (gcb)
                 Array = localHandleGcb(LogObject, varargin{2}, Format2D);
            end
        end
    end
    
    
catch me
    me.throwAsCaller;
end

end % getLogsArray

%% Handle Inputs

function Array = localHandleDataset(LogObject, SignalName, Format2D)

    found = LogObject.find(SignalName);

    if isempty(found)
        
        error(message('dsp:logging:noSuchSignal', SignalName));
        
    elseif isa(found, 'Simulink.SimulationData.Signal')

        Array = localHandleSignal(found, SignalName, Format2D, []);

    elseif isa(found, 'Simulink.SimulationData.Dataset')
    
        error(message('dsp:logging:duplicateSignalName'));
        
    else
        error(message('dsp:logging:logObjectNotDatasetOrSignal'));        
    end

end % localHandleDataset

function Array = localHandleSignalPath(LogObject, SignalPath, Format2D)

    BlockPath = SignalPath.BlockPath;
    if ~isa(BlockPath, 'Simulink.SimulationData.BlockPath')
        error(message('dsp:logging:notBlockPath'));
    end
    
    if isa(LogObject, 'Simulink.SimulationData.Dataset')
    
        Obj = LogObject.find(BlockPath, '-blockpath');

        if isa(Obj, 'Simulink.SimulationData.Dataset')
            % True if two or more outputs from same block are logged with the same name.
            % Use PortIndex to find which one to use.
            NumSigs = Obj.getLength;
            for i=1:NumSigs
                Signal = Obj.get(i);
                if ~isa(Signal, 'Simulink.SimulationData.Signal')
                    error(message('dsp:logging:logObjectReadError', ...
                        class(Signal), class(Obj), 'Simulink.SimulationData.Signal'));
                end
                if Signal.PortIndex == SignalPath.PortIndex
                    Array = localHandleSignal(Signal, SignalPath.SignalName, Format2D, SignalPath);
                    return;
                end
            end
            error(message('dsp:logging:signalNotOnPort', SignalPath.PortIndex));             

        elseif isa(Obj, 'Simulink.SimulationData.Signal')
            Array = localHandleSignal(Obj, SignalPath.SignalName, Format2D, SignalPath);        
        else
            error(message('dsp:logging:logObjectReadError2', class(Obj), ...
                'timeseries', 'Simulink.SimulationData.Dataset', ...
                'Simulink.SimulationData.Signal'));
        end
    else % isa Simulink.SimulationData.Signal
        Array = localHandleSignal(LogObject, SignalPath.SignalName, Format2D, SignalPath);
    end
                
end % localHandleSignalPath

function Array = localHandleGcb(LogObject, gcb, Format2D)
    if isa(LogObject, 'Simulink.SimulationData.Dataset')
        Signal = LogObject.find(gcb, '-blockpath');
        if ~isa(Signal, 'Simulink.SimulationData.Signal')
            error(message('dsp:logging:signalPathWrongType'));       
        end
    
        Array = localHandleSignal(Signal, Signal.Name, Format2D, []);
    else % isa Simulink.SimulationData.Signal
        error(message('dsp:logging:logObjectNotDatasetWhenGcb'));       
    end
    
end % localHandleGcb

function Array = localHandleSignal(SignalObj, SignalName, Format2D, SignalPath)

    if ~strcmp(SignalObj.Name, SignalName)
        error(message('dsp:logging:signalNameMismatch'));
    end

    if isa(SignalObj.Values, 'timeseries')
        
        Array = localHandleTimeseries(SignalObj.Values, SignalName, Format2D);        
        
    elseif isa(SignalObj.Values, 'struct')        
        % Path is to a bus. Must use BusElement field of SignalPath to find
        % the actual signal requested.
        
        if ~isempty(SignalPath)
        
            Array = localDecendIntoBus(SignalObj.Values, SignalPath, ...
                SignalPath.SignalName, Format2D, 1);
        
        else
            % It's a bus but need a SignalPath with BusElement field to
            % resolve the signal.
            error(message('dsp:logging:nameIsBus'));
        end
    else
        error(message('dsp:logging:logObjectReadError1', ...
            class(SignalObj.Values), class(SignalObj), 'timeseries', 'struct'));        
    end

end % localHandleSignal

function Array = localHandleTimeseries(timeseriesObj, SignalName, Format2D)

    if ~isa(timeseriesObj, 'timeseries')
        error(message('dsp:logging:logObjectReadError3', ...
            class(timeseriesObj), 'timeseries'));        
    elseif ~strcmp(SignalName, timeseriesObj.Name)
        % SignalName can be either the value of parameter 'SignalName' or
        % the Name field of the dsp.util.SignalPath object.
        error(message('dsp:logging:signalNameNotTimeseriesName'));
    end
    
    Array = localExtractArray(timeseriesObj.Data, Format2D);
    
end % localHandleTimeseries

%% Handle Signals in a Bus
function Array = localDecendIntoBus(obj, SignalPath, SignalName, Format2D, index)

    if isa(obj, 'timeseries')
        
        Array = localHandleTimeseries(obj, SignalName, Format2D);
        
    elseif isa(obj, 'struct')
                
        Name = localGetBusName(SignalPath.BusElement, index);
        
        Fields = fields(obj);
        
        if isempty(find(cell2mat(strfind(Fields, Name)), 1))
            error(message('dsp:logging:signalNotInBus', SignalName, Name));                     
        end
                              
        %Recursively decend
        Array = eval(sprintf(...
            'localDecendIntoBus(obj.%s, SignalPath, Name, Format2D, %d)', ...
            Name, index+1));
                                
    else
        error(message('dsp:logging:logObjectReadError1', class(obj), ...
            'Simulink.SimulationData.Signal', 'timeseries', 'struct'));        
    end                    

end % localDecendIntoBus

%% Extract a MATLAB array from a timeseries Data field

function Array = localExtractArray(Data, Format2D)

    Dim = size(Data);
    
    NumDims = length(Dim);
    
    if Format2D
        if NumDims == 2
            % Already 2-D
            Array = Data;            
        elseif NumDims == 3
            Ntimes = Dim(end)*Dim(1);
            Array = reshape(permute(Data,[1 3 2]),[Ntimes Dim(2)]);
        else % N-D, N > 3
            error(message('dsp:logging:cannotFormat2D'));
        end 
    else % Not Format2D       
        Array = Data;        
    end        

end % localExtractArray

%% Parse the BusElement

function name = localGetBusName(BusElement, index)
    % Parse a BusElement string with format 'name' or 'name1.name2...'

    % Any errors in this function indicate a mismatch between the
    % SignalPath object and the LogObject. One possibility is that the
    % SignalPath was created from a different LogObject.
    if isempty(BusElement)
        error(message('dsp:logging:busSignalNotInLogObject'));
    end
    
    Dots = strfind(BusElement, '.');
    
    if isempty(Dots)
        % Single name in BusElement
        if index == 1
            name = BusElement;
        else           
            error(message('dsp:logging:busSignalNotInLogObject'));            
        end
    else
        if index > length(Dots)+1
            % This will also prevent infinite recursion
            error(message('dsp:logging:busSignalNotInLogObject'));            
        end
        
        if index ==1
            name = BusElement(1:Dots(1)-1);
        elseif index == length(Dots)+1
            name = BusElement(Dots(end)+1:end);
        else
            name = BusElement(Dots(index-1)+1:Dots(index)-1);
        end
    end
end

%% Parameter Validation Functions

function localCheckRequiredInputs(LogObject, Format2D)
    if ~isa(LogObject, 'Simulink.SimulationData.Dataset') && ...
            ~isa(LogObject, 'Simulink.SimulationData.Signal') && ...
            ~isa(LogObject, 'timeseries')
        error(message('dsp:logging:logObjectNotDatasetOrSignalOrTimeseries'));            
    end
    if length(LogObject) ~= 1        
        error(message('dsp:logging:logObjectNotDatasetOrSignalOrTimeseries')); 
    end
    if ~isa(Format2D, 'logical')
        error(message('dsp:logging:formatNotLogical'));            
    end
end % localCheckRequiredInputs

function localCheckPVPairs(PvPairs)

    if length(PvPairs) ~= 2
        error(message('dsp:logging:missingSignalNameOrPathArg'));            
    end
    
    localCheckParamName(PvPairs);

    p = inputParser;
    
    p.addParamValue('SignalName', [], ...
        @(x) localValidateSignalName(x));
    p.addParamValue('SignalPath', [], ...
        @(x) localValidateSignalPath(x));
    
    p.parse(PvPairs{:});

end % localCheckPVPairs

function result = localValidateSignalName(SigNameVal)
    result = 1;
    if ~ischar(SigNameVal)
        error(message('dsp:logging:signalNameWrongType'));            
    end
end % localValidateSignalName

function result = localValidateSignalPath(SigPathVal)
    result = 1;
    if ~isa(SigPathVal, 'dsp.util.SignalPath') && ~isa(SigPathVal, 'char')
        error(message('dsp:logging:signalPathWrongType'));           
    elseif isa(SigPathVal, 'dsp.util.SignalPath') && (length(SigPathVal) ~= 1)
        % Same error
        error(message('dsp:logging:signalPathWrongType'));            
    end
end % localValidateSignalPath

function localCheckParamName(PvPairs)

    if ~ischar(PvPairs{1})
        error(message('dsp:logging:missingSignalNameOrPathArg'));
    end
    
    ParamName = char(PvPairs{1});
    
    if ~(strcmp(ParamName, 'SignalName') || strcmp(ParamName, 'SignalPath'))
        error(message('dsp:logging:missingSignalNameOrPathArg'));
    end
    
end % localCheckParamName

% EO%EOF

