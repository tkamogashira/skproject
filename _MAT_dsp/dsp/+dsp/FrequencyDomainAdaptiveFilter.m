classdef FrequencyDomainAdaptiveFilter < matlab.System
%FrequencyDomainAdaptiveFilter Computes output, error and coefficients using
%                              frequency domain FIR adaptive filter.
%
%   H = dsp.FrequencyDomainAdaptiveFilter returns a frequency domain FIR
%   adaptive filter System object(TM), H. This System object is used to
%   compute the filtered output and the filter error for a given input and
%   desired signal.
%
%   H = dsp.FrequencyDomainAdaptiveFilter('PropertyName',PropertyValue,...)
%   returns a FrequencyDomainAdaptiveFilter System object, H, with each
%   specified property set to the specified value.
%
%   H = dsp.FrequencyDomainAdaptiveFilter(LEN, 'PropertyName', ...
%       PropertyValue, ...)
%   returns a FrequencyDomainAdaptiveFilter System object, H, with the
%   Length property set to LEN, and other specified properties set to the
%   specified values.
%
%   Step method syntax:
%
%   [Y, ERR] = step(H, X, D) filters the input X, using D as the desired
%   signal, and returns the filtered output in Y and the filter error in
%   ERR. The System object estimates the filter weights needed to minimize
%   the error between the output signal and the desired signal. The FFT of
%   these filter weights can be obtained by accessing the FFTCoefficients
%   property after calling the step method by H.FFTCoefficients.
%
%   FrequencyDomainAdaptiveFilter methods:
%
%   step                - See above description for use of this method.
%   release             - Allow changes in non-tunable property values and
%                         input characteristics.
%   clone               - Create a FrequencyDomainAdaptiveFilter object
%                         with the same property values and internal
%                         states.
%   isLocked            - Locked status of the filter object (logical).
%   reset               - Reset the internal states to their initial
%                         conditions.
%
%   FrequencyDomainAdaptiveFilter properties:
%
%   Method              - Method to calculate the filter
%                         coefficients
%   Length              - Length of filter coefficients vector
%   BlockLength         - Block length for the coefficient updates
%   StepSize            - Adaptation step size
%   LeakageFactor       - Adaptation leakage factor
%   AveragingFactor     - Averaging factor for the signal power
%   Offset              - Offset for the normalization terms
%   InitialPower        - Initial FFT input signal power
%   InitialCoefficients - Initial time-domain coefficients of the filter
%   LockCoefficients    - Locked status of the coefficient updates
%
%
%   % EXAMPLE #1: QPSK adaptive equalization using a 32-coefficient FIR
%   %   filter (1024 iterations).
%
%     D = 16;                       % Number of samples of delay
%     b  = exp(1i*pi/4)*[-0.7 1];   % Numerator coefficients of channel
%     a  = [1 -0.7];                % Denominator coefficients of channel
%     ntr= 1024;                    % Number of iterations
%     s  = sign(randn(1,ntr+D))+1i*sign(randn(1,ntr+D));    % QPSK signal
%     n  = 0.1*(randn(1,ntr+D) + 1i*randn(1,ntr+D));        % Noise signal
%     r  = filter(b,a,s) + n;       % Received signal
%     x  = r(1+D:ntr+D);            % Input signal (received signal)
%     d  = s(1:ntr);                % Desired signal (delayed QPSK signal)
%     mu  = 0.1;                    % Step size
%     ha = dsp.FrequencyDomainAdaptiveFilter('Length',32,'StepSize',mu);
%     [y,e] = step(ha,x,d);
%     subplot(2,2,1); plot(1:ntr,real([d;y;e]));
%     legend('Desired','Output','Error'); title('In-Phase Components');
%     xlabel('Time Index'); ylabel('signal value');
%     subplot(2,2,2); plot(1:ntr,imag([d;y;e]));
%     legend('Desired','Output','Error'); title('Quadrature Components');
%     xlabel('Time Index'); ylabel('signal value');
%     subplot(2,2,3); plot(x(ntr-100:ntr),'.'); axis([-3 3 -3 3]);
%     title('Received Signal Scatter Plot'); axis('square');
%     xlabel('Real[x]'); ylabel('Imag[x]'); grid on;
%     subplot(2,2,4); plot(y(ntr-100:ntr),'.'); axis([-3 3 -3 3]);
%     title('Equalized Signal Scatter Plot'); axis('square');
%     xlabel('Real[y]'); ylabel('Imag[y]'); grid on;
%
%   See also dsp.LMSFilter, dsp.RLSFilter, dsp.AffineProjectionFilter,
%            dsp.AdaptiveLatticeFilter, dsp.FilteredXLMSFilter,
%            dsp.FIRFilter.

