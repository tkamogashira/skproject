classdef LSFToLPC< handle
%LSFToLPC Convert line spectral frequencies to linear prediction 
%coefficients
%   HLSF2LPC = dsp.LSFToLPC returns a System object, HLSF2LPC, which
%   converts line spectral frequencies (LSFs) to linear prediction
%   coefficients (LPCs).
%
%   Step method syntax:
%
%   A = step(HLSF2LPC, LSF) converts the input line spectral frequencies in
%   the range (0,pi), LSF, to linear prediction coefficients, A. The input
%   can be a vector or a matrix, where each column of the matrix is treated
%   as a separate channel.
%
%   LSFToLPC methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create LSF to LPC conversion object with same property
%              values
%   isLocked - Locked status (logical)
%
%   % EXAMPLE: Convert line spectral frequencies to linear prediction
%   %          coefficients.
%      a = [1.0000  0.6149  0.9899  0.0000  0.0031 -0.0082]'
%      hlpc2lsf = dsp.LPCToLSF;
%      ylsf = step(hlpc2lsf, a);
%      hlsf2lpc = dsp.LSFToLPC;
%      ylpc = step(hlsf2lpc, ylsf) % Check values are same as a.
%
%   See also dsp.LPCToLSF, dsp.LSPToLPC.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=LSFToLPC
            %LSFToLPC Convert line spectral frequencies to linear prediction 
            %coefficients
            %   HLSF2LPC = dsp.LSFToLPC returns a System object, HLSF2LPC, which
            %   converts line spectral frequencies (LSFs) to linear prediction
            %   coefficients (LPCs).
            %
            %   Step method syntax:
            %
            %   A = step(HLSF2LPC, LSF) converts the input line spectral frequencies in
            %   the range (0,pi), LSF, to linear prediction coefficients, A. The input
            %   can be a vector or a matrix, where each column of the matrix is treated
            %   as a separate channel.
            %
            %   LSFToLPC methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create LSF to LPC conversion object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   % EXAMPLE: Convert line spectral frequencies to linear prediction
            %   %          coefficients.
            %      a = [1.0000  0.6149  0.9899  0.0000  0.0031 -0.0082]'
            %      hlpc2lsf = dsp.LPCToLSF;
            %      ylsf = step(hlpc2lsf, a);
            %      hlsf2lpc = dsp.LSFToLPC;
            %      ylpc = step(hlsf2lpc, ylsf) % Check values are same as a.
            %
            %   See also dsp.LPCToLSF, dsp.LSPToLPC.
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
end
