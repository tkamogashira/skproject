function OpenMenuForConstr(MenuName);

% OO - open XXXmenu.fig for construction

fname = [MenuName 'menu.fig']; % traditional: append "Menu" to name
if ~exist(fname), % try literal usage of name
   fname = [MenuName '.fig'];
else, end
fixedOpenFig(fname); 
set(gcf,'visible', 'on');
rget;
uilist;
