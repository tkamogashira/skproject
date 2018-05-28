function uiframe(Prefix,Title);

global UIGROUP;
hh = uipaste(0,'TitledFrame');
for ii=1:length(hh),
   h = hh(ii);
   tag = get(h,'tag');
   tag = [Prefix tag];
   set(h,'tag',tag);
   uigroup.tags{ii} = tag;
end


if nargin>1, setstring(hh(1), Title); end;


