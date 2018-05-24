function result = getSignalPath(LogObject, SignalName)    
% dsp.util.getSignalPath Return paths to logged signals
%   dsp.util.getSignalPath(LogObject, SignalName) Return all paths to
%   signals in 'LogObject' with name 'SignalName'. 'LogObject' must be a
%   Simulink.SimulationData.Dataset or Simulink.SimulationData.Signal
%   object. 'SignalName' must be the name of a signal in 'LogObject'.
%      * If 'LogObject' contains a unique signal with name 'SignalName',
%         the function returns a dsp.util.SignalPath object.
%      * If 'LogObject' contains more than one signal with the specified
%         name, the function returns an array of dsp.util.SignalPath objects. 
%   To return the path to an unnamed signal in 'LogObject', set
%   'SignalName' to the empty string ('').
%
%   See also dsp.util.getLogsArray, dsp.util.SignalPath,
%   Simulink.SimulationData.Dataset, Simulink.SimulationData.Signal,
%   Simulink.SimulationData.updateDatasetFormatLogging

% Copyright 2011 The MathWorks, Inc.

try
    
    if ~isa(SignalName, 'char')
        error(message('dsp:logging:signalNameNotString'));       
    end
        
    if isa(LogObject, 'Simulink.SimulationData.Dataset')
        result = localHandleDataset(LogObject, SignalName);
    elseif isa(LogObject,'Simulink.SimulationData.Signal')
        result = localHandleSignal(LogObject, SignalName);
    else        
        error(message('dsp:logging:logObjectNotDatasetOrSignal'));
    end
    
    if isempty(result)
        error(message('dsp:logging:noSuchSignal', SignalName));      
    else    
        result = result';
    end

catch me
    me.throwAsCaller;
end

end % getBlockPath

function result = localHandleDataset(LogObject, SignalName)

result = dsp.util.SignalPath.empty;

found = LogObject.find(SignalName);

if isempty(found)
    return; % Empty object
end

if isa(found, 'Simulink.SimulationData.Signal')
    
    result = localHandleSignal(found, SignalName);
    
elseif isa(found, 'Simulink.SimulationData.Dataset')
    
    for i=1:found.getLength
        r = localHandleSignal(found.get(i), SignalName);
        for j=1:length(r)
            result(end+1) = r(j);
        end
    end
    
else
    error(message('dsp:logging:logObjectReadError1', class(found), ...
        class(LogObject), 'Simulink.SimulationData.Signal', ...
        'Simulink.SimulationData.Dataset'));
end

end % localHandleDataset

%EOF

function result = localHandleSignal(SignalObj, SignalName)

result = dsp.util.SignalPath.empty;

if isa(SignalObj.Values, 'struct')
               
    % Get bus elements for every signal in the bus. Decend into nested
    % busses, if present. BusElements will be a flattened list of all bus
    % elements in the bus.
    
    % initialize to none
    BusElements = {};
    % Used to hold bus element substrings during search
    BusElementSubstring = '';
    
    BusElements = localGetBusElements(SignalObj.Values, BusElements, ...
        BusElementSubstring);
    
    if isempty(BusElements)
        error(message('dsp:logging:busEmpty', SignalName));
    end       
    
    % Create a dsp.util.SignalPath object for every signal in the bus.
    for i=1:length(BusElements)
        result(end+1) = dsp.util.SignalPath(SignalName, SignalObj.BlockPath, ...
            SignalObj.PortIndex, BusElements{i});       
    end
    
elseif isa(SignalObj.Values, 'timeseries')
    
    if ~strcmp(SignalObj.Name, SignalName)
        return; % Empty object
    end
    
    result = dsp.util.SignalPath(SignalName, SignalObj.BlockPath, SignalObj.PortIndex, '');
else
    error(message('dsp:logging:logObjectReadError1', ...
        class(SignalObj.Values), class(SignalObj), 'timeseries', 'struct'));
end

end % localHandleSignal

function BusElements = localGetBusElements(obj, BusElements, BusElementSubstring)

if ~isa(obj, 'struct')    
    error(message('dsp:logging:logObjectReadError', ...
        class(obj), 'Simulink.SimulationData.Signal', 'struct'));
end

fds = fields(obj);

for i=1:length(fds)        
    
    if eval(sprintf('isa(obj.%s, ''timeseries'')',fds{i}))
        if isempty(BusElementSubstring)
            BusElements{end+1} = fds{i};
        else
            BusElements{end+1} = sprintf('%s.%s', BusElementSubstring, fds{i});
        end
                      
    elseif eval(sprintf('isa(obj.%s, ''struct'')',fds{i}))
         % Need a local bus element substring when decending into a nested
         % bus. The local bus element substring will be the
         % same BusElement substring for every signal in the nested bus.
         if isempty(BusElementSubstring)
            LocalBusElementSubstring = fds{i};
        else
            LocalBusElementSubstring = sprintf('%s.%s', BusElementSubstring, fds{i});
         end
        
        % Recursion step
        BusElements = eval(sprintf('localGetBusElements(obj.%s, BusElements, LocalBusElementSubstring)', fds{i}));                
    end
end

end % localGetBusElements
