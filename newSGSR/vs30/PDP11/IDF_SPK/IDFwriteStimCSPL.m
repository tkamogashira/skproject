function Pos = IDFwriteStimCSPL(fid, Seq)

% function Pos = IDFwriteStimCFS(fid);
% writes CFS stimulus info to IDF file

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'cspl')
   error('not an ''CSPL'' stimtype');
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);
% indiv.stimcmn field
fwriteVAXD(fid, Seq.indiv.stimcmn.polarity, 'uint8');
ALIGN = 0;
fwriteVAXD(fid, ALIGN, 'uint8');

% indiv.stim fields 
for k=1:2,
   fwriteVAXD(fid, Seq.indiv.stim{k}.loattn, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.hiattn, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.deltaattn, 'int16');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.freq, 'single');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.click_dur, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.delay, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.burst_duration, 'single');
end
Pos = ftell(fid);
