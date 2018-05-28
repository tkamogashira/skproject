function Pos = IDFwriteStimSPL(fid, Seq)

% function Pos = IDFwriteStimSPL(fid, Seq);

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'spl')
   warning('not an ''SPL'' stimtype');
   return
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);

% no stimcmn field for SPL stim type
% stim{1..2}
for k=1:2
   fwriteVAXD(fid, Seq.indiv.stim{k}.lospl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.hispl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.deltaspl, 'int16');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.freq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.modfreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.modpercent, 'single');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.delay, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.duration, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end
Pos = ftell(fid);

% source: IDFreadstimSPL