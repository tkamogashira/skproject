function Nblocks = SPKwriteSeqInfo(fid, rec)

% function OK = SPKwriteSeqInfo(fid, rec);

Nblocks = 0; % only set to one after complete succes
% should be at begin of block 
if rem(ftell(fid), 256)
   error('not at begin of 256-byte block');
end

if ~isequal(rec.data_rec_kind, 2)
   error('rec not of seqInfo type')
end

% data_rec_type counts from 0 on PDP11
fwriteVAXD(fid, rec.data_rec_kind-1, 'uint8'); 
fwriteVAXD(fid, 0, 'uint8'); % alignment
fwriteVAXD(fid, rec.which_take, 'int16');
SPKwriteUETinfo(fid, rec.uet_info);
fwriteVAXD(fid, rec.num_series1, 'int16');
fwriteVAXD(fid, rec.num_series2, 'int16');
IDFwriteStimCommon(fid, rec.stim_info, 1); % last arg=1=noSkip
fwriteVAXD(fid, rec.num_stim_info_recs, 'int16');
fwriteVAXD(fid, rec.num_rep_info_recs, 'int16');
fwriteVAXD(fid, rec.islogplot, 'uint8');
fwriteVAXD(fid, 0 , 'int8'); % alignment
fwriteVAXD(fid, rec.xlow, 'single');
fwriteVAXD(fid, rec.xhigh, 'single');
SPKwriteLocation(fid,[]); % bug fix; zero-valued loc field
for ii=1:16
   SPKwriteLocation(fid, rec.chan_info(ii));
end
fwrite(fid, rec.SPS_delay, 'single');
IDFfillToNextBlock(fid); % append zeros to fill up 256 byte-block

Nblocks = 1;
