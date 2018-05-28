function [PX, PY, I] = tri2patch(T, X, Y);
%  tri2patch - convert 2D triangulation to patch input args
%      [PX, PY, I] = tri2patch(T, X, Y) where X and Y are arrays of X and Y
%      coordinates, and T is a triangulation of (X,Y) produced by
%      delaunay, returns matrices PX and PY to be passed to PATCH to draw
%      the traingles of T as patches. PX(:,K) and PY(:,K) are the X and Y
%      are the X and Y coordinates of triangle T(K). The index matrix I has
%      the same size as PX and PY. I(J,K) is the index into X and Y of the
%      Jth vertex of the Kth triangle.
%      
%      Example
%      X = rand(200,1);
%      Y = rand(200,1);
%      Z = sqrt(X.^2 + Y.^2);
%      C = 1+round((size(colormap,1)-1)*((Z-min(Z))./(max(Z)-min(Z))));
%      T = delaunay(X,Y);
%      [PX, PY, I] = tri2patch(T, X, Y);
%      patch(PX,PY,C(I), 'edgecolor', 'none')
%      See also fenceplot.

PX = X(T.');
PY = Y(T.');
I = T.';


