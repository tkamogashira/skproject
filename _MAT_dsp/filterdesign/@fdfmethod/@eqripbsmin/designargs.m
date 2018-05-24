function args = designargs(this, hs)
%DESIGNARGS   Return the arguments for the design method.

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

hspecs = copy(hs);

dpass1 = convertmagunits(hspecs.Apass1, 'db', 'linear', 'pass');
dstop  = convertmagunits(hspecs.Astop,  'db', 'linear', 'stop');
dpass2 = convertmagunits(hspecs.Apass2, 'db', 'linear', 'pass');

% If transition widths are not equal, use the smallest one
TW1 = hspecs.Fstop1-hspecs.Fpass1;
TW2 = hspecs.Fpass2-hspecs.Fstop2;
if TW1<TW2,
    hspecs.Fstop2 = hspecs.Fpass2-TW1;
elseif TW1>TW2,
    hspecs.Fstop1 = hspecs.Fpass1+TW2;
end

F = [hspecs.Fpass1 hspecs.Fstop1 hspecs.Fstop2 hspecs.Fpass2];
R = [dpass1 dstop dpass2];

if isequal(getdesignfunction(this),@firgr)        
    % Get the minimum order settings for FIRGR.
    min = getminorder(this, F, [1 0 1], R);
    
    % Construct a cell array to be passed to FIRGR.
    args = {min, [0 F 1], [1 1 0 0 1 1], R};
    
else
     %construct arguments to be passed to FIRPM
    args = firpmord(F, [1 0 1], R, 2, 'cell');
end

% Test that the spec is met. firpmord sometimes under estimate the order
% e.g. when the transition band is near f = 0 or f = fs/2.
% Notice that although we may have changed the transition widths so that
% they are symmetrical, we still compare if specs are met with respect to
% the original asymmetric specs kept in hs
args = postprocessminorderargs(this,args,hs);

% [EOF]
