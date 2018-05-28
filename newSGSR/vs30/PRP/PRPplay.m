function PRPplay(DoRecord, DoRepeat, DoStutter);

% PRPplay - D/A with or without spike collection
% SYNTAX
% PRPplay(DoRecord, DoRepeat);
% All stim menus have standard buttons/menu
% items which should be enabled/disabled depending on the
% status of D/A.

if nargin<1, DoRecord = 0; end;
if nargin<2, 
   % is there a hidden menu?
   if ~isempty(messagehandle), % yes there is
      global StimMenuStatus
      DoRepeat = (get(StimMenuStatus.handles.RepeatButton,'userdata')==1);
   else,
      DoRepeat = 0; 
   end
end;
if nargin<3, DoStutter=0; end;

global PRPinstr PRPstatus;

if DoRecord, 
   % check if data can be saved
   if IdfSpkFullfile,
      PRPsetButtons('waiting');
      UIerror(strvcat('IDF/SPK files are full. ', ... 
         'Change data filename', ...
         '(see New Session menu)'));
      return
   end
   % prompt for a new ID or generate one automatically
   ID = idrequest('new');
   if isempty(ID), return; end;
end

PRPsetButtons('generating');

% prepare PRP instructions if needed (see SMS2PRP)
if isdeveloper, % don't catch errors
   prpOK = SMS2PRP(DoRecord);
else,
   try % stimuli might not fit in memory. The error is reported by StimGEN
      prpOK = SMS2PRP(DoRecord);
   catch
      PRPsetButtons('waiting');
      UIerror('D/A cancelled');
      % errordlg(lasterr,'Unexpected Error','modal');
      return
   end % try/cath
end; % if isdeveloper

if ~prpOK, % functions are responsible for their own error reporting, just quit
   PRPsetButtons('waiting');
   UIinfo('D/A cancelled',1);
   return
end

% reset interrupt
PRPstatus.interrupt = 0;
PRPstatus.interruptRec = 0;

% adapt menu controls' enable state
if DoRecord, PRPsetButtons('playing/recording');
else, PRPsetButtons('playing');
end;

PRPstatus.DoRecord = DoRecord;

if DoRecord, 
   AnnounceRecording; 
   SyncClock;
end
if DoStutter, % play 1st sequence in advance, w/o recording (see playRec)
   PRPstatus.Stuttering = 1;
   eval(synchedPlayer);
   PRPstatus.Stuttering = 0;
end

while 1,
   eval(synchedPlayer); % play
   if ~DoRepeat | PRPstatus.interrupt | DoRecord, % stop playing
      break;
   end
end
try,
   % activate stimmenu, not plot
   hh = stimmenuhandles;
   figure(hh.Root);
end; % try

if DoRecord, 
   % handle spike saving
   PRPstatus.SpikesStored = 1;
   if PRPstatus.interruptRec==1, % interrupted during collection of 1st subseq
      PRPstatus.SpikesStored = 0; % no usable data
   end;
   % save spikes (if any) to file unless interruption has occurred
   PRPsaveSpikes2;
   PRPstatus.SpikesStored = 0; % either saved or undesired
   if atbigscreen, beeps(20); pause(0.1);beeps(20); 
   elseif atohr, beeps(100); pause(0.1);beeps(100); pause(0.2);beeps(200); 
   end
end;

% reset menu controls' enable state to default
PRPsetButtons('waiting');
