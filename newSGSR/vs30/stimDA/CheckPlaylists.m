function y=CheckPlaylists;
% CheckPlaylists - debug function; checks if the # samples in the seqlist of PRPinstr are correct

global PRPinstr
N = length(PRPinstr.PLAY);
for iplay=1:N,
   Nplay = PRPinstr.PLAY(iplay).Nplay
   % collect all DBNs in playlist
   PL = PRPinstr.PLAY(iplay).playList;
   DBNs = PL(:,1:2:(end-1)); % odd columns are dbns
   REPs = PL(:,2:2:end); % even columns are # reps
   nchan = size(PL,1); % number of D/A channels
   DBNsizes = DBNs*0;
   for ichan=1:nchan
      dd = DBNs(ichan,:);
      NN = length(dd);
      [anc, isnew] = firstIndexWithValue(dd);
      for ii=1:NN,
         if isnew(ii),
            DBNsizes(ichan,ii) = local_DBNsize(dd(ii));
         else, % copy from previous, identical, one
            DBNsizes(ichan,ii) = DBNsizes(ichan,anc(ii));
         end
      end
   end
   TotNsam = sum((DBNsizes.*REPs).')
end % for iplay


%--------------------locals-------
function S = local_DBNsize(dbn);
global SampleLib
if dbn==0, S=0;
elseif dbn>0, S = length(Dama2ML(dbn));
else, S = length(SampleLib.cell{-dbn});
end
