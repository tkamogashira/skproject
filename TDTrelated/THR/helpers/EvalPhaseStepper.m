function Phase=EvalPhaseStepper(figh, P, Prefix)
% EvalPhaseStepper - compute phase series from Phase stepper GUI
%   Phase=EvalPhaseStepper(figh, P) checks phase-stepper specs
%   in struct P (returned by GUIval ): StartPhase, StepPhase, EndPhase, 
%   AdjustPhase (see PhaseStepper), and converts
%   them to the individual phase of the phase-stepping series.
%   Any errors in the user-specified values results in an empty return 
%   value Phase, while an error message is displayed by GUImessage.
%
%   See StimGUI, FrequencyStepper.

if nargin<3, Prefix=''; end
Phase = []; % allow premature return

EXP = getGUIdata(figh,'Experiment');

% query names for param retrieval & error highlighting
Qnames = {[Prefix 'StartPhase'], [Prefix 'StepPhase'], [Prefix 'EndPhase'], [Prefix 'AdjustPhase']};
[StartPhase, Stepsize, EndPhase, Adjuster] = deal(P.(Qnames{1}), P.(Qnames{2}), P.(Qnames{3}), P.(Qnames{4}));

% delegate the computation to generic EvalStepper
StepMode = 'Linear';

[Phase, Mess]=EvalStepper(StartPhase, Stepsize, EndPhase, StepMode, ...
    Adjuster, [-inf inf], EXP.maxNcond); % +/- inf: no a priori limits imposed to phase values
if isequal('nofit', Mess),
    Mess = {'Stepsize does not exactly fit Phase bounds', ...
        'Adjust Phase parameters or toggle Adjust button.'};
elseif isequal('largestep', Mess)
    Mess = 'Step size exceeds Phase range';
elseif isequal('cripple', Mess)
    Mess = 'Different # Phase steps in the two DA channels';
elseif isequal('toomany', Mess)
    Mess = {['Too many (>' num2str(EXP.maxNcond) ') Phase steps.'] 'Increase stepsize or decrease range'};
end

GUImessage(figh,Mess, 'error', Qnames);




