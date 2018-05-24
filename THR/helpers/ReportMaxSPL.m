function ReportMaxSPL(figh, maxSPL, );
% SPLpanel - generic SPL and DAchannel panel for stimulus GUIs.
%   S=SPLpanel(Title, CT) returns a GUIpanel M named 'Levels' allowing the 
%   user to specify a fixed sinusiodal amplitude modulation to be applied 
%   to all the stimuli of a series. Guipanel S has title Title. CT is the 
%   stimulus context, from which the number of active DAC channels (1 or 2) 
%   is obtained. Title='-' results in standard title 'SPLs & active channels'
%
%   The paramQuery objects contained in S are
%         SPL: level of stimuli in dB SPL
%         DAC: active DA channel
%   The messenger contained in S is
%       MaxSPL: report of max attainable SPL (filled by MakeStimXXX)
%
%   SPLpanel is a helper function for stimulus definitions like stimdefFS.
% 
%   M=SPLpanel(Title, ChanSpec, Prefix) prepends the string Prefix
%   to the paramQuery and Messenger names, e.g. SPL -> NoiseSPL, etc.
%
%   Use ReportMaxSPL to update the MAX SPL messenger display.
%
%   See StimGUI, GUIpanel, ReportMaxSPL, stimdefFS.

% # DAC channels fixes the allowed multiplicity of user-specied numbers

if nargin<3, Prefix=''; end

if isequal('-',T), T = 'SPLs & active channels'; end

if nchan(CT)==2, PairStr = ' Pairs of numbers are interpreted as [left right].';
else, PairStr = ''; 
end
ClickStr = ' Click button to select ';

% ---SPL
Levels = GUIpanel('Levels', T);
SPL = paramquery([Prefix 'SPL'], ...
    'frequency:', '102.5 101.2', 'dB SPL', 'rreal', ...
    ['Sound pressure level.' PairStr], nchan(CT));
switch CT.recSide,
    case 'Left', Lstr = 'Left=Ipsi'; Rstr = 'Right=Contra';
    case 'Right', Lstr = 'Left=Contra'; Rstr = 'Right=Ipsi';
end
switch CT.DAC,
    case 'Left', DACstr = {Lstr};
    case 'Right', DACstr = {Rstr};
    case 'Both', DACstr = {Lstr Rstr 'Both'};
end
DAC = paramquery([Prefix 'DAC'], 'DAC:', '', DACstr, ...
    '', ['Active D/A channels.' ClickStr 'channel(s).']);
SPL = paramquery([Prefix 'SPL'], 'levels:', '120.5 120.5', 'dB SPL', ...
    'rreal', ['Carrier SPL.' PairStr],2);
MaxSPL=messenger([Prefix 'MaxSPL'], 'max [**** ****] dB SPL @ [***** *****] Hz    ',1);
Levels = add(Levels,SPL,'below');
Levels = add(Levels,DAC,'nextto',[15 0]);
Levels = add(Levels,MaxSPL,'below SPL',[0 0]);
Levels = marginalize(Levels, [0 3]);




