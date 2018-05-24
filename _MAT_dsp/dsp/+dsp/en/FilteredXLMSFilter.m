classdef FilteredXLMSFilter< handle
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

    methods
        function out=FilteredXLMSFilter
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
            % Get default parameters group for this System object, and mark
            % SecondaryPathEstimate as dependent on private-only
        end

        function initializeVariables(in) %#ok<MANU>
        end

        function loadFilterDiscreteStates(in) %#ok<MANU>
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

        function saveFilterDiscreteStates(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Set InputDataType to be the data type of x and initialize the
            % FilterParameters property based on that. The FilterParameters
            % property is a structure with all the filter parameters casted
            % to the data type of the inputs.
        end

        function stepImpl(in) %#ok<MANU>
            % Load the required properties.
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
        %Coefficients Current coefficients of the adaptive filter
        %   This property stores the current coefficients of the filter
        %   as a row vector of length equal to the Length property value.
        %   This property is initialized to the values of
        %   InitialCoefficients property.
        Coefficients;

        %FilterParameters Private property to store the filter parameters
        %   This is a private MATLAB structure that stores all the filter
        %   parameters casted to the data type of the inputs. StepSize,
        %   LeakageFactor, SecondaryPathCoefficients, SecondaryPathEstimate
        %   and LockCoefficients are the filter parameters. This property
        %   is initialized in the setup method.
        FilterParameters;

        %FilteredInputStates Current filtered input states of the adaptive
        %                    filter
        %   This property stores the current filtered input states of the
        %   adaptive filter as a column vector. The length of this vector
        %   is equal to the Length property value. This property is
        %   initialized to a vector of zeros of appropriate length and data
        %   type.
        FilteredInputStates;

        %InitialCoefficients Initial coefficients of the filter
        %   Specify the initial values of the FIR adaptive filter
        %   coefficients as a scalar or a vector of length equal to the
        %   Length property value. The default value of this property is 0.
        InitialCoefficients;

        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs. It is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;

        %LeakageFactor Adaptation leakage factor
        %   Specify the leakage factor used in leaky adaptive filter as a
        %   numeric value between 0 and 1, both inclusive. When the value
        %   is less than 1, the System object implements a leaky adaptive
        %   algorithm. The default value of this property is 1, providing
        %   no leakage in the adapting method.
        LeakageFactor;

        %Length Length of the filter coefficients vector
        %   Specify the length of the FIR filter coefficients vector as a
        %   positive integer value. The default value of this property is
        %   10.
        Length;

        %LockCoefficients Lock the coefficient updates
        %   Specify whether the filter coefficient values should be locked.
        %   By default, the value of this property is false, and the object
        %   continuously updates the filter coefficients. If this property
        %   is set to true, the filter coefficients do not get updated and
        %   their values remain at the current value.
        LockCoefficients;

        %SecondaryPathCoefficients Coefficients of the secondary path
        %                          filter model
        %   Specify the coefficients of the secondary path filter model as
        %   a numeric vector. The secondary path exists between the output
        %   actuator and the error sensor. The default value of this
        %   property is a vector that represents the coefficients of a 10th
        %   order FIR low-pass filter.
        SecondaryPathCoefficients;

        %SecondaryPathEstimate An estimate of the secondary path filter
        %                      model
        %   Specify the estimate of the secondary path filter model as a
        %   numeric vector. The secondary path exists between the output
        %   actuator and the error sensor. The default value of this
        %   property is equal to the SecondayPathCoefficients property
        %   value. This is not a tunable property.
        SecondaryPathEstimate;

        %SecondaryPathStates Current states of the secondary path filter
        %   This property stores the current states of the secondary path
        %   filter model as a column vector. The length of this vector is
        %   equal to the length of the SecondaryPathCoefficients property
        %   value. This property is initialized to a vector of zeros of
        %   appropriate length and data type.
        SecondaryPathStates;

        %States Current internal states of the adaptive filter
        %   This property stores the current internal states of the filter
        %   as a column vector. Its length is equal to the maximum of the
        %   Length property value and the length of the
        %   SecondaryPathEstimate property value. This property is
        %   initialized to a vector of zeros of appropriate length and data
        %   type.
        States;

        %StepSize Adaptation step size
        %   Specify the adaptation step size factor as a positive numeric
        %   scalar. The default value of this property is 0.1.
        StepSize;

    end
end
