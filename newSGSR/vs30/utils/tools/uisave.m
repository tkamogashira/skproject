function uisave(n);

global VERSIONDIR GG

if nargin==0,
   n = 2:length(GG);
end

constrDir = [VERSIONDIR '\stimmenu\construction'];
EXT = '.mat';
fn = '';
if ischar(n),
   % filename 
   fn = [n EXT];
   fp = [constrDir '\'];
   N = length(GG);
   n = 2:N;
   anchor = N; 
   for ii=2:N, 
      tags{ii-1} = get(GG(ii),'tag'); 
   end;
   tags = RemoveEmptyCells(tags);
   uigroup = ggcopy(n);
else,   
   uigroup = ggcopy(n);
   N = length(n);
   for ii=1:N, 
      tags{ii} = get(GG(n(ii)),'tag'); 
   end;
   tags = RemoveEmptyCells(tags);
   for ii=1:N, 
      disp([num2str(ii+1) ': ' tags{ii}]);
   end;
   anchor = input('anchor index: ')-1;
   [fn fp] = uiputfile([constrDir '\*' EXT]);
   if isequal(fn,0), return; end;
end
fullname = [fp fn];
save(fullname,'uigroup','tags','anchor');