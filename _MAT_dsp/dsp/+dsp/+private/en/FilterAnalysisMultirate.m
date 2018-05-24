classdef FilterAnalysisMultirate< handle
%FilterAnalysisMultirate Baseclass for multirate filter System object analysis

   
  %   Copyright 2011-2012 The MathWorks, Inc.

    methods
        function out=FilterAnalysisMultirate
            %FilterAnalysisMultirate Baseclass for multirate filter System object analysis
        end

        function freqrespest(in) %#ok<MANU>
        end

        function freqrespopts(in) %#ok<MANU>
        end

        function isNLMSupported(in) %#ok<MANU>
        end

        function noisepsd(in) %#ok<MANU>
        end

        function noisepsdopts(in) %#ok<MANU>
        end

        function polyphase(in) %#ok<MANU>
            %Polyphase decomposition of System object
            %   P = polyphase(H) returns the polyphase matrix of the filter
            %   System object, H. The ith row of the matrix P represents the ith
            %   subfilter.
            %
            %   P = polyphase(H,'Arithmetic',ARITH,...) analyzes the filter
            %   System object, H, based on the arithmetic specified in the ARITH
            %   input. ARITH can be set to one of 'double', 'single', or 'fixed'.
            %   The analysis tool assumes a double precision filter when the
            %   arithmetic input is not specified and the filter System object is
            %   in an unlocked state.
            %
            %   polyphase(H) called with no outputs launches the Filter
            %   Visualization Tool (FVTool) with all the polyphase subfilters to
            %   allow analyses of each component individually.
        end

        function ss(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
end
