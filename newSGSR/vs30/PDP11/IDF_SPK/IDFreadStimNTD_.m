function indiv = IDFreadStimNTD(fid)

% function indiv = IDFreadstimNTD(fid);

% stimcmn
indiv.stimcmn.start_itd = freadVAXD(fid, 1, 'single');
indiv.stimcmn.end_itd = freadVAXD(fid, 1, 'single');
indiv.stimcmn.delta_itd = freadVAXD(fid, 1, 'single');
indiv.stimcmn.duration  = freadVAXD(fid, 1, 'single');
% stim{1..2}
for k=1:2,
   indiv.stim{k}.attn  = freadVAXD(fid, 1, 'int16');
   indiv.stim{k}.cutoff_freq  = freadVAXD(fid, 1, 'single');% (* in hz *)
   indiv.stim{k}.noise_data_set = char(freadVAXD(fid, 14, 'uchar').');
   indiv.stim{k}.file_name  = char(freadVAXD(fid, 14, 'uchar').');
   indiv.stim{k}.total_pts = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.sample_rate  = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end
