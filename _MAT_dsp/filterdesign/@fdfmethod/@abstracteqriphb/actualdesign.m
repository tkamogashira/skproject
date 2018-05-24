function b = actualdesign(this,hs)
%ACTUALDESIGN

%   Author(s): R. Losada
%   Copyright 1999-2005 The MathWorks, Inc.

args = designargs(this,hs);

if this.MinPhase
    minphase = {'minphase'};
else
    minphase = {};
end

% When the slope is zero we do not want to call FIRGR directly.
% FIRHALFBAND has special code for the halfband design.
if this.StopbandDecay == 0

    b = {firhalfband(args{:}, minphase{:})};

else

    % Calculate the Fstop based on Fpass.
    F = [args{2} 1-args{2}];

    if length(args) == 3
        
        % The passband ripple and stopband attenuation are the same for
        % halfband filters.
        A = {[args{3} args{3}]};
        
        % Calculate the initial order "guess".
        initialOrder = firpmord(F, [1 0], A{:});
        
        % Round the initialOrder up to the next even #.
        initialOrder = 2*ceil(initialOrder/2);
        
        order = {'mineven', initialOrder};
    else
        order = args{1};
        A = {};
        if rem(order, 2)
            error(message('dsp:fdfmethod:abstracteqriphb:actualdesign:invalidOrder'));
        end
    end

    % Need to rearrange the inputs for FIRGR.
    fresp = getfresp(this);
    b = {firgr(order, [0 F 1], fresp, A{:}, minphase{:})};

    % Make sure that we have exact zeros and an exact .5
    if ~this.MinPhase
        if rem((length(b{1})-1)/2, 2)
            b{1}(2:2:end) = 0;
        else
            b{1}(1:2:end) = 0;
        end
        b{1}((length(b{1})-1)/2+1) = .5;
    end

end

% [EOF]
