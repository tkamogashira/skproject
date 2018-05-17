function [yi, xi] = track(x, y, d)
%TRACK inperpolate synthesis parameters
%   [YI, XI] = TRACK(X, Y, D) interpolates the values of Y at times X and
%   returns the new values in YI with the actual times in XI.  It is
%   assumed that the last time in X indicates the total effective
%   duration. D gives the time in miliseconds for the update rate.

%   Copyright (c) 2000 by Michael Kiefte.

% total duration is assumed to be indicated by the last time index
u = x(end);

% add 20 ms to duration to ensure signal will decay to zero
xi = (0:d:u+20-d)';

% make sure parameter 20 ms following has same value
xp = [x(:); xi(end)];
yp = [y(:); y(end)];

yi = interp1q(xp, yp, xi);
eps = [0; diff(yi)];

% round to most recent integer
idx = find(eps > 0); % rising
yi(idx) = floor(yi(idx));
idx = find(eps < 0); % falling
yi(idx) = ceil(yi(idx));
