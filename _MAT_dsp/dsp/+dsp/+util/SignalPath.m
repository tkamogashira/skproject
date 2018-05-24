classdef SignalPath
    %dsp.util.SignalPath Holds properties of paths to signals    
    %   SignalPath(SignalName, BlockPath, PortIndex, BusElement) creates a
    %   SignalPath object which contains path information for signals
    %   in Simulink.SimulationData.Dataset objects. You get
    %   Simulink.SimulationData.Dataset objects when you use Dataset
    %   logging to log signals from a Simulink model.
    %
    %   dsp.util.SignalPath objects are returned by the
    %   dsp.util.getSignalPath function and can be used as input to the
    %   dsp.util.getLogsArray function.
    %
    %   SignalPath properties:
    %
    %   SignalName - Name of the signal 
    %   BlockPath  - Path to the block in the model that the signal originates from
    %   PortIndex  - Block output port index that the signal originates from
    %   BusElement - String description of a signal that is in a bus
    %
    %   All properties read only        
    %
    %   See also dsp.util.getSignalPath, dsp.util.getLogsArray, 
    %   Simulink.SimulationData.BlockPath, Simulink.SimulationData.Dataset
    
    % Copyright 2011 The MathWorks, Inc.
            
    properties (SetAccess=immutable)
    % 'SignalName':
    % Contains the name of the signal output by the block at the 'BlockPath'
    % specified.
    SignalName = '';
    % 'BlockPath':
    % Provides the Simulink.SimulationData.BlockPath to the block in the Simulink 
    % model from which the signal originates.
    BlockPath = [];
    % 'PortIndex'
    % Provides the output port index of the block from which the logged signal
    % 'SignalName' originates.
    PortIndex = 1;
    %'BusElement'
    % Provides a string description of a signal in a logged bus. When
    % 'SignalPath' is not a logged bus, this property will be an empty string.
    %
    % If the 'SignalPath' object is a logged bus signal, 'BusElement' will
    % be a string formatted as follows:
    %
    % 1. When the bus contains a non-bus signal, 'BusElement' is the
    % name of that signal.
    % 2. When the bus contains a nested bus containing a non-bus signal,
    % 'BusElement' is a dot-separated string consisting of the name of
    % the nested bus followed by the name of the non-bus signal. 
    % For example: 'nestbus.signal1'
    % 3. When the bus contains nested busses within nested busses to any
    % depth, 'BusElement' is a dot-separated string containing all the
    % nested bus names and ending with the non-bus signal name.
    % For example: 
    % 'outernestedbus.innernestedbus.signal1.'
    %
    BusElement = '';
    end
    
    methods (Access=public)
        function obj = SignalPath(SignalName, BlockPath, PortIndex, BusElement)
            
            if ~isa(BlockPath, 'Simulink.SimulationData.BlockPath')
                error(message('dsp:logging:notBlockPath'));
            end
            
            obj.SignalName = SignalName;
            obj.BlockPath  = BlockPath;
            obj.PortIndex  = PortIndex;
            obj.BusElement = BusElement;
        end
    end
    
end

