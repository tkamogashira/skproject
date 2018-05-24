function okay=EvalSAMpanel(figh, P, Fcar, FQnames, Prefix)
% EvalSAMpanel - evaluate SAM parameters from stimulus GUI
%   okay=EvalSAMpanel(figh, P, Fcar, FQnames, Prefix) evaluates the 
%   SAM parameters obtained from the paramqueries created by SAMpanel.
%   EvalSAMpanel tests if the SAM parameter values from the SAM panel
%   are within range, that is, if all sidebands are within the frequency 
%   bounds dictated by the stimulus context of the GUI. Input parameters:
%      figh: handle to GUI, or stimulus context for non-interactive calls.
%         P: struct returned by GUIval(figh) containing GUI parameters 
%      Fcar: frequencies or frequency bounds of unmodulated carrier.
%   FQnames: cellstr containing names of queries determining Fcar. Needed 
%            for highlighting in case of out-of-range errors. Defaults to {}.
%    Prefix: prefix of SAM query names (see SAMpanel). Defaults to ''.
%
%   EvalSAMpanel is a helper function for stimulus generators like 
%   makestimFS.
%   
%   See StimGUI, SAMpanel, makestimFS.

if nargin<4, FQnames={}; end
if nargin<5, Prefix=''; end
okay = 0; % pessimistic default

if isa(figh, 'experiment'), % non-interactive call - no GUI
    EXP = figh; 
    Interactive=false;
else,
    EXP = getGUIdata(figh,'Experiment');
    Interactive=true;
end
P = dePrefix(P,Prefix);
% get mod frequency from P & compute freqs of sidebands
[Fcar, ModFreq, ModDepth] = samesize(Fcar, P.ModFreq, P.ModDepth);
ModFreq = ModFreq.*(ModDepth~=0); % set ModFreq to zero if ModDepth vanishes
Flo = Fcar-ModFreq;
Fhi = Fcar+ModFreq;
if isfield(P,'ModTheta'),
    Theta = P.ModTheta;
else,
    Theta = 0;
end

% paramquery names for highlighting
FQnames = [FQnames, [Prefix 'ModFreq']];

% check if stimulus frequencies are within stimFreqRange(EXP)
somethingwrong=1;
if any(Flo(:)<EXP.minStimFreq),
    GUImessage(figh, {'Lower sideband violates min stim frequency'...
        ['of ' num2str(EXP.minStimFreq) ' Hz']},'error', FQnames);
elseif any(Fhi(:)>EXP.maxStimFreq),
    GUImessage(figh, {'Upper sideband exceeds max stim frequency'...
        ['of ' num2str(EXP.maxStimFreq) ' Hz']},'error', FQnames);
elseif any(abs(Theta)>0.25),
    GUImessage(figh, 'Absolute value of Theta may not exceed 0.25 Cycle', ...
        'error', [Prefix 'ModTheta']);
else, % passed all the tests..
    somethingwrong=0;
end
if somethingwrong, return; end

okay=1;





