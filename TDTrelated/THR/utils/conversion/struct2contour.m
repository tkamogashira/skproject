function C = struct2contour(S)
% struct2contour - convert struct array to CONTOUR output format.
%   C = struct2contour(S) converts the struct array described in 
%   contour2struct to the 2xN numerical array as returned by CONTOURC, 
%   CONTOUR, CONTOURF.
%   S is a struct array with fields:
%     Level: level of the contour
%       X,Y: X and Y coordinates in row arrays.
%   C is the CONTOUR format:
%       C = [level1 x1 x2 x3 ... level2 x2 x2 x3 ...;
%            pairs1 y1 y2 y3 ... pairs2 y2 y2 y3 ...]
%
%   See also plotcontour, contour2struct, CONTOUR, CONTOURF, CONTOURC.

C = zeros(2,0);
for ii=1:numel(S),
    s = S(ii);
    N = numel(s.X);
    c = [s.Level s.X; N s.Y];
    C = [C, c];
end










