function CorrSweep=CorrStepper(T, EXP, Prefix)
% CorrStepper - generic correlation stepper panel for stimulus GUIs.
%   PH=CorrStepper(Title, EXP) returns a GUIpanel F allowing the 
%   user to specify a series of linearly or arc-spaced correlations.  
%   The Guipanel PH has title Title. EXP is the experiment 
%   definition, from which the number of DAC channels used (1 or 2) is
%   determined.
%
%   The paramQuery objects contained in F are named: 
%        StartCorr: starting correlation value
%          EndCorr: end correlation value in Cycles
%        NcorrStep: # steps (equals # values-1)
%     CorrStepType: 'Linear' or 'Cosine'
%         CorrChan: Left or Right channel used for varying the correlation
%       
%
%   CorrStepper is a helper function for stimulus generators like 
%   stimdefNRHO.
% 
%   PH=CorrStepper(Title, ChanSpec, Prefix) prepends the string Prefix
%   to the paramQuery names, e.g. StartCorr -> ModStartCorr, etc.
%
%   Use EvalCorrStepper to read the values from the queries and to
%   compute the actual Corrs specified by the above step parameters.
%
%   See StimGUI, GUIpanel, EvalCorrStepper, stimdefNRHO.

if nargin<3, Prefix=''; end

% # DAC channels determines the allowed multiplicity of user-specied numbers
ClickStr = ' Click button to select ';

%==========Corr GUIpanel=====================
StartCorr = paramquery([Prefix 'StartCorr'], 'start:', '-0.5679 ', '', ...
    'rreal', ['Starting Corr of series.'], 1);
EndCorr = paramquery('EndCorr', 'end:', '-0.5679 ', '', ...
    'rreal', ['Last Corr of series.'], 1);
Nstep = paramquery([Prefix 'NcorrStep'], '# steps:', '25', '', ...
    'posint', '# steps in series.', 1);
Spacing = paramquery('CorrStepType', 'spacing:', '', {'linear' 'cosine'}, ...
    '', 'Spacing of correlation values. Linear means equal steps; cosine means spaced as cos(k*phi), k=0:Nstep.', 1);
VariedChan = paramquery([Prefix 'CorrChan'], 'varied:', '', {'ipsi' 'contra'}, ...
    '', 'Choose in which ear the stimulus Corr is varied. The other is kept fixed.', 1);

CorrSweep = GUIpanel('CorrSweep', T);
CorrSweep = add(CorrSweep, StartCorr);
CorrSweep = add(CorrSweep, EndCorr, alignedwith(StartCorr), [0 -5]);
CorrSweep = add(CorrSweep, Nstep, alignedwith(EndCorr), [20 -5]);
CorrSweep = add(CorrSweep, Spacing, alignedwith(Nstep), [0 -5]);
CorrSweep = add(CorrSweep, VariedChan, alignedwith(Spacing), [0 -5]);
%CorrSweep = marginalize(CorrSweep, [5 2]);





