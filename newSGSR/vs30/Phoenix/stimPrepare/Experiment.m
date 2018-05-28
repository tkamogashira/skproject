function E = Experiment(keyword, varargin);
% Experiment - initialize experiment or retrieve settings of current experiment
%   Experiment('prompt') launches a dialog for the initialization 
%   of a physiological experiment and returns the parameters in a paramset object.
%
%   Experiment('current') returns the paramset object with the current 
%   experiment settings or [] if none was defined during this MatLab session.
%
%   Experiment('previous') returns the most recently defined experiment, even
%   if that was defined during a previous MatLab session, and makes this
%   the current experiment paramset, i.e., the previous settings are restored.
%   If no previous settings can be found, the factory settings are returned.
%
%   Experiment('factory') returns the paramset object with the factory
%   defaults.
%
%   Experiment('clear') clears the current experiment paramset.
%
%   Experiment('clearprevious') clears the previously stored (cached) sets.
%
%   Experiment is also used as a callback function by the uicontrols of
%   the dialog opened by Experiment('init');
%
%   See also StimulusContext.

persistent retrievedParam;

if nargin<1,  keyword = get(gcbo, 'tag'); end

if isempty(keyword), error(['Missing keyword or uicontrol tag.']); end
if ~ischar(keyword), error('Keyword must be char string.'); end

switch lower(keyword),
case 'factory',
   E = localDefParamset;
   E = E(1);
case 'prompt',
   paramOUI(localDefParamset);
   previousEXP = localRecentParam('load');
   if ~isempty(previousEXP), OUIfill(previousEXP ,1); end
   if nargin<2, uiwait(OUIhandle); end % debug option -> return to commandline 
   E = retrievedParam;
case 'current',
   E = retrievedParam;
case 'clear',
   retrievedParam = [];
case 'clearprevious',
   localRecentParam('clearcache');
case 'previous',
   E = localRecentParam('load');
   if isempty(E), E = experiment('factory'); end; % fall back on factory settings
   retrievedParam = E; 
   %==============CALLBACKS FROM HERE================================
case 'okbutton',
   [retrievedParam, mess] = localReadOUI;
   if isempty(mess), % only if no errors occurred the OUI may be closed , etc
      close(OUIhandle);
      localRecentParam('save', retrievedParam);
   end 
case 'cancelbutton',
   retrievedParam = []; % make sure nothing meaningful is returned
   close(OUIhandle);
otherwise,
   error(['Unknown keyword ''' keyword '''.']);
end


%=========locals=================
function S = localDefParamset;
% paramset definition of experiment
S = paramset('Generic', 'Experiment', 'Parameters of physiological experiment', 1, [280 160], mfilename);
%                 name            val   unit   datatype   maxsize
S = AddParam(S,  'ExpName         _       _      char       20');
S = AddParam(S,  'Experimenter   factory  _      char       10');
S = AddParam(S,  'BrainStructure AN       _      char       10');
S = AddParam(S,  'RecordingSide  Left   chanName DAchan  ');
S = AddParam(S,  'ActiveDA       Both   chanName DAchan  ');
S = AddParam(S,  'useID          Yes    YesNo   switchState');
% OUI
%===
S = InitOUIgroup(S, 'ExperimentParam', [10 10 15-1e6 90], 'parameters');
S = DefineQuery(S, 'ExpName', 0, 'edit', 'name:', 'A01234ABCDEFG' , ['Name of experiment data files. Datafiles wil be created in folder ''' datadir '''.']);
S = DefineQuery(S, 'Experimenter', [140 0] , 'edit', 'experimenter:', 'Alberto  ' , 'Name of experimenter.' );
S = DefineQuery(S, 'BrainStructure', 30 , 'edit', 'structure:', 'auditory nerve' , 'Brain structure from which recordings are taken.' );
S = DefineQuery(S, 'RecordingSide', [145 30], 'toggle', 'recording side:', {'Left' 'Right'} , 'Hit button to toggle between Left/Right recording side.' );
S = DefineQuery(S, 'ActiveDA', 60, 'toggle', 'active DA:', {'Left' 'Right' 'Both'} , 'Hit button to toggle between Left/Right/Both DA channels active.' );
S = DefineQuery(S, 'useID', [150 60], 'toggle', 'use dataset IDs:', {'Yes' 'No'} , 'Hit button to enable/disable naming of datasets.' );
%===DASHBOARD
D = paramset('Dashboard', 'Actions', 'generic OUI actions', 1, [330 160], mfilename);
D = InitOUIgroup(D, 'Dashboard', [10 120 10 10], 'invisible');
D = addActionButton(D, 'OK', 'OK', [265 15 45 45], 'Experiment;', 'Hit button to accept current experiment parameters.');
D = addActionButton(D, 'Cancel', 'CANCEL', [210 15 45 45], 'Experiment;', 'Quit this dialog without any action.');
D = InitOUIgroup(D, 'messages', [10 110 120-1e6 50]);
D = defineReporter(D, 'stdmess', [15 5], [5-1e6 40]);
S = [S D];

function  [retrievedParam, mess] = localReadOUI;
[retrievedParam, mess] = readOUI('Experiment');
% check validity of parameters as entered by the user
errh = [];
if ~isempty(mess), % will report below
elseif ~isvarname(retrievedParam.expname.value),
   mess = {'Experiment name must be a valid MatLab', ...
          'variable name. See ISVARNAME.'}
   errh = {'expname'};
elseif ~isvarname(retrievedParam.experimenter.value),
   mess = {'Experiment name must be a valid MatLab', ...
          'variable name. See ISVARNAME.'}
   errh = {'experimenter'};
end
OUIerror(mess, errh);

function  S = localRecentParam(keyword, S);
CFN = [uidefdir filesep 'Experiment' '.OUIdef']; % full filename of cache file
switch keyword
case 'clearcache',
   emptycacheFile(CFN, 0); % 0: don't warn if ~exist(CFN )
case 'save',
   toCacheFile(CFN, -1, 'LastExp', S);
case 'load',
   S = fromCacheFile(CFN, 'LastExp');
otherwise,
   error(['Invalid keyword ''' keyword '''.']);
end



















