function InitSGSRmainMenu;

global SGSRmainMenuStatus SGSRDIR;
SGSRmainMenuStatus = [];

more off;

% open menu from file
hh = openUImenu('SGSRmain');
% uicontrol/property pairs whose values should
% be remembered next time upon opening the menu
DeclareMenuDefaults('SGSRmain', 'Root:position');
% update header
HeaderString = ['SGSR version ' currentVersion];
set(hh.Root,'name',HeaderString);
% show log
addToLog('setLogHandle', hh.LogText); % this updates log text
% report current session info
[Sstr SI]= sessionInfoString('SGSRmainMenu');
% SI tells if session has been initialized; activate ..
% .. stimulusMenu buttons & prompts accordingly
enableUIgroup('Stim',SI,SGSRmainMenuStatus.handles.Root);

if ~inLeuven & ~inUtrecht, % remove european options options 
   % delete(hh.StimTHRbutton);
   % delete(hh.StimTHRmenuItem);
   try,
      delete(hh.StimARMINbutton);
      delete(hh.StimARMINmenuItem);
      delete(hh.StimBNbutton);
      delete(hh.StimBNmenuItem);
      delete(hh.StimBERTbutton);
      delete(hh.StimBERTmenuItem);
      delete(hh.StimPSbutton);
   end
end

if ~TDTpresent, % disable any stimulus-related stuff
   set(hh.NewSessionButton, 'enable', 'off');
   set(hh.PRLmenuItem, 'enable', 'off');
end

SGSRmainMenuStatus.OK = 0;


