function indiv = IDFreadstimIID(fid)

% function indiv = IDFreadstimIID(fid);

% stimcmn
indiv.stimcmn.meanspl = freadVAXD(fid, 1, 'int16');
indiv.stimcmn.hispl = freadVAXD(fid, 1, 'int16');
indiv.stimcmn.deltaspl = freadVAXD(fid, 1, 'int16');
% stim{1..2}
for k=1:2
    indiv.stim{k}.freq = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.modfreq = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.modpercent = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.delay = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.duration = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end
