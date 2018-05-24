classdef FastTransversalFilter< handle
%FastTransversalFilter Computes output, error and coefficients using
%                      fast transversal least-squares FIR adaptive filter.
%
%   H = dsp.FastTransversalFilter returns a fast transversal least-squares
%   FIR adaptive filter System object(TM), H. This System object is used to
%   compute the filtered output and the filter error for a given input and
%   desired signal.
%
%   H = dsp.FastTransversalFilter('PropertyName', PropertyValue, ...)
%   returns a FastTransversalFilter System object, H, with each specified
%   property set to the specified value.
%
%   H = dsp.FastTransversalFilter(LEN, 'PropertyName', PropertyValue, ...)
%   returns a FastTransversalFilter System object, H, with the Length
%   property set to LEN, and other specified properties set to the
%   specified values.
%
%   Step method syntax:
%
%   [Y, ERR] = step(H, X, D) filters the input X, using D as the desired
%   signal, and returns the filtered output in Y and the filter error in
%   ERR. The System object estimates the filter weights needed to minimize
%   the error between the output signal and the desired signal. These
%   filter weights can be obtained by accessing the Coefficients property
%   after calling the step method by H.Coefficients
%
%   FastTransversalFilter methods:
%
%   step                - See above description for use of this method.
%   release             - Allow changes in non-tunable property values and
%                         input characteristics.
%   clone               - Create a FastTransversalFilter object with the
%                         same property values and internal states.
%   isLocked            - Locked status of the filter object (logical).
%   reset               - Reset the internal states to their initial
%                         conditions.
%
%   FastTransversalFilter properties:
%
%   Method                      - Method to calculate the filter
%                                 coefficients
%   Length                      - Length of filter coefficients vector
%   SlidingWindowBlockLength    - Width of the sliding window
%   ForgettingFactor            - Fast transversal filter forgetting factor
%   InitialPredictionErrorPower - Initial prediction error power
%   InitialConversionFactor     - Initial conversion factor (gamma)
%   InitialCoefficients         - Initial coefficients of the filter
%   LockCoefficients            - Locked status of the coefficient updates
%
%
%   % EXAMPLE #1: System identification of an FIR filter
%      hftf1 = dsp.FastTransversalFilter(11, 'ForgettingFactor', 0.99);
%      hfilt = dsp.DigitalFilter;               % System to be identified
%      hfilt.TransferFunction = 'FIR (all zeros)';
%      hfilt.Numerator = fir1(10, .25);
%      x = randn(1000,1);                       % input signal
%      d = step(hfilt, x) + 0.01*randn(1000,1); % desired signal
%      [y,e] = step(hftf1, x, d);
%      w = hftf1.Coefficients;
%      subplot(2,1,1), plot(1:1000, [d,y,e]);
%      title('System Identification of an FIR filter');
%      legend('Desired', 'Output', 'Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,1,2); stem([hfilt.Numerator; w].');
%      legend('Actual','Estimated'); 
%      xlabel('coefficient #'); ylabel('coefficient value');
%
%   See also dsp.LMSFilter, dsp.RLSFilter, dsp.AffineProjectionFilter,
%            dsp.AdaptiveLatticeFilter, dsp.FrequencyDomainAdaptiveFilter,
%            dsp.FilteredXLMSFilter, dsp.FIRFilter.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=FastTransversalFilter
            % Supports name-value pair arguments as well as alternatively
            % allows the Length property to be a value-only argument.
        end

        function backwardPredictionUpdate(in) %#ok<MANU>
        end

        function forwardPredictionUpdate(in) %#ok<MANU>
        end

        function getDiscreteStateImpl(in) %#ok<MANU>
        end

        function getFilterParameterStruct(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
            % Specify number of System inputs
        end

        function getNumOutputsImpl(in) %#ok<MANU>
            % Specify number of System outputs
        end

        function initializeVariables(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadFTFDiscreteStates(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
            % Whenever the tunable properties are changed, update the
            % FilterParameters private property that stores their type
            % casted version in a structure.
        end

        function resetImpl(in) %#ok<MANU>
            % Local copy of the required properties
        end

        function saveFTFDiscreteStates(in) %#ok<MANU>
            % Save final conversion factor
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Set InputDataType to be the data type of x and initialize the
            % FilterParameters property based on that. The FilterParameters
            % property is a structure with all the filter parameters casted
            % to the data type of the inputs.
        end

        function stepFTF(in) %#ok<MANU>
            % Load the required DiscreteState properties
        end

        function stepImpl(in) %#ok<MANU>
        end

        function stepSWFTF(in) %#ok<MANU>
            % Load the required DiscreteState properties
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Validating the size of the inputs x and d. Inputs must be
            % vectors.
        end

        function validatePropertiesImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %BackwardPredictionCoefficients Backward prediction coefficients
        %   This property stores the current backward prediction
        %   coefficients as a row vector. Its length is equal to the Length
        %   property value. This property is initialized to a vector of
        %   zeros of appropriate length and data type.
        BackwardPredictionCoefficients;

        %BackwardPredictionErrorPower Backward prediction error power
        %   This property stores the current backward prediction
        %   least-squares error power as a scalar value. This property is
        %   initialized to the InitialPredictionErrorPower property value.
        BackwardPredictionErrorPower;

        %Coefficients Current coefficients of the filter
        %   This property stores the current coefficients of the filter as
        %   a row vector of length equal to the Length property value. This
        %   property is initialized to the values of InitialCoefficients
        %   property.
        Coefficients;

        %ConversionFactor Current conversion factor (gamma) value
        %   This property stores the value of the current conversion factor
        %   value corresponding to the fast transversal filter. If the
        %   Method property is set to 'Fast transversal least-squares',
        %   this property is a numeric scalar. If the Method property is
        %   set to 'Sliding-window fast transversal least-squares', this
        %   property is a numeric two-element row vector. This property is
        %   initialized to the values of the InitialConversionFactor
        %   property.
        ConversionFactor;

        %DesiredStates Current desired states of the filter
        %   This property stores the current desired signal states of the
        %   adaptive filter as a column vector. Its length is equal to the
        %   SlidingWindowBlockLength property value. This property is
        %   applicable only if the Method property is set to
        %   'Sliding-window fast transversal least-squares'. This property
        %   is initialized to a vector of zeros of appropriate length.
        DesiredStates;

        %FilterParameters Private structure to store the filter parameters
        %   This is a private MATLAB structure that stores all the filter
        %   parameters casted to the data type of the inputs. For
        %   FastTransversalFilter System object, the ForgettingFactor
        %   property, the InitialPredictionErrorPower property and the
        %   LockCoefficients property are the filter parameters. The
        %   FilterParameters property is initialized in the setup method.
        FilterParameters;

        %ForgettingFactor Fast transversal filter forgetting factor
        %   Specify the fast transversal filter forgetting factor as a
        %   positive numeric value. Setting this property value to 1
        %   denotes infinite memory while adapting to find the new filter.
        %   It is recommended that the value set to this property should
        %   lie in the range (1-0.5/L, 1], where L is the Length property
        %   value. This property is applicable only if the Method property
        %   is set to 'Fast transversal least-squares'. The default value 
        %   of this property is 1.
        ForgettingFactor;

        %ForwardPredictionCoefficients Forward prediction coefficients
        %   This property stores the current forward prediction
        %   coefficients as a row vector. Its length is equal to the Length
        %   property value. This property is initialized to a vector of
        %   zeros of appropriate length and data type.
        ForwardPredictionCoefficients;

        %ForwardPredictionErrorPower Forward prediction error power
        %   This property stores the current forward prediction
        %   least-squares error power as a scalar value. If the Method
        %   property is set to 'Fast transversal least-squares', This
        %   property is initialized to the value of ((ForgettingFactor ^
        %   Length) * InitialPredictionErrorPower). If the Method property
        %   is set to 'Sliding-window fast transversal least-squares', this
        %   property is initialized to the InitialPredictionErrorPower
        %   property value.
        ForwardPredictionErrorPower;

        %InitialCoefficients Initial coefficients of the filter
        %   Specify the initial value of the FIR adaptive filter
        %   coefficients as a scalar or a vector of length equal to the
        %   Length property value. The default value of this property is 0.
        InitialCoefficients;

        %InitialConversionFactor Initial conversion factor (gamma)
        %   Specify the initial value of the conversion factor of the fast
        %   transversal filter.
        %
        %   If the Method property is set to 'Fast transversal
        %   least-squares', this property must be a positive numeric value
        %   less than or equal to 1. In this case, the default value of
        %   this property is 1.
        %
        %   If the Method property is set to 'Sliding-window fast
        %   transversal least-squares', this property must be a two-element
        %   numeric vector. The first element of this vector must lie
        %   within the range (0,1] and the second element must be less than
        %   or equal to -1. In this case, the default value of this
        %   property is [1, -1].
        InitialConversionFactor;

        %InitialPredictionErrorPower Initial prediction error power
        %   Specify the initial value of the forward and backward
        %   prediction error vectors as a positive numeric scalar. This
        %   scalar should be sufficiently large to maintain stability and
        %   prevent an excessive number of Kalman gain rescues. The default
        %   value of this property is 10.
        InitialPredictionErrorPower;

        %InputDataType Data type of the input
        %   This is a private property that stores the data type of the
        %   input. It is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;

        %KalmanGain Current Kalman gain vector
        %   This property stores the current Kalman gain vector. If the
        %   Method property is set to 'Fast transversal least-squares',
        %   this property is a column vector of length equal to the Length
        %   property value. If the Method property is set to
        %   'Sliding-window fast transversal least-squares', this property
        %   is a matrix with the number of rows equal to the Length
        %   property value and the number of columns equal to 2. This
        %   property is initialized to a zero matrix of appropriate
        %   dimension.
        KalmanGain;

        %KalmanGainStates Current Kalman gain states
        %   This property stores the current Kalman gain states of the
        %   filter as a column vector. If the Method property is set to
        %   'Fast transversal least-squares', the length of this vector is
        %   equal to the Length property value. If the Method property is
        %   set to 'Sliding-window fast transversal least-squares', the
        %   length of this vector is equal to the sum of the Length
        %   property value and the SlidingWindowBlockLength property value.
        %   This property is initialized to a zero matrix of appropriate
        %   dimension.
        KalmanGainStates;

        %Length Length of the filter coefficients vector
        %   Specify the length of the FIR filter coefficients vector as a
        %   positive integer value. The default value of this property is
        %   32.
        Length;

        %LockCoefficients Locked status of the coefficient updates
        %   Specify whether the filter coefficient values should be locked.
        %   By default, the value of this property is false, and the object
        %   continuously updates the filter coefficients. If this property
        %   is set to true, the filter coefficients do not get updated and
        %   their values remain at the current value.
        LockCoefficients;

        %Method Method to calculate the filter coefficients
        %   Specify the method used to calculate filter coefficients as one
        %   of [{'Fast transversal least-squares'} | 'Sliding-window fast
        %   transversal least-squares'].
        Method;

        %SlidingWindowBlockLength Width of the sliding window
        %   Specify the width of the sliding window as a positive integer
        %   value greater than or equal to the Length property value. This
        %   property is applicable only if the Method property is set to
        %   'Sliding-window fast transversal least-squares'. The default
        %   value of this property is set to the Length property value.
        SlidingWindowBlockLength;

        %States Current internal states of the filter
        %   This property stores the current internal states of the filter
        %   as a column vector. If the Method property is set to 'Fast
        %   transversal least-squares', the length of this vector is equal
        %   to the Length property value.  If the Method property is set to
        %   'Sliding-window fast transversal least-squares', the length of
        %   this vector is equal to the sum of the Length property value
        %   and the SlidingWindowBlockLength property value. This property
        %   is initialized to a vector of zeros of appropriate length and
        %   data type.
        States;

        %privInitialConversionFactorFTF A private property to store
        %   the default value of the InitialConversionFactor property
        %   if the Method property is set to 'Fast transversal
        %   least-squares'. If the InitialConversionFactor property is
        %   explicity set, this property must be updated.
        privInitialConversionFactorFTF;

        %privInitialConversionFactorSWFTF A private property to store
        %   the default value of the InitialConversionFactor property if
        %   the Method property is set to 'Sliding-window fast transversal
        %   least-squares'. If the InitialConversionFactor property is
        %   explicity set, this property must be updated.
        privInitialConversionFactorSWFTF;

        %privSlidingWindowBlockLength A private property to store
        %   the value explicity set to the SlidingWindowBlockLength
        %   property. This private property is used only if the Method
        %   property is set to 'Sliding-window Fast transversal
        %   least-squares'.
        privSlidingWindowBlockLength;

        %privSlidingWindowBlockLengthDefined A Private logical property to
        % denote whether the SlidingWindowBlockLength property has been
        % explicitly set.
        privSlidingWindowBlockLengthDefined;

    end
end
