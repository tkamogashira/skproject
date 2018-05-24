classdef VariableFractionalDelay< handle
%VariableFractionalDelay Delay input by time-varying fractional number of
%sample periods
%   HVFD = dsp.VariableFractionalDelay returns a variable fractional delay
%   System object, HVFD, that delays a discrete-time input by a
%   time-varying fractional number of sample periods, as specified by the
%   second input.
%
%   HVFD = dsp.VariableFractionalDelay('PropertyName', PropertyValue, ...)
%   returns a variable fractional delay System object, HVFD, with each
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HVFD, X, D) delays the input X by D samples, where D should be
%   less than or equal to the value specified in the MaximumDelay property.
%   Delay values greater than the specified maximum delay are clipped
%   appropriately.
%
%   VariableFractionalDelay methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create variable fractional delay object with same property
%              values
%   isLocked - Locked status (logical)
%   reset    - Reset the states to initial conditions
%   info     - Returns characteristic information about valid delay range
%
%   VariableFractionalDelay properties:
%
%   InterpolationMethod          - Interpolation method
%   FilterHalfLength             - FIR interpolation filter half-length
%   FilterLength                 - Length of Farrow filter
%   InterpolationPointsPerSample - Number of interpolation points per input
%                                  sample
%   Bandwidth                    - Normalized input bandwidth
%   InitialConditions            - Initial values in the memory
%   MaximumDelay                 - Maximum delay
%   DirectFeedthrough            - Choice to allow direct feedthrough
%   FIRSmallDelayAction          - Action to take for small input delay
%                                  values in FIR interpolation mode
%   FarrowSmallDelayAction       - Action to take for small input delay
%                                  values in Farrow interpolation mode
%   FrameBasedProcessing         - Process input in frames or as samples
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.VariableFractionalDelay.helpFixedPoint.
%
%   % EXAMPLE: Use a VariableFractionalDelay System object to delay a  
%   %          signal by a varying fractional number of sample periods. 
%       hsr  = dsp.SignalSource;       % Default signal of 1:10
%       hvfd = dsp.VariableFractionalDelay;   
%       hLog = dsp.SignalSink;   
%       for ii = 1:10
%           delayedsig = step(hvfd, step(hsr), ii/10); 
%           step(hLog, delayedsig);
%       end
%       sigd = hLog.Buffer;
%       % The output sigd corresponds to the values of the delayed signal 
%       % that are sampled at fixed time intervals. For visualization 
%       % purposes, we can instead plot the time instants at which the
%       % amplitudes of signal samples are constant by treating the 
%       % signals as the sampling instants.
%
%       stem(hsr.Signal, 1:10, 'b')    
%       hold on;
%       stem(sigd.', 1:10, 'r');
%       legend('Original signal','Variable fractional delayed signal', ...
%       'Location','best')
%
%   See also dsp.VariableIntegerDelay, dsp.Delay,
%            dsp.DelayLine, 
%            dsp.VariableFractionalDelay.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=VariableFractionalDelay
            %VariableFractionalDelay Delay input by time-varying fractional number of
            %sample periods
            %   HVFD = dsp.VariableFractionalDelay returns a variable fractional delay
            %   System object, HVFD, that delays a discrete-time input by a
            %   time-varying fractional number of sample periods, as specified by the
            %   second input.
            %
            %   HVFD = dsp.VariableFractionalDelay('PropertyName', PropertyValue, ...)
            %   returns a variable fractional delay System object, HVFD, with each
            %   specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HVFD, X, D) delays the input X by D samples, where D should be
            %   less than or equal to the value specified in the MaximumDelay property.
            %   Delay values greater than the specified maximum delay are clipped
            %   appropriately.
            %
            %   VariableFractionalDelay methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create variable fractional delay object with same property
            %              values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states to initial conditions
            %   info     - Returns characteristic information about valid delay range
            %
            %   VariableFractionalDelay properties:
            %
            %   InterpolationMethod          - Interpolation method
            %   FilterHalfLength             - FIR interpolation filter half-length
            %   FilterLength                 - Length of Farrow filter
            %   InterpolationPointsPerSample - Number of interpolation points per input
            %                                  sample
            %   Bandwidth                    - Normalized input bandwidth
            %   InitialConditions            - Initial values in the memory
            %   MaximumDelay                 - Maximum delay
            %   DirectFeedthrough            - Choice to allow direct feedthrough
            %   FIRSmallDelayAction          - Action to take for small input delay
            %                                  values in FIR interpolation mode
            %   FarrowSmallDelayAction       - Action to take for small input delay
            %                                  values in Farrow interpolation mode
            %   FrameBasedProcessing         - Process input in frames or as samples
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.VariableFractionalDelay.helpFixedPoint.
            %
            %   % EXAMPLE: Use a VariableFractionalDelay System object to delay a  
            %   %          signal by a varying fractional number of sample periods. 
            %       hsr  = dsp.SignalSource;       % Default signal of 1:10
            %       hvfd = dsp.VariableFractionalDelay;   
            %       hLog = dsp.SignalSink;   
            %       for ii = 1:10
            %           delayedsig = step(hvfd, step(hsr), ii/10); 
            %           step(hLog, delayedsig);
            %       end
            %       sigd = hLog.Buffer;
            %       % The output sigd corresponds to the values of the delayed signal 
            %       % that are sampled at fixed time intervals. For visualization 
            %       % purposes, we can instead plot the time instants at which the
            %       % amplitudes of signal samples are constant by treating the 
            %       % signals as the sampling instants.
            %
            %       stem(hsr.Signal, 1:10, 'b')    
            %       hold on;
            %       stem(sigd.', 1:10, 'r');
            %       legend('Original signal','Variable fractional delayed signal', ...
            %       'Location','best')
            %
            %   See also dsp.VariableIntegerDelay, dsp.Delay,
            %            dsp.DelayLine, 
            %            dsp.VariableFractionalDelay.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.VariableFractionalDelay System 
            %               object fixed-point information
            %   dsp.VariableFractionalDelay.helpFixedPoint displays
            %   information about fixed-point properties and operations of the
            %   dsp.VariableFractionalDelay System object.
        end

        function infoImpl(in) %#ok<MANU>
            %info Returns characteristic information about valid delay range
            %   S = info(OBJ) returns a structure, S, containing characteristic
            %   information about the variable fractional delay System object, OBJ. S
            %   has one field, whose description is as follows.
            %   ValidDelayRange  - String containing possible range of delay
            %                      values based on different object property
            %                      settings, of the format:
            %                      [MinValidDelay, MaxValidDelay]. The input
            %                      delay is clipped to a valid range as indicated
            %                      by this property value.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator data type as one of [{'Same as product'} |
        %   'Same as first input' | 'Custom'].
        AccumulatorDataType;

        %AccumulatorPolynomialValueDataType Accumulator polynomial values word-
        %                                   and fraction-length designations
        %   Specify the accumulator polynomial values data type as one of
        %   [{'Same as first input'} | 'Custom']. This property is applicable
        %   when the InterpolationMethod property is 'Farrow'.
        AccumulatorPolynomialValueDataType;

        %Bandwidth Normalized input bandwidth
        %   Specify the bandwidth to which the interpolated output samples
        %   should be constrained as numeric scalar between 0 and 1. This
        %   property can be used to take advantage of the band limited
        %   frequency content of the input. For example, if the input signal
        %   does not have frequency content above Fs/4 (where Fs is the
        %   sampling frequency), a value of 0.5 can be specified. A value of 1
        %   specifies half the sample frequency. This property is applicable
        %   when the InterpolationMethod property is 'FIR'. The default value
        %   of this property is 1.
        Bandwidth;

        %CoefficientsDataType Coefficients word- and fraction-length designations
        %   Specify the coefficients data type as one of [{'Same word length as
        %   input'} | 'Custom'].
        CoefficientsDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomAccumulatorPolynomialValueDataType Accumulator polynomial values
        %                                         word and fraction lengths
        %   Specify the accumulator polynomial values fixed-point type as an
        %   auto-signed, scaled numerictype object. This property is applicable
        %   when the InterpolationMethod property is 'Farrow' and the
        %   AccumulatorPolynomialValueDataType property is 'Custom'. The
        %   default value of this property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomAccumulatorPolynomialValueDataType;

        %CustomCoefficientsDataType Coefficients word length
        %   Specify the coefficients fixed-point word length as an auto-signed,
        %   unscaled numerictype object. This property is applicable when the
        %   CoefficientsDataType property is 'Custom'. The default value of
        %   this property is numerictype([],32).
        %
        %   See also numerictype.
        CustomCoefficientsDataType;

        %CustomMultiplicandPolynomialValueDataType Multiplicand polynomial values
        %                                          word and fraction lengths
        %   Specify the multiplicand polynomial values fixed-point type as an
        %   auto-signed, scaled numerictype object. This property is applicable
        %   when the InterpolationMethod property is 'Farrow' and the
        %   MultiplicandPolynomialValueDataType property is 'Custom'. The
        %   default value of this property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomMultiplicandPolynomialValueDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomProductDataType;

        %CustomProductPolynomialValueDataType Product polynomial values word and 
        %                             fraction lengths
        %   Specify the product polynomial values fixed-point type as an
        %   auto-signed, scaled numerictype object. This property is applicable
        %   when the InterpolationMethod property is 'Farrow' and the
        %   ProductPolynomialValueDataType property is 'Custom'. The default
        %   value of this property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomProductPolynomialValueDataType;

        %DirectFeedthrough Choice to allow direct feedthrough 
        %   Select if the object should allow direct feedthrough. Setting this
        %   property to false increases the minimum possible delay by one. The
        %   default value of this property is true.
        DirectFeedthrough;

        %FIRSmallDelayAction Action to take for small input delay values in  
        %                    FIR interpolation mode
        %   Specify the action the object should take for small input delay
        %   values in FIR interpolation mode. Set this property to one of
        %   [{'Clip to the minimum value necessary for centered kernel'} |
        %   'Switch to linear interpolation if kernel cannot be centered'].
        %   This property is applicable when the InterpolationMethod property
        %   is 'FIR'.
        FIRSmallDelayAction;

        %FarrowSmallDelayAction Action to take for small input delay values in  
        %                       Farrow interpolation mode
        %   Specify the action the object should take for small input delay
        %   values in Farrow interpolation mode. Set this property to one of
        %   [{'Clip to the minimum value necessary for centered kernel'} |
        %   'Use off-centered kernel'].
        %   This property is applicable when the InterpolationMethod property
        %   is 'Farrow'.
        FarrowSmallDelayAction;

        %FilterHalfLength FIR interpolation filter half-length
        %   Specify the half-length of the FIR interpolation filter as a
        %   positive scalar integer. This property is applicable when the
        %   InterpolationMethod property is 'FIR'. For periodic signals, a
        %   larger value of this property (that is, a higher order filter)
        %   yields a better estimate of the delayed output sample. A value
        %   between 4 and 6 for this property (that is, a 7th to 11th order
        %   filter) is usually adequate. The default value of this property is
        %   4.
        FilterHalfLength;

        %FilterLength Length of Farrow filter
        %   Specify the length of the FIR filter implemented using the Farrow
        %   structure, as a positive scalar integer. This property is
        %   applicable when the InterpolationMethod property is 'Farrow'. The
        %   default value of this property is 4.
        FilterLength;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %   property to false to enable sample-based processing. The default
        %   value of this property is true. When the value of this property is
        %   false, the object supports N-D inputs and each element of the input
        %   is treated as a separate channel. When the value of this property
        %   is true, the object accepts M-by-N input matrices and treats each of
        %   the N input columns as a frame containing M sequential time samples
        %   from an independent channel.
        FrameBasedProcessing;

        %InitialConditions Initial values in the memory
        %   Specify the values with which the object's memory is initialized.
        %   The default value of this property is 0. The dimensions of this
        %   property can vary depending on whether fixed or time-varying
        %   initial conditions are desired, and on the FrameBasedProcessing
        %   property value.
        %   When the FrameBasedProcessing property is false, the object
        %   supports N-D array inputs. For an M-by-N-by-P sample-based input
        %   array U:
        %   * Set the InitialConditions property to a scalar value with which
        %   to initialize every sample of every channel in memory.  
        %   * Set the InitialConditions property to an array of dimension
        %   M-by-N-by-P-by-D with which to initialize memory samples U(2:D+1),
        %   where D is the value of the MaximumDelay property. This is applicable
        %   when the InterpolationMode property is 'Linear'.
        %   * Set the InitialConditions property to an array of dimension
        %   M-by-N-by-P-by-(D+L) with which to initialize memory samples U(2:D+1),
        %   where D is the value of the MaximumDelay property. L is the value of
        %   the FilterHalfLength property or floor of half the value of the
        %   FilterLength property, whichever is relevant. This is
        %   applicable when the InterpolationMethod property is 'FIR' or
        %   'Farrow'. 
        %   When the FrameBasedProcessing property is true, the object
        %   treats each of the N input columns as a frame containing M
        %   sequential time samples from an independent channel. For an M-by-N
        %   frame-based input matrix U:
        %   * Set the InitialConditions property to a scalar value with which
        %   to initialize every sample of every channel in memory. 
        %   * Set the InitialConditions property to an array of size
        %   1-by-N-by-D to specify different time-varying initial conditions
        %   for each channel, where D is the value of the MaximumDelay property.
        %   This is applicable when the InterpolationMethod property is
        %   'Linear'.
        %   * Set the InitialConditions property to an array of size
        %   1-by-N-by-(D+L) to specify different time-varying initial conditions
        %   for each channel, where D is the value of the MaximumDelay property. L
        %   is the value of the FilterHalfLength property or floor of half the
        %   value of the FilterLength property, whichever is relevant. This is
        %   applicable when the InterpolationMethod property is 'FIR' or
        %   'Farrow'.
        InitialConditions;

        %InterpolationMethod Interpolation method
        %   The method by which to interpolate between adjacent stored samples
        %   to obtain a value for the sample indexed by the input. This
        %   property can be set to one of [{'Linear'} | 'FIR' | 'Farrow']. When
        %   this property is set to 'FIR', the Signal Processing Toolbox
        %   intfilt function computes an FIR filter for interpolation.
        %
        %   See also intfilt.
        InterpolationMethod;

        %InterpolationPointsPerSample Number of interpolation points per input
        %                             sample
        %   Specify the number of interpolation points per input sample at
        %   which a unique FIR interpolation filter is computed, as a positive
        %   scalar integer. This property is applicable when the
        %   InterpolationMethod property is 'FIR'. The default value of this
        %   property is 10.
        InterpolationPointsPerSample;

        %MaximumDelay Maximum delay
        %   Specify the maximum delay that the object can produce for any
        %   sample as a positive scalar integer value. Delay input values
        %   exceeding this maximum are clipped at the maximum. The default
        %   value of this property is 100.
        MaximumDelay;

        %MultiplicandPolynomialValueDataType Multiplicand polynomial values 
        %                                    word- and fraction-length designations
        %   Specify the multiplicand polynomial values data type as one of
        %   [{'Same as first input'} | 'Custom']. This property is applicable
        %   when the InterpolationMethod property is 'Farrow'.
        MultiplicandPolynomialValueDataType;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output data type as one of [{'Same as accumulator'} |
        %   'Same as first input' | 'Custom'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product data type as one of [{'Same as first input'} |
        %   'Custom'].
        ProductDataType;

        %ProductPolynomialValueDataType Product polynomial values word- and 
        %                       fraction-length designations
        %   Specify the product polynomial values data type as one of [{'Same
        %   as first input'} | 'Custom']. This property is applicable when the
        %   InterpolationMethod property is 'Farrow'.
        ProductPolynomialValueDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   'Floor' | 'Nearest' |'Round' | 'Simplest' | {'Zero'}].
        RoundingMethod;

    end
end
