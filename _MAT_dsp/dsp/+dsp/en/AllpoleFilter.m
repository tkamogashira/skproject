classdef AllpoleFilter< handle
%Allpole Filter
%   HALLPOLE = dsp.AllpoleFilter returns an Allpole filter System object,
%   HALLPOLE, which independently filters each channel of the input over
%   time using a specified Allpole filter implementation.
%
%   HALLPOLE = dsp.AllpoleFilter('PropertyName', PropertyValue, ...)
%   returns an Allpole filter System object, HALLPOLE, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HALLPOLE, X) filters the real or complex input signal X using
%   the specified filter to produce the output Y. The System object filters
%   each channel of the input signal independently over time.
%
%   AllpoleFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create Allpole filter object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the internal states to initial conditions
%
%   AllpoleFilter properties:
%
%   Denominator                  - Filter coefficients
%   ReflectionCoefficients       - Lattice filter coefficients
%   InitialConditions            - Initial conditions
%   Structure                    - Filter structure
%   FrameBasedProcessing         - Process input in frames or as samples
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.AllpoleFilter.helpFilterAnalysis.
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.AllpoleFilter.helpFixedPoint.
%
%   % EXAMPLE: Low pass filter 2 sinusoidal frequencies using an Allpole
%   %          filter.
%      t = [0:63]./32e3;
%      xin = (sin(2*pi*400*t)+sin(2*pi*14e3*t)) / 2;
%      hSR = dsp.SignalSource(xin', 4);
%      hLog = dsp.SignalSink;
%      hAllpole = dsp.AllpoleFilter('Denominator',[1 -0.9]);
%      while ~isDone(hSR)
%          input = step(hSR);
%          filteredOutput = step(hAllpole,input);
%          step(hLog,filteredOutput);
%      end
%      filteredResult = hLog.Buffer;
%      periodogram(filteredResult,[],[],32e3)
%
%   See also dsp.BiquadFilter, dsp.FIRFilter, dsp.IIRFilter,
%            dsp.AllpoleFilter.helpFixedPoint.

 
%   Copyright 2012-2013 The MathWorks, Inc.

    methods
        function out=AllpoleFilter
            %Allpole Filter
            %   HALLPOLE = dsp.AllpoleFilter returns an Allpole filter System object,
            %   HALLPOLE, which independently filters each channel of the input over
            %   time using a specified Allpole filter implementation.
            %
            %   HALLPOLE = dsp.AllpoleFilter('PropertyName', PropertyValue, ...)
            %   returns an Allpole filter System object, HALLPOLE, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HALLPOLE, X) filters the real or complex input signal X using
            %   the specified filter to produce the output Y. The System object filters
            %   each channel of the input signal independently over time.
            %
            %   AllpoleFilter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create Allpole filter object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the internal states to initial conditions
            %
            %   AllpoleFilter properties:
            %
            %   Denominator                  - Filter coefficients
            %   ReflectionCoefficients       - Lattice filter coefficients
            %   InitialConditions            - Initial conditions
            %   Structure                    - Filter structure
            %   FrameBasedProcessing         - Process input in frames or as samples
            %
            %   This System object supports several filter analysis methods. For more
            %   information, type dsp.AllpoleFilter.helpFilterAnalysis.
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.AllpoleFilter.helpFixedPoint.
            %
            %   % EXAMPLE: Low pass filter 2 sinusoidal frequencies using an Allpole
            %   %          filter.
            %      t = [0:63]./32e3;
            %      xin = (sin(2*pi*400*t)+sin(2*pi*14e3*t)) / 2;
            %      hSR = dsp.SignalSource(xin', 4);
            %      hLog = dsp.SignalSink;
            %      hAllpole = dsp.AllpoleFilter('Denominator',[1 -0.9]);
            %      while ~isDone(hSR)
            %          input = step(hSR);
            %          filteredOutput = step(hAllpole,input);
            %          step(hLog,filteredOutput);
            %      end
            %      filteredResult = hLog.Buffer;
            %      periodogram(filteredResult,[],[],32e3)
            %
            %   See also dsp.BiquadFilter, dsp.FIRFilter, dsp.IIRFilter,
            %            dsp.AllpoleFilter.helpFixedPoint.
        end

        function convertToDFILT(in) %#ok<MANU>
            % Convert the System object to a dfilt object for analysis 
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.AllpoleFilter System object fixed-point
            %               information
            %   dsp.AllpoleFilter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.AllpoleFilter System
            %   object.
        end

        function infoImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Cache input data type for filter analysis
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of ['Full
        %   precision' | 'Same as product' | 'Same as input' | 'Custom']. The
        %   default value of this property is 'Full precision'.
        AccumulatorDataType;

        %CoefficientsDataType Denominator word- and fraction-length designations
        %   Specify the numerator fixed-point data type as one of ['Same word
        %   length as input' | 'Custom']. The default value of this property is
        %   'Same word length as input'.
        CoefficientsDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomCoefficientsDataType Denominator word and fraction lengths
        %   Specify the numerator fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   CoefficientsDataType property is 'Custom'. The default value of
        %   this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomCoefficientsDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomProductDataType;

        %CustomReflectionCoefficientsDataType Reflection coefficients word and
        %fraction lengths
        %   Specify the numerator fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   ReflectionCoefficientsDataType property is 'Custom'. The default
        %   value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomReflectionCoefficientsDataType;

        %CustomStateDataType State word and fraction lengths
        %   Specify the state fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomStateDataType;

        %Denominator Filter coefficients
        %   Specify the filter coefficients as a real or complex numeric row
        %   vector. This property is applicable when the Structure property is
        %   set to one of 'Direct form', or 'Direct form transposed'. This
        %   property is tunable. The default value of this property is [1.0 0.1].
        Denominator;

        %FrameBasedProcessing Process input in frames or as samples
        %  Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %  property to false to enable sample-based processing. The default
        %  value of this property is true.
        FrameBasedProcessing;

        %InitialConditions Initial conditions
        %   Specify the initial conditions of the filter states. This property 
        %   is tunable. The default value of this property is 0.
        InitialConditions;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of ['Same as
        %   accumulator' | 'Same as input' | 'Custom']. The default value of
        %   this property is 'Same as input'.
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of ['Wrap' | 'Saturate']. The
        %   default value of this property is 'Wrap'.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of ['Full
        %   precision' | 'Same as input' | 'Custom']. The default value of this
        %   property is 'Full precision'.
        ProductDataType;

        %ReflectionCoefficients Lattice filter coefficients
        %   Specify the lattice filter coefficients as a real or complex
        %   numeric row vector. This property is applicable when the
        %   Structure property is set to 'Lattice AR'. This property is
        %   tunable. The default value of this property is [0.2 0.4].
        ReflectionCoefficients;

        %ReflectionCoefficientsDataType Reflection coefficients word- and
        %fraction-length designations
        %   Specify the reflection coefficients fixed-point data type as one of
        %   ['Same word length as input' | 'Custom']. The default value of this
        %   property is 'Same word length as input'.
        ReflectionCoefficientsDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   'Floor' | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. The default
        %   value of this property is 'Floor'.
        RoundingMethod;

        %StateDataType State word- and fraction-length designations
        %   Specify the state fixed-point data type as one of ['Same as
        %   accumulator' | 'Same as input' | 'Custom']. The default value of
        %   this property is 'Same as accumulator'.
        StateDataType;

        %Structure Filter structure
        %   Specify the filter structure as one of ['Direct form' | 'Direct
        %   form transposed' | 'Lattice AR']. The default value of this
        %   property is 'Direct form'.
        Structure;

    end
end
