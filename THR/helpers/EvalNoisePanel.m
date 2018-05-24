function [okay, RandSeed] = EvalNoisePanel(figh, P, Prefix)
% EvalNoisePanel - evaluate SAM parameters from stimulus GUI
%   [okay, Seed] = EvalSAMpanel(figh, P, Prefix) evaluates the parameters obtained 
%   from the paramqueries created by NoisePanel.
%   EvalSAMpanel tests if the SAM parameter values from the SAM panel
%   are within range, that is, if all sidebands are within the frequency 
%   bounds dictated by the stimulus context of the GUI. Input parameters:
%      figh: handle to GUI, or stimulus context for non-interactive calls.
%         P: struct returned by GUIval(figh) containing GUI parameters 
%    Prefix: prefix of Noise query names (see NoisePanel). Defaults to ''.
%
%   Seed is a copy of the NoiseSeed from P or a new, clockbased seed
%   replacing a NaN value in P (see SetRandState).
%   If anything goes wrong, opkay==false.
%
%   EvalNoisePanel is a helper function for stimulus generators like 
%   makestimFS.
%   
%   See StimGUI, SAMpanel, makestimFS.

Prefix = arginDefaults('Prefix', ''); 
okay = 0; % pessimistic default

if isa(figh, 'experiment'), % non-interactive call - no GUI
    EXP = figh; 
    Interactive=false;
else,
    EXP = getGUIdata(figh,'Experiment');
    Interactive=true;
end
P = dePrefix(P,Prefix);

% replace any NaN-valued rand seed
RandSeed = SetRandState(P.NoiseSeed);

% check if stimulus frequencies are within stimFreqRange(EXP) and corr is OK
somethingwrong=1;
cutoff = [P.LowFreq P.HighFreq];
FQnames = {[Prefix 'LowFreq']  [Prefix 'HighFreq']};
if diff(cutoff)<=0,
    GUImessage(figh, {'Lower cutoff must be', 'smaller than higher cutoff'}, 'error', FQnames);
elseif cutoff(1)<EXP.minStimFreq,
    GUImessage(figh, {'Lower cutoff violates minimum stim freq'...
        ['of ' num2str(EXP.minStimFreq) ' Hz']},'error', FQnames{1});
elseif cutoff(2)>EXP.maxStimFreq,
    GUImessage(figh, {'Upper cutoff exceeds max stim frequency'...
        ['of ' num2str(EXP.maxStimFreq) ' Hz']},'error', FQnames);
elseif abs(P.Corr)>1,
    GUImessage(figh, 'Interaural correlation must lie between -1 and 1.', ...
        'error', 'Corr');
else, % passed all the tests..
    somethingwrong=0;
end
if somethingwrong, return; end

okay=1;





