function [x, ns] = synth(h, ns)
%SYNTH Synthesize speech sample
%   X = SYNTH(H) produces a waveform on the basis of the struct H as returned
%   by HANDSY.

%   Copyright (c) 2001 by Michael Kiefte.

if nargin ==2
    x = coewave(parcoef(parmcont(h)), ns);
else
    [x ns] = coewave(parcoef(parmcont(h)));
end