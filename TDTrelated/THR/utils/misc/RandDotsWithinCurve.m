function [X, Y] = RandDotsWithinCurve(Cx, Cy, N);
% RandDotsWithinCurve - N random points in the XY plane within given closed curve
%    [X,Y] =RandDotsWithinCurve(Cx,Cy,N) returns N random points X(k),Y(k) 
%    that lie within the closed curve described by coordinates Cx,Cy.
%
% Example
%   [Xc Yc] = ginput; 
%   patch(Xc,Yc,'r'); 
%   [xd yd] = randdotsWithinCurve(Xc,Yc,1000); 
%   xplot(xd,yd,'*');
%
%   see also WithinCurve

% rectangle around curve
[Xmin, Xmax] = deal(min(Cx), max(Cx));
[Ymin, Ymax] = deal(min(Cy), max(Cy));
DX = Xmax-Xmin;
DY = Ymax-Ymin;
Arect = DX*DY;
Acurv = abs(AreaWithinCurve(Cx,Cy));
M = round(1.5*Arect/Acurv*N); % margin to get enough points
n = 0;
[X,Y] = deal([]);
while n<N,
    x = Xmin + DX*rand(1,M);
    y = Ymin + DY*rand(1,M);
    iwithin = find(withinCurve(Cx,Cy, x,y));
    X = [X x(iwithin)];
    Y = [Y y(iwithin)];
    n = length(X);
end
X = X(1:N);
Y = Y(1:N);




