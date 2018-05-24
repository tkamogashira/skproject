function Mod=SAMpanel(T, EXP, Prefix, IncludeTheta, IncludeITD);
% SAMpanel - generic amplitude modulation panel for stimulus GUIs.
%   S=SAMpanel(Title, EXP) returns a GUIpanel M allowing the 
%   user to specify a fixed sinusiodal modulation to be applied 
%   to all the stimuli of a series. Guipanel S has title Title. EXP is the 
%   experiment definition, from which the number of DAC channels used 
%   (1 or 2) is determined.
%
%   The paramQuery objects contained in F are named: 
%            ModFreq: modulation frequency in Hz
%           ModDepth: modulation depth in % (100%==full AM)
%      ModStartPhase: starting phase of modulation in Cycles (0=cos)
%           ModTheta: modulation angle in Cycles (0=AM; 0.25=QFM)
%
%   SAMpanel is a helper function for stimulus definitions like stimdefFS.
% 
%   M=SAMpanel(Title, EXP, Prefix) prepends the string Prefix
%   to the paramQuery names, e.g. ModFreq -> NoiseModFreq, etc.
%   Default Prefix is '', i.e., no prefix.
%
%   M=SAMpanel(Title, EXP, Prefix, IncludeTheta, IncludeITD) fixes the
%   optional inclusion of a Theta query (default: true) and a ITD query
%   (default: flase). Theta is the modulation angle.
%
%   Use EvalSAMpanel to read the values from the queries.
%
%   See StimGUI, GUIpanel, EvalSAMpanel, stimdefFS.

[Prefix, IncludeTheta, IncludeITD] = arginDefaults('Prefix/IncludeTheta/IncludeITD', '', 1,0);

% # DAC channels fixes the allowed multiplicity of user-specied numbers
if isequal('Both', EXP.AudioChannelsUsed), 
    Nchan = 2;
    PairStr = ' Pairs of numbers are interpreted as [left right].';
else, % single Audio channel
    Nchan = 1;
    PairStr = ''; 
end

ITDstring = ['Positive values correspond to ' upper(strrep(EXP.ITDconvention, 'Lead', ' Lead')) '.'];

% ---Modulation
Mod = GUIpanel('Mod', T);
ModFreq = paramquery([Prefix 'ModFreq'], ...
    'frequency:', '1100.1 1100.1', 'Hz', 'rreal/nonnegative', ...
    ['Modulation frequency.' PairStr], Nchan);
ModDepth = paramquery([Prefix 'ModDepth'], ...
    'depth:', '20.5 33.3', '%', 'rreal/nonnegative', ...
    ['Modulation depth.' PairStr], Nchan);
ModStartPhase = paramquery([Prefix 'ModStartPhase'], ...
    'phase:', '-0.25 -0.33', 'Cycle', 'rreal', ...
    ['Starting phase of modulation. Zero means cosine phase.' PairStr], Nchan);
ModITD = paramquery([Prefix 'ModITD'], 'Mod ITD:', '-123.44', 'ms', ...
    'rreal', ['Interaural delay of modulation; will be superimposed on waveform ITD!. ' ITDstring],1);
Theta = paramquery([Prefix 'ModTheta'], ...
    'theta:', '-0.25 -0.33', 'Cycle', 'rreal', ...
    ['Modulation angle. Theta = 0 results in AM; Theta=0.25 is QFM; other values give mixed modulation.' PairStr], Nchan);

Mod = add(Mod,ModFreq);
Mod = add(Mod,ModDepth, 'aligned', [0 -5]);
Mod = add(Mod,ModStartPhase, 'aligned', [0 -5]);
if IncludeITD,
    Mod = add(Mod,ModITD, 'aligned', [0 -5]);
end
if IncludeTheta,
    Mod = add(Mod,Theta, 'aligned', [0 -5]);
end



