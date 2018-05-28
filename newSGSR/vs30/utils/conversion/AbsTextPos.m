function posReFig = AbsTextPos(posReAx, axh);
% ABSTEXTPOS - translates uicontrol position given re axes to one given re figure

% A rectangle within a recangle ..
axu = get(axh, 'units');
set(gca,'units', 'normalized');
apos = get(gca, 'position');
posReFig = apos(1:2)+posReAx.*apos(3:4); % scale and add


