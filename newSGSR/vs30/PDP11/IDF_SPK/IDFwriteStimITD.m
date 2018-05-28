function Pos = IDFwriteStimITD(fid, Seq)

% function Pos = IDFwriteStimITD(fid, Seq);

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'itd')
   warning('not an ''ITD'' stimtype');
   return
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);

% stimcmn
fwriteVAXD(fid, Seq.indiv.stimcmn.incr_per_cycle, 'int16');
fwriteVAXD(fid, Seq.indiv.stimcmn.numcycles, 'int16');
fwriteVAXD(fid, Seq.indiv.stimcmn.leadchan, 'uint8');
fwriteVAXD(fid, Seq.indiv.stimcmn.delayonmod, 'uint8');
fwriteVAXD(fid, Seq.indiv.stimcmn.phasecomp, 'uint8');
fwriteVAXD(fid, 0, 'uint8'); % alignment byte
fwriteVAXD(fid, Seq.indiv.stimcmn.duration, 'single');
% stim{1..2}
for k=1:2
fwriteVAXD(fid, Seq.indiv.stim{k}.spl, 'int16');
fwriteVAXD(fid, Seq.indiv.stim{k}.freq, 'single');
fwriteVAXD(fid, Seq.indiv.stim{k}.modfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stim{k}.modpercent, 'single');
fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end
Pos = ftell(fid);
