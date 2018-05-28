function uiFileGetter(Prefix,PromptStr, EditStr);

error(nargchk(1,3,nargin));
clear global UIGROUP % is bugged
global UIGROUP;
uipaste(0,'GetFile');
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

if nargin>1, setstring(hh(3), PromptStr); end;
if nargin>2, setstring(hh(2), EditStr); end;


