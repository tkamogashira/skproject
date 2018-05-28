function Pos = IDFwriteStimFM(fid, Seq)

% function Pos = IDFwriteStimFM(fid);
% writes FM stimulus info to IDF file
% to IDF file.

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'fm')
   error('not an ''FS'' stimtype');
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);
% indiv.stim fields (indiv.stimcmn absent in FS stimtype)
for k=1:2
   fwriteVAXD(fid, Seq.indiv.stim{k}.spl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fmcarrlo, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fmcarrhi, 'single');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.sweepup, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.sweepdown, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.sweephold, 'single');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.delay, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end
Pos = ftell(fid);
