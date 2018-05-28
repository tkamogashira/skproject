function indiv = IDFreadstimFS(fid)

% function indiv = IDFreadstimFS(fid);

%stim{1..2}
for k=1:2,
    indiv.stim{k}.spl = freadVAXD(fid, 1, 'int16');
    indiv.stim{k}.lofreq = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.hifreq = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.deltafreq = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.modfreq = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.modpercent = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.delay = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.duration = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end
