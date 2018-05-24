function Pres=PresentationPanel_XY(Xname, Yname);
% PresentationPanel_XY - stimGUI presentation panel for two varied params
%   P = PresentationPanel_XY(X,Y) returns a GUIpanel M allowing 
%   the user to specify the parameters that determine the mode of 
%   presentation of the stimulus conditions and their repetitions in the 
%   case of two varied parameters with names X and Y. These names are only
%   used for display purposes.
%   The paramQuery objects contained in P
%   are 
%             ISI: onset-to-onset inter-stimulus interval in ms
%            Nrep: number of reps of each condition
%      SlowestVar: toggle button identifying the "slowest stepping" variable,
%                  which may be the rep count, X, Y, X-Y combined or none.
%     NextSlowVar: toggle button identifying the "next-slowest stepping" 
%                  variable, which may be the rep count, X, Y, or X-Y combined.
%      FastestVar: toggle button identifying the "fastest stepping" variable,
%                  which may be the rep count, X, Y, or X-Y combined.
%          Xorder: toggle specifying order of visiting X values. The options
%                  are
%                    Forward: from Start to End; all reps together
%                    Reverse: from End to Start; all reps together
%                    Random: fixed random order of conditions, i.e. when te
%                       next rep is there, the X values will be visited using
%                       the same random order.
%                    Scrambled: running random order, i.e., when the next rep
%                       is there, a new random order is used.
%                  Note that the contrast between Random and Scrambled is
%                  only meaningful when X is moving faster than the rep
%                  count. Note also that it is only meaningful to use "X-Y
%                  combined" for one the step speed options if both X and Y
%                  are randomized, in which case the X-Y plane is visited in
%                  a completely random fashion.
%          Yorder: idem for Y values.
%
%   PresentationPanel_XY is a helper function for stimulus definitions like stimdefRF.
% 
%   See StimGUI, DurPanel, stimdefRC, EvalPresentationPanel_XY.

SpeedOptions = {'Rep' Xname Yname [Xname '+' Yname] '-'}; % options for speed buttons
SpeedTooltip = ['Identify the XXXXX stepping parameter. "Rep" is the repetition count.' char(10) ...
    '"' SpeedOptions{4} '" means that ' Xname ' and ' Yname ' are varied together.'];
% ---Queries
ISI = paramquery('ISI', 'ISI:', '15000', 'ms', ...
    'rreal/positive', 'Onset-to-onset interval between consecutive stimuli of a series.',1);
Nrep = paramquery('Nrep', '#Reps:', '1500', '', ...
    'rreal/posint', 'Number of repetitions of each condition.',1);
Slowest = paramquery('Slowest', 'Update ', '', SpeedOptions, '', strrep(SpeedTooltip, 'XXXXX', 'slowest'), 1);
Nextslow = paramquery('Nextslow', '', '', SpeedOptions, '', strrep(SpeedTooltip, 'XXXXX', '2nd slowest'), 1);
Fastest = paramquery('Fastest', '', '', SpeedOptions, '', strrep(SpeedTooltip, 'XXXXX', 'fastest'), 1);
Xorder = paramquery('Xorder', [Xname ' order:'], '', {'Forward' 'Reverse' 'Random' 'Scrambled'}, ...
    '', ['Step order of ' Xname '. Forward means from Start to End value.' char(10) ...
    'Reverse means from End to Start. Random means conditions randomized (fixed random order).' char(10), ...
    'Scrambled is similar to Random, but a new randomization is used for each rep.'],1);
Yorder = paramquery('Yorder', [Yname ':'], '', {'Forward' 'Reverse' 'Random' 'Scrambled'}, ...
    '', ['Step order of ' Yname '. Forward means from Start to End value.' char(10) ...
    'Reverse means from End to Start. Random means conditions randomized (fixed random order).' char(10), ...
    'Scrambled is similar to Random, but a new randomization is used for each rep.'],1);
RSeed = paramquery('RSeed', 'Rand Seed:', '844596300', '', ...
    'rseed', 'Random seed used for presentation order. Specify NaN to refresh seed upon each realization.',1);
Baseline = paramquery('Baseline', 'Baseline:', '12000 12000 ', 'ms', ...
    'rreal/nonnegative', 'Duration of pre- and poststimulus baseline recording. Pairs are interpreted as [pre post].',2);
% two invisible queries to store Xname and Yname
TellXname = paramquery('Xname', '', '', {Xname},'', '', 1, 'visible', 'off');
TellYname = paramquery('Yname', '', '', {Yname},'', '', 1, 'visible', 'off');

% add to panel
Pres = GUIpanel('Pres', 'presentation');
Pres = add(Pres, ISI,'below',[5 0]);
Pres = add(Pres,Baseline,nextto(ISI), [10 0]);
Pres = add(Pres, Nrep, below(ISI), [0 -5]);
Pres = add(Pres,RSeed, nextto(Nrep), [0 0]);

Pres = add(Pres,Slowest, below(Nrep), [0 -5]);
Pres = add(Pres,Nextslow, 'nextto', [0 0]);
Pres = add(Pres,Fastest, 'nextto', [0 0]);
Pres = add(Pres,Xorder, below(Slowest), [5 -10]);
Pres = add(Pres,Yorder, 'nextto', [0 0]);

Pres = add(Pres,TellXname, 'nextto', [-60 0]);
Pres = add(Pres,TellYname, 'nextto', [-60 0]);












