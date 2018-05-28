function Pos = IDFwriteStimCTD(fid, Seq)

% function Pos = IDFwriteStimCTD(fid, Seq);

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'ctd')
   error('not an ''CTD'' stimtype');
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);

% stimcmn
fwriteVAXD(fid, Seq.indiv.stimcmn.start_itd, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.end_itd, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.delta_itd, 'single');

fwriteVAXD(fid, Seq.indiv.stimcmn.polarity, 'uint8');
Align = 0;
fwriteVAXD(fid, Align, 'uint8');

fwriteVAXD(fid, Seq.indiv.stimcmn.filter_freq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.bandwidth, 'single');

% stim{1..2}
for k=1:2
   fwriteVAXD(fid, Seq.indiv.stim{k}.spl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.click_dur, 'single');
end
Pos = ftell(fid);
