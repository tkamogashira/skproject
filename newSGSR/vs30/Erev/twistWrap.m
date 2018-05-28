function tx = twistWrap(x,untwist);
% TWISTWRAP - erev-like wrapping
if nargin<2, untwist=0; end;
N = length(x(:));
QN = N/4;
tw = exp(2*pi*i*(0:N-1)'/N);
x = tw.*x(:);
tx = sum(reshape(x,QN,4),2).';
if untwist,
   tx = tx.*tw(1:QN)';
end