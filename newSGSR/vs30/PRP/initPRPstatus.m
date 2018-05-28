function initPRPstatus(Prefix);

% initialize PRPstatus
% global PRPstatus is the info that can be modified 
% by various PRP functions
% PRPstatus variable holds the current status of Play/Record/Plot actions.

if nargin<1, Prefix = 'XX'; end;

clear global PRPstatus % delete previous versions
global PRPstatus
PRPstatus.prefix = Prefix;

% DAMA buffers to be deleted befor next D/A conversion
PRPstatus.deleteDBNs = [];

% interrupt status
PRPstatus.interrupt = 0;
PRPstatus.interruptRec = 0; % set to number of interrupted sequence...
% ... if interruption takes place during recording
% defaults for other status stuff
PRPstatus.DoRecord = 0; % is set PRPplay
PRPstatus.SpikesStored = 0; % internal storage of action potentials
PRPstatus.SpikesSaved = 0; % disk storage of action potentials
PRPstatus.Checking = 0; % There is no interrupted stimMenuCheck

% initial PRP pushbuttons status
PRPsetButtons('waiting');


