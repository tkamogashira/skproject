function args = designargs(this, hspecs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2008-2011 The MathWorks, Inc.

dstop = convertmagunits(hspecs.Astop, 'db', 'linear', 'stop');
dpass = convertmagunits(hspecs.Apass, 'db', 'linear', 'pass');

F = [hspecs.Fstop hspecs.Fpass];
A = [0 1];
R = [dstop dpass];

if isequal(getdesignfunction(this),@firgr)        
    % Get the order information.
    min = getminorder(this, F, A, R);
    
    % Construct a cell array to be passed to FIRGR.
    args = {min, [0 F 1]};
    
    switch this.StopbandShape,
        case 'flat'
            if this.StopbandDecay~=0,
                warning(message('dsp:fdfmethod:eqriphpmin:designargs:InvalidSpecifications'));
            end
            args(3) = {{@genhp, 0}};
        case 'linear'
            % Sloped Stopband FRESP
            args(3) = {{@genhp, this.StopbandDecay}};
        case '1/f'
            % 1/f Stopband FRESP
            args(3) = {{@genhp, this.StopbandDecay, .5, 0, false, true}};
    end
    
    args(4) = {R};
else
    %construct arguments to be passed to FIRPM
    args = firpmord(F, A, R, 2, 'cell');
end

% Test that the spec is met. firpmord sometimes under estimate the order
% e.g. when the transition band is near f = 0 or f = fs/2.
args = postprocessminorderargs(this,args,hspecs);

    

% [EOF]
