function [h, s, ah] = OUIhandle(parname, s, varargin);
% OUIhandle - handle of primary uicontrol of OUI group or OUI item
%   OUIhandle('foo') returns the primary handle of foo, where foo is
%   the name of a OUI group or OUI item of the current OUI.
%   Names are case-insensitive. Primary handles are the handles essential
%   for retrieving user input (queries), displaying messages (reporters)
%   taking action (actionButtons etc) or adapting a title (OUIgroups).
%   If no OUI item named FOO is found, [] is returned.
%
%   To retrieve handles of non-primary uicontrols, use a syntax as in:
%      OUIhandle('foo.prompt') 
%   This example returns the handle of foo's prompt instead of its primary handle.
%
%   OUIhandle without any input arguments returns the figure handle of the
%   active OUI. If none is active, [] is returned.
%
%   [h, s] = OUIhandle('foo') also returns the value of the
%   string property of the uicontrol.
%
%   [h, s, ah] = OUIhandle('foo') also returns any handles 
%   associated with foo, i.e., not only the primary handle,
%   but also foo's secondary handles (prompts, units, etc)
%
%   OUIhandle('foo', s) sets the value of the string property 
%   of the uicontrol to s.
%
%   OUIhandle('foo', s, prop, val ...) also sets additional graphics
%   properties of the uicontrol. Alternatively, these property/value 
%   pairs may be provided in a single struct Props: OUIhandle('foo', s, Props).
%
%   OUIhandle('foo', nan, prop, val ...) or OUIhandle('foo', nan, Props)
%   sets additional graphics properties but leaves the string property unaffected.
%
%   In all calls to OUIhandle, the name of the group or item ('foo' in the above)
%   may be a cell array of char strings. In this case, OUIhandle performs the
%   same action to each of the uicontrols corresponding to the respective
%   groups or items, and h, s, and ah are an array, cellstr and array, respectively.
%
%   See also paramOUI, OUIitem, ParamSet, readOUI.


doSet = (nargin>1);

if nargin<1, % just return figure handle of active OUI, or [] if none exists.
   h = paramOUI;
   return
end

% multiple parnames: recursion
if numel(cellstr(parname))>1,
   parname = cellstr(parname);
   if nargin>1, Sin = s; else, Sin = nan; end;
   [h, s, ah] = deal([],{},[]);
   for ii =1:length(parname),
      pn = parname{ii};
      [hii sii ahii] = OUIhandle(pn, Sin, varargin{:});
      h = [h hii];
      s = {s{:} sii};
      ah = [ah ahii];
   end
   return
end

if nargin>1, 
   if ~iscell(s) & ~isempty(s),
      doSet = ~isnan(s); % see help text
   end
end 

% retrieve handles of OUI
OUIinfo = OUIdata;
if isempty(OUIinfo),
   error('No active OUI found.');
end

parname = char(parname); % make sure to use char strings at this point
[parname, uicontrolType] = strtok(parname, '.'); % parse expressions like 'foo.frame'
if ~isempty(uicontrolType)
   uicontrolType = lower(uicontrolType(2:end)); % omit heading '.'
end
% first search queries, then reporters, then groups
OUIelements = {'items', 'groups'};
for ii=1:length(OUIelements),
   eltype = OUIelements{ii};
   handleSet = getfield(OUIinfo.handles, eltype); % handles.queries, handles.reporters, etc
   parnames = fieldnames(handleSet);
   % match is case insensitive
   iparam = strmatch(lower(parname), lower(parnames), 'exact');
   if ~isempty(iparam),
      parname = parnames{iparam}; % this name matches case exactly
      hh = getfield(handleSet, parname);
      break; % from for eltype loop
   end
end
if isempty(iparam),
   [h, s, ah] = deal([], '', []);
   return;
end

% return requested uicontrol, or ...
% ... edit, button, menu, menuitem, text or title in that order, or ...
% ... [] if none present
if ~isempty(uicontrolType), h = getfield(hh, uicontrolType);
elseif isfield(hh, 'edit'), h = hh.edit;
elseif isfield(hh, 'button'), h = hh.button;
elseif isfield(hh, 'menu'), h = hh.menu;
elseif isfield(hh, 'menuitem'), h = hh.menu;
elseif isfield(hh, 'text'), h = hh.text;
elseif isfield(hh, 'title'), h = hh.title;
else, h = [];
end
% ah are all handles in vector
ah = []; fns = fieldnames(hh);
for ii=1:length(fns), 
   ah = [ah getfield(hh, fns{ii})];
end

if doSet,
   if ishandle(h), set(h, 'string', s);
   else,
      error(['No retrieving uicontrol found for parameter ''' parname '''.']);
   end
end

if isoneHandle(h) & nargout>1, 
   % the following hack ensures that the string value returned is actually the...
   % ... one shown in the OUI, even if the uicontrol has focus at the time 
   % ... of the get(h, 'string') call.
   enableMode = get(h, 'enable');
   if isequal('on', enableMode),
      set(h, 'enable', 'off', 'enable', 'on'); 
   else, set(h, 'enable', 'on', 'enable', enableMode); 
   end
   if ismember(get(h,'type'), {'uimenu' 'uicontextmenu'}),
      s = get(h, 'label');
   else,
      s = get(h, 'string');
   end
else, s = '';
end

if nargin>2, % set additional properties
   set(h, varargin{:});
end












