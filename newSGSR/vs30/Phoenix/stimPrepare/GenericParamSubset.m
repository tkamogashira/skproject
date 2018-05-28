function S = GenericParamSubset(S, subsetName, XY, CT, groupName);
% GenericParamSubset - partial paramset definition generic parameters
%   S = GenericParamSubset(S, 'foo', [X Y], CT) adds a generic set of
%   foo-related parameters and their OUI items to paramset S.
%   The position of the OUI frame is given by [X Y], in points.
%   CT is the stimulus context, which limits the maximum size of some 
%   of the parameters. Default CT is the value returned by StimulusContext.
%   The uicontrols are placed in a OUIgroup 'foo'.
%
%   S = GenericParamSubset(S, 'foo', [X Y], CT, groupName) uses a
%   name for the OUIgroup that is different from 'foo'.
%
%   Here is a listing of currently defined generic paramSubsets 
%   and their parameters/queries and other OUI items:
%
%        frequency:  startFreq, stepType, linStepFreq, logStepFreq, endFreq
%        durations:  burstDur, rampDur, ITD
%              SPL:  SPL, activeDA, maxSPL
%       modulation:  modDepth, modFreq
%     presentation:  interval, Nrep, order, Ncondition
%
%   See also paramset, paramOUI, DurationsParamSubset, StimulusContext.

if nargout<1, 
   error('Not enough output arguments. Syntax: S = GenericParamSubset(S, groupName ,[X Y]).'); 
end

if nargin<4, CT = stimulusContext; end; % current stimulus context
if isempty(CT.experiment),
   error('No experiment initialized - missing essential DAchannel info.');
end
[maxNchan, chanNames] = DAchanStats(CT);
if nargin<5, groupName = subsetName; end


% aux
TTpairs = ' Pairs of numbers mean [left right].'; 
TThit = 'Hit button to toggle between ';
ED = 'edit'; TG = 'toggle';

switch lower(subsetName),
case 'frequency'
   S = AddParam(S,  'startFreq', 300,      'Hz',      'ureal', maxNchan);
   S = AddParam(S,  'stepType',  'octave',  '',       'char', inf);
   S = AddParam(S,  'linStepFreq',  50,    'Hz',     'real',   maxNchan);
   S = AddParam(S,  'logStepFreq', 0.2,    'octave', 'real',   maxNchan);
   S = AddParam(S,  'endFreq',     4500,    'Hz',     'ureal',  maxNchan);
   S = InitOUIgroup(S, groupName, [XY 140 70]); 
   S = DefineQuery(S, 'startFreq',     0, ED,   'start:',   '21000.5 21000.1', ['Frequency at start of sweep.' TTpairs] );
   S = DefineQuery(S, 'linStepFreq', 20, ED,   'step:',    '1100 1101',       ['Size of linear frequency step.' TTpairs] );
   S = DefineQuery(S, 'logStepFreq', 20, ED,   'step:',    '0.25 0.25',       ['Size of logaritmic frequency step.' TTpairs] );
   S = DefineQuery(S, 'stepType', [80 20], TG,   '',       {'Hz','octave'},   [TThit 'linear and logaritmic frequency steps'] );
   S = DefineQuery(S, 'endFreq',      40, ED,   'end:',     '21000.5 21000.1', ['Frequency at end of sweep.' TTpairs] );
   S = SeeSaw(S, 'stepType', 'linStepFreq', 'logStepFreq'); % steptype toggle button also toggles xxxStepFreq edits
case 'durations',
   S = AddParam(S,  'burstDur',    100,    'ms',     'ureal',  maxNchan);
   S = AddParam(S,  'rampDur',       4,    'ms',     'ureal',  [2 maxNchan]);
   S = AddParam(S,  'ITD',           0,    'ms',      'real',  1);
   % OUI items
   S = InitOUIgroup(S, groupName, [XY 120 70]);
   S = DefineQuery(S, 'burstDur',  0, ED, 'burst:',    '1000 1000', ['Burst duration.' TTpairs]);
   S = DefineQuery(S, 'rampDur',  20, ED, 'rise/fall:', '20.5 10.9', 'Durations of onset and offset ramps. Pairs of numbers mean [RISE FALL].');
   S = DefineQuery(S, 'ITD',      40, ED, 'ITD',  '-0.060.3', 'Interaural time difference. POSITIVE values correspond to LEADING IPSILATERAL channel.');
case 'spl',
   S = AddParam(S,  'SPL',          85,   'dB_SPL',   'real',  maxNchan');
   S = AddParam(S,  'activeDA',  chanNames{1},  'chanName', 'DAchan');
   % OUI items
   S = InitOUIgroup(S, groupName, [XY 220 55], 'SPLs & active DA channels');
   S = DefineQuery(S, 'SPL', 0, ED, 'level(s):', '110.5 110.9', ['Carrier SPL.' TTpairs]);
   S = DefineQuery(S, 'activeDA', [135 0], TG, 'Active:', chanNames(1:end-1), [TThit 'active DA channels = Left/Right?Both.' ]);
   S = defineReporter(S, 'maxSPL', [10 28], {'max: [100.6 101.9 dB SPL]' '@ [34000 21000 kHz]'}, ...
      ['Maximum SPL that can be realized with current value of stimulus parameters.' TTpairs], 'foregroundcolor', [0.4 0 0]);
case 'modulation',
   S = AddParam(S,  'modDepth',     50,     '%',     'ureal',  maxNchan);
   S = AddParam(S,  'modFreq',     120,    'Hz',     'ureal',  maxNchan);
   % OUI items
   S = InitOUIgroup(S, groupName, [XY 140 50]); 
   S = DefineQuery(S, 'modDepth', 0,    ED,   'depth:',   '100 100',         ['Modulation depth. ' TTpairs] ) ;
   S = DefineQuery(S, 'modFreq',  20,     ED,   'rate:',    '120.1 120.2',     ['Modulation frequency' TTpairs] );
case 'presentation',
   S = AddParam(S,  'interval',    200,    'ms',     'ureal',  1);
   S = AddParam(S,  'Nrep',         10,    '',       'uint',   1);
   S = AddParam(S,  'order',   'Random',    '',       'char',  inf');
   % OUI items
   S = InitOUIgroup(S, groupName, [XY 120 70]);
   S = DefineQuery(S, 'interval', 0, ED, 'interval:', '12000', 'Interval duration, i.e., duration between the offsets of subsequent repetitions.' );
   S = DefineQuery(S, 'Nrep', 20, ED, 'reps:', '1234', 'Number of repetitions of each stimulus condition.');
   S = DefineQuery(S, 'order', 40, TG, 'order:', {'Forward', 'Reverse', 'Random'}, [TThit 'Forward/Reverse/Random order of stimulus presentation.']);
   S = defineReporter(S, 'Ncondition', [65 31.5], '# cond: 100', ...
      '# conditions (subsequences) resulting from current settings. Hit Check/Update to update the info.', 'foregroundcolor', [0.4 0 0]);
otherwise,
   error(['Unknown generic parameter subset named ''' subsetName '''.']);
end














