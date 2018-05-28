function sp=SynchedPlayer;
global PRPinstr
if isfield(PRPinstr, 'synchedPlayer'),
   sp = PRPinstr.synchedPlayer;
else, % default player
   sp = 'playRec';
end
