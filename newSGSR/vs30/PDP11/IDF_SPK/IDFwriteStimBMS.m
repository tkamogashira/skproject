function Pos = IDFwriteStimBMS(fid, Seq)

% function Pos = IDFwriteStimBMS(fid, Seq);

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'bms'),
   error('not an ''BMS'' stimtype');
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);

% stimcommon field
fwriteVAXD(fid, Seq.indiv.stimcmn.carrierfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.lomodfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.himodfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.deltamodfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.beatfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.duration, 'single');
% stim{1..2}
for k=1:2
   fwriteVAXD(fid, Seq.indiv.stim{k}.spl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.modpercent, 'single');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end
Pos = ftell(fid);

% source: IDFreadstimBMS