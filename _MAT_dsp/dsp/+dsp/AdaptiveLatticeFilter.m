classdef AdaptiveLatticeFilter < matlab.System
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

%#codegen
    
    properties (Nontunable)
        %Method Method to calculate the filter coefficients
        %   Specify the method used to calculate filter coefficients as one
        %   of [{'Least-squares Lattice'} | 'QR-decomposition Least-squares
        %   Lattice' | 'Gradient Adaptive Lattice'].
        Method = 'Least-squares Lattice';
    end
    
    properties (Nontunable, PositiveInteger)
        %Length Length of the filter coefficients vector
        %   Specify the length of the FIR filter coefficients vector as a
        %   positive integer value. The default value of this property is
        %   32.
        Length = 32;
    end
    
    properties
        %ForgettingFactor Least-squares lattice forgetting factor
        %   Specify the Least-squares lattice forgetting factor as a scalar
        %   positive numeric value less than or equal to 1. Setting this
        %   property value to 1 denotes infinite memory while adapting.
        %   This property applies only if the Method property is set to
        %   'Least-squares Lattice' or 'QR-decomposition Least-squares
        %   Lattice'. The default value of this property is 1.
        ForgettingFactor = 1;
        
        %StepSize Joint process step size of the gradient adaptive filter
        %   Specify the joint process step size of the gradient adaptive
        %   lattice filter as a positive numeric scalar less than or equal
        %   to 1. This property applies only if the Method property is set
        %   to 'Gradient Adaptive Lattice'. The default value of this
        %   property is 0.1.
        StepSize = 0.1;
        
        %Offset Offset for the denominator of StepSize normalization term
        %   Specify an offset value for the denominator of the StepSize
        %   normalization term as a non-negative numeric scalar. A non-zero
        %   offset is useful to avoid a divide-by-near-zero if the input
        %   signal amplitude is very small. This property applies only if
        %   the Method property is set to 'Gradient Adaptive Lattice'. The
        %   default value of this property is 1.
        Offset = 1;
    end
    
    properties (Dependent)
        %ReflectionStepSize Reflection process step size
        %   Specify the reflection process step size of the gradient
        %   adaptive lattice filter as a scalar numeric value between 0 and
        %   1, both inclusive. This property applies only if the Method
        %   property is set to 'Gradient Adaptive Lattice'. The default
        %   value of this property is set to the StepSize property value.
        ReflectionStepSize;
        
        %AveragingFactor Averaging factor of the energy estimator
        %   Specify the averaging factor as a positive numeric scalar less
        %   than 1. This property is used to compute the exponentially
        %   windowed forward and backward prediction error powers for the
        %   coefficient updates. This property applies only if the Method
        %   property is set to 'Gradient Adaptive Filter'. The default
        %   value of this property is set to the value of (1 - StepSize).
        AveragingFactor;
        
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
    end
    
    properties
        %InitialCoefficients Initial coefficients of the filter
        %   Specify the initial values of the FIR adaptive filter
        %   coefficients as a scalar or a vector of length equal to the
        %   Length property value. The default value of this property is 0.
        InitialCoefficients = 0;
    end
    
    properties (Logical)
        %LockCoefficients Locked status of the coefficient updates
        %   Specify whether the filter coefficient values should be locked.
        %   By default, the value of this property is false, and the object
        %   continuously updates the filter coefficients. If this property
        %   is set to true, the filter coefficients do not get updated and
        %   their values remain at the current value. This property is
        %   applicable only if the Method property is set to 'Gradient
        %   Adaptive Lattice'.
        LockCoefficients = false;
    end
    
    properties (DiscreteState)
        %Coefficients Current coefficients of the filter
        %   This property stores the current coefficients of the filter as
        %   a row vector of length equal to the Length property value. This
        %   property is initialized to the values of the
        %   InitialCoefficients property.
        Coefficients;
        
        %States Current internal states of the filter
        %   This property stores the current internal states of the filter
        %   as a column vector. Its length is equal to the Length property
        %   value. This property is initialized to a vector of zeros of
        %   appropriate length and data type.
        States;
        
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
        
        %BackwardPredictionCoefficients Backward prediction coefficients
        %   This property stores the current backward reflection
        %   coefficients as a row vector. Its length is equal to L-1, where
        %   L is the Length property value. This property applies only if
        %   the Method property is set to 'Least-squares Lattice' or
        %   'QR-decomposition Least-squares Lattice'. This property is
        %   initialized to a vector of zeros of appropriate length and data
        %   type.
        BackwardPredictionCoefficients;
        
        %ReflectionCoefficients Reflection coefficient vector
        %   This property stores the current reflection coefficients as a
        %   row vector. Its length is equal to L-1, where L is the Length
        %   property value. This property applies only if the Method
        %   property is set to 'Gradient Adaptive Lattice'. This property
        %   is initialized to a vector of zeros of appropriate length and
        %   data type.
        ReflectionCoefficients;
        
        %ForwardPredictionErrorPower Forward prediction error powers
        %   This property stores the current forward prediction
        %   least-squares error power as a column vector. Its length is
        %   equal to the Length property value. All the elements of this
        %   vector are initialized to the InitialPredictionErrorPower
        %   property value.
        ForwardPredictionErrorPower;
        
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
    end
    
    properties (Access=protected)
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
        
        %privReflectionStepSize A private property to store the value set
        %   to the ReflectionStepSize property.
        privReflectionStepSize = 0.1;
        
        %privAveragingFactor A private property to store the value set to
        %   the AveragingFactor property.
        privAveragingFactor = 0.9;
        
        %privInitialPredictionErrorPowerLSL A private property to store
        %   the default value of the InitialPredictionErrorPower property
        %   if the Method property is set to 'Least-squares Lattice' or
        %   'QR-decomposition Least-squares Lattice'. If the
        %   InitialPredictionErrorPower property is explicitly set, this
        %   property must be updated.
        privInitialPredictionErrorPowerLSL = 1;
        
        %privInitialPredictionErrorPowerGAL A private property to store
        %   the default value of the InitialPredictionErrorPower property
        %   if the Method property is set to 'Gradient Adaptive Lattice'.
        %   If the InitialPredictionErrorPower property is explicitly set,
        %   this property must be updated.
        privInitialPredictionErrorPowerGAL = 0.1;
    end
    
    properties (Access=protected, Logical)
        %privReflectionStepSizeDefined A Private logical property to denote
        %   whether the ReflectionStepSize property has been explicitly
        %   set.
        privReflectionStepSizeDefined = false;
        
        %privAveragingFactorDefined A Private logical property to denote
        %   whether the AveragingFactor property has been explicitly set.
        privAveragingFactorDefined = false;
    end
    
    properties (Access=protected, Nontunable)
        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs. It is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;
    end
    
    properties(Constant, Hidden)
        %MethodSet String set to specify the valid string values for the
        %   Method property.
        MethodSet = matlab.system.StringSet( { ...
            'Least-squares Lattice', ...
            'QR-decomposition Least-squares Lattice', ...
            'Gradient Adaptive Lattice'} );
    end
    
    
    methods
        % AdaptiveLatticeFilter constructor
        function obj = AdaptiveLatticeFilter(varargin)
            % Support name-value pair arguments as well as alternatively
            % allow the Length property to be a value-only argument.
            setProperties(obj, nargin, varargin{:}, 'Length');
        end
        
        % Validating and setting ForgettingFactor
        function set.ForgettingFactor(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val > 0 && val <= 1 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeRealScalar0to1LeftOpen', 'ForgettingFactor');
            obj.ForgettingFactor = val;
        end
        
        % Validating and setting StepSize
        function set.StepSize(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val > 0 && val <= 1 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeRealScalar0to1LeftOpen', 'StepSize');
            obj.StepSize = val;
        end
        
        % Validating and setting Offset
        function set.Offset(obj,val)
            coder.internal.errorIf(~(isscalar(val) && isnumeric(val) && val >= 0 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeNonNegativeRealScalar', 'Offset');
            obj.Offset = val;
        end
        
        % Validating and setting InitialCoefficients
        function set.InitialCoefficients(obj,val)
            coder.internal.errorIf(~(isvector(val) && isnumeric(val) && all(isfinite(val))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericVector', 'InitialCoefficients');
            obj.InitialCoefficients = val(:).';
        end
        
        % Validating and setting ReflectionStepSize. Since
        % ReflectionStepSize is a dependent property, the value set to it
        % is stored in the privReflectionStepSize private property and the
        % logical property privReflectionStepSizeDefined is set to true.
        function set.ReflectionStepSize(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val >= 0 && val <= 1 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeRealScalar0to1Closed', 'ReflectionStepSize');
            obj.privReflectionStepSize = val;
            obj.privReflectionStepSizeDefined = true;
        end
        
        % Get method for the ReflectionStepSize dependent property. If the
        % ReflectionStepSize property is not explicityly set, this method
        % returns the StepSize property value as the default for the
        % ReflectionStepSize property.
        function val = get.ReflectionStepSize(obj)
            if obj.privReflectionStepSizeDefined
                val = obj.privReflectionStepSize;
            else
                val = obj.StepSize;
            end
        end
        
        % Validating and setting AveragingFactor. Since AveragingFactor is
        % a dependent property, the value set to it is stored in the
        % privAveragingFactor private property and the logical property
        % privAveragingFactorDefined is set to true.
        function set.AveragingFactor(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val > 0 && val < 1 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeRealScalar0to1Open', 'AveragingFactor');
            obj.privAveragingFactor = val;
            obj.privAveragingFactorDefined = true;
        end
        
        % Get method for the AveragingFactor dependent property. If the
        % AveragingFactor property is not explicitly set, this method
        % returns the value of (1 - StepSize) as the default for the
        % AveragingFactor property.
        function val = get.AveragingFactor(obj)
            if obj.privAveragingFactorDefined
                val = obj.privAveragingFactor;
            else
                val = 1 - obj.StepSize;
            end
        end
        
        % Validating and setting InitialPredictionErrorPower. Since
        % InitialPredictionErrorPower is a dependent property, the value
        % set to it is stored in both the private properties, viz,
        % privInitialPredictionErrorPowerLSL and
        % privInitialPredictionErrorPowerGAL.
        function set.InitialPredictionErrorPower(obj,val)
            coder.internal.errorIf(~(isscalar(val) && isnumeric(val) && val > 0 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBePositiveRealScalar', 'InitialPredictionErrorPower');
            obj.privInitialPredictionErrorPowerLSL = val;
            obj.privInitialPredictionErrorPowerGAL = val;
        end
        
        % Get method for the InitialPredictionErrorPower dependent
        % property. If the InitialPredictionErrorPower is not explicitly
        % set, this method returns the default value based on the Method
        % property value.
        function val = get.InitialPredictionErrorPower(obj)
            if strcmp(obj.Method, 'Gradient Adaptive Lattice')
                val = obj.privInitialPredictionErrorPowerGAL;
            else
                val = obj.privInitialPredictionErrorPowerLSL;
            end
        end
    end
    
    methods(Static, Access=protected)
        function group = getPropertyGroupsImpl
            % Get default parameters group for this System object
            group = matlab.system.display.Section('dsp.AdaptiveLatticeFilter', ...
                'DependOnPrivatePropertyList', {'ReflectionStepSize', 'AveragingFactor',  'InitialPredictionErrorPower'}); %#ok<EMCA>
        end
    end
    
    methods (Access=protected)
        
        function validatePropertiesImpl(obj)
            % Validating the dimensions of the InitialCoefficients property
            coder.internal.errorIf(~(any(length(obj.InitialCoefficients)==[1,obj.Length])), ...
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
            
            % Temporary vector of zeros
            zeroColumnVector = zeros(L,1,inputDataTypeLocal);
            
            % Initialize Coefficients to zeros of appropriate complexity
            % and data type.
            if realInputX && isreal(d) && isreal(obj.InitialCoefficients)
                obj.Coefficients = zeros(1,L,inputDataTypeLocal);
            else
                obj.Coefficients = complex(zeros(1,L,inputDataTypeLocal));
            end
            
            % Initialize States to zeros of appropriate complexity and data
            % type.
            if realInputX
                obj.States = zeroColumnVector;
            else
                obj.States = complex(zeroColumnVector);
            end
            
            % Initialize ForwardPredictionErrorPower and
            % BackWardPredictionErrorPower to zeros.
            obj.ForwardPredictionErrorPower = zeroColumnVector;
            obj.BackwardPredictionErrorPower = zeroColumnVector;
            
            % Initialize the reflection coefficients to zeros of
            % appropriate complexity and data type.
            zeroReflectionCoefficients = zeros(1,L-1,inputDataTypeLocal);
            switch obj.Method
                case 'Least-squares Lattice'
                    if realInputX
                        obj.ForwardPredictionCoefficients = zeroReflectionCoefficients;
                        obj.BackwardPredictionCoefficients = zeroReflectionCoefficients;
                    else
                        obj.ForwardPredictionCoefficients = complex(zeroReflectionCoefficients);
                        obj.BackwardPredictionCoefficients = complex(zeroReflectionCoefficients);
                    end
                case 'QR-decomposition Least-squares Lattice'
                    if realInputX
                        obj.ForwardPredictionCoefficients = zeros(1,L,inputDataTypeLocal);
                        obj.BackwardPredictionCoefficients = zeroReflectionCoefficients;
                    else
                        obj.ForwardPredictionCoefficients = complex(zeros(1,L,inputDataTypeLocal));
                        obj.BackwardPredictionCoefficients = complex(zeroReflectionCoefficients);
                    end
                case 'Gradient Adaptive Lattice'
                    obj.ReflectionCoefficients = zeroReflectionCoefficients;
            end
        end
        
        function resetImpl(obj)
            % Initialize Coefficients to InitialCoefficients.
            obj.Coefficients = dsp.private.copyMatrix(obj.InitialCoefficients, ...
                obj.Coefficients);
            
            % Initialize States to zeros.
            obj.States = dsp.private.copyMatrix(0, obj.States);
            
            % Initialize the ForwardPredictionErrorPower DiscreteState
            % property to the value of InitialPredictionErrorPower property
            intialPredictionErrorPowerLocal = obj.InitialPredictionErrorPower;
            obj.ForwardPredictionErrorPower(:) = intialPredictionErrorPowerLocal;
            
            % Initialize the BackwardPredictionErrorPower DiscreteState
            % property to the value of InitialPredictionErrorPower or
            % (InitialPredictionErrorPower/ForgettingFactor) depending on
            % the Method property value. Also initialize the reflection
            % coefficients to vector of zeros of appropriate length,
            % complexity and data type.
            if strcmp(obj.Method, 'Gradient Adaptive Lattice')
                obj.BackwardPredictionErrorPower(:) = intialPredictionErrorPowerLocal;
                obj.ReflectionCoefficients(:) = 0;
            else
                obj.BackwardPredictionErrorPower(:) = ...
                    intialPredictionErrorPowerLocal/obj.ForgettingFactor;
                obj.ForwardPredictionCoefficients = dsp.private.copyMatrix(0, ...
                    obj.ForwardPredictionCoefficients);
                obj.BackwardPredictionCoefficients = dsp.private.copyMatrix(0, ...
                    obj.BackwardPredictionCoefficients);
            end
        end
        
        function processTunedPropertiesImpl(obj)
            % If the tunable properties are changed, update the
            % FilterParameters private property that stores their
            % type-casted version in a structure.
            if strcmp(obj.Method, 'Gradient Adaptive Lattice')
                inputDataTypeLocal = obj.InputDataType;
                obj.FilterParameters.StepSize = ...
                    cast(obj.StepSize,inputDataTypeLocal);
                obj.FilterParameters.Offset = ...
                    cast(obj.Offset,inputDataTypeLocal);
                obj.FilterParameters.ReflectionStepSize = ...
                    cast(obj.ReflectionStepSize,inputDataTypeLocal);
                obj.FilterParameters.AveragingFactor = ...
                    cast(obj.AveragingFactor,inputDataTypeLocal);
                obj.FilterParameters.LockCoefficients = ...
                    obj.LockCoefficients;
            else
                obj.FilterParameters.ForgettingFactor = ...
                    cast(obj.ForgettingFactor,obj.InputDataType);
            end
        end
        
        function [y,e] = stepImpl(obj, x, d)
            switch obj.Method
                case 'Least-squares Lattice'
                    [y,e] = stepLSL(obj, x, d);
                case 'QR-decomposition Least-squares Lattice'
                    [y,e] = stepQRDLSL(obj, x, d);
                case 'Gradient Adaptive Lattice'
                    [y,e] = stepGAL(obj, x, d);
            end
        end
        
        %stepLSL A helper method to stepImpl that implements the core
        % algorithm of Least-squares Lattice FIR adaptive filter.
        function [y,e] = stepLSL(obj, x, d)
            % Initialize output variables
            [y,e,ntr] = initializeVariables(obj,size(x));
            
            % Load the required constant properties
            L = obj.Length;
            lam = obj.FilterParameters.ForgettingFactor;  % assign ForgettingFactor
            
            % Load the required DiscreteState properties
            [H,psi,alpha,beta] = loadCommonDiscreteStates(obj);
            rhoFwd = obj.ForwardPredictionCoefficients;     % assign forward reflection coefficient vector
            rhoBwd = obj.BackwardPredictionCoefficients;    % assign backward reflection coefficient vector
            
            % Initialize the required temporarty variables
            phi = psi;          % initialize temporary forward prediction error buffer
            E   = [H, 0].';     % initialize temporary joint process error buffer
            gamma  = alpha;     % initialize temporary conversion factor buffer
            betaNew = beta;     % initialize temporary backward least-squares error buffer
            
            % First iteration of forward/backward prediction updates
            
            phi(1) = x(1);      % assign current input sample
            gamma(1) = 1;       % initialize conversion factor
            psiSquared = real(psi.*conj(psi));    % compute square of backward errors
            
            % order-recursive updates
            for i=1:L-1
                beta(i) = lam*beta(i) + gamma(i)*psiSquared(i);   % update backward least-squares errors
                phi(i+1) = phi(i) + psi(i)*conj(rhoFwd(i)); % compute forward prediction errors
                gamma(i+1) = gamma(i) - gamma(i)^2*psiSquared(i)/beta(i); % compute conversion factors
            end
            
            % Update reflection coefficients and errors
            beta(L) = lam*beta(L) + gamma(L)*psiSquared(L);     % update last backward least-squares error
            alpha = real(lam*alpha + gamma.*phi.*conj(phi));    % update forward least-squares errors
            rhoFwd = rhoFwd - (gamma(1:L-1).*psi(1:L-1).*conj(phi(2:L))./beta(1:L-1)).';    % update forward reflection coefficients
            psi(:) = [x(1); psi(1:L-1)+phi(1:L-1).*rhoBwd'];    % compute backward prediction errors and shift down psi
            rhoBwd = rhoBwd - (gamma(1:L-1).*phi(1:L-1).*conj(psi(2:L))./alpha(1:L-1)).';   % update backward reflection coefficients
            
            % Main Loop
            for n=1:ntr-1
                phi(1) = x(n+1);                    % assign future input sample
                gamma(1) = 1;                       % initialize conversion factor
                psiSquared = real(psi.*conj(psi));  % compute square of backward errors
                E(1) = d(n);                        % assign current desired signal
                % order-recursive updates
                for i=1:L-1
                    beta(i) = lam*beta(i) + gamma(i)*psiSquared(i); % update backward least-squares errors
                    phi(i+1) = phi(i) + psi(i)*conj(rhoFwd(i));     % compute forward prediction errors
                    gamma(i+1) = gamma(i) - gamma(i)^2*psiSquared(i)/beta(i);   % compute conversion factors
                    E(i+1) = E(i) - psi(i)*conj(H(i));              % compute joint process errors
                end
                beta(L) = lam*beta(L) + gamma(L)*psiSquared(L); % update last backward least-squares error
                E(L+1) = E(L) - psi(L)*conj(H(L));              % compute last joint process error
                H = H + (gamma.*psi.*conj(E(2:L+1))./beta).';   % update joint process coefficients
                alpha = real(lam*alpha + gamma.*phi.*conj(phi));    % update forward least-squares errors
                rhoFwd = rhoFwd - (gamma(1:L-1).*psi(1:L-1).*conj(phi(2:L))./beta(1:L-1)).';    % update forward reflection coefficients
                psi(:) = [x(n+1); psi(1:L-1)+phi(1:L-1).*rhoBwd'];  % compute backward prediction errors an shift down
                rhoBwd = rhoBwd - (gamma(1:L-1).*phi(1:L-1).*conj(psi(2:L))./alpha(1:L-1)).';   % update backward reflection coefficients
                e(n) = E(L+1);              % assign current error sample
                y(n) = d(n) - e(n);         % compute current output sample
            end
            
            % Last iteration of joint process estimation updates
            E(1) = d(ntr);                      % assign current desired signal
            gamma(1) = 1;                       % initialize conversion factor
            psiSquared = real(psi.*conj(psi));  % compute square of backward errors
            % order-recursive updates
            for i=1:L-1
                betaNew(i) = lam*beta(i) + gamma(i)*psiSquared(i);  % compute new backward least-squares errors
                gamma(i+1) = gamma(i) - gamma(i)^2*psiSquared(i)/betaNew(i);    % compute conversion factors
                E(i+1) = E(i) - psi(i)*conj(H(i));  % compute joint process errors
            end
            betaNew(L) = lam*beta(L) + gamma(L)*psiSquared(L);  % update last new backward least-squares error
            E(L+1) = E(L) - psi(L)*conj(H(L));      % compute last joint process error
            H = H + (gamma.*psi.*conj(E(2:L+1))./betaNew).';    % update joint process coefficients
            e(ntr) = E(L+1);                % assign last error sample
            y(ntr) = d(ntr) - e(ntr);       % compute last output sample
            
            % Save states
            saveCommonDiscreteStates(obj,H,psi,alpha,beta);
            obj.ForwardPredictionCoefficients = dsp.private.copyMatrix(rhoFwd, ...
                obj.ForwardPredictionCoefficients);
            obj.BackwardPredictionCoefficients = dsp.private.copyMatrix(rhoBwd, ...
                obj.BackwardPredictionCoefficients);
        end
        
        %stepQRDLSL A helper method to stepImpl that implements the core
        % algorithm of QR-decomposition Least-squares Lattice FIR adaptive
        % filter.
        function [y,e] = stepQRDLSL(obj, x, d)
            % Initialize output variables
            [y,e,ntr] = initializeVariables(obj,size(x));
            
            % Load the required constant properties
            L = obj.Length;
            lam = obj.FilterParameters.ForgettingFactor;  % assign ForgettingFactor
            
            % Load the required DiscreteState properties
            [PiH,EpsB,alpha,beta] = loadCommonDiscreteStates(obj);
            PiF   = obj.ForwardPredictionCoefficients;  % assign forward reflection coefficient vector
            PiB   = obj.BackwardPredictionCoefficients; % assign backward reflection coefficient vector
            
            % Initialize the required temporarty variables
            EpsH = [PiH, 0].';      % initialize temporary joint process error buffer
            EpsF = EpsB;            % initialize temporary forward prediction error buffer
            sqrtLam  = sqrt(lam);   % assign square root of forgetting factor
            
            % First iteration of forward/backward prediction updates
            EpsF(1) = x(1);                 % assign current input sample
            betaOld = beta;                 % save backward least-squares errors
            beta = lam*beta + real(EpsB.*conj(EpsB));   % update backward least-squares errors
            C = sqrtLam*sqrt(betaOld./beta);            % compute Givens rotation factors C_b
            S = conj(EpsB)./sqrt(beta);     % compute Givens rotation factors S_b
            
            % order-recursive updates
            for i=1:L-1
                EpsF(i+1) = C(i)*EpsF(i) - conj(S(i))*sqrtLam*conj(PiF(i));    % forward prediction errors
            end
            
            PiF = (sqrtLam*C.*PiF' + S.*EpsF)';         % update forward auxiliary parameters
            alphaOld = alpha(1:L-1);                    % save forward least-squares errors
            alpha = lam*alpha + real(EpsF.*conj(EpsF)); % update forward least-squares errors
            C = sqrtLam*sqrt(alphaOld./alpha(1:L-1));   % compute Givens rotation factors C_f
            S = conj(EpsF(1:L-1))./sqrt(alpha(1:L-1));  % compute Givens rotation factors S_f
            EpsBOld = EpsB(1:L-1);                      % save backward prediction errors
            EpsB(:) = [x(1); C.*EpsBOld - sqrtLam*conj(S).*PiB'];   % compute backward predictions errors
            PiB = (sqrtLam*C.*PiB' + S.*EpsBOld)';      % update backward auxiliary parameters
            
            % Main Loop
            for n=1:ntr-1
                EpsF(1) = x(n+1);           % assign future input sample
                betaOld = beta;             % save backward least-squares errors
                beta = lam*beta + real(EpsB.*conj(EpsB));   % update backward least-squares errors
                C = sqrtLam*sqrt(betaOld./beta);            % compute Givens rotation factors C_b
                S = conj(EpsB)./sqrt(beta); % compute Givens rotation factors S_b
                EpsH(1) = d(n);             % assign current desired response sample
                
                for i=1:L-1                 % order-recursive updates
                    EpsF(i+1) = C(i)*EpsF(i) - conj(S(i))*sqrtLam*conj(PiF(i)); % forward prediction errors
                    EpsH(i+1) = C(i)*EpsH(i) - conj(S(i))*sqrtLam*conj(PiH(i)); % joint process errors
                end
                sqrtGamma = prod(C);                        % final conversion factor
                EpsH(L+1) = C(L)*EpsH(L) - conj(S(L))*sqrtLam*conj(PiH(L));     % final joint process error
                
                PiF = (sqrtLam*C.*PiF' + S.*EpsF)';         % update forward auxiliary parameters
                PiH = (sqrtLam*C.*PiH' + S.*EpsH(1:L))';    % joint process auxiliary parameters
                alphaOld = alpha(1:L-1);                    % save forward least-squares errors
                alpha = lam*alpha + real(EpsF.*conj(EpsF)); % update forward least-squares errors
                C = sqrtLam*sqrt(alphaOld./alpha(1:L-1));   % compute Givens rotation factors C_b
                S = conj(EpsF(1:L-1))./sqrt(alpha(1:L-1));  % compute Givens rotation factors S_b
                EpsBOld = EpsB(1:L-1);                      % save backward prediction errors
                EpsB(:) = [x(n+1); C.*EpsBOld - sqrtLam*conj(S).*PiB']; % compute backward predictions errors
                PiB = (sqrtLam*C.*PiB' + S.*EpsBOld)';      % update backward auxiliary parameters
                
                e(n) = EpsH(L+1)/sqrtGamma;                 % compute current error sample
                y(n) = d(n) - e(n);                         % compute current output sample
            end
            
            % Last iteration of joint process estimation updates
            EpsH(1) = d(ntr);                               % assign current desired signal
            betaNew = lam*beta + real(EpsB.*conj(EpsB));    % update backward least-squares errors
            C = sqrtLam*sqrt(beta./betaNew);                % compute Givens rotation factors C_b
            S = conj(EpsB)./sqrt(betaNew);                  % compute Givens rotation factors S_b
            
            % order-recursive updates
            for i=1:L-1
                EpsH(i+1) = C(i)*EpsH(i) - conj(S(i))*sqrtLam*conj(PiH(i)); % joint process errors
            end
            sqrtGamma = prod(C);                            % final conversion factor
            EpsH(L+1) = C(L)*EpsH(L) - conj(S(L))*sqrtLam*conj(PiH(L));     % final joint process error
            
            PiH = (sqrtLam*C.*PiH' + S.*EpsH(1:L))';        % joint process auxiliary parameters
            
            e(ntr) = EpsH(L+1)/sqrtGamma;                   % compute last error sample
            y(ntr) = d(ntr) - e(ntr);                       % compute last output sample
            
            % Save states
            saveCommonDiscreteStates(obj,PiH,EpsB,alpha,beta);
            obj.ForwardPredictionCoefficients = dsp.private.copyMatrix(PiF, ...
                obj.ForwardPredictionCoefficients);
            obj.BackwardPredictionCoefficients = dsp.private.copyMatrix(PiB, ...
                obj.BackwardPredictionCoefficients);
        end
        
        %stepGAL A helper method to stepImpl that implements the core
        % algorithm of Gradient Adaptive Lattice FIR adaptive filter.
        function [y,e] = stepGAL(obj, x, d)
            % Initialize output variables
            [y,e,ntr] = initializeVariables(obj,size(x));
            
            % Load the required DiscreteState properties
            [H,B,normF,normB] = loadCommonDiscreteStates(obj);
            Rho = obj.ReflectionCoefficients;   % initialize and assign reflection coefficient vector
            F   = B;                            % initialize temporary forward prediction error buffer
            
            % Load the required constant properties
            params = obj.FilterParameters;
            L = obj.Length;
            muH = params.StepSize;              % assign joint process Step size
            muR = params.ReflectionStepSize;    % assign reflection Step size
            beta = params.AveragingFactor;      % assign averaging factor
            offset = params.Offset;             % assign offset
            lockCoeffs = params.LockCoefficients;
            
            % Main Loop
            for n=1:ntr
                % Forward and backward prediction error calculations
                F(1) = x(n);                        % Assign current forward prediction error
                for i=1:L-1
                    F(i+1) = F(i) - Rho(i)*B(i);    % Compute new forward prediction errors
                end
                
                Bnew = B(1:L-1) - Rho.'.*F(1:L-1);  % Compute new backward prediction errors
                normF = beta*normF + (1-beta)*real(F.*conj(F)); % Update forward prediction error powers
                
                % Update reflection coefficients
                Rho = Rho + muR*real((F(2:L).*conj(B(1:L-1)) + Bnew.*conj(F(1:L-1)))./(normF(1:L-1)+normB(1:L-1)+offset)).';
                
                B(:) = [x(n); Bnew];                % Update backward prediction errors
                normB = beta*normB + (1-beta)*real(B.*conj(B)); % Update forward prediction error powers
                
                % Joint process estimation
                y(n) = H*B;                         % compute current output signal sample
                e(n) = d(n) - y(n);                 % compute current error signal sample
                if ~lockCoeffs                      % update joint process coefficient vector
                    H = H + muH*e(n)*(B./(normB+offset))';
                end
            end
            
            % Save states
            saveCommonDiscreteStates(obj,H,B,normF,normB);
            obj.ReflectionCoefficients = Rho;
        end
        
        %getFilterParameterStruct This is a helper method that creates and
        % returns a filter parameters structure. Each of the filter
        % parameters are casted to the InputDataType property value.
        function filterParams = getFilterParameterStruct(obj)
            if strcmp(obj.Method, 'Gradient Adaptive Lattice')
                inputDataTypeLocal = obj.InputDataType;
                filterParams = struct( ...
                    'StepSize', cast(obj.StepSize,inputDataTypeLocal), ...
                    'Offset', cast(obj.Offset,inputDataTypeLocal), ...
                    'ReflectionStepSize', cast(obj.ReflectionStepSize,inputDataTypeLocal), ...
                    'AveragingFactor', cast(obj.AveragingFactor,inputDataTypeLocal), ...
                    'LockCoefficients', obj.LockCoefficients ...
                    );
            else
                filterParams = struct('ForgettingFactor', ...
                    cast(obj.ForgettingFactor,obj.InputDataType));
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
        
        %loadCommonDiscreteStates This is a helper method to the stepImpl
        % method. This method returns the always active DiscreteState
        % properties of the AdaptiveLatticeFilter object.
        function [H,X,alpha,beta] = loadCommonDiscreteStates(obj)
            H = obj.Coefficients;
            X = obj.States;
            alpha = obj.ForwardPredictionErrorPower;
            beta = obj.BackwardPredictionErrorPower;
        end
        
        %saveCommonDiscreteStates This is a helper method to the stepImpl
        % method. This method saves the always active DiscreteState
        % properties of the AdaptiveLatticeFilter object.
        function saveCommonDiscreteStates(obj,H,X,alpha,beta)
            obj.Coefficients = dsp.private.copyMatrix(H,obj.Coefficients);
            obj.States = dsp.private.copyMatrix(X, obj.States);
            obj.ForwardPredictionErrorPower = alpha;
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
            switch prop
                case {'ForgettingFactor', 'ForwardPredictionCoefficients', ...
                        'BackwardPredictionCoefficients'}
                    if strcmp(obj.Method, 'Gradient Adaptive Lattice')
                        flag = true;
                    end
                case {'StepSize', 'Offset', 'ReflectionStepSize', ...
                        'AveragingFactor', 'ReflectionCoefficients', ...
                        'LockCoefficients'}
                    if ~strcmp(obj.Method, 'Gradient Adaptive Lattice')
                        flag = true;
                    end
            end
        end
        
        %getDiscreteStateImpl This overloaded method is used to get all the
        % active DiscreteState properties of the object as a structure.
        function discreteStates = getDiscreteStateImpl(obj)
            if strcmp(obj.Method, 'Gradient Adaptive Lattice')
                discreteStates = struct('Coefficients', obj.Coefficients, ...
                    'States', obj.States, ...
                    'ReflectionCoefficients', obj.ReflectionCoefficients, ...
                    'ForwardPredictionErrorPower', obj.ForwardPredictionErrorPower, ...
                    'BackwardPredictionErrorPower', obj.BackwardPredictionErrorPower);
            else
                discreteStates = struct('Coefficients', obj.Coefficients, ...
                    'States', obj.States, ...
                    'ForwardPredictionCoefficients', obj.ForwardPredictionCoefficients, ...
                    'BackwardPredictionCoefficients', obj.BackwardPredictionCoefficients, ...
                    'ForwardPredictionErrorPower', obj.ForwardPredictionErrorPower, ...
                    'BackwardPredictionErrorPower', obj.BackwardPredictionErrorPower);
            end
        end
        
        %saveObjectImpl This overloaded method is used to save all the
        % active properties of the object, including the required private
        % and protected ones, when the object is saved.
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@matlab.System(obj);
            
            % Save the private properties
            s.privReflectionStepSize = obj.privReflectionStepSize;
            s.privAveragingFactor = obj.privAveragingFactor;
            s.privInitialPredictionErrorPowerLSL = obj.privInitialPredictionErrorPowerLSL;
            s.privInitialPredictionErrorPowerGAL = obj.privInitialPredictionErrorPowerGAL;
            s.privReflectionStepSizeDefined = obj.privReflectionStepSizeDefined;
            s.privAveragingFactorDefined = obj.privAveragingFactorDefined;
            
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
            obj.privReflectionStepSize = s.privReflectionStepSize;
            obj.privAveragingFactor = s.privAveragingFactor;
            obj.privInitialPredictionErrorPowerLSL = s.privInitialPredictionErrorPowerLSL;
            obj.privInitialPredictionErrorPowerGAL = s.privInitialPredictionErrorPowerGAL;
            obj.privReflectionStepSizeDefined = s.privReflectionStepSizeDefined;
            obj.privAveragingFactorDefined = s.privAveragingFactorDefined;
            
            % Load the InputDataType property and the FilterParameters
            % property if the object was locked.
            if wasLocked
                obj.InputDataType = s.InputDataType;
                obj.FilterParameters = getFilterParameterStruct(obj);
            end
        end
    end
end
