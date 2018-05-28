function N=SwitchStateNaming;
% SwitchStateNaming - naming conventions for on/off switches
%   SwitchStateNaming returns a struct whose fieldnames are the
%   valid methods for specifying switch states.
%   Each field is a 1x2 char cell array that contains
%   the respective expressions for {'On' 'Off'}.
 
N.onoff =   { 'on' 'off'};
N.ONOFF =   {'ON'  'OFF'};
N.OnOff =   {'On'   'Off'};
N.logical = {  1      0 };
N.YesNo =   {'Yes'   'No'};
N.nan =     {nan     nan};
