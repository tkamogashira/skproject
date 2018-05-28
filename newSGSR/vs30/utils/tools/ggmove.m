function ggmove(n, dx, dy);

global GG;
if nargin<3, dy=0; end;
if ischar(dx), dx = str2num(dx); end;
if ischar(dy), dy = str2num(dy); end;

if ischar(n),
   st = lower(n);
   n = [];
   for ii=2:length(GG),
      ccc = lower(get(GG(ii),'tag'));
      if isequal(1,findstr(st,ccc)), n = [n ii]; end;
   end
end
for iin=n,
   oldpos = get(GG(iin), 'Position');
   newpos = oldpos + dx*[1 0 0 0] + dy*[0 1 0 0];
   set(GG(iin), 'Position', newpos);
end

figure(gcf); % show