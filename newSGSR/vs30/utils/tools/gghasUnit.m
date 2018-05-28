function [hasUnit, uh] = gghasUnit(n);
% [hasPrompt, ph] = gghasUnit(n);

if ischar(n), n = str2num(n); end;

ph = [];
global GG;
hasUnit = 0;

eh = GG(n); Edit = get(eh);

if ~strendsWith(Edit.Tag, 'Edit'), error('not an edit'); end;
try, uh = GG(n-1); hasUnit = strendswith(get(uh,'tag'), 'Unit'); end;


