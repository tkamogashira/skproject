function S = stimOUI(stimName);
% stimOUI - launch stimulus OUI
%    stimOUI('foo') launches the stimulus OUI for stimulus foo.
%    If foo is not specified, the 'FS' stimulus is used.
%    The definition of the stimulus must be a the mfile named 
%    StimDefinitionFoo. This file, which contains the complete 
%    definition of the stimulus and its OUI, must have a standard
%    design. For instance, StimDefinitionFoo('paramset') must return
%    the paramset comprising the stimulus, including the OUI design.
%    A complete description can be found in the documentation on 
%    stimulus definition.
%
%    For a list of existing stimulus definitions, type stimulusList.
%    StimDefinitionFS is the "Ur" example of a stimulus definition file.
%
%   See StimDefinitionFS, stimulusList and the documentation on stimulus definition.

if nargin<1, stimName='FS'; end
stimName = upper(stimName);

stimDefFile = ['stimdefinition' stimName];

if ~isequal(2, exist(stimDefFile,'file')),
   error(['Undefined stimulus type ''' stimName '''. Use ''stimulusList'' for a list of defined stimulus types.']);
end

% where is the stimulus definition? Warn if not generic.
qq = which(stimDefFile, '-all');
if numel(qq)>1,
   warning(['Multiple definitions of ''' stimName ''' stimulus coexist.']);
end
[PP NN XT] = fileparts(qq{1});
[P0 P1] = fileparts(PP);
if ~isequal('thestimuli', lower(P1)),
   warning(['Stimulus definition mfile ''' stimDefFile ''' does not reside in the generic ''theStimuli'' folder.']);
end

if isempty(experiment('current')),
   error('No experiment has been initialized - use EXPERIMENT to do that.');
end

% initialize the stimulus paramset and launch the GUI
CT = stimulusContext(1); % 1 arg: make fresh random seed
S = feval(stimDefFile, 'factoryparamset', CT); % S = StimDefinitionFoo('paramset', CT);
paramOUI([S stimulusdashboard('OUI', S.OUI.minFigSize(2))]);
% overrule default closereq function
set(ouiHandle, 'CloseRequestFcn', 'stimulusdashboard(''close'');');
% retrieve most recent, approved, paramset, and impose values on the OUI
ouiDefault('impose', S);
stimulusdashboard('retrievePlayRecordParams'); % restore the most recent dashboard params

% collect handles for enable/disable modes during handling of callbacks
stimulusdashboard('CollectDashboardHandles')

% context menu for disabling individual OUI items
hc = uicontextmenu('tag', 'EnableOUIitem');
uimenu(hc, 'tag', 'OUIcontrolDisableMenuItem', ...
   'label', 'temporarily DISABLE for saving defaults', ...
   'callback' , 'OUIitemContextMenuCallback;')
uimenu(hc, 'tag', 'OUIcontrolEnableMenuItem', ...
   'label', 'RE-ENABLE', ...
   'callback' , 'OUIitemContextMenuCallback;')
GD = ouidata;
stimItems = GD.ParamData(1).OUI.item;
OUIhandle({stimItems.name}, nan, 'uicontextmenu', hc);





