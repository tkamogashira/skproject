classdef KalmanFilter< handle
%KalmanFilter Estimate measurements and states of a system in presence
%             of white noise using Kalman Filter
%   Kalman filter is an estimator used to recursively obtain a solution for
%   linear optimal filtering. This is done without precise knowledge of the
%   underlying dynamic system. It implements the following linear
%   discrete-time process with state x at the kth time-step:
%
%      x(k) = A * x(k-1) + B * u(k-1) + w(k-1)    (state equation)
%
%   whose measurement z is given as:
%
%      z(k) = H * x(k) + v(k)                     (measurement equation)
%
%   The Kalman filter algorithm computes the following two steps 
%   recursively:
%      - Prediction: Process parameters x (state) and P (state error
%        covariance) are estimated using the previous state
%      - Correction (or update): The state and error covariance are 
%        corrected using the current measurement
%
%   H = dsp.KalmanFilter returns Kalman filter system object, H, with
%   default values for the parameters.
%
%   H = dsp.KalmanFilter('PropertyName', PropertyValue, ...)
%   returns a Kalman filter system object, H, with each specified property
%   set to the specified value.
%
%   H = dsp.KalmanFilter(STMatrix, MMatrix, PNCovariance, MNCovariance, ...
%                        CIMatrix, 'PropertyName', PropertyValue, ...)
%   returns a Kalman filter system object, H, with the 
%   StateTransitionMatrix property set to STMatrix, MeasurementMatrix 
%   property set to MMatrix, ProcessNoiseCovariance property set to 
%   PNCovariance, MeasurementNoiseCovariance property set to MNCovariance,
%   ControlInputMatrix property set to CIMatrix, and other specified 
%   properties set to the specified values.
%
%   Step method syntax:
%
%   [zEst, xEst, MSE_Est, zPred, xPred, MSE_Pred] = step(H, z, u)
%   Carries out the iterative Kalman filtering algorithm over on
%   measurements z and control inputs u. The columns in z and u are treated
%   as inputs to separate parallel filters, whose 'correction' (or 
%   'update') step can be disabled through the DisableCorrection property. 
%   The values returned are estimated measurements z_est, estimated states 
%   x_est, MSE of estimated states MSE_Est, predicted measurements zPred, 
%   predicted states xPred and MSE of predicted states MSE_Pred.
%
%   KalmanFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create Kalman filter System object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the internal states to initial conditions
%
%   KalmanFilter properties:
% 
%   StateTransitionMatrix           - Relates state at previous time step 
%                                     to state at current time step (A)
%   ControlInputMatrix              - Relates optional control input to 
%                                     the state (B)
%   MeasurementMatrix               - Relates state to the measurement (H)
%   ProcessNoiseCovariance          - Covariance of the white Gaussian 
%                                     process noise 'w' (Q)
%   MeasurementNoiseCovariance      - Covariance of the white Gaussian 
%                                     measurement noise 'v' (R)
%   InitialStateEstimate            - Initial value for states of the 
%                                     system           
%   InitialErrorCovarianceEstimate  - Initial value for covariance of 
%                                     state error
%   DisableCorrection               - Can be used to enable/disable the
%                                     'update' (or 'correct') step in the
%                                     algorithm
%   ControlInputPort                - Denotes if the control input is 
%                                     present or not  
%
%   % EXAMPLE: Estimating a changing scalar
%       % INITIALIZE
%       numSamples = 4000;  % Number of signal samples
%       R = 0.02;           % Measurement noise covariance
%       hSig = dsp.SignalSource; % Create the Signal Source
%       hSig.Signal = [  ones(numSamples/4,1);   -3*ones(numSamples/4,1);...
%                      4*ones(numSamples/4,1); -0.5*ones(numSamples/4,1)];
%       hTScope = dsp.TimeScope('NumInputPorts', 3, 'TimeSpan', numSamples, ...
%           'TimeUnits', 'Seconds', 'YLimits',[-5 5], ...
%           'ShowLegend', true); % Create the Time Scope
%       hKalman = dsp.KalmanFilter('ProcessNoiseCovariance', 0.0001,...
%           'MeasurementNoiseCovariance', R,...
%           'InitialStateEstimate', 5,...
%           'InitialErrorCovarianceEstimate', 1,...
%           'ControlInputPort',false); %Create Kalman filter
%       % STREAM
%       while(~isDone(hSig))
%           trueVal = step(hSig);               % Actual values
%           noisyVal = trueVal + sqrt(R)*randn; % Noisy measurements
%           estVal = step(hKalman, noisyVal);   % Estimated by Kalman filter
%           step(hTScope,noisyVal,trueVal,estVal);  % Plot on Time Scope
%       end

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=KalmanFilter
            % CONSTRUCTOR
        end

        function getNumInputsImpl(in) %#ok<MANU>
            % Specify number of System inputs
        end

        function getNumOutputsImpl(in) %#ok<MANU>
            % Specify the (maximum) number of System outputs
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
            % Make the ControlInputMatrix (B) inactive when ControlInputPort
            % property is set to 'false'
        end

        function loadObjectImpl(in) %#ok<MANU>
            % Load the private properties, protected properties and states
            % when loading the system object
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
            % Whenever the tunable properties are changed, update the
            % corresponding private properies that store the type casted
            % version of them.
        end

        function resetImpl(in) %#ok<MANU>
            % Initialization of states with appropriate data type
        end

        function saveObjectImpl(in) %#ok<MANU>
            % Save the private properties, protected properties and states
            % when saving the system object
        end

        function setupImpl(in) %#ok<MANU>
            % One-time calculations
            % Store the datatype of the Measurement input
        end

        function stepImpl(in) %#ok<MANU>
            % Estimate the measurement and state through noisy measurements
            % Inputs to the step function are -
            % z: Measurement Input
            % u: Control Input
            % Outputs from the step function are - 
            % zEst: Estimate of measurements
            % xEst: Estimate of states
            % MSE_Est: MSE of estimated states
            % zPred: Predicted measurements
            % xPred: Predicted states
            % MSE_Pred: MSE of predicted states
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Verify inputs to the step function.
            % z: Measurement Input
            % u: Control Input
        end

        function validatePropertiesImpl(in) %#ok<MANU>
            % Verify the dimensions of the properties.
            % Dimensions of the StateTransitionMatrix taken as the base for
            % comparison
        end

    end
    methods (Abstract)
    end
    properties
        %ControlInputMatrix Model of relation between (optional) control
        %                   input and states
        %   Specify the 'B' matrix in the state equation that relates 
        %   optional control input to the state, as a matrix with number of 
        %   rows equal to the number of states. This property is activated 
        %   only when the ControlInputPort property is true. The default 
        %   value of this property is 1.  
        ControlInputMatrix;

        %ControlInputPort Presence of a control input
        %   Specify if the control input is present, as a scalar logical.
        %   The default value of this property is true.
        ControlInputPort;

        %DisableCorrection Disable port for filters
        %   Specify if the filters in the System object should not perform 
        %   the 'correction' step after the 'prediction' step in the Kalman
        %   filter algorithm, as a scalar logical. The default value of 
        %   this property is false.
        DisableCorrection;

        % ErrorCovarianceEstimate Current estimate of error covariance of
        %                         states
        %   This property stores the current estimate of the covariance of 
        %   error, in states of the model computed through Kalman filter.
        %   This is a square matrix with each dimension equal to the number
        %   of states. This property is initialized to the value specified
        %   in the InitialErrorCovarianceEstimate property.
        ErrorCovarianceEstimate;

        % ErrorCovarianceEstimate Current prediction of error covariance of
        %                         states
        %   This property stores the current prediction of the covariance 
        %   of error in states of the model computed through Kalman filter 
        %   before applying the update step. This is a square matrix with 
        %   each dimension equal to the number of states. This property is 
        %   initialized to the value specified in the 
        %   InitialErrorCovarianceEstimate property.
        ErrorCovarianceEstimatePrior;

        % InitialErrorCovarianceEstimate Initial value for state error 
        %                                covariance
        %   Specify an initial estimate for covariance of the state error,
        %   as a square matrix with each dimension equal to the number of 
        %   states. The default value of this property is 0.1.
        InitialErrorCovarianceEstimate;

        % InitialStateEstimate Initial value for states
        %   Specify an initial estimate of the states of the model, as a
        %   column vector with length equal to the number of states. The
        %   default value of this property is 0.
        InitialStateEstimate;

        %InputDataType Data type of inputs
        %   This property stores the data type of the inputs to the System
        %   object, as a string.
        InputDataType;

        %MeasurementMatrix Model of relation between states and measurement
        %                  output
        %   Specify the 'H' matrix in the measurement equation that relates
        %   states to the measurements, as a matrix with number of columns
        %   equal to the number of states. The default value of this 
        %   property is 1. 
        MeasurementMatrix;

        %MeasurementNoiseCovariance Covariance of the measurement noise
        %   Specify the 'R' matrix as a square matrix with each dimension 
        %   equal to the number of measurements. This matrix 'R' is the 
        %   covariance of the white Gaussian process noise 'v' in the 
        %   measurement equation. The default value of this property is 
        %   0.1.
        MeasurementNoiseCovariance;

        %NumFilters Number of filters
        %   This property stores the number of parallel filters in the
        %   System object, as a double scalar. The number of filters is
        %   equal to the number of columns of the input to the step method.
        %   This property is initialized to 0.
        NumFilters;

        %ProcessNoiseCovariance Covariance of the process noise
        %   Specify the 'Q' matrix as a square matrix with each dimension 
        %   equal to the number of states. This matrix 'Q' is the 
        %   covariance of the white Gaussian process noise 'w' in the state
        %   equation. The default value of this property is 0.1.
        ProcessNoiseCovariance;

        %StateEstimate Current estimate of states of the model
        %   This property stores the current estimate of states of the 
        %   model computed through Kalman filter. It is a matrix with 
        %   number of rows equal to the number of states and number of 
        %   columns equal to the number of filters. This property is 
        %   initialized to the value specified in the InitialStateEstimate
        %   property.
        StateEstimate;

        %StateEstimatePrior Current prediction of states of the model
        %   This property stores the current prediction of states of the 
        %   model computed through Kalman filter before applying the update
        %   step. This is a matrix with number of rows equal to the number
        %   of states and number of columns equal to the number of filters. 
        %   This property is initialized to the value specified in the 
        %   InitialStateEstimate property.
        StateEstimatePrior;

        %StateTransitionMatrix Model of state transition
        %   Specify the 'A' matrix in the state equation that relates state
        %   at previous time step to the state at current time step, as a 
        %   square matrix with each dimension equal to the number of 
        %   states. The default value of this property is 1.   
        StateTransitionMatrix;

        privControlInputMatrix;

        privInitialStateEstimate;

        privMeasurementMatrix;

        privMeasurementNoiseCovariance;

        privProcessNoiseCovariance;

        privStateTransitionMatrix;

    end
end
