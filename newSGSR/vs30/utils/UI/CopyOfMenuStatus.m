function [MS, isStimMenu] = CopyOfMenuStatus(MenuName);

% returns copy of menustatus

% get name of global menu status
MSname = MenuStatusName(MenuName);
eval(['global ' MSname ';']);
eval(['MS = ' MSname ';']);
isStimMenu = isequal(MSname,'StimMenuStatus');