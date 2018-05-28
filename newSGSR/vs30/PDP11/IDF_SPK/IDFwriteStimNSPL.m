function Pos = IDFwriteStimNSPL(fid, Seq)


if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'nspl')
   warning('not an ''NSPL'' stimtype');
   return
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);

% no stimcmn field for NSPL stim type
 
for k=1:2
   fwriteVAXD(fid, Seq.indiv.stim{k}.loattn, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.hiattn, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.delattn, 'int16');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.cutoff_freq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.delay, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.duration, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.noise_data_set, 'uchar');
   fwriteVAXD(fid, Seq.indiv.stim{k}.file_name, 'uchar');
   fwriteVAXD(fid, Seq.indiv.stim{k}.total_pts, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.sample_rate, 'single');
   
   fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end

fwriteVAXD(fid, Seq.indiv.noise_character, 'uint8');
Pos = ftell(fid);

% source: IDFreadstimNSPL