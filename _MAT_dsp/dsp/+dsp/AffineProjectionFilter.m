classdef AffineProjectionFilter < matlab.System
%AffineProjectionFilter Compute output, error and coefficients using Affine
%                       Projection (AP) adaptive algorithm.
%
%   H = dsp.AffineProjectionFilter returns an adaptive FIR filter System
%   object(TM), H, that computes the filtered output and the filter error
%   for a given input and desired signal using the Affine Projection (AP)
%   algorithm.
%
%   H = dsp.AffineProjectionFilter('PropertyName', PropertyValue, ...)
%   returns an AffineProjectionFilter System object, H, with each specified
%   property set to the specified value.
%
%   H = dsp.AffineProjectionFilter(LEN, 'PropertyName', PropertyValue, ...)
%   returns an AffineProjectionFilter System object, H, with the Length
%   property set to LEN, and other specified properties set to the
%   specified values.
%
%   Step method syntax:
%
%   [Y, ERR] = step(H, X, D) filters the input X, using D as the desired
%   signal, and returns the filtered output in Y and the filter error in
%   ERR. The System object estimates the filter weights needed to minimize
%   the error between the output signal and the desired signal. These
%   filter weights can be obtained by accessing the 'Coefficients' property
%   after calling the 'step' method by H.Coefficients.
%
%   AffineProjectionFilter methods:
%
%   step     - See above description for use of this method.
%   release  - Allow property value and input characteristics changes
%   clone    - Create AffineProjectionFilter object with the same property
%              values 
%   isLocked - Locked status (logical).
%   reset    - Reset the internal states to their initial conditions.
%
%   AffineProjectionFilter properties:
%
%   Method                  - Method to calculate the filter coefficients
%   Length                  - Length of the filter coefficients vector 
%   ProjectionOrder         - Projection order of the affine projection
%                             algorithm
%   StepSize                - Affine projection step size
%   InitialCoefficients     - Initial coefficients of the filter
%   InitialOffsetCovariance - Initial values of the offset input covariance
%                             matrix
%   InitialInverseOffsetCovariance  - Initial values of the offset input
%                                     covariance matrix inverse
%   InitialCorrelationCoefficients  - Initial correlation coefficients
%   LockCoefficients        - Locks the coefficient updates (logical)
%
%   % EXAMPLE #1: QPSK adaptive equalization using a 32-coefficient FIR 
%   %  filter (1000 iterations).
%
%      D = 16;                      % Number of samples of delay
%      b = exp(j*pi/4)*[-0.7 1];    % Numerator coefficients of channel
%      a = [1 -0.7];                % Denominator coefficients of channel
%      ntr = 1000;                  % Number of iterations
%      s = sign(randn(1,ntr+D)) + j*sign(randn(1,ntr+D)); % Baseband signal
%      n = 0.1*(randn(1,ntr+D) + j*randn(1,ntr+D));       % Noise signal
%      r = filter(b,a,s)+n;         % Received signal
%      x = r(1+D:ntr+D);            % Input signal (received signal)
%      d = s(1:ntr);                % Desired signal (delayed QPSK signal)
%      mu = 0.1;                    % Step size
%      po = 4;                      % Projection order
%      offset = 0.05;               % Offset for covariance matrix
%      h = dsp.AffineProjectionFilter('Length', 32, ...
%          'StepSize', mu, 'ProjectionOrder', po, ...
%          'InitialOffsetCovariance',offset);
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
%   See also dsp.LMSFilter, dsp.RLSFilter, dsp.FIRFilter.

%   Copyright 1995-2013 The MathWorks, Inc.

