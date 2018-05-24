function [T, X] = bound2tri(XC, Nref);
%  bound2tri - surface triangulation based on sampling of circumference
%      [T, X] = bound2tri(XB), where the columns of N x 2 array XB are
%      spatial coordinates of the boundary enclsoing a 2D surface, returns
%      a triangulation of the surface (T,X), where the columns of X are the
%      spatial coordinates of the points spanning the triangulation and T
%      is an index array into X as produced by DELAUNAY. Bound2tru uses
%      INITMESH as the workhorse.
%
%      [T, X] = bound2tri(XB, N) refines the initial mesh N times. 
%
%      See also INITMESH, REFINEMESH.

Nref = arginDefaults('Nref',0);

N = size(XC,1);
xc = XC(:,1).';
yc = XC(:,2).';
g = [repmat(2,1,N); xc; circshift(xc,[0 -1]); yc; circshift(yc,[0 -1]); ...
    repmat([1;0],1,N)];
[p e t]= initmesh(g,'jiggle', 'mean', 'Hgrad', 1.3);
for ii=1:Nref,
    [p, e, t] = refinemesh(g, p, e, t);
end
X = p.';
T = t(1:3,:).';











