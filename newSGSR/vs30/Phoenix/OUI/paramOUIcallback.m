function figPos = paramoOUIcallBack(keyword, varargin);
% paramOUIcallBack - generic callback function for parameter OUI
%   paramOUIcallBack is the generic callback function for
%   OUIs created with paramOUI.
%   
%   See also paramOUI.


[hcn, figh] = gcbo; % handle of calling uicontrol and its parent figure
% make sure that callback figure is the current OUI
if ~isempty(figh), paramOUI(figh); end

if nargin<1, % must be callback of uicontrol or uimenu
   keyword = get(hcn, 'tag');
   % find out to which paramset this uicontrol belongs, if any
   pname = '';
   postfix = {'button' 'menuitem' 'menu'};
   for ii=1:length(postfix),
      pf = postfix{ii};
      if StrEndsWith(lower(keyword), pf),
         pname = keyword(1:end-length(pf));
      end
   end
   warning('incomplete implementation of callback stuff');
   pname
end

keyword = trimspace(keyword); % remove spurious white space

switch lower(keyword),
case 'close',
   OUIpos('save'); % save current position
   delete(gcbf);
case 'keypress',
   localHandleKeypress(figh);
otherwise,
   error(['Unknown keyword ''' keyword '''.']);
end

%=========================================
function localHandleKeypress(figh);
key = char(get(figh, 'currentkey'));
switch key,
case 'escape',
   localEvalCallback(ouihandle('cancel'));
case 'return',
   localEvalCallback(ouihandle('OK'));
end

function localEvalCallback(h);
% calls callback with tag as an argument
if isonehandle(h),
   CB = get(h, 'callback');
   CB = strSubst(CB,';',''); % remove any trailing semicolon
   TAG = get(h, 'tag');
   % call the callback function with the tag as an argument
   eval([CB '('''  TAG ''');']);
end










