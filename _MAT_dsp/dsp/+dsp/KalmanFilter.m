classdef KalmanFilter < matlab.System
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
     
%   References:
%
%   [1] Greg Welch and Gary Bishop, "An Introduction to the Kalman Filter"
%       TR95-041, University of North Carolina at Chapel Hill.

%   Copyright 1995-2013 The MathWorks, Inc.

%#codegen
    
    properties
        %StateTransitionMatrix Model of state transition
        %   Specify the 'A' matrix in the state equation that relates state
        %   at previous time step to the state at current time step, as a 
        %   square matrix with each dimension equal to the number of 
        %   states. The default value of this property is 1.   
        StateTransitionMatrix = 1;
        
        %ControlInputMatrix Model of relation between (optional) control
        %                   input and states
        %   Specify the 'B' matrix in the state equation that relates 
        %   optional control input to the state, as a matrix with number of 
        %   rows equal to the number of states. This property is activated 
        %   only when the ControlInputPort property is true. The default 
        %   value of this property is 1.  
        ControlInputMatrix = 1;
        
        %MeasurementMatrix Model of relation between states and measurement
        %                  output
        %   Specify the 'H' matrix in the measurement equation that relates
        %   states to the measurements, as a matrix with number of columns
        %   equal to the number of states. The default value of this 
        %   property is 1. 
        MeasurementMatrix = 1;
        
        %ProcessNoiseCovariance Covariance of the process noise
        %   Specify the 'Q' matrix as a square matrix with each dimension 
        %   equal to the number of states. This matrix 'Q' is the 
        %   covariance of the white Gaussian process noise 'w' in the state
        %   equation. The default value of this property is 0.1.
        ProcessNoiseCovariance = 0.1;
        
        %MeasurementNoiseCovariance Covariance of the measurement noise
        %   Specify the 'R' matrix as a square matrix with each dimension 
        %   equal to the number of measurements. This matrix 'R' is the 
        %   covariance of the white Gaussian process noise 'v' in the 
        %   measurement equation. The default value of this property is 
        %   0.1.
        MeasurementNoiseCovariance = 0.1;
        
        % InitialStateEstimate Initial value for states
        %   Specify an initial estimate of the states of the model, as a
        %   column vector with length equal to the number of states. The
        %   default value of this property is 0.
        InitialStateEstimate = 0;
        
        % InitialErrorCovarianceEstimate Initial value for state error 
        %                                covariance
        %   Specify an initial estimate for covariance of the state error,
        %   as a square matrix with each dimension equal to the number of 
        %   states. The default value of this property is 0.1.
        InitialErrorCovarianceEstimate = 0.1;
    end
    
    properties (Logical)
        %DisableCorrection Disable port for filters
        %   Specify if the filters in the System object should not perform 
        %   the 'correction' step after the 'prediction' step in the Kalman
        %   filter algorithm, as a scalar logical. The default value of 
        %   this property is false.
        DisableCorrection = false;
    end
    
    properties (Nontunable, Logical)
        %ControlInputPort Presence of a control input
        %   Specify if the control input is present, as a scalar logical.
        %   The default value of this property is true.
        ControlInputPort = true;
    end
    
    properties (DiscreteState)
        %StateEstimate Current estimate of states of the model
        %   This property stores the current estimate of states of the 
        %   model computed through Kalman filter. It is a matrix with 
        %   number of rows equal to the number of states and number of 
        %   columns equal to the number of filters. This property is 
        %   initialized to the value specified in the InitialStateEstimate
        %   property.
        StateEstimate;
        
        % ErrorCovarianceEstimate Current estimate of error covariance of
        %                         states
        %   This property stores the current estimate of the covariance of 
        %   error, in states of the model computed through Kalman filter.
        %   This is a square matrix with each dimension equal to the number
        %   of states. This property is initialized to the value specified
        %   in the InitialErrorCovarianceEstimate property.
        ErrorCovarianceEstimate;
        
        %StateEstimatePrior Current prediction of states of the model
        %   This property stores the current prediction of states of the 
        %   model computed through Kalman filter before applying the update
        %   step. This is a matrix with number of rows equal to the number
        %   of states and number of columns equal to the number of filters. 
        %   This property is initialized to the value specified in the 
        %   InitialStateEstimate property.
        StateEstimatePrior;
        
        % ErrorCovarianceEstimate Current prediction of error covariance of
        %                         states
        %   This property stores the current prediction of the covariance 
        %   of error in states of the model computed through Kalman filter 
        %   before applying the update step. This is a square matrix with 
        %   each dimension equal to the number of states. This property is 
        %   initialized to the value specified in the 
        %   InitialErrorCovarianceEstimate property.
        ErrorCovarianceEstimatePrior;
    end
    
    properties (Access=protected, Nontunable)
        %InputDataType Data type of inputs
        %   This property stores the data type of the inputs to the System
        %   object, as a string.
        InputDataType;
        
        %NumFilters Number of filters
        %   This property stores the number of parallel filters in the
        %   System object, as a double scalar. The number of filters is
        %   equal to the number of columns of the input to the step method.
        %   This property is initialized to 0.
        NumFilters=0;
    end
    
    properties (Access=protected)
        % Private properties that store the parameters in the correct data
        % type based on the measurement signal's data type.
        
        privStateTransitionMatrix;
        privControlInputMatrix;
        privMeasurementMatrix;
        privProcessNoiseCovariance;
        privMeasurementNoiseCovariance;
        privInitialStateEstimate;
    end
    
    methods
        
        function obj = KalmanFilter(varargin)
            % CONSTRUCTOR
            setProperties(obj, nargin, varargin{:}, ...
                'StateTransitionMatrix', 'MeasurementMatrix', ...
                'ProcessNoiseCovariance', 'MeasurementNoiseCovariance', ...
                'ControlInputMatrix');
        end
        
        function set.StateTransitionMatrix(obj,val)
            % The State Transition Matrix must be a square matrix.
            coder.internal.errorIf(~(isnumeric(val) && ismatrix(val) && ...
                (size(val,1)==size(val,2)) && all(isfinite(val(:)))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericSquareMatrix', ...
                'StateTransitionMatrix');

            obj.StateTransitionMatrix = val;
        end
        
        function set.ControlInputMatrix(obj,val)
            % The Control Input Matrix must be numeric finite matrix.
            coder.internal.errorIf(~(isnumeric(val) && ismatrix(val) && ...
                all(isfinite(val(:)))), ...
                'dsp:system:KalmanFilter:mustBeNumericRealFinite', ...
                'ControlInputMatrix');

            obj.ControlInputMatrix = val;
        end
        
        function set.MeasurementMatrix(obj,val)
            % The Measurement Matrix must be numeric finite matrix.
            coder.internal.errorIf(~(isnumeric(val) && ismatrix(val) && ...
                all(isfinite(val(:)))), ...
                'dsp:system:KalmanFilter:mustBeNumericRealFinite', ...
                'MeasurementMatrix');

            obj.MeasurementMatrix = val;
        end
        
        function set.ProcessNoiseCovariance(obj,val)
            % The covariance matrix must be finite numeric square matrix.
            coder.internal.errorIf(~(isnumeric(val) && ismatrix(val) && ...
                (size(val,1)==size(val,2)) && all(isfinite(val(:)))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericSquareMatrix', ...
                'ProcessNoiseCovariance');
            
            obj.ProcessNoiseCovariance = val;
        end
        
        function set.MeasurementNoiseCovariance(obj,val)
            % The covariance matrix must be finite numeric square matrix.
            coder.internal.errorIf(~(isnumeric(val) && ismatrix(val) && ...
                (size(val,1)==size(val,2)) && all(isfinite(val(:)))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericSquareMatrix', ...
                'MeasurementNoiseCovariance');
            
            obj.MeasurementNoiseCovariance = val;
        end
        
        function set.InitialStateEstimate(obj,val)
            % The InitialStateEstimate must be numeric finite matrix.
            coder.internal.errorIf(~(isnumeric(val) && ismatrix(val) && ...
                all(isfinite(val(:)))), ...
                'dsp:system:KalmanFilter:mustBeNumericRealFinite', ...
                'InitialStateEstimate');
            
            coder.internal.errorIf(~(iscolumn(val)), ...
                'dsp:system:KalmanFilter:mustBeColumnVector', 'InitialStateEstimate');

            obj.InitialStateEstimate = val;
        end
        
        function set.InitialErrorCovarianceEstimate(obj,val)
            % The initial estimate for error covariance matrix must be 
            % finite numeric square matrix.
            coder.internal.errorIf(~(isnumeric(val) && ismatrix(val) && ...
                (size(val,1)==size(val,2)) && all(isfinite(val(:)))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericSquareMatrix', ...
                'InitialErrorCovarianceEstimate');
            
            obj.InitialErrorCovarianceEstimate = val;
        end
        
    end
    
    methods(Access=protected)
        
        function N = getNumInputsImpl(obj)
            % Specify number of System inputs
            if obj.ControlInputPort
                N=2;
            else
                N=1;
            end
        end
        
        function num = getNumOutputsImpl(~)
            % Specify the (maximum) number of System outputs
            num = 6;
        end
        
        function setupImpl(obj,z,~)
            % One-time calculations
            % Store the datatype of the Measurement input
            obj.InputDataType = class(z);
            obj.NumFilters = size(z,2);
            
            % Cast properties into their private counterparts
            obj.privStateTransitionMatrix       = cast(obj.StateTransitionMatrix, obj.InputDataType);
            obj.privControlInputMatrix          = cast(obj.ControlInputMatrix, obj.InputDataType);
            obj.privMeasurementMatrix           = cast(obj.MeasurementMatrix, obj.InputDataType);
            obj.privProcessNoiseCovariance      = cast(obj.ProcessNoiseCovariance, obj.InputDataType);
            obj.privMeasurementNoiseCovariance  = cast(obj.MeasurementNoiseCovariance, obj.InputDataType);
            obj.privInitialStateEstimate        = cast(repmat(obj.InitialStateEstimate,1,obj.NumFilters), obj.InputDataType);
        end
        
        function resetImpl(obj)
            
            % Initialization of states with appropriate data type
            obj.StateEstimate                 = cast(obj.privInitialStateEstimate, obj.InputDataType);
            obj.ErrorCovarianceEstimate       = cast(obj.InitialErrorCovarianceEstimate, obj.InputDataType);
            obj.StateEstimatePrior            = zeros(size(obj.StateTransitionMatrix,1), size(obj.privInitialStateEstimate,2), obj.InputDataType);
            obj.ErrorCovarianceEstimatePrior  = zeros(size(obj.StateTransitionMatrix,1), obj.InputDataType);
        end
        
        function processTunedPropertiesImpl(obj)
            % Whenever the tunable properties are changed, update the
            % corresponding private properies that store the type casted
            % version of them.
            
            obj.privStateTransitionMatrix       = cast(obj.StateTransitionMatrix, obj.InputDataType);
            obj.privControlInputMatrix          = cast(obj.ControlInputMatrix, obj.InputDataType);
            obj.privMeasurementMatrix           = cast(obj.MeasurementMatrix, obj.InputDataType);
            obj.privProcessNoiseCovariance      = cast(obj.ProcessNoiseCovariance, obj.InputDataType);
            obj.privMeasurementNoiseCovariance  = cast(obj.MeasurementNoiseCovariance, obj.InputDataType);
            obj.privInitialStateEstimate        = cast(repmat(obj.InitialStateEstimate,1,obj.NumFilters), obj.InputDataType);
            
        end
        
        function flag = isInactivePropertyImpl(obj,propertyName)
            % Make the ControlInputMatrix (B) inactive when ControlInputPort
            % property is set to 'false'
            if strcmp(propertyName,'ControlInputMatrix') && ~obj.ControlInputPort
                flag = true;
            else
                flag = false;
            end
        end
        
        function [zEst, xEst, MSE_Est, zPred, xPred, MSE_Pred] = stepImpl(obj, z, u)
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
            
            stateSpaceDim = size(obj.StateTransitionMatrix,1);
            measurementSpaceDim = size(obj.MeasurementMatrix, 1);
            numTsteps = size(z,1)/measurementSpaceDim;
            numFilters = obj.NumFilters;
            
            % Check if the number of filters has changed since the last
            % time step was called
            coder.internal.errorIf(~(numFilters == size(z,2)), ...
                'MATLAB:system:inputSpecsChangedErrorS', 1);
            
            
            % Containers to store predictions and estimates for all time
            % steps
            zEstContainer = z;
            xEstContainer = zeros(stateSpaceDim*numTsteps, numFilters);
            MSE_EstContainer = zeros(numTsteps,1);
            zPredContainer = z;
            xPredContainer = zeros(stateSpaceDim*numTsteps, numFilters);
            MSE_PredContainer = zeros(numTsteps,1);
            
            % Local copies of properties
            A = obj.privStateTransitionMatrix;
            if obj.ControlInputPort
                B = obj.privControlInputMatrix;
            else
                B = zeros(stateSpaceDim,1,class(z));
                u = zeros(numTsteps, size(z,2),class(z));
            end
            H = obj.privMeasurementMatrix;
            Q = obj.privProcessNoiseCovariance;
            R = obj.privMeasurementNoiseCovariance;
            
            % Local copy of DisableCorrection property
            disableUpdate = obj.DisableCorrection;
            
            controlInputDim = size(B,2);
            
            % Local copies of discrete states
            xhat    = obj.StateEstimate;
            P       = obj.ErrorCovarianceEstimate;
            xPrior  = obj.StateEstimatePrior;
            PPrior  = obj.ErrorCovarianceEstimatePrior;
            
            % Loop over all time steps
            for n=1:numTsteps
                
                % Gather chunks for current time step
                zRowIndexChunk = (n-1)*measurementSpaceDim + (1:measurementSpaceDim);
                stateEstsRowIndexChunk = (n-1)*stateSpaceDim + (1:stateSpaceDim);
                controlInputRowIndexChunk = (n-1)*controlInputDim + (1:controlInputDim);
                
                % Prediction step
                xPrior = A * xhat + B * u(controlInputRowIndexChunk,:);
                PPrior =  A * P * A' + Q;
                
                % Correction step
                if disableUpdate
                    % Correction step is disabled
                    % Copy states and error covariance from prediction step
                    xhat = xPrior; 
                    P = PPrior;
                else
                    % Correction step is not disabled
                    % Compute Kalman gain
                    PpriorH   = PPrior * H';
                    HPpriorHR  = H * PpriorH + R;
                    KalmanGain = (HPpriorHR \ PpriorH')';
                    KH  = KalmanGain * H;

                    % States and error covariance are updated in the 
                    % correction step
                    xhat = xPrior + KalmanGain * z(zRowIndexChunk,:) - ...
                           KH * xPrior;     
                    P = PPrior - KH * PPrior;
                end
                
                % Append estimates
                xEstContainer(stateEstsRowIndexChunk, :) = xhat;
                zEstContainer(zRowIndexChunk,:) = H*xhat;
                MSE_EstContainer(n) = trace(P);
                
                % Append predictions
                xPredContainer(stateEstsRowIndexChunk, :) = xPrior;
                zPredContainer(zRowIndexChunk,:) = H*xPrior;
                MSE_PredContainer(n) = trace(PPrior);
            end
            
            
            % Update the discrete states
            obj.StateEstimate                = xhat;
            obj.ErrorCovarianceEstimate      = P;
            obj.StateEstimatePrior           = xPrior;
            obj.ErrorCovarianceEstimatePrior = PPrior;
            
            % Populate the outputs
            % zEst, xEst, MSE_Est, zPred, xPred, MSE_Pred
            zEst = zEstContainer;
            if nargout >=2
                xEst = xEstContainer;
            end
            if nargout >=3
                MSE_Est = MSE_EstContainer;
            end
            if nargout >=4
                zPred = zPredContainer;
            end
            if nargout >=5
                xPred = xPredContainer;
            end
            if nargout ==6
                MSE_Pred = MSE_PredContainer;
            end
        end
        
        function validatePropertiesImpl(obj)
            % Verify the dimensions of the properties.
            % Dimensions of the StateTransitionMatrix taken as the base for
            % comparison
            
            % Check the dimensions (rows) of ControlInputMatrix
            % Based on:
            % State = StateTransitionMatrix * PreviousState + ControlInputMatrix * InputSignal
            if obj.ControlInputPort
                ControlInputMatrixExpectedRows = size(obj.StateTransitionMatrix,1);
                coder.internal.errorIf(~(size(obj.ControlInputMatrix,1) == ...
                    ControlInputMatrixExpectedRows), ...
                    'dsp:system:KalmanFilter:invalidRows', ...
                    'ControlInputMatrix', ControlInputMatrixExpectedRows);
            end
            
            % Check the dimensions (columns) of MeasurementMatrix
            % Based on:
            % Measurement = MeasurementMatrix * State    and
            % State = StateTransitionMatrix * PreviousState + ControlInputMatrix * InputSignal
            MeasurementMatrixExpectedColumns = size(obj.StateTransitionMatrix,1);
            coder.internal.errorIf(~(size(obj.MeasurementMatrix,2) == ...
                MeasurementMatrixExpectedColumns),...
                'dsp:system:KalmanFilter:invalidColumns', ...
                'MeasurementMatrix', MeasurementMatrixExpectedColumns);
            
            % Check the dimensions (rows) of ProcessNoiseCovariance
            % Based on:
            % ErrorCovariancePrior = StateTransitionMatrix * ErrorCovariancePosterior * ...
            %                        StateTransitionMatrix' + ProcessNoiseCovariance
            ProcessNoiseCovarianceMatrixExpectedRows = size(obj.StateTransitionMatrix,1);
            coder.internal.errorIf(~(size(obj.ProcessNoiseCovariance,1) == ...
                ProcessNoiseCovarianceMatrixExpectedRows),...
                'dsp:system:KalmanFilter:invalidRows', ...
                'ProcessNoiseCovariance', ProcessNoiseCovarianceMatrixExpectedRows);
            
            % Check the dimensions (rows) of MeasurementNoiseCovariance
            % Based on:
            % KalmanGain = ErrorCovPrior * MeasurementMatrix' * ...
            %              inv(MeasurementMatrix * ErrorCovPrior * ...
            %              MeasurementMatrix' + MeasurementNoiseCovariance)
            MeasurementNoiseCovarianceMatrixExpectedRows = size(obj.MeasurementMatrix,1);
            coder.internal.errorIf(~(size(obj.MeasurementNoiseCovariance,1) ==...
                MeasurementNoiseCovarianceMatrixExpectedRows), ...
                'dsp:system:KalmanFilter:invalidMeasurementRows', ...
                'MeasurementNoiseCovariance', MeasurementNoiseCovarianceMatrixExpectedRows);
                
            % Check the dimensions (rows) of InitialStateEstimate
            % Based on:
            % States = InitialStateEstimate (for initialization)
            InitialStateEstimateExpectedRows = size(obj.StateTransitionMatrix,1);
            coder.internal.errorIf(~(size(obj.InitialStateEstimate,1) == ...
                InitialStateEstimateExpectedRows),...
                'dsp:system:KalmanFilter:invalidRows', ...
                'InitialStateEstimate', InitialStateEstimateExpectedRows);
            
            % Check the dimensions (rows) of InitialErrorCovarianceEstimate
            % Based on:
            % ErrorCovariancePosterior = InitialErrorCovarianceEstimate (for initialization)
            % and ErrorCovariancePrior = StateTransitionMatrix * ErrorCovariancePosterior * ...
            %                        StateTransitionMatrix' + ProcessNoiseCovariance
            InitialErrorCovarianceEstimateExpectedRows = size(obj.StateTransitionMatrix,1);
            coder.internal.errorIf(~(size(obj.InitialErrorCovarianceEstimate,1) == ...
                InitialErrorCovarianceEstimateExpectedRows),...
                'dsp:system:KalmanFilter:invalidRows', ...
                'InitialErrorCovarianceEstimate', InitialErrorCovarianceEstimateExpectedRows);
        end
        
        function validateInputsImpl(obj,z,u)
            % Verify inputs to the step function.
            % z: Measurement Input
            % u: Control Input
            
            % Check for real-valued and finite z
            coder.internal.errorIf(~(isnumeric(z) && isreal(z) && ...
                all(all(isfinite(z))) && ~isempty(z)), ...
                'dsp:system:KalmanFilter:inputsNotNumericRealFinite', ...
                'Measurement');
            
            % Check for valid datatype of z
            coder.internal.errorIf(~(isa(z,'float')), ...
                'dsp:system:KalmanFilter:inputsNotFloatingPoint', 'Measurement');
            
            if obj.ControlInputPort
                % Check for real-valued and finite u
                coder.internal.errorIf(~(isnumeric(u) && isreal(u) && ...
                    all(all(isfinite(u))) && ~isempty(u)), ...
                    'dsp:system:KalmanFilter:inputsNotNumericRealFinite', ...
                    'Control');
                
                % Check for valid datatype of u
                coder.internal.errorIf(~(isa(u,'float')), ...
                    'dsp:system:KalmanFilter:inputsNotFloatingPoint', 'Control');
                
                % Check for a match in datatypes of z and u
                coder.internal.errorIf(~(strcmp(class(z), class(u))), ...
                    'dsp:system:KalmanFilter:inputsNotSameClass', 'Measurement', 'Control');
            end
            
            % Check the dimensions (rows) of Measurement Input (z)
            % Number of rows of 'z' must be a multiple of the number of
            % rows of MeasurementMatrix
            % Based on: z(k) = H * x(k) + v(k) 
            MeasurementMatrixNumRows = size(obj.MeasurementMatrix,1);
            MeasurementsNumRows = size(z, 1);
            coder.internal.errorIf(~(mod(MeasurementsNumRows, MeasurementMatrixNumRows) == 0),...
                'dsp:system:KalmanFilter:inputsInvalidRows', ...
                'Measurement', 'MeasurementMatrix');
            
            if obj.ControlInputPort
                % Check the dimensions (rows) of Control Input (u)
                % Number of rows of 'u' must be a multiple of the number of
                % columns of ControlInputMatrix
                % Based on: x(k) = A * x(k-1) + B * u(k-1) + w(k-1)
                ControlInputMatrixColumns = size(obj.ControlInputMatrix,2);
                InputNumRows = size(u,1);
                coder.internal.errorIf(~(mod(InputNumRows, ControlInputMatrixColumns) == 0),...
                    'dsp:system:KalmanFilter:inputsInvalidRows', ...
                    'Control', 'ControlInputMatrix');
                
                % Check if the number of time steps deduced by the rows of
                % 'z' is consistent with the number of time steps deduced
                % by the rows of 'u'
                coder.internal.errorIf(~((InputNumRows/ControlInputMatrixColumns) == ...
                   (MeasurementsNumRows/MeasurementMatrixNumRows)),...
                   'dsp:system:KalmanFilter:inputsInvalidTimesteps');
               
                % Check if the number of columns of 'z' match the number of
                % columns of 'u'
                coder.internal.errorIf(~(size(z, 2) == size(u, 2)),...
                   'dsp:system:KalmanFilter:inputsInvalidColumns', 'Measurement', 'Control');
            end
            
        end
        
        function s = saveObjectImpl(obj)
            % Save the private properties, protected properties and states
            % when saving the system object
            
            % Call the base class method
            s = saveObjectImpl@matlab.System(obj);

            % Save the protected & private properties
            s.InputDataType = obj.InputDataType;
            s.NumFilters = obj.NumFilters;
            s.privStateTransitionMatrix = obj.privStateTransitionMatrix;
            s.privControlInputMatrix = obj.privControlInputMatrix;
            s.privMeasurementMatrix = obj.privMeasurementMatrix;
            s.privProcessNoiseCovariance = obj.privProcessNoiseCovariance;
            s.privMeasurementNoiseCovariance = obj.privMeasurementNoiseCovariance;
            s.privInitialStateEstimate = obj.privInitialStateEstimate;

            % Save the state only if object locked
            if isLocked(obj)
                s.StateEstimate = obj.StateEstimate;
                s.ErrorCovarianceEstimate = obj.ErrorCovarianceEstimate;
                s.StateEstimatePrior = obj.StateEstimatePrior;
                s.ErrorCovarianceEstimatePrior = obj.ErrorCovarianceEstimatePrior;
            end
        end

        function loadObjectImpl(obj,s,wasLocked)
            % Load the private properties, protected properties and states
            % when loading the system object

            % Load protected and private properties
            obj.InputDataType = s.InputDataType;
            obj.NumFilters = s.NumFilters;
            obj.privStateTransitionMatrix = s.privStateTransitionMatrix;
            obj.privControlInputMatrix = s.privControlInputMatrix;
            obj.privMeasurementMatrix = s.privMeasurementMatrix;
            obj.privProcessNoiseCovariance = s.privProcessNoiseCovariance;
            obj.privMeasurementNoiseCovariance = s.privMeasurementNoiseCovariance;
            obj.privInitialStateEstimate = s.privInitialStateEstimate;

            % Load the state only if object locked
            if wasLocked
                obj.StateEstimate = s.StateEstimate;
                obj.ErrorCovarianceEstimate = s.ErrorCovarianceEstimate;
                obj.StateEstimatePrior = s.StateEstimatePrior;
                obj.ErrorCovarianceEstimatePrior = s.ErrorCovarianceEstimatePrior;
            end

            % Call base class method to load public properties
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end 
        
    end % methods, protected API
    
end