%   Copyright 1995-2012 The MathWorks, Inc.

%#codegen
    
    properties (Nontunable)
        %Method Method to calculate the filter coefficients
        %   Specify the method used to calculate filter coefficients as one
        %   of [{'Constrained FDAF'} | 'Unconstrained FDAF'].
        Method = 'Constrained FDAF';
    end
    
    properties (Nontunable, PositiveInteger)
        %Length Length of the filter coefficients vector
        %   Specify the length of the FIR filter coefficients vector as a
        %   positive integer value. The default value of this property is
        %   32.
        Length = 32;
    end
    
    properties (Nontunable, Dependent)
        %BlockLength Block length for the coefficient updates
        %   Specify the block length of the coefficients updates as a
        %   positive integer value. The length of the input vectors must be
        %   divisible by the BlockLength property value. For faster
        %   execution, the sum of the Length property value and the
        %   BlockLength property value should be a power of two. The
        %   default value of the BlockLength property is set to the Length
        %   property value.
        BlockLength;
    end
    
    properties
        %StepSize Adaptation step size
        %   Specify the adaptation step size factor as a positive numeric
        %   scalar less than or equal to 1. Setting the StepSize property
        %   equal to one provides the fastest convergence during
        %   adaptation. The default value of this property is 1.
        StepSize = 1;
        
        %LeakageFactor Adaptation leakage factor
        %   Specify the leakage factor used in leaky adaptive filter as a
        %   scalar numeric value between 0 and 1, both inclusive. When the
        %   value is less than 1, the System object implements a leaky
        %   adaptive algorithm. The default value of this property is 1,
        %   providing no leakage in the adapting method.
        LeakageFactor = 1;
        
        %AveragingFactor Averaging factor for the signal power
        %   Specify the averaging factor used to compute the exponentially
        %   windowed FFT input signal powers for the coefficient updates as
        %   a scalar positive numeric value less than or equal to 1. The
        %   default value of this property is 1.
        AveragingFactor = 0.9;
        
        %Offset Offset for the normalization terms
        %   Specify the offset for the normalization terms in the
        %   coefficient updates as a scalar non-negative numeric value.
        %   This property value is used to avoid divide by zeros or divide
        %   by very small numbers if any of the FFT input signal powers
        %   become very small. The default value of this property is 0.
        Offset = 0;
        
        %InitialPower Initial FFT input signal power
        %   Specify the initial common value of all of the FFT input signal
        %   powers as a scalar positive numeric value. The default value of
        %   this property is 1.
        InitialPower = 1;
        
        %InitialCoefficients Initial time-domain coefficients of the filter
        %   Specify the initial time-domain coefficients of the adaptive
        %   filter as a scalar or a vector of length equal to the Length
        %   property value. The adaptive filter object uses these
        %   coefficients to compute the initial frequency-domain filter
        %   coefficients. The default value of this property is 0.
        InitialCoefficients = 0;
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
        %Coefficients Current FFT coefficients of the filter
        %   This property stores the current discrete Fourier transform of
        %   the filter coefficients as a row vector. The length of this
        %   vector is equal to the sum of the Length property value and the
        %   BlockLength property value. This property is initialized to the
        %   FFT values of the InitialCoefficients property.
        FFTCoefficients;
        
        %States Current internal states of the filter
        %   This property stores the current internal states of the filter
        %   as a column vector. The length of this vector is equal to the
        %   Length property value. This property is initialized to a vector
        %   of zeros of appropriate length and data type.
        States;
        
        %Power Current FFT input signal power
        %   This property stores the current values of FFT input signal
        %   powers as a column vector. The length of this vector is equal
        %   to the sum of the Length property value and the BlockLength
        %   property value. This property is initialized to a vector of
        %   appropriate length and data type with each of the elements
        %   equal to the InitialPower property value.
        Power;
    end
    
    properties (Access=protected)
        %FilterParameters Private structure to store the filter parameters
        %   This is a private MATLAB structure that stores all the filter
        %   parameters casted to the data type of the inputs. For
        %   FrequencyDomainAdaptiveFilter System object, StepSize,
        %   LeakageFactor, AveragingFactor, Offset, InitialPower and
        %   LockCoefficients are the filter parameters. The
        %   FilterParameters property is initialized in setup method.
        FilterParameters;
    end
    
    properties (Access=protected, Nontunable, PositiveInteger)
        %privBlockLength A private property to store the value explicitly
        %   set to the BlockLength property.
        privBlockLength = 32;   % Assigned value needed for cloning
    end
    
    properties (Access=protected, Nontunable, Logical)
        %privBlockLengthDefined A Private logical property to denote
        %   whether the BlockLength property has been explicitly set.
        privBlockLengthDefined = false;
    end
    
    properties (Access=protected, Nontunable)
        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs and it is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;
        
        % The following private properties are used to store dsp.FFT System
        % objects to compute FFT of various variables in the setup, reset
        % and step methods.
        hFFTIC;
        hFFTX;
        hFFTW;
        hIFFTY;
    end
    
    properties(Constant, Hidden)
        %MethodSet String set to specify the valid string values for the
        %   Method property.
        MethodSet = matlab.system.StringSet( { ...
            'Constrained FDAF', ...
            'Unconstrained FDAF'} );
    end
    
    
    methods
        % FrequencyDomainAdaptiveFilter Constructor
        function obj = FrequencyDomainAdaptiveFilter(varargin)
            % Support name-value pair arguments as well as alternatively
            % allow the Length property to be a value-only argument.
            setProperties(obj, nargin, varargin{:}, 'Length');
        end
        
        % Set method for the BlockLength dependent property. The value set
        % explicitly to the BlockLength dependent property is stored in the
        % privBlockLength property and the privBlockLengthDefined logical
        % property is set to true. Validation is taken care by the
        % PositiveInteger attribute of the privBlockLength property.
        function set.BlockLength(obj,val)
            obj.privBlockLength = val;
            obj.privBlockLengthDefined = true;
        end
        
        % Get method for the BlockLength dependent property. If the
        % BlockLength has not been explicitly set, this method returns the
        % Length property value as its default value.
        function val = get.BlockLength(obj)
            if obj.privBlockLengthDefined
                val = obj.privBlockLength;
            else
                val = obj.Length;
            end
        end
        
        % Validating and setting StepSize
        function set.StepSize(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val > 0 && val <= 1 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeRealScalar0to1LeftOpen', 'StepSize');
            obj.StepSize = val;
        end
        
        % Validating and setting LeakageFactor
        function set.LeakageFactor(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val >= 0 && val <= 1 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeRealScalar0to1Closed', 'LeakageFactor');
            obj.LeakageFactor = val;
        end
        
        % Validating and setting AveragingFactor
        function set.AveragingFactor(obj,val)
            coder.internal.errorIf(~(isscalar(val) && val > 0 && val <= 1 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeRealScalar0to1LeftOpen', 'AveragingFactor');
            obj.AveragingFactor = val;
        end
        
        % Validating and setting Offset
        function set.Offset(obj,val)
            coder.internal.errorIf(~(isscalar(val) && isnumeric(val) && val >= 0 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBeNonNegativeRealScalar', 'Offset');
            obj.Offset = val;
        end
        
        % Validating and setting InitialPower
        function set.InitialPower(obj,val)
            coder.internal.errorIf(~(isscalar(val) && isnumeric(val) && val > 0 && isreal(val)), ...
                'dsp:system:AdaptiveFilter:mustBePositiveRealScalar', 'InitialPower');
            obj.InitialPower = val;
        end
        
        % Validating and setting InitialCoefficients
        function set.InitialCoefficients(obj,val)
            coder.internal.errorIf(~(isvector(val) && isnumeric(val) && all(isfinite(val))), ...
                'dsp:system:AdaptiveFilter:mustBeNumericVector', 'InitialCoefficients');
            obj.InitialCoefficients = val(:).';
        end
    end
    
    methods(Static, Access=protected)
        function group = getPropertyGroupsImpl
            % Get default parameters group for this System object
            group = matlab.system.display.Section('dsp.FrequencyDomainAdaptiveFilter', ...
                'DependOnPrivatePropertyList', {'BlockLength'}); %#ok<EMCA>
        end
    end

    methods (Access=protected)
        function validatePropertiesImpl(obj)
            % Validating the dimensions of the InitialCoefficients property
            coder.internal.errorIf(~(any(length(obj.InitialCoefficients)==[1,obj.Length])), ...
                'dsp:system:AdaptiveFilter:invalidVectorOfLengthL', 'InitialCoefficients');
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
            
            % Validating the length of the input vectors. The length of the
            % input vectors must be divisible by the BlockLength property
            % value.
            coder.internal.errorIf((mod(length(x),obj.BlockLength)~=0), ...
                'dsp:system:FrequencyDomainAdaptiveFilter:invalidInputVectorLength');
            
            % Validating the data type of the inputs x and d. x and d must
            % both be single or double.
            coder.internal.errorIf(~(isa(x,'float') && strcmp(class(x), ...
                class(d))), 'dsp:system:AdaptiveFilter:inputsNotFloatingPoint');
        end
        
        function setupImpl(obj, x, ~)
            % Set InputDataType to be the data type of x and initialize the
            % FilterParameters property based on that. The FilterParameters
            % property is a structure with all the filter parameters casted
            % to the data type of the inputs.
            inputDataTypeLocal = class(x);
            obj.InputDataType = inputDataTypeLocal;
            obj.FilterParameters = getFilterParameterStruct(obj);
            
            % Local copy of the required properties
            L = obj.Length;
            LN = L + obj.BlockLength;
            realInputX = isreal(x);
            
            % Construct dsp.FFT System objects for using in the stepImpl
            % method.
            obj.hFFTIC = dsp.FFT('FFTLengthSource','Property','FFTLength',LN);
            obj.hFFTX = dsp.FFT('FFTLengthSource','Property','FFTLength',LN);
            obj.hFFTW = dsp.FFT('FFTLengthSource','Property','FFTLength',LN);
            obj.hIFFTY = dsp.IFFT('FFTLengthSource','Property','FFTLength',LN);
            
            % Initialize the Power property to a vector of zeros.
            obj.Power = zeros(LN,1,inputDataTypeLocal);
            
            % Initialize the FFTCoefficients property to a vector of zeros.
            obj.FFTCoefficients = complex(zeros(1,LN,inputDataTypeLocal));
            
            % Initializing the States property to a vector of zeros.
            if realInputX
                obj.States = zeros(L,1,inputDataTypeLocal);
            else
                obj.States = complex(zeros(L,1,inputDataTypeLocal));
            end
        end
        
        function resetImpl(obj)
            % Local copy of the required properties
            inputDataTypeLocal = obj.InputDataType;
            L = obj.Length;
            
            % Initialize the Power property to the InitialPower property
            % value.
            obj.Power(:) = obj.InitialPower;
            
            % Initialize FFTCoefficients to the FFT of InitialCoefficients.
            % A very small floating-point value is added to the imaginary
            % part of the FFTCoefficients property so as to avoid it
            % turning into real.
            if isreal(obj.InitialCoefficients)
                initialCoefficientsProto = zeros(L,1,inputDataTypeLocal);
            else
                initialCoefficientsProto = complex(zeros(L,1,inputDataTypeLocal));
            end
            initialCoeffsLocal = dsp.private.copyMatrix(obj.InitialCoefficients, ...
                initialCoefficientsProto);
            obj.FFTCoefficients = step(obj.hFFTIC,initialCoeffsLocal).' ...
                + 1i*eps(zeros(1,1,inputDataTypeLocal));
            
            % Initialize the States property to a vector of zeros.
            if isreal(obj.States)
                obj.States = zeros(L,1,inputDataTypeLocal);
            else
                % A very small floating-point value is added to the
                % imaginary part of the States property so as to avoid it
                % turning into real.
                obj.States = complex(zeros(L,1,inputDataTypeLocal), ...
                    eps(zeros(L,1,inputDataTypeLocal)));
            end
        end
        
        function processTunedPropertiesImpl(obj)
            % If the tunable properties are changed, update the
            % FilterParameters private property that stores their
            % type-casted version in a structure.
            inputDataTypeLocal = obj.InputDataType;
            obj.FilterParameters.StepSize = ...
                cast(obj.StepSize, inputDataTypeLocal);
            obj.FilterParameters.LeakageFactor = ...
                cast(obj.LeakageFactor, inputDataTypeLocal);
            obj.FilterParameters.AveragingFactor = ...
                cast(obj.AveragingFactor, inputDataTypeLocal);
            obj.FilterParameters.Offset = ...
                cast(obj.Offset, inputDataTypeLocal);
            obj.FilterParameters.InitialPower = ...
                cast(obj.InitialPower, inputDataTypeLocal);
        end
        
        function [y,e] = stepImpl(obj, x, d)
            if strcmp(obj.Method, 'Constrained FDAF')
                [y,e] = stepCFDAF(obj, x, d);
            else
                [y,e] = stepUFDAF(obj, x, d);
            end
        end
        
        %stepCFDAF A helper method to stepImpl that implements the core
        % algorithm of Constrained Frequency Domain Adaptive Filter.
        function [y,e] = stepCFDAF(obj, x, d)
            % Load the required properties
            [L,N,params,FFTW,normFFTX,X] = loadFDAFProperties(obj);
            
            % Initialize output and temporary local variables
            [yLocal,eLocal,ntrB,E,ZN] = initializeVariables(obj,size(x));
            
            % Cache the constant properties required in the main loop.
            mu = params.StepSize;           % Step size
            lam = params.LeakageFactor;     % Leakage factor
            beta = params.AveragingFactor;  % Averaging factor
            offset = params.Offset;         % Offset
            lockCoeffs = params.LockCoefficients;
            
            % Cache the index arrays required in the main loop.
            nnL = 1:L;
            nnLpN = N+1:N+L;
            nnNpL = L+1:L+N;
            
            % Main Loop
            for n=1:ntrB
                nn = ((n-1)*N+1):(n*N);     %  index for current signal blocks
                X(nnL) = X(nnLpN);          %  shift temporary input signal buffer up
                X(nnNpL) = x(nn);           %  assign current input signal vector
                FFTX = step(obj.hFFTX,X);   %  compute FFT of input signal vector
                Y = step(obj.hIFFTY,(FFTW.*FFTX));
                yLocal(nn) = Y(nnNpL);      %  assign current output signal block
                eLocal(nn) = d(nn) - yLocal(nn);    %  assign current error signal block
                E(nnNpL) = mu*eLocal(nn);   %  assign current error signal vector
                FFTE = step(obj.hFFTW,E);   %  compute FFT of error signal vector
                
                % Update FFT input signal powers
                normFFTX = beta*normFFTX + (1-beta)*real(FFTX.*conj(FFTX));
                
                % Compute gradient vector
                G = step(obj.hIFFTY,(FFTE.*conj(FFTX)./(normFFTX + offset)));
                G(nnNpL) = ZN;              %  impose gradient constraint
                
                % Update frequency domain coefficients
                if ~lockCoeffs
                    FFTW = lam*FFTW + step(obj.hFFTW,G);
                end
            end
            
            % Save States
            obj.FFTCoefficients = FFTW.';   % Save final frequency domain coefficients
            obj.Power = normFFTX;           % Save final FFT input signal powers
            obj.States = X(L+N:-1:N+1);     % Save final filter internal states
            
            % If the input and desired signals are real-valued, make sure
            % that the output and error signals are also real-valued.
            if isreal(x) && isreal(d)
                y = real(yLocal);
                e = real(eLocal);
            else
                y = yLocal;
                e = eLocal;
            end
        end
        
        %stepUFDAF A helper method to stepImpl that implements the core
        % algorithm of Unconstrained Frequency Domain Adaptive Filter..
        function [y,e] = stepUFDAF(obj, x, d)
            % Load the required properties
            [L,N,params,FFTW,normFFTX,X] = loadFDAFProperties(obj);
            
            % Initialize output and temporary local variables
            [yLocal,eLocal,ntrB,E] = initializeVariables(obj,size(x));
            
            % Cache the constant properties required in the main loop.
            mu = params.StepSize;           % Step size
            lam = params.LeakageFactor;     % Leakage factor
            beta = params.AveragingFactor;  % Averaging factor
            offset = params.Offset;         % Offset
            lockCoeffs = params.LockCoefficients;
            
            % Cache the index arrays required in the main loop.
            nnL = 1:L;
            nnLpN = N+1:N+L;
            nnNpL = L+1:L+N;
            
            % Main Loop
            for n=1:ntrB
                nn = ((n-1)*N+1):(n*N);     %  index for current signal blocks
                X(nnL) = X(nnLpN);          %  shift temporary input signal buffer up
                X(nnNpL) = x(nn);           %  assign current input signal vector
                FFTX = step(obj.hFFTX,X);   %  compute FFT of input signal vector
                Y = step(obj.hIFFTY,(FFTW.*FFTX));
                yLocal(nn) = Y(nnNpL);      %  assign current output signal block
                eLocal(nn) = d(nn) - yLocal(nn);    %  assign current error signal block
                E(nnNpL) = mu*eLocal(nn);   %  assign current error signal vector
                FFTE = step(obj.hFFTW,E);   %  compute FFT of error signal vector
                
                % Update FFT input signal powers
                normFFTX = beta*normFFTX + (1-beta)*real(FFTX.*conj(FFTX));
                
                % Update frequency domain coefficients
                if ~lockCoeffs
                    FFTW = lam*FFTW + (FFTE.*conj(FFTX)./(normFFTX + offset));
                end
            end
            
            % Save States
            obj.FFTCoefficients = FFTW.';   % Save final frequency domain coefficients
            obj.Power = normFFTX;           % Save final FFT input signal powers
            obj.States = X(L+N:-1:N+1);     % Save final filter internal states
            
            % If the input and desired signals are real-valued, make sure
            % that the output and error signals are also real-valued.
            if isreal(x) && isreal(d)
                y = real(yLocal);
                e = real(eLocal);
            else
                y = yLocal;
                e = eLocal;
            end
        end
        
        %getFilterParameterStruct This is a helper method that creates and
        % returns the filter parameters structure. Each of the filter
        % parameters are casted to the InputDataType property value.
        function filterParams = getFilterParameterStruct(obj)
            inputDataTypeLocal = obj.InputDataType;
            filterParams = struct('StepSize', cast(obj.StepSize,inputDataTypeLocal), ...
                'LeakageFactor', cast(obj.LeakageFactor, inputDataTypeLocal), ...
                'AveragingFactor', cast(obj.AveragingFactor, inputDataTypeLocal), ...
                'Offset', cast(obj.Offset, inputDataTypeLocal), ...
                'InitialPower', cast(obj.InitialPower, inputDataTypeLocal), ...
                'LockCoefficients', obj.LockCoefficients);
        end
        
        %initializeVariables This is a helper method to the stepImpl
        % method. This method is used to initialize output variables and
        % temporary variables required in the main loop of the stepImpl
        % method.
        function [y,e,ntrB,E,ZN] = initializeVariables(obj,Sx)
            % Load the required constant properties
            L = obj.Length;                 % Number of coefficients
            N = obj.BlockLength;            % Block length
            inputDataTypeLocal = obj.InputDataType;
            
            % Temporary number of iterations
            ntrB = max(Sx)/obj.BlockLength;
            
            % Initialize output and error signal vector
            y = complex(zeros(Sx,inputDataTypeLocal),eps(zeros(Sx,inputDataTypeLocal)));
            e = y;
            
            % Temporary error signal buffer
            E = complex(zeros(L+N,1,inputDataTypeLocal),eps(zeros(L+N,1,inputDataTypeLocal)));
            
            % N-dimensional zero vector
            ZN = zeros(N,1,inputDataTypeLocal);
        end
        
        %loadCommonDiscreteStates This helper method returns all the
        % properties of the filter object required in the step method.
        function [L,N,params,FFTW,normFFTX,X] = loadFDAFProperties(obj)
            % Load the required constant properties
            L = obj.Length;                 % Number of coefficients
            N = obj.BlockLength;            % Block length
            params = obj.FilterParameters;  % Filter parameters structure
            
            % Load the required DiscreteState properties
            FFTW = obj.FFTCoefficients.';   %  initialize and assign alternative coefficient vector
            normFFTX = obj.Power;           %  initialize and assign FFT input signal powers
            if isreal(obj.States)        % initialize temporary input signal buffer
                X = zeros(L+N,1,obj.InputDataType);
            else
                X = complex(zeros(L+N,1,obj.InputDataType));
            end
            X(L+N:-1:N+1) = obj.States;  %  assign input signal buffer
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
            s.privBlockLength = obj.privBlockLength;
            s.privBlockLengthDefined = obj.privBlockLengthDefined;
            s.hFFTIC = obj.hFFTIC;
            s.hFFTX = obj.hFFTX;
            s.hFFTW = obj.hFFTW;
            s.hIFFTY = obj.hIFFTY;
            
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
            obj.privBlockLength = s.privBlockLength;
            obj.privBlockLengthDefined = s.privBlockLengthDefined;
            obj.hFFTIC = s.hFFTIC;
            obj.hFFTX = s.hFFTX;
            obj.hFFTW = s.hFFTW;
            obj.hIFFTY = s.hIFFTY;
            
            % Load the InputDataType property and the FilterParameters
            % property if the object was locked.
            if wasLocked
                obj.InputDataType = s.InputDataType;
                obj.FilterParameters = getFilterParameterStruct(obj);
            end
        end
    end
end
