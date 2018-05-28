function [hasPrompt, ph] = gghasPrompt(n);
% mvEd(n, DX, DY)

if ischar(n), n = str2num(n); end;

ph = [];
global GG;
hasPrompt = 0;

eh = GG(n); Edit = get(eh);

if ~strendsWith(Edit.Tag, 'Edit'), error('not an edit'); end;
try, ph = GG(n+1); hasPrompt = strendswith(get(ph,'tag'), 'Prompt'); end;


