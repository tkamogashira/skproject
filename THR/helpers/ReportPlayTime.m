function [T, Tstr]=ReportPlayTime(figh, Ncond, Nrep, ISI, totBaseline);
% ReportPlayTime - compute total play time and report it to PlayTime panel 
%     T=ReportPlayTime(figh, Ncond, Nrep, ISI, totBaseline) computes total 
%     play time T (in seconds) from the number of conditions Ncond, the number of 
%     reps Nrep, the inter-stimulus-interval ISI (in ms) and the sum of
%     pre- and post-stimulus baselines, totBaseline. ReportPlayTime reports
%     T to the PlayTime messenger of the stimulus GUI having handle figh.
%
%     ReportPlayTime(figh, nan) resets the string of the PlayTime messenger 
%     to its TestLine value (see Messenger).
%
%     [T, Tstr]=ReportPlayTime(figh, ...) also returns the string
%     displayed in the PlayTime panel.
%
%   
%   See StimGUI, DurPanel, PlayTime, makestimFS, Messenger.

if nargin<3, [Nrep, ISI, totBaseline] = deal(nan); end % reset call, see help text

% compute and format
T = round(1e-3*(prod(Ncond)*Nrep*ISI+totBaseline)); % play time in s
Nmin = floor(T/60);
Nsec = rem(T,60);
if isnan(T),
    Tstr = 0; % results in TestLine, see Messenger/report
else,
    NcondStr = strrep(trimspace(num2str(Ncond)), ' ', ' x ');
    Tstr = ['Total play time: ' NcondStr ' x ' num2str(Nrep) ' x ' ...
        num2str(round(ISI)) ' ms  + baselines = ' num2str(Nmin) ' min ' dec2base(Nsec,10,2) ' s'];
end

% report
M = GUImessenger(figh, 'PlayTime');
report(M,Tstr);



