function indiv = IDFreadStimLMS_(fid)

% function indiv = IDFreadstimLMS(fid);

% stim{1..2}
for k=1:2,
   indiv.stim{k}.spl = freadVAXD(fid, 1, 'int16');
   indiv.stim{k}.carrierfreq = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.lomodfreq = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.himodfreq = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.deltamodfreq = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.modpercent = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.delay = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.duration = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end
