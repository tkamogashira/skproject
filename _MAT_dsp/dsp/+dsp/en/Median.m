classdef Median< handle
%Median Median values of an input
%   HMDN = dsp.Median returns a System object, HMDN, that computes the
%   median of the input or a sequence of inputs.
%
%   HMDN = dsp.Median('PropertyName', PropertyValue, ...) returns a median
%   System object, HMDN, with each specified property set to the specified
%   value.
%
%   Step method syntax:
%
%   Y = step(HMDN, X) computes Y as the median of input X.
%
%   Median methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create median object with same property values
%   isLocked - Locked status (logical)
%
%   Median properties:
%
%   SortMethod      - Sort method
%   Dimension       - Dimension to operate along
%   CustomDimension - Numerical dimension to operate along
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.Median.helpFixedPoint.
%
%   % EXAMPLE:
%       hmdn = dsp.Median;
%       x = [7 -9 0 -1 2 0 3 5 -9]';
%       y = step(hmdn, x)
%
%   See also dsp.Mean, dsp.Minimum, dsp.Maximum,
%            dsp.Variance, dsp.Median.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=Median
            %Median Median values of an input
            %   HMDN = dsp.Median returns a System object, HMDN, that computes the
            %   median of the input or a sequence of inputs.
            %
            %   HMDN = dsp.Median('PropertyName', PropertyValue, ...) returns a median
            %   System object, HMDN, with each specified property set to the specified
            %   value.
            %
            %   Step method syntax:
            %
            %   Y = step(HMDN, X) computes Y as the median of input X.
            %
            %   Median methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create median object with same property values
            %   isLocked - Locked status (logical)
            %
            %   Median properties:
            %
            %   SortMethod      - Sort method
            %   Dimension       - Dimension to operate along
            %   CustomDimension - Numerical dimension to operate along
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.Median.helpFixedPoint.
            %
            %   % EXAMPLE:
            %       hmdn = dsp.Median;
            %       x = [7 -9 0 -1 2 0 3 5 -9]';
            %       y = step(hmdn, x)
            %
            %   See also dsp.Mean, dsp.Minimum, dsp.Maximum,
            %            dsp.Variance, dsp.Median.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.Median System object fixed-point
            %               information
            %   dsp.Median.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.Median
            %   System object.
        end

    end
    methods (Abstract)
    end
    properties
        %Dimension Dimension to operate along
        %   Specify how the calculation is performed over the data as one of
        %   ['All' | 'Row' | {'Column'} | 'Custom'].
        Dimension;

    end
end
