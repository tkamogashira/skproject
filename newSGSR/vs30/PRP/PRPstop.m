function PRPstop(MenuHandles);

% PRPstop - Callback interrupt D/A and spike collection or ..
% interruption of Check action

global PRPinstr PRPstatus;

% update button availabilities
if PRPstatus.Checking,
   % interruption of check action via StimMenuWarn
   PRPsetButtons('stopping');
   hmess = messagehandle;
   set(hmess,'userdata','stop');
   tralala = get(hmess,'string');
   % remove two last lines of message containing continue/stop instructions
   tralala = tralala(1:(size(tralala,1)-2),:);
   set(hmess,'string',tralala); % this will resume StimMenuWarn
else, % interruption of D/A & data collection
   PRPsetButtons('stopping');
   PRPstatus.interrupt = 1;
   completeStop2; % rude interruption of D/A
   % resetting of above flag is handled by ...
   % the D/A functions after handling the interrupt
end


