classdef RandomFMToneGenerator < matlab.System
    %FMToneGenerator Generates a randomly FM-modulated tone
    %
    % This is an example of a discrete-time System object
    %
    % For more examples refer to the documentation.
    % web('http://www.mathworks.com/help/dsp/define-new-system-objects.html', '-browser')
    %
    % Copyright 2013 The MathWorks, Inc.
 
    properties
        Amplitude = 1
        FrequencyOffset = 200
        FrequencyStandardDeviation = 20
        FrequencyVariationNormalizedBandwidth = 0.0025
        SamplesPerFrame = 1
    end
    
    properties(Nontunable)
        FrequencyResolution = 0.1
        SampleRate = 2000
    end

    properties(Access = private)
        pNoiseGenerator
        pNCO
        pFrequencyGain
    end
    
    methods
        function obj = RandomFMToneGenerator(varargin)
            % Support name-value pair arguments
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    methods (Access=protected)
        function setupImpl(obj)
            % Initialize noise generation
            obj.pNoiseGenerator = dspdemo.BandlimitedNoiseGenerator(...
                'NoiseStandardDeviation',obj.FrequencyStandardDeviation,...
                'NoiseNormalizedBandwidth',...
                    obj.FrequencyVariationNormalizedBandwidth,...
                'SamplesPerFrame', obj.SamplesPerFrame);
            
            % Initialize NCO
            fs = obj.SampleRate;
            nNCO = ceil(log2(fs/obj.FrequencyResolution));
            obj.pNCO = dsp.NCO('SamplesPerFrame', 1, ...
                'CustomAccumulatorDataType', numerictype([],nNCO),...
                'OutputDataType', 'double');
            
            obj.pFrequencyGain = 2^nNCO/fs;

        end
        
        function resetImpl(obj)
            reset(obj.pNoiseGenerator)
            reset(obj.pNCO)
        end
        
        function [fmtone, frequencyActual] = stepImpl(obj)
            frequencyActual = step(obj.pNoiseGenerator) + ...
                obj.FrequencyOffset;
            L = obj.SamplesPerFrame;
            fgain = obj.pFrequencyGain;
            fmtone = zeros(L, 1);
            for k = 1:obj.SamplesPerFrame
                fmtone(k) = obj.Amplitude * step(obj.pNCO, ...
                    int32(frequencyActual(k)*fgain));
            end
        end
        
        function N = getNumInputsImpl(~)
            % Specify number of System inputs
            N = 0; % Because stepImpl has no input arguments beyond obj
        end
        
        function N = getNumOutputsImpl(~)
            % Specify number of System outputs
            N = 2; % Because stepImpl has one output
        end
        
        function processTunedPropertiesImpl(obj)
           % Extra effort needed for
           % - FrequencyStandardDeviation (relevant to obj.pNoiseGenerator)
           % - FrequencyVariationNormalizedBandwidth (same)
           % - SamplesPerFrame (same)
            obj.pNoiseGenerator.NoiseStandardDeviation = ...
                obj.FrequencyStandardDeviation;
            obj.pNoiseGenerator.NoiseNormalizedBandwidth = ...
                obj.FrequencyVariationNormalizedBandwidth;
            obj.pNoiseGenerator.SamplesPerFrame = ...
                obj.SamplesPerFrame;
        end
    end
end

