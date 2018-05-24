function Z = horzPadCat(X, Y, padVal);
% HORZPADCAT - hozrcat with padded numbers to make things fit
%    horzPadCat(X, Y) is [XX, YY]  where XX or YY is padded
%    with zeros so that XX and YY have the same # rows.
%    For example,
%       horzPadCat((1:4)',[100 200; 600 700]) equals
%       [(1:4)', [100 600 0 0]', [200 700 0 0]']
%
%    horzPadCat(X,Y,padVal) uses padVal instead of zeros for
%    the padded value.
%
%    See also VERTPADCAT.

if nargin<3, padVal=0; end;
% horzcat with padded zeros

SX  = size(X);
SY  = size(Y);
if SX(1)==SY(1), % need no padding
   Z = [X, Y];
elseif SX(1)>SY(1), % Y need padding
   Z = [X, [Y; repmat(padVal,SX(1)-SY(1), SY(2))]];
else, % X needs padding
   Z = [[X; repmat(padVal,SY(1)-SX(1), SX(2))], Y];
end
