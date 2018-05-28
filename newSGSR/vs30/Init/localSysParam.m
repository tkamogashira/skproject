function LocalSysParam(keyword);
% LocalSysParam; - generic callback function of LocalSysParamMenu

if nargin<1, % keyword defined by tag of callback object
   keyword = get(gcbo,'tag'); % which object is calling?
end

global LocalSysParamMenuStatus
hh = getFieldOrdef(LocalSysParamMenuStatus, 'handles', []);

% call keyword-specific local function
eval(['local_' keyword '(hh);']);

% --------------locals--------------
function local_retrieve(hh);
% retrieve from setupfile those SGSR parameters particular for this computer/setup
SUFN = 'localsysparam'; % setup filename
% local, user defined, values override factory defaults
localParam = getFieldsFromSetupFile([],SUFN,0);
% fix obsolete setup features
localParam = localUpdateLocalParam(localParam, SUFN);
% combine stored local params with existing SGSR (locals take precedence)
global SGSR; SGSR = combineStruct(SGSR, localParam);
if isempty(localParam), % local system params have never been set - deal with this interactively
   mess = strvcat('Cannot retrieve settings of this SGSR installation.',...
      'Please check & confirm the parameter settings in the next dialog, which is',...
      'also available from the System|Local System Parameters pulldown menu.');
   eh = warndlg(mess,'Local settings have not been specified','modal');
   set(eh,'KeyPressFcn', 'nop;');
   figure(eh);
   if ishandle(eh), uiwait(eh); end;
   LocalSysParam init;
end

function local_init(hh); % open the dialog and set edits to current defaults
global LocalSysParamMenuStatus
LocalSysParamMenuStatus = [];
hh = openUImenu('LocalSysParam','','modal');
noCloseDLG(hh.Root, strvcat('To close the Local System Parameters dialog,', ...
   'you must hit either Cancel or OK.'), 'OK or Cancel?');
% uicontrol/property pairs whose values should be remembered next time upon opening the menu
DeclareMenuDefaults('LocalSysParam', 'Root:position', '*Button:value');
% set text of edit controls to current SGSR values
global SGSR; local_display_values(hh, SGSR);
uiwait(hh.Root); % only return when user is done

function local_DefaultButton(hh);
global SGSR
% restore factory settings (only in menu edit, not yet confirmed)
% 1. get factory settings without changing global CalibDetails
CurSGSR = SGSR; % store current SGSR value
SystemParameters; % get factory settings
defSGSR = SGSR;
SGSR = CurSGSR; % restore current CalibDetails value
% 2. set edits to these values
local_display_values(hh, defSGSR);

function local_display_values(hh, sgsr);
set(hh.stimPresentButton, 'value', sgsr.TDTpresent);
local_stimPresentButton(hh); % this enables/disables the edits depending on TDTpresent
local_fillEdit(hh, 'prefDArange', sgsr.prefDAfraction);
local_fillEdit(hh, 'MaxAtten', sgsr.maxAtten);
local_fillEdit(hh, 'SwitchDur', sgsr.switchDur);
local_fillEdit(hh, 'SamRatio', sgsr.maxSampleRatio);
local_fillEdit(hh, 'SamFreqs', sgsr.samFreqs*1e-3); % Hz->kHz;
setstring(hh.MessageText,'');

function local_fillEdit(hh,Ename, value);
textcolors;
h = getfield(hh,[Ename 'Edit']);
setstring(h, StrCompactSpace(num2str(value),2));
uitextcolor(h, BLACK);

function StimPres = local_stimPresentButton(hh);
StimPres = get(hh.stimPresentButton,'value');
if StimPres, en = 'on'; % enable edits
else, en = 'off'; % disable
end
FNS = fieldnames(hh);
for ii=1:length(FNS), % visit all uicontrols
   if StrEndsWith(FNS{ii},'Edit') & ~isequal('SamFreqsEdit', FNS{ii}),
      ch = getfield(hh,FNS{ii});
      set(ch,'enable', en);
   end
end

function local_CancelButton(hh);
% close window without any action
delete(hh.Root);

function local_OKButton(hh);
% get new param values from edits, store in global SGSR and in setup file
pp = local_CheckEditValues(hh);
if isempty(pp), return; end; % errors have been reported by local_CheckEditValues
global SGSR
SGSR = CombineStruct(SGSR, pp); % fields of SGSR...
% ...that are not in pp will survive; for duplicate fields pp takes precedence
% save to disk
saveFieldsInSetupFile(pp, 'localsysparam');
% save menu defaults & quit
SaveMenuDefaults('LocalSysParam');
delete(hh.Root);
AddToLog('Local system parameters set');

