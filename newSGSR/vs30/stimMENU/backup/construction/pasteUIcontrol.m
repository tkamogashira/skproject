function y = pasteUIcontrol(figh, controlName);

global VERSIONDIR
FN = [VERSIONDIR '\stimMenu\construction\' controlName '.mat'];
if ~exist(FN),
   error(['cannot find uicontrol file ' controlName]);
end
load(FN); % creates variable named 'uigroup'
pasteToFig(uigroup, figh);

