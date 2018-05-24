function PhaseSweep=PhaseStepper(T, EXP, Prefix)
% PhaseStepper - generic phase stepper panel for stimulus GUIs.
%   PH=PhaseStepper(Title, EXP) returns a GUIpanel F allowing the 
%   user to specify a series of linearly spaced phases.  
%   The Guipanel PH has title Title. EXP is the experiment 
%   definition, from which the number of DAC channels used (1 or 2) is
%   determined.
%
%   The paramQuery objects contained in F are named: 
%        StartPhase: starting phase in Cycles
%         StepPhase: step in Cycles
%          EndPhase: end phase in Cycles
%       AdjustPhase: toggle selecting which of the above params to adjust
%                    in case StepPhase does not fit exactly.
%
%   PhaseStepper is a helper function for stimulus generators like 
%   stimdefNPHI.
% 
%   PH=PhaseStepper(Title, ChanSpec, Prefix) prepends the string Prefix
%   to the paramQuery names, e.g. StartPhase -> ModStartPhase, etc.
%
%   Use EvalPhaseStepper to read the values from the queries and to
%   compute the actual phases specified by the above step parameters.
%
%   See StimGUI, GUIpanel, EvalPhaseStepper, stimdefNPHI.

if nargin<3, Prefix=''; end

% # DAC channels determines the allowed multiplicity of user-specied numbers
if isequal('Both', EXP.AudioChannelsUsed), 
    Nchan = 2;
    PairStr = ' Pairs of numbers are interpreted as [left right].';
else, % single Audio channel
    Nchan = 1;
    PairStr = ''; 
end
ClickStr = ' Click button to select ';

%==========phase GUIpanel=====================
StartPhase = paramquery([Prefix 'StartPhase'], 'start:', '-0.5679 ', 'Cycle', ...
    'rreal', ['Starting phase of series.' PairStr], 1);
StepPhase = paramquery([Prefix 'StepPhase'], 'step:', '0.0001', 'Cycle', ...
    'rreal/positive', 'Phase step of series.', 1);
EndPhase = paramquery('EndPhase', 'end:', '-0.5679 ', 'Cycle', ...
    'rreal', ['Last phase of series.' PairStr], 1);
AdjustPhase = paramquery([Prefix 'AdjustPhase'], 'adjust:', '', {'none' 'start' 'step' 'end'}, ...
    '', 'Choose which parameter to adjust when the stepsize does not exactly fit the start & end values.', 1,'Fontsiz', 8);
VariedChan = paramquery([Prefix 'VariedChan'], 'varied:', '', {'ipsi' 'contra'}, ...
    '', 'Choose in which ear the stimulus phase is varied. The other is kept fixed.', 1);

PhaseSweep = GUIpanel('PhaseSweep', T);
PhaseSweep = add(PhaseSweep, StartPhase);
PhaseSweep = add(PhaseSweep, StepPhase, alignedwith(StartPhase), [0 -5]);
PhaseSweep = add(PhaseSweep, EndPhase, alignedwith(StepPhase), [0 -5]);
PhaseSweep = add(PhaseSweep, AdjustPhase, nextto(StepPhase), [10 -5]);
PhaseSweep = add(PhaseSweep, VariedChan, alignedwith(EndPhase), [90 -15]);





