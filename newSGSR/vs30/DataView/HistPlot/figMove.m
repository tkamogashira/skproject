function figMove(dx,dy,h);
% figmove - move figure by given # pixels
if nargin<3, h = gcf; end;

if ischar(dx), dx = str2num(dx); end;
if ischar(dy), dy = str2num(dy); end;

oldpos = get(h, 'position');
set(h,'position', [oldpos+[dx dy 0 0]]);