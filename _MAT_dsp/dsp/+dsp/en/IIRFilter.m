classdef IIRFilter< handle
%IIR Filter
%   HIIR = dsp.IIRFilter returns an IIR filter System object, HIIR, which
%   independently filters each channel of the input over time using a
%   specified IIR filter implementation.
%
%   HIIR = dsp.IIRFilter('PropertyName', PropertyValue, ...) returns an IIR
%   filter System object, HIIR, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HIIR, X) filters the real or complex input signal X using the
%   specified filter to produce the output Y. The System object filters
%   each channel of the input signal independently over time.
%
%   IIRFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create IIR filter object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset filter states to initial conditions
%
%   IIRFilter properties:
%
%   Structure                    - Filter structure
%   Numerator                    - Numerator coefficients
%   Denominator                  - Denominator coefficients
%   InitialConditions            - Initial conditions
%   NumeratorInitialConditions   - Initial conditions on zeros side
%   DenominatorInitialConditions - Initial conditions on poles side
%   FrameBasedProcessing         - Process input in frames or as samples
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.IIRFilter.helpFilterAnalysis.
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.IIRFilter.helpFixedPoint.
%
%   % EXAMPLE: Low pass filter 2 sinusoidal frequencies using an IIR filter.
%      t = [0:63]./32e3;
%      xin = (sin(2*pi*4e3*t)+sin(2*pi*12e3*t)) / 2;
%      hSR = dsp.SignalSource(xin', 4);
%      hLog = dsp.SignalSink;
%      hIIR = dsp.IIRFilter;
%      [b,a] = butter(6,0.5);
%      hIIR.Numerator = b;
%      hIIR.Denominator = a;
%      while ~isDone(hSR)
%          input = step(hSR);
%          filteredOutput = step(hIIR,input);
%          step(hLog,filteredOutput);
%      end
%      filteredResult = hLog.Buffer;
%      periodogram(filteredResult,[],[],32e3)
%
%   See also dsp.BiquadFilter, dsp.FIRFilter, dsp.AllpoleFilter, 
%            dsp.IIRFilter.helpFixedPoint.

 
%   Copyright 2012-2013 The MathWorks, Inc.

    methods
        function out=IIRFilter
            %IIR Filter
            %   HIIR = dsp.IIRFilter returns an IIR filter System object, HIIR, which
            %   independently filters each channel of the input over time using a
            %   specified IIR filter implementation.
            %
            %   HIIR = dsp.IIRFilter('PropertyName', PropertyValue, ...) returns an IIR
            %   filter System object, HIIR, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HIIR, X) filters the real or complex input signal X using the
            %   specified filter to produce the output Y. The System object filters
            %   each channel of the input signal independently over time.
            %
            %   IIRFilter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create IIR filter object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset filter states to initial conditions
            %
            %   IIRFilter properties:
            %
            %   Structure                    - Filter structure
            %   Numerator                    - Numerator coefficients
            %   Denominator                  - Denominator coefficients
            %   InitialConditions            - Initial conditions
            %   NumeratorInitialConditions   - Initial conditions on zeros side
            %   DenominatorInitialConditions - Initial conditions on poles side
            %   FrameBasedProcessing         - Process input in frames or as samples
            %
            %   This System object supports several filter analysis methods. For more
            %   information, type dsp.IIRFilter.helpFilterAnalysis.
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.IIRFilter.helpFixedPoint.
            %
            %   % EXAMPLE: Low pass filter 2 sinusoidal frequencies using an IIR filter.
            %      t = [0:63]./32e3;
            %      xin = (sin(2*pi*4e3*t)+sin(2*pi*12e3*t)) / 2;
            %      hSR = dsp.SignalSource(xin', 4);
            %      hLog = dsp.SignalSink;
            %      hIIR = dsp.IIRFilter;
            %      [b,a] = butter(6,0.5);
            %      hIIR.Numerator = b;
            %      hIIR.Denominator = a;
            %      while ~isDone(hSR)
            %          input = step(hSR);
            %          filteredOutput = step(hIIR,input);
            %          step(hLog,filteredOutput);
            %      end
            %      filteredResult = hLog.Buffer;
            %      periodogram(filteredResult,[],[],32e3)
            %
            %   See also dsp.BiquadFilter, dsp.FIRFilter, dsp.AllpoleFilter, 
            %            dsp.IIRFilter.helpFixedPoint.
        end

        function convertToDFILT(in) %#ok<MANU>
            % Convert the System object to a dfilt object for analysis      
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.IIRFilter System object fixed-point
            %               information
            %   dsp.IIRFilter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.IIRFilter System
            %   object.
        end

        function infoImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

        function sos(in) %#ok<MANU>
            %sos  Convert to second-order-sections
            %   Hsos = sos(H) converts IIR discrete-time filter System object H to
            %   second-order section form. Hsos is a dsp.BiquadFilter System
            %   object.
            %
            %   Hsos = sos(H,DIR_FLAG) specifies the ordering of the 2nd order
            %   sections. If DIR_FLAG is equal to 'UP', the first row will contain
            %   the poles closest to the origin, and the last row will contain the
            %   poles closest to the unit circle. If DIR_FLAG is equal to 'DOWN',
            %   the sections are ordered in the opposite direction. The zeros are
            %   always paired with the poles closest to them. DIR_FLAG defaults to
            %   'UP'
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Cache input data type for filter analysis
        end

    end
    methods (Abstract)
    end
    properties
        %CustomDenominatorAccumulatorDataType Accumulator word and fraction
        %                                     lengths on poles side
        %  Specify the denominator accumulator fixed-point type as an
        %  auto-signed, scaled numerictype object. This property is applicable
        %  when the DenominatorAccumulatorDataType property is 'Custom'. The
        %  default value of this property is numerictype([],32,30).
        %
        %  See also numerictype.
        CustomDenominatorAccumulatorDataType;

        %CustomDenominatorCoefficientsDataType Denominator coefficients word
        %                                      and fraction lengths
        %  Specify the denominator coefficients fixed-point type as an
        %  auto-signed numerictype object. This property is applicable when the
        %  DenominatorCoefficientsDataType property is 'Custom'. The default
        %  value of this property is numerictype([],16,15).
        %
        %  See also numerictype.
        CustomDenominatorCoefficientsDataType;

        %CustomDenominatorProductDataType Product word and fraction lengths on
        %                                 poles side
        %  Specify the denominator product fixed-point type as an auto-signed,
        %  scaled numerictype object. This property is applicable when the
        %  DenominatorProductDataType property is 'Custom'. The default value
        %  of this property is numerictype([],32,30).
        %
        %  See also numerictype.
        CustomDenominatorProductDataType;

        %CustomMultiplicandDataType Multiplicand word and fraction lengths
        %   Specify the multiplicand fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   MultiplicandDataType property is 'Custom'. The default value of
        %   this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomMultiplicandDataType;

        %CustomNumeratorAccumulatorDataType Accumulator word and fraction
        %                                   lengths on zeros side
        %  Specify the numerator accumulator fixed-point type as an
        %  auto-signed, scaled numerictype object. This property is applicable
        %  when the NumeratorAccumulatorDataType property is 'Custom'. The
        %  default value of this property is numerictype([],32,30).
        %
        %  See also numerictype.
        CustomNumeratorAccumulatorDataType;

        %CustomNumeratorCoefficientsDataType Numerator coefficients word and 
        %                                    fraction lengths
        %  Specify the numerator coefficients fixed-point type as an
        %  auto-signed numerictype object. This property is applicable when
        %  the NumeratorCoefficientsDataType property is 'Custom'. The default
        %  value of this property is numerictype([],16,15).
        %
        %  See also numerictype.
        CustomNumeratorCoefficientsDataType;

        %CustomNumeratorProductDataType Product word and fraction lengths on
        %                               zeros side
        %  Specify the numerator product fixed-point type as an auto-signed,
        %  scaled numerictype object. This property is applicable when the
        %  NumeratorProductDataType property is 'Custom'. The default value of
        %  this property is numerictype([],32,30).
        %
        %  See also numerictype.
        CustomNumeratorProductDataType;

        %CustomOutputDataType Output word and fraction lengths
        %  Specify the output fixed-point type as an auto-signed, scaled
        %  numerictype object. This property is applicable when the
        %  OutputDataType property is 'Custom'. The default value of this
        %  property is numerictype([],16,15).
        %
        %  See also numerictype.
        CustomOutputDataType;

        %CustomStateDataType State word and fraction lengths
        %  Specify the state fixed-point type as an auto-signed, scaled
        %  numerictype object. This property is applicable when the
        %  StateDataType property is 'Custom'.The default value of this
        %  property is numerictype([],16,15).
        %
        %  See also numerictype.
        CustomStateDataType;

        %Denominator Denominator coefficients
        %   Specify the denominator coefficients as a real or complex numeric row
        %   vector. The default value of this property is [1 0.1]. This
        %   property is tunable.
        Denominator;

        %DenominatorAccumulatorDataType Denominator word- and fraction-length 
        %                               designations on poles side
        %  Specify the denominator accumulator fixed-point data type as one of
        %  ['Full precision' | 'Same as input' | 'Same as product' |'Custom'].
        %  The default value of this property is 'Full precision'.
        DenominatorAccumulatorDataType;

        %DenominatorCoefficientsDataType Denominator coefficients word- and 
        %                                fraction-length designations
        % Specify the denominator coefficients fixed-point data type as one of
        % ['Same word length as input' | 'Custom']. The default value of this
        % property is 'Same word length as input'.
        DenominatorCoefficientsDataType;

        %DenominatorInitialConditions Initial conditions on poles side
        %   Specify the initial conditions of the filter states on the side of
        %   the filter structure with the poles. This property is applicable
        %   when the Structure property is one of 'Direct form I' and 'Direct
        %   form I transposed'. The default value of this property is 0. This
        %   property is tunable.
        DenominatorInitialConditions;

        %DenominatorProductDataType Product word- and fraction-length 
        %                           designations on poles side
        %  Specify the denominator product fixed-point data type as one of
        %  ['Full precision' | 'Same as input' | 'Custom']. The default value
        %  of this property is 'Full precision'.
        DenominatorProductDataType;

        %FrameBasedProcessing Process input in frames or as samples
        %  Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %  property to false to enable sample-based processing. The default
        %  value of this property is true.
        FrameBasedProcessing;

        %InitialConditions Initial conditions
        %   Specify the initial conditions of the filter states. This property
        %   is applicable when the Structure property is one of 'Direct form
        %   II' and 'Direct form II transposed'. The default value of this
        %   property is 0. This property is tunable.
        InitialConditions;

        %MultiplicandDataType Multiplicand word- and fraction-length designations
        %  Specify the multiplicand fixed-point data type as one of ['Same as
        %  input' | 'Custom']. This property is applicable when the Structure
        %  property is 'Direct form I transposed'. The default value of this
        %  property is 'Same as input'.
        MultiplicandDataType;

        %Numerator Numerator coefficients
        %   Specify the numerator coefficients as a real or complex numeric row
        %   vector. The default value of this property is [1 1]. This property
        %   is tunable. 
        Numerator;

        %NumeratorAccumulatorDataType Accumulator word- and fraction-length 
        %                             designations on zeros side
        %  Specify the numerator accumulator fixed-point data type as one of
        %  ['Full precision' | 'Same as input' | 'Same as product' |'Custom'].
        %  The default value of this property is 'Full precision'.
        NumeratorAccumulatorDataType;

        %NumeratorCoefficientsDataType Numerator coefficients word- and 
        %                              fraction-length designations
        %  Specify the numerator coefficients fixed-point data type as one of
        %  ['Same word length as input' | 'Custom']. The default value of this
        %  property is 'Same word length as input'.
        NumeratorCoefficientsDataType;

        %NumeratorInitialConditions Initial conditions on zeros side
        %   Specify the initial conditions of the filter states on the side of
        %   the filter structure with the zeros. This property is applicable
        %   when the Structure property is one of 'Direct form I' and 'Direct
        %   form I transposed'. The default value of this property is 0. This
        %   property is tunable.
        NumeratorInitialConditions;

        %NumeratorProductDataType Product word- and fraction-length 
        %                         designations on zeros side
        %  Specify the numerator product fixed-point data type as one of
        %  ['Full precision' | 'Same as input' | 'Custom']. The default value
        %  of this property is 'Full precision'.
        NumeratorProductDataType;

        %OutputDataType Output word- and fraction-length designations
        %  Specify the output fixed-point data type as one of ['Full precision'
        %  | 'Same as input' | 'Custom']. The default value of this property is
        %  'Same as input'.
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %  Specify the overflow action as one of ['Wrap' | 'Saturate']. The
        %  default value of this property is 'Wrap'.
        OverflowAction;

        %RoundingMethod Rounding method for fixed-point operations
        %  Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %  'Floor' | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. The default
        %  value of this property is 'Floor'.
        RoundingMethod;

        %StateDataType State word- and fraction-length designations
        %  Specify the state fixed-point data type as one of ['Same as input' |
        %  'Custom']. This property is not applicable for Direct form I filter
        %  structure. The default value of this property is 'Same as input'.
        StateDataType;

        %Structure Filter structure
        %  Specify the filter structure as one of ['Direct form I' | 'Direct
        %  form I transposed' | 'Direct form II' | 'Direct form II
        %  transposed']. The default value of this property is 'Direct form II
        %  transposed'.
        Structure;

    end
end
