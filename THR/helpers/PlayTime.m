function P=PlayTime;
% PlayTime - panel displaying total Play time for stimulus GUIs.
%   P=PlayTime(...) returns a GUIpanel containing a messenger
%   for displaying the total stimulus duration in a format like
%       29 x 10 x 300 ms = 1 min 27
%   meaning 29 conditions, 10 reps, ISI=300 ms, resulting in a total
%   duration of 1 minute, 27 seconds. The actual reporting is done by
%   EvalPlayTime.
%
%   Use reportPlayTime to compute and report the actual play time.
%
%   PlayPanel is a helper function for stimulus definitions like stimdefFS.
%
%   See StimGUI, GUIpanel, ReportPlayTime, stimdefFS.


P = GUIpanel('PlayTimePanel', ''); % no title
M = messenger('PlayTime', ...
    'Total play time: ..... x ..... x ..... ms + baselines = ....min .... s   ', ...
    1, 'FontWeight', 'bold', 'ForegroundColor', [0 0.3 0.4]);
P = add(P, M, 'below', [0 -15]);








