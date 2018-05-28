function DS = InitDataset(S, CT, IndepVar, indepAux, Specials);
% InitDataset - create dataset object from stimulus parameters and context
%   InitDataset(S, CT, IndepVar, indepAux, Specials) creates a 
%   dataset variable that is "almost complete". The only missing
%   information are the data (spike times etc) and those subfields
%   of the ID that have to do with file format, sequence number and
%   sequence ID. The latter missing parts can only be provided when
%   the measurement has been launched.
%
%   Input arguments of InitDataset are:
%          S: the paramset as returned by readOUI
%         CT: stimulus context as retuned by stumulusContext
%   IndepVar: parameter object containing the independent variable
%   indepAux: cell array with {name shortname plotscale} of indep variable 
%   Specials: struct containing those values of "stimulus specials" that
%             cannot be retrieved automatically.
%
%   See StimDefinitionFS for a detailed example.

% create dataset from current paramset. 
% Note: only the Data and some of the ID fields are missing - otherwise DS is complete.

Ncond = size(IndepVar.value, 1);
DS = struct(dataset); % void dataset
%===========ID
DS.ID.FileName = CT.experiment.expname.value;
DS.ID.FileFormat = 'TInneF'; % abbr of 'Temporary Internal Format'
DS.ID.Experimenter = CT.experiment.experimenter.value;
DS.ID.StimType = S.name;
DS.ID.Place = CT.location;
dd = datevec(CT.now); DS.ID.Time = round(dd([3 2 1 4 5 6]));
%===========sizes
DS.Sizes.Nsub = Ncond;
DS.Sizes.NsubRecorded = 0;
DS.Sizes.Nrep = S.Nrep.value;
%===========indepvar
DS.Stimulus.IndepVar.Name = indepAux{1};
DS.Stimulus.IndepVar.ShortName = indepAux{2};
DS.Stimulus.IndepVar.Values = IndepVar.value;
DS.Stimulus.IndepVar.Unit = IndepVar.unit;
DS.Stimulus.IndepVar.PlotScale = indepAux{3};
% ===========stimulus
DS.Stimulus.StimParam = S; 
% Specials: start all over again - in particular, we need control over the order of the fields
DS.Stimulus.Special = []; 
DS.Stimulus.Special.RepDur = S.Interval.in_ms; 
DS.Stimulus.Special.BurstDur = paramIfPresent(S, 'burstDur', 'in_ms', NaN);
DS.Stimulus.Special.SPL = paramIfPresent(S, 'SPL', 'in_dB_SPL', NaN);
DS.Stimulus.Special.CarFreq = paramIfPresent(S, 'carFreq', 'in_Hz', NaN);
DS.Stimulus.Special.ModFreq = paramIfPresent(S, 'modFreq', 'in_Hz', NaN);
DS.Stimulus.Special.ModDepth = paramIfPresent(S, 'modDepth', 'in_%', NaN);
if ~isstruct(Specials) & ~isempty(Specials),
   error('''Specials'' argument to initDataset must be struct or [].');
end
try, 
   DS.Stimulus.Special = combineStruct(DS.Stimulus.Special, Specials, 'nonew');
catch,
   invF = setdiff(fieldnames(Specials), fieldnames(DS.Stimulus.Special));
   mess = {'''Specials'' argument contains invalid fields:' invF{:}};
   error(errorStr(mess));
end
DS.Stimulus.Special.BeatFreq = uniquify(diff(stereoVar(DS.Stimulus.Special.CarFreq),1,2));
DS.Stimulus.Special.BeatModFreq = uniquify(diff(stereoVar(DS.Stimulus.Special.ModFreq),1,2));
% convert ITD -> delay-per-channel
ITD = paramIfPresent(S, 'ITD', 'in_ms', 0);
delay = [ITD 0];
% by convention, positive ITD means: leading ipsi. Previous line assumed ipsi==left ...
if isequal('Right', CT.experiment.RecordingSide.as_chanName); % .. correct this if ipsi==right
   delay = -delay;
end
delay = delay - min(delay); % smallest delay must be zero
DS.Stimulus.Special.ITD = ITD;
DS.Stimulus.Special.Delay = delay;
% ramps
ramp = S.rampDur.in_ms;
switch numel(ramp),
case 1, rise = ramp; fall = ramp;
case 2, 
   if size(ramp,2)==2, rise = ramp(1); fall = ramp(2); % [rise fall]
   else, rise = ramp.'; fall = ramp.'; % [left; right]
   end
case 4, rise = ramp(:,1).'; fall = ramp(:,2).'; % [riseL fallL; riseR fallR]
end
[DS.Stimulus.Special.riseDur, DS.Stimulus.Special.fallDur] = deal(rise, fall);
DS.Stimulus.Special.ActiveChan = S.activeDA.as_chanNum; % 0|1|2 = both|left|right by convention
% also store specials in paramset PS
SPEC = rmfield(DS.Stimulus.Special, 'ActiveChan');
PS = paramset('StimulusSpecial', [S.name '_specials'], ...
   ['Special parameters of ' S.name ' stimulus'], 1, [], mfilename);
%   RepDur BurstDur   SPL   CarFreq ModFreq ModDepth BeatFreq BeatModFreq ITD Delay riseDur fallDur
Units ={'ms'  'ms'  'dB_SPL'  'Hz'  'Hz'     '%'       'Hz'     'Hz'       'ms' 'ms' 'ms'   'ms'};
PS = paramsFromStruct(PS, SPEC, Units);
PS = addParam(PS, S.activeDA);
DS.Stimulus.Special.paramSet = PS;
% ----
DS.Settings = CT;

DS = dataset(DS, 'convert');















