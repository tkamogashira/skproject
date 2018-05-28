function indiv = IDFreadstimITD(fid)

% function indiv = IDFreadstimITD(fid);

% stimcmn
indiv.stimcmn.incr_per_cycle = freadVAXD(fid, 1, 'int16');
indiv.stimcmn.numcycles = freadVAXD(fid, 1, 'int16');
indiv.stimcmn.leadchan = freadVAXD(fid, 1, 'uint8');
indiv.stimcmn.delayonmod = freadVAXD(fid, 1, 'uint8');
indiv.stimcmn.phasecomp = freadVAXD(fid, 1, 'uint8');
align=freadVAXD(fid, 1, 'uint8');

indiv.stimcmn.duration = freadVAXD(fid, 1, 'single');
% stim{1..2}
for k=1:2
indiv.stim{k}.spl = freadVAXD(fid, 1, 'int16');
indiv.stim{k}.freq = freadVAXD(fid, 1, 'single');
indiv.stim{k}.modfreq = freadVAXD(fid, 1, 'single');
indiv.stim{k}.modpercent = freadVAXD(fid, 1, 'single');
indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end;

