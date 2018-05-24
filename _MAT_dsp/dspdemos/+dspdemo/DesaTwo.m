classdef DesaTwo < matlab.System
% DESATWO Implements the Discrete Energy Separation Algorithm DESA-2

% Copyright 2013 The MathWorks, Inc.
 
    properties(Access = public)
        SampleRate = 1
    end
    
    properties(SetAccess = private, GetAccess = private)
        % Two Teager-Kaiser energy operators (with internal states)
        pDiscreteEnergyOperatorOne  % TeagerKaiserEnergyOperator
        pDiscreteEnergyOperatorTwo  % TeagerKaiserEnergyOperator
        % Two delay elements
        pDelayOne                   % dsp.Delay
        pDelayTwo                   % dsp.Delay
    end
    
    methods
        % Constructor
        function obj = DesaTwo(varargin)
            % Support name-value pair arguments
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    % System object "services" (all protected)
    methods(Access=protected)
        function [amp, freq] = stepImpl(obj, inSignal)
            % Used to avoid division by zero and asin argument > 1
            DELTA = 1e-5;
            MAX_ENRATIO = 4;
            
            % Use delay element to form input to two Teager-Keiser
            % Energy Operators
            tkeoOneInput = step(obj.pDelayOne, inSignal);
            tkeoTwoInput = inSignal - step(obj.pDelayTwo, inSignal);
            % Get energy outputs from two energy operator instances
            energyOne = step(obj.pDiscreteEnergyOperatorOne,tkeoOneInput);
            energyTwo = step(obj.pDiscreteEnergyOperatorTwo,tkeoTwoInput);
            % Constrain energy estimates to be positive and non-zero
            energyOne = max(DELTA, energyOne);
            energyTwo = max(DELTA, energyTwo);
            % Constrain energy ratio to be less than 4 - this makes
            % argument of asin less than 1
            energyRatio = min(energyTwo ./ energyOne, MAX_ENRATIO);
            % Compute amplitude and frequency estimates
            amp = 2*energyOne./(sqrt(energyTwo));
            freq = obj.SampleRate * 1/(2*pi) * asin(1/2 * sqrt(energyRatio) );
        end
        
        function numIn = getNumInputsImpl(~)
           numIn = 1;
        end

        function numOut = getNumOutputsImpl(~)
           numOut = 2;
        end
        
        function setupImpl(obj, inSignal) %#ok<INUSD>
            % Instantiate two internal Teager Kaiser Energy Operators 
            % with Kaiser order = 1 (default)
            obj.pDiscreteEnergyOperatorOne = ...
                dspdemo.TeagerKaiserEnergyOperator;
            obj.pDiscreteEnergyOperatorTwo = ...
                dspdemo.TeagerKaiserEnergyOperator;
            % Delay #1 has only one tap, Delay #2 has two
            obj.pDelayOne = dsp.Delay(1);
            obj.pDelayTwo = dsp.Delay(2);
            
        end
        
        function resetImpl(obj)
            % Reset all system object properties 
            reset(obj.pDiscreteEnergyOperatorOne);
            reset(obj.pDiscreteEnergyOperatorTwo);
            reset(obj.pDelayOne);
            reset(obj.pDelayTwo);
        end        
        
        function releaseImpl(obj)
            % Release all system object properties 
            release(obj.pDiscreteEnergyOperatorOne);
            release(obj.pDiscreteEnergyOperatorTwo);
            release(obj.pDelayOne);
            release(obj.pDelayTwo);
        end        
        
        
    end

end
