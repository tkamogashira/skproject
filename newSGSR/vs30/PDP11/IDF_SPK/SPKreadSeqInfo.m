function rec = SPKreadSeqInfo(fid)

% function rec = SPKreadSeqInfo(fid);
noReset = 1; % prevent idfReadStimCommon from resetting file pos

rec.data_rec_kind = 2; % seq_info_record
rec.which_take = freadVAXD(fid, 1, 'int16');
rec.uet_info = SPKreadUETinfo(fid);
rec.num_series1 = freadVAXD(fid, 1, 'int16');
rec.num_series2 = freadVAXD(fid, 1, 'int16');
rec.stim_info = IDFreadstimcommon(fid,noReset);
rec.num_stim_info_recs = freadVAXD(fid, 1, 'int16');
rec.num_rep_info_recs = freadVAXD(fid, 1, 'int16');
rec.islogplot = freadVAXD(fid, 1, 'uint8');
alignment = freadVAXD(fid, 1, 'int8'); % check!
rec.xlow = freadVAXD(fid, 1, 'single');
rec.xhigh = freadVAXD(fid, 1, 'single');
rec.dummy = SPKreadlocation(fid);
for ii=1:16
   rec.chan_info(ii) = SPKreadlocation(fid);
end
rec.SPS_delay = freadVAXD(fid, 1, 'single');
