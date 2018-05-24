function S = quantizestates(q, S)
%QUANTIZESTATES   Quantize the states of a DF1 filter.

%   Author(s): P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'Saturate');

% Switch based on what was passed in for the states (a FILTSTATES.DFIIR
% object or a double vector).
if strcmpi(class(S),'filtstates.dfiir'),
    [S.Numerator,S.Denominator] = createFi(q,S.Numerator,S.Denominator,F);
else
    % Double vector was sent
    nb = q.ncoeffs(1);
    Snum =  S(1:nb-1,:);
    Sden = S(nb:end,:);
    [SNumFi,SDenFi] = createFi(q,Snum,Sden,F);

    % Create a FILTSTATES object
    S = filtstates.dfiir(SNumFi,SDenFi);
end

% -------------------------------------------------------------------------
function [SNumFi,SDenFi] = createFi(q,Snum,Sden,F)

SNumFi = fi(Snum,'WordLength',q.privinwl,...
    'FractionLength',q.privinfl,'fimath',F);
SDenFi = fi(Sden,'WordLength',q.privoutwl,...
    'FractionLength',q.privoutfl,'fimath',F);

% [EOF]
