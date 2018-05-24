classdef LSPToLPC< handle
%LSPToLPC Convert line spectral pairs to linear prediction 
%coefficients
%   HLSP2LPC = dsp.LSPToLPC returns a System object, HLSP2LPC, which
%   converts line spectral pairs (LSPs) to linear prediction coefficients
%   (LPCs).
%
%   Step method syntax:
%
%   A = step(HLSP2LPC, LSP) converts the input line spectral pairs in the
%   range (-1,1), LSP, to linear prediction coefficients, A. The input can
%   be a vector or a matrix, where each column of the matrix is treated as
%   a separate channel.
%
%   LSPToLPC methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create LSP to LPC conversion object with same property
%              values
%   isLocked - Locked status (logical)
%
%   % EXAMPLE: Convert line spectral pairs to linear prediction 
%   %          coefficients.
%      ylsp = [0.7080    0.0103   -0.3021   -0.3218   -0.7093]';
%      hlsp2lpc = dsp.LSPToLPC;
%      ylpc = step(hlsp2lpc, ylsp) 
%
%   See also dsp.LPCToLSP, dsp.LSFToLPC.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=LSPToLPC
            %LSPToLPC Convert line spectral pairs to linear prediction 
            %coefficients
            %   HLSP2LPC = dsp.LSPToLPC returns a System object, HLSP2LPC, which
            %   converts line spectral pairs (LSPs) to linear prediction coefficients
            %   (LPCs).
            %
            %   Step method syntax:
            %
            %   A = step(HLSP2LPC, LSP) converts the input line spectral pairs in the
            %   range (-1,1), LSP, to linear prediction coefficients, A. The input can
            %   be a vector or a matrix, where each column of the matrix is treated as
            %   a separate channel.
            %
            %   LSPToLPC methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create LSP to LPC conversion object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   % EXAMPLE: Convert line spectral pairs to linear prediction 
            %   %          coefficients.
            %      ylsp = [0.7080    0.0103   -0.3021   -0.3218   -0.7093]';
            %      hlsp2lpc = dsp.LSPToLPC;
            %      ylpc = step(hlsp2lpc, ylsp) 
            %
            %   See also dsp.LPCToLSP, dsp.LSFToLPC.
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
end
