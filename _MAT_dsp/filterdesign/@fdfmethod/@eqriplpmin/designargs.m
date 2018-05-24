function args = designargs(this, hspecs)
%DESIGNARGS   Return the arguments for the design method.

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

dpass = convertmagunits(hspecs.Apass, 'db', 'linear', 'pass');
dstop = convertmagunits(hspecs.Astop, 'db', 'linear', 'stop');

F = [hspecs.Fpass hspecs.Fstop];
A = [1 0];
R = [dpass dstop];

if isequal(getdesignfunction(this),@firgr)        
    % Get the minimum order settings for FIRGR.
    min = getminorder(this, F, A, R);
    
    % Construct a cell array to be passed to FIRGR.
    args = {min, [0 F 1]};
    
    switch this.StopbandShape,
        case 'flat',
            if this.StopbandDecay~=0,
                warning(message('dsp:fdfmethod:eqriplpmin:designargs:InvalidSpecifications'));
            end
            args(3) = {{@genlp, 0}};
        case 'linear',
            % Sloped Stopband FRESP
            args(3) = {{@genlp, this.StopbandDecay}};
        case '1/f',
            % 1/f Stopband FRESP
            args(3) = {{@genlp, this.StopbandDecay, .5, 0, false, true}};
    end
    
    args(4) = {R};

else
    %get arguments for FIRPM
    args = firpmord(F, A, R, 2, 'cell');
end

% Test that the spec is met. firpmord sometimes under estimate the order
% e.g. when the transition band is near f = 0 or f = fs/2.
args = postprocessminorderargs(this,args,hspecs);

% [EOF]
