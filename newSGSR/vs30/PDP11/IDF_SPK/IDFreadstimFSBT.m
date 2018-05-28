function indiv = IDFreadstimFSBT(fid)

% function indiv = IDFreadstimFSBT(fid);

% stimcmn
indiv.stimcmn.lofreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.hifreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.deltafreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.beatfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.duration = freadVAXD(fid, 1, 'single');
% stim{1..2}
for k=1:2,
    indiv.stim{k}.spl = freadVAXD(fid, 1, 'int16');
    indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end

