function S = CollectInStruct(varargin);
% CollectInStruct - collect variables in struct
%   CollectInStruct(X,Y,...) is s struct with field names 
%   'X', 'Y', ... and respective field values X,Y,...
%   All arguments must be variables, not anonymous values.
%
%   See also STRUCT, FIELDNAMES, GETFIELD, SETFIELD.

Nvar = length(varargin);
S = [];
for ivar=1:Nvar,
   FN = inputname(ivar);
   if isempty(FN),
      error(['arg #' num2str(ivar) ' has no name'])
   end
   S = setfield(S,FN,varargin{ivar});
end


