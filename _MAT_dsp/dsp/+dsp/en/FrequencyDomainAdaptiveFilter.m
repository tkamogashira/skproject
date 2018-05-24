classdef FrequencyDomainAdaptiveFilter< handle
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

    methods
        function out=FrequencyDomainAdaptiveFilter
            % Support name-value pair arguments as well as alternatively
            % allow the Length property to be a value-only argument.
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
            % Load the required constant properties
        end

        function loadFDAFProperties(in) %#ok<MANU>
            % Load the required constant properties
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
            % If the tunable properties are changed, update the
            % FilterParameters private property that stores their
            % type-casted version in a structure.
        end

        function resetImpl(in) %#ok<MANU>
            % Local copy of the required properties
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Set InputDataType to be the data type of x and initialize the
            % FilterParameters property based on that. The FilterParameters
            % property is a structure with all the filter parameters casted
            % to the data type of the inputs.
        end

        function stepCFDAF(in) %#ok<MANU>
            % Load the required properties
        end

        function stepImpl(in) %#ok<MANU>
        end

        function stepUFDAF(in) %#ok<MANU>
            % Load the required properties
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
        %AveragingFactor Averaging factor for the signal power
        %   Specify the averaging factor used to compute the exponentially
        %   windowed FFT input signal powers for the coefficient updates as
        %   a scalar positive numeric value less than or equal to 1. The
        %   default value of this property is 1.
        AveragingFactor;

        %BlockLength Block length for the coefficient updates
        %   Specify the block length of the coefficients updates as a
        %   positive integer value. The length of the input vectors must be
        %   divisible by the BlockLength property value. For faster
        %   execution, the sum of the Length property value and the
        %   BlockLength property value should be a power of two. The
        %   default value of the BlockLength property is set to the Length
        %   property value.
        BlockLength;

        %Coefficients Current FFT coefficients of the filter
        %   This property stores the current discrete Fourier transform of
        %   the filter coefficients as a row vector. The length of this
        %   vector is equal to the sum of the Length property value and the
        %   BlockLength property value. This property is initialized to the
        %   FFT values of the InitialCoefficients property.
        FFTCoefficients;

        %FilterParameters Private structure to store the filter parameters
        %   This is a private MATLAB structure that stores all the filter
        %   parameters casted to the data type of the inputs. For
        %   FrequencyDomainAdaptiveFilter System object, StepSize,
        %   LeakageFactor, AveragingFactor, Offset, InitialPower and
        %   LockCoefficients are the filter parameters. The
        %   FilterParameters property is initialized in setup method.
        FilterParameters;

        %InitialCoefficients Initial time-domain coefficients of the filter
        %   Specify the initial time-domain coefficients of the adaptive
        %   filter as a scalar or a vector of length equal to the Length
        %   property value. The adaptive filter object uses these
        %   coefficients to compute the initial frequency-domain filter
        %   coefficients. The default value of this property is 0.
        InitialCoefficients;

        %InitialPower Initial FFT input signal power
        %   Specify the initial common value of all of the FFT input signal
        %   powers as a scalar positive numeric value. The default value of
        %   this property is 1.
        InitialPower;

        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs and it is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;

        %LeakageFactor Adaptation leakage factor
        %   Specify the leakage factor used in leaky adaptive filter as a
        %   scalar numeric value between 0 and 1, both inclusive. When the
        %   value is less than 1, the System object implements a leaky
        %   adaptive algorithm. The default value of this property is 1,
        %   providing no leakage in the adapting method.
        LeakageFactor;

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
        %   of [{'Constrained FDAF'} | 'Unconstrained FDAF'].
        Method;

        %Offset Offset for the normalization terms
        %   Specify the offset for the normalization terms in the
        %   coefficient updates as a scalar non-negative numeric value.
        %   This property value is used to avoid divide by zeros or divide
        %   by very small numbers if any of the FFT input signal powers
        %   become very small. The default value of this property is 0.
        Offset;

        %Power Current FFT input signal power
        %   This property stores the current values of FFT input signal
        %   powers as a column vector. The length of this vector is equal
        %   to the sum of the Length property value and the BlockLength
        %   property value. This property is initialized to a vector of
        %   appropriate length and data type with each of the elements
        %   equal to the InitialPower property value.
        Power;

        %States Current internal states of the filter
        %   This property stores the current internal states of the filter
        %   as a column vector. The length of this vector is equal to the
        %   Length property value. This property is initialized to a vector
        %   of zeros of appropriate length and data type.
        States;

        %StepSize Adaptation step size
        %   Specify the adaptation step size factor as a positive numeric
        %   scalar less than or equal to 1. Setting the StepSize property
        %   equal to one provides the fastest convergence during
        %   adaptation. The default value of this property is 1.
        StepSize;

        % The following private properties are used to store dsp.FFT System
        % objects to compute FFT of various variables in the setup, reset
        % and step methods.
        hFFTIC;

        hFFTW;

        hFFTX;

        hIFFTY;

        %privBlockLength A private property to store the value explicitly
        %   set to the BlockLength property.
        privBlockLength;

        %privBlockLengthDefined A Private logical property to denote
        %   whether the BlockLength property has been explicitly set.
        privBlockLengthDefined;

    end
end
