function [Active, Iwav, Irep] = RX6seqplayStatus(Chan);
% RX6seqplayStatus - current status of sequenced play over Sys3 Device
%   Returns the status of sequenced play over Sys3 Device
%   syntax: [Active, Iwav, Irep] = RX6seqplayStatus(Chan)
%
%   Active indicates if playback is active or not.
%   Iwav indicates the position in the iwave vectors in SPinfo.
%   Zero buffers are taken in account!
%
%   If no channel is given, default is 'L'.
%   In case of error, [0, 0, 0] is returned, with a warning.
%   If playback is not active, just [0, 0, 0] is returned.
%
%   Type 'help RX6seqplay' to get more detailed instructions on sequenced playback.
%
%   See also RX6SeqPlayInit, RX6SeqPlayUpload, RX6SeqPlayList, RX6SeqPlayGo, RX6SeqPlayHalt

if nargin<1, warning('No channel specified. Using ''L''.');
   Chan = 'L'; 
end

[Active, Iwav, Irep] = deal(0); % default: not playing anything we know of

SPinfo = RX6seqplayInit('status');
if isempty(SPinfo)
   warning('RX6seqplay not initialized? Try RX6seqplayInit.');
   return;
end

Going = sys3getpar('Going', SPinfo.Dev);
Tick = sys3getpar('Tick', SPinfo.Dev) - SPinfo.NmarginZeros; % Some zeros are played before actual playback

if isequal(0, Going)
   [Active, Iwav, Irep] = deal(0);
   return;
end

% if still in this function, circuit is running
Active = 1;

if isequal('init', 'SPinfo.LoadStatus') % Going should be zero though...
   [Active, Iwav, Irep] = deal(0);
   warning('No samples uploaded');
   return;
end

if isequal('upload', 'SPinfo.LoadStatus') % Going should be zero though...
   [Active, Iwav, Irep] = deal(0);
   warning('No playlist specified');
   return;
end

switch Chan
case 'L',
   if isequal( 0, SPinfo.NBuffL )
      [Active, Iwav, Irep] = deal(0);
      warning('No playlist for that channel');
      return;
   end
   
   iwave = SPinfo.iwaveL;
   nrep = SPinfo.NrepL;
   nsam = SPinfo.NsamL;
case 'R',
   if isequal( 0, SPinfo.NBuffR )
      [Active, Iwav, Irep] = deal(0);
      warning('No playlist for that channel');
      return;
   end
   
   iwave = SPinfo.iwaveR;
   nrep = SPinfo.NrepR;
   nsam = SPinfo.NsamR;
otherwise,
   error('Channel not valid');
end

 
Iwav = 0; Irep = 0; % current Wav and Rep will be stored in these variables
Count = 0;

for cWav = 1:length(iwave)
  for cRep = 1:nrep(cWav)
     PrevCount = Count;
     Count = PrevCount + nsam(iwave(cWav));
     
     if PrevCount < Tick & Tick <= Count % found position of seqplay
        Iwav = cWav; Irep = cRep;
        break;
     end
  end
  if Iwav > 0, break;end
end