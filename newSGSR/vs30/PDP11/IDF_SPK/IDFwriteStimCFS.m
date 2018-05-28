function Pos = IDFwriteStimCFS(fid, Seq)

% function Pos = IDFwriteStimCFS(fid);
% writes CFS stimulus info to IDF file

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'cfs')
   error('not an ''CFS'' stimtype');
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);
% indiv.stimcmn field
fwriteVAXD(fid, Seq.indiv.stimcmn.polarity, 'uint8');
ALIGN = 0;
fwriteVAXD(fid, ALIGN, 'uint8');
% indiv.stim fields 
for k=1:2,
   fwriteVAXD(fid, Seq.indiv.stim{k}.spl, 'int16');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.lofreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.hifreq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.deltafreq, 'single');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.click_dur, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.delay, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.burst_duration, 'single');
end
Pos = ftell(fid);
