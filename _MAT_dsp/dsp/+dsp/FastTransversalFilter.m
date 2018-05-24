classdef FastTransversalFilter < matlab.System
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
    
    properties (Nontunable)
        %Method Method to calculate the filter coefficients
        %   Specify the method used to calculate filter coefficients as one
        %   of [{'Fast transversal least-squares'} | 'Sliding-window fast
        %   transversal least-squares'].
        Method = 'Fast transversal least-squares';
    end
    
    properties (Nontunable, PositiveInteger)
        %Length Length of the filter coefficients vector
        %   Specify the length of the FIR filter coefficients vector as a
        %   positive integer value. The default value of this property is
        %   32.
        Length = 32;
    end
    
    properties (Nontunable, Dependent)
        %SlidingWindowBlockLength Width of the sliding window
        %   Specify the width of the sliding window as a positive integer
        %   value greater than or equal to the Length property value. This
        %   property is applicable only if the Method property is set to
        %   'Sliding-window fast transversal least-squares'. The default
        %   value of this property is set to the Length property value.
        SlidingWindowBlockLength;
    end
    
    properties
        %ForgettingFactor Fast transversal filter forgetting factor
        %   Specify the fast transversal filter forgetting factor as a
        %   positive numeric value. Setting this property value to 1
        %   denotes infinite memory while adapting to find the new filter.
        %   It is recommended that the value set to this property should
        %   lie in the range (1-0.5/L, 1], where L is the Length property
        %   value. This property is applicable only if the Method property
        %   is set to 'Fast transversal least-squares'. The default value 
        %   of this property is 1.
        ForgettingFactor = 1;
        
        %InitialPredictionErrorPower Initial prediction error power
        %   Specify the initial value of the forward and backward
        %   prediction error vectors as a positive numeric scalar. This
        %   scalar should be sufficiently large to maintain stability and
        %   prevent an excessive number of Kalman gain rescues. The default
        %   value of this property is 10.
        InitialPredictionErrorPower = 10;
        
        %InitialCoefficients Initial coefficients of the filter
        %   Specify the initial value of the FIR adaptive filter
        %   coefficients as a scalar or a vector of length equal to the
        %   Length property value. The default value of this property is 0.
        InitialCoefficients = 0;
    end
    
    properties (Dependent)
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
    end
    
    properties (Logical)
        %LockCoefficients Locked status of the coefficient updates
        %   Specify whether the filter coefficient values should be locked.
        %   By default, the value of this property is false, and the object
        %   continuously updates the filter coefficients. If this property
        %   is set to true, the filter coefficients do not get updated and
        %   their values remain at the current value.
        LockCoefficients = false;
    end
    
    properties (DiscreteState)
        %Coefficients Current coefficients of the filter
        %   This property stores the current coefficients of the filter as
        %   a row vector of length equal to the Length property value. This
        %   property is initialized to the values of InitialCoefficients
        %   property.
        Coefficients;
        
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
        
        %DesiredStates Current desired states of the filter
        %   This property stores the current desired signal states of the
        %   adaptive filter as a column vector. Its length is equal to the
        %   SlidingWindowBlockLength property value. This property is
        %   applicable only if the Method property is set to
        %   'Sliding-window fast transversal least-squares'. This property
        %   is initialized to a vector of zeros of appropriate length.
        DesiredStates;
        
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
        
        %ForwardPredictionCoefficients Forward prediction coefficients
        %   This property stores the current forward prediction
        %   coefficients as a row vector. Its length is equal to the Length
        %   property value. This property is initialized to a vector of
        %   zeros of appropriate length and data type.
        ForwardPredictionCoefficients;
        
        %BackwardPredictionCoefficients Backward prediction coefficients
        %   This property stores the current backward prediction
        %   coefficients as a row vector. Its length is equal to the Length
        %   property value. This property is initialized to a vector of
        %   zeros of appropriate length and data type.
        BackwardPredictionCoefficients;
        
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
        
        %BackwardPredictionErrorPower Backward prediction error power
        %   This property stores the current backward prediction
        %   least-squares error power as a scalar value. This property is
        %   initialized to the InitialPredictionErrorPower property value.
        BackwardPredictionErrorPower;
    end
    
    properties (Access=protected)
        %FilterParameters Private structure to store the filter parameters
        %   This is a private MATLAB structure that stores all the filter
        %   parameters casted to the data type of the inputs. For
        %   FastTransversalFilter System object, the ForgettingFactor
        %   property, the InitialPredictionErrorPower property and the
        %   LockCoefficients property are the filter parameters. The
        %   FilterParameters property is initialized in the setup method.
        FilterParameters;
        
        %privInitialConversionFactorFTF A private property to store
        %   the default value of the InitialConversionFactor property
        %   if the Method property is set to 'Fast transversal
        %   least-squares'. If the InitialConversionFactor property is
        %   explicity set, this property must be updated.
        privInitialConversionFactorFTF = 1;
        
        %privInitialConversionFactorSWFTF A private property to store
        %   the default value of the InitialConversionFactor property if
        %   the Method property is set to 'Sliding-window fast transversal
        %   least-squares'. If the InitialConversionFactor property is
        %   explicity set, this property must be updated.
        privInitialConversionFactorSWFTF = [1 -1];
    end
    
    properties (Access=protected, Nontunable, PositiveInteger)
        %privSlidingWindowBlockLength A private property to store
        %   the value explicity set to the SlidingWindowBlockLength
        %   property. This private property is used only if the Method
        %   property is set to 'Sliding-window Fast transversal
        %   least-squares'.
        privSlidingWindowBlockLength = 32;
    end
    
    properties (Access=protected, Nontunable, Logical)
        %privSlidingWindowBlockLengthDefined A Private logical property to
        % denote whether the SlidingWindowBlockLength property has been
        % explicitly set.
        privSlidingWindowBlockLengthDefined = false;
    end
    
    properties (Access=protected, Nontunable)
        %InputDataType Data type of the input
        %   This is a private property that stores the data type of the
        %   input. It is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;
    end
    
    properties(Constant, Hidden)
        %MethodSet StringSet to specify the valid string values for the
        %   Method property
        MethodSet = matlab.system.StringSet( { ...
            'Fast transversal least-squares', ...
            'Sliding-window fast transversal least-squares'} );
    end
    
    
    methods
        % FastTransversalFilter constructor
        function obj = FastTransversalFilter(varargin)
            % Supports name-value pair arguments as well as alternatively
            % allows the Length property to be a value-only argument.
            setProperties(obj, nargin, varargin{:}, 'Length');
        end
        
        % Validating and setting ForgettingFactor
        function set.ForgettingFactor(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val > 0 && val <= 1 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeRealScalar0to1LeftOpen', 'ForgettingFactor');
            obj.ForgettingFactor = val;
        end
        
        % Validating and setting InitialPredictionErrorPower
        function set.InitialPredictionErrorPower(obj,val)
            coder.internal.errorIf(~(isscalar(val) && isnumeric(val) && val > 0 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBePositiveRealScalar', 'InitialPredictionErrorPower');
            obj.InitialPredictionErrorPower = val;
        end
        
        % Validating and setting InitialCoefficients
        function set.InitialCoefficients(obj,val)
            coder.internal.errorIf(~(isvector(val) && isnumeric(val) && ...
                all(isfinite(val))), 'dsp:system:AdaptiveFilter:mustBeNumericVector', ...
                'InitialCoefficients');
            obj.InitialCoefficients = val(:).';
        end
        
        % Validating and setting InitialConversionFactor. Since
        % InitialConversionFactor is a dependent property, the value
        % set to it is stored in both the private properties, viz,
        % privInitialConversionFactorFTF and
        % privInitialConversionFactorSWFTF.
        function set.InitialConversionFactor(obj,val)
            if strcmp(obj.Method, 'Fast transversal least-squares')
                coder.internal.errorIf(~(isscalar(val) && val > 0 && ...
                    val <= 1 && isreal(val)), ...
                    'dsp:system:AdaptiveFilter:mustBeRealScalar0to1LeftOpen', ...
                    'InitialConversionFactor');
                obj.privInitialConversionFactorFTF = val;
            else
                coder.internal.errorIf(~(numel(val)==2 && isnumeric(val) && ...
                    isreal(val) && val(1) > 0 && val(1) <= 1 && val(2) <= -1), ...
                    'dsp:system:FastTransversalFilter:invalidInitialConversionFactorSWFTF');
                obj.privInitialConversionFactorSWFTF = val(:).';
            end
        end
        
        % Get method for the InitialConversionFactor dependent property. If
        % the InitialConversionFactor is not explicitly set, this
        % method returns the default value based on the Method property
        % value.
        function val = get.InitialConversionFactor(obj)
            if strcmp(obj.Method, 'Fast transversal least-squares')
                val = obj.privInitialConversionFactorFTF;
            else
                val = obj.privInitialConversionFactorSWFTF;
            end
        end
        
        % Set method for the SlidingWindowBlockLength dependent property.
        % Since SlidingWindowBlockLength is a dependent property, the value
        % set to it is stored in the privSlidingWindowBlockLength private
        % property and the privSlidingWindowBlockLengthDefined logical
        % property is set to true. Validation is taken care by the
        % PositiveInteger attribute.
        function set.SlidingWindowBlockLength(obj,val)
            obj.privSlidingWindowBlockLength = val;
            obj.privSlidingWindowBlockLengthDefined = true;
        end
        
        % Get method for the SlidingWindowBlockLength dependent property.
        % If the SlidingWindowBlockLength is not explicitly set, this
        % method returns the Length property value as its default value.
        function val = get.SlidingWindowBlockLength(obj)
            if obj.privSlidingWindowBlockLengthDefined
                val = obj.privSlidingWindowBlockLength;
            else
                val = obj.Length;
            end
        end
    end
    
    methods (Access=protected)
        function validatePropertiesImpl(obj)
            L = obj.Length;
            % Validating the SlidingWindowBlockLength property. Its value
            % must be at least as large as the Length property value.
            if strcmp(obj.Method, 'Sliding-window fast transversal least-squares')
                coder.internal.errorIf((obj.SlidingWindowBlockLength < L), ...
                    'dsp:system:FastTransversalFilter:invalidSlidingWindowBlockLength');
            end
            
            % Validating the dimensions of the InitialCoefficients property
            coder.internal.errorIf(~(any(length(obj.InitialCoefficients)==[1,L])), ...
                'dsp:system:AdaptiveFilter:invalidVectorOfLengthL', 'InitialCoefficients');
        end
        
        function validateInputsImpl(~, x, d)
            % Validating the size of the inputs x and d. Inputs must be
            % vectors.
            coder.internal.errorIf(~isvector(x) || isempty(x), ...
                'MATLAB:system:inputMustBeVector','signal');
            
            coder.internal.errorIf(~isvector(d) || isempty(d), ...
                'MATLAB:system:inputMustBeVector','desired signal');
            
            % Inputs must be of same size
            coder.internal.errorIf(~all(size(x)==size(d)), ...
                'MATLAB:system:inputsNotSameSize');
            
            % Validating the data type of the inputs x and d. x and d must
            % both be single or double.
            coder.internal.errorIf(~(isa(x,'float') && strcmp(class(x), ...
                class(d))), 'dsp:system:AdaptiveFilter:inputsNotFloatingPoint');
        end
        
        function setupImpl(obj, x, d)
            % Set InputDataType to be the data type of x and initialize the
            % FilterParameters property based on that. The FilterParameters
            % property is a structure with all the filter parameters casted
            % to the data type of the inputs.
            inputDataTypeLocal = class(x);
            obj.InputDataType = inputDataTypeLocal;
            obj.FilterParameters = getFilterParameterStruct(obj);
            
            % Local copy of the required properties
            L = obj.Length;
            realInputX = isreal(x);
            realInputD = isreal(d);
            
            % Temporary variables - A vector of zeros of a scalar zero.
            zeroCoefficientsVector = zeros(1,L,inputDataTypeLocal);
            zeroScalar = cast(0,inputDataTypeLocal);
            
            % Initialize the Coefficients property to zeros of appropriate
            % complexity and data type:
            if realInputX && realInputD && isreal(obj.InitialCoefficients)
                obj.Coefficients = zeroCoefficientsVector;
            else
                obj.Coefficients = complex(zeroCoefficientsVector);
            end
            
            % Initialize the ConversionFactor property to zeros of
            % appropriate data type.
            obj.ConversionFactor = zeros(size(obj.InitialConversionFactor), inputDataTypeLocal);
            
            % Initialize the prediction coefficients and the prediction
            % error powers to zeros of appropriate complexity and data
            % type.
            obj.ForwardPredictionErrorPower = zeroScalar;
            obj.BackwardPredictionErrorPower = zeroScalar;
            if realInputX
                obj.ForwardPredictionCoefficients = zeroCoefficientsVector;
                obj.BackwardPredictionCoefficients = zeroCoefficientsVector;
            else
                obj.ForwardPredictionCoefficients = complex(zeroCoefficientsVector);
                obj.BackwardPredictionCoefficients = complex(zeroCoefficientsVector);
            end
            
            % Initialize other DiscreteStates properties whose dimensions
            % depend on the Method property value to zeros of appropriate
            % complexity, data type and dimensions.
            if strcmp(obj.Method, 'Fast transversal least-squares')
                % Initialize States, KalmanGainStates and KalmanGain to
                % zeros of appropriate complexity, data type and
                % dimensions for FTF filter.
                zeroStatesVector = zeros(L,1,inputDataTypeLocal);
                if realInputX
                    obj.States = zeroStatesVector;
                    obj.KalmanGainStates = zeroStatesVector;
                    obj.KalmanGain = zeroStatesVector;
                else
                    obj.States = complex(zeroStatesVector);
                    obj.KalmanGainStates = complex(zeroStatesVector);
                    obj.KalmanGain = complex(zeroStatesVector);
                end
            else
                % Initialize States, KalmanGainStates and KalmanGain to
                % zeros of appropriate complexity, data type and
                % dimensions for sliding-window FTF filter.
                N = obj.SlidingWindowBlockLength;
                zeroStatesVector = zeros(L+N,1,inputDataTypeLocal);
                if realInputX
                    obj.States = zeroStatesVector;
                    obj.KalmanGainStates = zeroStatesVector;
                    obj.KalmanGain = zeros(L,2,inputDataTypeLocal);
                else
                    obj.States = complex(zeroStatesVector);
                    obj.KalmanGainStates = complex(zeroStatesVector);
                    obj.KalmanGain = complex(zeros(L,2,inputDataTypeLocal));
                end
                
                % Initialize DesiredStates to zeros:
                if realInputD
                    obj.DesiredStates = zeros(N,1,inputDataTypeLocal);
                else
                    obj.DesiredStates = complex(zeros(N,1,inputDataTypeLocal));
                end
            end
        end
        
        function resetImpl(obj)
            % Local copy of the required properties
            L = obj.Length;
            params = obj.FilterParameters;
            
            % Initialize Coefficients to InitialCoefficients.
            obj.Coefficients = dsp.private.copyMatrix(obj.InitialCoefficients, ...
                obj.Coefficients);
            
            % Initialize Conversion Factor to zeros of appropriate
            % data type.
            obj.ConversionFactor(:) = obj.InitialConversionFactor;
            
            % Initialize the prediction error powers based on the
            % InitialPredictionErrorPower property value
            obj.BackwardPredictionErrorPower(:) = params.InitialPredictionErrorPower;
            if strcmp(obj.Method, 'Fast transversal least-squares')
                obj.ForwardPredictionErrorPower(:) = ...
                    (params.ForgettingFactor^L) * params.InitialPredictionErrorPower;
            else
                obj.ForwardPredictionErrorPower(:) = params.InitialPredictionErrorPower;
            end
            
            % Initialize other DiscreteStates properties to zeros of
            % appropriate complexity, data type and dimensions.
            obj.States = dsp.private.copyMatrix(0, obj.States);
            obj.KalmanGainStates = dsp.private.copyMatrix(0, obj.KalmanGainStates);
            obj.KalmanGain = dsp.private.copyMatrix(0, obj.KalmanGain);
            obj.ForwardPredictionCoefficients = dsp.private.copyMatrix( ...
                0, obj.ForwardPredictionCoefficients);
            obj.BackwardPredictionCoefficients = dsp.private.copyMatrix( ...
                0, obj.BackwardPredictionCoefficients);
            if strcmp(obj.Method, 'Sliding-window fast transversal least-squares')
                obj.DesiredStates = dsp.private.copyMatrix(0, obj.DesiredStates);
            end
        end
        
        function processTunedPropertiesImpl(obj)
            % Whenever the tunable properties are changed, update the
            % FilterParameters private property that stores their type
            % casted version in a structure.
            inputDataTypeLocal = obj.InputDataType;
            obj.FilterParameters.InitialPredictionErrorPower = ...
                cast(obj.InitialPredictionErrorPower, inputDataTypeLocal);
            obj.FilterParameters.LockCoefficients = obj.LockCoefficients;
            if strcmp(obj.Method, 'Fast transversal least-squares')
                obj.FilterParameters.ForgettingFactor = ...
                    cast(obj.ForgettingFactor,inputDataTypeLocal);
            end
        end
        
        function [y,e] = stepImpl(obj, x, d)
            if strcmp(obj.Method, 'Fast transversal least-squares')
                [y,e] = stepFTF(obj, x, d);
            else
                [y,e] = stepSWFTF(obj, x, d);
            end
        end
        
        %stepFTF A helper method to stepImpl that implements the core
        % algorithm of Fast transversal least-squares adaptive filter.
        function [y,e] = stepFTF(obj, x, d)
            % Load the required DiscreteState properties
            W = obj.Coefficients;   % Load coefficient vector
            Xo = obj.States;        % Load internal filter states
            [X,Kt,gamma,A,G,invAlpha,beta] = loadFTFDiscreteStates(obj);
            
            % Load the required constant properties
            L = obj.Length;
            params = obj.FilterParameters;
            lam = params.ForgettingFactor;
            delta = params.InitialPredictionErrorPower;
            lockCoeffs = params.LockCoefficients;
            inputDataTypeLocal = obj.InputDataType;
            
            % Initialize output variables
            [y,e,ntr] = initializeVariables(obj,size(x));
            
            % Assign L-element vector of zeros for rescues
            if isreal(X)
                zeroRowVector = zeros(1,L,inputDataTypeLocal);
            else
                zeroRowVector = complex(zeros(1,L,inputDataTypeLocal));
            end
            
            % Initialize some constants needed in the main loop
            olam = 1/lam;       % assign inverse forgetting factor
            lamL = lam^L;       % assign (L)th power of forgetting factor
            numRescues = 0;     % initialize number of rescues
            
            % Error feedback constants for stabilized FTF update.
            % Other "hard-wired" error feedback constants:
            %   Ki3 = 0, Ki5 = 1, Ki6 = 1
            Ki1 = 1.5;
            Ki2 = 2.5;
            Ki4 = 0.3;
            
            % Cache the index arrays required in the main loop
            nno = 1:L-1;
            nnop1 = 2:L;
            nnL = 1:L;
            
            % Main Loop
            for n=1:ntr
                % Compute a priori forward prediction error
                phi = x(n) - A*X;
                
                % Update augmented Kalman gain vector quantities
                rf = olam*invAlpha*phi;
                KtLp1 = [rf; Kt-rf*A'];
                invgamLp1 = 1/gamma + real(conj(rf)*phi);
                
                % Update forward prediction filter coefficients and least-squares error inverse
                f = phi*gamma;          % a posteriori forward prediction error
                A = A + Kt'*f;          % forward prediction filter coefficients
                % forward prediction least-squares error inverse
                invAlpha = olam*invAlpha - real(conj(rf)*rf)/invgamLp1;
                
                % Update input signal buffer for Kalman gain updates
                xold = X(L);            % save last input signal sample in buffer
                X(nnop1) = X(nno);
                X(1) = x(n);
                
                % Compute a priori backward prediction error samples for stabilized updates
                rbs = KtLp1(L+1);
                psis = lam*beta*rbs;        % a priori backward prediction error (state)
                psif = xold - G*X;          % a priori backward prediction error (filter)
                psierror = psif-psis;       % numerical difference in backward prediction errors
                psi1 = Ki1*psierror + psis; % a priori backward prediction error (1)
                psi2 = Ki2*psierror + psis; % a priori backward prediction error (2)
                
                % Update Kalman gain vector quantities
                rb = rbs + Ki4*(psif/(lam*beta) - rbs);
                Kt = KtLp1(nnL) + rb*G';
                gams = 1/(invgamLp1 - real(conj(rbs)*psif));
                
                % Update backward prediction filter coefficients and least-squares error
                b1 = psi1*gams;         % a posteriori backward prediction error (1)
                b2 = psi2*gams;         % a posteriori backward prediction error (1)
                G = G + b1*Kt';         % backward prediction filter coefficients
                beta = lam*beta + real(conj(psi2)*b2);    % backward prediction least-squares error
                
                % Compute current conversion factor
                gamma = lamL*beta*invAlpha;
                
                % Check range of conversion factor and perform Kalman gain
                % rescue if out of range. Conversion factor must be within
                % the range [0,1].
                if (gamma > 1) || (gamma < 0)
                    % Reset Kalman gain updates
                    A = zeroRowVector;      % initialize forward coefficient vector
                    invAlpha = lam/(lamL*delta);        % initialize forward least-squares error inverse
                    G = zeroRowVector;      % initialize backward coefficient vector
                    beta = delta;           % initialize backward least-squares error
                    gamma = cast(1,inputDataTypeLocal); % initialize conversion factor
                    Kt = zeroRowVector';    % initialize un-normalized Kalman gain vector
                    X = zeroRowVector.';    % initialize input signal buffer
                    
                    % Increment number of rescues
                    numRescues = numRescues + 1;
                    
                    % Stop function call if number of rescues is excessive
                    coder.internal.errorIf((numRescues > 4)&&(n/numRescues < 4*L), ...
                        'dsp:system:FastTransversalFilter:excessiveKalmanRescues');
                end
                
                % Update input signal buffer for output and error calculations
                Xo(nnop1) = Xo(nno);
                Xo(1) = x(n);
                
                % Compute output signal and error signal
                y(n) = W*Xo;        % compute and assign current output signal sample
                e(n) = d(n) - y(n); % compute and assign current error signal sample
                
                % Update filter coefficient vector
                if ~lockCoeffs
                    W = W + gamma*e(n)*Kt';
                end
            end
            
            % Save states
            obj.Coefficients = dsp.private.copyMatrix(W,obj.Coefficients);  % Save final coefficient vector
            obj.States = dsp.private.copyMatrix(Xo,obj.States);             % Save final internal filter states
            saveFTFDiscreteStates(obj,X,Kt,gamma,A,G,invAlpha,beta);
        end
        
        %stepSWFTF A helper method to stepImpl that implements the core
        % algorithm of Sliding-window fast transversal least-squares
        % adaptive filter.
        function [y,e] = stepSWFTF(obj, x, d)
            % Load the required DiscreteState properties
            W = obj.Coefficients;   % Load coefficient vector
            Xo = obj.States;        % Load internal filter states
            D = obj.DesiredStates;  % Load desired states
            [X,Kt,gamma,A,G,invAlpha,beta] = loadFTFDiscreteStates(obj);
            
            % Load the required constant properties
            L = obj.Length;
            N = obj.SlidingWindowBlockLength;
            params = obj.FilterParameters;
            delta = params.InitialPredictionErrorPower;
            lockCoeffs = params.LockCoefficients;
            inputDataTypeLocal = obj.InputDataType;
            
            % Initialize output variables
            [y,e,ntr] = initializeVariables(obj,size(x));
            
            % Assign L-element vector of zeros for rescues
            if isreal(X)
                zeroRowVector = zeros(1,L,inputDataTypeLocal);
            else
                zeroRowVector = complex(zeros(1,L,inputDataTypeLocal));
            end
            
            % Initialize number of Kalman rescues
            numRescues = 0;
            
            % Cache the index arrays required in the main loop
            nnL = 1:L;
            nnN = 1:N-1;
            nno = 1:L+N-1;
            nnLp1 = nnL + 1;
            nnNp1 = nnN + 1;
            nnop1 = nno + 1;
            nnLpN = nnL + N;
            nnLpNm1 = nnLpN - 1;
            Lp1 = L + 1;
            LpN = L + N;
            
            % Main Loop
            for n=1:ntr
                % Update input and desired signal buffers by shifting down
                % the buffers and assigning the current samples
                D(nnNp1) = D(nnN);
                D(1) = d(n);
                X(nnop1) = X(nno);
                X(1) = x(n);
                Xo(nnop1) = Xo(nno);
                Xo(1) = x(n);
                
                % Fast update for leading Kalman gain vector
                [A,invAlpha,KtLp1,invgamLp1] = forwardPredictionUpdate( ...
                    obj,A,invAlpha,Kt(:,1),gamma(1),X(nnLp1),X(1));
                [G,beta,Kt(:,1),gamma(1)] = backwardPredictionUpdate( ...
                    obj,G,beta,KtLp1(nnL),KtLp1(L+1),invgamLp1,X(nnL),X(Lp1));
                
                % Fast "down-date" for trailing Kalman gain vector
                [A,invAlpha,KtLp1,invgamLp1] = forwardPredictionUpdate( ...
                    obj,A,invAlpha,Kt(:,2),gamma(2),X(nnLpN),X(N));
                [G,beta,Kt(:,2),gamma(2)] = backwardPredictionUpdate( ...
                    obj,G,beta,KtLp1(nnL),KtLp1(Lp1),invgamLp1,X(nnLpNm1),X(LpN));
                
                % Compute conversion factor for stabilized Kalman updates
                if (rem(n,2)==0)
                    gamma(1) = -beta*invAlpha/gamma(2);
                else
                    gamma(2) = -beta*invAlpha/gamma(1);
                end
                
                % Check range of conversion factor and perform Kalman gain
                % rescue if out of range. The first element of the
                % ConversionFactor property must be within the range (0,1].
                if (gamma(1) > 1) || (gamma(1) <= 0)
                    % Reset Kalman gain updates
                    A = zeroRowVector;      % initialize forward coefficient vector
                    invAlpha = 1/delta;     % initialize forward least-squares error inverse
                    G = zeroRowVector;      % initialize backward coefficient vector
                    beta = delta;           % initialize backward least-squares error
                    gamma = cast([1 -1],inputDataTypeLocal);    % initialize conversion factors
                    Kt = [zeroRowVector.' zeroRowVector.'];     % initialize un-normalized Kalman gain vector
                    X = zeros(L+N,1,inputDataTypeLocal);        % initialize input signal States
                    
                    % Increment number of rescues
                    numRescues = numRescues + 1;
                    
                    % Stop function call if number of rescues is excessive
                    coder.internal.errorIf((numRescues > 4)&&(n/numRescues < 4*L), ...
                        'dsp:system:FastTransversalFilter:excessiveKalmanRescues');
                end
                
                % Compute output signal and error signal
                y(n) = W*Xo(nnL);       % compute and assign current output signal sample
                e(n) = d(n) - y(n);     % compute and assign current error signal sample
                
                % Update and "down-date" adaptive filter coefficient vector
                if ~lockCoeffs
                    % update adaptive filter coefficient vector
                    W = W + gamma(1)*e(n)*Kt(:,1)';
                    
                    % "down-date" adaptive filter coefficient vector
                    yN = W * Xo(nnLpNm1);
                    eN = D(N) - yN;
                    W = W + gamma(2)*eN*Kt(:,2)';
                end
            end
            
            % Save states
            obj.Coefficients = dsp.private.copyMatrix(W,obj.Coefficients);  % Save final coefficient vector
            obj.States = dsp.private.copyMatrix(Xo,obj.States);             % Save final internal filter states
            obj.DesiredStates = dsp.private.copyMatrix(D,obj.DesiredStates);% Save final desired states
            saveFTFDiscreteStates(obj,X,Kt,gamma,A,G,invAlpha,beta);
        end
        
        %forwardPredictionUpdate A helper method to perform the forward
        % prediction update in Sliding-window Fast Transversal Filter.
        function [Anew,invalphnew,KtLp1,invgamLp1] = ...
                forwardPredictionUpdate(~,A,invalph,Kt,gam,X,xnew)
            phi = xnew - A*X;           % Compute a priori forward prediction error
            rf = invalph*phi;           % Update augmented Kalman gain vector quantities
            KtLp1 = [rf; Kt-rf*A'];
            invgamLp1 = 1/gam + real(conj(rf)*phi);
            f = phi*gam;                % a posteriori forward prediction error
            Anew = A + Kt'*f;           % forward prediction filter coefficients
            invalphnew = invalph - real(conj(rf)*rf)/invgamLp1;  % least-squares error inverse
        end
        
        %backwardPredictionUpdate A helper method to perform the backward
        % prediction update in Sliding-window Fast Transversal Filter.
        function [Gnew,betnew,Kt,gam] = ...
                backwardPredictionUpdate(~,G,bet,KtLp1L,rbs,invgamLp1,X,xold)
            Ki1 = 0.75*sign(invgamLp1);   % error feedback constant
            Ki2 = 0.75*sign(invgamLp1)+1; % error feedback constant
            psis = bet*rbs;             % a priori backward prediction error (state)
            psif = xold - G*X;          % a priori backward prediction error (filter)
            psierror = psif-psis;       % numerical difference in backward prediction errors
            psi1 = Ki1*psierror + psis; % a priori backward prediction error (1)
            psi2 = Ki2*psierror + psis; % a priori backward prediction error (2)
            Kt = KtLp1L + rbs*G';       % Kalman gain vector
            gam = 1/(invgamLp1 - real(conj(rbs)*psif));
            b1 = psi1*gam;              % a posteriori backward prediction error (1)
            b2 = psi2*gam;              % a posteriori backward prediction error (2)
            Gnew = G + b1*Kt';          % backward prediction filter coefficients
            betnew = bet + real(conj(psi2)*b2);  % backward prediction least-squares error
        end
        
        %getFilterParameterStruct This is a helper method that creates and
        % returns a filter parameters structure. Each of the filter
        % parameters are casted to the InputDataType property value.
        function filterParams = getFilterParameterStruct(obj)
            if strcmp(obj.Method, 'Fast transversal least-squares')
                inputDataTypeLocal = obj.InputDataType;
                filterParams = struct('ForgettingFactor', ...
                    cast(obj.ForgettingFactor,inputDataTypeLocal), ...
                    'InitialPredictionErrorPower', ...
                    cast(obj.InitialPredictionErrorPower, inputDataTypeLocal), ...
                    'LockCoefficients', obj.LockCoefficients);
            else
                filterParams = struct('InitialPredictionErrorPower', ...
                    cast(obj.InitialPredictionErrorPower, obj.InputDataType), ...
                    'LockCoefficients', obj.LockCoefficients);
            end
        end
        
        %initializeVariables This is a helper method to the stepImpl
        % method. This method is used to initialize output variables and
        % temporary variables required in the main loop of the stepImpl
        % method.
        function [y,e,ntr] = initializeVariables(obj,Sx)
            ntr = max(Sx);                      % temporary number of iterations
            if isreal(obj.Coefficients)         % initialize output signal vector
                y = zeros(Sx,obj.InputDataType);
            else
                y = complex(zeros(Sx,obj.InputDataType));
            end
            e = y;                      % initialize error signal vector
        end
        
        %loadFTFDiscreteStates This is a helper method to the stepImpl
        % method. This is used to to load all the DiscreteState properties
        % specific to fast transversal adaptive filter.
        function [X,Kt,gamma,A,G,invAlpha,beta] = loadFTFDiscreteStates(obj)
            X = obj.KalmanGainStates;       % Kalman gain states
            gamma = obj.ConversionFactor;   % Conversion factor
            
            % Load forward and backward prediction coefficient vectors.
            A = obj.ForwardPredictionCoefficients;
            G = obj.BackwardPredictionCoefficients;
            
            % Load forward and backward prediction least-squares error
            invAlpha = 1/obj.ForwardPredictionErrorPower;
            beta = obj.BackwardPredictionErrorPower;
            
            % Load un-normalized Kalman gain vector
            Kt = obj.KalmanGain;
            if strcmp(obj.Method, 'Fast transversal least-squares')
                Kt = Kt/gamma;              % Kalman gain vector
            else
                Kt(:,1) = Kt(:,1)/gamma(1); % Leading Kalman gain vector
                Kt(:,2) = Kt(:,2)/gamma(2); % Trailing Kalman gain vector
            end
        end
        
        %saveFTFDiscreteStates This is a helper method to the stepImpl
        % method. This method is used to save all the DiscreteState
        % properties specific to fast transversal adaptive filter.
        function saveFTFDiscreteStates(obj,X,Kt,gamma,A,G,invAlpha,beta)
            % Save final conversion factor
            obj.ConversionFactor = gamma;
            % Save final Kalman gain States
            obj.KalmanGainStates = dsp.private.copyMatrix(X, obj.KalmanGainStates);
            
            % Save final Kalman gain vector
            if strcmp(obj.Method, 'Fast transversal least-squares')
                Kt = Kt*gamma;              % final Kalman gain vector
            else
                Kt(:,1) = Kt(:,1)*gamma(1); % final leading Kalman gain vector
                Kt(:,2) = Kt(:,2)*gamma(2); % final trailing Kalman gain vector
            end
            obj.KalmanGain = dsp.private.copyMatrix(Kt, obj.KalmanGain);
            
            % Save final forward and backward prediction coefficients
            obj.ForwardPredictionCoefficients = dsp.private.copyMatrix(A, ...
                obj.ForwardPredictionCoefficients);
            obj.BackwardPredictionCoefficients = dsp.private.copyMatrix(G, ...
                obj.BackwardPredictionCoefficients);
            
            % Save final forward and backward prediction error powers
            obj.ForwardPredictionErrorPower = 1/invAlpha;
            obj.BackwardPredictionErrorPower = beta;
        end
        
        function N = getNumInputsImpl(~)
            % Specify number of System inputs
            N = 2;
        end
        
        function N = getNumOutputsImpl(~)
            % Specify number of System outputs
            N = 2;
        end
        
        %isInactivePropertyImpl This overloaded method is used to flag some
        % of the irrelevant properties based on the Method property value
        % as inactive.
        function flag = isInactivePropertyImpl(obj, prop)
            flag = false;
            methodLocal = obj.Method;
            switch prop
                case 'ForgettingFactor'
                    if ~strcmp(methodLocal, 'Fast transversal least-squares')
                        flag = true;
                    end
                case {'SlidingWindowBlockLength', 'DesiredStates'}
                    if strcmp(methodLocal, 'Fast transversal least-squares')
                        flag = true;
                    end
            end
        end
        
        %getDiscreteStateImpl This overloaded method is used to get all the
        % active DiscreteState properties of the object as a structure.
        function discreteStates = getDiscreteStateImpl(obj)
            if strcmp(obj.Method, 'Fast transversal least-squares')
                discreteStates = struct( ...
                    'Coefficients', obj.Coefficients, ...
                    'States', obj.States, ...
                    'KalmanGain', obj.KalmanGain, ...
                    'KalmanGainStates', obj.KalmanGainStates, ...
                    'ConversionFactor', obj.ConversionFactor, ...
                    'ForwardPredictionCoefficients', obj.ForwardPredictionCoefficients, ...
                    'BackwardPredictionCoefficients', obj.BackwardPredictionCoefficients, ...
                    'ForwardPredictionErrorPower', obj.ForwardPredictionErrorPower, ...
                    'BackwardPredictionErrorPower', obj.BackwardPredictionErrorPower ...
                    );
            else
                discreteStates = struct( ...
                    'Coefficients', obj.Coefficients, ...
                    'States', obj.States, ...
                    'DesiredStates', obj.DesiredStates, ...
                    'KalmanGain', obj.KalmanGain, ...
                    'KalmanGainStates', obj.KalmanGainStates, ...
                    'ConversionFactor', obj.ConversionFactor, ...
                    'ForwardPredictionCoefficients', obj.ForwardPredictionCoefficients, ...
                    'BackwardPredictionCoefficients', obj.BackwardPredictionCoefficients, ...
                    'ForwardPredictionErrorPower', obj.ForwardPredictionErrorPower, ...
                    'BackwardPredictionErrorPower', obj.BackwardPredictionErrorPower ...
                    );
            end
        end
        
        %saveObjectImpl This overloaded method is used to save all the
        % active properties of the object, including the required private
        % and protected ones, when the object is saved.
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@matlab.System(obj);
            
            % Save the private properties
            s.privInitialConversionFactorFTF = obj.privInitialConversionFactorFTF;
            s.privInitialConversionFactorSWFTF = obj.privInitialConversionFactorSWFTF;
            s.privSlidingWindowBlockLength = obj.privSlidingWindowBlockLength;
            s.privSlidingWindowBlockLengthDefined = obj.privSlidingWindowBlockLengthDefined;
            
            % Save the InputDataType property if the object is locked.
            if isLocked(obj)
                s.InputDataType = obj.InputDataType;
            end
        end
        
        %loadObjectImpl This overloaded method is used to load all the
        % active properties of the object, including the private and
        % protected ones, when the object is loaded.
        function loadObjectImpl(obj, s, wasLocked)
            loadObjectImpl@matlab.System(obj, s, wasLocked);
            
            % Load the private properties
            obj.privInitialConversionFactorFTF = s.privInitialConversionFactorFTF;
            obj.privInitialConversionFactorSWFTF = s.privInitialConversionFactorSWFTF;
            obj.privSlidingWindowBlockLength = s.privSlidingWindowBlockLength;
            obj.privSlidingWindowBlockLengthDefined = s.privSlidingWindowBlockLengthDefined;
            
            % Load the InputDataType property and the FilterParameters
            % property if the object was locked.
            if wasLocked
                obj.InputDataType = s.InputDataType;
                obj.FilterParameters = getFilterParameterStruct(obj);
            end
        end
    end
end
