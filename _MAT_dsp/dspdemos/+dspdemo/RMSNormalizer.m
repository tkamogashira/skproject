classdef RMSNormalizer < matlab.System
    % RMSNormalizer normalizes its input signal so that the output has a
    % target RMS amplitude
    %
    % Copyright 2013 The MathWorks, Inc.
 
    properties(Nontunable)
        InternalBufferLength = 256
    end
    
    properties
        TargetRMSAmplitude = 1
        MaxAmplitude = 1
    end
    
    properties(Access = private)
        pDelayLine
    end
    
    methods
        % Constructor
        function obj = RMSNormalizer(varargin)
            % Support name-value pair arguments
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    methods (Access=protected)
        function setupImpl(obj, ~)
            obj.pDelayLine = dsp.DelayLine(obj.InternalBufferLength);
        end
        
        function resetImpl(obj)
            reset(obj.pDelayLine);
        end
        
        function y = stepImpl(obj, u)
            % Implement System algorithm. Calculate y as a function of
            % input u and state.
            y = zeros(size(u));
            for i = 1:length(u)
                buffer = step(obj.pDelayLine, u(i));
                currentRMS = (mean(buffer.^2))^0.5;

                y(i) = (obj.TargetRMSAmplitude/currentRMS) * u(i);

                if(abs(y(i)) > obj.MaxAmplitude)
                    y(i) = sign(y(i)) * obj.MaxAmplitude;
                end
            end
        end
        
        function N = getNumInputsImpl(~)
            % Specify number of System inputs
            N = 1; % Because stepImpl has one argument beyond obj
        end
        
        function N = getNumOutputsImpl(~)
            % Specify number of System outputs
            N = 1; % Because stepImpl has one output
        end
    end
end

