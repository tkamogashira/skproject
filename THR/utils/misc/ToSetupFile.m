function ToSetupFile(FN, varargin);
% ToSetupFile - save parameters in setup file
%   ToSetupFile(FN, X, Y, ..) stores named variables X and Y 
%   in setup file named SetupFile(FN). Variables that have been
%   stored in FN before are unaffected - the new variables are
%   appended to the setup file. If FN starts with '~', a global
%   setup file is created/used which is also readable oon other computers.
%   By default, setup files are local. See SetupfileName for details.
%
%   ToSetupFile(FN, '-propval', Prop1, Val1, Prop2, Val2, ..) uses a
%   property/value syntax to do the same. For instance,
%      ToSetupFile(FN, '-propval', 'Foo', X)
%   is equivalent to:
%      Foo = X; ToSetupFile(FN, Foo).
%
%   ToSetupFile(FN, '-delete', 'foo') deletes entry foo from setup file FN.
%
%   ToSetupFile(FN, '-deleteall') completely removes setup file FN.
%
%   Example
%      Town = 'Rotterdam';
%      Floor = 12;
%      ToSetupFile('Location', Town, Floor);
%
%   See also FromSetupFile, SetupList, SetupFileName, SetupDir, Compuname.

% use recursion to handle prop/val syntax (see help text)
if nargin>1 && isequal('-propval', lower(varargin{1})),
    for ii=1:floor((nargin-2)/2),
        Prop = varargin{2*ii};
        Val = varargin{2*ii+1};
        cmd = [Prop ' = Val; toSetupfile(FN, ' Prop ');'];
        eval(cmd);
    end
    return;
end
%-----no recursion beyond here--------

FN = setupfilename(FN); % setup will expand any heading '~' into local name

% check for removal calls (see help text)
if nargin==3 && isequal('-delete', lower(varargin{1})),
    if ~exist(FN,'file'), error(['Setup file ''' FN ''' not found.']); end
    STR = fromSetupFile(FN);
    STR = rmfield(STR, varargin{2});
    save(FN, 'STR', '-mat');
    return;
elseif nargin==2 && isequal('-deleteall', lower(varargin{1})),
    delete(FN);
    return
end



% put named variables in struct STR
for ii=1:nargin-1,
   fn = inputname(ii+1); % use name of variable as fieldname
   if isempty(fn), error('Setup parameters must be passed in named variables or using prop/val flag & syntax.'); end;
   eval(['STR.' fn ' = varargin{ii};']);
end
if exist(FN,'file'), % merge with existing values; new ones take precedence
    STR = structJoin(fromSetupFile(FN), STR);
end

save(FN, 'STR', '-mat');



