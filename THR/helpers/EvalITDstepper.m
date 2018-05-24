function ITD=EvalITDstepper(figh, P, Prefix)
% EvalITDstepper - compute ITD series from ITD stepper GUI
%   ITD=EvalITDstepper(figh, P) checks ITD-stepper specs
%   in struct P (returned by GUIval ): StartITD, StepITD, EndITD, 
%   AdjustITD (see ITDstepper), and converts
%   them to the individual ITDs of the ITD-stepping series.
%   Any errors in the user-specified values results in an empty return 
%   value ITD, while an error message is displayed by GUImessage.
%
%   See StimGUI, ITDstepper.

if nargin<3, Prefix=''; end
Phase = []; % allow premature return

EXP = getGUIdata(figh,'Experiment');

% query names for param retrieval & error highlighting
Qnames = {[Prefix 'startITD'], [Prefix 'stepITD'], [Prefix 'endITD'], [Prefix 'AdjustITD']};
[StartITD, Stepsize, EndITD, Adjuster] = deal(P.(Qnames{1}), P.(Qnames{2}), P.(Qnames{3}), P.(Qnames{4}));

% delegate the computation to generic EvalStepper
StepMode = 'Linear';

[ITD, Mess]=EvalStepper(StartITD, Stepsize, EndITD, StepMode, ...
    Adjuster, [-inf inf], EXP.maxNcond); % +/- inf: no a priori limits imposed to phase values
if isequal('nofit', Mess),
    Mess = {'Stepsize does not exactly fit ITD bounds', ...
        'Adjust ITD parameters or toggle Adjust button.'};
elseif isequal('largestep', Mess)
    Mess = 'Step size exceeds ITD range';
elseif isequal('toomany', Mess)
    Mess = {['Too many (>' num2str(EXP.maxNcond) ') ITD steps.'] 'Increase stepsize or decrease range'};
end

GUImessage(figh,Mess, 'error', Qnames);




