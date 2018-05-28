function indiv = IDFreadstimNSPL(fid)

% function indiv = IDFreadstimNSPL(fid);

for k=1:2,
 indiv.stim{k}.loattn = freadVAXD(fid, 1, 'int16');
 indiv.stim{k}.hiattn = freadVAXD(fid, 1, 'int16');
 indiv.stim{k}.delattn = freadVAXD(fid, 1, 'int16');
 indiv.stim{k}.cutoff_freq = freadVAXD(fid, 1, 'single');
 indiv.stim{k}.delay = freadVAXD(fid, 1, 'single');
 indiv.stim{k}.duration = freadVAXD(fid, 1, 'single');
 indiv.stim{k}.noise_data_set = char(freadVAXD(fid, 14, 'uchar').');
 indiv.stim{k}.file_name  = char(freadVAXD(fid, 14, 'uchar').');
 indiv.stim{k}.total_pts = freadVAXD(fid, 1, 'single');
 indiv.stim{k}.sample_rate  = freadVAXD(fid, 1, 'single');
 indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
 indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end; 
 indiv.noise_character = freadVAXD(fid, 2, 'uint8').';
