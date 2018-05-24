classdef FilteredXLMSFilter < matlab.System
%FilteredXLMSFilter Computes output, error, and coefficients using
%                   Filtered-X Least Mean Squares FIR adaptive filter.
%
%   H = dsp.FilteredXLMSFilter returns a filtered-x least-mean-square FIR
%   adaptive filter System object(TM), H. This System object is used to
%   compute the filtered output and the filter error for a given input and
%   desired signal.
%
%   H = dsp.FilteredXLMSFilter('PropertyName', PropertyValue, ...) returns
%   a FilteredXLMSFilter System object, H, with each specified property set
%   to the specified value.
%
%   H = dsp.FilteredXLMSFilter(LEN, 'PropertyName', PropertyValue, ...)
%   returns a FilteredXLMSFilter System object, H, with the Length property
%   set to LEN, and other specified properties set to the specified values.
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
%   FilteredXLMSFilter methods:
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
%   FilteredXLMSFilter properties:
%
%   Length                      - Length of filter coefficients vector
%   StepSize                    - Adaptation step size
%   LeakageFactor               - Leakage factor of the adaptive filter
%   SecondaryPathCoefficients   - Coefficient values of the secondary path
%   SecondaryPathEstimate       - Estimate of the secondary path model
%   InitialCoefficients         - Initial coefficients of the filter
%   LockCoefficients            - Locked status of the coefficient updates
%
%
%   % EXAMPLE #1: Active noise control of a random noise signal
%     x  = randn(1000,1);      % Noise source
%     g  = fir1(47,0.4);       % FIR primary path system model
%     n  = 0.1*randn(1000,1);  % Observation noise signal
%     d  = filter(g,1,x) + n;  % Signal to be cancelled
%     b  = fir1(31,0.5);       % FIR secondary path system model
%     mu = 0.008;              % Filtered-X LMS step size
%     ha = dsp.FilteredXLMSFilter(32, 'StepSize', mu, 'LeakageFactor', ...
%          1, 'SecondaryPathCoefficients', b);
%     [y,e] = step(ha,x,d);
%     plot(1:1000,d,'b',1:1000,e,'r');
%     title('Active Noise Control of a Random Noise Signal');
%     legend('Original','Attenuated');
%     xlabel('Time Index'); ylabel('Signal Value');  grid on;
%
%   See also dsp.LMSFilter, dsp.RLSFilter, dsp.AffineProjectionFilter,
%            dsp.AdaptiveLatticeFilter, dsp.FrequencyDomainAdaptiveFilter,
%            dsp.FIRFilter.

