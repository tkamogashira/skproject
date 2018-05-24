classdef LPCToCepstral< handle
%LPCToCepstral Convert linear prediction coefficients to cepstral 
%coefficients
%   HLPC2CC = dsp.LPCToCepstral returns a System object, HLPC2CC, that
%   converts linear prediction coefficients (LPCs) to cepstral coefficients
%   (CCs).
%
%   HLPC2CC = dsp.LPCToCepstral('PropertyName', PropertyValue, ...) returns
%   an LPC to cepstral converter object, HLPC2CC, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   CC = step(HLPC2CC, A) computes the cepstral coefficients, CC, from the
%   columns of input LPC coefficients, A. The prediction error power is
%   assumed to be 1.
%
%   CC = step(HLPC2CC, A, P) converts LPC coefficients to cepstral
%   coefficients, using P as the prediction error power, when the
%   PredictionErrorInputPort property is true.
%
%   LPCToCepstral methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create LPC to cepstral converter object with same property
%              values
%   isLocked - Locked status (logical)
%
%   LPCToCepstral properties:
%
%   PredictionErrorInputPort       - Enable prediction error power input
%   CepstrumLengthSource           - Source of cepstrum length
%   CepstrumLength                 - Number of output cepstral coefficients
%   NonUnityFirstCoefficientAction - Action to take when first LPC
%                                    coefficient is not 1
%
%   % EXAMPLE: Convert LPC to cepstral coefficients. 
%       hlevinson = dsp.LevinsonSolver;
%       hlevinson.AOutputPort = true; % Output polynomial coefficients
%       hac = dsp.Autocorrelator;
%       hac.MaximumLagSource = 'Property';
%       hac.MaximumLag = 9;     % Compute autocorrelation lags between [0:9]
%       hlpc2cc = dsp.LPCToCepstral;
%       x = [1:100]';
%       a = step(hac, x);
%       A = step(hlevinson, a);  % Compute LPC coefficients
%       CC = step(hlpc2cc, A);   % Convert LPC to CC.
%
%   See also dsp.CepstralToLPC, dsp.LPCToLSF, 
%            dsp.LPCToRC.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=LPCToCepstral
            %LPCToCepstral Convert linear prediction coefficients to cepstral 
            %coefficients
            %   HLPC2CC = dsp.LPCToCepstral returns a System object, HLPC2CC, that
            %   converts linear prediction coefficients (LPCs) to cepstral coefficients
            %   (CCs).
            %
            %   HLPC2CC = dsp.LPCToCepstral('PropertyName', PropertyValue, ...) returns
            %   an LPC to cepstral converter object, HLPC2CC, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   CC = step(HLPC2CC, A) computes the cepstral coefficients, CC, from the
            %   columns of input LPC coefficients, A. The prediction error power is
            %   assumed to be 1.
            %
            %   CC = step(HLPC2CC, A, P) converts LPC coefficients to cepstral
            %   coefficients, using P as the prediction error power, when the
            %   PredictionErrorInputPort property is true.
            %
            %   LPCToCepstral methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create LPC to cepstral converter object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   LPCToCepstral properties:
            %
            %   PredictionErrorInputPort       - Enable prediction error power input
            %   CepstrumLengthSource           - Source of cepstrum length
            %   CepstrumLength                 - Number of output cepstral coefficients
            %   NonUnityFirstCoefficientAction - Action to take when first LPC
            %                                    coefficient is not 1
            %
            %   % EXAMPLE: Convert LPC to cepstral coefficients. 
            %       hlevinson = dsp.LevinsonSolver;
            %       hlevinson.AOutputPort = true; % Output polynomial coefficients
            %       hac = dsp.Autocorrelator;
            %       hac.MaximumLagSource = 'Property';
            %       hac.MaximumLag = 9;     % Compute autocorrelation lags between [0:9]
            %       hlpc2cc = dsp.LPCToCepstral;
            %       x = [1:100]';
            %       a = step(hac, x);
            %       A = step(hlevinson, a);  % Compute LPC coefficients
            %       CC = step(hlpc2cc, A);   % Convert LPC to CC.
            %
            %   See also dsp.CepstralToLPC, dsp.LPCToLSF, 
            %            dsp.LPCToRC.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %CepstrumLength Number of output cepstral coefficients
        %   Set the length of the output cepstral coefficients vector as a
        %   scalar numeric integer. This property is applicable when the
        %   CepstrumLengthSource property is 'Property'. The default value of
        %   this property is 10.
        CepstrumLength;

        %CepstrumLengthSource Source of cepstrum length
        %   Select how to specify the length of cepstral coefficients as one of
        %   ['Auto' | {'Property'}]. When this property is set to 'Auto', the
        %   length of each channel of the cepstral coefficients output is the
        %   same as the length of each channel of the input LPC coefficients.
        CepstrumLengthSource;

        %NonUnityFirstCoefficientAction Action to take when first
        %                               LPCcoefficient is not 1
        %   Specify the action that the System object should take when the
        %   first coefficient of each channel of the LPC input is not 1 as one
        %   of [{'Replace with 1'} | 'Normalize'].
        NonUnityFirstCoefficientAction;

        %PredictionErrorInputPort Enable prediction error power input
        %   Choose how to set the prediction error power. When this property is
        %   set to true, the prediction error power must be specified as a
        %   second input to the step method. When this property is set to
        %   false, the prediction error power is assumed to be 1. By default,
        %   the property is false.
        PredictionErrorInputPort;

    end
end
