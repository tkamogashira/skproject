function detect = DetectFun(velocity)
% function detect = DetectFun(velocity)
% a somewhat-compressing HWR.

negate = 0; % depending on filterbank parameters, one or other might "thump"
if negate
    velocity = -velocity;
end

velocity(velocity < 0) = 0;
a = 0.25; % limiting slope, relative to 1 where it starts
detect = min(1, velocity);
detect = a*velocity + (1-a)*(detect - (detect.^3)/3);

% test it this way:
%plot(-1:.1:2, DetectFun(-1:.1:2))