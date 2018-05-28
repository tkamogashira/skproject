function indiv = IDFreadstimCFS(fid)

% function indiv = IDFreadstimCFS(fid);

% stimcmn
indiv.stimcmn.polarity = freadVAXD(fid, 1, 'uint8');
align = freadVAXD(fid, 1, 'uint8');
% stim{1..2}
for k=1:2,
   indiv.stim{k}.spl = freadVAXD(fid, 1, 'int16');
   indiv.stim{k}.lofreq = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.hifreq = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.deltafreq = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.click_dur = freadVAXD(fid, 1, 'single');% {in microseconds}
   indiv.stim{k}.delay = freadVAXD(fid, 1, 'single');
   indiv.stim{k}.burst_duration = freadVAXD(fid, 1, 'single');
end
