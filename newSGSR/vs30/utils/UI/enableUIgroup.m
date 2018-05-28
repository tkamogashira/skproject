function y=enableUIgroup(tagPrefix,enable, figh);

if nargin<3,
   if isempty(gcbo), figh = gcf;
   else, figh = get(gcbo,'parent');
   end
end

hh = findobj(figh);
hh(1) = []; % remove figure itself
if nargin<2, enable = 1; end;
if enable==1,
   st = 'on';
else,
   st = 'off';
end

for h=hh',
   tag = get(h,'tag');
   where = min(findstr(tag, tagPrefix));
   if isequal(where,1), set(h,'enable',st); end;
end;
