classdef LPCToRC< handle
%LPCToRC Convert linear prediction coefficients to reflection coefficients
%   HLPC2RC = dsp.LPCToRC returns a System object, HLPC2RC, that converts
%   linear prediction coefficients (LPC) to reflection coefficients (RC).
%
%   HLPC2RC = dsp.LPCToRC('PropertyName', PropertyValue, ...) returns an
%   LPC to RC conversion object, HLPC2RC, with each specified property set
%   to the specified value.
%
%   Step method syntax:
%
%   [K, P] = step(HLPC2RC, A) converts the columns of linear prediction
%   coefficients, A, to reflection coefficients K and outputs the
%   normalized prediction error power, P.
%
%   K = step(HLPC2RC, A) converts the columns of linear prediction
%   coefficients, A, to reflection coefficients K, when the
%   PredictionErrorOutputPort property is false.
%
%   [..., S] = step(HLPC2RC, A) also outputs the LPC filter stability, S,
%   when the ExceptionOutputPort property is true.
%
%   LPCToRC methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create LPC to RC conversion object with same property values
%   isLocked - Locked status (logical)
%
%   LPCToRC properties:
%
%   PredictionErrorOutputPort      - Enables normalized prediction error
%                                    power output
%   ExceptionOutputPort            - Produces an output with the stability
%                                    status of filter represented by RCs
%   NonUnityFirstCoefficientAction - Action to take when first LPC
%                                    coefficient is not 1
%
%   % EXAMPLE: Convert linear prediction coefficients to reflection 
%   %          coefficients.
%       load mtlb
%       hlevinson = dsp.LevinsonSolver;
%       hlevinson.AOutputPort = true;
%       hlevinson.KOutputPort = false;
%       hac = dsp.Autocorrelator;
%       hlpc2rc = dsp.LPCToRC;
%       hac.MaximumLagSource = 'Property';
%       hac.MaximumLag = 10; % Compute autocorrelation for lags between [0:10]
%       a = step(hac, mtlb);
%       A = step(hlevinson, a);     % Compute LPC coefficients
%       [K, P] = step(hlpc2rc, A);  % Convert to RC
%
%   See also dsp.RCToLPC, dsp.LPCToAutocorrelation.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=LPCToRC
            %LPCToRC Convert linear prediction coefficients to reflection coefficients
            %   HLPC2RC = dsp.LPCToRC returns a System object, HLPC2RC, that converts
            %   linear prediction coefficients (LPC) to reflection coefficients (RC).
            %
            %   HLPC2RC = dsp.LPCToRC('PropertyName', PropertyValue, ...) returns an
            %   LPC to RC conversion object, HLPC2RC, with each specified property set
            %   to the specified value.
            %
            %   Step method syntax:
            %
            %   [K, P] = step(HLPC2RC, A) converts the columns of linear prediction
            %   coefficients, A, to reflection coefficients K and outputs the
            %   normalized prediction error power, P.
            %
            %   K = step(HLPC2RC, A) converts the columns of linear prediction
            %   coefficients, A, to reflection coefficients K, when the
            %   PredictionErrorOutputPort property is false.
            %
            %   [..., S] = step(HLPC2RC, A) also outputs the LPC filter stability, S,
            %   when the ExceptionOutputPort property is true.
            %
            %   LPCToRC methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create LPC to RC conversion object with same property values
            %   isLocked - Locked status (logical)
            %
            %   LPCToRC properties:
            %
            %   PredictionErrorOutputPort      - Enables normalized prediction error
            %                                    power output
            %   ExceptionOutputPort            - Produces an output with the stability
            %                                    status of filter represented by RCs
            %   NonUnityFirstCoefficientAction - Action to take when first LPC
            %                                    coefficient is not 1
            %
            %   % EXAMPLE: Convert linear prediction coefficients to reflection 
            %   %          coefficients.
            %       load mtlb
            %       hlevinson = dsp.LevinsonSolver;
            %       hlevinson.AOutputPort = true;
            %       hlevinson.KOutputPort = false;
            %       hac = dsp.Autocorrelator;
            %       hlpc2rc = dsp.LPCToRC;
            %       hac.MaximumLagSource = 'Property';
            %       hac.MaximumLag = 10; % Compute autocorrelation for lags between [0:10]
            %       a = step(hac, mtlb);
            %       A = step(hlevinson, a);     % Compute LPC coefficients
            %       [K, P] = step(hlpc2rc, A);  % Convert to RC
            %
            %   See also dsp.RCToLPC, dsp.LPCToAutocorrelation.
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %ExceptionOutputPort Produces an output with the stability status of 
        %                    filter represented by RCs
        %   Set this property to true to return the stability of the filter
        %   represented by the RC coefficients. The output is a vector of
        %   length equal to the number of channels; logical values of 1
        %   indicate a stable filter and logical values of 0 indicate an
        %   unstable filter. The default value of this property is false.
        ExceptionOutputPort;

        %NonUnityFirstCoefficientAction Action to take when first LPC
        %                               coefficient is not 1
        %   Specify the action that the object should take when the first
        %   coefficient of each channel of the LPC input is not 1 as one of
        %   [{'Replace with 1'} | 'Normalize'].
        NonUnityFirstCoefficientAction;

        %PredictionErrorOutputPort Enables normalized prediction error power
        %                          output
        %   Set this property to true to return the normalized error power as
        %   a vector with one element per input channel. Each element varies
        %   between zero and one. The default value of this property is true.
        PredictionErrorOutputPort;

    end
end
