function Corr=EvalCorrStepper(figh, P, Prefix)
% EvalCorrStepper - compute Corr series from CorrStepper GUIpanel
%   Corr=EvalCorrStepper(figh, P) checks Corr-stepper specs
%   in struct P (returned by GUIval ): StartCorr, EndCorr, Ncorr,
%   CorrStepType (see CorrStepper), and converts
%   them to the individual Corr of the Corr-stepping series.
%   Any errors in the user-specified values results in an empty return 
%   value Corr, while an error message is displayed by GUImessage.
%
%   Corr=EvalCorrStepper(figh, P, Prefix) prepends Prefix to the names of
%   the parameters listed above.
%
%   See StimGUI, FrequencyStepper.

if nargin<3, Prefix=''; end
Corr = []; % allow premature return

EXP = getGUIdata(figh,'Experiment');

% query names for param retrieval & error highlighting
Qnames = {[Prefix 'StartCorr'], [Prefix 'NcorrStep'], [Prefix 'EndCorr'], [Prefix 'CorrStepType']};
[StartCorr, Nstep, EndCorr, StepType] = deal(P.(Qnames{1}), P.(Qnames{2}), P.(Qnames{3}), P.(Qnames{4}));

% elementary checks
if abs(StartCorr)>1,
    GUImessage(figh, 'Start correlation exceeds bounds [-1 1].', 'error', Qnames(1));
    return;
elseif abs(EndCorr)>1,
    GUImessage(figh, 'End correlation exceeds bounds [-1 1].', 'error', Qnames(3));
    return;
end

iscos = isequal('cosine', StepType);
if iscos,
    StartCorr = acos(StartCorr);
    EndCorr = acos(EndCorr);
end
% correlation values in column array
Corr = linspace(StartCorr, EndCorr, Nstep+1).';
if iscos,
    Corr = cos(Corr);
end


