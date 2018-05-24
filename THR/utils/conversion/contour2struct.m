function S = contour2struct(C)
% contour2struct - convert CONTOUR output to struct
%   S = contour2struct(C) converts the output of CONTOURC, CONTOUR, CONTOURF to
%   a struct array. C is the CONTOUR format:
%       C = [level1 x1 x2 x3 ... level2 x2 x2 x3 ...;
%            pairs1 y1 y2 y3 ... pairs2 y2 y2 y3 ...]
%   S is a struct array with fields:
%     Level: level of the contour
%       X,Y: X and Y coordinates in row arrays.
%
%   See also plotcontour, , struct2contour, CONTOUR, CONTOURF, CONTOURC.

S = emptystruct('Level', 'X', 'Y');

offset = 0;
while offset<size(C,2),
    N = C(2,offset+1);
    S(end+1).Level = C(1,offset+1);
    S(end).X = C(1,offset+1+(1:N));
    S(end).Y = C(2,offset+1+(1:N));
    offset = offset+N+1;
end









