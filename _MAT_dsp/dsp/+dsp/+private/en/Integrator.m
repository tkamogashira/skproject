classdef Integrator< handle
%Integrator Intergrates input signal
%   HINT = dsp.Integrator returns a System object, HINT, that integrates an
%   input signal. Inputs and outputs to the object are signed fixed-point
%   data types. A Fixed-Point Designer license is required to use this
%   System object.
%
%   HINT = dsp.Integrator('PropertyName', PropertyValue, ...) returns an
%   Integrator object, HINT, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HINT, X) integrates fixed-point input X to produce a
%   fixed-point output Y using the integrator object HINT.
%
%   Integrator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create integrator object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the internal states to initial conditions
%
%   Integrator properties:
%
%   CustomAccumulatorDataType - Custom accumulator data type

     
%   Copyright 2012 The MathWorks, Inc.

    methods
        function out=Integrator
            %Integrator Intergrates input signal
            %   HINT = dsp.Integrator returns a System object, HINT, that integrates an
            %   input signal. Inputs and outputs to the object are signed fixed-point
            %   data types. A Fixed-Point Designer license is required to use this
            %   System object.
            %
            %   HINT = dsp.Integrator('PropertyName', PropertyValue, ...) returns an
            %   Integrator object, HINT, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HINT, X) integrates fixed-point input X to produce a
            %   fixed-point output Y using the integrator object HINT.
            %
            %   Integrator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create integrator object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the internal states to initial conditions
            %
            %   Integrator properties:
            %
            %   CustomAccumulatorDataType - Custom accumulator data type
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
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

    end
end
