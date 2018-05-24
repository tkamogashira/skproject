function hFig_printprev = vqcopyaxes(hMainFig)
% COPY the axes of both the figures.
%   Copyright 1988-2003 The MathWorks, Inc.

hAxes = sigutils.copyAxes(hMainFig, @(hOld, hNew) lclCopyAxes(hMainFig, hNew));

hFig_printprev = ancestor(hAxes(1), 'figure');

% -------------------------------------------------------------------------
function hax = lclCopyAxes(hMainFig, hFig_printprev)

h = guidata(hMainFig);

hax1 = subplot(2,1,1);
haxc1 = copyobj(h.plotErrIter, hFig_printprev);
set(haxc1, 'units', get(hax1, 'units'), 'position', get(hax1, 'position'));
delete(hax1);

hax2 = subplot(2,1,2);
haxc2 = copyobj(h.plotEntropyIter, hFig_printprev);
set(haxc2, 'units', get(hax2, 'units'), 'position', get(hax2, 'position'));
delete(hax2);

hax = [haxc1 haxc2];

% [EOF]
