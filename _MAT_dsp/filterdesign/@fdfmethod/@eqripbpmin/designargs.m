function args = designargs(this, hs)
%DESIGNARGS   Return the arguments for the design method.

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

hspecs = copy(hs);

dstop1 = convertmagunits(hspecs.Astop1, 'db', 'linear', 'stop');
dpass  = convertmagunits(hspecs.Apass,  'db', 'linear', 'pass');
dstop2 = convertmagunits(hspecs.Astop2, 'db', 'linear', 'stop');

% If transition widths are not equal, use the smallest one
TW1 = hspecs.Fpass1-hspecs.Fstop1;
TW2 = hspecs.Fstop2-hspecs.Fpass2;
if TW1<TW2,
    hspecs.Fstop2 = hspecs.Fpass2+TW1;
elseif TW1>TW2,
    hspecs.Fstop1 = hspecs.Fpass1-TW2;
end

F = [hspecs.Fstop1 hspecs.Fpass1 hspecs.Fpass2 hspecs.Fstop2];
R = [dstop1 dpass dstop2];

if isequal(getdesignfunction(this),@firgr)        
    % Get the minimum order settings for FIRGR.
    min = getminorder(this, F, [0 1 0], R);

    % Construct a cell array to be passed to FIRGR.
    args = {min, [0 F 1], [0 0 1 1 0 0], R};
else
    %construct arguments to be passed to FIRPM
    args = firpmord(F, [0 1 0], R, 2, 'cell');
end

% Test that the spec is met. firpmord sometimes under estimate the order
% e.g. when the transition band is near f = 0 or f = fs/2.
% Notice that although we may have changed the transition widths so that
% they are symmetrical, we still compare if specs are met with respect to
% the original asymmetric specs kept in hs
args = postprocessminorderargs(this,args,hs);

% [EOF]
