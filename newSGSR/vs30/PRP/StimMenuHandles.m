function sh = StimMenuHandles;
% StimMenuHandles, returns handles of stimmenu in struct
%  returns [] if no stimmenu is active
%  See also PRPhandles, StimMenuActive.

if ~StimMenuActive,
   sh = [];
   return;
end

global StimMenuStatus
sh = StimMenuStatus.handles;