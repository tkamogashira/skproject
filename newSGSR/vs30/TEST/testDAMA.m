function y=testDAMA(N);
if nargin<1, N=7e5; end
Free_Words = freewords
xx = round(linspace(-maxMagDA,maxMagDA,N));
DBN = ml2dama(xx);
plot(xx,dama2ml(DBN)-xx);