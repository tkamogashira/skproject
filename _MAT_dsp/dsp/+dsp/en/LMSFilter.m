classdef LMSFilter< handle
%LMSFilter Compute output, error, and weights using LMS adaptive algorithm
%   HLMS = dsp.LMSFilter returns an adaptive FIR filter System object,
%   HLMS, that computes the filtered output, filter error and the filter
%   weights for a given input and desired signal using the Least Mean
%   Squares (LMS) algorithm.
%
%   HLMS = dsp.LMSFilter('PropertyName', PropertyValue, ...) returns an LMS
%   filter System object, HLMS, with each specified property set to the
%   specified value.
%
%   HLMS = dsp.LMSFilter(LEN, 'PropertyName', PropertyValue, ...) returns
%   an LMS filter System object, HLMS, with the Length property set to LEN,
%   and other specified properties set to the specified values.
%
%   Step method syntax:
%
%   [Y, ERR, WTS] = step(HLMS, X, D) filters the input X, using D as the
%   desired signal, and returns the filtered output in Y, the filter error
%   in ERR, and the estimated filter weights in WTS. The System object
%   estimates the filter weights needed to minimize the error between the
%   output signal and the desired signal.
%
%   [Y, ERR] = step(HLMS, X, D) filters the input X, using D as the desired
%   signal, and returns the filtered output in Y and the filter error in
%   ERR when the WeightsOutputPort property is false.
%
%   [...] = step(HLMS, X, D, MU) filters the input X, using D as the
%   desired signal and MU as the step size, when the StepSizeSource
%   property is 'Input port'.
%
%   [...] = step(HLMS, X, D, A) filters the input X, using D as the desired
%   signal and A as the adaptation control, when the AdaptInputPort
%   property is true. When A is non-zero, the System object continuously
%   updates the filter weights. When A is zero, the filter weights remain
%   constant.
%
%   [...] = step(HLMS, X, D, R) filters the input X, using D as the desired
%   signal and R as a reset signal when the WeightsResetInputPort property
%   is true. The WeightsResetCondition property can be used to set the
%   reset trigger condition. If a reset event occurs, the System object
%   resets the filter weights to their initial values.
%
%   The above operations can be used simultaneously, provided the System
%   object properties are set appropriately. One example of providing all
%   possible inputs and returning all possible outputs is shown below:
%   [Y, ERR, WTS] = step(HLMS, X, D, MU, A, R) filters input X using D
%   as the desired signal, MU as the step size, A as the adaptation
%   control, and R as the reset signal, and returns the filtered output in
%   Y, the filter error in ERR, and the adapted filter weights in WTS.
%
%   LMSFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create LMS filter object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset filter states
%
%   LMSFilter properties:
%
%   Method                - Method to calculate filter weights
%   Length                - Length of FIR filter weights vector
%   StepSizeSource        - How to specify adaptation step size
%   StepSize              - Adaptation step size
%   LeakageFactor         - Leakage factor used in Leaky LMS method
%   InitialConditions     - Initial conditions of filter weights
%   AdaptInputPort        - Enables weight adaptation
%   WeightsResetInputPort - Enables weight reset
%   WeightsResetCondition - Reset trigger setting for filter weights
%   WeightsOutputPort     - Enables returning filter weights
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.LMSFilter.helpFixedPoint.
%
%   % EXAMPLE #1: System identification of an FIR filter
%   % Initialize
%   N = 20; FrameSize = 100; NIter = 2000;
%   hlms1 = dsp.LMSFilter(N+1, 'StepSize', 0.01);
%   b = fir1(N,0.25); hfilt = dsp.FIRFilter('Numerator',b);
%   hAP = dsp.ArrayPlot('YLimits',[-0.1 .3],'ShowLegend',true,...
%       'Position',[0 0 560 420],'Title',...
%       'Actual Coefficients(Channel 1); Estimated (Channel 2)');
%   hTS =dsp.TimeScope('TimeSpan',FrameSize*NIter,'TimeUnits','Seconds',...
%       'YLimits',[-50 0],'Title','Learning curve','YLabel','dB',...
%       'BufferLength',FrameSize*NIter);
%   hmean = dsp.Mean('RunningMean',true);
%   % Stream
%   for k = 1:NIter
%       x = randn(FrameSize,1);                       % input signal
%       d = step(hfilt, x) + 0.01*randn(FrameSize,1); % desired signal
%       [y,e,w] = step(hlms1, x, d);
%       step(hAP,[b.',w]); % Actual = channel 1; Estimate = channel 2
%       step(hTS,10*log10(step(hmean,abs(e).^2)));
%   end
%
%   % EXAMPLE #2: Noise cancellation
%   % Initialize
%   FrameSize = 100; NIter = 10;
%   hlms = dsp.LMSFilter('Length', 11,'Method', 'Normalized LMS',...    
%       'StepSize', 0.05);
%   hfilt = dsp.FIRFilter('Numerator', fir1(10, [.5, .75]));
%   hsin  = dsp.SineWave('Frequency',0.01,...
%       'SampleRate',1,'SamplesPerFrame',FrameSize);
%   hTS =dsp.TimeScope('TimeSpan',FrameSize*NIter,'TimeUnits','Seconds',...
%       'YLimits',[-3 3],'BufferLength',2*FrameSize*NIter,...
%       'ShowLegend',true,'Title',...
%       'Noisy signal(Channel 1); Filtered signal (Channel 2)');
%   % Stream
%   for k = 1:NIter
%       x = randn(FrameSize,1);          % Input signal
%       d = step(hfilt, x) + step(hsin); % Noise + Signal
%       [y,e,w] = step(hlms, x, d);
%       step(hTS,[d,e]); % Noisy = channel 1; Filtered = channel 2    
%   end
%
%   See also dsp.BlockLMSFilter, dsp.DigitalFilter,
%            dsp.LMSFilter.helpFixedPoint.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=LMSFilter
            %LMSFilter Compute output, error, and weights using LMS adaptive algorithm
            %   HLMS = dsp.LMSFilter returns an adaptive FIR filter System object,
            %   HLMS, that computes the filtered output, filter error and the filter
            %   weights for a given input and desired signal using the Least Mean
            %   Squares (LMS) algorithm.
            %
            %   HLMS = dsp.LMSFilter('PropertyName', PropertyValue, ...) returns an LMS
            %   filter System object, HLMS, with each specified property set to the
            %   specified value.
            %
            %   HLMS = dsp.LMSFilter(LEN, 'PropertyName', PropertyValue, ...) returns
            %   an LMS filter System object, HLMS, with the Length property set to LEN,
            %   and other specified properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   [Y, ERR, WTS] = step(HLMS, X, D) filters the input X, using D as the
            %   desired signal, and returns the filtered output in Y, the filter error
            %   in ERR, and the estimated filter weights in WTS. The System object
            %   estimates the filter weights needed to minimize the error between the
            %   output signal and the desired signal.
            %
            %   [Y, ERR] = step(HLMS, X, D) filters the input X, using D as the desired
            %   signal, and returns the filtered output in Y and the filter error in
            %   ERR when the WeightsOutputPort property is false.
            %
            %   [...] = step(HLMS, X, D, MU) filters the input X, using D as the
            %   desired signal and MU as the step size, when the StepSizeSource
            %   property is 'Input port'.
            %
            %   [...] = step(HLMS, X, D, A) filters the input X, using D as the desired
            %   signal and A as the adaptation control, when the AdaptInputPort
            %   property is true. When A is non-zero, the System object continuously
            %   updates the filter weights. When A is zero, the filter weights remain
            %   constant.
            %
            %   [...] = step(HLMS, X, D, R) filters the input X, using D as the desired
            %   signal and R as a reset signal when the WeightsResetInputPort property
            %   is true. The WeightsResetCondition property can be used to set the
            %   reset trigger condition. If a reset event occurs, the System object
            %   resets the filter weights to their initial values.
            %
            %   The above operations can be used simultaneously, provided the System
            %   object properties are set appropriately. One example of providing all
            %   possible inputs and returning all possible outputs is shown below:
            %   [Y, ERR, WTS] = step(HLMS, X, D, MU, A, R) filters input X using D
            %   as the desired signal, MU as the step size, A as the adaptation
            %   control, and R as the reset signal, and returns the filtered output in
            %   Y, the filter error in ERR, and the adapted filter weights in WTS.
            %
            %   LMSFilter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create LMS filter object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset filter states
            %
            %   LMSFilter properties:
            %
            %   Method                - Method to calculate filter weights
            %   Length                - Length of FIR filter weights vector
            %   StepSizeSource        - How to specify adaptation step size
            %   StepSize              - Adaptation step size
            %   LeakageFactor         - Leakage factor used in Leaky LMS method
            %   InitialConditions     - Initial conditions of filter weights
            %   AdaptInputPort        - Enables weight adaptation
            %   WeightsResetInputPort - Enables weight reset
            %   WeightsResetCondition - Reset trigger setting for filter weights
            %   WeightsOutputPort     - Enables returning filter weights
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.LMSFilter.helpFixedPoint.
            %
            %   % EXAMPLE #1: System identification of an FIR filter
            %   % Initialize
            %   N = 20; FrameSize = 100; NIter = 2000;
            %   hlms1 = dsp.LMSFilter(N+1, 'StepSize', 0.01);
            %   b = fir1(N,0.25); hfilt = dsp.FIRFilter('Numerator',b);
            %   hAP = dsp.ArrayPlot('YLimits',[-0.1 .3],'ShowLegend',true,...
            %       'Position',[0 0 560 420],'Title',...
            %       'Actual Coefficients(Channel 1); Estimated (Channel 2)');
            %   hTS =dsp.TimeScope('TimeSpan',FrameSize*NIter,'TimeUnits','Seconds',...
            %       'YLimits',[-50 0],'Title','Learning curve','YLabel','dB',...
            %       'BufferLength',FrameSize*NIter);
            %   hmean = dsp.Mean('RunningMean',true);
            %   % Stream
            %   for k = 1:NIter
            %       x = randn(FrameSize,1);                       % input signal
            %       d = step(hfilt, x) + 0.01*randn(FrameSize,1); % desired signal
            %       [y,e,w] = step(hlms1, x, d);
            %       step(hAP,[b.',w]); % Actual = channel 1; Estimate = channel 2
            %       step(hTS,10*log10(step(hmean,abs(e).^2)));
            %   end
            %
            %   % EXAMPLE #2: Noise cancellation
            %   % Initialize
            %   FrameSize = 100; NIter = 10;
            %   hlms = dsp.LMSFilter('Length', 11,'Method', 'Normalized LMS',...    
            %       'StepSize', 0.05);
            %   hfilt = dsp.FIRFilter('Numerator', fir1(10, [.5, .75]));
            %   hsin  = dsp.SineWave('Frequency',0.01,...
            %       'SampleRate',1,'SamplesPerFrame',FrameSize);
            %   hTS =dsp.TimeScope('TimeSpan',FrameSize*NIter,'TimeUnits','Seconds',...
            %       'YLimits',[-3 3],'BufferLength',2*FrameSize*NIter,...
            %       'ShowLegend',true,'Title',...
            %       'Noisy signal(Channel 1); Filtered signal (Channel 2)');
            %   % Stream
            %   for k = 1:NIter
            %       x = randn(FrameSize,1);          % Input signal
            %       d = step(hfilt, x) + step(hsin); % Noise + Signal
            %       [y,e,w] = step(hlms, x, d);
            %       step(hTS,[d,e]); % Noisy = channel 1; Filtered = channel 2    
            %   end
            %
            %   See also dsp.BlockLMSFilter, dsp.DigitalFilter,
            %            dsp.LMSFilter.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.LMSFilter System object
            %               fixed-point information
            %   dsp.LMSFilter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.LMSFilter
            %   System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
            % connection depends on float-vs-fixed
        end

    end
    methods (Abstract)
    end
    properties
        %AdaptInputPort Enables weight adaptation
        %   Specify when the System object should adapt the filter weights. By
        %   default, the value of this property is false, and the object
        %   continuously updates the filter weights. When this property is set to
        %   true, an adaptation control input is provided to the step method. If
        %   the value of this input is non-zero, the object continuously updates
        %   the filter weights. If the input is zero, the filter weights remain
        %   at their current value.
        AdaptInputPort;

        %ConvolutionAccumulatorDataType Convolution accumulator word- and fraction-length designations
        %   Specify the convolution accumulator fixed-point data
        %   type as one of [{'Same as first input'} | 'Custom'].
        ConvolutionAccumulatorDataType;

        %ConvolutionProductDataType Convolution product word- and fraction-length designations
        %   Specify the convolution product fixed-point data type as
        %   one of [{'Same as first input'} | 'Custom'].
        ConvolutionProductDataType;

        %CustomConvolutionAccumulatorDataType Convolution accumulator word and fraction lengths
        %   Specify the convolution accumulator fixed-point type as an auto-signed
        %   scaled numerictype object. This property is applicable when the
        %   ConvolutionAccumulatorDataType property is 'Custom'. The default
        %   value of this property is numerictype([],32,20).
        %
        %   See also numerictype.
        CustomConvolutionAccumulatorDataType;

        %CustomConvolutionProductDataType Convolution product word and fraction lengths
        %   Specify the convolution product fixed-point type as an auto-signed
        %   scaled numerictype object. This property is applicable when the
        %   ConvolutionProductDataType property is 'Custom'. The default value of
        %   this property is numerictype([],32,20).
        %
        %   See also numerictype.
        CustomConvolutionProductDataType;

        %CustomEnergyAccumulatorDataType Energy accumulator word and fraction lengths
        %   Specify the energy accumulator fixed-point type as an auto-signed
        %   scaled numerictype object. This property is applicable when the
        %   Method property is 'Normalized LMS' and the EnergyAccumulatorDataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype([],32,20).
        %
        %   See also numerictype.
        CustomEnergyAccumulatorDataType;

        %CustomEnergyProductDataType Energy product word and fraction lengths
        %   Specify the energy product fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Normalized LMS' and the EnergyProductDataType property
        %   is 'Custom'. The default value of this property is
        %   numerictype([],32,20).
        %
        %   See also numerictype.
        CustomEnergyProductDataType;

        %CustomLeakageFactorDataType Leakage factor word and fraction lengths
        %   Specify the leakage factor fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   LeakageFactorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomLeakageFactorDataType;

        %CustomQuotientDataType Quotient word and fraction lengths
        %   Specify the quotient fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Normalized LMS' and the QuotientDataType property is
        %   'Custom'. The default value of this property is
        %   numerictype([],32,20).
        %
        %   See also numerictype.
        CustomQuotientDataType;

        %CustomStepSizeDataType Step size word and fraction lengths
        %   Specify the step size fixed-point type as an auto-signed numerictype
        %   object. This property is applicable when the StepSizeSource property
        %   is 'Property' and the StepSizeDataType property is 'Custom'. The
        %   default value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomStepSizeDataType;

        %CustomStepSizeErrorProductDataType Step size error product word and fraction lengths
        %   Specify the step size error product fixed-point type as an auto-signed
        %   scaled numerictype object. This property is applicable when the
        %   StepSizeErrorProductDataType property is 'Custom'. The default value
        %   of this property is numerictype([],32,20).
        %
        %   See also numerictype.
        CustomStepSizeErrorProductDataType;

        %CustomWeightsDataType Weights word and fraction lengths
        %   Specify the filter weights fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   WeightsDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomWeightsDataType;

        %CustomWeightsUpdateProductDataType Weight update product word and fraction lengths
        %   Specify the weight update product fixed-point type as an auto-signed
        %   scaled numerictype object. This property is applicable when the
        %   WeightsUpdateProductDataType property is 'Custom'. The default value
        %   of this property is numerictype([],32,20).
        %
        %   See also numerictype.
        CustomWeightsUpdateProductDataType;

        %EnergyAccumulatorDataType Energy accumulator word- and fraction-length designations
        %   Specify the energy accumulator fixed-point data type as one of
        %   [{'Same as first input'} | 'Custom']. This property is applicable
        %   when the Method property is 'Normalized LMS'.
        EnergyAccumulatorDataType;

        %EnergyProductDataType Energy product word- and fraction-length designations
        %   Specify the energy product fixed-point data type as one of [{'Same as
        %   first input'} | 'Custom']. This property is applicable when the
        %   Method property is 'Normalized LMS'.
        EnergyProductDataType;

        %InitialConditions Initial conditions of filter weights
        %   Specify the initial values of the FIR filter weights as a scalar or
        %   vector of length equal to the Length property value. The default
        %   value of this property is 0.
        InitialConditions;

        %LeakageFactor Leakage factor used in Leaky LMS method
        %   Specify the leakage factor used in Leaky LMS method as a scalar
        %   numeric value between 0 and 1, both inclusive. When the value is less
        %   than 1, the System object implements a leaky LMS method. The default
        %   value of this property is 1, providing no leakage in the adapting
        %   method. This property is tunable.
        LeakageFactor;

        %LeakageFactorDataType Leakage factor word- and fraction-length designations
        %   Specify the leakage factor fixed-point data type as one of [{'Same
        %   word length as first input'} | 'Custom'].
        LeakageFactorDataType;

        %Length Length of FIR filter weights vector
        %   Specify the length of the FIR filter weights vector as a scalar
        %   positive integer value. The default value of this property is 32.
        Length;

        %Method Method to calculate filter weights
        %   Specify the method used to calculate filter weights as one of
        %   [{'LMS'} | 'Normalized LMS' | 'Sign-Error LMS' | 'Sign-Data LMS' |
        %   'Sign-Sign LMS'].
        Method;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %QuotientDataType Quotient word- and fraction-length designations
        %   Specify the quotient fixed-point data type as one of [{'Same as first
        %   input'} | 'Custom']. This property is applicable when the Method
        %   property is 'Normalized LMS'.
        QuotientDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %StepSize Adaptation step size
        %   Specify the adaptation step size factor as a scalar non-negative
        %   numeric value. For convergence of the normalized LMS method, the step
        %   size should be greater than 0 and less than 2. The default value of
        %   this property is 0.1. This property is applicable when the
        %   StepSizeSource property is 'Property'. This property is tunable.
        StepSize;

        %StepSizeDataType Step size word- and fraction-length designations
        %   Specify the step size fixed-point data type as one of [{'Same word
        %   length as first input'} | 'Custom']. This property is applicable when
        %   the StepSizeSource property is 'Property'.
        StepSizeDataType;

        %StepSizeErrorProductDataType Step size error product word- and fraction-length designations
        %   Specify the step size error product fixed-point data type as one of
        %   [{'Same as first input'} | 'Custom'].
        StepSizeErrorProductDataType;

        %StepSizeSource How to specify adaptation step size
        %   Choose how to specify the adaptation step size factor as one of
        %   [{'Property'} | 'Input port'].
        StepSizeSource;

        %WeightsDataType Weights word- and fraction-length designations
        %   Specify the filter weights fixed-point data type as one of [{'Same as
        %   first input'} | 'Custom'].
        WeightsDataType;

        %WeightsOutputPort Enables returning filter weights
        %   Set this property to true to output the adapted filter weights. The
        %   default value of this property is true.
        WeightsOutputPort;

        %WeightsResetCondition Reset trigger setting for filter weights
        %   Specify the event to reset the filter weights as one of [ 'Rising
        %   edge' | 'Falling edge' | 'Either edge' | {'Non-zero'} ]. The System
        %   object resets the filter weights based on the values of this property
        %   and the reset input to the step method. This property is applicable
        %   when the WeightsResetInputPort property is true.
        WeightsResetCondition;

        %WeightsResetInputPort Enables weight reset 
        %   Specify when the System object should reset the filter weights. By
        %   default, the value of this property is false, and the object does not
        %   reset the weights. When this property is set to true, a reset control
        %   input is provided to the step method, and the WeightsResetCondition
        %   property becomes applicable. The object resets the filter weights
        %   based on the values of the WeightsResetCondition property and the
        %   reset input to the step method.
        WeightsResetInputPort;

        %WeightsUpdateProductDataType Weight update product word- and fraction-length designations
        %   Specify the weight update product fixed-point data type as one of 
        %   [{'Same as first input'} | 'Custom'].
        WeightsUpdateProductDataType;

    end
end
