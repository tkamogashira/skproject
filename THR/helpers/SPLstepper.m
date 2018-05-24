function Levels=SPLpanel(T, EXP, Prefix, CmpName);
% SPLstepper - generic panel for stepped SPL and DAchannel in stimulus GUIs.
%   S=SPLstepper(Title, EXP) returns a GUIpanel M named 'Levels' allowing the 
%   user to specify a stepped SPL to be applied to the stimuli of a series.
%   Guipanel S has title Title. EXP is the experiment definition, from 
%   which the number of DAC channels used 
%   (1 or 2) is determined. Title='-' results in standard title 'SPLs & 
%   active channels'
%
%   The paramQuery objects contained in S are
%         StartSPL: starting level of stimuli in dB SPL
%         StepSPL: step of SPL dB
%         EndSPL: end level of stimuli in dB SPL
%         AdjustSPL: how to adjust misfitting step requests.
%         DAC: active DA channel
%   The messenger contained in S is
%       MaxSPL: report of max attainable SPL (filled by MakeStimXXX)
%
%   SPLstepper is a helper function for stimulus definitions like stimdefRF.
% 
%   M=SPLstepper(Title, ChanSpec, Prefix, 'Foo') prepends the string Prefix
%   to the paramQuery names, e.g. StartSPL -> NoiseStartSPL, etc, and calls the
%   components whose SPL is set by the name Foo in any error messages.
%
%   Use EvalSPLstepper to check the feasibility of SPLs and to update the 
%   MaxSPL messenger display.
%
%   See StimGUI, GUIpanel, ReportMaxSPL, stimdefFS, SPLstepper.


[Prefix, CmpName] = arginDefaults('Prefix/CmpName', '', 'Carrier');
if isequal('-',T), T = 'SPLs & active channels'; end

% # DAC channels determines the allowed multiplicity of user-specied numbers
if isequal('Both', EXP.AudioChannelsUsed), 
    Nchan = 2;
    PairStr = ' Pairs of numbers are interpreted as [left right].';
else, % single Audio channel
    Nchan = 1;
    PairStr = ''; 
end
ClickStr = ' Click button to select ';
switch EXP.Recordingside,
    case 'Left', Lstr = 'Left=Ipsi'; Rstr = 'Right=Contra';
    case 'Right', Lstr = 'Left=Contra'; Rstr = 'Right=Ipsi';
end
switch EXP.AudioChannelsUsed,
    case 'Left', DACstr = {Lstr};
    case 'Right', DACstr = {Rstr};
    case 'Both', DACstr = {Lstr Rstr 'Both'};
end

%&&&&&&&&
StartSPL = paramquery([Prefix 'StartSPL'], 'start:', '-10.5 -10.5', 'dB SPL', ...
    'rreal', ['Starting SPL of series.' PairStr], Nchan);
StepSPL = paramquery([Prefix 'StepSPL'], 'step:', '1.25 1.25', 'dB', ...
    'rreal/positive', 'SPL step of series.', Nchan);
EndSPL = paramquery('EndSPL', 'end:', '120.9 120.9', 'dB SPL', ...
    'rreal', ['Last SPL of series.' PairStr], Nchan);
AdjustSPL = paramquery([Prefix 'AdjustSPL'], 'adjust:', '', {'none' 'start' 'step' 'end'}, ...
    '', 'Choose which parameter to adjust when the stepsize does not exactly fit the start & end values.', 1,'Fontsiz', 8);
%&&&&&&&&

% ---SPL

DAC = paramquery([Prefix 'DAC'], 'DAC:', '', DACstr, ...
    '', ['Active D/A channels.' ClickStr 'channel(s).']);
MaxSPL=messenger([Prefix 'MaxSPL'], 'max [**** ****] dB SPL @ [***** *****] Hz    ',1);

Levels = GUIpanel('Levels', T);
Levels = add(Levels,StartSPL,'below');
Levels = add(Levels,StepSPL,alignedwith(StartSPL));
Levels = add(Levels,EndSPL, alignedwith(StepSPL));
Levels = add(Levels,DAC,nextto(StartSPL),[10 0]);
Levels = add(Levels,AdjustSPL,  nextto(StepSPL), [5 7]);
Levels = add(Levels,MaxSPL, below(EndSPL),[17 0]);
Levels = marginalize(Levels, [0 3]);




