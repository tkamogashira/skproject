classdef SpectralEstimator< handle
%SpectralEstimator SpectralEstimator class

   
%   Copyright 2012-2013 The MathWorks, Inc.

    methods
        function out=SpectralEstimator
            %SpectralEstimator SpectralEstimator class
        end

        function getCenterFrequency(in) %#ok<MANU>
            %getCenterFrequency Get current center frequency
        end

        function getFrequencyVector(in) %#ok<MANU>
        end

        function getFstart(in) %#ok<MANU>
            %getFstart Get current Fstart
        end

        function getFstop(in) %#ok<MANU>
            %getFstop Get current Fstop
        end

        function getInputSamplesPerUpdate(in) %#ok<MANU>
        end

        function getNFFT(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function getNumOverlapSamples(in) %#ok<MANU>
        end

        function getRBW(in) %#ok<MANU>
            %getRBW Get current resolution bandwidth
        end

        function getSegmentLength(in) %#ok<MANU>
        end

        function getSpan(in) %#ok<MANU>
            %getSpan Get current span
        end

        function getWindowENBW(in) %#ok<MANU>
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
            % If Span or RBW changes we need to setup the object again and reset
        end

        function releaseImpl(in) %#ok<MANU>
            % Release contained objects
            % NOTE: Databuffer is not owned by this object and is not flushed here
        end

        function resetImpl(in) %#ok<MANU>
            % Initialize matrix containing past periodograms
        end

        function setNumChan(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            %setupImpl Setup private properties and contained objects
        end

        function stepImpl(in) %#ok<MANU>
        end

        function thisSetup(in) %#ok<MANU>
            % The setup and set methods must be called in the right order or some
            % private properties used in a method might not be set to the correct
            % value
        end

        function updateBuffer(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        CenterFrequency;

        % If channel mode is 'All' then we compute periodograms for all channels.
        % If it is 'Single' then we compute the periodograms for the channel
        % specified in ChannelNumber property.
        ChannelMode;

        % Channel number only relevant when ChannelMode is 'Single'
        ChannelNumber;

        DigitalDownConvert;

        FFTLength;

        FFTLengthSource;

        FrequencyResolutionMethod;

        FrequencySpan;

        MaxHoldTrace;

        MinHoldTrace;

        OverlapPercent;

        RBW;

        RBWSource;

        ReduceUpdates;

        SampleRate;

        SidelobeAttenuation;

        Span;

        SpectralAverages;

        StartFrequency;

        StopFrequency;

        TwoSidedSpectrum;

        Window;

        WindowLength;

    end
end
