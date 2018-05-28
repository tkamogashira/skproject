function h = ToSetupFile(FN, varargin);
% ToSetupFile - save parameters in setup file
%   ToSetupFile(FN, X, Y, ..) stores named variables X and Y 
%   in setup file named SetupFile(FN). Variables that have been
%   stored in FN before are unaffected - the new variables are
%   appended to the setup file.
%
%   See also FromSetupFile, SetupFile, SetupDir.

% put named variables in struct STR
for ii=1:nargin-1,
   fn = inputname(ii+1); % use name of variable as fieldname
   if isempty(fn), error('Setup parameters must be passed in named variables.'); end;
   eval(['STR.' fn ' = varargin{ii};']);
end
saveFieldsInSetupFile(STR, FN);