%#codegen
    
    properties (Nontunable)
        %Method Method to calculate the filter coefficients
        %   Specify the method used to calculate filter coefficients as one
        %   of [{'Direct Matrix Inversion'} | 'Recursive Matrix Update' |
        %   'Block Direct Matrix Inversion'].
        Method = 'Direct Matrix Inversion';
    end
    
    properties (Nontunable, PositiveInteger)
        %Length Length of the filter coefficients vector
        %   Specify the length of the FIR filter coefficients vector as a
        %   scalar positive integer value. The default value of this
        %   property is 32.
        Length = 32;
        
        %ProjectionOrder Projection order of the affine projection
        %                algorithm
        %   Specify the projection order of the affine projection algorithm
        %   as a scalar positive integer value greater than or equal to 2.
        %   This property defines the size of the input signal covariance
        %   matrix. The default value of this property is 2.
        ProjectionOrder = 2;
    end
    
    properties
        %StepSize Affine projection step size
        %   Specify the affine projection step size factor as a scalar
        %   non-negative numeric value between 0 and 1, both inclusive.
        %   Setting step equal to one provides the fastest convergence
        %   during adaptation. The default value of this property is 1.
        StepSize = 1.0;
        
        %InitialCoefficients Initial coefficients of the filter
        %   Specify the initial values of the FIR adaptive filter
        %   coefficients as a scalar or a vector of length equal to the
        %   Length property value. The default value of this property is 0.
        InitialCoefficients = 0;
        
        %InitialOffsetCovariance Initial values of the offset input 
        %                        covariance matrix
        %   Specify the initial values for the offset input covariance
        %   matrix. This property must either be a scalar positive numeric
        %   value or a positive-definite square matrix with each dimension
        %   equal to the ProjectionOrder property value. If it is a scalar
        %   value, the OffsetCovariance property is initialized to a
        %   diagonal matrix with the diagonal elements equal to that scalar
        %   value. If it is a square matrix, the OffsetCovariance property
        %   is initialized to the values of that square matrix.  This
        %   property is applicable only if the Method property is set to
        %   'Direct Matrix Inversion' or 'Block Direct Matrix Inversion'.
        %   The default value of this property is 1.
        InitialOffsetCovariance = 1;
        
        %InitialInverseOffsetCovariance Initial values of the offset input 
        %                               covariance matrix inverse
        %   Specify the initial values for the offset input covariance
        %   matrix inverse. This property must either be a scalar positive
        %   numeric value or a positive-definite square matrix with each
        %   dimension equal to the ProjectionOrder property value. If it is
        %   a scalar value, the InverseOffsetCovariance property is
        %   initialized to a diagonal matrix with each diagonal element
        %   equal to that scalar value. If it is a square matrix, the
        %   InverseOffsetCovariance property is initialized to the values of
        %   that square matrix.  This property is applicable only if the
        %   Method property is set to 'Recursive Matrix Update'. The
        %   default value of this property is 20.
        InitialInverseOffsetCovariance = 20;
        
        %InitialCorrelationCoefficients Initial correlation coefficients
        %   Specify the initial values of the correlation coefficients of
        %   the FIR filter as a scalar or a vector of length equal to
        %   (ProjectionOrder - 1). This property is applicable only if the
        %   Method property is set to 'Recursive Matrix Update'. The
        %   default value of this property is 0.
        InitialCorrelationCoefficients = 0;
    end
    
    properties (Logical)
        %LockCoefficients Lock the coefficient updates
        %   Specify whether the filter coefficient values should be locked.
        %   By default, the value of this property is false, and the object
        %   continuously updates the filter coefficients. When this
        %   property is set to true, the filter coefficients are not
        %   updated and their values remain at the current value.
        LockCoefficients = false;
    end
    
    properties (DiscreteState)
        %Coefficients Current coefficients of the filter
        %   This property stores the current coefficients of the filter as
        %   a row vector of length equal to the Length property value. This
        %   property is initialized to the values of InitialCoefficients
        %   property casted to the data type of the inputs.
        Coefficients;
        
        %States Current internal states of the filter
        %   This property stores the current internal states of the filter
        %   as a column vector. Its length is equal to the sum of Length
        %   property and ProjectionOrder property. This property is
        %   initialized to a zero vector of appropriate length and data
        %   type as that of the inputs.
        States;
        
        %ErrorStates Error states of the adaptive filter
        %   This property stores the current error states of the adaptive
        %   filter as a column vector. Its length is equal to the
        %   ProjectionOrder property value. This property is initialized to
        %   a zero vector of appropriate length and data type.
        ErrorStates;
        
        %EpsilonStates Epsilon values of the adaptive filter
        %   This property stores the current epsilon values of the adaptive
        %   filter as a column vector. Its length is equal to the
        %   ProjectionOrder property value. This property is initialized to
        %   a zero vector of appropriate length and data type.
        EpsilonStates;
        
        %OffsetCovariance Offset covariance matrix
        %   This property stores the offset covariance matrix of the
        %   current inputs. It is a square matrix with each dimension equal
        %   to the ProjectionOrder property value. This property is
        %   applicable only if the Method property is set to 'Direct Matrix
        %   Inversion' or 'Block Direct Matrix Inversion'. This property is
        %   initialized to the values of the InitialOffsetCovariance
        %   property.
        OffsetCovariance;
        
        %InverseOffsetCovariance Inverse of offset-covariance matrix
        %   This property stores the inverse of offset covariance matrix of
        %   the current inputs. It is a square matrix with each dimension
        %   equal to the ProjectionOrder property value. This property is
        %   applicable only if the Method property is set to 'Recursive
        %   Matrix Update'. This property is initialized to the values of
        %   InitialInverseOffsetCovariance property.
        InverseOffsetCovariance;
        
        %CorrelationCoefficients Correlation coefficients of the filter
        %   This property stores the correlation coefficients for the FIR
        %   adaptive filter as a row vector. Its length is equal to
        %   (ProjectionOrder - 1). This property is applicable only if the
        %   Method property is set to 'Recursive Matrix Update'. This
        %   property is initialized to the values of
        %   InitialCorrelationCoefficients property casted to the data type
        %   of the inputs.
        CorrelationCoefficients;
    end
    
    properties (Access=protected)
        %FilterParameters Private structure to store the filter parameters
        %   This is a private MATLAB structure that stores all the filter
        %   parameters in the appropriate data type. For
        %   AffineProjectionFilter System object, StepSize and
        %   LockCoefficients are the filter parameters. This property is
        %   initialized in setup method.
        FilterParameters;
    end
    
    properties (Access=protected, Nontunable)
        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs and it is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;
    end
    
    properties(Constant, Hidden)
        MethodSet = matlab.system.StringSet( { ...
            'Direct Matrix Inversion', ...
            'Block Direct Matrix Inversion', ...
            'Recursive Matrix Update'} );
    end
    
    
    methods
        % AffineProjectionFilter Constructor
        function obj = AffineProjectionFilter(varargin)
            % Support name-value pair arguments as well as alternatively
            % allow the Length property to be a value-only argument.
            setProperties(obj, nargin, varargin{:}, 'Length');
        end
        
        % Validating and setting ProjectionOrder
        function set.ProjectionOrder(obj,val)
            % ProjectionOrder is defined as a PositiveInteger property, so
            % minimal validation that makes sure that the value is greater
            % than 2 is enough here.          
            coder.internal.errorIf(val < 2, ...
                'dsp:system:AffineProjectionFilter:invalidProjectionOrder');
            obj.ProjectionOrder = val;
        end
        
        % Validating and setting StepSize
        function set.StepSize(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val >= 0 && val <= 1 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeRealScalar0to1Closed', 'StepSize');
            obj.StepSize = val;
        end
        
        % Checking if InitialCoefficients is a vector before setting it.
        function set.InitialCoefficients(obj,val)
            coder.internal.errorIf(~(isnumeric(val) && isvector(val) && all(isfinite(val(:)))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericVector', 'InitialCoefficients');
            obj.InitialCoefficients = val(:).';
        end
        
        % Validating and setting InitialOffsetCovariance
        function set.InitialOffsetCovariance(obj,val)
            coder.internal.errorIf(~(isnumeric(val) && all(isfinite(val(:))) ...
                && ismatrix(val) && (size(val,1)==size(val,2)) && (~isscalar(val) || ...
                (isscalar(val) && val > 0))), ...
                'dsp:system:AffineProjectionFilter:mustBeNumericPositiveSquareMatrix', ...
                'InitialOffsetCovariance');
            obj.InitialOffsetCovariance = val;
        end
        
        % Validating and setting InitialOffsetCovariance
        function set.InitialInverseOffsetCovariance(obj,val)
            coder.internal.errorIf(~(isnumeric(val) && all(isfinite(val(:))) ...
                && ismatrix(val) && (size(val,1)==size(val,2)) && (~isscalar(val) || ...
                (isscalar(val) && val > 0))), ...
                'dsp:system:AffineProjectionFilter:mustBeNumericPositiveSquareMatrix', ...
                'InitialInverseOffsetCovariance');
            obj.InitialInverseOffsetCovariance = val;
        end
        
        % Checking if InitialCorrelationCoefficients is a vector before
        % setting it.
        function set.InitialCorrelationCoefficients(obj,val)
            coder.internal.errorIf(~(isnumeric(val) && isvector(val) && all(isfinite(val(:)))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericVector', 'InitialCorrelationCoefficients');
            obj.InitialCorrelationCoefficients = val(:).';
        end
    end
    
    methods (Static, Hidden)
        %APCoefficientUpdate This static method performs the Affine
        %   projection coefficient update by direct matrix inversion for
        %   the given error signal, affine projection filter states and
        %   affine projection filter parameters. The input argument
        %   'discreteStates' must be a structure and must contain the
        %   following fields: States, Coefficients, ErrorStates,
        %   EpsilonStates and OffsetCovariance. The input argument 'params'
        %   must be a structure and must contain the StepSize value and
        %   LockCoefficients logical value.
        function discreteStates = APCoefficientUpdate(error, discreteStates, params)
            % Local copy of the filter states
            X = discreteStates.States;
            W = discreteStates.Coefficients;
            E = discreteStates.ErrorStates;
            Eps = discreteStates.EpsilonStates;
            
            % Local copy of the filter parameters
            mu = params.StepSize;
            L = length(W);
            N = size(E,1);
            
            % Update Offset input covariance matrix with most-recent N
            % input signal samples.
            XN = X(1:N);
            R = discreteStates.OffsetCovariance + XN*XN';
            
            % Update error and epsilon signal buffers
            E(:) = [mu*error; (1-mu)*E(1:N-1)]; %  Update error signal buffer
            Eps(:) = [0; Eps(1:N-1)] + R\E;     %  Update temporary epsilon signal buffer
            
            % "Down-date" Offset input covariance matrix with oldest N
            % input signal samples.
            XN = X(L:N+L-1);
            discreteStates.OffsetCovariance = R - XN*XN';
            
            % Update filter coefficient vector
            if ~params.LockCoefficients
                discreteStates.Coefficients = W + Eps(N)*X(N:N+L-1)';
            end
            
            % Save back the modified filter states
            discreteStates.ErrorStates = E;
            discreteStates.EpsilonStates = Eps;
        end
        
        %BAPCoefficientUpdate This static method performs the Block Affine
        %   projection coefficient update by direct matrix inversion for
        %   the given error signal, affine projection filter states and
        %   affine projection filter parameters. The input argument
        %   'discreteStates' must be a structure and must contain the
        %   following fields: States, Coefficients and OffsetCovariance.
        %   The input argument 'params' must be a structure and must
        %   contain the StepSize value and LockCoefficients logical value.
        function discreteStates = BAPCoefficientUpdate(error, discreteStates, params)
            % Local copy of the filter states
            X = discreteStates.States;
            W = discreteStates.Coefficients;
            
            % Local copy of the filter parameters
            L = length(W);
            N = length(X) - L;
            
            % Update Offset input covariance matrix with most-recent N
            % input signal samples.
            XR = toeplitz(X((1:N)+L),X(L+1:-1:L-N+2));
            R = discreteStates.OffsetCovariance + XR'*XR;
            
            % Compute projected error vector weighted by step-size factor
            E = params.StepSize * flipud(error(:));
            invRE = R\E;
            
            % Compute gradient for current block weighted by step-size
            G = filter(invRE,1,X');
            
            % "Down-date" Offset input covariance matrix with oldest N
            % input signal samples.
            XR = toeplitz(X(N+1:2*N),X(N+1:-1:2));
            discreteStates.OffsetCovariance = R - XR'*XR;
            
            % Update filter coefficient vector
            if ~params.LockCoefficients
                discreteStates.Coefficients = W + G(L+N:-1:N+1);
            end
        end
        
        %APRUCoefficientUpdate This static method performs the coefficient
        %   update using the Affine projection by recursive matrix update
        %   algorithm for the given error signal, affine projection filter
        %   states and affine projection filter parameters. The input
        %   argument 'discreteStates' must be a structure and must contain
        %   the following fields: States, Coefficients, ErrorStates,
        %   EpsilonStates, InverseOffsetCovariance and
        %   CorrelationCoefficients. The input argument 'params' must be a
        %   structure and must contain the StepSize value and
        %   LockCoefficients logical value.
        function discreteStates = APRUCoefficientUpdate(error, discreteStates, params)
            % Local copy of the filter states
            X = discreteStates.States;
            W = discreteStates.Coefficients;
            E = discreteStates.ErrorStates;
            Eps = discreteStates.EpsilonStates;
            P = discreteStates.InverseOffsetCovariance;
            
            % Local copy of the filter parameters
            mu = params.StepSize;
            L = length(W);
            N = size(E,1);
            
            % Update Offset input covariance matrix inverse with the
            % most recent N input signal samples.
            XN = X(1:N);
            XP = XN'*P;
            PX = P*XN;
            K = (1/(1 + XP*XN))*PX;     %  compute Kalman gain vector
            P = P - K*XP;               %  update inverse covariance matrix
            
            % Update correlation coefficients vector
            RR = discreteStates.CorrelationCoefficients + XN(1)*XN(2:N)';
            
            % Update error and epsilon signal buffers
            E(:) = [mu*error; (1-mu)*E(1:N-1)]; %  Update error signal buffer
            Eps(:) = [0; Eps(1:N-1)] + P*E;     %  Update temporary epsilon signal buffer
            
            % "Down-date" Offset input covariance matrix inverse with the
            % oldest N input signal samples.
            XN = X(L:N+L-1);
            XP = XN'*P;
            PX = P*XN;
            K = (1/(-1 + XP*XN))*PX;    %  compute Kalman gain vector
            discreteStates.InverseOffsetCovariance = P - K*XP;
            
            % "Down-date" correlation coefficients vector
            discreteStates.CorrelationCoefficients = RR - XN(1)*XN(2:N)';
            
            % Update filter coefficient vector
            if ~params.LockCoefficients
                discreteStates.Coefficients = W + Eps(N)*X(N:N+L-1)';
            end
            
            % Save back the modified filter states
            discreteStates.ErrorStates = E;
            discreteStates.EpsilonStates = Eps;
        end
    end
    
    methods (Access=protected)
        
        function validatePropertiesImpl(obj)
            % Validating InitialCoefficients
            coder.internal.errorIf(~(any(length(obj.InitialCoefficients)==[1,obj.Length])), ...
                'dsp:system:AdaptiveFilter:invalidVectorOfLengthL', 'InitialCoefficients');
            
            N = obj.ProjectionOrder;
            L = obj.Length;            
            
            % Validating properties that depends on the Method property
            % value.            
            if strcmp(obj.Method, 'Recursive Matrix Update')
                % Validating InitialInverseOffsetCovariance
                tempSize = size(obj.InitialInverseOffsetCovariance);
                coder.internal.errorIf(~(any(tempSize(1)==[1,N]) && tempSize(1)==tempSize(2)), ...
                    'dsp:system:AffineProjectionFilter:invalidSquareMatrixOfDimensionN', ...
                    'InitialInverseOffsetCovariance');
                
                % Validating InitialCorrelationCoefficients
                coder.internal.errorIf(~(any(length(obj.InitialCorrelationCoefficients)==[1,N-1])), ...
                    'dsp:system:AffineProjectionFilter:invalidInitialCorrelationCoefficientsLength');
            else
                % Validating InitialOffsetCovariance
                tempSize = size(obj.InitialOffsetCovariance);
                coder.internal.errorIf(~(any(tempSize(1)==[1,N]) && tempSize(1)==tempSize(2)), ...
                    'dsp:system:AffineProjectionFilter:invalidSquareMatrixOfDimensionN', ...
                    'InitialOffsetCovariance');
                
                % Validating ProjectionOrder vs. Length
                if strcmp(obj.Method, 'Block Direct Matrix Inversion')
                    coder.internal.errorIf(N>L, ...
                        'dsp:system:AffineProjectionFilter:invalidProjectionOrderForBlockDirectMatrixInversion');
                end
            end
        end
        
        function validateInputsImpl(obj, x, d)
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
            
            % If the Method property is set to 'Block Direct Matrix Inversion',
            % the length of the input vector must be divisible by the
            % ProjectionOrder property value.
            if strcmp(obj.Method, 'Block Direct Matrix Inversion')
                coder.internal.errorIf((mod(length(x),obj.ProjectionOrder)~=0), ...
                    'dsp:system:AffineProjectionFilter:invalidInputsForBlockDirectMatrixInversion');
            end
        end
        
        function setupImpl(obj, x, d)
            % Setting InputDataType to be the data type of x and setting
            % the FilterParameters property as a structure with the
            % required properties casted to that data type.
            inputDataTypeLocal = class(x);
            obj.InputDataType = inputDataTypeLocal;
            obj.FilterParameters = getFilterParameterStruct(obj);
            
            % Local copy of the required properties
            L = obj.Length;
            N = obj.ProjectionOrder;
            realInputX = isreal(x);
            realInputD = isreal(d);
            
            % Initialize States to zeros of appropriate complexity and data
            % type.
            if realInputX
                obj.States = zeros(L+N,1,inputDataTypeLocal);
            else
                obj.States = complex(zeros(L+N,1,inputDataTypeLocal));
            end
            
            % Initialize all other DiscreteStates properties to zeros of
            % appropriate complexity and data type.
            ZN = zeros(N,1,inputDataTypeLocal);
            switch obj.Method
                case 'Direct Matrix Inversion'
                    % Initialize OffsetCovariance to zeros:
                    realInitOffsetCov = isreal(obj.InitialOffsetCovariance);
                    if realInputX && realInitOffsetCov
                        obj.OffsetCovariance = zeros(N,N,inputDataTypeLocal);
                    else
                        obj.OffsetCovariance = complex(zeros(N,N,inputDataTypeLocal));
                    end
                    
                    % Initialize Coefficients, ErrorStates and
                    % EpsilonStates to zeros:
                    if realInputX && realInputD && realInitOffsetCov && ...
                            isreal(obj.InitialCoefficients)
                        obj.Coefficients = zeros(1,L,inputDataTypeLocal);
                        obj.ErrorStates = ZN;
                        obj.EpsilonStates = ZN;
                    else
                        obj.Coefficients = complex(zeros(1,L,inputDataTypeLocal));
                        obj.ErrorStates = complex(ZN);
                        obj.EpsilonStates = complex(ZN);
                    end
                    
                case 'Block Direct Matrix Inversion'
                    % Initialize OffsetCovariance to zeros:
                    realInitOffsetCov = isreal(obj.InitialOffsetCovariance);
                    if realInputX && realInitOffsetCov
                        obj.OffsetCovariance = zeros(N,N,inputDataTypeLocal);
                    else
                        obj.OffsetCovariance = complex(zeros(N,N,inputDataTypeLocal));
                    end
                    
                    % Initialize Coefficients to zeros:
                    if realInputX && realInputD && realInitOffsetCov && ...
                            isreal(obj.InitialCoefficients)
                        obj.Coefficients = zeros(1,L,inputDataTypeLocal);
                    else
                        obj.Coefficients = complex(zeros(1,L,inputDataTypeLocal));
                    end
                    
                case 'Recursive Matrix Update'
                    % Initialize InverseOffsetCovariance to zeros:
                    realInitInvOffsetCov = isreal(obj.InitialInverseOffsetCovariance);
                    if realInputX && realInitInvOffsetCov
                        obj.InverseOffsetCovariance = zeros(N,N,inputDataTypeLocal);
                    else
                        obj.InverseOffsetCovariance = complex(zeros(N,N,inputDataTypeLocal));
                    end
                    
                    % Initialize CorrelationCoefficients to zeros:
                    if realInputX && isreal(obj.InitialCorrelationCoefficients)
                        obj.CorrelationCoefficients = zeros(1,N-1,inputDataTypeLocal);
                    else
                        obj.CorrelationCoefficients = complex(zeros(1,N-1,inputDataTypeLocal));
                    end
                    
                    % Initialize Coefficients, ErrorStates and
                    % EpsilonStates to zeros:
                    if realInputX && realInputD && realInitInvOffsetCov && ....
                            isreal(obj.InitialCoefficients) && ...
                            isreal(obj.InitialCorrelationCoefficients)
                        obj.Coefficients = zeros(1,L,inputDataTypeLocal);
                        obj.ErrorStates = ZN;
                        obj.EpsilonStates = ZN;
                    else
                        obj.Coefficients = complex(zeros(1,L,inputDataTypeLocal));
                        obj.ErrorStates = complex(ZN);
                        obj.EpsilonStates = complex(ZN);
                    end
            end
        end
        
        function resetImpl(obj)
            % Local copy of the required properties
            N = obj.ProjectionOrder;
            methodLocal = obj.Method;
            inputDataTypeLocal = obj.InputDataType;
            
            % Initialize Coefficients to InitialCoefficients.
            coeffsLocal = obj.Coefficients;
            coeffsLocal(:) = cast(obj.InitialCoefficients,inputDataTypeLocal);
            
            obj.Coefficients = dsp.private.copyMatrix(coeffsLocal,obj.Coefficients);
            
            % Initialize States to zeros.
            statesLocal = obj.States;
            if isreal(statesLocal)
                obj.States = zeros(size(statesLocal), inputDataTypeLocal);
            else
                obj.States = complex(zeros(size(statesLocal), inputDataTypeLocal));
            end
            
            % Initialize ErrorStates and EpsilonStates to zeros.
            % ErrorStates and EpsilonStates are always of the same
            % complexity.
            if ~strcmp(methodLocal, 'Block Direct Matrix Inversion')
                if isreal(obj.ErrorStates)
                    obj.ErrorStates = zeros(N,1,inputDataTypeLocal);
                    obj.EpsilonStates = zeros(N,1,inputDataTypeLocal);
                else
                    obj.ErrorStates = complex(zeros(N,1,inputDataTypeLocal));
                    obj.EpsilonStates = complex(zeros(N,1,inputDataTypeLocal));
                end
            end 
            
            % Initialize OffsetCovariance, InverseOffsetCovariance and
            % CorrelationCoefficients if they are relevant to the Method
            % property value.
            if strcmp(methodLocal, 'Recursive Matrix Update')
                % Initialize InverseOffsetCovariance to
                % InitialInverseOffsetCovariance.
                invOffsetCovLocal = obj.InverseOffsetCovariance;
                invOffsetCovLocal(:) = cast(obj.InitialInverseOffsetCovariance*eye(N), inputDataTypeLocal);
                
                obj.InverseOffsetCovariance = dsp.private.copyMatrix(invOffsetCovLocal,obj.InverseOffsetCovariance);
                                
                % Initialize CorrelationCoefficients to
                % InitialCorrelationCoefficients.
                corrCoeffsLocal = obj.CorrelationCoefficients;
                corrCoeffsLocal(:) = cast(obj.InitialCorrelationCoefficients, inputDataTypeLocal);
                
                obj.CorrelationCoefficients = dsp.private.copyMatrix(corrCoeffsLocal,obj.CorrelationCoefficients);                
            else
                % Initialize OffsetCovariance to InitialOffsetCovariance.
                offsetCovLocal = obj.OffsetCovariance;
                offsetCovLocal(:) = cast(obj.InitialOffsetCovariance*eye(N),inputDataTypeLocal);

                obj.OffsetCovariance = dsp.private.copyMatrix(offsetCovLocal,obj.OffsetCovariance);                                
            end
        end
        
        function processTunedPropertiesImpl(obj)
            % Whenever the tunable properties are changed, update the
            % private structure that stores the type casted version of
            % them.
            obj.FilterParameters.StepSize = cast(obj.StepSize,obj.InputDataType);
            obj.FilterParameters.LockCoefficients = obj.LockCoefficients;
        end
        
        function [y,e] = stepImpl(obj, x, d)
            % Load states, properties and initialize variables
            discreteStates = getDiscreteStateImpl(obj);
            params = obj.FilterParameters;
            [y,e,ntr] = obj.initializeVariables(size(x));
            L = obj.Length;
            N = obj.ProjectionOrder;
            
            % Main Loop
            switch obj.Method
                case 'Direct Matrix Inversion'
                    for n=1:ntr
                        %  filter the current input buffer
                        discreteStates.States = updateBuffer(obj,x(n),discreteStates.States);
                        X = discreteStates.States;
                        y(n) = discreteStates.Coefficients*X(1:L) + ...
                            (discreteStates.OffsetCovariance(1,2:N) + X(1)* X(2:N)') ...
                            * discreteStates.EpsilonStates(1:N-1);
                        %  compute and assign current error signal sample
                        e(n) = d(n) - y(n);
                        %  update filter coefficient vector
                        discreteStates = obj.APCoefficientUpdate(e(n),discreteStates,params);
                    end
                case 'Block Direct Matrix Inversion'
                    ntrB = floor(ntr/N);
                    for n=1:ntrB
                        %  shift temporary input signal buffer up and
                        %  assign the current signal block
                        nn = ((n-1)*N+1):(n*N); %  index for current signal block
                        discreteStates.States(1:L) = discreteStates.States((1:L)+N);
                        discreteStates.States((1:N)+L) = x(nn);
                        
                        %  compute and assign current output signal block
                        Y = filter(discreteStates.Coefficients,1,discreteStates.States);
                        y(nn) = Y((1:N)+L);
                        
                        %  compute and assign current error signal block
                        e(nn) = d(nn) - y(nn);
                        
                        %  update filter coefficient vector
                        discreteStates = obj.BAPCoefficientUpdate(e(nn),discreteStates,params);
                    end
                case 'Recursive Matrix Update'
                    for n=1:ntr
                        %  filter the current input buffer
                        discreteStates.States = updateBuffer(obj,x(n),discreteStates.States);
                        X = discreteStates.States;
                        y(n) = discreteStates.Coefficients*X(1:L) + ...
                            (discreteStates.CorrelationCoefficients + X(1)* X(2:N)') ...
                            * discreteStates.EpsilonStates(1:N-1);
                        %  compute and assign current error signal sample
                        e(n) = d(n) - y(n);
                        %  update filter coefficient vector
                        discreteStates = obj.APRUCoefficientUpdate(e(n),discreteStates,params);
                    end
            end
            
            % Save states
            setDiscreteState(obj,discreteStates);
        end
        
        function N = getNumInputsImpl(~)
            % Specify number of System inputs
            N = 2;
        end
        
        function N = getNumOutputsImpl(~)
            % Specify number of System outputs
            N = 2;
        end
        
        %getFilterParameterStruct This method that gives the filter
        % parameters structure with the values casted to the InputDataType
        % property value.
        function filterParams = getFilterParameterStruct(obj)
            filterParams = struct('StepSize', ...
                cast(obj.StepSize,obj.InputDataType), ...
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
        
        %updateBuffer This method is used to update the input buffer with
        % the current input sample by shifting the buffer down.
        function buffer = updateBuffer(~, currentInput, buffer)
            % Function to assign the current input by shifting the buffer down
            buffer(:) = [currentInput(:); buffer(1:end-length(currentInput))];
        end
        
        %isInactivePropertyImpl This overloaded method is used to flag some
        % of the irrelevant properties based on the Method property value
        % as inactive.
        function flag = isInactivePropertyImpl(obj, prop)
            flag = false;
            methodLocal = obj.Method;
            switch prop
                case {'InitialOffsetCovariance'}
                    if (strcmp(methodLocal, 'Recursive Matrix Update'))
                        flag = true;
                    end
                case {'InitialCorrelationCoefficients', ...
                      'InitialInverseOffsetCovariance'}
                    if ~(strcmp(methodLocal, 'Recursive Matrix Update'))
                        flag = true;
                    end
            end
        end
        
        %getDiscreteStateImpl This overloaded method is used to get all the
        % active DiscreteState properties of the object as a structure.
        function discreteStates = getDiscreteStateImpl(obj)
            switch obj.Method
                case 'Direct Matrix Inversion'
                    discreteStates = struct('States', obj.States, ...
                        'Coefficients', obj.Coefficients, ...
                        'ErrorStates', obj.ErrorStates, ...
                        'EpsilonStates', obj.EpsilonStates, ...
                        'OffsetCovariance', obj.OffsetCovariance);
                case 'Block Direct Matrix Inversion'
                    discreteStates = struct('States', obj.States, ...
                        'Coefficients', obj.Coefficients, ...
                        'OffsetCovariance', obj.OffsetCovariance);
                case 'Recursive Matrix Update'
                    discreteStates = struct('States', obj.States, ...
                        'Coefficients', obj.Coefficients, ...
                        'ErrorStates', obj.ErrorStates, ...
                        'EpsilonStates', obj.EpsilonStates, ...
                        'CorrelationCoefficients', obj.CorrelationCoefficients, ...
                        'InverseOffsetCovariance', obj.InverseOffsetCovariance);
            end
        end
        
        %setDiscreteStateImpl This overloaded method is used to set the
        % DiscreteState properties of the object equal to the corresponding
        % fields of the structure passed as input argument.
        function setDiscreteStateImpl(obj, discreteStates)
            obj.States = dsp.private.copyMatrix(discreteStates.States,obj.States);
            obj.Coefficients = dsp.private.copyMatrix(discreteStates.Coefficients,obj.Coefficients);
            switch obj.Method
                case 'Direct Matrix Inversion'
                    obj.ErrorStates = dsp.private.copyMatrix(discreteStates.ErrorStates,obj.ErrorStates);
                    obj.EpsilonStates = dsp.private.copyMatrix(discreteStates.EpsilonStates,obj.EpsilonStates);
                    obj.OffsetCovariance = dsp.private.copyMatrix(discreteStates.OffsetCovariance,obj.OffsetCovariance);
                case 'Block Direct Matrix Inversion'
                    obj.OffsetCovariance = dsp.private.copyMatrix(discreteStates.OffsetCovariance,obj.OffsetCovariance);
                case 'Recursive Matrix Update'
                    obj.ErrorStates = dsp.private.copyMatrix(discreteStates.ErrorStates,obj.ErrorStates);
                    obj.EpsilonStates = dsp.private.copyMatrix(discreteStates.EpsilonStates,obj.EpsilonStates);
                    obj.InverseOffsetCovariance = dsp.private.copyMatrix(discreteStates.InverseOffsetCovariance,obj.InverseOffsetCovariance);
                    obj.CorrelationCoefficients = dsp.private.copyMatrix(discreteStates.CorrelationCoefficients,obj.CorrelationCoefficients);
            end
        end
        
        %saveObjectImpl This overloaded method is used to save all the
        % active properties of the object, including the required private
        % and protected ones, when the object is saved.
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@matlab.System(obj);
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
            % Load InputDataType if the object was locked.
            if wasLocked
                obj.InputDataType = s.InputDataType;
                obj.FilterParameters = getFilterParameterStruct(obj);
            end
        end
    end
end
