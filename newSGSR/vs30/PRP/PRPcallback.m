function PRPcallback(varargin);

% generic callback function for PRP uicontrols of stimulus Menu 
% the real work is done in local_PRPcallback below; the main function
% is just a wrapper (to allow different types of error catching)

if isDeveloper, % immediately delegate to local_PRPcallback, no error trapping
   local_PRPcallback(varargin{:});
else,
   try
      local_PRPcallback(varargin{:});
   catch
      message = strvcat(...
         'Unexpected error during Play/Record action.',...
         'Please report the problem unless it has a trivial cause',...
         'such as power failure, etc.',...
         'MatLab message: ', Dealstring(lasterr));
      warnchoice1('Unexpected error detected', 'ERROR', message, 'OK');
      PRPsetButtons('waiting'); % leave stim menu in proper state
   end
end

function local_PRPcallback(varargin);

global PRPstatus StimMenuStatus
prefix = PRPstatus.prefix;
hh = StimMenuStatus.handles;
hmess = hh.MessageText; % handle for reporting progress, errors, etc

uih = gcbo;
TAG = get(gcbo,'tag');

switch TAG
   %----------------------PLAY---------
case {'PlayButton','PlayMenuItem'}
   DONTRECORD = 0;
   % read repeat  button
   DoRepeat = isequal(1,get(hh.RepeatButton, 'UserData'));
   if StimMenuCheck, % no action if param check failed
      PRPplay(DONTRECORD, DoRepeat);
   end; 
case {'PlayRecordButton','PlayRecordMenuItem'}
   RECORD = 1; DoRepeat = 0;
   DoStutter = isequal(1, uiintfromtoggle(hh.StutterButton));
   if StimMenuCheck, % no action if param check failed
      PRPplay(RECORD, DoRepeat, DoStutter);
   end; 
   UpdateStimMenuHeader;
case 'CloseButton'
   closeStimMenu;
   return; % bypass resetting of PRP buttons below
case {'StopButton','StopMenu'}
   PRPstop(hh);
   return; % bypass resetting of PRP buttons below
case {'CheckUpdateButton','CheckMenuItem'}
   StimMenuCheck;
otherwise,
   eh = errordlg(['unknown callback object ' TAG],...
      [prefix ' Menu Error']);
   uiwait(eh);
end % switch TAG

PRPsetButtons('waiting');

