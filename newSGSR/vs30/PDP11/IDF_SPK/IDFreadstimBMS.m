function indiv = IDFreadstimBMS(fid)

% function indiv = IDFreadstimBMS(fid);

% stimcmn
indiv.stimcmn.carrierfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.lomodfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.himodfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.deltamodfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.beatfreq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.duration = freadVAXD(fid, 1, 'single');
% stim{1..2}
for k=1:2,
    indiv.stim{k}.spl = freadVAXD(fid, 1, 'int16');
    indiv.stim{k}.modpercent = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end
