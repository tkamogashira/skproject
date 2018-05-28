function moveEdit(n, DX, DY)
% mvEd(n, DX, DY)

if nargin<3, DY=0; end;

if ischar(n), n = str2num(n); end;
if ischar(DX), DX = str2num(DX); end;
if ischar(DY), DY = str2num(DY); end;

global GG;
hasPrompt = 0; hasUnit = 0;

eh = GG(n); Edit = get(eh);

if ~strendsWith(Edit.Tag, 'Edit'), error('not an edit'); end;
try, ph = GG(n+1); hasPrompt = strendswith(get(ph,'tag'), 'Prompt'); end;
try, uh = GG(n-1); hasUnit = strendswith(get(uh,'tag'), 'Unit'); end;

ggmove(n, DX, DY)
if hasPrompt, 
   ggmove(n+1, DX, DY);
end;
if hasUnit, 
   ggmove(n-1, DX, DY);
end;

figure(gcf); % show


