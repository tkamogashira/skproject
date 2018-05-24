function Dur=DurPanel(T, EXP, Prefix, Flag, ITDoptions);
% DurPanel - generic durations and timing panel for stimulus GUIs.
%   D=DurPanel(Title, EXP) returns a GUIpanel D for specification of
%   stimulus parameters concerning timing and durations. Title is the title
%   of the GUIpanel. Title='-' means the default title 'duration & timing'.
%   EXP is the experiment definition, from which the number of DAC channels 
%   used (1 or 2) is determined. The paramQuery objects contained in D are 
%        BurstDur: duration of the stimulus in ms including ramps.
%           Delay: delay [ms] of stimulus onset, common to both DACs
%         RiseDur:  rise time in ms.
%         FallDur:  rise time in ms.
%             ITD: interaural time delay (ipsi vs contra) in ms
%         ITDtype: waveform|gating|ongoing determines how ITD is realized
%                  waveform = whole waveform delay;
%                  gating = delayed gating imposed on nondelayed waveform;
%                  ongoing = nondelayed gating imposed on delayed waveform.
%           Phase: (optional) starting phase.
%                    
%   BurstDur, RiseDur, and Falldur may be [left,right] pairs provided the
%   stimulus context allows dual-channel stimulation.
%
%   DurPanel is a helper function for stimulus definitions like stimdefFS.
% 
%   M=DurPanel(Title, ChanSpec, Prefix) prepends the string Prefix
%   to the paramQuery names, e.g. ITD -> NoiseITD, etc.
%
%   M=DurPanel(Title, ChanSpec, Prefix, 'nophase') discards the phase
%   query.
%
%   M=DurPanel(Title, ChanSpec, Prefix, 'basicsonly') only provides the
%   burstdur, risedur and falldur queries.
%
%   M=DurPanel(Title, ChanSpec, Prefix, 'basicsonly_mono') only provides
%   the basic parameters burstdur, risedur and falldur and restricts then
%   to single values (no per-channel specs). 
%
%   M=DurPanel(Title, ChanSpec, Prefix, Flag, ITDoptions), restricts the
%   choice of ITD types to char cell array ITDoptions. Default is all
%   options: waveform, fine, gate, mod, fine+gate, fine+mod, gate+mod.
%
%   Use EvalDurPanel to read the values from the queries and to perform 
%   standard checks on their consistency with other parameters.
%
%   See StimGUI, GUIpanel, EvalDurPanel, stimdefFS.

if isequal('-', T), T= 'durations & timing'; end
if nargin<3, Prefix=''; end
if nargin<4, Flag=''; end
if nargin<5, ITDoptions = {'waveform' 'fine' 'gate' 'mod' 'fine+gate' 'fine+mod' 'gate+mod'}; end

ITDstring = ['Positive values correspond to ' upper(strrep(EXP.ITDconvention, 'Lead', ' Lead')) '.'];

% # DAC channels fixes the allowed multiplicity of user-specied numbers
if isequal('Both', EXP.AudioChannelsUsed) && ~isequal('basicsonly_mono',Flag), 
    Nchan = 2;
    PairStr = ' Pairs of numbers are interpreted as [left right].';
else, % single Audio channel
    Nchan = 1;
    PairStr = ''; 
end
if isequal('basicsonly_mono',Flag), % always mono, indep of EXP: use smaller edits
    Durstr = '15000';
    Rampstr = '2.5';
else, % use wider edits
    Durstr = '15000 15000';
    Rampstr = '2.5 3.0';
end
BurstDur = paramquery([Prefix 'BurstDur'], 'burst:', Durstr, 'ms', ...
    'rreal/positive', 'Duration of burst including ramps.',Nchan);
OnsetDelay = paramquery([Prefix 'OnsetDelay'], 'delay:', '1500', 'ms', ...
    'rreal/nonnegative', 'Delay of stimulus onset (common to both DA channels).',1);
RiseDur = paramquery([Prefix 'RiseDur'], 'rise:', Rampstr, '', ...
    'rreal/nonnegative', ['duration of onset ramps.' PairStr],Nchan);
FallDur = paramquery([Prefix 'FallDur'], 'fall:', Rampstr, 'ms', ...
    'rreal/nonnegative', ['duration of offset ramps.' PairStr],Nchan);
ITD = paramquery([Prefix 'ITD'], 'ITD:', '-123.44', 'ms', ...
    'rreal', ['interaural delay. ' ITDstring],1);
ITDtype = paramquery([Prefix 'ITDtype'], ' on', '', ITDoptions, '', ...
    ['Implementation of ITD. Click to toggle between options.' char(10) ...
    '    waveform = whole waveform delay (fine structure + gating + modulation)' char(10) ...
    '      fine = delayed fine structure; diotic gating & modulation' char(10)  ...
    '      gate = delayed gating only; diotic fine structure & modulation' char(10)  ...
    '      mod = delayed modulation only; diotic fine structure & modulation' char(10)  ...
    '      fine+gate = delayed fine structure & gating; diotic modulation' char(10)  ...
    '      fine+mod = delayed fine structure & modulation; diotic gating' char(10)  ...
    '      gate+mod = delayed gating & modulation; diotic fine structure' char(10)  ...
    ]);
WavePhase = paramquery([Prefix 'WavePhase'], 'Phase:', '-0.1251 -0.1251', 'cycle', ...
    'rreal', ['Waveform starting phase. POSITIVE numbers indicate a phase LEAD.' PairStr], Nchan);

Dur = GUIpanel('Dur', T);
Dur = add(Dur, BurstDur,'below',[0 0]);
Dur = add(Dur, OnsetDelay,nextto(BurstDur),[5 0]);
Dur = add(Dur, RiseDur, below(BurstDur), [0 0]);
Dur = add(Dur, FallDur, nextto(RiseDur));
if ~isequal('basicsonly', Flag) && ~isequal('basicsonly_mono', Flag),
    Dur = add(Dur, ITD, ['below ' Prefix 'RiseDur']);
    Dur = add(Dur, ITDtype,'nextto');
    if ~isequal('nophase', Flag),
        Dur = add(Dur, WavePhase, ['below ' Prefix 'ITD']);
    end
end








