function y=loadPlayList(PLAYinstr);

% loadPlaylist - loads playList into common playList dama buffer for D/A
% PLAYinstr is single element of PLAY field of PRPinstruction generated 
% by playinstr

playList = PLAYinstr.playList;
% Determine the odd entries that contain negative numbers.
dummy = playList; dummy(:,2:2:end) = 0; % set even entries to 0
SLentries = find(dummy<0);
if ~isempty(SLentries), % some signals are not yet in DAMA; get them there
   global PRPstatus SampleLib
   % first deallocate previous DAMA buffers
   for dbn=PRPstatus.deleteDBNs(:)', s232('deallot', dbn); end;
   % now visit negative entries and allocate DAMA buffer if new
   BookKeeping = [0 0]; % will contain two columns. 1st column...
   % .. contains sampleLib indices, 2nd column  contains 
   % ...corresponding DAMA Buffer Numbers
   for iEntry = SLentries(:)',
      SLindex = -playList(iEntry);
      identicals = find(BookKeeping(:,1)==SLindex);
      if isempty(identicals), 
         % this SLindex has not been encountered before
         % allocate new DBN for it and push samples to DAMA
         DBN = ml2dama(SampleLib.cell{SLindex});
      else,
         % this SLindex is identical to one just encountered
         % DBN is identical to the one created at that time
         DBN = BookKeeping(identicals(1),2);
      end
      % set playListEntry to correct DBN
      playList(iEntry) = DBN;
      % update BookKeeping
      BookKeeping = [BookKeeping; SLindex DBN];
   end % for iEntry
   % finally mark DNBs for deletion upon next D/A call
   BookKeeping(1,:) = []; % remove dummy zeros
   PRPstatus.deleteDBNs = unique(BookKeeping(:,2)');
end

% dump playlist in playlistDBN(s)
playListDBN = PLAYinstr.PlayListDBN;
for ichan=1:(length(playListDBN)-1),
   ml2dama(playList(ichan,:), playListDBN(ichan));
end
   
