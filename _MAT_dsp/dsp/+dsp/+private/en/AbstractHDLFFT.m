classdef AbstractHDLFFT< handle
%   Copyright 2011-2013 The MathWorks, Inc.

     %   Copyright 2011-2013 The MathWorks, Inc.

    methods
        function out=AbstractHDLFFT
            %   Copyright 2011-2013 The MathWorks, Inc.
        end

        function Radix2FFT(in) %#ok<MANU>
            %FFTSim
            % N = Number of points.
            % dataIn_re Real part of input
            % dataIn_im Imaginary part of input.
        end

        function availableData(in) %#ok<MANU>
        end

        function bitReverse(in) %#ok<MANU>
            % this is called when stage is greater than 1. It is not valid for stage = 1.
        end

        function butterfly(in) %#ok<MANU>
            % Calculate Full precision
        end

        function createBitReversTable(in) %#ok<MANU>
        end

        function dispLatency(in) %#ok<MANU>
        end

        function getHeaderImpl(in) %#ok<MANU>
        end

        function getIconImpl(in) %#ok<MANU>
        end

        function getIndexVector(in) %#ok<MANU>
        end

        function getInputNamesImpl(in) %#ok<MANU>
        end

        function getLatency(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function getOutputNamesImpl(in) %#ok<MANU>
        end

        function getPropertyGroupsImpl(in) %#ok<MANU>
            %getPropertyGroupsImpl   Return property groups for object display
            %main = matlab.system.display.SectionGroup(...
            %    'Title', 'Main', ...
            %    'PropertyList', {'FFTImplementation','BitReversedOutput', 'Normalize','FFTLengthSource','FFTLength' });
        end

        function getTimingVector(in) %#ok<MANU>
        end

        function getTwiddleFactor(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.HDLFFT System object fixed-point information
            %   dsp.HDLFFT.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.FFT
            %   System object.
        end

        function inputTiming(in) %#ok<MANU>
        end

        function inputTimingX(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function read_outBuffer(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
            % Save the public properties
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            %%% Checking for FFTlength
        end

        function spFind(in) %#ok<MANU>
        end

        function spFindFirst(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
            % stepImpl
            %%% Real only input is not supported in 2014A since we didn't
            %%% have time to optimized the hardware. Therefore error out.
            %coder.extrinsic('inputTimingX');
        end

        function validateBoolean(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
            % validateInputsImpl
            % Input validation
            % Data inputs should be scalar/vector. For vector input the
            % vector size should be the same as FFTLength if
            % FFTLengthSource is 'Property', and a power of 2.
            % all the inputs should have the same size.
            % Data type can be single, double, uint, int or fi.
            % Control ports should be boolean
        end

        function write_outBuffer(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %EndOutputPort Enable end output port
        %The default value for this property is false.
        EndOutputPort;

        %FFTImplementation FFT implementation
        %   Specify the implementation used for the FFT.
        FFTImplementation;

        FFTLatency;

        %FFTLength FFT length
        %   Specify the FFT length. This property is applicable when the
        %   FFTLengthSource property is 'Property'. The default value of this
        %   property is 1024. This property must be a power of two 
        %  (8 <= N <= 2^16).
        FFTLength;

        %FFTLengthSource Source of FFT length
        %   Specify how to determine the FFT length as one of ['Auto' |
        %   {'Property'}]. When this property is set to 'Auto', the FFT
        %   length N is equal to the number of rows of the input signal. 
        %   N should be a power of 2 and (8 <= N <= 2^16). 
        FFTLengthSource;

        %OverflowAction Overflow Action
        %   Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %RoundingMethod Rounding Method
        %   method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Zero']. 
        RoundingMethod;

        %StartOutputPort Enable start output port
        %The default value for this property is false.
        StartOutputPort;

        %ValidInputPort Enable valid input port
        %The default value for this property is true.
        ValidInputPort;

        %ValidOutputPort Enable valid output port
        ValidOutputPort;

    end
end
