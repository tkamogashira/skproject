function indiv = IDFreadstimSPL(fid)

% function indiv = IDFreadstimSPL(fid);
% stim{1..2}
for k=1:2
   indiv.stim{k}.lospl = freadVAXD(fid, 1, 'int16');
   indiv.stim{k}.hispl = freadVAXD(fid, 1, 'int16');
   indiv.stim{k}.deltaspl = freadVAXD(fid, 1, 'int16');
   indiv.stim{k}.freq = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.modfreq = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.modpercent = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.delay = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.duration = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end
