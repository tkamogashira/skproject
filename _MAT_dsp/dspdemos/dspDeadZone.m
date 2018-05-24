function y = dspDeadZone(varargin)
%DSPDEADZONE Performs deadzone action on the input
%   Y = DSPDEADZONE(X, T) performs deadzone action on the input X,
%   which outputs zero for inputs within the deadzone and offsets the input
%   by either the start or the end value when outside the deadzone.

%   Copyright 2009-2010 The MathWorks, Inc.

    [x, T] = deal(varargin{:});

    x(((x<=T) & (x >= -T))) = 0;
    x((x>T)) = x((x>T))-T;
    x((x<-T)) = x((x<-T))+T;
    y = x;
    