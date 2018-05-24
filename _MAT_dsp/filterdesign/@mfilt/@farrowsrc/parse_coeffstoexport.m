function [hTar,domapcoeffstoports] = parse_coeffstoexport(Hd,hTar)
%PARSE_COEFFSTOEXPORT Store coefficient names and values into hTar for
%export.

%   Copyright 2009-2011 The MathWorks, Inc.

state = hTar.MapCoeffsToPorts;

if strcmpi(state,'on')
    [~, coeffnames var] = mapcoeffstoports(Hd,'MapCoeffsToPorts','on',...
                                        'CoeffNames',hTar.CoeffNames);
    hTar.CoeffNames = coeffnames;
    setprivcoefficients(hTar,var);
end

domapcoeffstoports = strcmpi(state,'on');

% check parameters
L = Hd.InterpolationFactor;
M = Hd.DecimationFactor;

if strcmpi(Hd.privArithmetic, 'fixed'),
    if rem(L,1)~=0 || rem(M,1)~=0,
        error(message('dsp:mfilt:farrowsrc:parse_coeffstoexport:MustBeAnInteger'));
    end
end

% [EOF]
