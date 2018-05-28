function S = Seesaw(S, toggle, par1, par2);
% paramset/seesaw - define flipflop-like side effect of toggle on other uicontrols
%   S = SeeSaw(S, toggle, par1, par2), where S is a paramset object
%   and toggle, par1 and par2 are three of its queried parameters, 
%   makes that the par1's (par2's) uicontrols are only visible when
%   the toggle is in state 1 (state 2).
%   
%   Seesaw(..) without an output argument attemps to realize the seesaw on the
%   the current OUI.
%
%   See also toggleCallback, paramOUI.

if nargout<1, % do it
   htoggle = OUIhandle(toggle);
   ud = get(htoggle, 'userdata');
   try,
      ud.visible = {par1 par2};
      ud.invisible = {par2 par1};
      set(htoggle, 'userdata', ud);
      % confirm present state of toggle
      toggleCallback(htoggle, ud.itoggle);
   catch,
      lasterr
      error(['Parameter ''' toggle ''' is not associated with a two-state toggle.']);
   end
else, % define it for use at paramOUI time
   ES = paramset; % void paramset for correct signature of SeeSaw call
   S = AddInitCommand(S, 'SeeSaw', ES, toggle, par1, par2);
end





