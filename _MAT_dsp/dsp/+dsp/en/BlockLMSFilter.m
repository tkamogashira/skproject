classdef BlockLMSFilter< handle
%BlockLMSFilter Compute output, error, and weights using Block LMS adaptive 
%algorithm
%   HBLMS = dsp.BlockLMSFilter returns an adaptive FIR filter System
%   object, HBLMS, that filters the input signal and computes filter
%   weights based on the Block Least Mean Squares (LMS) algorithm.
%
%   HBLMS = dsp.BlockLMSFilter('PropertyName', PropertyValue, ...) returns
%   a Block LMS filter System object, HBLMS, with each specified property
%   set to the specified value.
%
%   HBLMS = dsp.BlockLMSFilter(LEN, BLOCKSIZE, 'PropertyName',
%   PropertyValue, ...) returns a Block LMS filter System object, HBLMS,
%   with the Length property set to LEN, the BlockSize property set to
%   BLOCKSIZE, and other specified properties set to the specified values.
%
%   Step method syntax:
%
%   [Y, ERR, WTS] = step(HBLMS, X, D) filters the input X, using D as the
%   desired signal, and returns the filtered output in Y, the filter error
%   in ERR, and the estimated filter weights in WTS. The filter weights are
%   updated once for every block of data that is processed.
%
%   [Y, ERR] = step(HBLMS, X, D) filters the input X, using D as the
%   desired signal, and returns the filtered output in Y, and the filter
%   error in ERR when the WeightsOutputPort property is false.
%
%   [...] = step(HBLMS, X, D, MU) filters the input X, using D as the
%   desired signal and MU as the step size when the StepSizeSource property
%   is 'Input port'.
%
%   [...] = step(HBLMS, X, D, A) filters the input X, using D as the
%   desired signal and A as the adaptation control when the AdaptInputPort
%   property is true. When A is non-zero, the System object continuously
%   updates the filter weights. When A is zero, the filter weights remain
%   constant.
%
%   [...] = step(HBLMS, X, D, R) filters the input X, using D as the
%   desired signal, and R as a reset signal, when the WeightsResetInputPort
%   property is true. The WeightsResetCondition property can be used to set
%   the reset trigger condition. If a reset event occurs, the System object
%   resets the filter weights to their initial values.
%
%   The above operations can be used simultaneously, provided the System
%   object properties are set appropriately. One example of providing all
%   possible inputs and returning all possible outputs is shown below: 
%   [Y, ERR, WTS] = step(HBLMS, X, D, MU, A, R) filters input X using D as
%   the desired signal, MU as the step size, A as the adaptation control,
%   and R as the reset signal, and returns the filtered output in Y, the
%   filter error in ERR, and the adapted filter weights in WTS.
%
%   BlockLMSFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create Block LMS filter object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset filter states
%
%   BlockLMSFilter properties:
%
%   Length                - Length of FIR filter weights vector
%   BlockSize             - Number of samples acquired before weights
%                           adaptation
%   StepSizeSource        - Source of adaptation step size
%   StepSize              - Adaptation step size
%   LeakageFactor         - Leakage factor used in Leaky LMS algorithm
%   InitialWeights        - Initial values of filter weights
%   AdaptInputPort        - Enables weight adaptation via step method input
%   WeightsResetInputPort - Enables weight reset via step method input
%   WeightsResetCondition - Reset trigger setting for filter weights
%   WeightsOutputPort     - Enables returning filter weights
%
%   % EXAMPLE: Noise cancellation using BlockLMSFilter System object.
%      hblms = dsp.BlockLMSFilter(10, 5);
%      hblms.StepSize = 0.01;
%      hblms.WeightsOutputPort = false;
%      hfilt = dsp.DigitalFilter;
%      hfilt.TransferFunction = 'FIR (all zeros)';
%      hfilt.Numerator = fir1(10, [.5, .75]);
%      x = randn(1000,1);                      % Noise
%      d = step(hfilt, x) + sin(0:.05:49.95)';  % Noise + Signal
%      [y, err] = step(hblms, x, d);
%      subplot(2,1,1), plot(d), title('Noise + Signal');
%      subplot(2,1,2), plot(err), title('Signal');
%
%   See also dsp.LMSFilter, dsp.DigitalFilter.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=BlockLMSFilter
            %BlockLMSFilter Compute output, error, and weights using Block LMS adaptive 
            %algorithm
            %   HBLMS = dsp.BlockLMSFilter returns an adaptive FIR filter System
            %   object, HBLMS, that filters the input signal and computes filter
            %   weights based on the Block Least Mean Squares (LMS) algorithm.
            %
            %   HBLMS = dsp.BlockLMSFilter('PropertyName', PropertyValue, ...) returns
            %   a Block LMS filter System object, HBLMS, with each specified property
            %   set to the specified value.
            %
            %   HBLMS = dsp.BlockLMSFilter(LEN, BLOCKSIZE, 'PropertyName',
            %   PropertyValue, ...) returns a Block LMS filter System object, HBLMS,
            %   with the Length property set to LEN, the BlockSize property set to
            %   BLOCKSIZE, and other specified properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   [Y, ERR, WTS] = step(HBLMS, X, D) filters the input X, using D as the
            %   desired signal, and returns the filtered output in Y, the filter error
            %   in ERR, and the estimated filter weights in WTS. The filter weights are
            %   updated once for every block of data that is processed.
            %
            %   [Y, ERR] = step(HBLMS, X, D) filters the input X, using D as the
            %   desired signal, and returns the filtered output in Y, and the filter
            %   error in ERR when the WeightsOutputPort property is false.
            %
            %   [...] = step(HBLMS, X, D, MU) filters the input X, using D as the
            %   desired signal and MU as the step size when the StepSizeSource property
            %   is 'Input port'.
            %
            %   [...] = step(HBLMS, X, D, A) filters the input X, using D as the
            %   desired signal and A as the adaptation control when the AdaptInputPort
            %   property is true. When A is non-zero, the System object continuously
            %   updates the filter weights. When A is zero, the filter weights remain
            %   constant.
            %
            %   [...] = step(HBLMS, X, D, R) filters the input X, using D as the
            %   desired signal, and R as a reset signal, when the WeightsResetInputPort
            %   property is true. The WeightsResetCondition property can be used to set
            %   the reset trigger condition. If a reset event occurs, the System object
            %   resets the filter weights to their initial values.
            %
            %   The above operations can be used simultaneously, provided the System
            %   object properties are set appropriately. One example of providing all
            %   possible inputs and returning all possible outputs is shown below: 
            %   [Y, ERR, WTS] = step(HBLMS, X, D, MU, A, R) filters input X using D as
            %   the desired signal, MU as the step size, A as the adaptation control,
            %   and R as the reset signal, and returns the filtered output in Y, the
            %   filter error in ERR, and the adapted filter weights in WTS.
            %
            %   BlockLMSFilter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create Block LMS filter object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset filter states
            %
            %   BlockLMSFilter properties:
            %
            %   Length                - Length of FIR filter weights vector
            %   BlockSize             - Number of samples acquired before weights
            %                           adaptation
            %   StepSizeSource        - Source of adaptation step size
            %   StepSize              - Adaptation step size
            %   LeakageFactor         - Leakage factor used in Leaky LMS algorithm
            %   InitialWeights        - Initial values of filter weights
            %   AdaptInputPort        - Enables weight adaptation via step method input
            %   WeightsResetInputPort - Enables weight reset via step method input
            %   WeightsResetCondition - Reset trigger setting for filter weights
            %   WeightsOutputPort     - Enables returning filter weights
            %
            %   % EXAMPLE: Noise cancellation using BlockLMSFilter System object.
            %      hblms = dsp.BlockLMSFilter(10, 5);
            %      hblms.StepSize = 0.01;
            %      hblms.WeightsOutputPort = false;
            %      hfilt = dsp.DigitalFilter;
            %      hfilt.TransferFunction = 'FIR (all zeros)';
            %      hfilt.Numerator = fir1(10, [.5, .75]);
            %      x = randn(1000,1);                      % Noise
            %      d = step(hfilt, x) + sin(0:.05:49.95)';  % Noise + Signal
            %      [y, err] = step(hblms, x, d);
            %      subplot(2,1,1), plot(d), title('Noise + Signal');
            %      subplot(2,1,2), plot(err), title('Signal');
            %
            %   See also dsp.LMSFilter, dsp.DigitalFilter.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AdaptInputPort Enables weight adaptation via step method input
        %   Specify when the System object should adapt the filter weights. By
        %   default, the value of this property is false, and the System object
        %   continuously updates the filter weights. When this property is set
        %   to true, an adaptation control input is provided to the step
        %   method. If the value of this input is non-zero, the System object
        %   continuously updates the filter weights. If the input is zero, the
        %   filter weights remain at their current value.
        AdaptInputPort;

        %BlockSize Number of samples acquired before weight adaptation
        %   Specify the number of samples of the input signal to acquire before
        %   the filter weights are updated. The input frame length must be an
        %   integer multiple of the block size. The default value of this
        %   property is 32.
        BlockSize;

        %InitialWeights Initial values of filter weights
        %   Specify the initial values of the FIR filter weights as a scalar or
        %   a vector of length equal to the Length property value. The default
        %   value of this property is 0.
        InitialWeights;

        %LeakageFactor Leakage factor used in Leaky LMS algorithm
        %   Specify the leakage factor used in Leaky LMS algorithm as a scalar
        %   numeric value between 0 and 1, both inclusive. When the value is
        %   less than 1, the System object implements a leaky LMS algorithm.
        %   The default value of this property is 1, providing no leakage in
        %   the adapting algorithm. This property is tunable.
        LeakageFactor;

        %Length Length of FIR filter weights vector
        %   Specify the length of the FIR filter weights vector as a positive
        %   integer scalar. The default value of this property is 32.
        Length;

        %StepSize Adaptation step size
        %   Specify the adaptation step size factor as a scalar, non-negative
        %   numeric value. The default value of this property is 0.1. This
        %   property is applicable when the StepSizeSource property is
        %   'Property'. This property is tunable.
        StepSize;

        %StepSizeSource Source of adaptation step size
        %   Choose how to specify the adaptation step size factor as one of
        %   [{'Property'} | 'Input port'].
        StepSizeSource;

        %WeightsOutputPort Enables returning filter weights
        %   Set this property to true to output the adapted filter weights. The
        %   default value of this property is true.
        WeightsOutputPort;

        %WeightsResetCondition Reset trigger setting for filter weights
        %   Specify the event to reset the filter weights as one of [ 'Rising
        %   edge' | 'Falling edge' | 'Either edge' | {'Non-zero'} ]. The System
        %   object resets the filter weights based on the values of this
        %   property and the reset input to the step method. This property is
        %   applicable when the WeightsResetInputPort property is true.
        WeightsResetCondition;

        %WeightsResetInputPort Enables weight reset via step method input
        %   Specify whether the System object can reset the filter weights. By
        %   default, the value of this property is false, and the object does
        %   not reset the weights. When this property is set to true, a reset
        %   control input is provided to the step method. Also, the
        %   WeightsResetCondition property becomes applicable. The object
        %   resets the filter weights based on the values of the
        %   WeightsResetCondition property and the reset input to the step
        %   method.
        WeightsResetInputPort;

    end
end
