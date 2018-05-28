function Pos = IDFwriteStimIID(fid, Seq)

% function Pos = IDFwriteStimITD(fid, Seq);

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'iid')
   warning('not an ''IID'' stimtype');
   return
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);

% stimcmn
fwriteVAXD(fid, Seq.indiv.stimcmn.meanspl, 'int16');
fwriteVAXD(fid, Seq.indiv.stimcmn.hispl, 'int16');
fwriteVAXD(fid, Seq.indiv.stimcmn.deltaspl, 'int16');
% stim{1..2}
for k=1:2
   fwriteVAXD(fid, Seq.indiv.stim{k}.freq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.modfreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.modpercent, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.delay, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.duration, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end
Pos = ftell(fid);

% source: IDFreadstimIID