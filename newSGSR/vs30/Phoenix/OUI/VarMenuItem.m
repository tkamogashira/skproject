function Y = VarMenuItem(keyword, varargin);
% VarMenuItem - generic handler of variable menu items
%   VarMenuItem creates and manages variable pulldown menu items, such
%   as a list of recently opened files. The group of variable menu items 
%   form a FIFO list of items.
%   Syntax is:
%      VarMenuItem('keyword', ...). 
%   In OOP lingo, VarMenuItem is a class and the possible 
%   keywords are its methods:
%
%   VarMenuItem('init', Name, hmenu, N, Callback)
%     constructor call with args:
%        Name: unique identifier of this VarMenuItem group.
%        hmenu: handle to parent pulldown menu (item)
%        N maximum # items
%        Callback: name of callback function
%
%   VarMenuItem('additem', Name, Label, ...)
%     adds a labeled menuitem on top of the list. 
%        Name: unique, case-insensitive, identifier of current VarMenuItem group
%        Label: label of the new menu item
%        ...: any number of arguments that will be passed to the Callback function
%   If adding the new item results in exceeding the max number of items,
%   the oldest item will be removed (FIFO principle).
%   Adding an item that already exist (i.e., same Label and CallbackArg)
%   will not have any effect.
%
%   L = VarMenuItem('getitems', Name)
%       returns the added items of Named list in a struct array.
%
%   VarMenuItem('setitems', Name, L)
%       restores the item list L to the Named VarMenuItem list.
%
%   VarMenuItem('enable', Name, Enab)
%       enables/disables the Named VarMenuItem list for Enab = 1/0.
%
%   VarMenuItem('clear', Name)
%       empties the Named VarMenuItem list by removing all items.
%
%   VarMenuItem('delete', Name)
%       deletes the Named VarMenuItem list.
%
%
%   Example:
%      h = uimenu('label', 'Hello')
%      VarMenuItem('init', 'SayHello', h, 10, 'disp')
%      VarMenuItem('additem', 'SayHello', 'world', 'hello world')
%      VarMenuItem('additem', 'SayHello', 'moon', 'hello moon')
%      VarMenuItem('additem', 'SayHello', 'computer', ';-)')
%

LocalCleanup; % remove obselete elements

