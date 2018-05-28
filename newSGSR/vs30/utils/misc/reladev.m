function Rdev = reladev(X,Y);
% RELADEV - relative deviation between two values
%   RD = RELADEV(X,Y) returns the difference between X and Y as a
%   fraction of the reference value X:
%      RD = (Y-X)./abs(X);

Rdev = (Y-X)./abs(X);
