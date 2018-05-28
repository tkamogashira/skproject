function indiv = IDFreadstimICI(fid, seqdate)

% function indiv = IDFreadstimICI(fid);
% date has to passed in order to check for oldstim vs newstim

newstim = ((seqdate(3)+ 0.01*seqdate(2))> 1992.091);%after Sep 1992

% stimcmn:
indiv.stimcmn.start_ici = freadVAXD(fid, 1, 'single');
indiv.stimcmn.end_ici = freadVAXD(fid, 1, 'single');
indiv.stimcmn.delta_ici = freadVAXD(fid, 1, 'single');
indiv.stimcmn.polarity = freadVAXD(fid, 1, 'uint8');
align = freadVAXD(fid, 1, 'uint8');
indiv.stimcmn.itd1 = freadVAXD(fid, 1, 'single');
indiv.stimcmn.itd2 = freadVAXD(fid, 1, 'single');
indiv.stimcmn.filter_freq = freadVAXD(fid, 2, 'single').';
indiv.stimcmn.bandwidth = freadVAXD(fid, 2, 'single').';
% stim
for k=1:2
    if ~newstim
        align = freadVAXD(fid, 4, 'single');
    end
    indiv.stim{k}.spl1 = freadVAXD(fid, 1, 'int16');
    indiv.stim{k}.spl2 = freadVAXD(fid, 1, 'int16');
    indiv.stim{k}.click_dur = freadVAXD(fid, 1, 'single');
end
