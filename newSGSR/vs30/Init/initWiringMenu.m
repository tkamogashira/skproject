function y=initWiringMenu;

global WiringMenuStatus SGSRDIR;
WiringMenuStatus = [];

% open menu from file
hh = openUImenu('Wiring');
% refresh info
[Wtext WtextPanes] = wiringtext;
setstring(hh.headerText,WtextPanes.header);
setstring(hh.conn1,WtextPanes.conn1);
setstring(hh.conn2,WtextPanes.conn2);
setstring(hh.conn3,WtextPanes.conn3);
setstring(hh.conn4,WtextPanes.conn4);
% wait until menu is closed and remove global menustatus
uiwait(hh.Root);
clear global WiringMenuStatus;



