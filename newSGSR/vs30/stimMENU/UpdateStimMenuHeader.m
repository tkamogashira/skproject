function UpdateStimMenuHeader;

% updates header and recordingside info of stimulus menus

global StimMenuStatus

MenuName = StimMenuStatus.MenuName;
figh = StimMenuStatus.handles.Root;

[fp fname] = fileparts(dataFile);
if isempty(fname), fname = '??'; end

Name = [MenuName ' Menu --- File: ' upper(fname) ' --- Next seq: ' SeqIndex];
set(figh, 'name',Name);

RSh = StimMenuStatus.handles.ContraChanInfo;
if ishandle(RSh),
   RS = channelChar(ipsiside,1);
   setstring(RSh, ['Rec side: ' RS]);
end
