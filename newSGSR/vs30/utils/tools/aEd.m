function adaptEdit(n, newtag, newPrompt, newUnit);
% adaptEdit(n, newTag, newPrompt, newUnit)

if ischar(n), n = str2num(n); end;
global GG;
hasPrompt = 0;
hasUnit = 0;
if nargin<4, newUnit = ''; end;

eh = GG(n);
Edit = get(eh);

if ~strendsWith(Edit.Tag, 'Edit'), error('not an edit'); end;
try, ph = GG(n+1); hasPrompt = strendswith(get(ph,'tag'), 'Prompt'); end;
try, uh = GG(n-1); hasUnit = strendswith(get(uh,'tag'), 'Unit'); end;

set(eh, 'tag', [newtag 'Edit']);
if ~hasPrompt, error('cannot find prompt'); end;
set(ph, 'tag', [newtag 'Prompt']);
setstring(ph, newPrompt);
set(ph, 'tooltipstr', '');

if ~hasUnit, error('cannot find unit'); end;
set(uh, 'tag', [newtag 'Unit']);
setstring(uh, newUnit);
set(uh, 'tooltipstr', '');

figure(gcf); % show

