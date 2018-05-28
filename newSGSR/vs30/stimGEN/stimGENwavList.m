function BufDBNs = stimgenwavList(wf, storage);

% STIMGENwavList -  computes (realizes) wavList waveform XXX throwing away samples stinks
% SYNTAX:
% function BufDBNs = stimgenWavList(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.



stype = wf.GENdata.storage;

if isequal(stype,'WAVdata'),
   global WAVdata
   iWav = wf.GENdata.iwav;
   iWavCh = min(wf.GENdata.iwavchan, size(WAVdata{iWav}.waveform,2)); % other chan may have been removed
   ScaleFactor = wf.GENdata.scalor;
   % store samples in single row vector
   BufDBNs = StoreSamples(ScaleFactor*WAVdata{iWav}.waveform(:,iWavCh).',storage);
   % now that they have been stored, they can be removed from global WAVdata
   % WAVdata{iWav}.waveform(:,iWavCh) = [];
else,
   error(['unknown storage type ''' stype '''']);
end



