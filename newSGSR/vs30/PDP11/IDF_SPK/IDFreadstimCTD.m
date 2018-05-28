function indiv = IDFreadstimCTD(fid)

% function indiv = IDFreadstimCTD(fid);

% stimcmn
indiv.stimcmn.start_itd = freadVAXD(fid, 1, 'single');
indiv.stimcmn.end_itd = freadVAXD(fid, 1, 'single');
indiv.stimcmn.delta_itd = freadVAXD(fid, 1, 'single');
indiv.stimcmn.polarity = freadVAXD(fid, 1, 'uint8');
align = freadVAXD(fid, 1, 'uint8');
indiv.stimcmn.filter_freq = freadVAXD(fid, 1, 'single');
indiv.stimcmn.bandwidth = freadVAXD(fid, 1, 'single');
% stim{1..2}
for k=1:2
   indiv.stim{k}.spl = freadVAXD(fid, 1, 'int16');
   indiv.stim{k}.click_dur = freadVAXD(fid, 1, 'single');% {in microseconds}
end
