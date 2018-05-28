function co = lico(n,ha);
% LICO - line colors in fixed order, cyclic.
%    S = LICO(N) returns struct S with S.color field set to the Nth
%    color-order color of the current axes.
%
%    S = LICO(N, h) uses axes h.
%
%    See also PLOCO.
if nargin<2, ha=gca; end

CC = get(ha,'ColorOrder');
Nco = size(CC,1);
n = 1+mod(n-1,Nco);
co.color = CC(n,:);