function editVals = local_CheckEditValues(hh);
% parse edits, check them, apply these values
global SGSR
editVals = []; % init value indicates something went wrong
textcolors;
% check if hardware is present at all
% parse edits
pp.TDTpresent = local_stimPresentButton(hh);
pp.samFreqs = sort(1e3*UIdoubleFromStr(hh.SamFreqsEdit,4)); % kHz->Hz; max 4 sample rates
pp.maxSampleRatio = UIdoubleFromStr(hh.SamRatioEdit,1);
pp.switchDur = UIdoubleFromStr(hh.SwitchDurEdit,1); 
pp.maxAtten = UIdoubleFromStr(hh.MaxAttenEdit,1);
pp.prefDAfraction = UIdoubleFromStr(hh.prefDArangeEdit,1);
if ~pp.TDTpresent, % need not check other edits
   editVals = pp; 
   return;
elseif ~SGSR.TDTpresent, % the presence of hardware is new - init the hardware
   if ~HardwareInit,
      UIerror('Unable to initialize TDT hardware');
      return;
   end
end
% check for non-numerical and oversized input 
pvalues = [pp.prefDAfraction pp.maxSampleRatio pp.switchDur pp.maxAtten pp.samFreqs ];
hhh = [hh.prefDArangeEdit hh.SamRatioEdit hh.SwitchDurEdit hh.MaxAttenEdit hh.SamFreqsEdit ];
nnn = {'Preferred D/A range', 'Max Sample ratio','Switch interval','Max analog Att.','Sample frequencies'};
if any(isnan(pvalues)),
   UIerror('Non-numerical input');
   return;
end
if any(isinf(pvalues)),
   UIerror('Too many numbers specified');
   return;
end
% negative?
nega = find(pvalues<0); if nega>5, nega=5; end; % samFreqs can be multiple valued
if ~isempty(nega),
   ii = min(nega);
   mess = strvcat(nnn{ii}, ' must be non-negative');
   UIerror(mess,hhh(ii));   
   return;
end
% check individuals
textcolors;
% D/A range must be number between 0 and 1
ii = 1; % index of pre D/A range
if (pvalues(ii)<=0) | (pvalues(ii)>1),
   mess = strvcat(nnn{ii}, ' must be >0',' and <=1');
   UIerror(mess,hhh(ii));
   return;
end
% max sample ratio must be >=0.2 and <0.5
ii = 2; % index of maxSampleRatio
if (pvalues(ii)>=0.5) | (pvalues(ii)<0.2),
   mess = strvcat(nnn{ii}, ' must be >=0.2',' and <0.5');
   UIerror(mess,hhh(ii));
   return;
end
% switchdur must be >=30
ii = 3; % index of switchDur
if (pvalues(ii)<30),
   mess = strvcat(nnn{ii}, ' must be >=30 ms');
   UIerror(mess,hhh(ii));
   return;
end
% test max atten value
ii = 4;
if (pvalues(ii)<0) | (pvalues(ii)>120),
   mess = strvcat(nnn{ii}, ' must be >0',' and <120 dB');
   UIerror(mess,hhh(ii));
   return;
end
% all sam freqs must be <=125 kHz
ii =5; % index of (first) sample freq
if any(pvalues(ii:end)>125e3),
   mess = strvcat(nnn{ii}, 'cannot exceed 125 kHz');
   UIerror(mess,hhh(ii));
   return;
end
% base clock rate problem: true sample freqs must me divisors
% of 12.5 MHz. Use PD1speriod to get true (=rounded) values
pp.samFreqs = local_correctSamFreqs(pp.samFreqs);
editVals = pp;

function rsf = local_correctSamFreqs(sf);
rsf = sf;
try, if ~isequal('sys2', TDTsystem), return; end; end;
Nsfr = length(sf);
if ~exist('s232.dll'), tdtinit; end; % tdt stuff was not initialized yet
for ii=1:Nsfr,
   SP = s232('PD1speriod',1,1e6/sf(ii)); % true sample period in us
   rsf(ii) = 1e6/SP; % true sample period in Hz
end

%--------------------------------------------------------------------
function localParam = localUpdateLocalParam(localParam, SUFN);
% fix obsolete setupfile features
fixed = 0;
if isfield(localParam, 'LocalSysParam'), % correct an obsolete storage of local system params
   localParam = localParam.LocalSysParam;
   fixed = 1;
end
npx = isequal(2,exist(setupFile('noAP2')));
if npx,
   % this is an obsolete way to indicate the abscence of stimulus hardware; ...
   % ...replace it by the new localsysparam setup file
   localParam.TDTpresent = 0;
   fixed = 1;
end
if fixed, % store the new-style settings
   try, delete(setupFile(SUFN)); end;
   saveFieldsInSetupFile(localParam, SUFN);
   if npx, try, delete(setupFile('noAP2')); end; end;
end


