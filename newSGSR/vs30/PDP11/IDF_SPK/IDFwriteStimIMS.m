function Pos = IDFwriteStimIMS(fid, Seq)

% function Pos = IDFwriteStimIMS(fid, Seq);

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'ims')
   error('not an ''IMS'' stimtype');
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);

% no stimcmn field in LMS
% stim{1..2}
for k=1:2
   fwriteVAXD(fid, Seq.indiv.stim{k}.lospl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.hispl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.deltaspl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.carrierfreq, 'single');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.lomodfreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.himodfreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.deltamodfreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.modpercent, 'single');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.delay, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.duration, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end
Pos = ftell(fid);

% source: IDFreadstimIMS