classdef LPCToAutocorrelation< handle
%LPCToAutocorrelation Convert linear prediction coefficients to
%autocorrelation coefficients
%   HLPC2AC = dsp.LPCToAutocorrelation returns a System object, HLPC2AC,
%   that converts linear prediction coefficients (LPC) to autocorrelation
%   coefficients.
%
%   HLPC2AC = dsp.LPCToAutocorrelation('PropertyName', PropertyValue, ...)
%   returns an LPC to autocorrelation conversion object, HLPC2AC, with each
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   AC = step(HLPC2AC, A) converts the columns of the linear prediction
%   coefficients, A, to autocorrelation coefficients, AC. The prediction
%   error power is assumed to be 1.
%
%   AC = step(HLPC2AC, A, P) converts the columns of the linear prediction
%   coefficients, A, to autocorrelation coefficients, AC, using P as the
%   prediction error power, when the PredictionErrorInputPort property is
%   true. P must be a row vector with same number of columns as in A.
%
%   LPCToAutocorrelation methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create LPC to autocorrelation object with same property
%              values
%   isLocked - Locked status (logical)
%
%   LPCToAutocorrelation properties:
%
%   PredictionErrorInputPort       - Enable prediction error power input
%   NonUnityFirstCoefficientAction - Action to take when first LPC
%                                    coefficient is not 1
%
%   % EXAMPLE: Convert LPC to autocorrelation coefficients.
%      a = [1.0 -1.4978 1.4282 -1.3930 0.9076 -0.3855 0.0711].';
%      hlpc2ac = dsp.LPCToAutocorrelation;
%      ac = step(hlpc2ac, a);
%
%   See also dsp.LPCToLSF, dsp.LPCToRC,
%            dsp.LPCToCepstral, dsp.RCToAutocorrelation.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=LPCToAutocorrelation
            %LPCToAutocorrelation Convert linear prediction coefficients to
            %autocorrelation coefficients
            %   HLPC2AC = dsp.LPCToAutocorrelation returns a System object, HLPC2AC,
            %   that converts linear prediction coefficients (LPC) to autocorrelation
            %   coefficients.
            %
            %   HLPC2AC = dsp.LPCToAutocorrelation('PropertyName', PropertyValue, ...)
            %   returns an LPC to autocorrelation conversion object, HLPC2AC, with each
            %   specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   AC = step(HLPC2AC, A) converts the columns of the linear prediction
            %   coefficients, A, to autocorrelation coefficients, AC. The prediction
            %   error power is assumed to be 1.
            %
            %   AC = step(HLPC2AC, A, P) converts the columns of the linear prediction
            %   coefficients, A, to autocorrelation coefficients, AC, using P as the
            %   prediction error power, when the PredictionErrorInputPort property is
            %   true. P must be a row vector with same number of columns as in A.
            %
            %   LPCToAutocorrelation methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create LPC to autocorrelation object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   LPCToAutocorrelation properties:
            %
            %   PredictionErrorInputPort       - Enable prediction error power input
            %   NonUnityFirstCoefficientAction - Action to take when first LPC
            %                                    coefficient is not 1
            %
            %   % EXAMPLE: Convert LPC to autocorrelation coefficients.
            %      a = [1.0 -1.4978 1.4282 -1.3930 0.9076 -0.3855 0.0711].';
            %      hlpc2ac = dsp.LPCToAutocorrelation;
            %      ac = step(hlpc2ac, a);
            %
            %   See also dsp.LPCToLSF, dsp.LPCToRC,
            %            dsp.LPCToCepstral, dsp.RCToAutocorrelation.
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %NonUnityFirstCoefficientAction Action to take when first LPC
        %                               coefficient is not 1
        %   Specify the action that the System object should take when the
        %   first coefficient of each channel of the LPC input is not 1 as one
        %   of [{'Replace with 1'} | 'Normalize'].
        NonUnityFirstCoefficientAction;

        %PredictionErrorInputPort Enable prediction error power input
        %   Choose how to select the prediction error power. When this property
        %   is set to true, the prediction error power must be specified as a
        %   second input to the step method. When this property is set to
        %   false, the prediction error power is assumed to be 1. By default,
        %   the property is false.
        PredictionErrorInputPort;

    end
end
