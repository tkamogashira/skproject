function UIMV(h, dpos, varargin);
% UIMV - move uicontrol

if nargin>2,
   dpos = [dpos varargin{:}];
end

oldpos = get(h,'position');
N = length(oldpos);
for ii=length(dpos)+1:N,
   dpos(ii)=0;
end
set(h,'position',oldpos+dpos);



