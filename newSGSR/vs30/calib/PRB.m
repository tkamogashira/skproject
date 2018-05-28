function y=PRB(kw,varargin);
% PRB - generic callback  for PRB menu - vs 12 and up
global PRBMenuStatus CALIBstatus
persistent figh hh
if nargin==0,
   if isempty(gcbo),
      error('Keyword nor callback.');
   end
   kw = get(gcbo,'tag');
end
switch kw
case 'debug',
   keyboard; 
case 'init', % syntax: PRB init <fname> [return], where fname is short prb name
   PRBMenuStatus = []; % start from scratch
   PRBMenuStatus.fname = varargin{1};
   hh = openUImenu('PRB', 'newPRBmenu'); % menu name is PRB, but fig file is called newPrbMenu
   figh = hh.Root;
   DeclareMenuDefaults('PRB', 'Root:position', '*Edit:string', ...
      'DACchannelButton:string', 'DACchannelButton:userdata');
   if isdeveloper, 
      enableUIgroup('Start', 1, hh.Root); 
      enableUIgroup('Gain', 1, hh.Root); 
   end;
   set(hh.Root, 'name', ['PRB  ' PRBMenuStatus.fname]);
   CALIBstatus.action = 'wait';
   if nargin<3, repaintWait(hh.Root);  end  % only return when menu is closed
   PRBMenuStatus.PRBdata = []; % save some memory
case 'CancelButton',
   if isequal('wait', CALIBstatus.action), 
      delete(figh);
   end
case 'close',
   if isequal('wait', CALIBstatus.action), 
      SaveMenuDefaults('PRB', '', 1);
      delete(figh);
   end
case 'PlotButton', % --------------------plot most recent PRB data
   CDplot(PRBMenuStatus.PRBdata);
case 'AcceptButton', % ---------------save most recent PRB data and quit
   CDwrite(PRBMenuStatus.PRBdata ,PRBMenuStatus.fname);
   addToLog(['PRB measured & saved: ' PRBMenuStatus.fname]);
   PRB('close');
case 'StartButton',   % -------------------perform calibration; the results are ...
   localGO(hh); % ... stored in PRBdata field of global PRBMenuStatus
case 'StopButton',   % -------------------perform calibration; the results are ...
   localStop; % ... stored in PRBdata field of global PRBMenuStatus
end
%----locals----------------
function localGO(hh);
global PRBMenuStatus CALIBstatus
if ~isequal('wait', CALIBstatus.action), return; end; % playing .. do not interrupt
[cpOK, BWreg, Fhighest, highestBW] = CalibParamCheck(hh);
if ~cpOK, return; end;
DAchan = UIIntFromToggle(hh.DACchannelButton); % 1|2 ~ L|R 
% get microphone sensitivity and gain
micSens = abs(UIdoubleFromStr(hh.SenseEdit,1));
micGain = UIdoublefromStr(hh.GainEdit);
if ~checkNanAndInf([micSens micGain]), return; end;
% disable start, plot & accept buttons enable stop button
enableUIgroup('Start',0); 
enableUIgroup('Accept',0); enableUIgroup('Plot',0); enableUIgroup('Stop',1);
% -----now we're ready to play/record----
% measure trf; store results in return variable PRBdata
setstring(hh.SNratioText, '');
CALIBstatus.action = 'play';
DefaultStartAtt = 40; % dB default start setting of attenuator
maxSPL = 100; % dB max SPL - unduly high levels might cause trembing etc
CD = doCalibration('PRB', DAchan, DefaultStartAtt, micSens, micGain, maxSPL);
enableUIgroup('Stop',0);
if ~isempty(CD), % succesfull measurement, enable some buttons
   PRBMenuStatus.PRBdata = CD; 
   enableUIgroup('Accept',1); 
   enableUIgroup('Plot',1);
end;
enableUIgroup('Start',1); 
CALIBstatus.action = 'wait';
 
%----------
function localAccept(PRBtransfer, hh);
% get filename to save data to, save data, and close PRB window

set(hh.FileNameEdit,'enable','on');
fname = get(hh.FileNameEdit,'string');
if isempty(fname),
   mess = strvcat('Specify filename and retry');
   errordlg(mess,'No file name specified for PRB data');
   return;
end;
fname = removeFileExtension(fname);
fullname = [calibdir '\' fname '.PRB'];
try, save(fullname, 'PRBtransfer');
catch
   mess = strvcat('error message:', lasterr, 'check filename and try again');
   errordlg(mess,'Error while saving PRB data');
   return;
end;
SaveMenuDefaults('PRB', '', 1);
delete(hh.Root);
%---------------
function localStop;
global CALIBstatus
CALIBstatus.interrupt = 1;
% the rest will be handled by the playing functions