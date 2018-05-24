classdef SecondOrderSectionFilter< handle
%SECONDORDERSECTIONFILTER Implements filter formed of cascade of second
%order sections. 

 
%   Copyright 2013 The MathWorks, Inc.

    methods
        function out=SecondOrderSectionFilter
            % Constructor
        end

        function convertToDFILT(in) %#ok<MANU>
            % Delegate to convertToDFILT method of equivalent dsp.BiquadFilter
            % object
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
            % release biquad filter
        end

        function resetImpl(in) %#ok<MANU>
            % reset biquad filter
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Setup Biquad Filter
        end

        function stepImpl(in) %#ok<MANU>
            % use dsp.BiquadFilter to perofrm filtering. Coefficients and
            % gains are tunable (specified from input port)
        end

    end
    methods (Abstract)
    end
    properties
        % Denominator Denominator coefficients of size Lx2, where L is
        % the number of sections. The first coefficient is always unity.
        Denominator;

        % Numerator Numerator coefficients of size Lx3, where L is the
        % number of sections.
        Numerator;

        % ScaleValues Scale values of the sections, of length L+1, where
        % L is the number of sections.
        ScaleValues;

    end
end
