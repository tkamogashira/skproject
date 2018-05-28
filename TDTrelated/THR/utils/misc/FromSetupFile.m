function varargout = FromSetupFile(FN, varargin);
% FromSetupFile - retrieve parameters from setup file
%   [Xval, Yval ..] = FromSetupFile(FN, Xname, Yname, ..) 
%   retrieves parameters named Xname, etc, from setupfile FN
%   that have been stored in FN by an earlier call to ToSetupFile. 
%   FN does not need full path; see SetupFile.
%
%   FromSetupFile(FN, 'Foo', '-default', DefValue)  can be used
%   to retrieve a single setup parameter Foo while providing a default 
%   value DefValue. If the specified property is not present in the
%   setup file, DefValue is returned.
%   FromSetupFile(FN, 'Foo', '-default*', DefValue) does the same, but also
%   saves the default value if no prior value for Foo exists.
%
%   FromSetupFile(FN) without specifation of parameter names, returns
%   all the parameters stored in FN as a atruct whose fieldnames
%   are the parameter names.
%
%   See also ToSetupFile, SetupFile, SetupDir, SetupList.

% get whole struct
SUF = setupfilename(FN);
if ~exist(SUF,'file'), % try global version
    FN = ['~' FN];;
    SUF = setupfilename(FN);
end
if ~exist(SUF,'file'), 
    if  (nargin>2) && isequal('-default', varargin{2}),
        varargout{1} = varargin{3}; % return default value
        return;
    else,
        error(['Setup file ''' FN ''' not found.'])
    end
end

qq = load(SUF, '-mat');

if (nargin>3) && isequal('-default', varargin{2}(1:8)), % see help text
    fn = varargin{1};
    defVal = varargin{3};
    if isfield(qq.STR, fn),
        varargout{1} = qq.STR.(fn);
    else,
        varargout{1} = defVal;
        if isequal('-default*', varargin{2}), % also save def value
            toSetupFile(FN, '-propval', fn, defVal);
        end
    end
    return
end



if nargin<2, % whole struct
   varargout{1} = qq.STR;
else,
   for ii=1:nargin-1,
      varargout{ii} = getfield(qq.STR, varargin{ii});
   end
end 




