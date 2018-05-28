function r = Torusknot(M1,M2,N);
%  TorusKnot - 3D closed curve of torus knot

if nargin<3, N = 1e3; end

alpha= linspace(0,2*M1*pi,N)'; 
beta= linspace(0,2*M2*pi,N)'; 

R=[exp(i*alpha)]; r=[R.*(1+0.1*cos(beta)), 0.1*sin(beta)];


