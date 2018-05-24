classdef AdaptiveLatticeFilter< handle
%AdaptiveLatticeFilter Computes output, error and coefficients using
%                      Lattice based FIR adaptive filter.
%
%   H = dsp.AdaptiveLatticeFilter returns a Lattice based FIR adaptive
%   filter System object(TM), H. This System object is used to compute the
%   filtered output and the filter error for a given input and desired
%   signal.
%
%   H = dsp.AdaptiveLatticeFilter('PropertyName', PropertyValue, ...)
%   returns an AdaptiveLatticeFilter System object, H, with each specified
%   property set to the specified value.
%
%   H = dsp.AdaptiveLatticeFilter(LEN, 'PropertyName', PropertyValue, ...)
%   returns an AdaptiveLatticeFilter System object, H, with the Length
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
%   after calling the step method by H.Coefficients.
%
%   AdaptiveLatticeFilter methods:
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
%   AdaptiveLatticeFilter properties:
%
%   Method                  - Method to calculate the filter coefficients
%   Length                  - Length of the filter coefficients vector 
%   ForgettingFactor        - Least-squares lattice forgetting factor
%   StepSize                - Joint process step size of the gradient
%                             adaptive filter
%   Offset                  - Offset for the denominator of StepSize
%                             normalization term
%   ReflectionStepSize      - Reflection process step size of the gradient
%                             adaptive filter
%   AveragingFactor         - Averaging factor of the energy estimator
%   InitialPredictionErrorPower - Initial prediction error power
%   InitialCoefficients     - Initial coefficients of the filter
%   LockCoefficients        - Locked status of the coefficient updates
%
%
%   % EXAMPLE #1: QPSK adaptive equalization using a 32-coefficient FIR 
%   %  filter (1000 iterations).
%
%      D = 16;                      % Number of samples of delay
%      b = exp(1i*pi/4)*[-0.7 1];   % Numerator coefficients of channel
%      a = [1 -0.7];                % Denominator coefficients of channel
%      ntr = 1000;                  % Number of iterations
%      s = sign(randn(1,ntr+D)) + 1i*sign(randn(1,ntr+D));  % QPSK signal
%      n = 0.1*(randn(1,ntr+D) + 1i*randn(1,ntr+D));        % Noise signal
%      r = filter(b,a,s) + n;       % Received signal
%      x = r(1+D:ntr+D);            % Input signal (received signal)
%      d = s(1:ntr);                % Desired signal (delayed QPSK signal)
%      lam = 0.995;                 % Forgetting factor
%      del = 1;                     % Initial Prediction Error Power
%      h = dsp.AdaptiveLatticeFilter('Length', 32, ...
%          'ForgettingFactor', lam, 'InitialPredictionErrorPower', del);
%      [y,e] = step(h,x,d);
%      subplot(2,2,1); plot(1:ntr,real([d;y;e]));
%      title('In-Phase Components');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,2,2); plot(1:ntr,imag([d;y;e]));
%      title('Quadrature Components');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,2,3); plot(x(ntr-100:ntr),'.'); axis([-3 3 -3 3]);
%      title('Received Signal Scatter Plot'); axis('square'); 
%      xlabel('Real[x]'); ylabel('Imag[x]'); grid on;
%      subplot(2,2,4); plot(y(ntr-100:ntr),'.'); axis([-3 3 -3 3]);
%      title('Equalized Signal Scatter Plot'); axis('square');
%      xlabel('Real[y]'); ylabel('Imag[y]'); grid on;
%
%   See also dsp.LMSFilter, dsp.RLSFilter, dsp.AffineProjectionFilter,
%            dsp.FrequencyDomainAdaptiveFilter, dsp.FilteredXLMSFilter,
%            dsp.FIRFilter, dsp.FastTransversalFilter.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=AdaptiveLatticeFilter
            % Support name-value pair arguments as well as alternatively
            % allow the Length property to be a value-only argument.
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

        function getPropertyGroupsImpl(in) %#ok<MANU>
            % Get default parameters group for this System object
        end

        function initializeVariables(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadCommonDiscreteStates(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
            % If the tunable properties are changed, update the
            % FilterParameters private property that stores their
            % type-casted version in a structure.
        end

        function resetImpl(in) %#ok<MANU>
            % Initialize Coefficients to InitialCoefficients.
        end

        function saveCommonDiscreteStates(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Set InputDataType to be the data type of x and initialize the
            % FilterParameters property based on that. The FilterParameters
            % property is a structure with all the filter parameters casted
            % to the data type of the inputs.
        end

        function stepGAL(in) %#ok<MANU>
            % Initialize output variables
        end

        function stepImpl(in) %#ok<MANU>
        end

        function stepLSL(in) %#ok<MANU>
            % Initialize output variables
        end

        function stepQRDLSL(in) %#ok<MANU>
            % Initialize output variables
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Validating the size of the inputs x and d. Inputs must be
            % vectors.
        end

        function validatePropertiesImpl(in) %#ok<MANU>
            % Validating the dimensions of the InitialCoefficients property
        end

    end
    methods (Abstract)
    end
    properties
        %AveragingFactor Averaging factor of the energy estimator
        %   Specify the averaging factor as a positive numeric scalar less
        %   than 1. This property is used to compute the exponentially
        %   windowed forward and backward prediction error powers for the
        %   coefficient updates. This property applies only if the Method
        %   property is set to 'Gradient Adaptive Filter'. The default
        %   value of this property is set to the value of (1 - StepSize).
        AveragingFactor;

        %BackwardPredictionCoefficients Backward prediction coefficients
        %   This property stores the current backward reflection
        %   coefficients as a row vector. Its length is equal to L-1, where
        %   L is the Length property value. This property applies only if
        %   the Method property is set to 'Least-squares Lattice' or
        %   'QR-decomposition Least-squares Lattice'. This property is
        %   initialized to a vector of zeros of appropriate length and data
        %   type.
        BackwardPredictionCoefficients;

        %BackwardPredictionErrorPower Backward prediction error powers
        %   This property stores the current backward prediction
        %   least-squares error power as a column vector. Its length is
        %   equal to the Length property value. If the Method property
        %   value is 'Least-squares Lattice' or 'QR-decomposition
        %   Least-squares Lattice', all the elements of this vector are
        %   initialized to the value of (InitialPredictionErrorPower /
        %   ForgettingFactor). If the Method property value is 'Gradient
        %   Adaptive Lattice', all the elements of this vector are
        %   initialized to the InitialPredictionErrorPower property value.
        BackwardPredictionErrorPower;

        %Coefficients Current coefficients of the filter
        %   This property stores the current coefficients of the filter as
        %   a row vector of length equal to the Length property value. This
        %   property is initialized to the values of the
        %   InitialCoefficients property.
        Coefficients;

        %FilterParameters Private structure to store the filter parameters
        %   This is a private MATLAB structure that stores all the filter
        %   parameters casted to the data type of the inputs. If the Method
        %   property value is 'Least-squares Lattice' or 'QR-decomposition
        %   Least-squares Lattice', then ForgettingFactor is the only
        %   filter parameter. If the Method property value is 'Gradient
        %   Adaptive Lattice', then StepSize, Offset, ReflectionStepSize,
        %   AveragingFactor and LockCoefficients are the filter parameters.
        %   The FilterParameters property is initialized in the setup
        %   method.
        FilterParameters;

        %ForgettingFactor Least-squares lattice forgetting factor
        %   Specify the Least-squares lattice forgetting factor as a scalar
        %   positive numeric value less than or equal to 1. Setting this
        %   property value to 1 denotes infinite memory while adapting.
        %   This property applies only if the Method property is set to
        %   'Least-squares Lattice' or 'QR-decomposition Least-squares
        %   Lattice'. The default value of this property is 1.
        ForgettingFactor;

        %ForwardPredictionCoefficients Forward prediction coefficients
        %   This property stores the current forward reflection
        %   coefficients as a row vector. If the Method property is set to
        %   'Least-square Lattice', its length is equal to L-1, where L is
        %   the Length property value. If the Method property is set to
        %   'QR-decomposition Least-squares Lattice', its length is equal
        %   to the Length property value. This property is not applicable
        %   if the Method property is set to 'Gradient Adaptive Lattice'.
        %   This property is initialized to a vector of zeros of
        %   appropriate length and data type.
        ForwardPredictionCoefficients;

        %ForwardPredictionErrorPower Forward prediction error powers
        %   This property stores the current forward prediction
        %   least-squares error power as a column vector. Its length is
        %   equal to the Length property value. All the elements of this
        %   vector are initialized to the InitialPredictionErrorPower
        %   property value.
        ForwardPredictionErrorPower;

        %InitialCoefficients Initial coefficients of the filter
        %   Specify the initial values of the FIR adaptive filter
        %   coefficients as a scalar or a vector of length equal to the
        %   Length property value. The default value of this property is 0.
        InitialCoefficients;

        %InitialPredictionErrorPower Initial prediction error power
        %   Specify the initial values for the prediction error vectors as
        %   a scalar positive numeric value.
        %
        %   If the Method property is set to 'Least-squares Lattice' or
        %   'QR-decomposition Least-squares Lattice', the default value of
        %   this property is 1.0. The ForwardPredictionErrorPower property
        %   is initialized to a vector of appropriate length with all the
        %   elements equal to the InitialPredictionErrorPower property
        %   value. The BackwardPredictionErrorPower property is initialized
        %   to a vector of appropriate length with all the elements equal
        %   to the value of (InitialPredictionErrorPower /
        %   ForgettingFactor).
        %
        %   If the Method property is set to 'Gradient Adaptive Lattice',
        %   the default value of this property is 0.1. Both
        %   ForwardPredictionErrorPower and BackwardPredictionErrorPower
        %   properties are set to a vector of appropriate length with all
        %   the elements equal to the InitialPredictionErrorPower property
        %   value.
        InitialPredictionErrorPower;

        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs. It is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;

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
        %   their values remain at the current value. This property is
        %   applicable only if the Method property is set to 'Gradient
        %   Adaptive Lattice'.
        LockCoefficients;

        %Method Method to calculate the filter coefficients
        %   Specify the method used to calculate filter coefficients as one
        %   of [{'Least-squares Lattice'} | 'QR-decomposition Least-squares
        %   Lattice' | 'Gradient Adaptive Lattice'].
        Method;

        %Offset Offset for the denominator of StepSize normalization term
        %   Specify an offset value for the denominator of the StepSize
        %   normalization term as a non-negative numeric scalar. A non-zero
        %   offset is useful to avoid a divide-by-near-zero if the input
        %   signal amplitude is very small. This property applies only if
        %   the Method property is set to 'Gradient Adaptive Lattice'. The
        %   default value of this property is 1.
        Offset;

        %ReflectionCoefficients Reflection coefficient vector
        %   This property stores the current reflection coefficients as a
        %   row vector. Its length is equal to L-1, where L is the Length
        %   property value. This property applies only if the Method
        %   property is set to 'Gradient Adaptive Lattice'. This property
        %   is initialized to a vector of zeros of appropriate length and
        %   data type.
        ReflectionCoefficients;

        %ReflectionStepSize Reflection process step size
        %   Specify the reflection process step size of the gradient
        %   adaptive lattice filter as a scalar numeric value between 0 and
        %   1, both inclusive. This property applies only if the Method
        %   property is set to 'Gradient Adaptive Lattice'. The default
        %   value of this property is set to the StepSize property value.
        ReflectionStepSize;

        %States Current internal states of the filter
        %   This property stores the current internal states of the filter
        %   as a column vector. Its length is equal to the Length property
        %   value. This property is initialized to a vector of zeros of
        %   appropriate length and data type.
        States;

        %StepSize Joint process step size of the gradient adaptive filter
        %   Specify the joint process step size of the gradient adaptive
        %   lattice filter as a positive numeric scalar less than or equal
        %   to 1. This property applies only if the Method property is set
        %   to 'Gradient Adaptive Lattice'. The default value of this
        %   property is 0.1.
        StepSize;

        %privAveragingFactor A private property to store the value set to
        %   the AveragingFactor property.
        privAveragingFactor;

        %privAveragingFactorDefined A Private logical property to denote
        %   whether the AveragingFactor property has been explicitly set.
        privAveragingFactorDefined;

        %privInitialPredictionErrorPowerGAL A private property to store
        %   the default value of the InitialPredictionErrorPower property
        %   if the Method property is set to 'Gradient Adaptive Lattice'.
        %   If the InitialPredictionErrorPower property is explicitly set,
        %   this property must be updated.
        privInitialPredictionErrorPowerGAL;

        %privInitialPredictionErrorPowerLSL A private property to store
        %   the default value of the InitialPredictionErrorPower property
        %   if the Method property is set to 'Least-squares Lattice' or
        %   'QR-decomposition Least-squares Lattice'. If the
        %   InitialPredictionErrorPower property is explicitly set, this
        %   property must be updated.
        privInitialPredictionErrorPowerLSL;

        %privReflectionStepSize A private property to store the value set
        %   to the ReflectionStepSize property.
        privReflectionStepSize;

        %privReflectionStepSizeDefined A Private logical property to denote
        %   whether the ReflectionStepSize property has been explicitly
        %   set.
        privReflectionStepSizeDefined;

    end
end
