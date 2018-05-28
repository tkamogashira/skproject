function Hhh=xplot(varargin);
% xplot - add plot to current axes

fake = 0;
if nargin>1,
   fake = isequal('n', varargin{nargin});
end

if fake, hh=plot(varargin{1:(nargin-1)});
else 
   hold on;
   hh=plot(varargin{:});
   hold off;
end
figure(gcf);
if nargout>0, Hhh=hh; end
   