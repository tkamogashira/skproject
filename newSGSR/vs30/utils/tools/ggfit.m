function ggfit(n, tt);

global GG;

%   
style = get(GG(n), 'style');
if ~isequal(style,'text') & ~isequal(style,'checkbox'),
   error(['don''t know hiw to fit ' style ' uicontrols']);
end
ext = get(GG(n), 'extent');
if isequal(style,'checkbox'),
   ext = ext + [0 0 ext(4) 0]; % add space for box itself
end
ggpos(n, [0 0 ext(3) ext(4)]);
   

   
