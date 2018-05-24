function NP=NoisePanel(T, EXP, Prefix, Exclude);
% NoisePanel - generic noise panel for stimulus GUIs.
%   NP=NoisePanel(Title, EXP) returns a GUIpanel NP allowing the 
%   user to specify a white noise band. Guipanel NP has title Title. EXP is the 
%   experiment definition, from which the number of DAC channels used 
%   (1 or 2) is determined.
%
%   The paramQuery objects contained in F are named: 
%            LowFreq: lower cutoff frequency in Hz
%           HighFreq: higher cutoff frequency in Hz
%         NoiseSeed: random seed used for realization of noise waveform
%               SPL: sound intensity, with toggle (dB SPL | dB/Hz)
%              Corr: interaural correlation with toggle (C|I)  
%         NoiseSeed: random seed 
%               DAC: toggle L|R|B
%  
%   A messenger fo reporting the maximum SPL is also created.
%
%   NoisePanel is a helper function for stimulus definitions like
%   stimdefNPHI.
% 
%   M=NoisePanel(Title, EXP, Prefix, , Exclude) prepends the string Prefix
%   to the paramQuery names, e.g. LowFreq -> NoiseLowFreq, etc. Exclude is
%   one of 'Corr' or 'SPL', resulting in omitting the corresponding queries.
%
%   Use EvalNoisePanel to read the values from the queries.
%
%   See StimGUI, GUIpanel, EvalNoisePanel, stimdefNPHI.

if nargin<3, Prefix=''; end
if nargin<4, Exclude=''; end

%===========Bookkeeping=========
% ---levels and active DACs
if isequal('-',T), T = 'SPLs & active channels'; end
% # DAC channels fixes the allowed multiplicity of user-specied numbers
if isequal('Both', EXP.AudioChannelsUsed), 
    Nchan = 2;
    PairStr = ' Pairs of numbers are interpreted as [left right].';
else, % single Audio channel
    Nchan = 1;
    PairStr = ''; 
end
Levels = GUIpanel('Levels', T);
switch EXP.Recordingside,
    case 'Left', Lstr = 'Left=Ipsi'; Rstr = 'Right=Contra';
    case 'Right', Lstr = 'Left=Contra'; Rstr = 'Right=Ipsi';
end
switch EXP.AudioChannelsUsed,
    case 'Left', DACstr = {Lstr};
    case 'Right', DACstr = {Rstr};
    case 'Both', DACstr = {Lstr Rstr 'Both'};
end
ClickStr = ' Click button to select ';

%===========Queries========
% ---freq & seed
LowFreq = paramquery([Prefix 'LowFreq'], ...
    'low:', '1100.1 1100.1', 'Hz', 'rreal/nonnegative', ...
    ['Low cutoff frequency.' PairStr], Nchan);
HighFreq = paramquery([Prefix 'HighFreq'], ...
   'high:', '1100.1 1100.1', 'Hz', 'rreal/nonnegative', ...
    ['High cutoff frequency.' PairStr], Nchan);
Corr = paramquery([Prefix 'Corr'], 'corr:', '-0.9997 ', {'I', 'C'}, ...
    'rreal', ['Interaural noise correlation (number between -1 and 1)', char(10), ... 
    'Click button to change the "varied channel" (where mixing is done).'],1);
NoiseSeed = paramquery([Prefix 'NoiseSeed'], 'seed:', '844596300', '', ...
    'rseed', 'Random seed used for realization of noise waveform. Specify NaN to refresh seed upon each realization.',1);
NoiseIPD = paramquery([Prefix 'Corr'], 'corr:', '-0.9997 ', {'I', 'C'}, ...
    'rreal', ['Interaural noise correlation (number between -1 and 1)', char(10), ... 
    'Click button to change the "varied channel" (where mixing is done).'],1);
% ---SPL
SPL = paramquery([Prefix 'SPL'], 'level:', '120.5 120.5', {'dB SPL' 'dB/Hz'}, ...
    'rreal', ['Intensity. Click button to switch between overall level (dB SPL) and spectrum level (dB/Hz).' PairStr],Nchan);
DAC = paramquery('DAC', 'DAC:', '', DACstr, ...
    '', ['Active D/A channels.' ClickStr 'channel(s).']);
MaxSPL=messenger([Prefix 'MaxSPL'], 'max [**** ****] dB SPL @ [***** *****] Hz    ',1);


% ========Add queries to panel=======
NP = GUIpanel('Noise', T);
NP = add(NP,LowFreq, 'below', [10 0]);
NP = add(NP,HighFreq, 'aligned', [0 -7]);
NP = add(NP,SPL, nextto(LowFreq), [20 0]);
NP = add(NP,Corr, 'aligned', [0 -7]);
NP = add(NP,NoiseSeed, nextto(Corr), [0 0]);
NP = add(NP,MaxSPL,below(HighFreq),[17 0]);
NP = add(NP,DAC,'nextto',[5 -10]);
NP = marginalize(NP, [0 3]);

% remove some, if requested
NP = remove(NP, Exclude);