%   Copyright 1995-2013 The MathWorks, Inc.


    properties (Nontunable, PositiveInteger)
        %Length Length of the filter coefficients vector
        %   Specify the length of the FIR filter coefficients vector as a
        %   positive integer value. The default value of this property is
        %   10.
        Length = 10;
    end
    
    properties
        %StepSize Adaptation step size
        %   Specify the adaptation step size factor as a positive numeric
        %   scalar. The default value of this property is 0.1.
        StepSize = 0.1;
        
        %LeakageFactor Adaptation leakage factor
        %   Specify the leakage factor used in leaky adaptive filter as a
        %   numeric value between 0 and 1, both inclusive. When the value
        %   is less than 1, the System object implements a leaky adaptive
        %   algorithm. The default value of this property is 1, providing
        %   no leakage in the adapting method.
        LeakageFactor = 1;
        
        %InitialCoefficients Initial coefficients of the filter
        %   Specify the initial values of the FIR adaptive filter
        %   coefficients as a scalar or a vector of length equal to the
        %   Length property value. The default value of this property is 0.
        InitialCoefficients = 0;
        
        %SecondaryPathCoefficients Coefficients of the secondary path
        %                          filter model
        %   Specify the coefficients of the secondary path filter model as
        %   a numeric vector. The secondary path exists between the output
        %   actuator and the error sensor. The default value of this
        %   property is a vector that represents the coefficients of a 10th
        %   order FIR low-pass filter.
        SecondaryPathCoefficients = fir1(10,0.5);
    end
    
    properties (Dependent, Nontunable)
        %SecondaryPathEstimate An estimate of the secondary path filter
        %                      model
        %   Specify the estimate of the secondary path filter model as a
        %   numeric vector. The secondary path exists between the output
        %   actuator and the error sensor. The default value of this
        %   property is equal to the SecondayPathCoefficients property
        %   value. This is not a tunable property.
        SecondaryPathEstimate;
    end
    
    properties (Logical)
        %LockCoefficients Lock the coefficient updates
        %   Specify whether the filter coefficient values should be locked.
        %   By default, the value of this property is false, and the object
        %   continuously updates the filter coefficients. If this property
        %   is set to true, the filter coefficients do not get updated and
        %   their values remain at the current value.
        LockCoefficients = false;
    end
    
    properties (DiscreteState)
        %Coefficients Current coefficients of the adaptive filter
        %   This property stores the current coefficients of the filter
        %   as a row vector of length equal to the Length property value.
        %   This property is initialized to the values of
        %   InitialCoefficients property.
        Coefficients;
        
        %States Current internal states of the adaptive filter
        %   This property stores the current internal states of the filter
        %   as a column vector. Its length is equal to the maximum of the
        %   Length property value and the length of the
        %   SecondaryPathEstimate property value. This property is
        %   initialized to a vector of zeros of appropriate length and data
        %   type.
        States;
        
        %FilteredInputStates Current filtered input states of the adaptive
        %                    filter
        %   This property stores the current filtered input states of the
        %   adaptive filter as a column vector. The length of this vector
        %   is equal to the Length property value. This property is
        %   initialized to a vector of zeros of appropriate length and data
        %   type.
        FilteredInputStates;
        
        %SecondaryPathStates Current states of the secondary path filter
        %   This property stores the current states of the secondary path
        %   filter model as a column vector. The length of this vector is
        %   equal to the length of the SecondaryPathCoefficients property
        %   value. This property is initialized to a vector of zeros of
        %   appropriate length and data type.
        SecondaryPathStates;
    end
    
    properties (Access=protected)
        %FilterParameters Private property to store the filter parameters
        %   This is a private MATLAB structure that stores all the filter
        %   parameters casted to the data type of the inputs. StepSize,
        %   LeakageFactor, SecondaryPathCoefficients, SecondaryPathEstimate
        %   and LockCoefficients are the filter parameters. This property
        %   is initialized in the setup method.
        FilterParameters;
    end
    
    properties (Access=private, Nontunable)
        %privSecondaryPathEstimate A private property to store the value
        %   set to the SecondaryPathEstimate dependent property.
        privSecondaryPathEstimate;
    end
    
    properties (Access=private, Logical, Nontunable)
        %privSecondaryPathEstimate A Private logical property to denote
        %   whether the SecondaryPathEstimate property has been explicitly
        %   set.
        privSecondaryPathEstimateDefined = false;
    end
    
    properties (Access=protected, Nontunable)
        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs. It is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;
    end
    
    methods
        % FilteredXLMSFilter constructor
        function obj = FilteredXLMSFilter(varargin)
            % Support name-value pair arguments as well as alternatively
            % allow the Length property to be a value-only argument.
            setProperties(obj, nargin, varargin{:}, 'Length');
        end
        
        % Validating and setting StepSize
        function set.StepSize(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val >= 0 && ...
                isnumeric(val) && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBePositiveRealScalar', ...
                'StepSize');
            obj.StepSize = val;
        end
        
        % Validating and setting LeakageFactor
        function set.LeakageFactor(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val >= 0 && val <= 1 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeRealScalar0to1Closed', ...
                'LeakageFactor');
            obj.LeakageFactor = val;
        end
        
        % Validating and setting InitialCoefficients
        function set.InitialCoefficients(obj,val)
            coder.internal.errorIf(~(isnumeric(val) && isvector(val) && all(isfinite(val))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericVector', 'InitialCoefficients');
            obj.InitialCoefficients = val(:).';
        end
        
        % Validating and setting SecondaryPathCoefficients
        function set.SecondaryPathCoefficients(obj,val)
            coder.internal.errorIf(~(isnumeric(val) && isvector(val) && all(isfinite(val))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericVector', 'SecondaryPathCoefficients');
            obj.SecondaryPathCoefficients = val(:).';
        end
        
        % Set method for the SecondaryPathEstimate dependent property. The
        % value set explicitly to the SecondaryPathEstimate dependent
        % property is stored in the privSecondaryPathEstimate property and
        % the privSecondaryPathEstimateDefined logical property is set to
        % true.
        function set.SecondaryPathEstimate(obj,val)
            coder.internal.errorIf(~(isnumeric(val) && isvector(val) && all(isfinite(val))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericVector', 'SecondaryPathEstimate');
            obj.privSecondaryPathEstimate = val(:).';
            obj.privSecondaryPathEstimateDefined = true;
        end
        
        % Get method for the SecondaryPathEstimates dependent property. If
        % the SecondaryPathEstimates property is not explicitly set, this
        % method returns the SecondaryPathCoefficients property value as
        % the default value for the SecondaryPathEstimate property.
        function val = get.SecondaryPathEstimate(obj)
            if obj.privSecondaryPathEstimateDefined
                val = obj.privSecondaryPathEstimate;
            else
                val = obj.SecondaryPathCoefficients;
            end
        end
    end    
    
    methods(Static, Access=protected)
        function group = getPropertyGroupsImpl
            % Get default parameters group for this System object, and mark
            % SecondaryPathEstimate as dependent on private-only
            group = matlab.system.display.Section('dsp.FilteredXLMSFilter', ...
                'DependOnPrivatePropertyList', {'SecondaryPathEstimate'});
            
            % Replace SecondaryPathEstimate default spec
            pind = find(strcmp('SecondaryPathEstimate', group.PropertyList),1);
            group.PropertyList{pind} = matlab.system.display.internal.Property('SecondaryPathEstimate', ...
                'UseClassDefault', false, ...
                'Default', 'fir1( 10, 0.5 )');
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
            realInputD = isreal(d);
            
            % Initialize FilteredInputStates to zeros:
            % If the input signal and the SecondaryPathEstimate property
            % are real, then the FilteredInputStates property is
            % initialized to a real zero vector. Else it is initialized to
            % a complex zero vector.
            if realInputX && isreal(obj.SecondaryPathEstimate)
                obj.FilteredInputStates = zeros(L,1,inputDataTypeLocal);
            else
                obj.FilteredInputStates = complex(zeros(L,1,inputDataTypeLocal));
            end
            
            % Initialize SecondaryPathStates and Coefficients to zeros:
            % Both of them are inter-dependent and they are complex if any
            % one of the inputs, the InitialCoefficients property, the
            % SecondaryPathCoefficients property or the
            % SecondaryPathEstimates property is complex.
            M = length(obj.SecondaryPathCoefficients);
            if realInputX && realInputD && isreal(obj.SecondaryPathCoefficients)...
                    && isreal(obj.SecondaryPathEstimate) && isreal(obj.InitialCoefficients)
                obj.Coefficients = zeros(1,L,inputDataTypeLocal);
                obj.SecondaryPathStates = zeros(M,1,inputDataTypeLocal);
            else
                obj.Coefficients = complex(zeros(1,L,inputDataTypeLocal));
                obj.SecondaryPathStates = complex(zeros(M,1,inputDataTypeLocal));
            end
            
            % Initialize States to zeros:
            maxLN = max(L,length(obj.SecondaryPathEstimate));
            if realInputX
                obj.States = zeros(maxLN,1,inputDataTypeLocal);
            else
                obj.States = complex(zeros(maxLN,1,inputDataTypeLocal));
            end
        end
        
        function resetImpl(obj)
            % Initialize Coefficients to InitialCoefficients.
            obj.Coefficients = dsp.private.copyMatrix(obj.InitialCoefficients, ...
                obj.Coefficients);
            
            % Initialize States to a vector of zeros.
            obj.States = dsp.private.copyMatrix(0, obj.States);
            
            % Initialize FilteredInputStates to a vector of zeros.
            obj.FilteredInputStates = dsp.private.copyMatrix(0, obj.FilteredInputStates);
            
            % Initialize SecondaryPathStates to a vector of zeros.
            obj.SecondaryPathStates = dsp.private.copyMatrix(0, obj.SecondaryPathStates);
        end
        
        function processTunedPropertiesImpl(obj)
            % If the tunable properties are changed, update the
            % FilterParameters private property that stores their
            % type-casted version in a structure.
            inputDataTypeLocal = obj.InputDataType;
            obj.FilterParameters.StepSize = ...
                cast(obj.StepSize,inputDataTypeLocal);
            obj.FilterParameters.LeakageFactor = ...
                cast(obj.LeakageFactor,inputDataTypeLocal);
            obj.FilterParameters.SecondaryPathCoefficients = ...
                cast(obj.SecondaryPathCoefficients,inputDataTypeLocal);
            obj.FilterParameters.SecondaryPathEstimate = ...
                cast(obj.SecondaryPathEstimate,inputDataTypeLocal);
            obj.FilterParameters.LockCoefficients = obj.LockCoefficients;
        end
        
        function [y, e] = stepImpl(obj, x, d)
            % Load the required properties.
            L = obj.Length;
            params = obj.FilterParameters;
            [W,X,Y,F] = loadFilterDiscreteStates(obj);
            
            % Initialize output and temporary local variables.
            [y,e,ntr] = initializeVariables(obj,size(x));
            
            % Cache the constant properties required in the main loop.
            mu = params.StepSize;
            lam = params.LeakageFactor;
            H = params.SecondaryPathCoefficients;
            Hhat = params.SecondaryPathEstimate;
            lockCoeffs = params.LockCoefficients;
            M = length(H);
            N = length(Hhat);
            
            % Cache the index arrays required in the main loop.
            nL = 1:L;
            nN = 1:N;
            nnL = 1:L-1;
            nnLp1 = 2:L;
            nnM = 1:M-1;
            nnMp1 = 2:M;
            mLN = max(L,N);
            nnmLN = 1:mLN-1;
            nnmLNp1 = 2:mLN;
            
            % Main Loop
            for n=1:ntr
                X(nnmLNp1) = X(nnmLN);  % shift temporary input signal buffer down
                X(1) = x(n);            % assign current input signal sample
                y(n) = W*X(nL);         % compute current output signal sample
                Y(nnMp1) = Y(nnM);      % shift temporary output signal buffer down
                Y(1) = y(n);            % assign current output signal sample
                e(n) = d(n) + H*Y;      % compute and assign current error signal sample
                F(nnLp1) = F(nnL);      % shift temporary filtered input signal buffer down
                F(1) = Hhat*X(nN);      % assign current filtered input signal sample
                
                % Update filter coefficient vector
                if ~lockCoeffs
                    W = lam*W - mu*e(n)*F';
                end
            end
            
            % Save States
            saveFilterDiscreteStates(obj,W,X,Y,F);
        end
        
        %loadFilterDiscreteStates This is a helper method to the stepImpl
        % method. This method is used to load all the DiscreteState
        % properties used in the stepImpl method.
        function [W,X,Y,F] = loadFilterDiscreteStates(obj)
            X = obj.States;             %  initialize and assign input signal buffer
            W = obj.Coefficients;       %  initialize and assign coefficient vector
            F = obj.FilteredInputStates;        %  initialize temporary filtered input signal buffer
            Y = obj.SecondaryPathStates;        %  initialize temporary output signal buffer
        end
        
        %saveFilterDiscreteStates This is a helper method to the stepImpl
        % method. This method is used to save all the DiscreteState
        % properties specific modified in the stepImpl method.
        function saveFilterDiscreteStates(obj,W,X,Y,F)
            obj.Coefficients = dsp.private.copyMatrix(W, obj.Coefficients);
            obj.States = dsp.private.copyMatrix(X, obj.States);
            obj.SecondaryPathStates = dsp.private.copyMatrix(Y, obj.SecondaryPathStates);
            obj.FilteredInputStates = dsp.private.copyMatrix(F, obj.FilteredInputStates);
        end
        
        %getFilterParameterStruct This method that gives the filter
        % parameters structure with the values casted to the InputDataType
        % property value.
        function filterParams = getFilterParameterStruct(obj)
            inputDataTypeLocal = obj.InputDataType;
            filterParams = struct( ...
                'StepSize', ...
                cast(obj.StepSize,inputDataTypeLocal), ...
                'LeakageFactor', ...
                cast(obj.LeakageFactor,inputDataTypeLocal), ...
                'SecondaryPathCoefficients', ...
                cast(obj.SecondaryPathCoefficients, inputDataTypeLocal), ...
                'SecondaryPathEstimate', ...
                cast(obj.SecondaryPathEstimate, inputDataTypeLocal), ...
                'LockCoefficients', obj.LockCoefficients);
        end
        
        %initializeVariables This method is used to initialized output
        % variables and temporary variables required in the main loop of
        % the stepImpl method.
        function [y,e,ntr] = initializeVariables(obj,Sx)
            ntr = max(Sx);                      %  temporary number of iterations
            if isreal(obj.Coefficients)         %  initialize output signal vector
                y = zeros(Sx,obj.InputDataType);
            else
                y = complex(zeros(Sx,obj.InputDataType));
            end
            e = y;                      %  initialize error signal vector
        end
        
        function N = getNumInputsImpl(~)
            % Specify number of System inputs
            N = 2;
        end
        
        function N = getNumOutputsImpl(~)
            % Specify number of System outputs
            N = 2;
        end
        
        %saveObjectImpl This overloaded method is used to save all the
        % active properties of the object, including the required private
        % and protected ones, when the object is saved.
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@matlab.System(obj);
            
            % Save the private properties
            s.privSecondaryPathEstimate = obj.privSecondaryPathEstimate;
            s.privSecondaryPathEstimateDefined = obj.privSecondaryPathEstimateDefined;
            
            % Save InputDataType if the object is locked.
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
            obj.privSecondaryPathEstimate = s.privSecondaryPathEstimate;
            obj.privSecondaryPathEstimateDefined = s.privSecondaryPathEstimateDefined;
            
            % Load InputDataType and FilterParameters if the object was
            % locked.
            if wasLocked
                obj.InputDataType = s.InputDataType;
                obj.FilterParameters = getFilterParameterStruct(obj);
            end
        end
    end
end
