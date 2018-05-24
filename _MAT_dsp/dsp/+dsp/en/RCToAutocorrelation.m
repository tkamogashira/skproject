classdef RCToAutocorrelation< handle
%RCToAutocorrelation Convert reflection coefficients to autocorrelation
%coefficients
%   HRC2AC = dsp.RCToAutocorrelation returns a System object, HRC2AC, that
%   converts reflection coefficients to autocorrelation coefficients.
%
%   HRC2AC = dsp.RCToAutocorrelation('PropertyName', PropertyValue, ...)
%   returns an object, HRC2AC, that converts reflection coefficients into
%   autocorrelation coefficients, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   AC = step(HRC2AC, K) converts the columns of the reflection
%   coefficients, K, to autocorrelation coefficients, AC.
%
%   AC = step(HRC2AC, K, P) converts the columns of the reflection
%   coefficients, K, to autocorrelation coefficients, AC, using P as the
%   prediction error power, when the PredictionErrorInputPort property is
%   true. P must be a row vector with same number of columns as in K.
%
%   RCToAutocorrelation methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create RC to autocorrelation conversion object with same
%              property values
%   isLocked - Locked status (logical)
%
%   RCToAutocorrelation properties:
%
%   PredictionErrorInputPort - Enable prediction error power input
%
%   % EXAMPLE: Convert RC to autocorrelation coefficients.
%      k = [-0.8091 0.2525 -0.5044 0.4295 -0.2804 0.0711].';
%      hrc2ac = dsp.RCToAutocorrelation;
%      ac = step(hrc2ac, k);
%
%   See also dsp.LPCToLSF, dsp.LPCToRC,
%            dsp.LPCToCepstral, dsp.LPCToAutocorrelation.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=RCToAutocorrelation
            %RCToAutocorrelation Convert reflection coefficients to autocorrelation
            %coefficients
            %   HRC2AC = dsp.RCToAutocorrelation returns a System object, HRC2AC, that
            %   converts reflection coefficients to autocorrelation coefficients.
            %
            %   HRC2AC = dsp.RCToAutocorrelation('PropertyName', PropertyValue, ...)
            %   returns an object, HRC2AC, that converts reflection coefficients into
            %   autocorrelation coefficients, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   AC = step(HRC2AC, K) converts the columns of the reflection
            %   coefficients, K, to autocorrelation coefficients, AC.
            %
            %   AC = step(HRC2AC, K, P) converts the columns of the reflection
            %   coefficients, K, to autocorrelation coefficients, AC, using P as the
            %   prediction error power, when the PredictionErrorInputPort property is
            %   true. P must be a row vector with same number of columns as in K.
            %
            %   RCToAutocorrelation methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create RC to autocorrelation conversion object with same
            %              property values
            %   isLocked - Locked status (logical)
            %
            %   RCToAutocorrelation properties:
            %
            %   PredictionErrorInputPort - Enable prediction error power input
            %
            %   % EXAMPLE: Convert RC to autocorrelation coefficients.
            %      k = [-0.8091 0.2525 -0.5044 0.4295 -0.2804 0.0711].';
            %      hrc2ac = dsp.RCToAutocorrelation;
            %      ac = step(hrc2ac, k);
            %
            %   See also dsp.LPCToLSF, dsp.LPCToRC,
            %            dsp.LPCToCepstral, dsp.LPCToAutocorrelation.
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %PredictionErrorInputPort Enable prediction error power input
        %   Choose how to select the prediction error power. When this property
        %   is set to true, the prediction error power must be specified as a
        %   second input to the step method. When this property is set to
        %   false, the prediction error power is assumed to be 1. By default,
        %   the property is false.
        PredictionErrorInputPort;

    end
end
