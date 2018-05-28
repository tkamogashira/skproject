function HadToChange = UpdateActiveChannelButton; 

global StimMenuStatus

HadToChange = 0; % indicates if current values are being...
% ...reset because of limited channl availability
if isfield(StimMenuStatus.handles,'ActiveChannelButton'),
   hbut = StimMenuStatus.handles.ActiveChannelButton;
else, % no active-channel button
   return;
end

% retrieve last value
cv = abs(get(hbut,'Userdata'));
switch SessioDAchan
case 'L',
   set(hbut,'String', 'Left');
   set(hbut,'Userdata', 2);
case 'R',
   set(hbut,'String', 'Right');
   set(hbut,'Userdata', 3);
case 'B',
   togglestring = '{''Both'' ''Left'' ''Right''}';
   eval(['toggles = ' togglestring ';']);
   set(hbut,'Callback', ['MENUbuttonToggle(' togglestring ')']);
   set(hbut,'String', toggles{cv});
   set(hbut,'Userdata', cv);
   set(hbut,'enable', 'on');
end
HadToChange = ~isequal(cv,get(hbut,'Userdata'));