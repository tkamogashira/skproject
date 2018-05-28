function newEdit(newtag, DY);
% nwEd - klone edit 

newtag;
if nargin<2, DY = 20; end;

global GG;
% find first edit in children's list (=lowest in tab order)
for ii=2:length(GG),
   tag = get(GG(ii), 'tag');
   if StrEndsWith(tag, 'Edit'); n = ii; break; end
end

ncop = n;
nnew = 2;
if gghasPrompt(n), ncop = [ncop n+1]; end;
if gghasUnit(n), ncop = [n-1 ncop]; nnew = 3; end;
qq = ggcopy(ncop);
ggpaste(qq);
aed(nnew, newtag, 'Prompt:', 'Unit');

ggmove(2+ncop-min(ncop), 0, -DY);

figure(gcf); % show

















