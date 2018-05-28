function PRPresumechecking;
global PRPstatus StimMenuStatus

% resume earlier, interrupted, call to XXcheck
% that has been suspended by StimMenuWarn

hmess = messagehandle;
% set continue flag
set(hmess, 'userdata', 'continue');
% the next call will resume suspended StimMenuWarn
UIinfo('Checking parameters...');

