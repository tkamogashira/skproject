classdef DigitalFilter< handle
%DigitalFilter Filter each channel of input using static or time-varying
%digital filter implementations
%   HFILT = dsp.DigitalFilter returns a digital filter System object,
%   HFILT, which independently filters each channel of the input over
%   successive calls to step method using a specified digital filter
%   implementation.
%
%   HFILT = dsp.DigitalFilter('PropertyName', PropertyValue, ...) returns a
%   digital filter System object, HFILT, with each specified property set
%   to the specified value.
%
%   Step method syntax:
%
%   Y = step(HFILT, X) filters the real or complex input signal X using the
%   specified filter to produce the output Y. The System object filters
%   each channel of the input signal independently over successive calls to
%   step method.
%
%   Y = step(HFILT, X, COEFF) uses the time-varying numerator or
%   denominator coefficients COEFF, to filter the input signal X and
%   produce the output Y. This option is possible when the TransferFunction
%   property is either 'FIR (all zeros)' or 'IIR (all poles)', and the
%   CoefficientsSource property is 'Input port'.
%
%   Y = step(HFILT, X, NUM, DEN) uses the time-varying numerator
%   coefficients NUM, and the time-varying denominator coefficients DEN, to
%   filter the input signal X and produce the output Y. This option is
%   possible when the TransferFunction property is 'IIR (poles and zeros)'
%   and the CoefficientsSource property is 'Input port'.
%
%   DigitalFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create digital filter object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the internal states to initial conditions
%
%   DigitalFilter properties:
%
%   TransferFunction                  - Type of filter transfer function
%   Structure                         - Filter structure
%   CoefficientsSource                - Source of filter coefficients
%   Numerator                         - Numerator coefficients
%   Denominator                       - Denominator coefficients
%   ReflectionCoefficients            - Reflection coefficients of lattice
%                                       filter structure
%   SOSMatrix                         - SOS matrix of biquad filter
%                                       structure
%   ScaleValues                       - Scale values of biquad filter
%                                       structure
%   IgnoreFirstDenominatorCoefficient - Assume first denominator
%                                       coefficient is 1
%   InitialConditions                 - Initial conditions
%   NumeratorInitialConditions        - Initial conditions on zeros side
%   DenominatorInitialConditions      - Initial conditions on poles side
%   FrameBasedProcessing              - Process input in frames or as
%                                       samples
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.DigitalFilter.helpFixedPoint.
%
%   % EXAMPLE: Low pass filter 2 sinusoidal frequencies using an FIR filter.
%      t = [0:63]./32e3;
%      xin = (sin(2*pi*4e3*t)+sin(2*pi*12e3*t)) / 2;
%      hSR = dsp.SignalSource(xin', 4);
%      hLog = dsp.SignalSink;
%      hFilt = dsp.DigitalFilter;
%      hFilt.TransferFunction = 'FIR (all zeros)';
%      hFilt.Numerator = fir1(10,0.5);
%      while ~isDone(hSR)
%          input = step(hSR);
%          filteredOutput = step(hFilt,input);
%          step(hLog,filteredOutput);
%      end
%      filteredResult = hLog.Buffer;
%      periodogram(filteredResult,[],[],32e3)
%
%   See also dsp.BiquadFilter, 
%            dsp.DigitalFilter.helpFixedPoint.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=DigitalFilter
            %DigitalFilter Filter each channel of input using static or time-varying
            %digital filter implementations
            %   HFILT = dsp.DigitalFilter returns a digital filter System object,
            %   HFILT, which independently filters each channel of the input over
            %   successive calls to step method using a specified digital filter
            %   implementation.
            %
            %   HFILT = dsp.DigitalFilter('PropertyName', PropertyValue, ...) returns a
            %   digital filter System object, HFILT, with each specified property set
            %   to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HFILT, X) filters the real or complex input signal X using the
            %   specified filter to produce the output Y. The System object filters
            %   each channel of the input signal independently over successive calls to
            %   step method.
            %
            %   Y = step(HFILT, X, COEFF) uses the time-varying numerator or
            %   denominator coefficients COEFF, to filter the input signal X and
            %   produce the output Y. This option is possible when the TransferFunction
            %   property is either 'FIR (all zeros)' or 'IIR (all poles)', and the
            %   CoefficientsSource property is 'Input port'.
            %
            %   Y = step(HFILT, X, NUM, DEN) uses the time-varying numerator
            %   coefficients NUM, and the time-varying denominator coefficients DEN, to
            %   filter the input signal X and produce the output Y. This option is
            %   possible when the TransferFunction property is 'IIR (poles and zeros)'
            %   and the CoefficientsSource property is 'Input port'.
            %
            %   DigitalFilter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create digital filter object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the internal states to initial conditions
            %
            %   DigitalFilter properties:
            %
            %   TransferFunction                  - Type of filter transfer function
            %   Structure                         - Filter structure
            %   CoefficientsSource                - Source of filter coefficients
            %   Numerator                         - Numerator coefficients
            %   Denominator                       - Denominator coefficients
            %   ReflectionCoefficients            - Reflection coefficients of lattice
            %                                       filter structure
            %   SOSMatrix                         - SOS matrix of biquad filter
            %                                       structure
            %   ScaleValues                       - Scale values of biquad filter
            %                                       structure
            %   IgnoreFirstDenominatorCoefficient - Assume first denominator
            %                                       coefficient is 1
            %   InitialConditions                 - Initial conditions
            %   NumeratorInitialConditions        - Initial conditions on zeros side
            %   DenominatorInitialConditions      - Initial conditions on poles side
            %   FrameBasedProcessing              - Process input in frames or as
            %                                       samples
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.DigitalFilter.helpFixedPoint.
            %
            %   % EXAMPLE: Low pass filter 2 sinusoidal frequencies using an FIR filter.
            %      t = [0:63]./32e3;
            %      xin = (sin(2*pi*4e3*t)+sin(2*pi*12e3*t)) / 2;
            %      hSR = dsp.SignalSource(xin', 4);
            %      hLog = dsp.SignalSink;
            %      hFilt = dsp.DigitalFilter;
            %      hFilt.TransferFunction = 'FIR (all zeros)';
            %      hFilt.Numerator = fir1(10,0.5);
            %      while ~isDone(hSR)
            %          input = step(hSR);
            %          filteredOutput = step(hFilt,input);
            %          step(hLog,filteredOutput);
            %      end
            %      filteredResult = hLog.Buffer;
            %      periodogram(filteredResult,[],[],32e3)
            %
            %   See also dsp.BiquadFilter, 
            %            dsp.DigitalFilter.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.DigitalFilter System object
            %               fixed-point information
            %   dsp.DigitalFilter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the
            %   dsp.DigitalFilter System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of ['Same as
        %   input' | {'Same as product'} | 'Custom'].
        AccumulatorDataType;

        %CoefficientsSource Source of filter coefficients
        %   Specify the source of the filter coefficients as one of
        %   [{'Property'} | 'Input port']. When the filter coefficients are
        %   specified via input port, the System object updates the
        %   time-varying filter once every frame if the FrameBasedProcessing
        %   property is true or once every sample otherwise.
        CoefficientsSource;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomDenominatorCoefficientsDataType Denominator coefficients word 
        %                                      and fraction lengths
        %   Specify the denominator coefficients fixed-point type as an
        %   auto-signed numerictype object. This property is applicable when
        %   the DenominatorCoefficientsDataType property is 'Custom'. The word
        %   lengths of CustomNumeratorCoefficientsDataType,
        %   CustomDenominatorCoefficientsDataType and the
        %   CustomScaleValuesDataType property values, if applicable must be
        %   the same. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomDenominatorCoefficientsDataType;

        %CustomMultiplicandDataType Multiplicand word and fraction lengths
        %   Specify the multiplicand fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   MultiplicandDataType property is 'Custom'. The default value of
        %   this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomMultiplicandDataType;

        %CustomNumeratorCoefficientsDataType Numerator coefficients word and 
        %                                    fraction lengths
        %   Specify the numerator coefficients fixed-point type as an
        %   auto-signed numerictype object. This property is applicable when
        %   the NumeratorCoefficientsDataType property is 'Custom'. The word
        %   lengths of CustomNumeratorCoefficientsDataType,
        %   CustomDenominatorCoefficientsDataType, and the ScaleValuesTypes
        %   property values, if applicable must be the same. The default value
        %   of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomNumeratorCoefficientsDataType;

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

        %CustomScaleValuesDataType Scale values word and fraction lengths
        %   Specify the scale values fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   CoefficientsSource property is 'Property' and the
        %   ScaleValuesDataType property is 'Custom'. The word lengths of the
        %   CustomNumeratorCoefficientsDataType,
        %   CustomDenominatorCoefficientsDataType and CustomScaleValuesDataType
        %   property values, if applicable, must be the same. The default value
        %   of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomScaleValuesDataType;

        %CustomSectionInputDataType Section input word and fraction lengths
        %   Specify the section input fixed-point type as an auto-signed,
        %   scaled numerictype object. This property is applicable when the
        %   SectionInputDataType property is 'Custom'. The word lengths of the
        %   CustomSectionInputDataType and CustomSectionOutputDataType property
        %   values must be equal. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomSectionInputDataType;

        %CustomSectionOutputDataType Section Output word and fraction lengths
        %   Specify the section output fixed-point type as an auto-signed,
        %   scaled numerictype object. This property is applicable when the
        %   SectionOutputDataType property is 'Custom'. The word lengths of the
        %   CustomSectionInputDataType and CustomSectionOutputDataType property
        %   values must be equal. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomSectionOutputDataType;

        %CustomStateDataType State word and fraction lengths
        %   Specify the state fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   StateDataType property is 'Custom'.The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomStateDataType;

        %CustomTapSumDataType Tap sum word and fraction lengths
        %   Specify the tap sum fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   TapSumDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomTapSumDataType;

        %Denominator Denominator coefficients
        %   Specify the filter denominator coefficients as a real or complex
        %   numeric vector. This property is applicable when the
        %   TransferFunction property is 'IIR (all poles)', the
        %   CoefficientsSource property is 'Property' and the Structure
        %   property is not set to 'Lattice AR'. This property is also
        %   applicable when the TransferFunction property is 'IIR (poles &
        %   zeros)', the CoefficientsSource is 'Property', and the
        %   TransferFunction property is set to one of 'Direct form', 'Direct
        %   form symmetric', 'Direct form antisymmetric' or 'Direct form
        %   transposed'. When the TransferFunction property is 'IIR (poles &
        %   zeros)', the numerator and denominator must have the same
        %   complexity. This property is tunable. The default value of this
        %   property is [1 0.1].
        Denominator;

        %DenominatorCoefficientsDataType Denominator coefficients word- and fraction-
        %                                length designations
        %   Specify the denominator coefficients fixed-point data type as one 
        %   of [{'Same word length as input'} | 'Custom']. Setting this 
        %   property also sets the NumeratorCoefficientsDataType and the
        %   ScaleValuesDataType properties, if applicable, to the same value.
        %   This property is applicable when the CoefficientsSource property is
        %   'Property' and the TransferFunction property is not 'FIR (all 
        %   zeros)'.
        DenominatorCoefficientsDataType;

        %DenominatorInitialConditions Initial conditions on poles side
        %   Specify the initial conditions of the filter states on the side of
        %   the filter structure with the poles. This property is applicable
        %   when the TransferFunction property is 'IIR (poles & zeros)' and the
        %   Structure property is one of 'Direct form I', 'Direct form I
        %   transposed', Biquad direct form I (SOS)', or 'Biquad direct form I
        %   transposed (SOS)'. The default value of this property is 0. To
        %   learn how to specify initial conditions, see the help of the
        %   InitialConditions property.
        DenominatorInitialConditions;

        %FrameBasedProcessing Process input in frames or as samples
        %  Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %  property to false to enable sample-based processing. The default
        %  value of this property is true.
        FrameBasedProcessing;

        %IgnoreFirstDenominatorCoefficient Assume first denominator coefficient 
        %                                  is 1
        %   Setting this logical property to true reduces the number of
        %   computations the System object must make to produce the output, by
        %   omitting the 1/a0 term in the filter structure. The object's output
        %   is invalid if you set this property to true when the first
        %   denominator filter coefficient is not always 1 for your
        %   time-varying filter. Note that the object ignores this property for
        %   fixed-point inputs, since this object does not support non-unity a0
        %   coefficients for fixed-point inputs. This property is applicable
        %   when the CoefficientsSource property is 'Input port', the
        %   TransferFunction property is 'IIR (all poles)', and the Structure
        %   property is not set to 'Lattice AR'. This property is also
        %   applicable when the CoefficientsSource property is 'Input port' and
        %   the TransferFunction property is 'IIR (poles & zeros)'. The default
        %   value of this property is true.
        IgnoreFirstDenominatorCoefficient;

        %InitialConditions Initial conditions
        %   Specify the initial conditions of the filter states. When the
        %   TransferFunction property is 'FIR (all zeros)' or 'IIR (all
        %   poles)', the number of states or delay elements is equal to the
        %   number of reflection coefficients for the Lattice structure or the
        %   number of filter coefficients-1 for the other direct form
        %   structures. When the TransferFunction property is 'IIR (poles &
        %   zeros)', the number of states for Direct form II and Direct form II
        %   transposed structure is equal to the max(number of poles, number of
        %   zeros) - 1.    
        %   The initial conditions can be specified as a scalar, vector or
        %   matrix.  
        %   - If this property is set to a scalar value, the System object
        %   initializes all delay elements in the filter to that value. 
        %   - If this property is set to a vector whose length is equal to the
        %   number of delay elements in the filter, each vector element
        %   specifies a unique initial condition for a corresponding delay
        %   element. The object applies the same vector of initial
        %   conditions to each channel of the input signal. 
        %   - If this property is set to a vector whose length is equal to the
        %   product of the number of input channels and the number of delay
        %   elements in the filter, each element specifies a unique initial
        %   condition for a corresponding delay element in a corresponding
        %   channel. 
        %   - If this property is set to a matrix with the same number of rows
        %   as the number of delay elements in the filter, and one column for
        %   each channel of the input signal, each element specifies a unique
        %   initial condition for a corresponding delay element in a
        %   corresponding channel. 
        %   This property is applicable when the Structure property is
        %   not set to one of 'Direct Form I', 'Direct Form I transposed',
        %   'Biquad direct form I (SOS)', or 'Biquad direct form I transposed
        %   (SOS)'. The default value of this property is 0.
        InitialConditions;

        %MultiplicandDataType Multiplicand word- and fraction-length designations
        %   Specify the multiplicand fixed-point data type as one of [{'Same as
        %   output'} | 'Custom']. This property is applicable when the
        %   Structure property is 'Direct form I transposed' or 'Biquad direct
        %   form I transposed (SOS)'.
        MultiplicandDataType;

        %Numerator Numerator coefficients
        %   Specify the filter numerator coefficients as a real or complex
        %   numeric vector. This property is applicable when the
        %   TransferFunction property is 'FIR (all zeros)', the
        %   CoefficientsSource property is 'Property' and the Structure
        %   property is not set to 'Lattice MA'. This property is also
        %   applicable when the TransferFunction property is 'IIR (poles &
        %   zeros)', the CoefficientsSource is 'Property', and the
        %   TransferFunction property is set to one of 'Direct form', 'Direct
        %   form symmetric', 'Direct form antisymmetric' or 'Direct form
        %   transposed'. This property is tunable. The default value of this
        %   property is [1 2].
        Numerator;

        %NumeratorCoefficientsDataType Numerator coefficients word- and fraction-length
        %                              designations
        %   Specify the numerator coefficients fixed-point data type as one of
        %   [{'Same word length as input'} | 'Custom']. Setting this property
        %   also sets the DenominatorCoefficientsDataType and the
        %   ScaleValuesDataType properties, if applicable, to the same value.
        %   This property is applicable when the CoefficientsSource property is
        %   'Property', and the TransferFunction property is not 'IIR (all
        %   poles)'.
        NumeratorCoefficientsDataType;

        %NumeratorInitialConditions Initial conditions on zeros side
        %   Specify the initial conditions of the filter states on the side of
        %   the filter structure with the zeros. This property is applicable
        %   when the TransferFunction property is 'IIR (poles & zeros)' and the
        %   Structure property is one of 'Direct form I', 'Direct form I
        %   transposed', Biquad direct form I (SOS)', or 'Biquad direct form I
        %   transposed (SOS)'. The default value of this property is 0. To
        %   learn how to specify initial conditions, see the help of the
        %   InitialConditions property.
        NumeratorInitialConditions;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of ['Same as input'
        %   | {'Same as accumulator'} | 'Custom'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [ {'Same as
        %   input'} | 'Custom'].
        ProductDataType;

        %ReflectionCoefficients Reflection coefficients of lattice filter 
        %                       structure
        %   Specify the reflection coefficients of a lattice filter as a real
        %   or complex numeric vector. This property is applicable when the
        %   TransferFunction property is 'FIR (all zeros)', the Structure
        %   property is 'Lattice MA', and the CoefficientsSource property is
        %   'Property'. This property is also applicable when the
        %   TransferFunction property is 'IIR (all poles)', the Structure
        %   property is 'Lattice AR', and the CoefficientsSource property is
        %   'Property'. This property is tunable. The default value of this
        %   property is [0.2 0.4].
        ReflectionCoefficients;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %SOSMatrix SOS matrix of biquad filter structure
        %   Specify the second-order section (SOS) matrix of a biquad filter as
        %   an M-by-6 matrix, where M is the number of sections in the filter.
        %   Each row of the SOS matrix contains the numerator and denominator
        %   coefficients (bik and aik) of the corresponding section in the
        %   filter.
        %    SOSMatrix = [ b01 b11 b21  a01 a11 a21 
        %                  b02 b12 b22  a02 a12 a22
        %                  ...
        %                [ b0M b1M b2M  a0M a1M a2M ]
        %   The coefficients can be real or complex. This property is
        %   applicable when the TransferFunction property is 'IIR (poles and
        %   zeros)', the CoefficientsSource property is 'Property', and the
        %   Structure property is one of 'Biquad direct form I (SOS)', 'Biquad
        %   direct form I transposed (SOS)', 'Biquad direct form II (SOS)' or
        %   'Biquad direct form II transposed (SOS)'. This property is tunable.
        %   The default value of this property is [1 0.3 0.4 1 0.1 0.2].
        SOSMatrix;

        %ScaleValues Scale values of biquad filter structure
        %   Specify the scale values to be applied before and after each
        %   section of a biquadratic filter. The scale values must be a scalar
        %   or a vector of length M+1, where M is the number of sections. If
        %   this property is set to a scalar, the value is used as the gain
        %   value before the first section of the second-order filter. The rest
        %   of the gain values are set to 1. If this property is set to a
        %   vector of M+1 values, each value is used for a separate section of
        %   the filter. This property is applicable when the TransferFunction
        %   property is 'IIR (poles & zeros)', the CoefficientsSource property
        %   is 'Property', and the Structure property is one of 'Biquad direct
        %   form I (SOS)', 'Biquad direct form I transposed (SOS)', 'Biquad
        %   direct form II (SOS)' or 'Biquad direct form II transposed (SOS)'.
        %   This property is tunable. The default value of this property is 1.
        ScaleValues;

        %ScaleValuesDataType Scale values word- and fraction-length designations
        %   Specify the scale values fixed-point data type as one of [{'Same
        %   word length as input'} | 'Custom']. Setting this property also sets
        %   the NumeratorCoefficientsDataType and the 
        %   DenominatorCoefficientsDataType properties, if applicable, to the
        %   same value. This property is applicable when the CoefficientsSource 
        %   property is 'Property', the TransferFunction property is 'IIR
        %   (poles & zeros'), and the Structure property corresponds to one of
        %   the biquads.
        ScaleValuesDataType;

        %SectionInputDataType Section input word- and fraction-length designations
        %   Specify the section input fixed-point data type as one of [{'Same
        %   as input'} | 'Custom']. Setting this property also sets the
        %   SectionOutputDataType property to the same value. This property is
        %   applicable when the TransferFunction property is 'IIR (poles &
        %   zeros)', and the Structure property corresponds to one of the
        %   biquads.
        SectionInputDataType;

        %SectionOutputDataType Section output word- and fraction-length designations
        %   Specify the section output fixed-point data type as one of [{'Same
        %   as input'} | 'Custom']. Setting this property also sets the 
        %   SectionInputDataType property to the same value. This property is 
        %   applicable when the TransferFunction property is 'IIR (poles & 
        %   zeros)', and the Structure property corresponds to one of the 
        %   biquads. 
        SectionOutputDataType;

        %StateDataType State word- and fraction-length designations
        %   Specify the state fixed-point data type as one of ['Same as input'
        %   | {'Same as accumulator'} | 'Custom']. This property is not
        %   applicable for any of the direct form or direct form I filter
        %   structures.
        StateDataType;

        %Structure Filter structure
        %   Specify the filter structure as one of [{'Direct form'} |'Direct
        %   form symmetric' | 'Direct form antisymmetric' | 'Direct form
        %   transposed' | 'Lattice MA'] when the TransferFunction property
        %   is 'FIR (all zeros)'. Specify the filter structure as one of
        %   [ {'Direct form'} | 'Direct form transposed' | 'Lattice AR'] when
        %   the TransferFunction property is 'IIR (all poles)'. Specify the
        %   filter structure as one of ['Direct form I' | 'Direct form I
        %   transposed' | 'Direct form II' | {'Direct form II transposed'} |
        %   'Biquad direct form I (SOS)' | 'Biquad direct form I transposed
        %   (SOS)' | 'Biquad direct form II (SOS)' | 'Biquad direct form II
        %   transposed (SOS)'] when the TransferFunction property is 'IIR
        %   (poles & zeros)'. The biquad filter structures are not applicable
        %   when the CoefficientsSource property is set to 'Input port'.
        Structure;

        %TapSumDataType Tap sum word- and fraction-length designations
        %   Specify the tap sum fixed-point data type as one of [{'Same as
        %   input'} | 'Custom']. This property is applicable when the
        %   TransferFunction property is 'FIR (all zeros)' and the Structure
        %   property is 'Direct form symmetric' or 'Direct form antisymmetric'.
        TapSumDataType;

        %TransferFunction Type of filter transfer function
        %   Specify the type of transfer function of the digital filter as one
        %   of [{'IIR (poles & zeros)'} | 'IIR (all poles)' | 'FIR (all
        %   zeros)'].
        TransferFunction;

    end
end
