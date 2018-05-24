classdef VariableBandwidthFilterBase< handle
%VARIABLEBANDWIDTHFILTERBASE Abstract base class for variable bandwidth
% objects. dsp.VariableBandwidthIIRFilter and 
% dsp.VariableBandwidthFIRFilter inherit from this base class.  

 
%   Copyright 2013 The MathWorks, Inc.

    methods
        function out=VariableBandwidthFilterBase
            % Constructor
        end

        function convertToDFILT(in) %#ok<MANU>
            % Returns equivalent dfilt to current object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isInputSizeLockedImpl(in) %#ok<MANU>
            % Variable size inputs are allowed.
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
            % Tune the filter coefficients
        end

        function realizemdl(in) %#ok<MANU>
            % realizemdl is not supported     
        end

        function releaseImpl(in) %#ok<MANU>
            % Release the filter object
        end

        function resetImpl(in) %#ok<MANU>
            % Reset the filter object
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Setup the input datatype and number of channels.
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

        function validatePropertiesImpl(in) %#ok<MANU>
            % Cross-validation of filter specifications
        end

    end
    methods (Abstract)
        %TUNECOEFFICIENTS Children objects redefine this method to specify
        % how coefficients are modified when filter characteristic is tuned
        tuneCoefficients; %#ok<NOIN>

        % VALIDATEFREQUENCYRANGE Children objects redefine this method to
        % validate cutoff frequencies versus sample rate. 
        validateFrequencyRange; %#ok<NOIN>

    end
    properties
        % Bandwidth  Filter center bandwidth.
        %   Specify the filter bandwidth in Hertz as a real, positive
        %   scalar smaller than SampleRate/2. This property applies when
        %   you set the FilterType property to 'Bandpass' or 'Bandstop'.
        %   The default is 7680 Hz. This property is tunable.
        Bandwidth;

        %CenterFrequency  Filter center frequency.
        %   Specify the filter center frequency in Hz as a real, positive
        %   scalar smaller than SampleRate/2. This property applies when
        %   you set the FilterType property to 'Bandpass' or 'Bandstop'.
        %   The default is 11025 Hz. This property is tunable.
        CenterFrequency;

        %FilterType Filter type
        %   Specify the type of the filter as one of 'Lowpass' | 'Highpass'
        %   | 'Bandpass' | 'Bandstop'. The default is 'Lowpass'.
        FilterType;

        % SampleRate Input sample rate
        %   Specify the sampling rate of the input in Hertz as a finite numeric
        %   scalar. The default is 44.1 kHz.
        SampleRate;

        % pDatatype Input datatype
        pDatatype;

        % pNumChannels Number of input channels
        pNumChannels;

        % filter handle. Children objects instantiate and set this object
        pfilter;

    end
end
