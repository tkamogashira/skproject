function DoStop = StimMenuWarn(mess, controlHandles);
global StimMenuStatus PRPstatus

if nargin<2, controlHandles=[]; end;
hmess = messagehandle;

hmess = messagehandle;
% enable buttons that allow user to react on warning
prevMode = PRPstatus.action; % store previous mode (e.g. waiting/playing, etc)
PRPsetButtons('warning');

% issue warning together with continue/stop instructions
mess = strvcat(mess,...
   'Hit Check/Update to continue or',...
   'Stop to interrupt.');
UIwarn(mess);
% render edit controls purple
textcolors;
for hh=controlHandles(:).',
   UItextColor(hh, PURPLE); 
end

if atBigScreen,
   for ii=1:10, 
      beeps(ceil(rand*10)); 
      pause(0.1*rand);
   end
end

% wait until message text is ...
% ...changed by either XXcheck or PRPstop
waitfor(hmess,'string');

% meanwhile, userdata have been set by either XXcheck or PRPstop
DoStop = isequal('stop',get(hmess,'userdata'));
if DoStop,
   PRPsetButtons('waiting');
else,
   PRPsetButtons(prevMode);
end

