function toggleCallback(hbutt, itoggle);
% toggleCallback - default callback for toggle buttons
%    ToggleCallback(h) toggles the string value of a 
%    toggle button with handle h and updates the button's 
%    userdata accordingly. If h is a char string, ToggleCallback(h)
%    is equivalent to ToggleCallback(OUIhandle(h)).
%
%    ToggleCallback(h, ii) forces the toggle into the ii-th state.
%    States are counted from 1. When ii=0, the current state
%    is confirmed.
%
%    ToggleCallback(h, 'foo') forces the toggle into the state
%    for which the string 'foo' is being displayed on the
%    button. An error results when 'foo' is not in the 
%    predefined set of values of the toggle. Note that the
%    toggle strings are case sensitive.
%
%    ToggleCallback, without any arguments, uses gcbo as the
%    handle. Thus any button that has ToggleCallback as its
%    callback function will be toggled by ToggleCallback.
%
%    See also query/qdraw, seesaw, OUIhandle.

if nargin<1, hbutt = gcbo; end % handle of button clicked
if nargin<2, itoggle=nan; end % to be corrected below

if ischar(hbutt), [hbutt] = OUIhandle(hbutt); end

ud = get(hbutt, 'userdata');
N = length(ud.toggleSet);
if isnan(itoggle), % toggle, i.e., add one to toggle count and wrap modulo N
   itoggle = 1+rem(ud.itoggle, N);
elseif isequal(0,itoggle), % confirm current state
   itoggle = ud.itoggle;
elseif ischar(itoggle), % set to state with named string
   toggleStr = itoggle; % need it for error message
   itoggle = strmatch(itoggle, ud.toggleSet, 'exact');
   if isempty(itoggle),
      error(['String ''' toggleStr ''' is not a member of predefined toggle set of toggle.']);
   end
end
ud.itoggle = itoggle;
set(hbutt, 'string', ud.toggleSet{ud.itoggle});
set(hbutt, 'userdata', ud);

% A toggle may also disable and/or enable other uicontrols
if isfield(ud, 'disable'),
   paramname = ud.disable{itoggle};
   [dum, dum, ah] = OUIhandle(paramname); % all handles associated with paramName
   set(ah, 'enable', 'off');
end
if isfield(ud, 'enable'),
   paramname = ud.enable{itoggle};
   [dum, dum, ah] = OUIhandle(paramname); % all handles associated with paramName
   set(ah, 'enable', 'on');
end

% A toggle may also make visible and/or make invisible other uicontrols
if isfield(ud, 'invisible'),
   paramname = ud.invisible{itoggle};
   [dum, dum, ah] = OUIhandle(paramname); % all handles associated with paramName
   set(ah, 'visible', 'off');
end
if isfield(ud, 'visible'),
   paramname = ud.visible{itoggle};
   [dum, dum, ah] = OUIhandle(paramname); % all handles associated with paramName
   set(ah, 'visible', 'on');
end










