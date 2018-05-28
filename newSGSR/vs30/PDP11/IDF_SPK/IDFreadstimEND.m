function indiv = IDFreadstimEND(fid)

% function indiv = IDFreadstimEND(fid);

% stim{1..2}
for k=1:2
    indiv.stim{k}.start_itd = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.end_itd = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.delta_itd = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.attn  = freadVAXD(fid, 1, 'int16');
    indiv.stim{k}.band_width = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.center_fq  = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.cutoff_freq  = freadVAXD(fid, 1, 'single'); % (* in hz *)
    indiv.stim{k}.bandpass_noise_set = freadVAXD(fid, 14, 'uchar');
    indiv.stim{k}.file_name  = freadVAXD(fid, 14, 'uchar');
    indiv.stim{k}.total_pts = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.sample_rate  = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.duration  = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end
