function fixedOpenFig(f)
% fixedOpenFig - open fig file and correct bug in MatLab OPEN

% the following lines seem to fix a MatLab bug in OPEN which screws up the ...
% ... stacking order order of uicontrols when the figure's visibility was off during save

shh = get(0,'showhiddenhandles'); % or else, puldown menus will be permuted ...
set(0,'showhiddenhandles', 'on');
open(f);
figh = gcf;
set(figh,'children',get(figh,'children')); 
set(0,'showhiddenhandles', shh);

% make sure it does not fall off the screen
RepositionFig(figh);



