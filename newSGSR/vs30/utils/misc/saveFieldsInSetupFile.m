function saveFieldsInSetupFile(X , FN, varargin)
% saveFieldsInSetupFile - save selected fields of struct, or all fields, in setup file

if nargin<3, 
   fns = fieldnames(X); 
else
   fns = varargin;
end
y__________Y = X; % unlikely variable name
for ii=1:length(fns)   ,
   fn = fns{ii};
   eval([fn ' = y__________Y.' fn ';']);
end

saveArgs = {'-mat'};
FN = setupFile(FN);
if exist(FN,'file'),
   saveArgs = {saveArgs{:} '-append'};
end
save(FN, fns{:}, saveArgs{:});