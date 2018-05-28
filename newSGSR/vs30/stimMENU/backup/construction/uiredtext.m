function uiredtext(Prefix,Str);

global UIGROUP;
uipaste(0,'RedText');
uigroup = getfield(UIGROUP,UIGROUP.lastGroup);
hh = uigroup.handles;
for ii=1:length(hh),
   h = hh(ii);
   tag = get(h,'tag');
   tag = [Prefix tag];
   set(h,'tag',tag);
   uigroup.tags{ii} = tag;
end


% falsify book keeping of UIGROUP
UIGROUP = rmfield(UIGROUP,UIGROUP.lastGroup);
UIGROUP = setfield(UIGROUP,Prefix, uigroup);
UIGROUP.lastGroup = Prefix;

if nargin>1, setstring(hh(1), Str); end;


