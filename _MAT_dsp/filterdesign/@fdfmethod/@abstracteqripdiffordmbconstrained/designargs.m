function args = designargs(this, hs)
%DESIGNARGS Returns the inputs to the design function.

%   Copyright 2011 The MathWorks, Inc.

order = hs.FilterOrder;

% Determine what type of differentiator we have
typeIV = true;
if ~rem(order,2),
    typeIV = false;
end

% Define the 2nd to last and last Amplitudes and Frequencies
if typeIV,
    error(message('dsp:fdfmethod:abstracteqripdiffordmbconstrained:designargs:InvalidDesign'));
end

constraints = getconstraints(this,hs);

args = {order, [0 hs.Fpass hs.Fstop 1], [0 hs.Fpass*pi 0  0],...
    constraints{:},'differentiator'}; %#ok<CCAT>

% [EOF]
