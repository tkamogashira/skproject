function RS = OUIdefault(keyword, varargin);
% OUIdefault - save or retrieve paramset of current OUI
%   OUIdefault('save', S) saves paramset S in a setup file whose 
%   name is derived fom the type and the name S. More precisely,
%   the filename is OUIdefaultsFilename(S).
%
%   OUIdefault('save', S, 'foo') saves paramset S in a setup file
%   OUIdefaultsFilename(S, 'foo').
%
%   OUIdefault('save', S, '?put') prompts the user for a .ouidef 
%   file and then saves S in that file. If the user cancels the
%   opening of the file by escaping from the uigetfile dialog, 
%   nothing is saved.
%
%   OUIdefault('clear', ...) deletes the setup file OUIdefaultsFilename(...).
%   Note that this has the side effect that the stored position of the 
%   OUI is also lost.
%
%   OUIdefault('retrieve', S) or OUIdefault('retrieve', S, FN) returns the
%   paramset that was saved earlier in the setup file OUIdefaultsFilename(S,..). 
%   If S is not specified, OUIdefaultsFilename is called without any input arg, 
%   i.e., the first paramset of the current OUI is used (see OUIdefaultsFilename).
%   If no paramset was previously saved in the setup file, S itself
%   is returned; if S was not specified, the factory settings
%   of the current primary paramset are returned.
%
%   OUIdefault('retrieve', S, '?put') uses the uiputfile dialog to get a
%   uidef filename. If the user cancelled, OUIdefault returns [].
%
%   OUIdefault('impose') not only retrieves a saved paramset but
%   also imposes it on the current OUI using OUIfill.
%
%   See also paramOUI, OUIpos, OUIdefaultsFilename, OUIfill.

switch lower(keyword),
case 'save',
   if nargin<2, error('Not enough input arguments; input argument S not specified.'); end
   S = varargin{1};
   if isempty(S), error('Cannot save empty paramset.'); 
   elseif isvoid(S), error('Cannot save void paramset.'); 
   end
   [FN EX pp paramset] = OUIdefaultsFilename(varargin{:}); % note: directory is created if it does not yet exist
   if isempty(FN), return; end % user cancelled -> do nada
   paramset = varargin{1};
   save(FN, 'paramset', pp{:});
case 'clear',
   [FN EX pp paramset] = OUIdefaultsFilename(varargin{:});
   if EX, delete(FN); end
case 'retrieve',
   [FN EX pp RS] = OUIdefaultsFilename(varargin{:});
   if isempty(FN), RS = []; return; end % user cancelled -> return []
   if EX, 
      try, 
         qq = who('-file', FN);
         if strmatch('paramset', qq, 'exact'),
            load(FN, 'paramset', '-mat'); 
            RS = paramset; 
         end
      end
   end
case 'impose', % retrieve & fill
   RS = OUIdefault('retrieve', varargin{:});
   if isempty(RS), return; end % cancelled
   OUIfill(RS,1); % trailing 1 -> try to ignore any problems
otherwise, 
   error(['invalid keyword ''' keyword '''.']);
end












