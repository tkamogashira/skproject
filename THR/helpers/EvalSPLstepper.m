function SPL=EvalSPLstepper(figh, Prefix, P)
% EvalSPLstepper - compute SPL series from SPL stepper GUI
%   SPL = EvalSPLstepper(figh) reads SPL-stepper specs
%   from paramqueries StartSPL, StepSPL, EndSPL, ad AdjustSPL
%   in the GUI figure with handle figh (see SPLstepper), and converts
%   them to the individual SPLs of the SPL-stepping series.
%   Any errors in the user-specified values results in an empty return 
%   value SPL, while an error message is displayed by GUImessage.
%
%   EvalSPLStepper(figh, 'Foo') uses prefix Foo for the query names,
%   i.e., FooStartSPL, etc. The prefix defaults to ''.
%
%   EvalSPLStepper(figh, Prefix, P) does not read the queries, but
%   extracts them from struct P which was previously returned by GUIval.
%   This is the preferred use of EvalSPLStepper, because it leaves
%   the task of reading the parameters to the generic GUIval function. The
%   first input arg figh is still needed for error reporting.
%
%   See StimGUI, SPLstepper, makestimRF.

if nargin<2, Prefix=''; end
if nargin<3, P = []; end
SPL = []; % allow premature return

if isempty(P), % obtain info from GUI. Non-preferred method; see help text.
    EXP = getGUIdata(figh,'Experiment');
    Q = getGUIdata(figh,'Query');
    StartSPL = read(Q([Prefix 'StartSPL']));
    StepSPL = read(Q([Prefix 'StepSPL']));
    EndSPL = read(Q([Prefix 'EndSPL']));
    AdjustSPL = read(Q([Prefix 'AdjustSPL']));
    P = collectInstruct(StartSPL, StepSPL, StepFreqUnit, EndFreq, AdjustFreq);
else,
    P = dePrefix(P, Prefix);
    EXP = P.Experiment;
end

% delegate the computation to generic EvalStepper
StepMode = 'Linear'; % in dB ;-)

[SPL, Mess]=EvalStepper(P.StartSPL, P.StepSPL, P.EndSPL, StepMode, ...
    P.AdjustSPL, [-inf inf], EXP.maxNcond);
if isequal('nofit', Mess),
    Mess = {'Stepsize does not exactly fit SPL bounds', ...
        'Adjust SPL parameters or toggle Adjust button.'};
elseif isequal('largestep', Mess),
    Mess = 'Step size exceeds SPL range';
elseif isequal('cripple', Mess),
    Mess = 'Different # SPL steps in the two DA channels';
elseif isequal('toomany', Mess),
    Mess = {['Too many (>' num2str(EXP.maxNcond) ') SPL steps.'] 'Increase stepsize or decrease range'};
end
GUImessage(figh,Mess, 'error',{[Prefix 'StartSPL'] [Prefix 'StepSPL'] [Prefix 'EndSPL'] });




