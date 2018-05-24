function allPanels(cmd);
% allPanels - apply command to all panels of gcf
%   Example
%   allPanels('xlim([0, 1])');

h = findobj(gcf, 'type', 'axes');
for ii=1:length(h),
   axes(h(ii))   ;
   eval(cmd);
end



