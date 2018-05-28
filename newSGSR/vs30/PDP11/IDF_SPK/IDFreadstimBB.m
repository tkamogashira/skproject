function indiv = IDFreadstimBB(fid)

% function indiv = IDFreadstimBB(fid);

% stimcmn
indiv.stimcmn.duration = freadVAXD(fid, 1, 'single');
indiv.stimcmn.carrierfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.modfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.hibeatfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.lobeatfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.deltabeatfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.beatonmod = freadVAXD(fid, 1, 'uint8');
indiv.stimcmn.var_chan = freadVAXD(fid, 1, 'uint8');
% stim{1..2}
for k=1:2
    indiv.stim{k}.spl = freadVAXD(fid, 1, 'int16');
    indiv.stim{k}.modpercent = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end
