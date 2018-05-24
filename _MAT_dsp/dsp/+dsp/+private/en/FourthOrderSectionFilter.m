classdef FourthOrderSectionFilter< handle
%FOURTHORDERSECTIONFILTER Implements filter formed of cascade of fourth
%order sections. 

 
%   Copyright 2013 The MathWorks, Inc.

    methods
        function out=FourthOrderSectionFilter
            % Constructor
        end

        function convertToDFILT(in) %#ok<MANU>
            % Returns equivalent dfilt to current object.
            % Fixed-point analysis is not currently supported
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
            % Initialize state matrix. Each input channel has seperate states. 
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Set the number of sections
        end

        function stepImpl(in) %#ok<MANU>
            % Pre-allocate some variables for performance
        end

    end
    methods (Abstract)
    end
    properties
        % Denominator - Denominator coefficients of size Lx5, where L is
        % the number of sections.
        Denominator;

        % Numerator - Numerator coefficients of size Lx5, where L is the
        % number of sections.
        Numerator;

        % ScaleValues - Scale values of the sections, of length L+1, where
        % L is the number of sections.
        ScaleValues;

    end
end
