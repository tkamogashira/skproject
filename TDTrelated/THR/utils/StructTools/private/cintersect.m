function [Xp, Yp] = cintersect(X, Y, C)
%CINTERSECT gets intersection points of curve with constant function
%   [Xp, Yp] = CINTERSECT(X, Y, C) gets intersection points of curve given by vectors X and Y with
%   constant function y = C. The curve must have a maximum, and only the two intersection points
%   closest to the maximum are given.

%B. Van de Sande 08-03-2004

[YMax, iMax] = max(Y); 
XMax = X(iMax);

i = find((Y > C) & (X >= XMax)); if isempty(i), [Xp, Yp] = deal([NaN NaN]); return; end
j = min(find(diff(i) > 1));

if isempty(j), i2 = max(i); 
else i2 = i(j); end

if i2 == length(Y), [Xp, Yp] = deal([NaN NaN]); return; end

i = find((Y > C) & (X <= XMax)); if isempty(i), [Xp, Yp] = deal([NaN NaN]); return; end
j = max(find(diff(i) > 1)) + 1;

if isempty(j), i1 = min(i); 
else i1 = i(j); end

%if (i1 == iMax) | (i1 == 1), [Xp, Yp] = deal([NaN NaN]); return; end
if (i1 == 1), [Xp, Yp] = deal([NaN NaN]); return; end

x1 = X(i1 - 1); y1 = Y(i1 - 1);
x2 = X(i1); y2 = Y(i1);

a1 = (y2 - y1)/(x2 - x1);
b1 = y1 - a1*x1;

InterSect1 = (C - b1)/a1;

x3 = X(i2); y3 = Y(i2);
x4 = X(i2 + 1); y4 = Y(i2 + 1);

a2 = (y4 - y3)/(x4 - x3);
b2 = y3 - a2*x3;

InterSect2 = (C - b2)/a2;

Xp = [InterSect1 InterSect2];
Yp = interp1(X, Y, Xp);