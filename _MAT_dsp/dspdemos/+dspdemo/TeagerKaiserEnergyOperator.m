% Class that implements the Teager-Kaiser discrete energy operator. This
% uses local-in-time samples to estimate the energy of a sinusoidal signal
%
% Copyright 2013 The MathWorks, Inc.

classdef TeagerKaiserEnergyOperator < matlab.System

    
    properties(Nontunable)
        KaiserOrder = 1 % Defines length and use of internal delay line
    end
    
    properties(Access = private)
        pDelayLine;     % Stores signal samples for energy estimation
    end
    
    methods
        % Constructor
        function obj = TeagerKaiserEnergyOperator(varargin)
            % Support name-value pair arguments
            setProperties(obj,nargin,varargin{:});

        end
    end
    
    % System object "services" (all protected)
    methods (Access=protected)
        function numIn = getNumInputsImpl(~)
           numIn = 1;
        end

        function numOut = getNumOutputsImpl(~)
           numOut = 1;
        end
        
        function setupImpl(obj, inSignal) %#ok<INUSD>
            delayLineLength = 2*obj.KaiserOrder+1;
            obj.pDelayLine = dsp.DelayLine(...
                delayLineLength, ...
                zeros(delayLineLength,1),...
                'DirectFeedthrough', true);
        end
        
        function resetImpl(obj)
            reset(obj.pDelayLine);
        end        
        
        function releaseImpl(obj)
            release(obj.pDelayLine);
        end        
        
        % Step method implementation
        function outEnergy = stepImpl(obj, inSignal)
            KO = obj.KaiserOrder;
            % Loop over input samples
            outEnergy = zeros(size(inSignal));
            for k = 1:size(inSignal,1)
                x = step(obj.pDelayLine, inSignal(k,:));
                % en = |x[n-1]|^2 - x[n-2]*x[n]
                outEnergy(k,:) = abs(x(end-KO,:))^2 - x(end-2*KO,:)*x(end,:);
            end
        end
    end
    
end