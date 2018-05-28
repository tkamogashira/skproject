function Levels=SPLpanel(T, EXP, Prefix, CmpName);
% SPLpanel - generic SPL and DAchannel panel for stimulus GUIs.
%   S=SPLpanel(Title, EXP) returns a GUIpanel M named 'Levels' allowing the 
%   user to specify a fixed sinusiodal amplitude modulation to be applied 
%   to all the stimuli of a series. Guipanel S has title Title. EXP is the 
%   experiment definition, from which the number of DAC channels used 
%   (1 or 2) is determined. Title='-' results in standard title 'SPLs & 
%   active channels'
%
%   The paramQuery objects contained in S are
%         SPL: level of stimuli in dB SPL
%         DAC: active DA channel
%   The messenger contained in S is
%       MaxSPL: report of max attainable SPL (filled by MakeStimXXX)
%
%   SPLpanel is a helper function for stimulus definitions like stimdefFS.
% 
%   M=SPLpanel(Title, ChanSpec, Prefix, 'Foo') prepends the string Prefix
%   to the paramQuery names, e.g. SPL -> NoiseSPL, etc, and calls the
%   components whose SPL is set by the name Foo.
%
%   Use EvalSPLpanel to check the feasibility of SPLs and to update the 
%   MaxSPL messenger display.
%
%   See StimGUI, GUIpanel, ReportMaxSPL, stimdefFS, SPLstepper.

% # DAC channels fixes the allowed multiplicity of user-specied numbers

[Prefix, CmpName] = arginDefaults('Prefix/CmpName', '', 'Carrier');

if isequal('-',T), T = 'SPLs & active channels'; end

% # DAC channels fixes the allowed multiplicity of user-specied numbers
if isequal('Both', EXP.AudioChannelsUsed), 
    Nchan = 2;
    PairStr = ' Pairs of numbers are interpreted as [left right].';
else, % single Audio channel
    Nchan = 1;
    PairStr = ''; 
end
ClickStr = ' Click button to select ';

% ---SPL
switch EXP.Recordingside,
    case 'Left', Lstr = 'Left=Ipsi'; Rstr = 'Right=Contra';
    case 'Right', Lstr = 'Left=Contra'; Rstr = 'Right=Ipsi';
end
switch EXP.AudioChannelsUsed,
    case 'Left', DACstr = {Lstr};
    case 'Right', DACstr = {Rstr};
    case 'Both', DACstr = {Lstr Rstr 'Both'};
end

SPL = paramquery([Prefix 'SPL'], 'levels:', '120.5 120.5', 'dB SPL', ...
    'rreal', [CmpName ' SPL.' PairStr],Nchan);
DAC = paramquery([Prefix 'DAC'], 'DAC:', '', DACstr, ...
    '', ['Active D/A channels.' ClickStr 'channel(s).']);
MaxSPL=messenger([Prefix 'MaxSPL'], 'max [**** ****] dB SPL @ [***** *****] Hz    ',1);

Levels = GUIpanel('Levels', T);
Levels = add(Levels,SPL,'below');
Levels = add(Levels,DAC,'nextto',[15 0]);
Levels = add(Levels,MaxSPL,['below ' Prefix 'SPL'],[17 0]);
Levels = marginalize(Levels, [0 3]);




