classdef FilterAnalysisCIC< handle
%#codegen
%FilterAnalysisCIC Baseclass for CIC filter System object analysis

   
  %   Copyright 2011-2012 The MathWorks, Inc.

    methods
        function out=FilterAnalysisCIC
            %#codegen
            %FilterAnalysisCIC Baseclass for CIC filter System object analysis
        end

        function convertToDFILTCIC(in) %#ok<MANU>
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

        function parseArithmetic(in) %#ok<MANU>
            % Parse arithmetic input
            % Inputs:
            %
            % inputsCell    - cell containing PV-pairs. The method will look for
            %                 the 'Arithmetic' input, parse its value and delete
            %                 the PV-pair from the cell. It will return the
            %                 modified cell in the second output, inputsCell.
            % noDfilt       - If true, do not generate an mfilt object from the
            %                 System object and return the parsed arithmetic
            %                 string instead of the dfilt object in the first
            %                 output, d.
        end

        function realizemdl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
end
