function MenuDefaults = SaveMenuDefaults(MenuName, DefFile, CurrentDisplay);
% SaveMenuDefaults - 
%   usage: MenuDefaults = SaveMenuDefaults(MenuName, DefFile, CurrentDisplay);
%   DefFile is optional - if present, must be full path
%   if there is an outarg, it equals the menudefaults struct that 
%   is saved in file. If DefFile is empty, nothing is saved

if nargin<1, 
   global PRPstatus
   MenuName = PRPstatus.prefix;
end;
if nargin<2, 
   DefFile = ''; 
end;

[MS isStimMenu] = CopyOfMenuStatus(MenuName);

if nargin<3, CurrentDisplay=~isStimMenu; end;
if isempty(MS), return; end;

if CurrentDisplay, % grab currently displayed values, regardless of their validity
   MenuDefaults = CollectMenuDefaultValues(MenuName); 
else,
   MenuDefaults = MS.defaults; % what is stored is NOT the current set of values, but ...
   % ... rather the most recently checked set (see stimMenuCheck)
end

% remove entries with empty value fields ..
iemval = [];
for ii=1:length(MenuDefaults), 
   if isempty(MenuDefaults(ii).value), iemval=[iemval, ii]; end; 
end
if ~isempty(iemval), MenuDefaults(iemval)=[]; end;

if isempty(MenuDefaults), return; end;

% save to disk
if isempty(DefFile), 
   DefFile = MS.defFile; 
end
if ~isempty(DefFile),
   save(DefFile, 'MenuDefaults', '-mat');
end

