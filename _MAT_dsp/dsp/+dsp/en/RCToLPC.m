classdef RCToLPC< handle
%RCToLPC Convert reflection coefficients to linear prediction coefficients
%   HRC2LPC = dsp.RCToLPC returns a System object, HRC2LPC, that converts
%   reflection coefficients (RC) to linear prediction coefficients (LPC).
%
%   HRC2LPC = dsp.RCToLPC('PropertyName', PropertyValue, ...) returns an RC
%   to LPC conversion object, HRC2LPC, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   [A, P] = step(HRC2LPC, K) converts the columns of the reflection
%   coefficients, K, to linear prediction coefficients, A, and outputs the
%   normalized prediction error power, P.
%
%   A = step(HRC2LPC, K) converts the columns of the reflection
%   coefficients, K, to linear prediction coefficients, A, when the
%   PredictionErrorOutputPort property is false.
%
%   [..., S] = step(HRC2LPC, K) also outputs the LPC filter stability, S,
%   when the ExceptionOutputPort property is true.
%
%   RCToLPC methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create RC to LPC conversion object with same property values
%   isLocked - Locked status (logical)
%
%   RCToLPC properties:
%
%   PredictionErrorOutputPort - Enables normalized prediction error power
%                               output
%   ExceptionOutputPort       - Produces an output with the stability
%                               status of filter represented by RCs
%
%   % EXAMPLE: Convert reflection coefficients to linear prediction 
%   %          coefficients.
%       hlevinson = dsp.LevinsonSolver;
%       hac = dsp.Autocorrelator;
%       hac.MaximumLagSource = 'Property';
%       hac.MaximumLag = 10;   % Compute autocorrelation lags between [0:10]
%       hrc2lpc = dsp.RCToLPC;
%       x = (1:100)';
%       a = step(hac, x);
%       k = step(hlevinson, a); % Compute reflection coefficients
%       [A, P] = step(hrc2lpc, k);
%
%   See also dsp.LPCToRC, dsp.LPCToAutocorrelation.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=RCToLPC
            %RCToLPC Convert reflection coefficients to linear prediction coefficients
            %   HRC2LPC = dsp.RCToLPC returns a System object, HRC2LPC, that converts
            %   reflection coefficients (RC) to linear prediction coefficients (LPC).
            %
            %   HRC2LPC = dsp.RCToLPC('PropertyName', PropertyValue, ...) returns an RC
            %   to LPC conversion object, HRC2LPC, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   [A, P] = step(HRC2LPC, K) converts the columns of the reflection
            %   coefficients, K, to linear prediction coefficients, A, and outputs the
            %   normalized prediction error power, P.
            %
            %   A = step(HRC2LPC, K) converts the columns of the reflection
            %   coefficients, K, to linear prediction coefficients, A, when the
            %   PredictionErrorOutputPort property is false.
            %
            %   [..., S] = step(HRC2LPC, K) also outputs the LPC filter stability, S,
            %   when the ExceptionOutputPort property is true.
            %
            %   RCToLPC methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create RC to LPC conversion object with same property values
            %   isLocked - Locked status (logical)
            %
            %   RCToLPC properties:
            %
            %   PredictionErrorOutputPort - Enables normalized prediction error power
            %                               output
            %   ExceptionOutputPort       - Produces an output with the stability
            %                               status of filter represented by RCs
            %
            %   % EXAMPLE: Convert reflection coefficients to linear prediction 
            %   %          coefficients.
            %       hlevinson = dsp.LevinsonSolver;
            %       hac = dsp.Autocorrelator;
            %       hac.MaximumLagSource = 'Property';
            %       hac.MaximumLag = 10;   % Compute autocorrelation lags between [0:10]
            %       hrc2lpc = dsp.RCToLPC;
            %       x = (1:100)';
            %       a = step(hac, x);
            %       k = step(hlevinson, a); % Compute reflection coefficients
            %       [A, P] = step(hrc2lpc, k);
            %
            %   See also dsp.LPCToRC, dsp.LPCToAutocorrelation.
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
        %   represented by the LPC or RC coefficients. The lattice filter
        %   represented by the RCs is stable when the absolute value of each
        %   reflection coefficient is less than 1. The output is a vector of
        %   length equal to the number of channels; logical values of 1
        %   indicate a stable filter and logical values of 0 indicate an
        %   unstable filter. The default value of this property is false.
        ExceptionOutputPort;

        %PredictionErrorOutputPort Enables normalized prediction error power
        %                          output
        %   Set this property to true to return the normalized error power as
        %   a vector with one element per input channel. Each element varies
        %   between zero and one. The default value of this property is true.
        PredictionErrorOutputPort;

    end
end
