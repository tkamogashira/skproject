function X = getFieldsFromSetupFile(X,FN, existingOnly)
% getFieldsFromSetupFile - gets the fields of a struct from a setup file
if nargin<3,
   existingOnly = 1; % only replace existing fields; do not add new ones
end

FN = setupFile(FN);
if ~exist(FN), return; end;
try
   dummy = load(FN,'-mat');
   fns = fieldnames(dummy);
   for ii=1:length(fns),
      fn = fns{ii};
      if ~existingOnly | isfield(X,fn),
         newVal = getfield(dummy, fn);
         X = setfield(X, fn, newVal);
      end
   end
catch
   warning(lasterr);
end
