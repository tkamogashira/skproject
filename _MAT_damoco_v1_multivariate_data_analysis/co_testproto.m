function out=co_testproto(theta1,theta2)
% DAMOCO Toolbox, function CO_TESTPROTO, version 17.01.11 
% Convention: protophases are column arrays in 0,2pi interval.
% This function tests whether the input data conforms
% to this convention.
% 
% Form of call:  co_testproto(theta1) or co_testproto(theta1,theta2).
%
% In case of two input arguments, the function tests whether
% the time series of protophases are of the same length.
% Output is 1, if data are OK, and zero, if something is wrong.
%
out=1;  % suppose, everything is OK!
s1=size(theta1); 
if s1(2) ~= 1
    disp('Protophase must be a column array!')
    out=0;
end
if min(theta1) < 0
    disp('Negative values of protophase are not allowed!')
    out=0;
end
if max(theta1) > 2*pi
    disp('Convention is to use wrapped protophases!')
    out=0;
end
if nargin == 2
    s2=size(theta2);
    if s2(2) ~= 1
        disp('Protophase must be a column array!')
        out=0;
    end
    if min(theta2) < 0
        disp('Negative values of protophase are not allowed!')
        out=0;
    end
    if max(theta1) > 2*pi
        disp('Convention is to use wrapped protophases!')
        out=0;
    end
    if s1(1)~=s2(1)
        disp('Series of protophases must be of the same length!')
        out=0;
    end
end 
end
