function set_outq(q, accWL, accFL)
%SET_OUTQ Specify output word and fraction length for DF2.

% This method was overloaded because we cannot use the 
% @abstractnonscalarfilterq/set_outq for non-SOS IIRs due to the fact that
% q.ncoeffs is a two element vector.

% This should be a private method.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

outWL = q.privoutwl;
if strcmpi(q.privOutputMode, 'AvoidOverflow') || strcmpi(q.privOutputMode, 'BestPrecision'),
    
    % Best precision output fraction length will be ignored
    
    % q.ncoeffs(1) is the number of numerator coefficients
    bits2add = nguardbits(q.ncoeffs(1)-1); 
    ideal_numaccWL = q.privstatewl + q.privcoeffwl + bits2add;
    ideal_numaccFL = q.privstatefl + q.privcoefffl;
    outFL = outWL - (min(accWL-accFL,ideal_numaccWL-ideal_numaccFL));
else
    outFL = q.privoutfl;
end
if ~isempty(outFL),
    q.privoutfl = outFL;
end

% [EOF]
