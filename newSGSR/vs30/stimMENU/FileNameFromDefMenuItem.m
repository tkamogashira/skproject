function [FN, Index, h, isvis] = FileNameFromDefMenuItem(MenuIt);
% MenuIt is either tag such as 'GetFile01MenuItem'
% or index N indicating Nth DefMenuItem

if nargin<1, % retrieve all
   FN = '';
   Index = [];
   h = [];
   for ii=1:9,
      [ff, Index(ii), h(ii), isvis(ii)] = FileNameFromDefMenuItem(ii);
      FN = strvcat(FN,ff);
   end
   return;
end

if isnumeric(MenuIt),
   MenuIt = ['GetFile0' num2str(MenuIt) 'VarMenuItem'];
end
Index = str2num(MenuIt(8:9));

h = UIhandle(MenuIt);
FN  = get(h, 'Label');
WhiteLoc = min(findstr(FN,' '));
FN = trimspace(FN(WhiteLoc+1:end));
isvis = isequal(get(h, 'visible'), 'on');
