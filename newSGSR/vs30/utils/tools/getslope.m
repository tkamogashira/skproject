function S = getslope;
% GetSlope - quick & dirty slope estimate from figure
%   GetSlope uses ginput to prompt the user for two points P1 P2 
%   on a graph and returns (Y1-Y2)/(X1-X2). The line segment
%   connecting the two points is plotted on the graph.

figure(gcf);
p = ginput(2);
X = p(:,1)
Y = p(:,2)

xplot(X, Y, ':k');

S = diff(Y)/diff(X);



