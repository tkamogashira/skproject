function Pos = IDFwriteStimFS(fid, Seq)

% function Pos = IDFwriteStimFS(fid);
% writes FS stimulus info to IDF file
% to IDF file.

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'fs')
   warning('not an ''FS'' stimtype');
   return
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);
% indiv.stim fields (indiv.stimcmn absent in FS stimtype)
for k=1:2
   fwriteVAXD(fid, Seq.indiv.stim{k}.spl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.lofreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.hifreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.deltafreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.modfreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.modpercent, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.delay, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.duration, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end
Pos = ftell(fid);
