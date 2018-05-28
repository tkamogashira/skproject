function uigroups;

global UIGROUP;

% get right uigroup 
Fns = fieldnames(UIGROUP);
N = length(Fns);
fullName = '';
for ii=1:N,
   Fn = Fns{ii};
   if ~isequal(Fn, 'lastGroup'),
      disp(Fn);
   end
end
