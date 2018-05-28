function s = paramset(Type, Name, Description, Version, minOUIsize, createdBy);
% paramset - constructor for paramset objects
%   S = Paramset(Type, Name, Description, Version, minOUIsize, createdBy) 
%   creates a new paramset object. The exact definition of the
%   parameter set is provided by filling its virtual fields.
%   Version must be a positive integer number.
%   minOUIsize is optional minimum size of OUI (in points).
%   The default minOUIsize [100 40] is assigned if [] is passed.
%   createdBy is a string identifying the caller. Typically
%   mfilename is used to identify the calling function (see example below).
%
%   Paramset without any input arguments creates a void paramset object.
%
%   Example:
%     FS = paramset('Stimulus', 'FS', 'Frequency sweep', 1, [], mfilename);
%     % define parameters 
%     FS = AddParam(FS,  'startFreq', 300,  'Hz',  'ureal', 2);
%     ...
%     % specify the UI control for the parameters
%     % first initialize group of uicontrols & their titled frame
%     FS = InitQueryGroup(FS, 'frequencies', [20 10 140 80], 'frequency sweep'); 
%     % then add queries etc
%     FS = DefineQuery(FS, 'startFreq', 0, 'edit', 'start:', '21000.5 21000.1', ['Frequency at start of sweep.'] );
%     ...
%     paramOUI(FS); % open OUI
%     ...
%     [FS, mess] = readOUI; % read parameters as specified on the OUI
%
%   See Paramset/AddParam, ParamSet/addreporter, paramOUI and documentation on Paramset objects.

if nargin==0, % empty paramset object needed for implicit ...
   % ... assignments, e.g., qq(2) = paramset(..) where qq didn't exist before.
   [Type, Name, Description, Version, minOUIsize, createdBy] = deal([]);
elseif nargin==1, % (pseudo) casting
   if isa(Type, 'paramset'), s = Type; return;
   elseif isa(Type, 'struct'), s = class(Type, 'paramset'); return;
   else, error(['Cannot convert ' class(Type) ' to paramset object.']);
   end
else,
   % check the input args 
   error(nargchk(6,6,nargin)); 
   if ~ischar(Type),
      error('Type argument must be character string.');
   elseif isempty(Type),
      error('Type may not be empty.');
   elseif size(Type,1)~=1,
      error('Type must be single-line character string.');
   elseif any(isspace(Type)),
      error('Name may not contain white space.');
   elseif ~isvarname(Type),
      error(['Type ''' Type ''' is not a valid identifier.']);
   end
   if ~ischar(Name),
      error('Name argument must be character string.');
   elseif isempty(Name),
      error('Name may not be empty.');
   elseif size(Name,1)~=1,
      error('Name must be single-line character string.');
   elseif any(isspace(Name)),
      error('Name may not contain white space.');
   elseif ~isvarname(Name),
      error(['Name ''' Name ''' is not a valid identifier.']);
   end
   %---------------
   if ~ischar(Description),
      error('Description argument must be character string.');
   elseif isempty(Description),
      error('Description may not be empty.');
   elseif size(Description,1)~=1,
      error('Description must be single-line character string.');
   end
   %---------------
   versionOK = 0;
   if isnumeric(Version),
      versionOK = isreal(Version) ...
         & (numel(Version)==1) ...
         & (Version>0) ...
         & (rem(Version,1)==0);
   end
   if ~versionOK, error('Version must be positive integer.'); end
end

if isempty(minOUIsize), minOUIsize=[100 40]; end;

% providing empty fields for future definition
Stimparam = [];
OUI = initOUIstruct(minOUIsize);


s = CollectInStruct(Type, Name, Description, Version, Stimparam, OUI, createdBy);
s = class(s, 'paramset');












