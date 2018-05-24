function P=ITDstepper(T, EXP, Prefix, haveTypes);
% ITDstepper - generic ITD stepper panel for stimulus GUIs.
%   F=ITDstepper(Title, EXP) returns a GUIpanel F allowing the 
%   user to specify a series of ITDs, using a linear spacing.  
%   The Guipanel F has title Title. EXP is the experiment 
%   definition, from which the number of DAC channels used (1 or 2) is
%   determined.
%
%   The paramQuery objects contained in F are named: 
%         StartITD: starting frequency in Hz
%     StepITD: step in Hz or Octaves (toggle unit)
%      EndITD: end frequency in Hz
%        AdjustITD: toggle selecting which of the above params to adjust
%                    in case StepFrequency does not fit exactly.
%   ITDStepper is a helper function for stimulus definers like 
%   stimdefBINZW.
% 
%   F=ITDstepper(Title, Exp, Prefix) prepends the string Prefix
%   to the paramQuery names, e.g. StartFreq -> ModStartFreq, etc.
%
%  ITDstepper(Title, Exp, Prefix, haveTypes) specifies whether to allow
%  different types of ITD (ongoing, total waveform, etc). 
%  The default is haveTypes = false.
%
%   Use EvalITDstepper to read the values from the queries and to
%   compute the actual frequencies specified by the above step parameters.
%
%   See StimGUI, GUIpanel, EvalFrequencyStepper, makestimFS.

[Prefix, haveTypes] = arginDefaults('Prefix, haveTypes', '', false);

ClickStr = ' Click button to select ';
ITDstr = ['(positive = ' upper(strrep(EXP.ITDconvention, 'Lead', ' Lead')) ')'];

%==========ITD GUIpanel=====================
P = GUIpanel('ITD', T);
ITDpref = preferences(EXP, 'ITDconvention');
startITD = paramquery('startITD', 'start:', '-10.170', 'ms', 'rreal', ['Start value of ITD ' ITDstr], 1);
endITD = paramquery('endITD', 'end:', '-10.170', 'ms', 'rreal', ['End value of ITD ' ITDstr], 1);
stepITD = paramquery('stepITD', 'step:', '0.170', 'ms', 'rreal/positive', 'Step value of ITD ', 1);
adjustITD = paramquery([Prefix 'AdjustITD'], 'adjust:', '', {'none' 'start' 'step' 'end'}, ...
    '', ['Choose which parameter to adjust when the stepsize does not exactly fit the start & end values.'], 1,'Fontsiz', 8);
ITDtype = paramquery([Prefix 'ITDtype'], 'impose on', '', {'waveform' 'fine' 'gate' 'mod' 'fine+gate' 'fine+mode' 'gate+mod'}, '', ...
    ['Implementation of ITD. Click to toggle between options.' char(10) ...
    '    waveform = whole waveform delay' char(10) ...
    '      gating = delayed gating imposed on nondelayed waveform' char(10)  ...
    '     ongoing = nondelayed gating imposed on delayed waveform.' ]);

P = add(P, startITD, 'below', [0 0]);
P = add(P, stepITD, alignedwith(startITD));
P = add(P, endITD, alignedwith(stepITD));
P = add(P, adjustITD, nextto(stepITD));
if haveTypes,
    P = add(P, ITDtype, below(endITD));
end



% P = GUIpanel('Fsweep', T);
% StartFreq = paramquery([Prefix 'StartFreq'], 'start:', '15000.5 15000.5', 'Hz', ...
%     'rreal/positive', ['Starting frequency of series.' PairStr], Nchan);
% StepFreq = paramquery([Prefix 'StepFreq'], 'step:', '12000', {'Hz' 'Octave'}, ...
%     'rreal/positive', ['Frequency step of series.' ClickStr 'step units.'], Nchan);
% EndFreq = paramquery('EndFreq', 'end:', '12000.1 12000.1', 'Hz', ...
%     'rreal/positive', ['Last frequency of series.' PairStr], Nchan);
% AdjustFreq = paramquery([Prefix 'AdjustFreq'], 'adjust:', '', {'none' 'start' 'step' 'end'}, ...
%     '', ['Choose which parameter to adjust when the stepsize does not exactly fit the start & end values.'], 1,'Fontsiz', 8);
% Tol = paramquery([Prefix 'FreqTolMode'], 'acuity:', '', {'economic' 'exact'}, '', [ ...
%     'Exact: no rounding applied;', char(10), 'Economic: allow slight (<1 part per 1000), memory-saving rounding of frequencies;'], ...
%     1, 'Fontsiz', 8);
% Fsweep = add(Fsweep, StartFreq);
% Fsweep = add(Fsweep, StepFreq, alignedwith(StartFreq));
% Fsweep = add(Fsweep, EndFreq, alignedwith(StepFreq));
% Fsweep = add(Fsweep, AdjustFreq, nextto(StepFreq), [10 0]);
% if ~isequal('notol', Flag),
%     Fsweep = add(Fsweep, Tol, alignedwith(AdjustFreq) , [0 -10]);
% end




