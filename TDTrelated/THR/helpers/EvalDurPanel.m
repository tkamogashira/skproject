function [okay, P]=EvalDurPanel(figh, P, Ncond, Prefix, mISI)
% EvalDurPanel - evaluate Dur parameters from stimulus GUI
%   [Okay, P]=EvalDurPanel(figh, P, Ncond, Prefix, mISI) evaluates the Duration 
%   parameters obtained from the paramqueries created by DurPanel. The 
%   first output argument Okay is true unless durations and/or timing parameters 
%   are out of range or mutually inconsistent. The second output is
%   identical to the input struct P, except three new fields are added:
%   FineITD, GateITD, ModITD, which realize the expansion of the ITD and
%   ITDtype fields in P (see ITDparse). Input arguments are 
%
%      figh: handle to GUI, or stimulus context for non-interactive calls.
%         P: struct returned by GUIval(figh) containing GUI parameters 
%     Ncond: number of conditions (needed to report the total play time)
%    Prefix: prefix of Dur query names (see DurPanel). Defaults to ''.
%      mISI: mean inter-stimulus-interval in ms to be used in the
%            estimation and reporting of total play time. mISI defaults to
%            P.ISI, but may deviate from it due to warping (e.g. makeStimMask).
%   
%   If the GUI has a PlayTime messenger panel, EvalDurPanel also reports
%   the total play time to this messenger.
%
%   EvalDurPanel is a helper function for stimulus generators like 
%   makestimFS.
%   
%   See StimGUI, DurPanel, ReportPlayTime, makestimFS, ITDparse.

[Prefix, mISI] = arginDefaults('Prefix/mISI', '', P.ISI);
okay = 0; % pessimistic default

if isa(figh, 'experiment'), % non-interactive call - no GUI
    EXP = figh; 
    Interactive=false;
else,
    EXP = getGUIdata(figh,'Experiment');
    Interactive=true;
    ReportPlayTime(figh, nan); % reset PlayTime report
end
% get DurPanel params and ISI from P
P = dePrefix(P,Prefix);

% Check validity & consistency of params, report any error & highlight edits
anywrong = 1;
% parse ITD spec, if present
hasITD = isfield(P,'ITD');
if hasITD, [P.FineITD P.GateITD P.ModITD] = ITDparse(P.ITD, P.ITDtype); end
% combine onset delay + burstdur
Onset_Burst_dur = bsxfun(@plus, P.OnsetDelay, P.BurstDur);

if any(Onset_Burst_dur>P.ISI),
    GUImessage(figh,'OnsetDelay+Burst duration exceeds ISI.', ...
        'error', {[Prefix 'OnsetDelay'] [Prefix 'BurstDur'] 'ISI'});
elseif any(P.ISI<0.25),
    GUImessage(figh,'ISI must be at least 0.25 ms.', ...
        'error', 'ISI');
elseif hasITD && any(Onset_Burst_dur+abs(P.GateITD)>P.ISI),
    GUImessage(figh,'Sum of OnsetDelay, BurstDur & gated ITD exceeds ISI.', ...
        'error', {[Prefix 'OnsetDelay'] [Prefix 'BurstDur'] [Prefix 'ITD'] 'ISI'});
elseif any(Onset_Burst_dur>P.ISI),
    GUImessage(figh,'Sum of OnsetDelay, BurstDur exceeds ISI.', ...
        'error', {[Prefix 'OnsetDelay'] [Prefix 'BurstDur'] 'ISI'});
elseif any(P.BurstDur<P.RiseDur+P.FallDur),
    GUImessage(figh,'Sum of Rise & Fall durations exceeds BurstDur.', ...
        'error', {[Prefix 'BurstDur'] [Prefix 'RiseDur'] [Prefix 'FallDur']});
elseif prod(Ncond)>EXP.maxNcond,
    Mess = {['Too many (>' num2str(EXP.maxNcond) ') stimulus conditions.'],...
        'Increase stepsize(s) or decrease range(s)'};
    GUImessage(figh, Mess, 'error');
else, anywrong=0; % past all tests
end
if anywrong, return; end

if Interactive, % report playtime
    totBaseline = sum(samesize(P.Baseline,[1 1])); % sum of pre- & post-stim baselines
    Ttotal=ReportPlayTime(figh, Ncond, P.Nrep, mISI, totBaseline);
end

okay=1;