switch lower(keyword),
case 'init', %   VarMenuItem('init', Name, hmenu, N, Callback)
   if nargin~=5, error('Syntax: VarMenuItem(''init'', Name, hmenu, N, Callback)'); end
   [Name, hmenu, N, Callback] = deal(varargin{:});
   if localList('exist', Name),
      error(['Cannot initialize list named ''' Name '''; Name is already used.']);
   end
   localList('new', Name, hmenu, N, Callback);
   needSepa =  ~isempty(get(hmenu,'children'));
   % create the items; note that callbacks are redirected; see 'callback' method below
   for iitem=1:N,
      mih(iitem) = uimenu( ...
         'parent', hmenu, ...
         'label', ['&' num2str(iitem) ' '], ...
         'callback', [mfilename ' callback;'], ...
         'visible', 'off' ...
      );
   end
   if needSepa, set(mih(1), 'separator', 'on'); end
   localList('setfields', Name, 'mih', mih);
case 'additem', %   VarMenuItem('additem', Name, Label, CallbackArg)
   if nargin<3, error('Syntax: VarMenuItem(''init'', Name, Label, ...)'); end
   [Name, Label] = deal(varargin{1:2});
   CallbackArg = varargin(3:end); % cell array containing all callback args
   % prepare new item 
   new_item = collectInStruct(Label, CallbackArg);
   % get current list
   L = localList('get', Name);
   % check if item exits in list; if so, quit
   if structismember(new_item, L.ItemList), return; end
   % prepend new item
   L.ItemList = [new_item L.ItemList];
   % truncate list if necessary
   if length(L.ItemList)>L.Nmax,
      L.ItemList = L.ItemList(1:L.Nmax);
   end
   % replace list
   localList('replace', Name, L);
   % render
   VarMenuItem('render', Name);
case 'getitems', %   VarMenuItem('getitems', Name)
   Name = varargin{1};
   L = localList('get', Name);
   Y = L.ItemList;
case 'setitems', %   VarMenuItem('setitems', Name, L)
   if ~isequal(2, length(varargin)), error('Syntax: VarMenuItem(''setitems'', Name, ItemList)'); end
   [Name, newItemList] = deal(varargin{1:2});
   % get current list
   L = localList('get', Name);
   L.ItemList = newItemList;
   localList('replace', Name, L);
   VarMenuItem('render', Name);
case 'enable', %   VarMenuItem('enable', Name, Enab)
   if ~isequal(2, length(varargin)), error('Syntax: VarMenuItem(''enable'', Name, Enab)'); end
   [Name, Enab] = deal(varargin{1:2});
   if Enab, enval = 'on'; else, enval = 'off'; end; 
   L = localList('get', Name);
   for iitem=1:length(L.ItemList),
      set(L.mih(iitem), 'enable', enval);
   end
case 'clear', %   VarMenuItem('clear', Name)
   Name = varargin{1};
   L = localList('get', Name);
   L.ItemList = [];
   localList('replace', Name, L);
   VarMenuItem('render', Name);
case 'delete', %   VarMenuItem('delete', Name)
   Name = varargin{1};
   VarMenuItem('clear', Name);
   localList('remove', Name);
   %======private & debug===================
case 'getlist', %   L = VarMenuItem('getlist', Name)
   Name = varargin{1};
   Y = localList('get', Name);
case 'render', %   VarMenuItem('render', Name)
   Name = varargin{1};
   % render the menuitems
   L = localList('get', Name);
   Nitem = length(L.ItemList);
   for iitem=1:Nitem,
      hi = L.mih(iitem);
      it = L.ItemList(iitem);
      set(hi, ...
         'label', ['&' num2str(iitem) ' ' it.Label], ...
         'userdata', {L.Callback it.CallbackArg{:}}, ... % callback args are stored in uimenu
         'visible', 'on' ...
         );
   end
   for iitem=Nitem+1:L.Nmax,
      hi = L.mih(iitem);
      set(hi,'visible', 'off');
   end
case 'cleanup', %   VarMenuItem('cleanup')
   return; % LocalCleanup is allways called
case 'callback', %   L = VarMenuItem('callback')
   % the callback of the items is redirected via here; this enables ...
   % ... passing of arguments to the effective Callback function.
   % These args have been stored in the userdata of the callback object (see 'render' method)
   cbArgs = get(gcbo, 'userdata'); % see 'init' and 'render' methods above
   feval(cbArgs{:}); % the effective callback
otherwise,
   error(['Invalid keyword ''' keyword '''.'])
end % switch/case



%==============================================
function Y = localList(kw, Name, varargin);
% manages the database of Named VarMenuItem lists
persistent VarMenuItemList
mess = ''; Y = [];
switch kw,
case 'index',
   Y = strmatch(lower(Name), lower({VarMenuItemList.Name}));
   if nargin>2, % throw error if not exist
      if isempty(Y), error(['List named ''' Name ''' does not exist.']);end;
   end
case 'exist',
   if isempty(VarMenuItemList), 
      Y = 0; 
   else,
      Y = ~isempty(localList('index', Name));
   end
case 'new', % add new item
   if localList('exist', Name),
      error(['List named ''' Name ''' already exists.']);
   end
   if ~isvarname(Name),
      error(['''' Name ''' is not a valid identifier (see isvarname).']);
   end
   [hmenu, Nmax, Callback] = deal(varargin{:});
   mess = 'hmenu arg must be handle of menu or menu item.';
   try, if isequal('uimenu', get(hmenu, 'type')), mess = ''; end; end; error(mess);
   mess = 'N arg must be positive integer.';
   try, if (isequal(Nmax, round(abs(Nmax))) & (Nmax>0)), mess = ''; end; end; error(mess);
   mess = 'Callback arg must be existing function or command.';
   try, if (ismember(exist(Callback),[2 3 5 6 8])), mess = ''; end; end; error(mess);
   mih = []; % array of menu item handles
   ItemList = []; % list of added items
   nw = CollectInStruct(Name, hmenu, Nmax, mih, Callback, ItemList);
   VarMenuItemList = [VarMenuItemList nw];
case 'get',
   ihit = localList('index', Name, 'mustexist');
   Y = VarMenuItemList(ihit);
case 'getall',
   Y = VarMenuItemList;
case 'replace', % replace the whole struct; NOTE: no check for field consistency!
   ihit = localList('index', Name, 'mustexist');
   rp = varargin{1};
   VarMenuItemList(ihit) = rp;
case 'setfields',
   ihit = localList('index', Name, 'mustexist');
   for ifield = 1:length(varargin)/2,
      FN = varargin{2*ifield-1};
      FVAL = varargin{2*ifield};
      if ~isfield(VarMenuItemList, FN),
         error(['Non existing fieldname ''' FN '''.']);
      end
      VarMenuItemList(ihit) = setfield(VarMenuItemList(ihit), FN, FVAL);
   end
case 'remove',
   ihit = localList('index', Name, 'mustexist');
   VarMenuItemList(ihit) = [];
otherwise, error(['invalid keyword ''' kw '''.'])
end


function LocalCleanup;
% remove all lists that whose parent menu handle does not exist
L = localList('getall');
for ii=1:length(L),
   if ~ishandle(L(ii).hmenu),
      localList('remove', L(ii).Name);
   end
end





