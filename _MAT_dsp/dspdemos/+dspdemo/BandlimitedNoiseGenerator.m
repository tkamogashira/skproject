classdef BandlimitedNoiseGenerator < matlab.System
 
% Copyright 2013 The MathWorks, Inc.
 
    properties
        NoiseStandardDeviation = 1
        NoiseNormalizedBandwidth = 0.25
        SamplesPerFrame = 1
        NumChannels = 1;
    end
    
    properties(Access = private)
        pNoiseFilter      % NoiseFilter
        pRMSNormalizer    % RMSNormalizer
    end
    
    properties(Access = private, Constant)
        pFilterOrder = 8
        pRMSNormalizerBufferLength = 1024
    end
    
    methods
        function obj = BandlimitedNoiseGenerator(varargin)
            % Support name-value pair arguments
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    methods (Access=protected)
        function setupImpl(obj, ~)
            % Create and store a variable-bandwidth filter 
            obj.pNoiseFilter = dsp.VariableBandwidthIIRFilter(...
                'SampleRate', 2,...
                'PassbandFrequency', obj.NoiseNormalizedBandwidth, ...
                'FilterOrder', obj.pFilterOrder);
            % Create and store an RMS normalizer
            obj.pRMSNormalizer = dspdemo.RMSNormalizer(...
                'TargetRMSAmplitude', obj.NoiseStandardDeviation, ...
                'InternalBufferLength', obj.pRMSNormalizerBufferLength, ...
                'MaxAmplitude', 5*obj.NoiseStandardDeviation);
        end
        
        function resetImpl(obj)
            reset(obj.pNoiseFilter);
            reset(obj.pRMSNormalizer);
        end
        
        function normalizedOutput = stepImpl(obj)
            % Generate random vector
            wideBandNoise = randn(obj.SamplesPerFrame, obj.NumChannels);
            % Filter it
            bandLimitedNoise = step(obj.pNoiseFilter, wideBandNoise);
            % Normalize it
            normalizedOutput = step(obj.pRMSNormalizer, bandLimitedNoise);
            
        end
        
        function N = getNumInputsImpl(~)
            % Specify number of System inputs
            N = 0; % Because stepImpl has no arguments beyond obj
        end
        
        function N = getNumOutputsImpl(~)
            % Specify number of System outputs
            N = 1; % Because stepImpl has one output
        end
        
        function processTunedPropertiesImpl(obj)
           % Extra effort needed for
           % - NoiseStandardDeviation (relevant to obj.pRMSNormalizer)
           % - NoiseNormalizedBandwidth (relevant to obj.pNoiseFilter)
            obj.pRMSNormalizer.TargetRMSAmplitude = ...
                obj.NoiseStandardDeviation;
            obj.pRMSNormalizer.MaxAmplitude = ...
                5*obj.NoiseStandardDeviation;
            obj.pNoiseFilter.PassbandFrequency = ...
                obj.NoiseNormalizedBandwidth;
        end
        
    end
end

