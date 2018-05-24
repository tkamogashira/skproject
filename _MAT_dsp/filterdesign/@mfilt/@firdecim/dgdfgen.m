function DGDF = dgdfgen(Hd,hTar,doMapCoeffsToPorts)
%DGDFGEN generate the dg_dfilt structure from a specified filter structure
%Hd.

%   Author(s): Honglei Chen
%   Copyright 1988-2005 The MathWorks, Inc.

if Hd.DecimationFactor==1,
    H = dfilt.dffir(Hd.Numerator);
    if isfixptinstalled,
        H.Arithmetic = Hd.Arithmetic;
        if strcmpi(H.Arithmetic, 'fixed'),
            H.CoeffWordLength = Hd.CoeffWordLength;
            H.CoeffAutoScale = Hd.CoeffAutoScale;
            if ~H.CoeffAutoScale,
                H.NumFracLength = Hd.NumFracLength;
            end
            H.Signed = Hd.Signed;
            H.InputWordLength = Hd.InputWordLength;
            H.InputFracLength = Hd.InputFracLength;
            H.FilterInternals = Hd.FilterInternals;
            if strcmpi(H.FilterInternals,'SpecifyPrecision'),
                H.OutputWordLength = Hd.OutputWordLength;
                H.OutputFracLength = Hd.OutputFracLength;
                H.ProductWordLength = Hd.ProductWordLength;
                H.ProductFracLength = Hd.ProductFracLength;
                H.AccumWordLength = Hd.AccumWordLength;
                H.AccumFracLength = Hd.AccumFracLength;
                H.RoundMode = Hd.RoundMode;
                H.OverflowMode = Hd.OverflowMode;
            end
        end
    end
    DGDF = dgdfgen(H,hTar,doMapCoeffsToPorts);
else
   
    DGDF=firdecimdggen(Hd.filterquantizer,Hd,hTar.coeffnames,doMapCoeffsToPorts,hTar.privStates);
end

