classdef AffineProjectionFilter< handle
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

    methods
        function out=AffineProjectionFilter
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

        function initializeVariables(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
            % Whenever the tunable properties are changed, update the
            % private structure that stores the type casted version of
            % them.
        end

        function resetImpl(in) %#ok<MANU>
            % Local copy of the required properties
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setDiscreteStateImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Setting InputDataType to be the data type of x and setting
            % the FilterParameters property as a structure with the
            % required properties casted to that data type.
        end

        function stepImpl(in) %#ok<MANU>
            % Load states, properties and initialize variables
        end

        function updateBuffer(in) %#ok<MANU>
            % Function to assign the current input by shifting the buffer down
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Validating the size of the inputs x and d. Inputs must be
            % vectors.
        end

        function validatePropertiesImpl(in) %#ok<MANU>
            % Validating InitialCoefficients
        end

    end
    methods (Abstract)
    end
    properties
        %Coefficients Current coefficients of the filter
        %   This property stores the current coefficients of the filter as
        %   a row vector of length equal to the Length property value. This
        %   property is initialized to the values of InitialCoefficients
        %   property casted to the data type of the inputs.
        Coefficients;

        %CorrelationCoefficients Correlation coefficients of the filter
        %   This property stores the correlation coefficients for the FIR
        %   adaptive filter as a row vector. Its length is equal to
        %   (ProjectionOrder - 1). This property is applicable only if the
        %   Method property is set to 'Recursive Matrix Update'. This
        %   property is initialized to the values of
        %   InitialCorrelationCoefficients property casted to the data type
        %   of the inputs.
        CorrelationCoefficients;

        %EpsilonStates Epsilon values of the adaptive filter
        %   This property stores the current epsilon values of the adaptive
        %   filter as a column vector. Its length is equal to the
        %   ProjectionOrder property value. This property is initialized to
        %   a zero vector of appropriate length and data type.
        EpsilonStates;

        %ErrorStates Error states of the adaptive filter
        %   This property stores the current error states of the adaptive
        %   filter as a column vector. Its length is equal to the
        %   ProjectionOrder property value. This property is initialized to
        %   a zero vector of appropriate length and data type.
        ErrorStates;

        %FilterParameters Private structure to store the filter parameters
        %   This is a private MATLAB structure that stores all the filter
        %   parameters in the appropriate data type. For
        %   AffineProjectionFilter System object, StepSize and
        %   LockCoefficients are the filter parameters. This property is
        %   initialized in setup method.
        FilterParameters;

        %InitialCoefficients Initial coefficients of the filter
        %   Specify the initial values of the FIR adaptive filter
        %   coefficients as a scalar or a vector of length equal to the
        %   Length property value. The default value of this property is 0.
        InitialCoefficients;

        %InitialCorrelationCoefficients Initial correlation coefficients
        %   Specify the initial values of the correlation coefficients of
        %   the FIR filter as a scalar or a vector of length equal to
        %   (ProjectionOrder - 1). This property is applicable only if the
        %   Method property is set to 'Recursive Matrix Update'. The
        %   default value of this property is 0.
        InitialCorrelationCoefficients;

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
        InitialInverseOffsetCovariance;

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
        InitialOffsetCovariance;

        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs and it is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;

        %InverseOffsetCovariance Inverse of offset-covariance matrix
        %   This property stores the inverse of offset covariance matrix of
        %   the current inputs. It is a square matrix with each dimension
        %   equal to the ProjectionOrder property value. This property is
        %   applicable only if the Method property is set to 'Recursive
        %   Matrix Update'. This property is initialized to the values of
        %   InitialInverseOffsetCovariance property.
        InverseOffsetCovariance;

        %Length Length of the filter coefficients vector
        %   Specify the length of the FIR filter coefficients vector as a
        %   scalar positive integer value. The default value of this
        %   property is 32.
        Length;

        %LockCoefficients Lock the coefficient updates
        %   Specify whether the filter coefficient values should be locked.
        %   By default, the value of this property is false, and the object
        %   continuously updates the filter coefficients. When this
        %   property is set to true, the filter coefficients are not
        %   updated and their values remain at the current value.
        LockCoefficients;

        %Method Method to calculate the filter coefficients
        %   Specify the method used to calculate filter coefficients as one
        %   of [{'Direct Matrix Inversion'} | 'Recursive Matrix Update' |
        %   'Block Direct Matrix Inversion'].
        Method;

        %OffsetCovariance Offset covariance matrix
        %   This property stores the offset covariance matrix of the
        %   current inputs. It is a square matrix with each dimension equal
        %   to the ProjectionOrder property value. This property is
        %   applicable only if the Method property is set to 'Direct Matrix
        %   Inversion' or 'Block Direct Matrix Inversion'. This property is
        %   initialized to the values of the InitialOffsetCovariance
        %   property.
        OffsetCovariance;

        %ProjectionOrder Projection order of the affine projection
        %                algorithm
        %   Specify the projection order of the affine projection algorithm
        %   as a scalar positive integer value greater than or equal to 2.
        %   This property defines the size of the input signal covariance
        %   matrix. The default value of this property is 2.
        ProjectionOrder;

        %States Current internal states of the filter
        %   This property stores the current internal states of the filter
        %   as a column vector. Its length is equal to the sum of Length
        %   property and ProjectionOrder property. This property is
        %   initialized to a zero vector of appropriate length and data
        %   type as that of the inputs.
        States;

        %StepSize Affine projection step size
        %   Specify the affine projection step size factor as a scalar
        %   non-negative numeric value between 0 and 1, both inclusive.
        %   Setting step equal to one provides the fastest convergence
        %   during adaptation. The default value of this property is 1.
        StepSize;

    end
end
