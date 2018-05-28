function [om, ZT] = TLine(R,L,C, om, plotArg);
% Tline - finite-segment transmission line

if nargin<4, om=[]; end
if nargin<5, plotArg='n'; end


if isempty(om), om=linspace(0.1,10,200); end


Nseg = maxLength(R,L,C);
[R,L,C] = localMult(Nseg,R,L,C);
% build from the end, adding segment by segment
ZT = inf;
for iseg=1:Nseg,
   Zcr = R(iseg)+1./(i*om*C(iseg));
   Ycr_tail = 1./Zcr+1./ZT;
   ZT = i*om*L(iseg) + 1./Ycr_tail;
end

if nargout==0,
   subplot(2,1,1);
   xplot(om, a2db(abs(1./ZT)), plotArg);
   set(gca,'xscale', 'log')
   grid on
   subplot(2,1,2);
   xplot(om, angle(ZT)/2/pi, plotArg);
   set(gca,'xscale', 'log')
   grid on
end

%  >--L------L--- ---L--- ---L--- 
%        |       |       |       |
%        C       C       C       C
%        |       |       |       |
%        R       R       R       R
%        |       |       |       |
%  >------------------------------

%-----------------------
function varargout=localMult(Nseg,varargin);
for iarg = 1:nargin-1, 
   X = varargin{iarg};
   if length(X)==1,
      X = X*ones(Nseg,1);
   end
   varargout{iarg} = X(:);
end

