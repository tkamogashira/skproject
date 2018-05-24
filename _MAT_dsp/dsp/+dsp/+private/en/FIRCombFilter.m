classdef FIRCombFilter< handle
%FIRCombFilter FIR Comb Filter
%   HCOMB = dsp.FIRCombFilter returns a System object, HCOMB, that applies
%   an FIR comb filter to the input signal. Inputs and outputs to the
%   object are signed fixed-point data types. A Fixed-Point Designer license
%   is required to use this System object.
%
%   HCOMB = dsp.FIRCombFilter('PropertyName', PropertyValue, ...) returns
%   an FIR comb filter object, HCOMB, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   Y = step(HCOMB, X) filters fixed-point input X to produce a fixed-point
%   output Y using the FIR comb filter object HCOMB.
%
%   FIR comb filter methods:
%
%   step     - See above description for use of this method 
%   release  - Allow property value and input characteristics changes 
%   clone    - Create integrator object with same property values 
%   isLocked - Locked status (logical) 
%   reset    - Reset the internal states to initial conditions
%
%   FIR comb filter properties:
%
%   DelayLength               - Amount of delay on FIR comb filter
%   CustomAccumulatorDataType - Custom accumulator data type

     
%   Copyright 2012 The MathWorks, Inc.

    methods
        function out=FIRCombFilter
            %FIRCombFilter FIR Comb Filter
            %   HCOMB = dsp.FIRCombFilter returns a System object, HCOMB, that applies
            %   an FIR comb filter to the input signal. Inputs and outputs to the
            %   object are signed fixed-point data types. A Fixed-Point Designer license
            %   is required to use this System object.
            %
            %   HCOMB = dsp.FIRCombFilter('PropertyName', PropertyValue, ...) returns
            %   an FIR comb filter object, HCOMB, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HCOMB, X) filters fixed-point input X to produce a fixed-point
            %   output Y using the FIR comb filter object HCOMB.
            %
            %   FIR comb filter methods:
            %
            %   step     - See above description for use of this method 
            %   release  - Allow property value and input characteristics changes 
            %   clone    - Create integrator object with same property values 
            %   isLocked - Locked status (logical) 
            %   reset    - Reset the internal states to initial conditions
            %
            %   FIR comb filter properties:
            %
            %   DelayLength               - Amount of delay on FIR comb filter
            %   CustomAccumulatorDataType - Custom accumulator data type
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isInputSizeLockedImpl(in) %#ok<MANU>
        end

        function isOutputComplexityLockedImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as a signed, scaled
        %   numerictype object. The default value of this property is
        %   numerictype(true,16,0).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %DelayLength Amount of delay
        %   Specify amount of delay for the FIR comb filter. This property
        %   must be set to a scalar. The default value of this property is 1.
        DelayLength;

    end
end
