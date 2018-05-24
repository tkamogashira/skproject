classdef CepstralToLPC< handle
%CepstralToLPC Convert cepstral coefficients to linear prediction 
%coefficients
%   HCC2LPC = dsp.CepstralToLPC returns a System object, HCC2LPC, that
%   converts the cepstral coefficients(CCs) to linear prediction
%   coefficients (LPCs).
%
%   HCC2LPC = dsp.CepstralToLPC('PropertyName', PropertyValue, ...) returns
%   a Cepstral to LPC object, HCC2LPC, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   A = step(HCC2LPC, CC) computes the LPC coefficients, A, from the
%   columns of cepstral coefficients, CC.
%
%   [A, P] = step(HCC2LPC, CC) converts the columns of the cepstral
%   coefficients CC to the linear prediction coefficients, and also returns
%   the prediction error power P when the PredictionErrorOutputPort
%   property is true.
%
%   CepstralToLPC methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create Cepstral to LPC object with same property values
%   isLocked - Locked status (logical)
%
%   CepstralToLPC properties:
%
%   PredictionErrorOutputPort - Enables prediction error power output
%
%   % EXAMPLE: Convert Cepstral Coefficients to LPC.
%       cc = [0 0.9920 0.4919 0.3252 0.2418 , ...
%             0.1917 0.1583 0.1344 0.1165 0.0956]'; 
%       hcc2lpc = dsp.CepstralToLPC;
%       a = step(hcc2lpc, cc);
%
%   See also dsp.LPCToCepstral, dsp.LSFToLPC,
%            dsp.RCToLPC.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=CepstralToLPC
            %CepstralToLPC Convert cepstral coefficients to linear prediction 
            %coefficients
            %   HCC2LPC = dsp.CepstralToLPC returns a System object, HCC2LPC, that
            %   converts the cepstral coefficients(CCs) to linear prediction
            %   coefficients (LPCs).
            %
            %   HCC2LPC = dsp.CepstralToLPC('PropertyName', PropertyValue, ...) returns
            %   a Cepstral to LPC object, HCC2LPC, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   A = step(HCC2LPC, CC) computes the LPC coefficients, A, from the
            %   columns of cepstral coefficients, CC.
            %
            %   [A, P] = step(HCC2LPC, CC) converts the columns of the cepstral
            %   coefficients CC to the linear prediction coefficients, and also returns
            %   the prediction error power P when the PredictionErrorOutputPort
            %   property is true.
            %
            %   CepstralToLPC methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create Cepstral to LPC object with same property values
            %   isLocked - Locked status (logical)
            %
            %   CepstralToLPC properties:
            %
            %   PredictionErrorOutputPort - Enables prediction error power output
            %
            %   % EXAMPLE: Convert Cepstral Coefficients to LPC.
            %       cc = [0 0.9920 0.4919 0.3252 0.2418 , ...
            %             0.1917 0.1583 0.1344 0.1165 0.0956]'; 
            %       hcc2lpc = dsp.CepstralToLPC;
            %       a = step(hcc2lpc, cc);
            %
            %   See also dsp.LPCToCepstral, dsp.LSFToLPC,
            %            dsp.RCToLPC.
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %PredictionErrorOutputPort Enables prediction error power output
        %   Set this property to true to output the prediction error power. The
        %   prediction error power is the power of the error output of an FIR
        %   analysis filter represented by the LPCs for a given input signal.
        %   The default value of this property is false.
        PredictionErrorOutputPort;

    end
end
