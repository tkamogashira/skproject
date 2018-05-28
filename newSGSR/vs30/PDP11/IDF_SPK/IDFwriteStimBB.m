function Pos = IDFwriteStimBB(fid, Seq)

% function Pos = IDFwriteStimLMS(fid, Seq);

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'bb')
   error('not an ''BB'' stimtype');
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);

% stimcmn
fwriteVAXD(fid, Seq.indiv.stimcmn.duration, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.carrierfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.modfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.hibeatfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.lobeatfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.deltabeatfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.beatonmod, 'int8');
fwriteVAXD(fid, Seq.indiv.stimcmn.var_chan, 'int8');
% stim{1..2}
for k=1:2
   fwriteVAXD(fid, Seq.indiv.stim{k}.spl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.modpercent, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end;
Pos = ftell(fid);
% source: IDFreadstimBB
